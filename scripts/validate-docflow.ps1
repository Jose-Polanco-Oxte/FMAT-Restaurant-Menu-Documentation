#requires -Version 7.0

[CmdletBinding()]
param()

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

$Root = [System.IO.Path]::GetFullPath(
    (Split-Path -Parent $PSScriptRoot)
)

$ScriptPath = Join-Path $PSScriptRoot "docflow.ps1"
$RequiredFiles = @(
    "AGENTS.md",
    ".agents/agents/documentation-editor/agent.md",
    ".ai/prompts/analyst.md",
    ".ai/prompts/auditor.md",
    ".ai/schemas/integration-plan.schema.json",
    ".ai/schemas/execution-report.schema.json",
    ".ai/schemas/audit-report.schema.json",
    "scripts/docflow.ps1"
)

Write-Host "Validating Docflow V5.2.1..."

# 1) Parse the PowerShell script using PowerShell's own parser.
$Tokens = $null
$ParseErrors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile(
    $ScriptPath,
    [ref]$Tokens,
    [ref]$ParseErrors
)

if (@($ParseErrors).Count -gt 0) {
    Write-Host ""
    Write-Host "PowerShell parser errors:"
    foreach ($ErrorItem in @($ParseErrors)) {
        Write-Host (
            "  Line {0}, Column {1}: {2}" -f
            $ErrorItem.Extent.StartLineNumber,
            $ErrorItem.Extent.StartColumnNumber,
            $ErrorItem.Message
        )
    }
    throw "docflow.ps1 contains PowerShell syntax errors."
}

Write-Host "  [PASS] PowerShell parser"

# 2) Required files.
foreach ($Relative in $RequiredFiles) {
    $Path = Join-Path $Root $Relative
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing required file: $Relative"
    }
}
Write-Host "  [PASS] Required harness files"

# 3) JSON schemas.
foreach ($Relative in @(
    ".ai/schemas/integration-plan.schema.json",
    ".ai/schemas/execution-report.schema.json",
    ".ai/schemas/audit-report.schema.json"
)) {
    $Path = Join-Path $Root $Relative
    $null = Get-Content -LiteralPath $Path -Raw -Encoding utf8 |
        ConvertFrom-Json -ErrorAction Stop
}
Write-Host "  [PASS] JSON schemas parse"

# 4) Profile / version contract.
$EditorProfile = Get-Content `
    -LiteralPath (Join-Path $Root ".agents/agents/documentation-editor/agent.md") `
    -Raw `
    -Encoding utf8

if ($EditorProfile -notmatch 'DOCUMENTATION_EDITOR_V5_2') {
    throw "Editor profile identifier DOCUMENTATION_EDITOR_V5_2 is missing."
}
Write-Host "  [PASS] Editor profile identifier"

# 5) PowerShell collection semantics used by the harness.
$One = @("single") | Where-Object { $_ }
if (@($One).Count -ne 1) {
    throw "StrictMode collection count self-test failed for singleton."
}

$None = @("single") | Where-Object { $false }
if (@($None).Count -ne 0) {
    throw "StrictMode collection count self-test failed for empty output."
}
Write-Host "  [PASS] StrictMode collection semantics"

# 6) Static anti-regression checks for the bug that triggered V5.2.
$RawScript = Get-Content -LiteralPath $ScriptPath -Raw -Encoding utf8

$UnsafeCount = [regex]::Matches(
    $RawScript,
    '(?m)(?<!@\()\$[A-Za-z_][A-Za-z0-9_]*\.Count'
)

if (@($UnsafeCount).Count -gt 0) {
    $Examples = @($UnsafeCount | Select-Object -First 10 | ForEach-Object { $_.Value })
    throw (
        "Unsafe scalar .Count usage found: " +
        ($Examples -join ', ')
    )
}

$UnsafeArrayPipeline = [regex]::Matches(
    $RawScript,
    '\)\s*\|\s*Where-Object'
)

if (@($UnsafeArrayPipeline).Count -gt 0) {
    throw "Found a ') | Where-Object' pattern. Wrap the complete pipeline inside @(...)."
}

Write-Host "  [PASS] Static collection anti-regression checks"

# 7) Real Git checkpoint smoke test using the same portable sequence as docflow.
$TempRepo = Join-Path (
    [System.IO.Path]::GetTempPath(),
    ("docflow-checkpoint-smoke-" + [guid]::NewGuid().ToString("N"))
)

try {
    New-Item -ItemType Directory -Force -Path $TempRepo | Out-Null

    $InitOutput = @(
        & git -C "$TempRepo" init 2>&1
    )
    if ($LASTEXITCODE -ne 0) {
        throw (
            "Git checkpoint smoke test could not initialize temp repo: " +
            (($InitOutput | ForEach-Object { [string]$_ }) -join "`n")
        )
    }

    & git -C "$TempRepo" config user.name "Docflow Validator" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not configure temp Git user.name." }

    & git -C "$TempRepo" config user.email "docflow-validator@local.invalid" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not configure temp Git user.email." }

    Set-Content `
        -LiteralPath (Join-Path $TempRepo "baseline.txt") `
        -Value "baseline" `
        -Encoding utf8

    & git -C "$TempRepo" add -A -- . | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not stage temp baseline." }

    & git -C "$TempRepo" commit -m "baseline" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not commit temp baseline." }

    New-Item `
        -ItemType Directory `
        -Force `
        -Path (Join-Path $TempRepo ".ai/current") |
        Out-Null

    New-Item `
        -ItemType Directory `
        -Force `
        -Path (Join-Path $TempRepo ".ai/runs") |
        Out-Null

    Set-Content `
        -LiteralPath (Join-Path $TempRepo ".ai/current/request.md") `
        -Value "runtime" `
        -Encoding utf8

    Set-Content `
        -LiteralPath (Join-Path $TempRepo ".ai/runs/archive.txt") `
        -Value "runtime" `
        -Encoding utf8

    Set-Content `
        -LiteralPath (Join-Path $TempRepo "candidate.txt") `
        -Value "candidate" `
        -Encoding utf8

    $StageOutput = @(
        & git -C "$TempRepo" add -A -- . 2>&1
    )
    if ($LASTEXITCODE -ne 0) {
        throw (
            "Portable checkpoint git add failed: " +
            (($StageOutput | ForEach-Object { [string]$_ }) -join "`n")
        )
    }

    $UnstageOutput = @(
        & git -C "$TempRepo" reset -q HEAD -- ".ai/current" ".ai/runs" 2>&1
    )
    if ($LASTEXITCODE -ne 0) {
        throw (
            "Portable checkpoint runtime unstage failed: " +
            (($UnstageOutput | ForEach-Object { [string]$_ }) -join "`n")
        )
    }

    $CommitOutput = @(
        & git -C "$TempRepo" commit --allow-empty -m "candidate checkpoint" 2>&1
    )
    if ($LASTEXITCODE -ne 0) {
        throw (
            "Portable checkpoint commit failed: " +
            (($CommitOutput | ForEach-Object { [string]$_ }) -join "`n")
        )
    }

    $CommittedCandidate = @(
        & git -C "$TempRepo" ls-tree -r --name-only HEAD 2>&1
    )
    if ($LASTEXITCODE -ne 0) {
        throw "Could not inspect temp checkpoint commit."
    }

    if (
        @($CommittedCandidate | Where-Object { $_ -eq "candidate.txt" }).Count -ne 1
    ) {
        throw "Checkpoint smoke test did not commit candidate.txt."
    }

    if (
        @($CommittedCandidate | Where-Object { $_ -like ".ai/current/*" -or $_ -like ".ai/runs/*" }).Count -gt 0
    ) {
        throw "Checkpoint smoke test committed runtime control state."
    }
}
finally {
    if (Test-Path -LiteralPath $TempRepo) {
        Remove-Item `
            -LiteralPath $TempRepo `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}

Write-Host "  [PASS] Git checkpoint smoke test"
Write-Host ""
Write-Host "Docflow V5.2.1 validation PASS."