# Dust Heist

A Godot 4 western arena survival prototype. The current build is a fast, lethal courthouse ambush game with one-hit player tension, saber and revolver combat, outlaw skills, human enemy archetypes, and persistent blood on the sand.

## Current Prototype

- Bright sandy courtyard arena surrounded by old-west buildings
- One-hit player with dash movement and close-range saber parries
- Wave-based survival with knife rushers, riflemen, shotgun brutes, and duelist minibosses
- Duelist intro cards with wind and leaf motion
- Western skill set: Deadeye, Ricochet Shot, Dust Veil, and Quickdraw
- Permanent upgrade system with 15 purchasable character benefits
- Upgrade tokens earned from completed quests and rival duelist boss defeats
- Dust Heist information menu for controls, weapons, enemies, and run goals
- Persistent blood stains and grounded dust/weapon effects
- Local JSON save for credits and run count

## Controls

- Move: WASD, arrow keys, or touch-drag
- Dash: Space
- Sword slash: J or left mouse
- Deadeye: 1
- Ricochet Shot: 2
- Dust Veil: 3
- Quickdraw: 4
- Restart after failure: any key

## Run It

Open this folder in Godot 4 and run `scenes/Main.tscn`.

You can validate the project from the terminal with:

```bash
.tools/godot/Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit
```

## Supabase

This project is pinned to Aimbotic's Supabase project `uotzmpttpekpkcjxurjj` at `https://uotzmpttpekpkcjxurjj.supabase.co`.

Copy `.env.example` for local environment values. The Godot autoload `SupabaseConfig` only enables Supabase when `SUPABASE_URL` exactly matches the pinned Aimbotic project URL. The Trusted Bums project ref `vaoqvtxqvbptyxddpoju` is explicitly blocked and must not be used.

See `docs/supabase.md` for the project pin and connection guard contract.

## Performance Tools

Run the game with a live overlay and one-second perf logs:

```bash
.tools/godot/godot --log-file /tmp/dust-heist-live-perf.log --path . -- --dust-perf-overlay --dust-perf-log
```

Press F3 while playing to toggle the overlay.

Run with memory snapshots around menu load/release and once per second:

```bash
.tools/godot/godot --log-file /tmp/dust-heist-memory.log --path . -- --dust-memory-log
```

Repeatable perf checks:

```bash
.tools/godot/godot --headless --log-file /tmp/dust-heist-menu-perf.log --path . -- --dust-menu-performance-test
.tools/godot/godot --headless --log-file /tmp/dust-heist-combat-perf.log --path . -- --dust-performance-test
.tools/godot/godot --headless --log-file /tmp/dust-heist-heavy-perf.log --path . -- --dust-heavy-combat-performance-test
```

## Play From GitHub Pages

This repo includes a GitHub Actions workflow at `.github/workflows/pages.yml` that exports the Godot project to Web and deploys it to GitHub Pages whenever `main` is pushed.

You can test the same export locally with:

```bash
mkdir build\web
.tools/godot/Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html
```

## Important Files

- `scenes/Main.tscn`: boot scene
- `scripts/game/main.gd`: run orchestration, wave spawning, and arena rendering
- `scripts/game/vault_generator.gd`: arena layout data
- `scripts/game/game_director.gd`: danger escalation model
- `scripts/player/player.gd`: movement, one-hit health, sword attacks, parry, and mobile drag input
- `scripts/enemies/`: outlaw enemy behaviors
- `scripts/systems/program_system.gd`: western skill catalog, cooldowns, and casts
- `scripts/systems/vfx_layer.gd`: blood, dust, weapon trails, and rifle traces
- `scripts/ui/hud.gd`: in-game HUD and duelist intro cards

## Next Build Priorities

1. Add score/combo ranks for stylish wave clears.
2. Add named duelist variants with different attack patterns.
3. Add revolver ammo and reload loops.
4. Add sound effects, music stingers, and stronger hit freeze.
