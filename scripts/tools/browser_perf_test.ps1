param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [int]$ServerPort = 9021,
    [int]$DebugPort = 9223
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $repoRoot

if (-not (Test-Path $ChromePath)) {
    $edgePath = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
    if (Test-Path $edgePath) {
        $ChromePath = $edgePath
    } else {
        throw "Browser executable not found: $ChromePath"
    }
}

if (-not (Test-Path "build\web\index.html")) {
    throw "Web export not found. Run the Godot Web export before browser performance testing."
}

node scripts\tools\browser_perf_probe.js $ChromePath $ServerPort $DebugPort
exit $LASTEXITCODE
