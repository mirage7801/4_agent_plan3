param(
    [Parameter(Mandatory = $true)][string]$ProblemPath,
    [Parameter(Mandatory = $true)][string]$OutputDir,
    [string]$ConfigPath = "$PSScriptRoot\config\experiment.example.json"
)

$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot
python -m agent.cli run --problem $ProblemPath --config $ConfigPath --output $OutputDir
exit $LASTEXITCODE
