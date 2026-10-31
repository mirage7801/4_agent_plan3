param(
    [Parameter(Mandatory = $true)][string]$ProblemPath,
    [Parameter(Mandatory = $true)][string]$OutputDir,
    [string]$ConfigPath = "$PSScriptRoot\config\experiment.example.json",
    [string]$RunId
)

$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

# Preflight is the configuration/asset gate. It is offline and must pass
# before a model or Vivado process is started.
python scripts/preflight.py --problem $ProblemPath --config $ConfigPath --output $OutputDir --json
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$agentArgs = @("-m", "agent.cli", "run", "--problem", $ProblemPath, "--config", $ConfigPath, "--output", $OutputDir)
if ($RunId) { $agentArgs += @("--run-id", $RunId) }
python @agentArgs
exit $LASTEXITCODE
