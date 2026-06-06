# Running The Dust Heist Build Agent

The build agent is a repeatable Codex workflow for improving Dust Heist one focused pass at a time.

## Set A Goal

Edit `docs/agent_goal.md`. Put the most important outcome under `Active Goal`, then list the next few focus areas.

Good goals:

- "Make duelists feel like named rivals with distinct attacks and story flavor."
- "Make the arena more tactical with cover, hazards, and clearer enemy pressure."
- "Make combat feel more cinematic with VFX, camera, hit freeze, and HUD polish."

## Start A Build Pass

Ask Codex:

```text
Run the Dust Heist build agent. Read AGENTS.md and docs/agent_goal.md, choose one focused improvement, implement it, validate it, and update docs/agent_progress.md.
```

## Agent Contract

Each pass should:

- Read the active goal.
- Choose one high-impact improvement.
- Change the actual Godot project.
- Validate with the bundled Godot console executable.
- Log progress and the next recommended step.

## Validation Command

```powershell
.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit
```

## Optional Web Export

```powershell
New-Item -ItemType Directory -Force build\web
.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html
```
