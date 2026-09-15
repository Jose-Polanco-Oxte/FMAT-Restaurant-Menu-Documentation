param(
    [Parameter(Mandatory = $true)]
    [string]$Request,

    [int]$MaxRounds = 3
)

$ErrorActionPreference = "Stop"

$Root = (Get-Location).Path
$Current = Join-Path $Root ".ai\current"
$Runs = Join-Path $Root ".ai\runs"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $Current |
    Out-Null

New-Item `
    -ItemType Directory `
    -Force `
    -Path $Runs |
    Out-Null

$RunId = Get-Date -Format "yyyyMMdd-HHmmss"

Set-Content `
    -Path "$Current\request.md" `
    -Value $Request `
    -Encoding utf8

Set-Content `
    -Path "$Current\plan.json" `
    -Value "{}" `
    -Encoding utf8

Set-Content `
    -Path "$Current\execution.json" `
    -Value "{}" `
    -Encoding utf8

Set-Content `
    -Path "$Current\audit.json" `
    -Value "{}" `
    -Encoding utf8

Set-Content `
    -Path "$Current\changes.patch" `
    -Value "" `
    -Encoding utf8


for ($Round = 1; $Round -le $MaxRounds; $Round++) {

    Write-Host ""
    Write-Host "========================================"
    Write-Host " ROUND $Round / $MaxRounds"
    Write-Host "========================================"

    # =====================================================
    # ASTRA
    # =====================================================

    Write-Host ""
    Write-Host ">>> ASTRA: ANALYZE"

    $AstraPrompt = @"
Read and follow:

- AGENTS.md
- .ai/prompts/astra-analyst.md
- .ai/current/request.md

Inspect the repository as necessary.

If .ai/current/audit.json contains a previous FAIL audit,
use it as feedback and analyze the CURRENT repository state.

Do not modify repository documentation.

Return ONLY an IntegrationPlan matching:

.ai/schemas/integration-plan.schema.json
"@

    & codex exec `
        --model gpt-6-astra `
        --sandbox read-only `
        --config 'model_reasoning_effort="high"' `
        --output-schema ".ai/schemas/integration-plan.schema.json" `
        --output-last-message ".ai/current/plan.json" `
        $AstraPrompt

    if ($LASTEXITCODE -ne 0) {
        throw "Astra execution failed."
    }

    try {
        $Plan = Get-Content `
            "$Current\plan.json" `
            -Raw |
            ConvertFrom-Json
    }
    catch {
        throw "Astra returned invalid IntegrationPlan JSON."
    }

    if ($null -eq $Plan.change_id) {
        throw "Astra IntegrationPlan is missing change_id."
    }

    if ($Plan.blockers.Count -gt 0) {

        Write-Host ""
        Write-Host "ASTRA BLOCKED THE INTEGRATION:"
        Write-Host ""

        foreach ($Blocker in $Plan.blockers) {
            Write-Host " - $Blocker"
        }

        exit 3
    }


    # =====================================================
    # FLASH
    # =====================================================

    Write-Host ""
    Write-Host ">>> GEMINI 3.8 FLASH: EXECUTE"

    $FlashPrompt = @"
Read and follow:

- AGENTS.md
- .ai/prompts/flash-editor.md
- .ai/current/request.md
- .ai/current/plan.json

Execute the IntegrationPlan against the repository.

The plan may contain CREATE, MODIFY, DELETE and VERIFY operations.

Do not make new semantic decisions.

Return ONLY the structured ExecutionReport requested by the schema.
"@

    $FlashRaw = & agy `
        -p $FlashPrompt `
        --model gemini-3.8-flash-medium `
        --agent documentation-editor `
        --mode=accept-edits `
        --output-format json `
        --json-schema ".ai/schemas/execution-report.schema.json" `
        --print-timeout 15m

    if ($LASTEXITCODE -ne 0) {
        throw "Gemini 3.8 Flash execution failed."
    }

    try {
        $FlashEnvelope = $FlashRaw | ConvertFrom-Json
    }
    catch {
        throw "Antigravity returned invalid JSON."
    }

    if ($FlashEnvelope.status -ne "SUCCESS") {
        throw "Antigravity execution status: $($FlashEnvelope.status)"
    }

    if ($null -eq $FlashEnvelope.structured_output) {
        throw "Flash did not return structured_output."
    }

    $FlashEnvelope.structured_output |
        ConvertTo-Json -Depth 100 |
        Set-Content `
            "$Current\execution.json" `
            -Encoding utf8

    $Execution = Get-Content `
        "$Current\execution.json" `
        -Raw |
        ConvertFrom-Json

    if ($Execution.status -eq "BLOCKED") {

        Write-Host ""
        Write-Host "FLASH REPORTED BLOCKERS:"
        Write-Host ""

        foreach ($Blocker in $Execution.blockers) {
            Write-Host " - $Blocker"
        }

        exit 4
    }


    # =====================================================
    # CAPTURE CHANGES
    # =====================================================

    Write-Host ""
    Write-Host ">>> CAPTURING REPOSITORY CHANGES"

    & "$PSScriptRoot\capture-doc-changes.ps1" `
        -OutputPath "$Current\changes.patch"

    if ($LASTEXITCODE -ne 0) {
        throw "Could not capture repository changes."
    }


    # =====================================================
    # LUNA
    # =====================================================

    Write-Host ""
    Write-Host ">>> LUNA: AUDIT"

    $LunaPrompt = @"
Read and follow:

- AGENTS.md
- .ai/prompts/luna-auditor.md
- .ai/current/request.md
- .ai/current/plan.json
- .ai/current/execution.json
- .ai/current/changes.patch

Inspect the actual repository independently.

Do not modify repository files.

Audit both:
1. execution quality
2. completeness of Astra's impact analysis

Return ONLY an AuditReport matching:

.ai/schemas/audit-report.schema.json
"@

    & codex exec `
        --model gpt-5.6-luna `
        --sandbox read-only `
        --config 'model_reasoning_effort="high"' `
        --output-schema ".ai/schemas/audit-report.schema.json" `
        --output-last-message ".ai/current/audit.json" `
        $LunaPrompt

    if ($LASTEXITCODE -ne 0) {
        throw "Luna execution failed."
    }

    try {
        $Audit = Get-Content `
            "$Current\audit.json" `
            -Raw |
            ConvertFrom-Json
    }
    catch {
        throw "Luna returned invalid AuditReport JSON."
    }


    # =====================================================
    # ARCHIVE ROUND
    # =====================================================

    $RoundDir = Join-Path `
        $Runs `
        "$RunId\round-$Round"

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $RoundDir |
        Out-Null

    Copy-Item `
        "$Current\request.md" `
        "$RoundDir\request.md"

    Copy-Item `
        "$Current\plan.json" `
        "$RoundDir\plan.json"

    Copy-Item `
        "$Current\execution.json" `
        "$RoundDir\execution.json"

    Copy-Item `
        "$Current\changes.patch" `
        "$RoundDir\changes.patch"

    Copy-Item `
        "$Current\audit.json" `
        "$RoundDir\audit.json"


    # =====================================================
    # VERDICT
    # =====================================================

    if ($Audit.verdict -eq "PASS") {

        Write-Host ""
        Write-Host "========================================"
        Write-Host " DOCUMENTATION FLOW: PASS"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "Run:"
        Write-Host ""
        Write-Host "  git diff"
        Write-Host ""
        Write-Host "to review the final repository changes."

        exit 0
    }

    Write-Host ""
    Write-Host "AUDIT RESULT: FAIL"
    Write-Host ""

    foreach ($Issue in $Audit.issues) {
        Write-Host "[$($Issue.severity)] $($Issue.file)"
        Write-Host "  $($Issue.issue)"
        Write-Host ""
    }

    Write-Host "Sending audit feedback back to Astra..."
}


Write-Host ""
Write-Host "========================================"
Write-Host " MAXIMUM AUDIT ROUNDS REACHED"
Write-Host "========================================"

exit 2