param(
    [string]$GodotPath = ".\.tools\godot\Godot_v4.6.2-stable_win64_console.exe",
    [switch]$ImportFirst
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $repoRoot

if (-not (Test-Path $GodotPath)) {
    throw "Godot console executable not found: $GodotPath"
}

if ($ImportFirst) {
    & $GodotPath --headless --path . --import
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

& $GodotPath --headless --path . -- --dust-smoke-test
exit $LASTEXITCODE
