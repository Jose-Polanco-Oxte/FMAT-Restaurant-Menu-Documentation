#requires -Version 7.0

param(
    [string]$Request,
    [string[]]$RequestFile,

    [switch]$Resume,
    [string]$ResumeRunId,

    [ValidateSet("Auto", "Analyst", "Editor", "Auditor")]
    [string]$ResumeFrom = "Auto",

    [ValidateRange(1, 10)]
    [int]$MaxRounds = 5,

    # Automatic retries for each individual Editor target.
    [ValidateRange(1, 5)]
    [int]$EditorRetryLimit = 3,

    # Optional HARD write boundary.
    #
    # Exact file:
    #   -WriteScope "docs/md/spec.md"
    #
    # Directory prefix:
    #   -WriteScope "docs/md/","output/interfaces/"
    #
    # VERIFY may read outside this scope.
    # CREATE/MODIFY/DELETE may not.
    [string[]]$WriteScope,

    [string]$BaselineRef = "HEAD",

    # A V5.2 run always starts from the committed baseline.
    # This switch only suppresses the safety refusal when main contains
    # non-workflow uncommitted documentation/application changes.
    [switch]$AllowDirtyBaseline,

    # PASS normally leaves main untouched and exports approved.patch.
    [switch]$ApplyOnPass,

    [switch]$CleanupWorktreeOnPass,

    [switch]$ForceNewRun
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $Utf8NoBom
$OutputEncoding = $Utf8NoBom

# ============================================================
# CONFIG
# ============================================================

$AnalystModel = "gpt-5.6-sol"
$AnalystReasoning = "high"

$EditorModel = "gemini-3.8-flash-high"

$AuditorModel = "gpt-5.6-luna"
$AuditorReasoning = "max"

$EditorProfileIdentifier = "DOCUMENTATION_EDITOR_V5_2"

# ============================================================
# PATHS
# ============================================================

$Root = [System.IO.Path]::GetFullPath(
    (Split-Path -Parent $PSScriptRoot)
)

$Current = Join-Path $Root ".ai\current"
$Runs = Join-Path $Root ".ai\runs"

$RequestPath = Join-Path $Current "request.md"
$PlanPath = Join-Path $Current "plan.json"
$ExecutionPath = Join-Path $Current "execution.json"
$ChangesPath = Join-Path $Current "changes.patch"
$AuditPath = Join-Path $Current "audit.json"
$StatePath = Join-Path $Current "state.json"
$ApprovedPatchPath = Join-Path $Current "approved.patch"
$EditorFeedbackPath = Join-Path $Current "editor-feedback.json"
$EditorTaskPath = Join-Path $Current "editor-task.md"

$AgentsPath = Join-Path $Root "AGENTS.md"
$AnalystPromptPath = Join-Path $Root ".ai\prompts\analyst.md"
$AuditorPromptPath = Join-Path $Root ".ai\prompts\auditor.md"

$IntegrationSchemaPath = Join-Path $Root ".ai\schemas\integration-plan.schema.json"
$ExecutionSchemaPath = Join-Path $Root ".ai\schemas\execution-report.schema.json"
$AuditSchemaPath = Join-Path $Root ".ai\schemas\audit-report.schema.json"

$EditorAgentPath = Join-Path $Root ".agents\agents\documentation-editor\agent.md"

# ============================================================
# BASIC HELPERS
# ============================================================

function Assert-CommandExists {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command was not found in PATH: $Name"
    }
}

function Get-CommandPath {
    param([Parameter(Mandatory = $true)][string]$Name)

    $Command = Get-Command $Name -ErrorAction Stop

    if (-not [string]::IsNullOrWhiteSpace([string]$Command.Source)) {
        return [string]$Command.Source
    }

    if (-not [string]::IsNullOrWhiteSpace([string]$Command.Path)) {
        return [string]$Command.Path
    }

    throw "Could not resolve executable path for: $Name"
}

function Assert-FileExists {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Description
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Description not found: $Path"
    }
}

function Test-JsonProperty {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    return $null -ne $Object.PSObject.Properties[$Name]
}

function Try-ReadJsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }

    try {
        $Raw = Get-Content `
            -LiteralPath $Path `
            -Raw `
            -Encoding utf8 `
            -ErrorAction Stop

        if ([string]::IsNullOrWhiteSpace($Raw)) {
            return $null
        }

        return ($Raw | ConvertFrom-Json -ErrorAction Stop)
    }
    catch {
        return $null
    }
}

function Read-JsonFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Description
    )

    try {
        return (
            Get-Content `
                -LiteralPath $Path `
                -Raw `
                -Encoding utf8 `
                -ErrorAction Stop |
            ConvertFrom-Json `
                -ErrorAction Stop
        )
    }
    catch {
        throw "Invalid JSON in $Description`: $Path`n$($_.Exception.Message)"
    }
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)]$Value,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $Parent = Split-Path -Parent $Path

    if (-not [string]::IsNullOrWhiteSpace($Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }

    $Value |
        ConvertTo-Json -Depth 100 |
        Set-Content `
            -LiteralPath $Path `
            -Encoding utf8
}

function Format-Duration {
    param([Parameter(Mandatory = $true)][TimeSpan]$Elapsed)

    if ($Elapsed.TotalHours -ge 1) {
        return "{0:0.0}h" -f $Elapsed.TotalHours
    }

    if ($Elapsed.TotalMinutes -ge 1) {
        return "{0:0.0}m" -f $Elapsed.TotalMinutes
    }

    return "{0:0}s" -f $Elapsed.TotalSeconds
}

function Normalize-RepoPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $Value = ($Path -replace '\\', '/').Trim()

    while ($Value.StartsWith("./")) {
        $Value = $Value.Substring(2)
    }

    return $Value.TrimStart('/')
}

function Assert-SafeRepoRelativePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "Repository path may not be empty."
    }

    if ([System.IO.Path]::IsPathRooted($Path)) {
        throw "Absolute paths are not allowed in affected_files: $Path"
    }

    $Normalized = Normalize-RepoPath $Path

    if (
        $Normalized -match '(^|/)\.\.(/|$)' -or
        $Normalized -match '[\*\?\[\]]'
    ) {
        throw "Unsafe or wildcard repository path is not allowed: $Path"
    }

    return $Normalized
}

function Convert-ToAbsoluteRepoPath {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $Normalized = Assert-SafeRepoRelativePath $RelativePath

    $Absolute = [System.IO.Path]::GetFullPath(
        (Join-Path $RepoRoot ($Normalized -replace '/', '\'))
    )

    $RepoFull = [System.IO.Path]::GetFullPath($RepoRoot)

    $Prefix = $RepoFull.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    ) + [System.IO.Path]::DirectorySeparatorChar

    if (
        -not $Absolute.StartsWith(
            $Prefix,
            [System.StringComparison]::OrdinalIgnoreCase
        )
    ) {
        throw "Path escapes repository root: $RelativePath"
    }

    return $Absolute
}

function Test-ProtectedPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $P = Normalize-RepoPath $Path

    if (
        $P.Equals(
            "AGENTS.md",
            [System.StringComparison]::OrdinalIgnoreCase
        ) -or
        $P.Equals(
            ".gitignore",
            [System.StringComparison]::OrdinalIgnoreCase
        )
    ) {
        return $true
    }

    foreach ($Prefix in @(
        ".ai/",
        ".agents/",
        "scripts/"
    )) {
        if (
            $P.StartsWith(
                $Prefix,
                [System.StringComparison]::OrdinalIgnoreCase
            )
        ) {
            return $true
        }
    }

    return $false
}

function Normalize-WriteScopes {
    param([string[]]$Scopes)

    $Result = @()

    foreach ($Scope in @($Scopes)) {
        if ([string]::IsNullOrWhiteSpace($Scope)) {
            continue
        }

        $Raw = ($Scope -replace '\\', '/').Trim()
        $DirectoryScope = $Raw.EndsWith("/")

        $Normalized = Assert-SafeRepoRelativePath $Raw

        if ($DirectoryScope) {
            $Normalized = $Normalized.TrimEnd('/') + '/'
        }

        if (Test-ProtectedPath $Normalized) {
            throw "WriteScope may not target workflow infrastructure: $Scope"
        }

        $Result += $Normalized
    }

    return @($Result | Sort-Object -Unique)
}

function Test-PathInWriteScope {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [string[]]$Scopes
    )

    if (@($Scopes).Count -eq 0) {
        return $true
    }

    $P = Normalize-RepoPath $Path

    foreach ($Scope in @($Scopes)) {
        if ($Scope.EndsWith("/")) {
            if (
                $P.StartsWith(
                    $Scope,
                    [System.StringComparison]::OrdinalIgnoreCase
                )
            ) {
                return $true
            }
        }
        elseif (
            $P.Equals(
                $Scope,
                [System.StringComparison]::OrdinalIgnoreCase
            )
        ) {
            return $true
        }
    }

    return $false
}

function Invoke-CapturedProcess {
    param(
        [Parameter(Mandatory = $true)][string]$FileName,
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [Parameter(Mandatory = $true)][string]$Activity,
        [ValidateRange(10, 600)][int]$HeartbeatSeconds = 60
    )

    $StartInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $StartInfo.FileName = $FileName
    $StartInfo.WorkingDirectory = $WorkingDirectory
    $StartInfo.UseShellExecute = $false
    $StartInfo.RedirectStandardOutput = $true
    $StartInfo.RedirectStandardError = $true
    $StartInfo.CreateNoWindow = $true
    $StartInfo.StandardOutputEncoding = $Utf8NoBom
    $StartInfo.StandardErrorEncoding = $Utf8NoBom

    foreach ($Argument in $Arguments) {
        [void]$StartInfo.ArgumentList.Add([string]$Argument)
    }

    $Process = [System.Diagnostics.Process]::new()
    $Process.StartInfo = $StartInfo

    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        if (-not $Process.Start()) {
            throw "Failed to start process: $FileName"
        }

        $StdoutTask = $Process.StandardOutput.ReadToEndAsync()
        $StderrTask = $Process.StandardError.ReadToEndAsync()

        while (-not $Process.WaitForExit($HeartbeatSeconds * 1000)) {
            Write-Host (
                "    still running... {0}" -f
                (Format-Duration -Elapsed $Stopwatch.Elapsed)
            )
        }

        $Process.WaitForExit()

        $Stdout = $StdoutTask.GetAwaiter().GetResult()
        $Stderr = $StderrTask.GetAwaiter().GetResult()
        $ExitCode = $Process.ExitCode
    }
    finally {
        $Stopwatch.Stop()
        $Process.Dispose()
    }

    return [pscustomobject]@{
        ExitCode = $ExitCode
        Stdout = $Stdout
        Stderr = $Stderr
        Elapsed = $Stopwatch.Elapsed
        Activity = $Activity
    }
}

function Throw-ProcessFailure {
    param(
        [Parameter(Mandatory = $true)]$Result,
        [Parameter(Mandatory = $true)][string]$StageName
    )

    $Details = if (
        -not [string]::IsNullOrWhiteSpace([string]$Result.Stderr)
    ) {
        [string]$Result.Stderr
    }
    elseif (
        -not [string]::IsNullOrWhiteSpace([string]$Result.Stdout)
    ) {
        [string]$Result.Stdout
    }
    else {
        "(no process output)"
    }

    throw @"
$StageName failed with exit code $($Result.ExitCode).

$Details
"@
}

# ============================================================
# GIT / ISOLATED WORKTREE
# ============================================================

function Get-GitRoot {
    $Raw = & git -C "$Root" rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -ne 0) {
        throw "Workflow root is not a Git repository: $Root"
    }

    return [System.IO.Path]::GetFullPath(
        ($Raw | Select-Object -First 1).Trim()
    )
}

function Get-GitCommit {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Ref
    )

    $Raw = & git -C "$RepoRoot" rev-parse "$Ref^{commit}" 2>$null

    if ($LASTEXITCODE -ne 0) {
        throw "Could not resolve Git ref '$Ref' in $RepoRoot"
    }

    return ($Raw | Select-Object -First 1).Trim()
}

function Assert-MainBaselineClean {
    if ($AllowDirtyBaseline) {
        Write-Host (
            "WARNING: dirty baseline allowed; isolated run still starts from committed '{0}'." -f
            $BaselineRef
        )
        return
    }

    $Dirty = @(
        & git -C "$Root" status `
            --porcelain `
            --untracked-files=all `
            -- `
            . `
            ':(exclude).ai/**' `
            ':(exclude).agents/**' `
            ':(exclude)scripts/**' `
            ':(exclude)AGENTS.md' `
            ':(exclude).gitignore' `
            2>$null |
        Where-Object { $_ }
    )

    if (@($Dirty).Count -gt 0) {
        $Preview = ($Dirty | Select-Object -First 20) -join "`n"

        throw @"
The main repository contains non-workflow uncommitted changes.

Preserve or clean those changes first, or intentionally use:
  -AllowDirtyBaseline

The isolated V5.2 run still starts from the committed baseline.

Detected:
$Preview
"@
    }
}

function New-IsolatedWorktree {
    param(
        [Parameter(Mandatory = $true)][string]$RunId,
        [Parameter(Mandatory = $true)][string]$Commit
    )

    $RepoName = Split-Path -Leaf $Root
    $Base = Join-Path $env:TEMP "docflow-worktrees"

    New-Item -ItemType Directory -Force -Path $Base | Out-Null

    $Worktree = Join-Path $Base "$RepoName-$RunId"

    if (Test-Path -LiteralPath $Worktree) {
        if (-not $ForceNewRun) {
            throw "Worktree path already exists: $Worktree"
        }

        & git -C "$Root" worktree remove --force "$Worktree" 2>$null | Out-Null
        Remove-Item `
            -LiteralPath $Worktree `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }

    & git -C "$Root" worktree add --detach "$Worktree" "$Commit" 2>&1 | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Could not create isolated Git worktree: $Worktree"
    }

    return [System.IO.Path]::GetFullPath($Worktree)
}

function Assert-WorktreeAvailable {
    param([Parameter(Mandatory = $true)][string]$Worktree)

    if (-not (Test-Path -LiteralPath $Worktree -PathType Container)) {
        throw @"
The isolated worktree no longer exists:
$Worktree

This candidate cannot be resumed safely.
Start a new V5.1 run from a committed baseline.
"@
    }

    $Inside = & git -C "$Worktree" rev-parse --is-inside-work-tree 2>$null

    if (
        $LASTEXITCODE -ne 0 -or
        ($Inside | Select-Object -First 1).Trim() -ne "true"
    ) {
        throw "Path is not a valid Git worktree: $Worktree"
    }
}

function Remove-IsolatedWorktree {
    param([Parameter(Mandatory = $true)][string]$Worktree)

    & git -C "$Root" worktree remove --force "$Worktree" 2>$null | Out-Null

    if (Test-Path -LiteralPath $Worktree) {
        Remove-Item `
            -LiteralPath $Worktree `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }

    & git -C "$Root" worktree prune 2>$null | Out-Null
}

function New-CandidateCheckpoint {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$Message
    )

    # Stage the complete isolated candidate first. Avoid exclude pathspec magic
    # here: on the harness control path we prefer the most portable Git command
    # possible, then explicitly unstage runtime-only directories.
    $StageOutput = @(
        & git -C "$Worktree" add -A -- . 2>&1
    )
    $StageExitCode = $LASTEXITCODE

    if ($StageExitCode -ne 0) {
        $Details = ($StageOutput | ForEach-Object { [string]$_ }) -join "`n"

        throw @"
Could not stage isolated candidate checkpoint.

Git command:
  git -C <candidate> add -A -- .

Git exit code: $StageExitCode
Git output:
$Details
"@
    }

    # Runtime state must never become part of an internal candidate commit.
    # `git reset -- <paths>` only resets the index for those paths; it leaves
    # the working-tree files intact for the agents to read.
    $UnstageOutput = @(
        & git -C "$Worktree" reset -q HEAD -- ".ai/current" ".ai/runs" 2>&1
    )
    $UnstageExitCode = $LASTEXITCODE

    if ($UnstageExitCode -ne 0) {
        $Details = ($UnstageOutput | ForEach-Object { [string]$_ }) -join "`n"

        throw @"
Could not exclude runtime control state from the isolated checkpoint.

Git command:
  git -C <candidate> reset -q HEAD -- .ai/current .ai/runs

Git exit code: $UnstageExitCode
Git output:
$Details
"@
    }

    $CommitOutput = @(
        & git -C "$Worktree" `
            -c user.name="Docflow Harness" `
            -c user.email="docflow@local.invalid" `
            commit `
            --allow-empty `
            -m "$Message" `
            2>&1
    )
    $CommitExitCode = $LASTEXITCODE

    if ($CommitExitCode -ne 0) {
        $Details = ($CommitOutput | ForEach-Object { [string]$_ }) -join "`n"

        throw @"
Could not create isolated candidate checkpoint.

Git exit code: $CommitExitCode
Git output:
$Details
"@
    }

    return Get-GitCommit -RepoRoot $Worktree -Ref "HEAD"
}

function Restore-CandidateCheckpoint {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$Checkpoint
    )

    & git -C "$Worktree" reset --hard "$Checkpoint" 2>$null | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Could not reset isolated worktree to checkpoint."
    }

    & git -C "$Worktree" clean -fdx 2>$null | Out-Null
}

function Get-DeltaPaths {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$Checkpoint
    )

    $Tracked = @(
        & git -C "$Worktree" diff `
            --name-only `
            "$Checkpoint" `
            -- `
            . `
            2>$null |
        Where-Object { $_ }
    )

    $Untracked = @(
        & git -C "$Worktree" ls-files `
            --others `
            --exclude-standard `
            2>$null |
        Where-Object { $_ }
    )

    return @(
        @($Tracked) + @($Untracked) |
        ForEach-Object { Normalize-RepoPath $_ } |
        Sort-Object -Unique
    )
}

function Get-CumulativeCandidatePaths {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$BaselineCommit,
        [Parameter(Mandatory = $true)][string]$CandidateCommit
    )

    $Changed = @(
        & git -C "$Worktree" diff `
            --name-only `
            "$BaselineCommit" `
            "$CandidateCommit" `
            -- `
            . `
            2>$null |
        Where-Object { $_ }
    )

    return @(
        $Changed |
        ForEach-Object { Normalize-RepoPath $_ } |
        Where-Object { -not (Test-ProtectedPath $_) } |
        Sort-Object -Unique
    )
}

# ============================================================
# CONTROL PLANE SYNC
# ============================================================

function Copy-ControlFile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        return
    }

    $Parent = Split-Path -Parent $Destination

    if (-not [string]::IsNullOrWhiteSpace($Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }

    Copy-Item `
        -LiteralPath $Source `
        -Destination $Destination `
        -Force
}

function Sync-ControlPlaneToWorktree {
    param([Parameter(Mandatory = $true)][string]$Worktree)

    $Pairs = @(
        @($AgentsPath, (Join-Path $Worktree "AGENTS.md")),
        @(
            $EditorAgentPath,
            (Join-Path $Worktree ".agents\agents\documentation-editor\agent.md")
        ),
        @(
            $AnalystPromptPath,
            (Join-Path $Worktree ".ai\prompts\analyst.md")
        ),
        @(
            $AuditorPromptPath,
            (Join-Path $Worktree ".ai\prompts\auditor.md")
        ),
        @(
            $IntegrationSchemaPath,
            (Join-Path $Worktree ".ai\schemas\integration-plan.schema.json")
        ),
        @(
            $ExecutionSchemaPath,
            (Join-Path $Worktree ".ai\schemas\execution-report.schema.json")
        ),
        @(
            $AuditSchemaPath,
            (Join-Path $Worktree ".ai\schemas\audit-report.schema.json")
        )
    )

    foreach ($Pair in $Pairs) {
        Copy-ControlFile -Source $Pair[0] -Destination $Pair[1]
    }

    foreach ($Name in @(
        "request.md",
        "plan.json",
        "execution.json",
        "changes.patch",
        "audit.json",
        "editor-feedback.json",
        "editor-task.md"
    )) {
        Copy-ControlFile `
            -Source (Join-Path $Current $Name) `
            -Destination (Join-Path $Worktree ".ai\current\$Name")
    }
}

function Sync-ArtifactToWorktree {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$Name
    )

    Copy-ControlFile `
        -Source (Join-Path $Current $Name) `
        -Destination (Join-Path $Worktree ".ai\current\$Name")
}

function Get-ProtectedControlSnapshot {
    param([Parameter(Mandatory = $true)][string]$Worktree)

    $Map = [ordered]@{}

    function Add-SnapshotFile {
        param([Parameter(Mandatory = $true)][string]$FilePath)

        if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
            return
        }

        $Relative = Normalize-RepoPath(
            [System.IO.Path]::GetRelativePath(
                $Worktree,
                $FilePath
            )
        )

        $Map[$Relative] = (
            Get-FileHash `
                -LiteralPath $FilePath `
                -Algorithm SHA256
        ).Hash
    }

    function Add-SnapshotTree {
        param([Parameter(Mandatory = $true)][string]$TreePath)

        if (-not (Test-Path -LiteralPath $TreePath -PathType Container)) {
            return
        }

        foreach ($File in Get-ChildItem -LiteralPath $TreePath -Recurse -File) {
            Add-SnapshotFile -FilePath $File.FullName
        }
    }

    Add-SnapshotFile -FilePath (Join-Path $Worktree "AGENTS.md")
    Add-SnapshotFile -FilePath (Join-Path $Worktree ".gitignore")
    Add-SnapshotTree -TreePath (Join-Path $Worktree ".agents")
    Add-SnapshotTree -TreePath (Join-Path $Worktree "scripts")

    # Snapshot all .ai content except .ai/runs. This keeps state small while
    # still detecting an Editor that creates or edits protected control files.
    $AiRoot = Join-Path $Worktree ".ai"

    if (Test-Path -LiteralPath $AiRoot -PathType Container) {
        foreach ($File in Get-ChildItem -LiteralPath $AiRoot -File) {
            Add-SnapshotFile -FilePath $File.FullName
        }

        foreach ($Directory in Get-ChildItem -LiteralPath $AiRoot -Directory) {
            if (
                $Directory.Name.Equals(
                    "runs",
                    [System.StringComparison]::OrdinalIgnoreCase
                )
            ) {
                continue
            }

            Add-SnapshotTree -TreePath $Directory.FullName
        }
    }

    return [pscustomobject]$Map
}

function Compare-ProtectedControlSnapshot {
    param(
        [Parameter(Mandatory = $true)]$Before,
        [Parameter(Mandatory = $true)]$After
    )

    $Names = @(
        @($Before.PSObject.Properties.Name) +
        @($After.PSObject.Properties.Name) |
        Sort-Object -Unique
    )

    $Changed = @()

    foreach ($Name in $Names) {
        $BeforeProperty = $Before.PSObject.Properties[$Name]
        $AfterProperty = $After.PSObject.Properties[$Name]

        $BeforeValue = if ($null -eq $BeforeProperty) {
            "__MISSING__"
        }
        else {
            [string]$BeforeProperty.Value
        }

        $AfterValue = if ($null -eq $AfterProperty) {
            "__MISSING__"
        }
        else {
            [string]$AfterProperty.Value
        }

        if ($BeforeValue -ne $AfterValue) {
            $Changed += $Name
        }
    }

    return @($Changed | Sort-Object -Unique)
}

# ============================================================
# REQUEST / STATE / ARCHIVE
# ============================================================

function Build-Request {
    param(
        [string]$InlineRequest,
        [string[]]$Files
    )

    $Parts = @()

    if (-not [string]::IsNullOrWhiteSpace($InlineRequest)) {
        $Parts += $InlineRequest.Trim()
    }

    foreach ($File in @($Files)) {
        if ([string]::IsNullOrWhiteSpace($File)) {
            continue
        }

        if ([System.IO.Path]::IsPathRooted($File)) {
            $Resolved = [System.IO.Path]::GetFullPath($File)
        }
        else {
            $Resolved = [System.IO.Path]::GetFullPath(
                (Join-Path $Root $File)
            )
        }

        if (-not (Test-Path -LiteralPath $Resolved -PathType Leaf)) {
            throw "Request file not found: $Resolved"
        }

        $Parts += Get-Content `
            -LiteralPath $Resolved `
            -Raw `
            -Encoding utf8
    }

    if (@($Parts).Count -eq 0) {
        throw "Provide -Request, -RequestFile, or both for a new run."
    }

    return ($Parts -join "`n`n---`n`n")
}

function New-WorkflowState {
    param(
        [Parameter(Mandatory = $true)][string]$RunId,
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$BaselineCommit,
        [Parameter(Mandatory = $true)][string]$BaselineReference,
        [Parameter(Mandatory = $true)][int]$RoundLimit,
        [Parameter(Mandatory = $true)][int]$RetryLimit,
        [string[]]$Scopes
    )

    $Now = (Get-Date).ToString("o")

    return [pscustomobject]@{
        version = 52
        run_id = $RunId
        round = 1
        max_rounds = $RoundLimit
        editor_retry_limit = $RetryLimit

        next_stage = "ANALYST"
        status = "RUNNING"

        baseline_ref = $BaselineReference
        baseline_commit = $BaselineCommit
        candidate_commit = $BaselineCommit
        worktree_path = $Worktree
        write_scope = @($Scopes)

        round_checkpoint = $null
        current_target_index = 0
        editor_attempt = 1
        editor_attempt_checkpoint = $null
        editor_protected_before = $null
        editor_last_violations = @()
        editor_last_feedback = $null

        round_created_files = @()
        round_modified_files = @()
        round_deleted_files = @()
        authorized_write_history = @()

        created_at = $Now
        updated_at = $Now
        last_error = $null
    }
}

function Save-State {
    param([Parameter(Mandatory = $true)]$State)

    $State.updated_at = (Get-Date).ToString("o")
    Write-JsonFile -Value $State -Path $StatePath
}

function Set-StateError {
    param(
        [Parameter(Mandatory = $true)]$State,
        [Parameter(Mandatory = $true)][string]$Message
    )

    $State.status = "INTERRUPTED"
    $State.last_error = $Message
    Save-State -State $State
}

function Reset-EditorRoundState {
    param([Parameter(Mandatory = $true)]$State)

    $State.round_checkpoint = $null
    $State.current_target_index = 0
    $State.editor_attempt = 1
    $State.editor_attempt_checkpoint = $null
    $State.editor_protected_before = $null
    $State.editor_last_violations = @()
    $State.editor_last_feedback = $null

    $State.round_created_files = @()
    $State.round_modified_files = @()
    $State.round_deleted_files = @()
}

function Archive-Round {
    param(
        [Parameter(Mandatory = $true)][string]$RunId,
        [Parameter(Mandatory = $true)][int]$Round
    )

    $RoundDir = Join-Path $Runs "$RunId\round-$Round"

    New-Item -ItemType Directory -Force -Path $RoundDir | Out-Null

    foreach ($Name in @(
        "request.md",
        "plan.json",
        "execution.json",
        "changes.patch",
        "audit.json",
        "state.json",
        "editor-feedback.json",
        "approved.patch"
    )) {
        $Source = Join-Path $Current $Name

        if (Test-Path -LiteralPath $Source -PathType Leaf) {
            Copy-Item `
                -LiteralPath $Source `
                -Destination (Join-Path $RoundDir $Name) `
                -Force
        }
    }
}

function Get-LatestArchivedRoundDirectory {
    param([Parameter(Mandatory = $true)][string]$RunDirectory)

    $Candidates = @(
        Get-ChildItem `
            -LiteralPath $RunDirectory `
            -Directory `
            -Filter "round-*" |
        ForEach-Object {
            if ($_.Name -match '^round-(\d+)$') {
                [pscustomobject]@{
                    Directory = $_
                    Number = [int]$Matches[1]
                }
            }
        } |
        Sort-Object Number
    )

    if (@($Candidates).Count -eq 0) {
        return $null
    }

    return $Candidates[-1]
}

function Restore-ArchivedControlState {
    param([Parameter(Mandatory = $true)][string]$RunId)

    $RunDirectory = Join-Path $Runs $RunId

    if (-not (Test-Path -LiteralPath $RunDirectory -PathType Container)) {
        throw "Run not found: $RunId"
    }

    $Latest = Get-LatestArchivedRoundDirectory -RunDirectory $RunDirectory

    if ($null -eq $Latest) {
        throw "Run '$RunId' has no archived rounds."
    }

    New-Item -ItemType Directory -Force -Path $Current | Out-Null

    foreach ($Name in @(
        "request.md",
        "plan.json",
        "execution.json",
        "changes.patch",
        "audit.json",
        "state.json",
        "editor-feedback.json",
        "approved.patch"
    )) {
        $Source = Join-Path $Latest.Directory.FullName $Name

        if (Test-Path -LiteralPath $Source -PathType Leaf) {
            Copy-Item `
                -LiteralPath $Source `
                -Destination (Join-Path $Current $Name) `
                -Force
        }
    }
}

# ============================================================
# PLAN POLICY
# ============================================================

function Assert-PlanUsable {
    $Plan = Read-JsonFile `
        -Path $PlanPath `
        -Description "IntegrationPlan"

    foreach ($Name in @(
        "change_id",
        "objective",
        "decisions",
        "invariants",
        "affected_files",
        "blockers"
    )) {
        if (-not (Test-JsonProperty -Object $Plan -Name $Name)) {
            throw "IntegrationPlan is missing required field: $Name"
        }
    }

    if ([string]::IsNullOrWhiteSpace([string]$Plan.change_id)) {
        throw "IntegrationPlan has an empty change_id."
    }

    return $Plan
}

function Assert-AuditUsable {
    $Audit = Read-JsonFile `
        -Path $AuditPath `
        -Description "AuditReport"

    foreach ($Name in @(
        "verdict",
        "summary",
        "issues",
        "next_action"
    )) {
        if (-not (Test-JsonProperty -Object $Audit -Name $Name)) {
            throw "AuditReport is missing required field: $Name"
        }
    }

    if ([string]$Audit.verdict -notin @("PASS", "FAIL")) {
        throw "Unexpected audit verdict: $($Audit.verdict)"
    }

    return $Audit
}

function Merge-UniquePlanStrings {
    param([object[]]$Values)

    $Seen = @{}
    $Result = [System.Collections.Generic.List[string]]::new()

    foreach ($Value in @($Values)) {
        $Text = ([string]$Value).Trim()

        if ([string]::IsNullOrWhiteSpace($Text)) {
            continue
        }

        if (-not $Seen.ContainsKey($Text)) {
            $Seen[$Text] = $true
            [void]$Result.Add($Text)
        }
    }

    return @($Result.ToArray())
}

function Normalize-PlanAffectedFiles {
    param([Parameter(Mandatory = $true)]$Plan)

    $Groups = [ordered]@{}
    $GroupOrder = [System.Collections.Generic.List[string]]::new()

    foreach ($Entry in @($Plan.affected_files)) {
        if (
            -not (Test-JsonProperty -Object $Entry -Name "path") -or
            -not (Test-JsonProperty -Object $Entry -Name "operation")
        ) {
            throw "Every affected_files entry must contain path and operation."
        }

        $Path = Assert-SafeRepoRelativePath ([string]$Entry.path)
        $Operation = ([string]$Entry.operation).ToUpperInvariant()

        if ($Operation -notin @("CREATE", "MODIFY", "DELETE", "VERIFY")) {
            throw "Unsupported plan operation '$Operation' for $Path"
        }

        $Key = $Path.ToLowerInvariant()

        if (-not $Groups.Contains($Key)) {
            $Groups[$Key] = [pscustomobject]@{
                path = $Path
                entries = [System.Collections.Generic.List[object]]::new()
                operations = [System.Collections.Generic.List[string]]::new()
            }

            [void]$GroupOrder.Add($Key)
        }

        [void]$Groups[$Key].entries.Add($Entry)
        [void]$Groups[$Key].operations.Add($Operation)
    }

    $Normalized = [System.Collections.Generic.List[object]]::new()
    $WasChanged = $false

    foreach ($Key in $GroupOrder) {
        $Group = $Groups[$Key]
        $Entries = @($Group.entries)
        $Operations = @(
            $Group.operations |
            Sort-Object -Unique
        )

        $EffectiveOperation = $null

        if (@($Operations).Count -eq 1) {
            $EffectiveOperation = [string]$Operations[0]
        }
        elseif (
            @($Operations).Count -eq 2 -and
            @($Operations | Where-Object { $_ -eq "VERIFY" }).Count -eq 1
        ) {
            $WriteOperations = @(
                $Operations |
                Where-Object { $_ -ne "VERIFY" }
            )

            if (
                @($WriteOperations).Count -eq 1 -and
                [string]$WriteOperations[0] -in @("CREATE", "MODIFY")
            ) {
                # A read-only VERIFY for a file that is also being written is
                # folded into the write target. Its criteria are preserved
                # below as acceptance criteria.
                $EffectiveOperation = [string]$WriteOperations[0]
            }
        }

        if ([string]::IsNullOrWhiteSpace($EffectiveOperation)) {
            throw @"
IntegrationPlan contains conflicting operations for the same path:
$($Group.path)

Operations:
$($Operations -join ", ")

Duplicate entries are merged automatically only when they are semantically
compatible. CREATE+MODIFY, DELETE+MODIFY, DELETE+CREATE, and DELETE+VERIFY
require Analyst re-planning.
"@
        }

        $InstructionValues = @()
        $AcceptanceValues = @()

        foreach ($Entry in $Entries) {
            $EntryOperation = ([string]$Entry.operation).ToUpperInvariant()

            $Instructions = @()
            if (Test-JsonProperty -Object $Entry -Name "instructions") {
                $Instructions = @($Entry.instructions)
            }

            $Acceptance = @()
            if (Test-JsonProperty -Object $Entry -Name "acceptance") {
                $Acceptance = @($Entry.acceptance)
            }

            if (
                $EntryOperation -eq "VERIFY" -and
                $EffectiveOperation -ne "VERIFY"
            ) {
                # VERIFY instructions are validation concerns, not editing
                # commands. Preserve them as acceptance criteria instead of
                # feeding them to Flash as write instructions.
                foreach ($Instruction in $Instructions) {
                    $Text = ([string]$Instruction).Trim()

                    if (-not [string]::IsNullOrWhiteSpace($Text)) {
                        $AcceptanceValues += "Verify: $Text"
                    }
                }
            }
            else {
                $InstructionValues += @($Instructions)
            }

            $AcceptanceValues += @($Acceptance)
        }

        $MergedEntry = [pscustomobject]@{
            path = [string]$Group.path
            operation = $EffectiveOperation
            instructions = @(
                Merge-UniquePlanStrings -Values $InstructionValues
            )
            acceptance = @(
                Merge-UniquePlanStrings -Values $AcceptanceValues
            )
        }

        [void]$Normalized.Add($MergedEntry)

        if (
            @($Entries).Count -gt 1 -or
            -not (
                ([string]$Entries[0].path).Equals(
                    [string]$Group.path,
                    [System.StringComparison]::Ordinal
                )
            ) -or
            ([string]$Entries[0].operation).ToUpperInvariant() -ne $EffectiveOperation
        ) {
            $WasChanged = $true
        }
    }

    if (@($Normalized).Count -ne @($Plan.affected_files).Count) {
        $WasChanged = $true
    }

    if ($WasChanged) {
        $Plan.affected_files = @($Normalized.ToArray())

        # Persist the deterministic normalization so Editor and Auditor see
        # the exact same effective plan. This does not invoke a model.
        Write-JsonFile `
            -Value $Plan `
            -Path $PlanPath
    }

    return [pscustomobject]@{
        changed = $WasChanged
        entries = @($Normalized.ToArray())
    }
}

function Assert-PlanPolicy {
    param(
        [Parameter(Mandatory = $true)]$Plan,
        [Parameter(Mandatory = $true)][string]$Worktree,
        [string[]]$Scopes
    )

    $WriteEntries = @()
    $DeleteEntries = @()
    $VerifyEntries = @()

    $Normalization = Normalize-PlanAffectedFiles -Plan $Plan

    foreach ($Entry in @($Normalization.entries)) {
        $Path = Assert-SafeRepoRelativePath ([string]$Entry.path)
        $Operation = ([string]$Entry.operation).ToUpperInvariant()

        if ($Operation -ne "VERIFY" -and (Test-ProtectedPath $Path)) {
            throw @"
IntegrationPlan attempts to write protected workflow infrastructure:
$Path
"@
        }

        if (
            $Operation -ne "VERIFY" -and
            -not (Test-PathInWriteScope -Path $Path -Scopes $Scopes)
        ) {
            throw @"
IntegrationPlan expanded beyond the hard -WriteScope:
$Path

Allowed write scope:
$(@($Scopes) -join "`n")
"@
        }

        $Absolute = Convert-ToAbsoluteRepoPath `
            -RepoRoot $Worktree `
            -RelativePath $Path

        if (
            $Operation -ne "VERIFY" -and
            (Test-Path -LiteralPath $Absolute -PathType Container)
        ) {
            throw "affected_files must use exact file paths, not directories: $Path"
        }

        switch ($Operation) {
            "CREATE" {
                # Existence is a start-of-plan precondition, not a persistent
                # policy rule. After a successful CREATE the file is expected
                # to exist, and Assert-PlanPolicy is called again later.
                $WriteEntries += $Entry
            }

            "MODIFY" {
                # Existence is validated once before execution starts.
                $WriteEntries += $Entry
            }

            "DELETE" {
                if (Test-Path -LiteralPath $Absolute -PathType Container) {
                    throw "DELETE may target only files: $Path"
                }

                $DeleteEntries += $Entry
            }

            "VERIFY" {
                $VerifyEntries += $Entry
            }
        }
    }

    return [pscustomobject]@{
        write_entries = @($WriteEntries)
        delete_entries = @($DeleteEntries)
        verify_entries = @($VerifyEntries)
    }
}

function Assert-PlanOperationPreconditions {
    param(
        [Parameter(Mandatory = $true)]$Policy,
        [Parameter(Mandatory = $true)][string]$Worktree
    )

    foreach ($Entry in @($Policy.write_entries)) {
        $Path = Normalize-RepoPath ([string]$Entry.path)
        $Operation = ([string]$Entry.operation).ToUpperInvariant()

        $Absolute = Convert-ToAbsoluteRepoPath `
            -RepoRoot $Worktree `
            -RelativePath $Path

        switch ($Operation) {
            "CREATE" {
                if (Test-Path -LiteralPath $Absolute) {
                    throw @"
CREATE precondition failed before Editor execution:
$Path

The target already exists in the current candidate. The Analyst must use
MODIFY for an existing artifact.
"@
                }
            }

            "MODIFY" {
                if (-not (Test-Path -LiteralPath $Absolute -PathType Leaf)) {
                    throw @"
MODIFY precondition failed before Editor execution:
$Path

The target does not exist as a file in the current candidate.
"@
                }
            }
        }
    }
}

# ============================================================
# EDITOR SURGICAL TASKS
# ============================================================

function Get-EntryArray {
    param(
        [Parameter(Mandatory = $true)]$Entry,
        [Parameter(Mandatory = $true)][string]$PropertyName
    )

    $Property = $Entry.PSObject.Properties[$PropertyName]

    if ($null -eq $Property -or $null -eq $Property.Value) {
        return @()
    }

    return @($Property.Value)
}

function Write-EditorTask {
    param(
        [Parameter(Mandatory = $true)]$Entry,
        [Parameter(Mandatory = $true)][int]$Attempt,
        [Parameter(Mandatory = $true)][int]$RetryLimit,
        [string[]]$PreviousViolations,
        [string]$PreviousFeedback
    )

    $Path = Normalize-RepoPath ([string]$Entry.path)
    $Operation = ([string]$Entry.operation).ToUpperInvariant()

    $Instructions = Get-EntryArray `
        -Entry $Entry `
        -PropertyName "instructions"

    $Acceptance = Get-EntryArray `
        -Entry $Entry `
        -PropertyName "acceptance"

    $InstructionText = if (@($Instructions).Count -eq 0) {
        "- Follow the semantic intent for this target from the approved plan."
    }
    else {
        (
            $Instructions |
            ForEach-Object { "- $_" }
        ) -join "`n"
    }

    $AcceptanceText = if (@($Acceptance).Count -eq 0) {
        "- The target satisfies its approved plan intent."
    }
    else {
        (
            $Acceptance |
            ForEach-Object { "- $_" }
        ) -join "`n"
    }

    $RetryText = ""

    if (-not [string]::IsNullOrWhiteSpace($PreviousFeedback)) {
        $RetryText += @"

## Previous attempt did not satisfy the target contract

$PreviousFeedback

Correct this on the next attempt. Do not broaden the write scope.
"@
    }

    if (@($PreviousViolations).Count -gt 0) {
        $ViolationText = (
            @($PreviousViolations) |
            ForEach-Object { "- $_" }
        ) -join "`n"

        $RetryText = @"

## Previous attempt was rejected

The previous attempt was rolled back because it wrote outside the one-file
allowlist.

Unauthorized paths:
$ViolationText

Do not repeat those writes. They are NOT part of this invocation.

If you believe one of them is actually required, DO NOT edit it. Return:
`[DOCFLOW_BLOCKED] <reason>`
"@
    }

    $Task = @"
# Surgical Editor Task

Attempt: $Attempt / $RetryLimit

## Only writable target

$Path

Operation: $Operation

This is the ONLY repository file you are allowed to create or modify in this
invocation.

All other repository files are READ-ONLY context, even if they:
- reference this target;
- are inconsistent with it;
- are translations or historical copies;
- would normally be updated for consistency;
- contain obvious errors.

## Instructions

$InstructionText

## Acceptance

$AcceptanceText

## Mandatory behavior

1. Read other files only when needed to understand this target.
2. Modify only $Path.
3. Do not execute any other entry from plan.json.
4. Do not perform repository cleanup.
5. Do not synchronize parallel/historical/translated/generated files.
6. Do not edit workflow files.
7. If the target cannot be completed without another write, do not perform that
   write. Return `[DOCFLOW_BLOCKED] <reason>` instead.
8. If completed, return only `DONE`.
$RetryText
"@

    Set-Content `
        -LiteralPath $EditorTaskPath `
        -Value $Task `
        -Encoding utf8
}

function Test-ExactPath {
    param(
        [Parameter(Mandatory = $true)][string]$Actual,
        [Parameter(Mandatory = $true)][string]$Expected
    )

    return (
        (Normalize-RepoPath $Actual).Equals(
            (Normalize-RepoPath $Expected),
            [System.StringComparison]::OrdinalIgnoreCase
        )
    )
}

function Get-UnauthorizedTargetWrites {
    param(
        [string[]]$DeltaPaths,
        [string[]]$ProtectedDeltaPaths,
        [Parameter(Mandatory = $true)][string]$AllowedTarget
    )

    $Unauthorized = @()

    foreach ($Path in @($DeltaPaths)) {
        if (-not (Test-ExactPath -Actual $Path -Expected $AllowedTarget)) {
            $Unauthorized += $Path
        }
    }

    foreach ($Path in @($ProtectedDeltaPaths)) {
        $Unauthorized += $Path
    }

    return @($Unauthorized | Sort-Object -Unique)
}

function Apply-AuthorizedDeletes {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)]$DeleteEntries
    )

    $Deleted = @()

    foreach ($Entry in @($DeleteEntries)) {
        $Path = Normalize-RepoPath ([string]$Entry.path)

        $Absolute = Convert-ToAbsoluteRepoPath `
            -RepoRoot $Worktree `
            -RelativePath $Path

        if (Test-ProtectedPath $Path) {
            throw "Refusing to delete protected path: $Path"
        }

        if (Test-Path -LiteralPath $Absolute -PathType Container) {
            throw "DELETE may target only files: $Path"
        }

        if (Test-Path -LiteralPath $Absolute -PathType Leaf) {
            Remove-Item -LiteralPath $Absolute -Force
        }

        $Deleted += $Path
    }

    return @($Deleted | Sort-Object -Unique)
}

function Write-EditorFeedback {
    param(
        [Parameter(Mandatory = $true)][string]$Type,
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][string]$Reason,
        [int]$Attempts = 0,
        [string[]]$Violations
    )

    $Feedback = [ordered]@{
        type = $Type
        target = $Target
        reason = $Reason
        attempts = $Attempts
        unauthorized_paths = @($Violations)
        instruction = (
            "Reanalyze only against the original request. Do not authorize " +
            "extra files merely because the Editor attempted to touch them."
        )
    }

    Write-JsonFile `
        -Value $Feedback `
        -Path $EditorFeedbackPath
}

# ============================================================
# PATCH / FINAL AUTHORIZATION
# ============================================================

function Write-CumulativeCandidatePatch {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$BaselineCommit,
        [Parameter(Mandatory = $true)][string]$CandidateCommit,
        [Parameter(Mandatory = $true)][string]$OutputPath
    )

    $Patch = @(
        & git -C "$Worktree" diff `
            --binary `
            "$BaselineCommit" `
            "$CandidateCommit" `
            -- `
            . `
            ':(exclude).ai/**' `
            ':(exclude).agents/**' `
            ':(exclude)scripts/**' `
            ':(exclude)AGENTS.md' `
            ':(exclude).gitignore' `
            2>$null
    )

    if ($LASTEXITCODE -ne 0) {
        throw "Could not generate candidate Git patch."
    }

    [System.IO.File]::WriteAllText(
        $OutputPath,
        (($Patch -join "`n") + $(if (@($Patch).Count -gt 0) { "`n" } else { "" })),
        $Utf8NoBom
    )
}

function Assert-CumulativeAuthorization {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [Parameter(Mandatory = $true)][string]$BaselineCommit,
        [Parameter(Mandatory = $true)][string]$CandidateCommit,
        [string[]]$AuthorizedHistory
    )

    $Changed = Get-CumulativeCandidatePaths `
        -Worktree $Worktree `
        -BaselineCommit $BaselineCommit `
        -CandidateCommit $CandidateCommit

    $Unauthorized = @()

    foreach ($Path in $Changed) {
        $Found = $false

        foreach ($Allowed in @($AuthorizedHistory)) {
            if (Test-ExactPath -Actual $Path -Expected $Allowed) {
                $Found = $true
                break
            }
        }

        if (-not $Found) {
            $Unauthorized += $Path
        }
    }

    if (@($Unauthorized).Count -gt 0) {
        throw @"
Candidate contains cumulative changes that were never accepted by the
orchestrator:

$($Unauthorized -join "`n")

The main repository remains untouched.
"@
    }

    return @($Changed)
}

function Refresh-AuthorizedHistoryFromCandidate {
    param(
        [Parameter(Mandatory = $true)]$State,
        [Parameter(Mandatory = $true)][string]$Worktree
    )

    $State.authorized_write_history = @(
        Get-CumulativeCandidatePaths `
            -Worktree $Worktree `
            -BaselineCommit ([string]$State.baseline_commit) `
            -CandidateCommit ([string]$State.candidate_commit)
    )
}

function Apply-CandidateToMain {
    param(
        [Parameter(Mandatory = $true)][string]$BaselineCommit,
        [Parameter(Mandatory = $true)][string]$PatchPath,
        [string[]]$ChangedPaths
    )

    $MainHead = Get-GitCommit -RepoRoot $Root -Ref "HEAD"

    if ($MainHead -ne $BaselineCommit) {
        throw @"
Refusing -ApplyOnPass because main HEAD moved during the run.

Baseline:
$BaselineCommit

Current:
$MainHead
"@
    }

    foreach ($Path in @($ChangedPaths)) {
        $Dirty = @(
            & git -C "$Root" status `
                --porcelain `
                --untracked-files=all `
                -- `
                "$Path" `
                2>$null |
            Where-Object { $_ }
        )

        if (@($Dirty).Count -gt 0) {
            throw @"
Refusing -ApplyOnPass because main has a local change at:
$Path
"@
        }
    }

    if (@($ChangedPaths).Count -eq 0) {
        return
    }

    Assert-FileExists `
        -Path $PatchPath `
        -Description "Approved patch"

    & git -C "$Root" apply --check "$PatchPath" 2>$null

    if ($LASTEXITCODE -ne 0) {
        throw @"
Approved patch does not apply cleanly to the main worktree.

The main repository was not modified.
Patch:
$PatchPath
"@
    }

    & git -C "$Root" apply "$PatchPath" 2>$null

    if ($LASTEXITCODE -ne 0) {
        throw @"
git apply failed after a successful preflight check.

Inspect the main worktree before retrying:
  git status --short
  git diff

Patch:
$PatchPath
"@
    }
}

# ============================================================
# MODEL INVOCATIONS
# ============================================================

function Get-ScopePromptText {
    param([string[]]$Scopes)

    if (@($Scopes).Count -eq 0) {
        return @"
No additional CLI write cap is set. The original request is still the
authoritative semantic boundary.
"@
    }

    return @"
HARD WRITE SCOPE:
$(@($Scopes) -join "`n")

CREATE/MODIFY/DELETE outside this scope are forbidden by the orchestrator.
VERIFY/read operations may inspect other files.
"@
}

function Invoke-Analyst {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [string[]]$Scopes
    )

    $ScopeText = Get-ScopePromptText -Scopes $Scopes

    $Prompt = @"
Read and follow AGENTS.md and .ai/prompts/analyst.md.
Read .ai/current/request.md.

If present:
- read .ai/current/audit.json as previous-round audit feedback;
- read .ai/current/editor-feedback.json as Editor execution feedback.

IMPORTANT:
Editor feedback is evidence about a failed attempt, NOT permission to broaden
the request. If the Editor tried to touch an unauthorized file, prefer a more
precise plan/instruction for the original target. Do not add the attempted file
unless the ORIGINAL REQUEST independently requires it and the hard write scope
allows it.

request.md is the authority for WHAT may change.
Do not perform repository cleanup or synchronize unrelated artifacts.

Operations are relative to the CURRENT candidate repository:
- use CREATE only when the target does not exist now;
- use MODIFY when the target already exists now;
- do not repeat CREATE for an artifact created in an earlier failed round.

$ScopeText

Inspect repository files selectively as needed.
Do not modify files.
Return only the IntegrationPlan required by the output schema.
"@

    $Arguments = @(
        "exec",
        "--cd", $Worktree,
        "--model", $AnalystModel,
        "--sandbox", "read-only",
        "--config", "model_reasoning_effort=`"$AnalystReasoning`"",
        "--output-schema", $IntegrationSchemaPath,
        "--output-last-message", $PlanPath,
        $Prompt
    )

    return Invoke-CapturedProcess `
        -FileName (Get-CommandPath "codex") `
        -Arguments $Arguments `
        -WorkingDirectory $Worktree `
        -Activity "Analyst"
}

function Invoke-EditorTarget {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree
    )

    $Prompt = @"
Read and follow:
1. AGENTS.md
2. .agents/agents/documentation-editor/agent.md
3. .ai/current/editor-task.md

Execute ONLY the surgical task in editor-task.md.

Do not execute the complete plan.
Do not modify any file other than the one exact target named there.

If another write seems necessary, do not perform it. Reply:
[DOCFLOW_BLOCKED] <short reason>

If successful, reply only:
DONE
"@

    $Arguments = @(
        "--add-dir", $Worktree,
        "-p", $Prompt,
        "--model", $EditorModel,
        "--mode=accept-edits",
        "--sandbox",
        "--output-format", "json",
        "--print-timeout", "15m"
    )

    return Invoke-CapturedProcess `
        -FileName (Get-CommandPath "agy") `
        -Arguments $Arguments `
        -WorkingDirectory $Worktree `
        -Activity "Editor"
}

function Invoke-Auditor {
    param(
        [Parameter(Mandatory = $true)][string]$Worktree,
        [string[]]$Scopes
    )

    $ScopeText = Get-ScopePromptText -Scopes $Scopes

    $Prompt = @"
Read and follow AGENTS.md and .ai/prompts/auditor.md.

Audit the CURRENT isolated candidate using:
- .ai/current/request.md
- .ai/current/plan.json
- .ai/current/execution.json
- .ai/current/changes.patch

execution.json describes the current round. changes.patch is cumulative from
the original baseline to the current stable candidate. Previous-round changes
may therefore appear in changes.patch even when they are not listed in the
current execution report.

Inspect repository files only as needed.
Do not modify files.

Judge the requested outcome, not an ideal globally-clean repository.
Do not turn unrelated pre-existing issues into required work.
FAIL unnecessary candidate changes outside the original request.

$ScopeText

Return only the AuditReport required by the output schema.
"@

    $Arguments = @(
        "exec",
        "--cd", $Worktree,
        "--model", $AuditorModel,
        "--sandbox", "read-only",
        "--config", "model_reasoning_effort=`"$AuditorReasoning`"",
        "--output-schema", $AuditSchemaPath,
        "--output-last-message", $AuditPath,
        $Prompt
    )

    return Invoke-CapturedProcess `
        -FileName (Get-CommandPath "codex") `
        -Arguments $Arguments `
        -WorkingDirectory $Worktree `
        -Activity "Auditor"
}

# ============================================================
# PRE-FLIGHT
# ============================================================

Assert-CommandExists "git"
Assert-CommandExists "codex"
Assert-CommandExists "agy"

$GitRoot = Get-GitRoot

if (
    -not $Root.TrimEnd('\', '/').Equals(
        $GitRoot.TrimEnd('\', '/'),
        [System.StringComparison]::OrdinalIgnoreCase
    )
) {
    throw "Script root and Git root do not match."
}

Assert-FileExists $AgentsPath "AGENTS.md"
Assert-FileExists $AnalystPromptPath "Analyst prompt"
Assert-FileExists $AuditorPromptPath "Auditor prompt"
Assert-FileExists $IntegrationSchemaPath "Integration plan schema"
Assert-FileExists $ExecutionSchemaPath "Execution report schema"
Assert-FileExists $AuditSchemaPath "Audit report schema"
Assert-FileExists $EditorAgentPath "Documentation editor profile"

$EditorProfileRaw = Get-Content `
    -LiteralPath $EditorAgentPath `
    -Raw `
    -Encoding utf8

if (
    $EditorProfileRaw -notmatch
    [regex]::Escape($EditorProfileIdentifier)
) {
    throw @"
The editor profile does not contain:
$EditorProfileIdentifier

Install the V5.2 editor profile before running.
"@
}

New-Item -ItemType Directory -Force -Path $Current | Out-Null
New-Item -ItemType Directory -Force -Path $Runs | Out-Null

# ============================================================
# INITIALIZE / RESUME
# ============================================================

if (
    $Resume -and
    -not [string]::IsNullOrWhiteSpace($ResumeRunId)
) {
    throw "Use either -Resume or -ResumeRunId, not both."
}

$HasRequestArguments = (
    $PSBoundParameters.ContainsKey("Request") -or
    $PSBoundParameters.ContainsKey("RequestFile")
)

if (
    (
        $Resume -or
        -not [string]::IsNullOrWhiteSpace($ResumeRunId)
    ) -and
    $HasRequestArguments
) {
    throw "Do not pass -Request or -RequestFile while resuming."
}

$State = $null

if (-not [string]::IsNullOrWhiteSpace($ResumeRunId)) {
    Restore-ArchivedControlState -RunId $ResumeRunId
    $State = Read-JsonFile -Path $StatePath -Description "workflow state"

    if ([int]$State.version -ne 52) {
        throw "Only V5.2 runs can be resumed with this harness."
    }

    Assert-WorktreeAvailable -Worktree ([string]$State.worktree_path)

    if (
        -not [string]::IsNullOrWhiteSpace(
            [string]$State.candidate_commit
        )
    ) {
        Restore-CandidateCheckpoint `
            -Worktree ([string]$State.worktree_path) `
            -Checkpoint ([string]$State.candidate_commit)
    }
}
elseif ($Resume) {
    $State = Read-JsonFile -Path $StatePath -Description "workflow state"

    if ([int]$State.version -ne 52) {
        throw @"
Current state belongs to an older harness version.
Start a new V5.2 isolated run.
"@
    }

    Assert-WorktreeAvailable -Worktree ([string]$State.worktree_path)
}
else {
    $ExistingState = Try-ReadJsonFile -Path $StatePath

    if (
        -not $ForceNewRun -and
        $null -ne $ExistingState -and
        [string]$ExistingState.status -notin @(
            "COMPLETED",
            "ABANDONED"
        )
    ) {
        throw @"
A workflow state already exists.

Resume it with -Resume, or intentionally start a new run with -ForceNewRun.
"@
    }

    Assert-MainBaselineClean

    $FinalRequest = Build-Request `
        -InlineRequest $Request `
        -Files $RequestFile

    $Scopes = Normalize-WriteScopes -Scopes $WriteScope
    $BaselineCommit = Get-GitCommit -RepoRoot $Root -Ref $BaselineRef
    $RunId = Get-Date -Format "yyyyMMdd-HHmmss"

    $Worktree = New-IsolatedWorktree `
        -RunId $RunId `
        -Commit $BaselineCommit

    Set-Content `
        -LiteralPath $RequestPath `
        -Value $FinalRequest `
        -Encoding utf8

    Set-Content -LiteralPath $PlanPath -Value "{}" -Encoding utf8
    Set-Content -LiteralPath $ExecutionPath -Value "{}" -Encoding utf8
    Set-Content -LiteralPath $ChangesPath -Value "" -Encoding utf8
    Set-Content -LiteralPath $AuditPath -Value "{}" -Encoding utf8
    Set-Content -LiteralPath $EditorFeedbackPath -Value "{}" -Encoding utf8
    Set-Content -LiteralPath $EditorTaskPath -Value "" -Encoding utf8

    Remove-Item `
        -LiteralPath $ApprovedPatchPath `
        -Force `
        -ErrorAction SilentlyContinue

    $State = New-WorkflowState `
        -RunId $RunId `
        -Worktree $Worktree `
        -BaselineCommit $BaselineCommit `
        -BaselineReference $BaselineRef `
        -RoundLimit $MaxRounds `
        -RetryLimit $EditorRetryLimit `
        -Scopes $Scopes

    Save-State -State $State
    Sync-ControlPlaneToWorktree -Worktree $Worktree
}

if ($null -eq $State) {
    throw "Workflow state could not be initialized."
}

if ($PSBoundParameters.ContainsKey("MaxRounds")) {
    $State.max_rounds = $MaxRounds

    if (
        [string]$State.status -eq "MAX_ROUNDS_REACHED" -and
        [int]$State.round -le [int]$State.max_rounds
    ) {
        $State.status = "RUNNING"
        $State.next_stage = "ANALYST"
    }

    Save-State -State $State
}

if (
    $PSBoundParameters.ContainsKey("EditorRetryLimit") -and
    ($Resume -or -not [string]::IsNullOrWhiteSpace($ResumeRunId))
) {
    $State.editor_retry_limit = $EditorRetryLimit
    Save-State -State $State
}

if (
    $PSBoundParameters.ContainsKey("WriteScope") -and
    ($Resume -or -not [string]::IsNullOrWhiteSpace($ResumeRunId))
) {
    throw "WriteScope is fixed when a V5.1 run starts."
}

$Worktree = [string]$State.worktree_path
$Scopes = @($State.write_scope)

# Automatic crash recovery: the checkpoint marker is authoritative.
# The outer catch may have changed status to INTERRUPTED after a crash, so do
# not rely on status == EDITOR_RUNNING here.
if (
    -not [string]::IsNullOrWhiteSpace(
        [string]$State.editor_attempt_checkpoint
    )
) {
    Write-Host ""
    Write-Host "Recovering interrupted Editor attempt..."

    Restore-CandidateCheckpoint `
        -Worktree $Worktree `
        -Checkpoint ([string]$State.editor_attempt_checkpoint)

    $State.status = "RUNNING"
    $State.next_stage = "EDITOR"
    $State.editor_attempt_checkpoint = $null
    $State.editor_protected_before = $null
    Save-State -State $State
}

Sync-ControlPlaneToWorktree -Worktree $Worktree

if (
    [string]$State.status -eq "COMPLETED" -and
    $ResumeFrom -eq "Auto"
) {
    Write-Host ""
    Write-Host "Workflow already completed."
    Write-Host "Run: $($State.run_id)"
    Write-Host "Candidate: $Worktree"
    exit 0
}

if ($ResumeFrom -ne "Auto") {
    switch ($ResumeFrom) {
        "Analyst" {
            $State.next_stage = "ANALYST"
        }

        "Editor" {
            $Plan = Assert-PlanUsable

            $Policy = Assert-PlanPolicy `
                -Plan $Plan `
                -Worktree $Worktree `
                -Scopes $Scopes

            # Recovery case: Analyst completed but no Editor work has started.
            # Only then should CREATE/MODIFY start-state preconditions be
            # checked. A partially completed round may legitimately contain a
            # file created by an already accepted CREATE target.
            $NoEditorProgress = (
                [int]$State.current_target_index -eq 0 -and
                [string]::IsNullOrWhiteSpace(
                    [string]$State.round_checkpoint
                )
            )

            if ($NoEditorProgress) {
                Assert-PlanOperationPreconditions `
                    -Policy $Policy `
                    -Worktree $Worktree
            }

            # Analyst completed and plan.json is valid, but the harness may
            # have failed while creating the round checkpoint. Recreate it
            # without rerunning the Analyst.
            if (
                [string]::IsNullOrWhiteSpace(
                    [string]$State.round_checkpoint
                )
            ) {
                Sync-ControlPlaneToWorktree -Worktree $Worktree

                $State.round_checkpoint = New-CandidateCheckpoint `
                    -Worktree $Worktree `
                    -Message "docflow round $($State.round) start (recovered)"
            }

            $State.next_stage = "EDITOR"
        }

        "Auditor" {
            $Execution = Read-JsonFile `
                -Path $ExecutionPath `
                -Description "ExecutionReport"

            if (
                -not (Test-JsonProperty -Object $Execution -Name "status") -or
                [string]$Execution.status -ne "COMPLETED"
            ) {
                throw "Cannot resume Auditor: execution.json is not COMPLETED."
            }

            $State.next_stage = "AUDITOR"
        }
    }

    $State.status = "RUNNING"
    $State.last_error = $null
    Save-State -State $State
}

# ============================================================
# CLI HEADER
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host " DOCUMENTATION WORKFLOW - HARDENED V5.2.3"
Write-Host "============================================================"
Write-Host ("Run:           {0}" -f $State.run_id)
Write-Host ("Round:         {0}/{1}" -f $State.round, $State.max_rounds)
Write-Host ("Stage:         {0}" -f $State.next_stage)
Write-Host ("Baseline:      {0}" -f $State.baseline_commit)
Write-Host ("Candidate:     {0}" -f $Worktree)
Write-Host ("Editor retries:{0}" -f $State.editor_retry_limit)

if (@($Scopes).Count -gt 0) {
    Write-Host ("WriteScope:     {0}" -f ($Scopes -join ", "))
}
else {
    Write-Host "WriteScope:     request + plan enforced"
}

Write-Host ("Analyst:       {0} ({1})" -f $AnalystModel, $AnalystReasoning)
Write-Host ("Editor:        {0}" -f $EditorModel)
Write-Host ("Auditor:       {0} ({1})" -f $AuditorModel, $AuditorReasoning)
Write-Host "============================================================"
Write-Host ""

# ============================================================
# MAIN LOOP
# ============================================================

try {
    while ([int]$State.round -le [int]$State.max_rounds) {
        $Round = [int]$State.round
        $Stage = [string]$State.next_stage

        switch ($Stage) {
            "ANALYST" {
                Write-Host (
                    "[Round {0}/{1}] ANALYST  running..." -f
                    $Round,
                    $State.max_rounds
                )

                $State.status = "RUNNING"
                $State.last_error = $null
                Save-State -State $State

                Set-Content -LiteralPath $ExecutionPath -Value "{}" -Encoding utf8
                Set-Content -LiteralPath $ChangesPath -Value "" -Encoding utf8

                Sync-ControlPlaneToWorktree -Worktree $Worktree

                $Result = Invoke-Analyst `
                    -Worktree $Worktree `
                    -Scopes $Scopes

                if ($Result.ExitCode -ne 0) {
                    Throw-ProcessFailure -Result $Result -StageName "Analyst"
                }

                $Plan = Assert-PlanUsable
                Sync-ArtifactToWorktree -Worktree $Worktree -Name "plan.json"

                $Policy = Assert-PlanPolicy `
                    -Plan $Plan `
                    -Worktree $Worktree `
                    -Scopes $Scopes

                # Validate CREATE/MODIFY against the candidate exactly once,
                # before any Editor target has been executed. Later calls to
                # Assert-PlanPolicy intentionally do not re-check existence.
                Assert-PlanOperationPreconditions `
                    -Policy $Policy `
                    -Worktree $Worktree

                $AffectedCount = @($Plan.affected_files).Count
                $WriteCount = @($Policy.write_entries).Count
                $VerifyCount = @($Policy.verify_entries).Count
                $BlockerCount = @($Plan.blockers).Count

                Write-Host (
                    "                completed in {0} | affected: {1} | write targets: {2} | verifies: {3} | blockers: {4}" -f
                    (Format-Duration -Elapsed $Result.Elapsed),
                    $AffectedCount,
                    $WriteCount,
                    $VerifyCount,
                    $BlockerCount
                )

                if ($BlockerCount -gt 0) {
                    $State.status = "BLOCKED"
                    $State.next_stage = "ANALYST"
                    Save-State -State $State

                    Archive-Round `
                        -RunId $State.run_id `
                        -Round $Round

                    Write-Host ""
                    Write-Host "ANALYST BLOCKED:"

                    foreach ($Blocker in @($Plan.blockers)) {
                        Write-Host "  - $Blocker"
                    }

                    exit 3
                }

                Reset-EditorRoundState -State $State

                $State.round_checkpoint = New-CandidateCheckpoint `
                    -Worktree $Worktree `
                    -Message "docflow round $Round start"

                $State.next_stage = "EDITOR"
                Save-State -State $State
                continue
            }

            "EDITOR" {
                $Plan = Assert-PlanUsable

                $Policy = Assert-PlanPolicy `
                    -Plan $Plan `
                    -Worktree $Worktree `
                    -Scopes $Scopes

                $Targets = @($Policy.write_entries)
                $TargetIndex = [int]$State.current_target_index

                if ($TargetIndex -ge (@($Targets).Count)) {
                    $Deleted = Apply-AuthorizedDeletes `
                        -Worktree $Worktree `
                        -DeleteEntries $Policy.delete_entries

                    $State.round_deleted_files = @($Deleted)

                    if (@($Deleted).Count -gt 0) {
                        $State.authorized_write_history = @(
                            @($State.authorized_write_history) +
                            @($Deleted) |
                            Sort-Object -Unique
                        )
                    }

                    # Commit the complete round result so CREATE/MODIFY/DELETE
                    # all have one stable candidate commit. This also makes
                    # changes.patch / approved.patch real Git patches.
                    $RoundResultCommit = New-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Message "docflow round $Round candidate result"

                    $State.candidate_commit = $RoundResultCommit
                    Refresh-AuthorizedHistoryFromCandidate `
                        -State $State `
                        -Worktree $Worktree

                    $Execution = [ordered]@{
                        status = "COMPLETED"
                        created_files = @(
                            $State.round_created_files |
                            Sort-Object -Unique
                        )
                        modified_files = @(
                            $State.round_modified_files |
                            Sort-Object -Unique
                        )
                        deleted_files = @(
                            $State.round_deleted_files |
                            Sort-Object -Unique
                        )
                        verified_files = @(
                            @($Policy.verify_entries) |
                            ForEach-Object {
                                Normalize-RepoPath ([string]$_.path)
                            } |
                            Sort-Object -Unique
                        )
                        blockers = @()
                        notes = @(
                            "Execution report synthesized by the V5.2.3 orchestrator.",
                            "Each CREATE/MODIFY target was executed in an isolated one-file Editor invocation.",
                            "Unauthorized Editor writes were rolled back automatically before acceptance.",
                            "DELETE operations were performed by the orchestrator.",
                            "This report describes the current round; changes.patch describes the cumulative candidate from baseline."
                        )
                    }

                    Write-JsonFile `
                        -Value $Execution `
                        -Path $ExecutionPath

                    Write-CumulativeCandidatePatch `
                        -Worktree $Worktree `
                        -BaselineCommit ([string]$State.baseline_commit) `
                        -CandidateCommit ([string]$State.candidate_commit) `
                        -OutputPath $ChangesPath

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    Write-Host (
                        "[Round {0}/{1}] EDITOR   complete | created: {2} | modified: {3} | deleted: {4}" -f
                        $Round,
                        $State.max_rounds,
                        @($Execution.created_files).Count,
                        @($Execution.modified_files).Count,
                        @($Execution.deleted_files).Count
                    )

                    $State.next_stage = "AUDITOR"
                    $State.status = "RUNNING"
                    Save-State -State $State
                    continue
                }

                $Entry = $Targets[$TargetIndex]
                $TargetPath = Normalize-RepoPath ([string]$Entry.path)
                $Operation = ([string]$Entry.operation).ToUpperInvariant()
                $Attempt = [int]$State.editor_attempt
                $RetryLimit = [int]$State.editor_retry_limit

                Write-EditorTask `
                    -Entry $Entry `
                    -Attempt $Attempt `
                    -RetryLimit $RetryLimit `
                    -PreviousViolations @($State.editor_last_violations) `
                    -PreviousFeedback ([string]$State.editor_last_feedback)

                Sync-ControlPlaneToWorktree -Worktree $Worktree

                $AttemptCheckpoint = New-CandidateCheckpoint `
                    -Worktree $Worktree `
                    -Message "docflow round $Round target $TargetIndex attempt $Attempt"

                $ProtectedBefore = Get-ProtectedControlSnapshot `
                    -Worktree $Worktree

                $State.editor_attempt_checkpoint = $AttemptCheckpoint
                $State.editor_protected_before = $ProtectedBefore
                $State.status = "EDITOR_RUNNING"
                Save-State -State $State

                Write-Host (
                    "[Round {0}/{1}] EDITOR   target {2}/{3}: {4} | attempt {5}/{6}" -f
                    $Round,
                    $State.max_rounds,
                    ($TargetIndex + 1),
                    (@($Targets).Count),
                    $TargetPath,
                    $Attempt,
                    $RetryLimit
                )

                $Result = Invoke-EditorTarget -Worktree $Worktree

                if ($Result.ExitCode -ne 0) {
                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint $AttemptCheckpoint

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    $State.status = "INTERRUPTED"
                    $State.next_stage = "EDITOR"
                    $State.editor_attempt_checkpoint = $null
                    $State.editor_protected_before = $null
                    Save-State -State $State

                    Throw-ProcessFailure `
                        -Result $Result `
                        -StageName "Editor"
                }

                # Editor explicitly says the one target cannot be completed
                # without an out-of-scope write.
                if (
                    [string]$Result.Stdout -match
                    '\[DOCFLOW_BLOCKED\]\s*(.*)'
                ) {
                    $Reason = $Matches[1].Trim()

                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint ([string]$State.round_checkpoint)

                    $State.candidate_commit = [string]$State.round_checkpoint
                    Refresh-AuthorizedHistoryFromCandidate `
                        -State $State `
                        -Worktree $Worktree

                    Write-EditorFeedback `
                        -Type "BLOCKED" `
                        -Target $TargetPath `
                        -Reason $Reason `
                        -Attempts $Attempt

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    $State.round = $Round + 1
                    Reset-EditorRoundState -State $State
                    $State.next_stage = "ANALYST"

                    if ([int]$State.round -gt [int]$State.max_rounds) {
                        $State.status = "MAX_ROUNDS_REACHED"
                    }
                    else {
                        $State.status = "RUNNING"
                    }

                    Save-State -State $State

                    Archive-Round `
                        -RunId $State.run_id `
                        -Round $Round

                    if ([string]$State.status -eq "MAX_ROUNDS_REACHED") {
                        Write-Host ""
                        Write-Host "Editor blocked and maximum rounds were reached."
                        exit 2
                    }

                    Write-Host (
                        "                BLOCKED: {0}" -f
                        $Reason
                    )
                    Write-Host (
                        "                rolled back round {0}; reanalyzing automatically in round {1}." -f
                        $Round,
                        $State.round
                    )

                    continue
                }

                $GitDelta = Get-DeltaPaths `
                    -Worktree $Worktree `
                    -Checkpoint $AttemptCheckpoint

                $ProtectedAfter = Get-ProtectedControlSnapshot `
                    -Worktree $Worktree

                $ProtectedDelta = Compare-ProtectedControlSnapshot `
                    -Before $ProtectedBefore `
                    -After $ProtectedAfter

                $Unauthorized = Get-UnauthorizedTargetWrites `
                    -DeltaPaths $GitDelta `
                    -ProtectedDeltaPaths $ProtectedDelta `
                    -AllowedTarget $TargetPath

                $HeadAfterEditor = Get-GitCommit `
                    -RepoRoot $Worktree `
                    -Ref "HEAD"

                if ($HeadAfterEditor -ne $AttemptCheckpoint) {
                    $Unauthorized = @(
                        @($Unauthorized) +
                        @("[git-history]") |
                        Sort-Object -Unique
                    )
                }

                if (@($Unauthorized).Count -gt 0) {
                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint $AttemptCheckpoint

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    Write-Host (
                        "                rejected | unauthorized writes: {0}" -f
                        ($Unauthorized -join ", ")
                    )

                    if ($Attempt -lt $RetryLimit) {
                        $State.editor_attempt = $Attempt + 1
                        $State.editor_last_violations = @($Unauthorized)
                        $State.editor_last_feedback = (
                            "The previous attempt was rejected because it changed " +
                            "paths outside the exact target or manipulated Git state."
                        )
                        $State.editor_attempt_checkpoint = $null
                        $State.editor_protected_before = $null
                        $State.status = "RUNNING"
                        $State.next_stage = "EDITOR"
                        Save-State -State $State

                        Write-Host (
                            "                rolled back automatically; retrying same target with corrective feedback."
                        )

                        continue
                    }

                    # Repeated violation: roll back the whole round and let
                    # Analyst refine the plan/instructions automatically.
                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint ([string]$State.round_checkpoint)

                    $State.candidate_commit = [string]$State.round_checkpoint
                    Refresh-AuthorizedHistoryFromCandidate `
                        -State $State `
                        -Worktree $Worktree

                    Write-EditorFeedback `
                        -Type "POLICY_RETRY_EXHAUSTED" `
                        -Target $TargetPath `
                        -Reason (
                            "Editor repeatedly attempted writes outside the exact one-file allowlist."
                        ) `
                        -Attempts $Attempt `
                        -Violations @($Unauthorized)

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    $State.round = $Round + 1
                    Reset-EditorRoundState -State $State
                    $State.next_stage = "ANALYST"

                    if ([int]$State.round -gt [int]$State.max_rounds) {
                        $State.status = "MAX_ROUNDS_REACHED"
                    }
                    else {
                        $State.status = "RUNNING"
                    }

                    Save-State -State $State

                    Archive-Round `
                        -RunId $State.run_id `
                        -Round $Round

                    if ([string]$State.status -eq "MAX_ROUNDS_REACHED") {
                        Write-Host ""
                        Write-Host "Editor retry limit and maximum rounds reached."
                        exit 5
                    }

                    Write-Host (
                        "                retry limit reached; entire round rolled back."
                    )
                    Write-Host (
                        "                Analyst will replan automatically in round {0}." -f
                        $State.round
                    )

                    continue
                }

                # Enforce the target contract itself. A planned CREATE/MODIFY
                # must produce a real target delta; otherwise retry rather than
                # silently claiming success.
                $ChangedTarget = @(
                    $GitDelta |
                    Where-Object {
                        Test-ExactPath `
                            -Actual $_ `
                            -Expected $TargetPath
                    }
                ).Count -gt 0

                $TargetAbsolute = Convert-ToAbsoluteRepoPath `
                    -RepoRoot $Worktree `
                    -RelativePath $TargetPath

                $TargetExists = Test-Path `
                    -LiteralPath $TargetAbsolute `
                    -PathType Leaf

                $TargetContractFailure = $null

                if (-not $ChangedTarget) {
                    $TargetContractFailure = (
                        "The Editor returned successfully but produced no Git delta " +
                        "for the planned $Operation target '$TargetPath'."
                    )
                }
                elseif ($Operation -in @("CREATE", "MODIFY") -and -not $TargetExists) {
                    $TargetContractFailure = (
                        "The planned $Operation target '$TargetPath' does not exist " +
                        "as a file after the Editor attempt."
                    )
                }

                if (-not [string]::IsNullOrWhiteSpace($TargetContractFailure)) {
                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint $AttemptCheckpoint

                    Sync-ControlPlaneToWorktree -Worktree $Worktree

                    Write-Host (
                        "                rejected | {0}" -f
                        $TargetContractFailure
                    )

                    if ($Attempt -lt $RetryLimit) {
                        $State.editor_attempt = $Attempt + 1
                        $State.editor_last_violations = @()
                        $State.editor_last_feedback = $TargetContractFailure
                        $State.editor_attempt_checkpoint = $null
                        $State.editor_protected_before = $null
                        $State.status = "RUNNING"
                        $State.next_stage = "EDITOR"
                        Save-State -State $State

                        Write-Host (
                            "                rolled back automatically; retrying same target with corrective feedback."
                        )

                        continue
                    }

                    Restore-CandidateCheckpoint `
                        -Worktree $Worktree `
                        -Checkpoint ([string]$State.round_checkpoint)

                    $State.candidate_commit = [string]$State.round_checkpoint
                    Refresh-AuthorizedHistoryFromCandidate `
                        -State $State `
                        -Worktree $Worktree

                    Write-EditorFeedback `
                        -Type "TARGET_RETRY_EXHAUSTED" `
                        -Target $TargetPath `
                        -Reason $TargetContractFailure `
                        -Attempts $Attempt

                    $State.round = $Round + 1
                    Reset-EditorRoundState -State $State
                    $State.next_stage = "ANALYST"

                    if ([int]$State.round -gt [int]$State.max_rounds) {
                        $State.status = "MAX_ROUNDS_REACHED"
                    }
                    else {
                        $State.status = "RUNNING"
                    }

                    Save-State -State $State
                    Archive-Round `
                        -RunId $State.run_id `
                        -Round $Round

                    if ([string]$State.status -eq "MAX_ROUNDS_REACHED") {
                        Write-Host ""
                        Write-Host "Editor target retry limit and maximum rounds reached."
                        exit 5
                    }

                    Write-Host (
                        "                target retry limit reached; round rolled back; Analyst will replan automatically."
                    )

                    continue
                }

                # Exactly the requested target changed and still satisfies the
                # file-level operation contract.
                if ($ChangedTarget) {
                    if ($Operation -eq "CREATE") {
                        $State.round_created_files = @(
                            @($State.round_created_files) +
                            @($TargetPath) |
                            Sort-Object -Unique
                        )
                    }
                    else {
                        $State.round_modified_files = @(
                            @($State.round_modified_files) +
                            @($TargetPath) |
                            Sort-Object -Unique
                        )
                    }

                    $State.authorized_write_history = @(
                        @($State.authorized_write_history) +
                        @($TargetPath) |
                        Sort-Object -Unique
                    )

                    Write-Host "                accepted | exact target only"
                }
                else {
                    Write-Host "                accepted | no file change required"
                }

                $State.current_target_index = $TargetIndex + 1
                $State.editor_attempt = 1
                $State.editor_last_violations = @()
                $State.editor_last_feedback = $null
                $State.editor_attempt_checkpoint = $null
                $State.editor_protected_before = $null
                $State.status = "RUNNING"
                $State.next_stage = "EDITOR"
                Save-State -State $State

                continue
            }

            "AUDITOR" {
                Write-Host (
                    "[Round {0}/{1}] AUDITOR  running..." -f
                    $Round,
                    $State.max_rounds
                )

                $Execution = Read-JsonFile `
                    -Path $ExecutionPath `
                    -Description "ExecutionReport"

                if (
                    -not (Test-JsonProperty -Object $Execution -Name "status") -or
                    [string]$Execution.status -ne "COMPLETED"
                ) {
                    throw "Auditor requires a COMPLETED execution report."
                }

                Sync-ControlPlaneToWorktree -Worktree $Worktree

                $State.status = "RUNNING"
                $State.last_error = $null
                Save-State -State $State

                $Result = Invoke-Auditor `
                    -Worktree $Worktree `
                    -Scopes $Scopes

                if ($Result.ExitCode -ne 0) {
                    Throw-ProcessFailure `
                        -Result $Result `
                        -StageName "Auditor"
                }

                $Audit = Assert-AuditUsable
                Sync-ArtifactToWorktree -Worktree $Worktree -Name "audit.json"

                $IssueCount = @($Audit.issues).Count

                Write-Host (
                    "                completed in {0} | verdict: {1} | issues: {2}" -f
                    (Format-Duration -Elapsed $Result.Elapsed),
                    $Audit.verdict,
                    $IssueCount
                )

                if ([string]$Audit.verdict -eq "PASS") {
                    $ChangedPaths = Assert-CumulativeAuthorization `
                        -Worktree $Worktree `
                        -BaselineCommit ([string]$State.baseline_commit) `
                        -CandidateCommit ([string]$State.candidate_commit) `
                        -AuthorizedHistory @($State.authorized_write_history)

                    Write-CumulativeCandidatePatch `
                        -Worktree $Worktree `
                        -BaselineCommit ([string]$State.baseline_commit) `
                        -CandidateCommit ([string]$State.candidate_commit) `
                        -OutputPath $ApprovedPatchPath

                    if ($ApplyOnPass) {
                        Apply-CandidateToMain `
                            -BaselineCommit ([string]$State.baseline_commit) `
                            -PatchPath $ApprovedPatchPath `
                            -ChangedPaths $ChangedPaths
                    }

                    $State.status = "COMPLETED"
                    $State.next_stage = "NONE"
                    $State.last_error = $null
                    Save-State -State $State

                    Archive-Round `
                        -RunId $State.run_id `
                        -Round $Round

                    Write-Host ""
                    Write-Host "============================================================"
                    Write-Host " PASS"
                    Write-Host "============================================================"
                    Write-Host ("Run:           {0}" -f $State.run_id)
                    Write-Host ("Changed files: {0}" -f (@($ChangedPaths).Count))
                    Write-Host ("Candidate:     {0}" -f $Worktree)
                    Write-Host ("Approved diff: {0}" -f $ApprovedPatchPath)

                    if ($ApplyOnPass) {
                        Write-Host "Main repo:     approved changes applied"
                    }
                    else {
                        Write-Host "Main repo:     untouched"
                    }

                    Write-Host ("Summary:       {0}" -f $Audit.summary)
                    Write-Host ""

                    if ($CleanupWorktreeOnPass) {
                        Remove-IsolatedWorktree -Worktree $Worktree
                        Write-Host "Isolated worktree removed."
                    }

                    exit 0
                }

                Write-Host ""
                Write-Host "AUDIT ISSUES:"

                foreach ($Issue in @($Audit.issues)) {
                    $File = [string]$Issue.file

                    if ([string]::IsNullOrWhiteSpace($File)) {
                        $File = "(candidate)"
                    }

                    Write-Host (
                        "  [{0}] {1}" -f
                        $Issue.severity,
                        $File
                    )

                    Write-Host ("    {0}" -f $Issue.issue)
                }

                $State.round = $Round + 1
                Reset-EditorRoundState -State $State
                $State.next_stage = "ANALYST"

                # Auditor feedback supersedes prior Editor feedback.
                Set-Content `
                    -LiteralPath $EditorFeedbackPath `
                    -Value "{}" `
                    -Encoding utf8

                if ([int]$State.round -gt [int]$State.max_rounds) {
                    $State.status = "MAX_ROUNDS_REACHED"
                }
                else {
                    $State.status = "RUNNING"
                }

                Save-State -State $State

                Archive-Round `
                    -RunId $State.run_id `
                    -Round $Round

                if ([string]$State.status -eq "MAX_ROUNDS_REACHED") {
                    Write-Host ""
                    Write-Host "Maximum audit rounds reached."
                    Write-Host (
                        "Resume with a larger limit, e.g. " +
                        ".\scripts\docflow.ps1 -Resume -MaxRounds 7"
                    )

                    exit 2
                }

                Write-Host ""
                Write-Host (
                    "Reanalyzing automatically in round {0}..." -f
                    $State.round
                )

                continue
            }

            "NONE" {
                $State.status = "COMPLETED"
                Save-State -State $State
                exit 0
            }

            default {
                throw "Unknown workflow stage: $Stage"
            }
        }
    }

    $State.status = "MAX_ROUNDS_REACHED"
    Save-State -State $State
    exit 2
}
catch {
    if ($null -ne $State) {
        try {
            if (
                [string]$State.status -notin @(
                    "COMPLETED",
                    "MAX_ROUNDS_REACHED",
                    "BLOCKED"
                )
            ) {
                Set-StateError `
                    -State $State `
                    -Message $_.Exception.Message
            }
        }
        catch {
            # Preserve original exception.
        }
    }

    throw
}
