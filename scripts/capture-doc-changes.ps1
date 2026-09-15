param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"

$TrackedDiff = git diff -- `
    . `
    ':(exclude).ai/**'

$UntrackedFiles = @(
    git ls-files --others --exclude-standard |
    Where-Object {
        $_ -notlike ".ai/*"
    }
)

$Builder = New-Object System.Text.StringBuilder

[void]$Builder.AppendLine("=== TRACKED CHANGES ===")
[void]$Builder.AppendLine()

if ($TrackedDiff) {
    [void]$Builder.AppendLine(($TrackedDiff -join "`n"))
}
else {
    [void]$Builder.AppendLine("(none)")
}

[void]$Builder.AppendLine()
[void]$Builder.AppendLine("=== UNTRACKED / NEW FILES ===")
[void]$Builder.AppendLine()

if ($UntrackedFiles.Count -eq 0) {
    [void]$Builder.AppendLine("(none)")
}
else {
    foreach ($File in $UntrackedFiles) {

        [void]$Builder.AppendLine("=== NEW FILE: $File ===")

        if (Test-Path $File -PathType Leaf) {
            $Content = Get-Content $File -Raw
            [void]$Builder.AppendLine($Content)
        }
        else {
            [void]$Builder.AppendLine("(unable to read file)")
        }

        [void]$Builder.AppendLine("=== END NEW FILE: $File ===")
        [void]$Builder.AppendLine()
    }
}

$Builder.ToString() |
    Set-Content `
        -Path $OutputPath `
        -Encoding utf8