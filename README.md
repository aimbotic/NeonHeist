# Neon Heist

A Godot 4 prototype for an offline-first cyberpunk roguelike infiltration game. The current build is a code-native vertical prototype: one main scene creates the vault, player, enemies, programs, HUD, saves, and neon VFX at runtime.

## Current Prototype

- Procedural room-and-corridor vault generation
- Top-down player movement with dash invulnerability
- Touch-drag movement support for mobile testing
- Hack nodes that award loot and unlock additional programs
- Extraction unlock after three hacked nodes or lockdown
- Alert escalation director with enemy pressure scaling
- Three enemy types: patrol drones, hunters, and turrets
- Ten-program catalog with three starter casts implemented
- Chain reaction hazards and screen-space neon effects
- Local JSON save for credits and run count

## Controls

- Move: WASD, arrow keys, or touch-drag
- Dash: Space
- Weapon slash: J or left mouse
- Hack: E near a square node
- Program 1, EMP Blast: 1
- Program 2, Chain Lightning: 2
- Program 3, Time Slow: 3
- Restart after extraction or failure: any key

## Run It

Open this folder in Godot 4 and run `scenes/Main.tscn`.

A portable Godot 4 binary is installed locally at `.tools/godot/Godot_v4.6.2-stable_linux.x86_64`. You can validate the project from the terminal with:

```bash
.tools/godot/Godot_v4.6.2-stable_linux.x86_64 --headless --path . --quit
```


## Play From GitHub Pages

This repo includes a GitHub Actions workflow at `.github/workflows/pages.yml` that exports the Godot project to Web and deploys it to GitHub Pages whenever `main` is pushed.

After pushing the repo, set GitHub Pages to use **GitHub Actions** as its source in the repository Pages settings. The workflow will publish the playable build from `build/web`.

You can test the same export locally with:

```bash
mkdir -p build/web
.tools/godot/Godot_v4.6.2-stable_linux.x86_64 --headless --path . --export-release Web build/web/index.html
```

## Important Files

- `scenes/Main.tscn`: boot scene
- `scripts/game/main.gd`: run orchestration and rendering
- `scripts/game/vault_generator.gd`: deterministic vault layout generation
- `scripts/game/game_director.gd`: alert and escalation model
- `scripts/player/player.gd`: movement, dash, health, mobile drag input
- `scripts/enemies/`: enemy behaviors
- `scripts/systems/program_system.gd`: ability catalog, cooldowns, casts
- `scripts/systems/vfx_layer.gd`: neon pulses, beams, shockwaves
- `scripts/ui/hud.gd`: readable-chaos HUD

## Next Build Priorities

1. Add collision walls and nav constraints so enemies and players respect room geometry.
2. Convert procedural visuals into TileMap/TileSet layers once the look settles.
3. Implement the remaining seven programs beyond unlock metadata.
4. Add iOS export settings, haptics, and proper virtual controls.
5. Add save encryption or obfuscation before production.
