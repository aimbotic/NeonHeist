param(
    [string]$GoalFile = "docs\agent_goal.md",
    [switch]$PrintOnly
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $repoRoot

if (-not (Test-Path $GoalFile)) {
    throw "Goal file not found: $GoalFile"
}

$goal = Get-Content $GoalFile -Raw
$prompt = @"
Run the Dust Heist build agent.

Read AGENTS.md, README.md, docs/art_bible.md, and the active goal below. Choose one focused improvement that advances the goal, implement it in the Godot project, validate it with the bundled Godot console command, and update docs/agent_progress.md with the result and next recommended step.

Active goal file:

$goal
"@

if ($PrintOnly -or -not (Get-Command codex -ErrorAction SilentlyContinue)) {
    $prompt
    exit 0
}

codex $prompt
