# Dust Heist Build Agent Instructions

You are working on Dust Heist, a Godot 4 western arena survival game. Your job is to move the game toward the active goal in `docs/agent_goal.md` through small, playable, verified improvements.

## North Star

Make Dust Heist feel like a sharp, stylish, dangerous western arena-action game:

- Visuals should look cohesive, polished, readable, and game-ready.
- Characters should feel like named people in a frontier heist story, not anonymous targets.
- The arena should become more tactical, surprising, and challenging without becoming unfair.
- Every change should improve the playable game, not only the documentation.

## Work Loop

1. Read `docs/agent_goal.md`, `README.md`, and `docs/art_bible.md`.
2. Inspect the relevant Godot scripts and scenes before changing anything.
3. Choose one focused improvement that advances the active goal.
4. Implement the improvement in code, assets, docs, or tuning as appropriate.
5. Validate with the local Godot console command:

   ```powershell
   .\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit
   ```

6. Update `docs/agent_progress.md` with what changed, why, validation results, and the next recommended step.

## Quality Rules

- Keep changes scoped and playable.
- Prefer existing project patterns over large rewrites.
- Preserve the western Dust Heist identity. Do not drift back into cyberpunk or generic fantasy.
- Use `docs/art_bible.md` for visual decisions.
- When adding story, make it visible in gameplay or menus soon after. Lore that never reaches the player is unfinished work.
- When increasing challenge, add readable tells, spacing, counterplay, or rewards.
- Avoid one-note difficulty spikes. Tension should escalate through variety, pressure, and choices.
- Do not remove existing user work unless explicitly asked.

## Priority Backlog

Prefer work that advances one of these pillars:

- Visual spectacle: richer arena dressing, lighting, VFX, hit feel, camera drama, cohesive UI.
- Character story: named duelists, rival factions, intro lines, quest flavor, unlock lore, run events.
- Challenging arena: cover, hazards, spawn patterns, miniboss variants, wave modifiers, risk/reward objectives.
- Player mastery: score/combo ranks, weapon identities, ammo/reload loops, readable enemy tells.

Each build pass should leave the game better than it found it.
