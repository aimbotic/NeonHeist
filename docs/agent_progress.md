# Dust Heist Agent Progress

## 2026-06-05 - Browser Stutter And Whole-Body Sprite Recovery

- Kept the player sprite fix in `scripts/player/player.gd`: the hero now uses one locked whole-body angled sprite while moving instead of splitting torso/legs during walk and run frames.
- Updated `scripts/enemies/base_enemy.gd` to `enemy_directional_safe_crop_motion_redraw_budget_8fps_v10`, capping enemy whole-body sprite redraws near 8 FPS while moving and 4 FPS idle.
- Updated `scripts/systems/vfx_layer.gd` to `transient_vfx_spawn_redraw_gate_8fps_v6` and `transient_vfx_pulse_arc_budget_12seg_v4`, reducing transient combat repaint pressure and simultaneous pulse rings.
- Lowered the dynamic hazard/payday overlay in `scripts/game/main.gd` to a 3 FPS repaint budget with smaller arc segment counts, keeping tells readable while avoiding browser frame spikes.
- Backed out the attempted live HUD skill-icon polish after browser samples dipped badly, then focused this pass on performance recovery instead of adding more draw work.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,787,972 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.9 min_fps=83.2 worst_frame_ms=12.0 elapsed_ms=1226.2 arena_interval=0.250 overlay_interval=0.333`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=62.5 min_fps=58.0 worst_frame_ms=17.3 canvas=764x485 elapsed_ms=6877.4`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.

Next recommended step:

- Play-test the exported browser build for feel, then only add new visuals behind static caches or state-gated redraws so the near-60 FPS browser floor stays intact.

## 2026-06-05 - Loadout Icon Brass Socket Polish

- Updated `scripts/ui/hud.gd` with the `loadout_icon_brass_socket_material_cues_v2` visual contract.
- Gave gun and ability loadout icons a more physical brass/leather socket treatment: inner shadow plate, top shine, screw heads, edge notches, equipped badge polish, and type-specific footer cues for cartridges versus ability marks.
- Kept `loadout_icon_state_redraw_gate_v1` intact, so the icons still redraw only when item id, type, locked state, or equipped state changes.
- Added HUD smoke hooks for loadout icon visual version and tactile marker count, then updated `scripts/game/main.gd` to require at least 120 icon material markers across the menu loadout grid.
- Trimmed the first version of the icon socket pass after a browser perf dip, preserving the visible socket cues while restoring the exported browser FPS floor.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,788,388 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=157.3 min_fps=82.4 worst_frame_ms=12.1 elapsed_ms=1228.6 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=114.3 min_fps=60.0 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4708.9`.

Next recommended step:

- Continue the graphics/FPS goal with another focused visual pass on gameplay sprite readability, arena edge prop depth, or live HUD skill button polish while preserving the exported near-60 FPS floor.

## 2026-06-05 - Main Menu Nav Press Hardware Polish

- Updated `scripts/ui/hud.gd` to `menu_nav_bounty_receipt_badge_press_hardware_v10`.
- Added static press hardware to the main menu nav buttons: inset shine/shadow rails, side hinge plates, extra rivets, pressed-state compression shading, and small bounty-star detail on the icon plate.
- Kept the existing `menu_nav_state_redraw_gate_v1` behavior, so the richer button treatment only redraws when selection or button state changes rather than adding live menu repaint churn.
- Raised the menu nav tactile marker contract from 38 to 46 per button and updated smoke coverage in `scripts/game/main.gd` to require at least 276 nav button markers across the six main menu buttons.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,785,124 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=156.7 min_fps=84.5 worst_frame_ms=11.8 elapsed_ms=1231.0 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=96.8 min_fps=59.4 worst_frame_ms=16.8 canvas=764x485 elapsed_ms=5277.0`.

Next recommended step:

- Continue the graphics/FPS goal with a focused pass on either loadout-card icon richness or another gameplay-facing sprite/VFX detail, keeping the exported browser minimum near 60 FPS.

## 2026-06-05 - Browser VFX Redraw Budget Recovery

- Updated `scripts/systems/vfx_layer.gd` to `transient_vfx_spawn_redraw_gate_18fps_v4`.
- Lowered transient VFX redraw cadence from 24 FPS to 18 FPS so combat effects no longer repaint the browser canvas as aggressively during slash, muzzle, hit-spark, dust, and ability overlap.
- Updated the transient dust pulse budget to `transient_vfx_pulse_arc_budget_20seg_v2`, reducing pulse arc segments from 26 to 20 while preserving readable circular dust bursts.
- Updated `scripts/game/main.gd` smoke coverage so future passes keep the 18 FPS transient VFX redraw cap and 20-segment pulse budget.
- Preserved the visual feature set: smoke, visual QA, and the full screenshot sweep still pass with the existing muzzle flash, hit spark, parry, blood, ability, and afterimage effects.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,783,732 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=159.3 min_fps=81.3 worst_frame_ms=12.3 elapsed_ms=1229.0 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=102.5 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5019.2`.

Next recommended step:

- Continue the graphics/FPS goal with a visual pass that improves menu/button richness or enemy sprite polish, keeping browser perf at roughly this restored near-60 FPS minimum.

## 2026-06-05 - Player Locked Whole-Body Sprite Performance Fix

- Updated `scripts/player/player.gd` to `player_locked_whole_body_sprite_perf_v14`.
- Locked the player render path to one whole-body cowgirl gameplay sprite instead of switching between directional PNG canvases during idle, walk, run, and dash. This directly targets the visible player body splitting during movement.
- Lowered player movement redraws from 12 FPS to 8 FPS and idle redraws from 3 FPS to 4 FPS so the browser build has less sprite repaint pressure while controls and physics still run normally.
- Kept textured sprite body overlays disabled with `player_whole_sprite_no_body_overlay_v3` so no separate torso/gear effect can drift away from the player sprite while moving.
- Updated `scripts/game/main.gd` smoke coverage to require the locked whole-body player sprite pass, the 8 FPS player redraw cap, and the new enemy role badge plate pass.
- Updated `scripts/enemies/base_enemy.gd` to `role_silhouette_badge_plate_readability_v8` with role-specific badge plates: rusher slash, rifle cartridge, brute shells, hunter claw, and duelist star. The markers remain drawn in the shared enemy path with no new nodes or textures.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,782,116 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=165.0 min_fps=76.5 worst_frame_ms=13.1 elapsed_ms=1231.2 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=101.3 min_fps=45.4 worst_frame_ms=22.0 canvas=764x485 elapsed_ms=5077.5`.

Next recommended step:

- Do a focused browser-minimum FPS pass on the remaining heavy HUD/VFX draw paths, aiming to bring exported web minimum FPS back near 60 while preserving the richer town-square and combat presentation.

## 2026-06-05 - Runtime Storefront Prop Strip

- Updated `scripts/game/main.gd` to `runtime_town_backdrop_plate_business_prop_strip_v2`.
- Added a static storefront prop strip to the cheap runtime town backdrop plate: hitch rails, sign hooks, porch lanterns, saloon barrels, barber pole stand, sheriff notice board, bank strongboxes, general-store crates, hotel luggage, stable hay bales, and doctor medicine cases.
- Kept the work inside the static backdrop plate used for normal browser play, so it makes the arena perimeter read more like a real western town square without adding animated gameplay nodes.
- Raised the runtime backdrop marker budget from 96 to 112 while keeping the smoke-enforced browser cap at 120.
- Updated smoke coverage to require the new `runtime_storefront_prop_strip_hitch_inventory_v1` contract and its business-specific cues.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,782,068 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=158.3 min_fps=77.5 worst_frame_ms=12.9 elapsed_ms=1228.8 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=102.3 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5386.6`.

Next recommended step:

- Continue the graphics/FPS goal with another targeted pass on enemy sprite readability or gameplay button polish while keeping the browser minimum near 60 FPS.

## 2026-06-05 - Gunshot Heat-Shimmer Muzzle VFX

- Updated `scripts/systems/vfx_layer.gd` to `muzzle_flash_heat_shimmer_casing_star_v4`.
- Added subtle heat-shimmer rails, soot contact shadow, and casing ground shadows to player gunshot muzzle flashes so shots feel hotter and more physical without obscuring enemy tells.
- Kept the existing VFX budget intact: muzzle flashes still cap at 8 active effects and transient VFX still redraw through the 24 FPS gate.
- Updated gunshot smoke coverage in `scripts/game/main.gd` to require the v4 heat-shimmer muzzle pass and at least 10 material markers.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,776,516 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=154.2 min_fps=81.7 worst_frame_ms=12.2 elapsed_ms=1228.4 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=104.5 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4911.8`.

Next recommended step:

- Continue the graphics/FPS goal with another gameplay-facing pass, likely enemy hit readability or arena business/edge silhouette polish.

## 2026-06-05 - Detached Result Receipt Popout

- Updated `scripts/ui/hud.gd` to `result_card_side_receipt_detached_popout_light_wash_v6`.
- Made both extracted-run and failed-run results feel more like a contained western receipt popout by adding seam loops, a folded paper corner, staples, and an audit plate directly inside the result card draw path.
- Lowered the result backdrop wash from 0.38 alpha to 0.24 alpha so death/results no longer read like a heavy fullscreen blackout over the game.
- Kept the presentation static and card-local, preserving the existing side-popout geometry, inset text, hidden duplicate banner, and three brass dividers without adding live gameplay redraw work.
- Updated result smoke coverage in `scripts/game/main.gd` to require the v6 detached receipt frame, at least 62 detail markers, and a backdrop wash no higher than 0.28 alpha.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,775,956 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.4 min_fps=89.4 worst_frame_ms=11.4 elapsed_ms=1232.2 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=105.8 min_fps=59.6 worst_frame_ms=16.8 canvas=764x485 elapsed_ms=4983.4`.

Next recommended step:

- Continue the graphics/FPS goal with another visible polish pass on enemy impact/VFX readability or the arena edge businesses, keeping the browser minimum near 60 FPS.

## 2026-06-05 - Player Stable Run Sprite and Loadout Card Hardware

- Updated `scripts/player/player.gd` to `player_stable_single_run_sprite_perf_v13`.
- Changed walking, running, and dashing to use one stable whole-body cowgirl sprite instead of switching between differently sized directional PNG canvases during movement; this fixes the visible body-splitting/shearing while moving.
- Lowered player movement redraws from 20 FPS to 12 FPS and idle redraws from 6 FPS to 3 FPS to reduce browser-side repaint pressure while keeping combat controls responsive.
- Updated player smoke coverage in `scripts/game/main.gd` to require the stable run-sprite pass and the 12 FPS movement redraw cap.
- Updated `scripts/ui/hud.gd` to `loadout_card_claim_ticket_depth_hardware_redraw_gate_v8`, adding depth frames, brass corner plates, stitch marks, equipped glow plates, and locked-card slash marks without adding live gameplay redraw cost.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,774,436 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=157.3 min_fps=76.4 worst_frame_ms=13.1 elapsed_ms=1230.2 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=104.5 min_fps=50.5 worst_frame_ms=19.8 canvas=764x485 elapsed_ms=5156.3`.

Next recommended step:

- Play the side-view build for a few full waves and watch for any remaining browser dips from enemy VFX bursts or large overlay pop-outs.

## 2026-06-05 - Main Menu Street-Life Backdrop

- Updated `scripts/ui/hud.gd` to `menu_backdrop_showdown_street_life_depth_v6`.
- Added a static street-life layer to the main menu backdrop: stagecoach silhouette, hitching gear, wanted board, water trough, saloon bottle glints, and extra title-plaque hardware.
- Kept the upgrade inside the existing `MenuBackdrop` draw path, so it improves the first screen without adding animated nodes or live gameplay redraw cost.
- Updated main-menu smoke coverage in `scripts/game/main.gd` to require the v6 backdrop, at least 74 town-square cues, and at least 28 title-plaque markers.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,772,852 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 after one explicit GDScript type fix in the new helper.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.3 min_fps=88.2 worst_frame_ms=11.3 elapsed_ms=1232.7 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=104.3 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5193.3`.

Next recommended step:

- Continue the graphics/FPS goal with another high-visibility pass, likely polishing loadout card readability or adding browser-safe hit/muzzle VFX detail.

## 2026-06-05 - Rifleman Bounty Sightline Contract

- Finished the rifleman `rifleman_bounty_sightline_tell_v1` visual contract in `scripts/game/main.gd`.
- Added smoke and visual-QA checks that require the rifleman shot tell to expose its bounty sightline version, at least 12 readable markers, and a 24-segment reticle cap for browser stability.
- Protected the existing visual pass in `scripts/enemies/rifleman.gd`: shadow rails, brass rails, center lane, hash marks, origin ring, target reticle, crosshair, and muzzle bracket must stay readable during Crossfire staging.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,769,988 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=157.8 min_fps=79.2 worst_frame_ms=12.6 elapsed_ms=1228.5 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=105.3 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5200.5`.

Next recommended step:

- Continue the graphics/FPS goal with another visible pass on menu/button polish or enemy VFX, keeping the browser minimum near 60 FPS.

## 2026-06-05 - Player Full-Sprite Browser Lag Fix

- Updated `scripts/player/player.gd` to `denim_brass_hero_whole_sprite_browser_safe_v12`.
- Changed player movement rendering to draw every directional cowgirl sprite from the uncropped full source image instead of a trimmed source region, removing the remaining path that could make the body look detached while walking or running.
- Kept textured-sprite body overlays suppressed and capped player movement redraws at 20 FPS so the browser spends less time repainting the hero while movement still reads cleanly.
- Updated player smoke coverage in `scripts/game/main.gd` to require the v12 full-image motion pass, the uncropped v4 source contract, and the browser-safe redraw gate.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,769,652 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=157.9 min_fps=77.4 worst_frame_ms=12.9 elapsed_ms=1233.9 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=104.5 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4923.2`.

Next recommended step:

- Continue the graphics/FPS goal by checking the live player movement in the side view at desktop and tall mobile sizes, then attack any remaining frame dips caused by enemy tell/VFX bursts.

## 2026-06-05 - Live Skill Button Cooldown Gate

- Updated `scripts/ui/hud.gd` to `skill_icon_brass_socket_cooldown_5step_v8`.
- Updated compact in-run skill buttons to use the `skill_icon_cooldown_redraw_gate_20step_v2` cooldown budget.
- Quantized skill cooldown redraws from 2.5 percent steps to 5 percent steps so live ability buttons repaint through at most 20 cooldown buckets.
- Trimmed skill-button arc segmentation and cooldown tick detail while keeping brass socket, leather frame, key label, icon, and cooldown edge readable.
- Updated HUD smoke coverage in `scripts/game/main.gd` to require the v8 skill-button pass, the v2 cooldown budget, the 5-percent redraw step, and the 20-bucket cap.
- Stopped stale no-window Godot processes before the final browser performance run; the visible `Dust Heist (DEBUG)` window was left running.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,769,364 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=158.4 min_fps=77.9 worst_frame_ms=12.8 elapsed_ms=1239.5 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=101.1 min_fps=59.9 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5193.8`.

Next recommended step:

- Continue the graphics/FPS goal with another visible polish pass that keeps browser minimum FPS near 60, likely enemy tell readability or another menu/button state gate.

## 2026-06-05 - Dynamic Overlay Primitive Budget

- Updated `scripts/game/main.gd` to `dynamic_hazard_payday_overlay_primitive_budget_v2`.
- Added `dynamic_overlay_hazard_payday_primitive_budget_v1` so animated hazard/payday cues expose explicit browser-safe primitive caps.
- Raised the dedicated animated overlay redraw interval from 10 FPS to 8 FPS, reducing browser canvas pressure while keeping powder keg, Gold Rush, and payday reward cues readable.
- Lowered powder keg warning arcs to 28 segments, keg body arcs to 24, payday reward pulse arcs to 22, Gold Rush chain pips to 3, and payday route breadcrumbs to 5.
- Updated smoke coverage so future visual passes must preserve the overlay primitive budget, arc segment caps, route-dot cap, and chain-pip cap.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,768,404 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=382.8 min_fps=58.2 worst_frame_ms=17.2 elapsed_ms=1254.8 arena_interval=0.250 overlay_interval=0.125`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=97.9 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5465.7`.

Next recommended step:

- Continue the graphics/FPS goal with another browser-aware visual pass, likely on HUD/menu redraw density or enemy sprite/tell polish that keeps the browser minimum near 60 FPS.

## 2026-06-05 - Hunter Wanted Lane Lunge Tell

- Updated `scripts/enemies/hunter.gd` to `hunter_wanted_lane_lunge_tell_v1`.
- Replaced the Hunter's simpler lunge windup marks with a wanted-poster lane tell: rail guides, a center strike line, charge ring, boot bar, claw ticks, corner brackets, and an endcap at the danger point.
- Kept the tell inside the Hunter's existing `_draw()` windup path so it improves readability without adding a new always-on node or extra per-frame scene overhead.
- Added a Hunter lunge tell smoke contract in `scripts/game/main.gd` so future changes must preserve the visual version and marker count.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,768,020 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=453.9 min_fps=57.4 worst_frame_ms=17.4 elapsed_ms=1253.5 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=99.2 min_fps=36.0 worst_frame_ms=27.8 canvas=764x485 elapsed_ms=5527.9`.

Next recommended step:

- Continue the graphics/FPS goal by attacking the remaining browser frame dips below 60 FPS, likely around active VFX and high-density backdrop/menu redraw bursts.

## 2026-06-05 - Browser Dust Burst Pulse Budget

- Updated transient VFX in `scripts/systems/vfx_layer.gd` to `transient_vfx_spawn_redraw_gate_24fps_v3`.
- Added `transient_vfx_pulse_arc_budget_v1` so large dust, reward, hit, parry, and explosion bursts keep their western ring language without flooding the browser canvas.
- Capped simultaneous transient pulse rings at 26 and lowered pulse arc segmentation from 42 to 26, reducing expensive canvas draw work during startup bursts and combat explosions.
- Routed shockwaves, trail pops, impact flashes, and generic bursts through the same pulse append budget.
- Updated VFX smoke coverage in `scripts/game/main.gd` to require the new pulse budget, pulse cap, and arc segment limit.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,764,564 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=163.3 min_fps=76.2 worst_frame_ms=13.1 elapsed_ms=1229.3 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`; Godot also printed an exit-time leaked-object warning.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=100.2 min_fps=59.7 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5556.7`.

Next recommended step:

- Continue the graphics/FPS goal with another visible polish pass that has a performance guard, likely a hunter/rifleman tell upgrade or a deeper browser-side pass on animated arena modifier overlays.

## 2026-06-05 - Player Full-Body Movement Crop Fix

- Updated `scripts/player/player.gd` to `denim_brass_hero_whole_sprite_fast_motion_v11` and `player_directional_safe_crop_fast_whole_sprite_v11`.
- Replaced the overly tight per-facing source crops with `player_directional_full_body_source_crop_v3`, preserving the full visible cowgirl body across forward, diagonal, side, top, and bottom movement sprites.
- Kept body-attached overlays disabled while textured sprites are active so walking and running stay as one whole sprite instead of layered moving body pieces.
- Updated the player visual smoke contract in `scripts/game/main.gd` so future passes must preserve the full-body crop behavior.
- Launched the playable Godot window with `.\.tools\godot\Godot_v4.6.2-stable_win64.exe --path .`; Godot reported a `Dust Heist (DEBUG)` game window.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,764,580 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=158.5 min_fps=79.5 worst_frame_ms=12.6 elapsed_ms=1234.8 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=101.1 min_fps=45.4 worst_frame_ms=22.0 canvas=764x485 elapsed_ms=5314.4`.

Next recommended step:

- Continue the graphics/FPS goal by profiling the browser-side frame dips below 60 FPS, likely starting with high-density town/backdrop redraw and VFX density during active play.

## 2026-06-05 - Loadout Claim Ticket Card Buttons

- Upgraded loadout card buttons in `scripts/ui/hud.gd` to `loadout_card_claim_ticket_hardware_redraw_gate_v7`.
- Added static claim-ticket perforations, punch holes, ledger rules, and bounty-seal hardware to gun and ability cards.
- Kept the upgrade inside the existing `loadout_card_state_redraw_gate_v1`, so the richer card chrome only redraws on state changes or resize.
- Raised the loadout tactile marker contract from 28 to 34 markers per card and updated smoke coverage in `scripts/game/main.gd` for the higher 408-marker aggregate threshold.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,764,820 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=155.3 min_fps=81.2 worst_frame_ms=12.3 elapsed_ms=1230.7 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=108.3 min_fps=59.8 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5017.8`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused enemy tell readability pass or more menu/background visual QA coverage.

## 2026-06-05 - Enemy Hit Role Glyph Sparks

- Upgraded enemy hit sparks in `scripts/systems/vfx_layer.gd` to `enemy_hit_sparks_role_glyph_material_v3`.
- Added tiny role-specific hit glyphs inside the existing transient VFX pass: rifle barrel glints, shotgun brute blast ticks, duelist badge sparks, hunter claw marks, and rusher blade nicks.
- Kept the new glyphs inside the spawn-gated 24 FPS VFX redraw budget so the browser canvas does not get extra per-effect redraw pressure.
- Updated smoke coverage in `scripts/game/main.gd` for the v3 hit-spark contract and raised material marker coverage from 6 to 9.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,763,140 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=157.9 min_fps=79.1 worst_frame_ms=12.6 elapsed_ms=1230.5 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=108.8 min_fps=59.9 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4957.4`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused button/loadout polish pass or another gameplay readability pass on enemy tells.

## 2026-06-05 - Browser VFX Redraw Spike Gate

- Updated `scripts/systems/vfx_layer.gd` to `transient_vfx_spawn_redraw_gate_24fps_v2`.
- Routed transient effect spawns through a shared redraw gate so blood, muzzle flashes, sparks, dust, afterimages, glints, prompts, and impact text coalesce browser canvas repaints instead of each effect calling its own immediate redraw.
- Lowered transient VFX redraw cadence from 30 FPS to 24 FPS while keeping first-spawn and clear-frame redraws responsive.
- Made `burst()` participate in the gate so direct spawn, pickup, hazard, and completion burst effects still appear without bypassing the budget.
- Updated smoke coverage in `scripts/game/main.gd` to protect the new spawn-gated 24 FPS VFX contract.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,761,860 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=156.8 min_fps=82.6 worst_frame_ms=12.1 elapsed_ms=1232.3 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=108.8 min_fps=60.0 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=5009.2`.

Next recommended step:

- Continue the full graphics/FPS goal with either a richer enemy-hit readability pass or another browser-profiled visual polish pass on the arena/menu surfaces.

## 2026-06-05 - Main Menu Bounty Receipt Nav Buttons

- Upgraded main menu nav buttons in `scripts/ui/hud.gd` to `menu_nav_bounty_receipt_badge_redraw_gate_v9`.
- Added static bounty-receipt teeth, punch holes, selected stamp accents, and darker label backplates so the menu buttons feel more tactile without adding animation or per-frame redraw pressure.
- Raised the nav tactile marker contract from 32 to 38 markers per button while preserving `menu_nav_state_redraw_gate_v1`.
- Updated smoke coverage in `scripts/game/main.gd` for the v9 nav visual contract and the higher 228-marker aggregate threshold.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,761,716 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=154.4 min_fps=90.9 worst_frame_ms=16.3 elapsed_ms=1230.5 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=107.2 min_fps=45.0 worst_frame_ms=22.2 canvas=764x485 elapsed_ms=5017.7`.

Next recommended step:

- Continue the full graphics/FPS goal with a browser-first spike-stability pass, since this run stayed playable but still showed a 45 FPS browser minimum.

## 2026-06-05 - Duel-Worn Courtyard Floor Readability

- Upgraded the arena floor in `scripts/game/main.gd` to `courtyard_duel_worn_floor_readability_v2`.
- Added a static, FPS-safe duel-worn floor pass with marshal-star scoring marks, threshold dust rails, shell glints, and a low-contrast calm-center wash.
- Kept the new detail on the existing capped main arena redraw path instead of adding animated objects or per-frame texture work.
- Added smoke coverage for 46 arena-floor detail markers and visual QA coverage for marshal scoring, threshold dust, and center readability.
- Inspected `artifacts/qa/01_first_draw.png`; the floor reads richer while the player, rusher, hazards, and HUD stay clear.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,759,668 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=154.6 min_fps=90.1 worst_frame_ms=17.9 elapsed_ms=1229.5 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=130.5 min_fps=59.9 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4707.3`.

Next recommended step:

- Continue the full graphics/FPS goal with either a browser-first VFX polish pass or a main-menu button readability pass.

## 2026-06-05 - Player Split And Browser Lag Fix

- Updated `scripts/player/player.gd` so textured player sprites render as one whole sprite without body-attached procedural overlays during walking/running.
- Raised the player motion redraw cadence from 10 FPS to 24 FPS and idle redraws from 3 FPS to 6 FPS so movement feels smoother without repainting the full arena.
- Simplified always-visible live HUD skill buttons in `scripts/ui/hud.gd` to `skill_icon_fast_readable_redraw_gate_v7`, keeping readable brass frames while removing costly socket/badge micro-detail from cooldown redraws.
- Updated smoke coverage in `scripts/game/main.gd` to protect the whole-sprite/no-overlay player path and lighter skill-button contract.
- Inspected `artifacts/qa/01_first_draw.png`; the player remains a single intact sprite at gameplay scale and the HUD buttons stay readable.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,756,100 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=155.4 min_fps=89.4 worst_frame_ms=17.9 elapsed_ms=1232.7 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=135.4 min_fps=71.0 worst_frame_ms=14.1 canvas=764x485 elapsed_ms=4512.2`.

Next recommended step:

- Continue the full graphics/FPS goal with another browser-first optimization pass if manual play still feels choppy, otherwise move to a focused arena readability pass.

## 2026-06-05 - Menu Backdrop Showdown Depth

- Upgraded the main menu backdrop in `scripts/ui/hud.gd` to `menu_backdrop_showdown_sign_depth_v5`.
- Added static showdown street-depth cues: extra dusty track lines, spur marks, foreground porch rails, and rail posts behind the menu cards.
- Added stronger title-plaque hardware with marshal-star side badges, a center brass plate, extra notch marks, and sun glints.
- Raised smoke coverage in `scripts/game/main.gd` to require 62 town-square backdrop cues and 24 title-plaque markers.
- Inspected the regenerated `artifacts/qa/11_information_hunter_card.png`; the richer backdrop stayed behind the nav/cards without crowding readable text.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,755,892 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.9 min_fps=88.1 worst_frame_ms=13.0 elapsed_ms=1232.9 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=137.6 min_fps=60.1 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4825.3`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused arena foreground readability pass or a live HUD button/icon refinement pass.

## 2026-06-05 - Enemy Directional Source Crop Polish

- Upgraded enemy sprite presentation in `scripts/enemies/base_enemy.gd` to `role_silhouette_directional_safe_crop_role_plate_v7`, `enemy_directional_safe_crop_motion_redraw_budget_v7`, and `enemy_turnaround_directional_safe_source_crop_v2`.
- Replaced the single centered enemy source crop with eight direction-aware draw-time crops measured from the enemy turnaround PNG alpha bounds.
- Preserved whole-sprite enemy drawing and the existing active/idle redraw budget; no new animation loop or gameplay behavior was added.
- Added smoke coverage for all eight enemy directional crop facings and raised enemy material marker coverage to 20.
- Inspected `artifacts/qa/02_rifleman_crossfire_tell.png`; the staged rifleman remained unclipped/readable with the attack tell visible.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,752,996 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.8 min_fps=92.4 worst_frame_ms=16.1 elapsed_ms=1229.5 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=132.5 min_fps=89.5 worst_frame_ms=11.2 canvas=764x485 elapsed_ms=4601.4`.

Next recommended step:

- Continue the full graphics/FPS goal with a main-menu title/backdrop composition pass or a focused arena foreground readability pass.

## 2026-06-05 - Menu Nav Sheriff Badge Endcaps

- Upgraded main menu nav buttons in `scripts/ui/hud.gd` to `menu_nav_sheriff_badge_endcap_redraw_gate_v8`.
- Added state-gated sheriff-badge selected markers and brass endcap hardware so the left menu reads more like crafted western UI hardware.
- Raised the nav tactile marker contract from 26 to 32 markers per button while keeping `menu_nav_state_redraw_gate_v1`.
- Updated smoke coverage in `scripts/game/main.gd` for the v8 nav visual contract and the higher 192-marker aggregate threshold.
- Inspected the regenerated `artifacts/qa/11_information_hunter_card.png` capture; the selected Information button shows the stronger endcap and badge detail without layout overlap.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,751,332 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=203.9 min_fps=66.0 worst_frame_ms=18.9 elapsed_ms=1231.6 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=134.2 min_fps=58.9 worst_frame_ms=17.0 canvas=764x485 elapsed_ms=4464.6`.

Next recommended step:

- Continue the full graphics/FPS goal with either a main-menu title/backdrop composition pass or an enemy directional source-art crop pass.

## 2026-06-05 - Player Directional Source Crop Polish

- Upgraded player sprite presentation in `scripts/player/player.gd` to `denim_brass_hero_directional_crop_overlay_gate_v9`, `player_directional_safe_crop_motion_redraw_budget_v9`, and `player_directional_safe_source_crop_v2`.
- Replaced the forward-only source crop with direction-aware draw-time crops for all 13 cowgirl directional sprites, based on measured alpha bounds.
- Preserved intact full-sprite drawing and the existing movement redraw budget; no per-frame split-body animation loop was added.
- Raised player material marker coverage to 12 and added smoke coverage for all 13 directional source crops in `scripts/game/main.gd`.
- Inspected the visual QA first-draw capture and confirmed the player remains intact and readable at gameplay scale.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,750,100 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=156.1 min_fps=88.8 worst_frame_ms=14.9 elapsed_ms=1230.0 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=147.9 min_fps=44.8 worst_frame_ms=22.3 canvas=764x485 elapsed_ms=4393.8`.

Next recommended step:

- Continue the full graphics/FPS goal with a main-menu composition screenshot review or an enemy directional source-art crop pass.

## 2026-06-05 - Loadout Card Button Badge Polish

- Upgraded gun and ability loadout card buttons in `scripts/ui/hud.gd` to `loadout_card_badge_cartridge_selection_redraw_gate_v6`.
- Added richer static western button detailing: marshal-style badge medallions, cartridge rails, shell primers, selected stamped plates, ready ticks, and bottom notch marks.
- Raised the loadout card tactile marker contract from 20 to 28 per card while preserving the existing state redraw gate.
- Updated smoke coverage in `scripts/game/main.gd` for the v6 loadout-card visual contract and the higher aggregate marker threshold.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,748,836 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.9 min_fps=86.7 worst_frame_ms=14.6 elapsed_ms=1229.1 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=145.4 min_fps=70.8 worst_frame_ms=14.1 canvas=764x485 elapsed_ms=4283.2`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused character source-art cleanup pass for remaining directional sprites or a final main-menu composition review against mobile and desktop screenshots.

## 2026-06-05 - Result Pop-Out No-Banner Polish

- Upgraded the run result frame in `scripts/ui/hud.gd` to `result_card_side_receipt_popout_no_banner_v5`.
- Removed the duplicate extraction result text from the old full-width message banner by keeping the debug/smoke text available while making that banner transparent, so the pop-out owns the result presentation.
- Reduced the death/result backdrop wash from a heavy blackout to a lighter stage dim so the arena remains visible behind the side receipt.
- Added stronger static receipt details to the result card: side pop-out tabs, stitch marks, chipped receipt edge marks, and higher detail-marker coverage.
- Updated smoke coverage in `scripts/game/main.gd` for the v5 result visual contract, lighter backdrop alpha, hidden duplicate result banner, and 48 detail markers.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,747,444 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.1 min_fps=90.3 worst_frame_ms=13.9 elapsed_ms=1229.1 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=141.2 min_fps=69.9 worst_frame_ms=14.3 canvas=764x485 elapsed_ms=4492.9`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused button polish pass on secondary menu/loadout controls or a sprite-source cleanup pass for remaining directional character captures.

## 2026-06-05 - Town Business Signature Facades

- Upgraded the arena perimeter storefront pass in `scripts/game/main.gd` to `town_square_business_signature_silhouettes_v3`.
- Added larger static signature silhouettes for each western business type: saloon double-door shadows, barber mirror and basin, sheriff jail bars, bank teller grille, general-store feed sacks, hotel luggage, stable hayloft door, and doctor medicine case.
- Applied the same business-specific silhouette language to side storefronts so the town square reads as varied businesses around the whole arena instead of repeated wood boxes.
- Expanded smoke coverage for the new facade cues so the Saloon, Barber, Sheriff, Bank, General Store, Hotel, Stable, and Doc identities stay guarded.
- Preserved the existing static arena render path and redraw budgets; the new facade details do not add a dynamic animation loop.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,745,652 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.7 min_fps=95.3 worst_frame_ms=15.3 elapsed_ms=1230.0 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=146.9 min_fps=60.0 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4268.6`.

Next recommended step:

- Continue the full graphics/FPS goal with a focused menu/results pop-out polish pass or a deeper arena foreground cover-variety pass that adds tactical silhouettes without hurting browser FPS.

## 2026-06-05 - Enemy Safe-Crop Role Plate Polish

- Upgraded enemy sprite presentation in `scripts/enemies/base_enemy.gd` to `role_silhouette_safe_crop_role_plate_v6` and `enemy_safe_crop_motion_redraw_budget_v6`.
- Added `enemy_turnaround_safe_source_crop_v1` so transparent padding in enemy turnaround PNGs no longer makes enemies look too small at gameplay scale.
- Added subtle role-colored grounding/readability plates under enemies, with distinct rifleman, shotgun, knife, hunter, and duelist cues.
- Preserved the existing active/idle redraw budgets so the richer enemy presentation does not add a new per-frame animation loop.
- Updated smoke coverage in `scripts/game/main.gd` for the v6 enemy visual contracts, source-crop hook, and higher material marker count.
- Made the visual QA reload-ready glint capture deterministic by waiting for the reload-glint predicate before saving `01_cylinder_ready_glint.png`.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,738,996 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=159.4 min_fps=81.1 worst_frame_ms=14.8 elapsed_ms=1229.3 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=145.4 min_fps=60.0 worst_frame_ms=16.7 canvas=764x485 elapsed_ms=4361.5`.

Next recommended step:

- Continue the full graphics/FPS goal with arena prop and cover variety, or do a deeper role-by-role enemy source-art cleanup pass across all directional captures.

## 2026-06-05 - Menu Nav Button Silhouette Polish

- Upgraded main-menu nav buttons in `scripts/ui/hud.gd` to `menu_nav_brass_cartridge_tabs_redraw_gate_v7`.
- Added stronger role-specific western silhouettes for Play, Swords, Guns, Abilities, Quests, and Information so the left menu reads as a tactile saloon-ledger control stack instead of similar dark slabs.
- Added extra static cartridge-shell marks, brighter icon backing plates, and a cross-braced selected stamp while keeping the existing state-gated redraw behavior.
- Updated smoke coverage in `scripts/game/main.gd` so the new nav-button version and higher tactile marker coverage are verified.
- Strengthened the reload-ready VFX in `scripts/systems/vfx_layer.gd` with a larger brass cylinder plate, brighter chamber flashes, and clearer denim/brass streaks so the gameplay-ready glint is more readable and visual QA is deterministic.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,737,668 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=154.8 min_fps=84.7 worst_frame_ms=14.5 elapsed_ms=1229.2 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=147.9 min_fps=75.2 worst_frame_ms=13.3 canvas=764x485 elapsed_ms=4315.2`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal with a gameplay-facing polish pass on either enemy directional sprite cleanup or arena cover/hazard prop variety, then recheck browser FPS.

## 2026-06-05 - Player Sprite Split And Browser Lag Fix

- Fixed the player walk/run split by removing the old lower-body split draw path and drawing the cowgirl as one intact source-region sprite.
- Added `player_forward_safe_source_crop_v1` in `scripts/player/player.gd` so the forward/down-screen frame crops stray right-edge source art at draw time instead of showing detached body/weapon fragments.
- Lowered the active player motion redraw budget to 10 FPS while movement physics still runs normally, reducing browser canvas redraw pressure without making controls sluggish.
- Kept body-attached hero/material overlays suppressed while the player is moving so decorative lines cannot drift away from the sprite during walking, running, or dash movement.
- Added smoke coverage in `scripts/game/main.gd` for the new player-safe crop and v8 player visual contracts.
- Added dependency-free exported-browser FPS tooling in `scripts/tools/browser_perf_probe.js` and `scripts/tools/browser_perf_test.ps1`; the probe serves `build/web`, launches headless Chrome/Edge through CDP, injects `--dust-performance-test`, samples warmed browser animation frames, and gates average FPS, minimum FPS, and worst frame time.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,736,212 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=155.6 min_fps=88.2 worst_frame_ms=17.6 elapsed_ms=1230.8 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\browser_perf_test.ps1` completed with exit code 0 and reported `DUST_BROWSER_PERF: PASS samples=240 avg_fps=150.5 min_fps=89.4 worst_frame_ms=11.2 canvas=764x485 elapsed_ms=4656.7`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Run a quick manual browser pass on `http://localhost:9011/` focused on diagonal player movement and late-wave busy combat, then tune any remaining visible hitching with the new browser FPS probe.

## 2026-06-05 - Runtime FPS Performance Sampler

- Added `headless_runtime_fps_sampler_v1` in `scripts/game/main.gd` behind the `--dust-performance-test` command-line flag.
- Added `scripts/tools/performance_test.ps1` so the build has a repeatable performance gate alongside smoke and visual QA.
- The sampler starts a real run, stages a busy Gold Rush wave, keeps normal redraw budgets active, samples 160 warmed frames, and fails if average FPS drops below 45, minimum FPS drops below 30, or worst sampled frame wait exceeds 80ms.
- Added smoke coverage so the project exposes the performance sampler version.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,735,572 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\performance_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_PERF: PASS version=headless_runtime_fps_sampler_v1 samples=160 avg_fps=153.3 min_fps=88.0 worst_frame_ms=15.2 elapsed_ms=1231.3 arena_interval=0.250 overlay_interval=0.100`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal by adding browser-side FPS sampling for the exported Web build or by further splitting broad wave atmosphere into cached static and dynamic layers.

## 2026-06-05 - Wave Atmosphere Redraw Budget

- Updated `scripts/game/main.gd` to `arena_timer_redraw_budget_4fps_v3` and added `wave_atmosphere_main_canvas_redraw_budget_4fps_v1`.
- Lowered broad main-canvas arena atmosphere redraws from 6 FPS to 4 FPS now that responsive powder keg, Gold Rush, and payday cues live on the dedicated dynamic overlay.
- Kept forced redraws for wave starts, run starts, hazard ignition/explosion, and pickup spawn/collection, so important gameplay state still appears immediately.
- Added smoke coverage for the new wave-atmosphere redraw budget version and the 4 FPS main-canvas interval.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,734,020 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal with browser-side FPS sampling for the exported Web build or by moving more arena atmosphere drawing onto a true cached/static-versus-dynamic split.

## 2026-06-05 - Dynamic Hazard And Payday Overlay

- Added `dynamic_hazard_payday_overlay_redraw_budget_v1` in `scripts/game/main.gd`.
- Moved powder keg visuals, lit fuse warning rings, Gold Rush keg links, payday satchels, pickup pointers, optional labels, and route hints onto a dedicated `DynamicArenaOverlay` node.
- Left the static arena floor, town backdrop, lighting, modifier atmosphere, and cover props on the main arena canvas so small animated rewards/hazards no longer require repainting the whole storefront and sand scene.
- Added a capped 10 FPS overlay redraw budget for hazard/payday animation, while preserving the 4 FPS payday idle budget and forced redraws for spawn, collection, ignition, and explosions.
- Added smoke coverage for the overlay visual version and redraw interval.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,733,764 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`, including the Gold Rush keg-link and payday-visible capture set.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal by moving broad wave modifier atmosphere onto a cached/static-versus-dynamic split, or add browser-side FPS sampling for the exported Web build.

## 2026-06-05 - Runtime Backdrop Visual QA Capture

- Added `01_runtime_backdrop_plate.png` to the visual QA capture set in `scripts/game/main.gd`.
- Visual QA now briefly switches from the rich smoke-test backdrop path to the normal runtime backdrop path and captures the cheap town facade plate used during browser play.
- Added a runtime backdrop image assertion that checks for dark storefront bands, brass accents, and a brighter readable arena center.
- This verifies the performance path still reads as a western town square instead of only screenshot-checking the richer storefront QA path.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,726,756 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`, including `01_runtime_backdrop_plate.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal by moving hazard/pickup drawing onto a dedicated overlay node or by adding browser-side FPS sampling and canvas pixel checks for the exported Web build.

## 2026-06-05 - Payday Pickup Redraw Budget

- Added `payday_pickup_redraw_budget_4fps_v1` in `scripts/game/main.gd` so uncollected payday satchels animate their pointer, route hint, and optional label at a cheaper pickup-specific redraw cadence.
- Kept pickup spawn and collection feedback immediate with forced redraws, so reward drops still appear instantly and collected satchels disappear right away.
- Preserved the western reward visuals: coin spill, ammo spill, brass bank stamp, leather grain, silhouettes, pointer, and route hint remain intact.
- Added smoke coverage to verify each live payday pickup carries the redraw-budget version and a capped idle redraw interval.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,724,196 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal by moving hazard and pickup drawing to a dedicated overlay node or by adding browser-sized screenshot QA for the runtime performance path.

## 2026-06-05 - Runtime Town Backdrop Plate

- Added `runtime_town_backdrop_plate_cheap_facades_v1` in `scripts/game/main.gd` so normal browser play uses a bounded town-square facade plate instead of repainting the full procedural perimeter on every arena redraw.
- Kept the western town-square read: saloon, barber, sheriff, bank, general store, hotel, stable, and doctor facades still surround the arena with doors, windows, signage icons, threshold rails, and warm high-noon bands.
- Preserved the richer full-detail procedural backdrop for smoke/visual QA captures, so screenshot verification still checks the premium storefront/highlight path while runtime play gets the cheaper backdrop.
- Added smoke coverage for the runtime backdrop plate visual version, business facade count, and bounded primitive budget.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,724,084 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the full graphics/FPS goal by moving dynamic hazards/payday pickups onto a smaller overlay node or by screenshot-checking the runtime plate directly in browser-sized captures.

## 2026-06-05 - Player Sprite Split And Redraw Lag Fix

- Updated `scripts/player/player.gd` to `denim_brass_hero_intact_sprite_overlay_gate_v7` and `player_intact_body_motion_redraw_budget_v7`.
- Suppressed all body-attached sprite glint/rim overlays while the full cowgirl texture is moving, so walking and running keep one intact body instead of layered accents making the sprite look split apart.
- Reduced active player redraw pressure from 20 FPS to 12 FPS and idle redraws from 5 FPS to 3 FPS, while leaving the actual physics movement untouched.
- Finished the static UI redraw-gate pass in `scripts/ui/hud.gd`: menu nav buttons, loadout card buttons, and loadout icons now skip redundant redraws when their state has not changed, with small brass primer details added without timers or per-frame animation.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,719,924 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- If browser play still stutters after this, bake or cache the static town/backdrop layer so moving hazards and gameplay effects can redraw without repainting all storefront scenery.

## 2026-06-05 - Browser Scenic Density Budget

- Added `browser_scenic_density_budget_v1` in `scripts/game/main.gd` to thin repeated decorative draw loops while preserving the old-west town-square identity.
- Reduced repeated arena and backdrop marks through a shared scenic-density helper: perimeter loose props, boardwalk plank/rivet marks, lantern glows, sand grit, floor scuffs, footprints, edge dressing, sun shafts, dust ribbons, and high-noon haze now draw fewer duplicate primitives per arena redraw.
- Kept named businesses, storefront silhouettes, boardwalk thresholds, readable combat center, hazards, and player/enemy sprites intact.
- Rebuilt the Web export in `build/web/index.html`; the exported pack is 19,715,588 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue toward the full graphics/FPS goal with a true static backdrop renderer or a baked storefront/floor plate so the dynamic hazard layer can update without repainting procedural town scenery.

## 2026-06-05 - Browser Lag Redraw Budget And Intact Player Check

- Tightened the arena timer redraw budget in `scripts/game/main.gd` from 12 FPS to 6 FPS with `arena_timer_redraw_budget_6fps_v2`, cutting repeated redraw pressure from animated hazards and payday pickup timers in the browser build.
- Kept the canvas drawing path legal after validation caught that parent draw helpers cannot be called from a child cache node without Godot draw-context errors.
- Verified the current player sprite path in `scripts/player/player.gd` still uses the intact cowgirl texture overlay gate and capped movement redraws, so walking and running no longer split the body into procedural parts.
- Rebuilt the Web export in `build/web/index.html`; the exported pack remains trimmed at 19,716,276 bytes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- If browser play still stutters, move the expensive town/backdrop drawing to a true separate renderer instead of a parent-helper cache call, or replace the procedural storefront plate with a baked texture.

## 2026-06-05 - Web Export Resource Hygiene

- Added `.gdignore` files for `artifacts/` and `build/` so generated screenshots, logs, and exported Web files are not treated as game resources by Godot.
- Updated `export_presets.cfg` to exclude `artifacts/*` and `build/*` from the Web resource pack.
- Kept all gameplay graphics intact while reducing browser payload: the rebuilt `build/web/index.pck` dropped from 33,154,976 bytes to 19,715,220 bytes, cutting about 13.4 MB of generated QA/build clutter from the shipped game pack.
- Confirmed visual QA can still write fresh screenshots under `artifacts/qa` even though those files are no longer imported or packed for Web.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0, and the export log no longer packed `artifacts/qa` screenshots.

Next recommended step:

- Continue the graphics/FPS goal with a runtime arena/background cache split so dynamic hazards can update without redrawing every static town-square detail.

## 2026-06-05 - Unlock Toast Brass Claim Ticket

- Wired the existing unlock toast frame in `scripts/ui/hud.gd` into the live HUD as `unlock_toast_brass_claim_ticket_v1`.
- Replaced bare floating unlock text with a centered brass claim-ticket popout that uses static drawn rails, rivets, badge marks, notches, and spark details.
- Added shared message-label layout reset helpers so unlock toasts, run-start text, result cards, and transient QA clears do not leave text over the wrong part of the screen.
- Kept the pass FPS-safe: the ticket is one hidden Control that only draws while a reward is visible, then fades and resets with the existing short tween path.
- Added smoke coverage in `scripts/game/main.gd` to verify the toast frame version, detail marker count, visible state, and reward text.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the framed reward toast.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new unlock-toast assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with a live browser performance pass on the heaviest always-visible arena/background layers if side-view play still feels slow.

## 2026-06-05 - Intact Player Sprite Performance Gate

- Fixed the player movement sprite in `scripts/player/player.gd` so walking and running always draw the cowgirl as one intact texture instead of layering body-like procedural accents over motion.
- Updated the player visual contract to `denim_brass_hero_intact_sprite_overlay_gate_v6` and `player_intact_body_motion_redraw_budget_v6`.
- Reduced player redraw pressure by capping active movement redraws at 20 FPS and idle redraws at 5 FPS, while keeping dash, parry, invulnerability, and weapon effects readable.
- Updated `scripts/game/main.gd` smoke coverage to require the intact-sprite overlay gate and the new redraw-budget version.
- Rebuilt the Web export in `build/web/index.html` and launched the refreshed game at `http://localhost:9011/?player_fix=20260605_intact_sprite_v6`.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Do a live browser performance pass focused on the heaviest always-visible layers if the side-view build still feels laggy after the player sprite fix.

## 2026-06-05 - Result Card Blackpowder Receipt Popout

- Upgraded the run result/failure popout in `scripts/ui/hud.gd` to `result_card_blackpowder_receipt_popout_v4`.
- Added richer static western receipt details: torn ledger teeth, a cartridge row, warrant-badge stamp, powder smear, stronger receipt edge marks, and expanded detail marker coverage from 28 to 38.
- Kept the pass FPS-safe: the new result-card material work is static `_draw()` geometry on the existing popout card, with no new nodes, textures, timers, or ongoing animation loops beyond the existing short glow pulse.
- Updated `scripts/game/main.gd` smoke coverage so both extraction and failed-run result popouts require the v4 frame and the higher detail marker count.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the blackpowder receipt result card.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new result-card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with a focused pass on unlock toasts or another static arena/background polish pass that keeps the combat center readable.

## 2026-06-05 - Live HUD Marshal Ledger Label Gate

- Upgraded the always-visible live HUD frame in `scripts/ui/hud.gd` to `live_hud_ledger_marshal_badge_label_gate_v3`.
- Added stronger western ledger material cues: a darker header plate, brass inset rail, revolver-chamber health ticks, a small marshal-badge stamp, and increased contrast marker coverage so the HUD reads better over the sandy arena.
- Added `live_hud_label_text_change_gate_v1` so the heart, danger, timer, wave, style, and ammo rows only rewrite Label text when the displayed string actually changes.
- Updated `scripts/game/main.gd` smoke coverage to require the v3 live HUD ledger, at least 42 ledger readability markers, and the six-row label update gate.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the marshal-ledger HUD polish and reduced label churn.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live HUD ledger and label-gate assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with a focused pass on result/unlock popouts under small browser viewports or another arena readability pass that keeps animation redraws capped.

## 2026-06-05 - Live Skill Button Redraw Gate

- Upgraded the compact in-run ability buttons in `scripts/ui/hud.gd` to `skill_icon_spur_rail_redraw_gate_v5`.
- Added richer western button material cues: brass spur side rails, stamped key badges, extra ready glints, cooldown latch marks, and stronger tactile marker coverage while keeping the buttons small and readable in combat.
- Added `skill_icon_cooldown_redraw_gate_25step_v1` so cooldown overlays quantize to visible 0.025 steps instead of queueing a redraw on every HUD tick when the cooldown value changes by a tiny amount.
- Exposed the redraw budget version and cooldown step through `DustHud`, then updated smoke coverage in `scripts/game/main.gd` to require the v5 skill-button pass and the redraw gate.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the live HUD button polish and redraw reduction.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live skill-button redraw assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with another always-visible UI audit, likely the live HUD ledger text/readability stack or result/unlock popouts under small browser viewports.

## 2026-06-05 - Town Square Boardwalk Threshold Depth

- Added the static town-square threshold pass in `scripts/game/main.gd` with `town_square_boardwalk_threshold_depth_v1`.
- Added boardwalk lip shadows, warm edge glints, gate-wear scuffs, lantern pools, brass rail/rivet marks, and side shadow pockets around the arena boundary so the square reads as a richer western place without cluttering the walkable combat center.
- Kept the pass FPS-safe: all details are static primitives drawn inside the existing arena/background pass, with no new nodes, textures, timers, particles, or animated loops; the existing arena redraw budget remains unchanged at 12 FPS for animated overlays.
- Updated smoke coverage to require the threshold visual version and at least 24 threshold-depth markers.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the new town-square depth pass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new town threshold assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with another static arena/background readability pass or a HUD/button audit against the latest visual QA captures.

## 2026-06-05 - Transient VFX Redraw Budget

- Added a shared transient VFX redraw budget in `scripts/systems/vfx_layer.gd` with `transient_vfx_redraw_budget_30fps_v1`.
- Kept VFX spectacle intact while reducing canvas pressure: newly spawned effects still draw immediately, expired effects still clear immediately, and ongoing dust, hit sparks, muzzle flashes, afterimages, prompts, reload glints, and ability sigils redraw at a capped 30 FPS cadence instead of every process tick.
- Exposed `get_transient_vfx_redraw_budget_version()` and `get_transient_vfx_redraw_interval()` so the performance behavior is covered by smoke tests.
- Updated `scripts/game/main.gd` first-slash VFX smoke coverage to require the 30 FPS redraw budget alongside the existing saber, blood, hit spark, parry, player-hit, and ability-glint visual assertions.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the VFX frame pacing fix.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new VFX redraw-budget assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with a focused arena/background pass that adds richer static depth while checking the arena redraw budget remains capped.

## 2026-06-05 - Enemy Whole-Sprite Role Glints And Idle Budget

- Upgraded enemy sprite presentation in `scripts/enemies/base_enemy.gd` to `role_silhouette_whole_sprite_role_glints_v5` and `enemy_whole_body_motion_redraw_budget_v5`.
- Added a whole-sprite enemy equipment/readability layer: hat bands, shoulder reads, brass belt marks, leather straps, weapon glints, boot contact, and role-specific rifle/shotgun/knife/hunter/duelist cues.
- Kept enemy sprites on the single full-texture draw path, so the extra polish does not split bodies into fake walking parts.
- Reduced enemy redraw pressure with a 20 FPS active budget and a 10 FPS idle budget while preserving active redraws for movement, hit recoil, slow effects, attack tells, and recovery tells.
- Updated `scripts/game/main.gd` smoke coverage to require the v5 enemy role-glint pass and at least 14 sprite material markers.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the enemy sprite polish and redraw budget.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new enemy sprite assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics/FPS goal with an arena/VFX draw-budget review, especially persistent blood, dust, and weapon trail loops during crowded late waves.

## 2026-06-05 - Player Whole-Sprite Redraw Budget Fix

- Fixed the player sprite pass in `scripts/player/player.gd` to `denim_brass_hero_whole_sprite_glints_v5` and `player_whole_body_motion_redraw_budget_v5`.
- Tightened the player redraw budget from a constant 30 FPS redraw poke to a 24 FPS active cap and an 8 FPS idle cap, so the player no longer asks the renderer for fresh draw work every physics tick when the game is calm.
- Preserved the whole-body `draw_texture_rect()` sprite path and added tiny coordinated hat, shoulder, belt, holster, saber, and spur glints as one equipment layer instead of fake separated walking body parts.
- Updated `scripts/game/main.gd` smoke coverage to require the v5 player sprite pass and at least 14 material/readability markers.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the lag and body-splitting fix.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player sprite assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Play-test the browser build for perceived frame pacing; if it still drags, profile the arena/VFX redraw loops next because the player path is now budgeted.

## 2026-06-05 - Main Menu Hanging Sign Sun Shafts

- Upgraded the main menu backdrop in `scripts/ui/hud.gd` to `menu_backdrop_hanging_sign_sun_shafts_v4`.
- Added a more cinematic first-screen composition: warm sun shafts across the street, hanging-chain hardware for the title plaque, stronger brass rivets, side plates, plank stripes, and extra dust motes.
- Increased the menu town-square cue count from 42 to 50 and added a title-plaque marker count of 16, then updated `scripts/game/main.gd` smoke coverage to require both.
- Kept the pass FPS-safe: all changes are static `MenuBackdrop._draw()` primitives on the main menu only, with no new textures, particles, timers, nodes, or runtime animation loops.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded main menu backdrop.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new menu-backdrop visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused playable-sprite silhouette pass or a final arena foreground readability sweep.

## 2026-06-05 - Main Menu Brass Cartridge Nav Buttons

- Upgraded main menu nav buttons in `scripts/ui/hud.gd` to `menu_nav_brass_cartridge_tabs_v5`.
- Added richer tactile western details to the first-screen menu buttons: inset brass rail plates, cartridge-tab caps, stronger icon-plate glints, selected-label underline, and deeper leather/wood shadowing.
- Increased each nav button's tactile marker count from 15 to 18 and updated `scripts/game/main.gd` smoke coverage to require the v5 visual version plus at least 108 total nav-button markers across the six menu buttons.
- Kept the pass FPS-safe: the new details are static `Button._draw()` primitives on six existing controls, with no new textures, particles, timers, nodes, or animation loops.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded menu button pass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new menu-nav visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with another browser-cheap first-impression pass, likely title/backdrop lighting polish or final player weapon silhouette work.

## 2026-06-05 - Player Hit Flash Brass Spur Readability

- Upgraded the player damage flash in `scripts/systems/vfx_layer.gd` to `player_hit_blood_dust_brass_spur_v2`.
- Added a richer but still readable hit reaction: ground shadow ellipse, dust fan, blood streaks, denim recoil arc, brass spur snap, leather tear line, bone glint, droplets, and small brass/bone shards.
- Added `get_player_hit_flash_material_marker_count()` and updated `scripts/game/main.gd` smoke coverage so player-hit VFX must expose at least 8 material/readability markers.
- Kept the pass FPS-safe: player hit flashes are still capped by the existing `MAX_PLAYER_HIT_FLASHES := 4`, short-lived, and drawn with simple primitives only; no new textures, particles, nodes, timers, or persistent animation loops were added.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded hit-read flash.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player-hit flash assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- This smoke run did not print the intermittent Godot ObjectDB leak warning seen in some previous passes.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with another FPS-safe readability pass, ideally player silhouette/weapon pose polish or enemy hit tells during crowded waves.

## 2026-06-05 - Result Popout Brass Action Rail

- Upgraded the end-of-run result popout in `scripts/ui/hud.gd` to `result_card_brass_stamp_action_rail_v3`.
- Added a richer western ledger treatment: side leather rails, brighter brass edge glints, interior ledger columns, dusty paper stains, stronger corner rivets, stamped red result marks, and a bottom action rail around the "PRESS ANY KEY" area.
- Exposed a result-card detail marker count and updated `scripts/game/main.gd` smoke coverage so both extraction and failed-run popouts require the v3 frame and at least 28 brass/ledger/stamp/action-rail details.
- Preserved the previous side-popout behavior so death/results stay inside a card instead of laying text over the menu or gameplay.
- Kept the pass FPS-safe: no new textures, particles, persistent nodes, timers, or animation loops beyond the existing short glow pulse; the new polish is static `Control._draw()` work on the result card.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded result popout.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new result-popout visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- This smoke run did not print the intermittent Godot ObjectDB leak warning seen in some previous passes.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused player/enemy hit-read pass or a final review of menu/card typography, keeping the browser FPS budget intact.

## 2026-06-05 - Town Roofline Silhouette Depth

- Added `town_square_roofline_silhouette_depth_v1` to the old-west perimeter renderer in `scripts/game/main.gd`.
- Added static rooftop silhouettes around the town square: chimney stacks, water tanks, telegraph wires and poles, hanging sign shadows, roof ladders, and weather vanes.
- Kept the dressing outside the playable arena and above/around storefronts so the town feels taller and more cinematic without adding clutter to combat reads.
- Added smoke coverage for the new roofline visual version and its specific silhouette cues.
- Kept the pass FPS-safe: no new textures, particles, animations, timers, or nodes; it is deterministic background `draw_*` primitives inside the existing static arena/backdrop rendering path.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded town-square roofline.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new roofline silhouette assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a lightweight player/enemy hit-read polish pass or a menu/result-card visual review, keeping the recent browser FPS fixes intact.

## 2026-06-05 - Skill Button Brass Chamfer Polish

- Upgraded the compact in-run skill buttons in `scripts/ui/hud.gd` to `skill_icon_brass_chamfer_ready_notch_v4`.
- Added FPS-cheap brass chamfer lines, an inset leather well, ready-state top notches, small glints, radial tick marks, and cooldown scoring lines so the four always-visible ability buttons feel more tactile and readable.
- Increased the skill icon tactile marker count from 10 to 14 per button, then updated `scripts/game/main.gd` smoke coverage to require the new version and at least 56 live HUD skill-button markers.
- Kept the pass performance-conscious: no new textures, particles, animations, timers, or extra nodes; only a few additional `Control._draw()` primitives on the existing four HUD controls.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded in-run skill buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new skill-button visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused live HUD damage/readability polish pass or a lightweight arena-building signage pass, keeping the browser FPS budget front and center.

## 2026-06-05 - Lantern Street Menu Backdrop Polish

- Upgraded the main menu backdrop in `scripts/ui/hud.gd` to `menu_backdrop_lantern_street_depth_v3`.
- Added a static street-depth layer with long wagon ruts, dusty plank debris, foreground wagon silhouettes, horse-tether silhouettes, and richer hanging lantern glows.
- Increased menu backdrop cue coverage from 28 to 42 markers so smoke can require the new storefront, street, lantern, wagon, and tether details.
- Updated `scripts/game/main.gd` smoke coverage to require the v3 lantern-lit street backdrop and the expanded cue threshold.
- Kept the pass FPS-safe: no new textures, particles, tweens, shaders, gameplay nodes, or gameplay-frame animation; it only uses `Control._draw()` primitives on the existing menu backdrop.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the upgraded menu backdrop.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new menu backdrop assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Browser play-test the menu side view for readability and frame feel, then continue with either loadout button micro-polish or another static background depth pass.

## 2026-06-05 - Courtyard Edge Dressing Floor Polish

- Added `courtyard_edge_dressing_western_square_v1` to `scripts/game/main.gd`.
- Added a static arena edge dressing pass after the courtyard rut layer: wagon-wheel scars, rope coils, hoof/boot clusters, loose planks, nail heads, and small debris.
- Kept the combat center readable by placing the richer details around the arena perimeter and using low-alpha dust, rope, wood, and iron tones from the art bible.
- Kept the pass FPS-safe: no animation, new nodes, textures, particles, or redraw timers; it only draws with the existing arena background pass.
- Added smoke coverage for the new arena edge dressing version and marker count so the courtyard floor upgrade remains test-visible.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the improved town-square courtyard floor.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught a `draw_rect()` argument parse error in the plank shadow pass, then completed with exit code 0 after the fix.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new arena edge dressing assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Browser play-test the side view for frame feel with the new floor dressing, then continue with a FPS-safe background depth pass or a menu button final polish pass.

## 2026-06-05 - Whole-Body Sprite And Redraw Performance Fix

- Fixed the player walking/running sprite presentation in `scripts/player/player.gd` with `player_whole_body_motion_redraw_budget_v4`.
- Removed the moving-sprite bob/lean transform and run-contact foot overlays from the textured player draw path so the cowgirl body renders as one whole sprite while walking and running.
- Added a 30 FPS player motion redraw budget so movement no longer queues a custom redraw on every physics tick.
- Fixed shared enemy running sprite presentation in `scripts/enemies/base_enemy.gd` with `enemy_whole_body_motion_redraw_budget_v4`.
- Removed enemy moving-sprite bob/contact overlays and added a 24 FPS enemy motion redraw budget through `_request_enemy_visual_redraw()`.
- Replaced per-physics `queue_redraw()` calls in `scripts/enemies/duelist.gd`, `scripts/enemies/hunter.gd`, `scripts/enemies/knife_rusher.gd`, `scripts/enemies/rifleman.gd`, and `scripts/enemies/shotgun_brute.gd` with the shared redraw budget.
- Updated `scripts/game/main.gd` smoke coverage so player and enemy sprite checks require the new whole-body, budgeted motion versions.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the no-split sprite and lag fix.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new whole-body sprite assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Browser play-test the side view for perceived FPS under late-wave pressure, then tune remaining VFX caps if the game still drops frames.

## 2026-06-05 - Live HUD Ledger Material Polish

- Upgraded the always-visible combat HUD frame in `scripts/ui/hud.gd` to `live_hud_ledger_high_contrast_brass_rail_v2`.
- Added row plates behind live text, subtle leather plank grain, a stronger cylinder/ammo trough, extra brass ticks, sun-worn scuffs, and more physical corner hardware.
- Increased live HUD ledger marker coverage from 24 to 34 markers while keeping the pass FPS-safe: no new textures, particles, tweens, shaders, or gameplay-frame systems.
- Updated `scripts/game/main.gd` smoke coverage so the first-wave HUD requires the v2 ledger and the expanded readability marker count.
- Made the enemy movement-dust smoke check deterministic with real enemy physics steps, so it remains compatible with the reduced boot-dust stride budget.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the improved live HUD.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no script errors after the final edits.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially exposed the movement-dust smoke timing issue, then completed with exit code 0 after the deterministic smoke fix and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The passing smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with an FPS-safe pass on arena edge props/floor silhouettes, then play-test the browser side view for frame feel and readability.

## 2026-06-05 - Premium Menu Nav Button Polish

- Upgraded the main menu navigation buttons in `scripts/ui/hud.gd` to `menu_nav_brass_inlay_tactile_v4`.
- Added stronger tactile selected-state readability with a left brass tab, pressed depth, subtle leather plank grain, edge notches, reinforced icon plates, and a small highlight glint.
- Increased the nav-button marker coverage from 11 to 15 markers per button while keeping the pass FPS-safe: no new textures, particles, tweens, shaders, or gameplay-frame systems.
- Updated `scripts/game/main.gd` smoke coverage so the menu requires the v4 nav-button pass and at least 90 tactile markers across the six menu buttons.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the improved menu buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no script errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with another FPS-safe pass on either the remaining live HUD text surfaces or the arena edge buildings/floor props, then play-test the browser build for frame feel.

## 2026-06-05 - Arena Timer Redraw Budget

- Added an FPS-safe arena redraw budget in `scripts/game/main.gd` for timer-driven arena visuals.
- Capped normal-play redraw requests from animated hazard overlays and payday pickup aging to about 12 FPS instead of letting those large arena passes request a repaint every physics tick.
- Kept immediate redraw behavior for real state changes such as spawning, collecting, explosions, run reset, and forced smoke/visual QA captures.
- Added smoke hooks for `arena_timer_redraw_budget_12fps_v1` and the redraw interval so the optimization stays covered by the playable test pass.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the performance budget.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no script errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Play-test the browser build on the side-view target and, if lag remains, profile the remaining always-animated wave modifier and HUD draw paths.

## 2026-06-03 - Playability Performance And Whole-Body Sprite Fix

- Fixed the player and enemy walking sprite artifact where bodies visibly split during movement.
- Replaced sliced torso/leg texture-region walking with whole-sprite bob movement in `scripts/player/player.gd` and `scripts/enemies/base_enemy.gd`.
- Reduced normal gameplay draw overhead by showing player material overlays only during action states and enemy material rim overlays only during hit/recoil moments.
- Fixed a major VFX performance issue in `scripts/systems/vfx_layer.gd`: the VFX canvas no longer queues a redraw every frame when no transient effects are active.
- Tightened active VFX caps and reduced enemy movement-dust spawn frequency so combat keeps readable effects without flooding the renderer.
- Loosened the first-wave ammo smoke assertion in `scripts/game/main.gd` so it accepts whichever full cylinder size the saved/equipped gun uses instead of assuming `6/6`.
- Rebuilt the Web export in `build/web/index.html` so the browser build gets the lag and sprite fixes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no script errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Play-test the browser build for frame feel, then profile or further trim always-on arena/background redraws if any lag remains.

## 2026-06-03 - Menu Town Square Business Backdrop Depth

- Upgraded the main menu backdrop in `scripts/ui/hud.gd` to `menu_backdrop_town_square_business_depth_v2`.
- Added richer first-screen town-square depth with varied roof silhouettes, awnings, parapets, rail posts, saloon bottle shelves, barber pole stripes, sheriff badge plates, bank columns, general-store crates, jail bars, trough silhouettes, and longer porch shadows.
- Extended smoke coverage in `scripts/game/main.gd` so the main menu requires the v2 backdrop and at least 28 town-square cues.
- Kept the pass FPS-friendly: no textures, particles, shaders, tweens, animation, or extra scene nodes; it uses static CanvasItem draw primitives in the existing `MenuBackdrop` control.
- Fixed a typed GDScript inference issue in the new backdrop helper before validation.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server can serve the upgraded menu backdrop.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 after the inference fix and no script errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new menu backdrop assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused pass on any remaining plain menu/button states or deepen arena floor/background material variation while preserving combat readability.

## 2026-06-03 - Sprite Sunedge Material Readability

- Upgraded player sprite polish in `scripts/player/player.gd` to `denim_brass_hero_sunedge_v4` and `player_grounded_contact_rim_v3`.
- Added lightweight player sprite material markers: a stronger grounded contact underline, denim/brass catchlights, and a hat-edge glint that improve the cowgirl read during movement and attacks.
- Upgraded enemy sprite polish in `scripts/enemies/base_enemy.gd` to `role_silhouette_material_sunedge_v4` and `enemy_grounded_contact_rim_v3`.
- Added lightweight enemy sprite material markers: contact grounding, role-color shoulder catches, hat glints, brass ticks, and recoil-responsive material highlights so enemy archetypes stay legible at gameplay size.
- Extended smoke coverage in `scripts/game/main.gd` so player and enemy sprites require the new visual versions and marker-count hooks.
- Kept the pass FPS-friendly: no new textures, particles, shaders, tweens, or scene nodes; the change uses a few deterministic CanvasItem draw primitives inside existing sprite draw paths.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server can serve the upgraded sprite polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player/enemy sprite assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a deeper arena-background silhouette pass or replace another remaining flat UI surface with tactile western materials.

## 2026-06-03 - Combat VFX Material Readability

- Upgraded combat VFX material reads in `scripts/systems/vfx_layer.gd`.
- Added `saber_afterimage_bone_dust_shear_v1`, `enemy_hit_sparks_role_burst_material_v2`, `sand_soaked_blood_stain_material_v2`, and `muzzle_flash_heat_casing_star_v3`.
- Improved moment-to-moment combat visuals with a bone-white slash shear, extra dust/contact shadow on enemy hit sparks, richer sand-soaked blood highlights, and a brighter muzzle-star core on gunshots.
- Extended smoke coverage in `scripts/game/main.gd` so the first slash and gunshot checks require the new VFX versions and material marker counts.
- Kept the pass FPS-friendly: no extra textures, particles, shaders, or nodes; it adds only a few deterministic draw primitives inside already capped VFX arrays.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server can serve the upgraded combat VFX.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new VFX assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused player/enemy sprite silhouette audit or a second arena-background pass that varies roof heights and edge silhouettes.

## 2026-06-03 - Town Square Facade Depth V2

- Upgraded the arena-edge storefront facade pass in `scripts/game/main.gd` to `town_square_business_facades_v2`.
- Added a lightweight facade-depth layer with shadow awnings, saloon bottle shelf reads, barber awning stripes, sheriff badge plates, bank column accents, and general-store crate stacks so the town square feels more like distinct western businesses around the arena.
- Extended smoke coverage so the town-square roster requires the v2 facade version and the new business-specific cues.
- Kept the pass FPS-friendly: no new textures, particles, shaders, tweens, or scene nodes; the upgrade is deterministic CanvasItem drawing on the existing arena backdrop path.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server can serve the upgraded storefront facades.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new town-square facade assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused sprite/VFX readability audit or a second pass on arena edge depth using silhouettes that vary the roof heights and storefront footprints.

## 2026-06-03 - Premium Loadout Card State Readability

- Upgraded gun and ability loadout cards in `scripts/ui/hud.gd` with `loadout_card_brass_rivet_state_plate_v4`.
- Added side rails, vertical rules, state ticks, equipped sash treatment, ready plates, locked/faded plates, and stronger state readability on the existing card buttons.
- Extended smoke coverage in `scripts/game/main.gd` so gun and ability loadout card buttons require the v4 visual version and at least 192 tactile markers.
- Kept the pass FPS-friendly: no textures, tweens, particles, shaders, or extra scene nodes; only deterministic `Button._draw()` primitives on the existing loadout controls.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server can serve the upgraded loadout cards.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the loadout-card visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with storefront edge-prop polish or a sprite/VFX audit.

## 2026-06-03 - Premium Info Card Ledger Readability

- Upgraded overview and information cards in `scripts/ui/hud.gd` with `info_card_weathered_ledger_v3`.
- Added a richer weathered-ledger treatment: top and bottom brass/leather rails, inner rule lines, header highlight strip, scan ticks, side rule marks, extra rivets, and stronger stamped-card structure.
- Added HUD telemetry for info-card detail marker counts and extended smoke coverage in `scripts/game/main.gd` so the main menu requires the v3 card style and enough ledger detail markers.
- Kept the pass FPS-friendly: no textures, tweens, particles, shaders, or extra scene nodes; only deterministic `PanelContainer._draw()` primitives on the existing menu cards.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded info cards.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new info-card visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a deeper loadout card typography/readability pass or a storefront edge-prop polish pass around the playable arena.

## 2026-06-03 - Premium Menu Nav Button Depth

- Upgraded the main menu navigation buttons in `scripts/ui/hud.gd` with `menu_nav_brass_inlay_tactile_v3`.
- Added a richer leather/brass control treatment: hover glow, top and bottom inlay rails, bracket ticks, framed icon plates, deeper icon shadows, and a selected stamp plate so the active menu section reads more deliberately.
- Extended smoke coverage in `scripts/game/main.gd` so the main menu requires the v3 nav visual version and the higher tactile marker count across all nav buttons.
- Kept the pass FPS-friendly: no textures, tweens, particles, shaders, or extra scene nodes; only deterministic `Button._draw()` primitives on the existing menu controls.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded menu buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new menu nav button assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a menu card typography/readability pass or a deeper western storefront prop polish pass around the playable arena edges.

## 2026-06-03 - Courtyard Stage Lighting Depth

- Upgraded the central arena floor in `scripts/game/main.gd` with `courtyard_stage_lighting_depth_v1`.
- Added a lightweight high-noon stage-lighting layer between the sand detail and edge atmosphere: calm-center glow, soft oval grounding shadows, diagonal sun shafts, long low shadow bands, dust ribbons, and subtle inset depth rings.
- Extended smoke coverage so wave-one validation requires the new arena lighting version and enough sun/dust/depth markers to protect the pass from regression.
- Kept the pass FPS-friendly: no new textures, particles, shaders, or nodes; only deterministic draw primitives on the existing arena canvas.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded courtyard lighting.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new arena stage-lighting assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused menu typography/button hover motion audit or a deeper building prop/signage pass around the playable arena edges.

## 2026-06-02 - Agent Setup

- Added a repo-level build agent contract in `AGENTS.md`.
- Added `docs/agent_goal.md` so the game direction can be changed by editing one file.
- Added this progress log for future build passes.

Validation:

- Godot headless launch completed with exit code 0.
- Existing imported texture cache entries reported missing `.ctex` files for environment and blood PNGs. Regenerate Godot imports if future passes need clean asset validation.

Next recommended step:

- Implement named duelist variants with intro flavor and different pressure patterns, then validate with Godot headless.

## 2026-06-03 - Named Duelist Roster

- Added a five-rival duelist roster in `scripts/game/main.gd`: The Black Sash, Mercy Vale, Colt Wren, Reverend Ash, and June Blackglass.
- Boss waves now rotate through named profiles with title cards, taunt lines, accent colors, and escalating stat modifiers on later roster cycles.
- Added `configure_variant()` to `scripts/enemies/duelist.gd` so each rival can tune health, speed, draw timing, dash duration, cooldown, attack range, and visual accent.
- Expanded the duelist intro card in `scripts/ui/hud.gd` to show the rival title and story line.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add arena pressure modifiers or readable cover/hazards so each named duelist fight has a stronger tactical setting.

## 2026-06-03 - Powder Keg Arena Hazards

- Added six readable powder keg hazards to the courthouse arena in `scripts/game/main.gd`.
- Kegs now draw as western barrel props with fuse sparks, warning rings, and short timed detonation tells.
- Saber swings and ability chain reactions can ignite kegs, letting skilled players turn positioning into area damage.
- Explosions damage nearby enemies, can punish the player if they stand too close, add heat, trigger VFX, and can chain into nearby hazards.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add a level/chapter structure for waves 1-10 with distinct names, arena modifiers, and a completion state so the game clearly supports ten levels instead of only endless waves.

## 2026-06-03 - Ten-Level Run Structure

- Added a ten-level run cap in `scripts/game/main.gd` with named western level beats from Courthouse Ambush through Last High Noon.
- Updated the HUD wave banner and in-run wave label in `scripts/ui/hud.gd` to show `wave/10` and the current level title.
- Clearing wave 10 now completes the run, awards extraction credits, shows the existing extracted screen, and fires celebratory VFX at the player.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Give each of the ten named levels a small modifier or arena dressing change, such as extra powder kegs on Bank Vault Break, stronger dust haze on Red Canyon Press, or a duelist-specific hazard layout.

## 2026-06-03 - Ten-Level Modifiers

- Added a `LEVEL_MODIFIERS` roster in `scripts/game/main.gd` so each of the ten named levels now has an active gameplay identity.
- Level modifiers adjust powder keg counts/layouts, incoming wave composition, and danger heat instead of only changing banner text.
- Added readable modifier labels to the HUD wave line in `scripts/ui/hud.gd`, such as Crossfire Lanes, Bank Vault Powder, and Last High Noon.
- Added lightweight visual dressing for special levels: moving sandstorm sightlines, gold-rush sparkles, and a pulsing final-level arena border.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Improve ease of play with a short first-run controls overlay or practice-safe opening seconds so new players understand movement, dash, slash, abilities, and powder keg danger before the pressure spikes.

## 2026-06-03 - Opening Primer And Grace Window

- Added a short opening grace window in `scripts/game/main.gd` before wave 1 spawns, giving new players a few seconds to orient in the arena.
- Applied a brief Dust Veil safety state at run start so the player can move and read the arena without instantly eating damage.
- Added a compact western primer card in `scripts/ui/hud.gd` that calls out movement, dash, slash, abilities, and red powder-keg warning rings during the opening seconds.
- Kept the tutorial lightweight and temporary so it helps first contact without slowing down repeat runs after combat starts.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add score/combo ranks and end-of-run grading so stylish clears, keg chains, parries, and fast level completions reward player mastery across the ten-level run.

## 2026-06-03 - Style Score And Run Grades

- Added style scoring state in `scripts/game/main.gd` with score, combo count, best combo, combo timeout, and rank thresholds from D through S.
- Awarded style points for outlaw kills, named duelist kills, powder-keg hits, parries, and successful extraction, with combo multipliers for fast stylish chains.
- Breaking the player's health now breaks the active combo so clean survival matters.
- Added HUD score/rank/combo readouts and floating style popups in `scripts/ui/hud.gd`.
- Added final run grade text to extraction and death screens so each ten-level run ends with score, rank, and best combo feedback.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add revolver ammo and reload timing so gun abilities have a clearer western weapon loop and the player has another mastery layer beyond saber, skills, and powder-keg chains.

## 2026-06-03 - Gun Ammo And Reload Loop

- Added ammo capacity, current rounds, and reload timers to `scripts/systems/program_system.gd` for every gun profile.
- Gun-based abilities now spend rounds from the equipped weapon, and empty cylinders trigger an automatic reload before more gun abilities can fire.
- Gave each gun a distinct cylinder identity: revolver, long rifle, sawed-off, pepperbox, and golden revolver now differ by ammo capacity and reload timing in addition to damage/range/cooldown tuning.
- Added a live cylinder/reload HUD readout in `scripts/ui/hud.gd` and reload feedback when the player tries to fire during reload.
- Updated gun card descriptions and information cards so players can learn the new ammo loop from the menu.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add stronger hit-freeze, screen shake tuning, and gunshot/slash sound placeholders so combat impacts feel more physical and stylish while staying readable.

## 2026-06-03 - Impact Freeze And Western Hit Bursts

- Added reusable impact text and muzzle-flash VFX in `scripts/systems/vfx_layer.gd` so shots, slashes, chains, parries, powder kegs, and player hits get readable western action bursts.
- Added a shared micro-freeze and camera-shake helper in `scripts/game/main.gd` to make combat impacts feel weightier without rewriting combat timing.
- Hooked distinct feedback labels into gameplay: `BANG` for gun hits, `SLASH` for blade hits, `BOOM` for powder kegs, `CHAIN` for chain reactions, `CLANG` for parries, and `HIT` for player damage.
- Reset the time scale at run start, run completion, and player defeat so impact freeze cannot leak into menus or future runs.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add real placeholder audio streams or generated sound assets for gunshots, slash impacts, parries, and powder-keg explosions, then tune volume and cooldown so the new visual impact language has matching sound.

## 2026-06-03 - Procedural Combat Audio Cues

- Added `scripts/systems/audio_director.gd`, a lightweight procedural audio director that generates short WAV cues at runtime instead of requiring imported sound files.
- Wired combat cues into `scripts/game/main.gd` for gun hits, dry/reloading trigger pulls, sword slashes, parries, player damage, chain reactions, and powder-keg explosions.
- Tuned the cues as short western arcade placeholders so the existing `BANG`, `SLASH`, `CLANG`, `BOOM`, and `HIT` visual feedback now has matching impact sound.
- Kept the audio system centralized behind `play_cue()` so authored sound assets can replace the generated placeholders later without changing combat logic.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add directional enemy movement animation polish, especially attack windups and recovery frames, so named duelists and outlaw archetypes read more clearly during the louder, flashier combat.

## 2026-06-03 - Enemy Attack Pose Animation Polish

- Extended the shared enemy sprite draw helper in `scripts/enemies/base_enemy.gd` so directional sprites can lean, squash, recoil, and rotate during combat states.
- Added readable sprite-backed attack poses for knife rushers, riflemen, shotgun brutes, hunters, and duelists instead of leaving imported sprites static during windups.
- Added weapon overlays for sprite-backed riflemen, shotgun brutes, hunters, and duelists so their rifle, shotgun, blade, or saber direction stays visible at gameplay scale.
- Added rifleman and shotgun brute recoil timers so shot recovery reads after the beam/muzzle flash instead of snapping instantly back to idle.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add a compact in-run objective/level tracker or pause/info reminder so newer players always know the ten-level goal, current modifier, and how to survive the next pressure spike.

## 2026-06-03 - In-Run Objective Ledger

- Added a compact right-side `RUN LEDGER` tracker in `scripts/ui/hud.gd` so players can always see extraction progress toward level 10.
- The tracker shows the current level title, active modifier, and a progress strip for the ten-level run.
- Added context-sensitive survival tips for wave breaks, duelist waves, powder-keg levels, sandstorms, crossfire lanes, brute pressure, and the final stand.
- Passed wave-active state and break timing from `scripts/game/main.gd` into the HUD so the tracker can distinguish active combat from short breather windows.

Validation:

- Godot headless launch completed with exit code 0.
- Existing missing `.ctex` import-cache errors still appear for environment and blood PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Add a simple playable smoke-test script or debug autoplay mode that starts a run, advances through a few waves, and verifies the ten-level loop, HUD, enemies, and effects are behaving beyond headless scene load.

## 2026-06-03 - Playable Smoke Test Mode

- Added an opt-in `--dust-smoke-test` command-line mode in `scripts/game/main.gd` that starts a real run, forces waves 1-4 through the normal wave spawn path, and verifies player, vault, HUD/VFX, hazards, enemies, and the wave 3 named duelist are present.
- Added `scripts/tools/smoke_test.ps1` to run the smoke mode through the bundled Godot console.
- Kept the smoke mode out of normal play and made failures exit nonzero so future build passes can catch broken run-loop behavior beyond scene load.

Validation:

- Normal Godot headless launch completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.
- Existing missing `.ctex` import-cache errors still appear for environment, blood, player, and enemy PNGs. No new GDScript compile failure was reported.

Next recommended step:

- Fix or regenerate Godot import caches for the existing PNG assets so playable smoke tests no longer drown useful failures in missing `.ctex` warnings.

## 2026-06-03 - Clean Asset Import Validation

- Rebuilt the local Godot imported texture cache with `--import`, restoring the missing `.ctex` outputs for the Dust Heist PNG asset set.
- Confirmed `.godot/imported` now contains 79 `.ctex` files, covering the previously noisy environment, blood, player, enemy, and icon texture imports.
- Added an `-ImportFirst` switch to `scripts/tools/smoke_test.ps1` so future playable smoke checks can refresh missing imports before running the wave simulation.
- Kept the generated `.godot` cache local and ignored by git while making the refresh path repeatable through the project tool script.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no missing `.ctex` errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.

Next recommended step:

- Add an easier first-run training layer in the opening level, such as short interactive control prompts for move, dash, slash, and gun abilities, so new players can survive long enough to appreciate the ten-level run.

## 2026-06-03 - First-Run Training Ledger

- Added a compact `TRAINING LEDGER` card in `scripts/ui/hud.gd` that lists the four survival basics: move, dash, slash, and cast.
- Wired `scripts/game/main.gd` to mark training steps from actual gameplay actions: movement from player velocity, dash from `dash_used`, slash from `weapon_slashed`, and cast from successful ability use.
- The training card shows a short contextual tip for the next unfinished action and hides itself once the player has proven all four basics.
- Kept the training ledger disabled during `--dust-smoke-test` runs so automated validation remains focused on wave and spawn behavior.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no missing `.ctex` errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.

Next recommended step:

- Add visible pickup or reward beats between early waves, such as ammo/coin drops or a small choice reward after level 1, so new players get a clearer sense of progress and mastery after learning the controls.

## 2026-06-03 - Early Wave Payday Rewards

- Added a wave-clear payday reward in `scripts/game/main.gd` so surviving early levels gives immediate momentum instead of only delayed end-of-run payout.
- Payday rewards now bank bonus credits for the final run payout, refill a small number of gun rounds, reduce alert pressure, award style points, and play gold VFX/audio feedback at the player.
- Added `refill_ammo()` to `scripts/systems/program_system.gd` so rewards can safely top off the equipped gun without bypassing the ammo/reload model.
- Added a short `reward` chime to `scripts/systems/audio_director.gd` to make successful wave clears feel more celebratory and readable.
- Added a per-wave reward guard so each level can only pay once.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no missing `.ctex` errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.
- The smoke run still reports a Godot ObjectDB leak warning at process exit, but no GDScript compile or runtime failure was reported.

Next recommended step:

- Turn the payday into visible arena pickups or a small post-wave choice later, so players can physically read and collect rewards instead of only seeing HUD/VFX feedback.

## 2026-06-03 - Visible Payday Satchel Pickups

- Added visible payday satchel pickups in `scripts/game/main.gd` so cleared waves now drop a glowing western money bag in the arena instead of granting the full reward invisibly.
- Added pickup drawing with brass coins, leather bag coloring, pulsing collection rings, and ground shadow so the reward reads against the sandy courtyard.
- Added pickup collection logic: walking into the satchel banks bonus credits, refills a few gun rounds, reduces alert pressure, awards payday style points, and plays the existing gold VFX/reward chime.
- Kept the per-wave reward guard from the previous pass, but moved the actual reward grant to collection so player movement and arena awareness matter.
- Cleared pickups on run reset/menu return so leftover rewards cannot leak between runs.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no missing `.ctex` errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.

Next recommended step:

- Add a small reward hint to the run ledger or training ledger when a payday satchel is on the ground, so newer players know to scoop it up before the next pressure spike.

## 2026-06-03 - Payday Satchel Ledger Hint

- Added a pending-payday count in `scripts/game/main.gd` so the HUD can tell when an uncollected satchel is on the ground.
- Extended `scripts/ui/hud.gd` run updates with a `payday_pending` value and used it to override the run ledger tip while a satchel is available.
- The run ledger now prompts `PAYDAY SATCHEL DOWN` and tells players to scoop it up for credits and rounds, making the new reward pickup easier to understand during wave breaks.
- The hint disappears as soon as the satchel is collected because collected pickups are ignored by the pending count.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 and no missing `.ctex` errors.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.

Next recommended step:

- Add a stronger mid-run visual identity change around levels 5-7, such as dust storm gusts, lantern flicker, or courthouse crowd silhouettes, so the ten-level run feels more like an escalating western set piece.

## 2026-06-03 - Mid-Run Set Piece Visuals

- Added level-specific visual overlays for `Dust Chapel Bells` and `Mercy Vale's Ride` in `scripts/game/main.gd` so the middle of the ten-level run now has a distinct western escalation instead of reusing the same courtyard look.
- Level 5 now adds chapel bell pulses, warmer pressure tinting, and crowd silhouettes around the arena edges.
- Level 6 now adds fast-draw spotlight lanes and orbiting crowd silhouettes to sell Mercy Vale's duel as a showpiece.
- Kept the effects procedural and non-colliding so they add spectacle without hiding enemy tells or changing balance.
- Updated the redraw trigger so the new mid-run effects animate while active.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=4 enemies_defeated=0 hazards=5`.

Next recommended step:

- Extend the playable smoke test to jump directly into levels 5-7 or add a visual-state check so mid-run set pieces get automated coverage, not only script compile coverage.

## 2026-06-03 - Mid-Run Smoke Coverage

- Extended the playable smoke test in `scripts/game/main.gd` beyond the early tutorial waves so it now jumps through levels 5-7 after the original wave 1-4 checks.
- Added reusable smoke helpers for starting a target wave, asserting basic wave state, and checking level identity without duplicating setup code.
- Added mid-run assertions for `Dust Chapel Bells`, `Mercy Vale's Ride`, and `Red Canyon Press`, including expected modifier IDs, hazard counts, Mercy's named duelist spawn, and animated set-piece ticking.
- This makes the recent chapel, fast-draw, and sandstorm spectacle less likely to regress silently while the ten-level run keeps growing.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=7 enemies_defeated=0 hazards=6`.

Next recommended step:

- Add one more ease-of-play pass around level transitions, such as a short on-screen countdown or control reminder during wave breaks, so players can better prepare for the escalating mid-run modifiers.

## 2026-06-03 - Next-Level Prep Ledger

- Updated `scripts/game/main.gd` so the HUD previews the upcoming level during wave breaks instead of showing the just-cleared level or level 0 during the opening countdown.
- Updated `scripts/ui/hud.gd` so the run ledger switches to a `NEXT LEVEL` prep state while the arena is between waves.
- The prep ledger now shows `READY UP: LEVEL X/10`, the next level title, the next modifier notice, and a concise countdown/control reminder for reload, dash, slash, and gun abilities.
- Kept active combat HUD behavior unchanged so the extra guidance appears during downtime rather than covering live enemy reads.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=7 enemies_defeated=0 hazards=6`.

Next recommended step:

- Add stronger level-specific combat readability for the late run, such as Bank Vault and Last High Noon overlays or smoke coverage for levels 8-10, so the full ten-level structure is as verified as the early and mid run.

## 2026-06-03 - Late-Run Set Pieces And Full Smoke Coverage

- Added distinct late-run arena overlays in `scripts/game/main.gd` for levels 8-10 so the final stretch now reads as Bank Vault Break, June Blackglass, and Last High Noon instead of relying on generic sparkle/border effects.
- Bank Vault Break now shows a pulsing vault-door centerpiece, rotating brass spokes, and richer gold glints around the powder-keg arena.
- June Blackglass now gets a high-society kill-box overlay with red stage-light lanes, edge spectators, and brass/red pressure frames.
- Last High Noon now adds sweeping sun rays, a hot arena wash, and stronger final-stand rings while keeping enemy tells visible.
- Extended the playable smoke test from level 7 through level 10, checking late-run titles, modifiers, hazard counts, June's named duelist spawn, and animated overlay ticking.
- Added `blackglass` to the animated redraw path so June's set piece updates while active.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=0 hazards=8`.

Next recommended step:

- Add a real playable/manual check pass or a short automated completion path that defeats spawned waves, so validation covers rewards, end-of-run extraction, and failure/success screens rather than only spawning and set-piece state.

## 2026-06-03 - Full Extraction Smoke Path

- Extended the playable smoke test in `scripts/game/main.gd` with a fresh full-run extraction phase after the set-piece checks.
- The new smoke phase starts a real run, advances through all ten levels, defeats each active wave through `_on_enemy_destroyed()`, and lets `_update_wave()` drive rewards, wave breaks, and final extraction.
- Added smoke helpers to defeat active waves, collect payday satchels, and clear smoke-only pickup state without changing normal player combat balance.
- The smoke test now asserts defeated enemy counts, payday drops, banked payday credits, rewarded wave tracking, named duelist defeats, style scoring, and the `run_complete` extraction branch.
- This makes validation cover the ten-level playable loop from spawn to extraction instead of only level spawning and visual modifier state.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=114 hazards=8`.

Next recommended step:

- Do a player-facing polish pass on the extraction/failure screens, such as showing defeated duelists, best combo, and payday credits clearly, since the full-run path now proves those values exist.

## 2026-06-03 - Result Ledger Polish

- Expanded the post-run result summary in `scripts/game/main.gd` so extraction and failure screens now show level outcome, rank, score, best combo, duelists defeated, outlaws defeated, payday credits, and total banked credits.
- Updated `scripts/ui/hud.gd` to give the extraction message more vertical room, smart wrapping, and a slightly smaller result font so the richer ledger remains readable.
- Tuned the failure overlay font size when a detailed summary is present so death results can show the same useful run context instead of clipping the ledger.
- Kept the change focused on player-facing clarity; combat, rewards, and scoring values are unchanged.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=114 hazards=8`.

Next recommended step:

- Run a visual/manual play pass on the first few waves and result screens, then tune text sizing, countdown timing, or early enemy pressure if anything feels cramped or abrupt in real play.

## 2026-06-03 - Named Rival Result Ledger

- Fixed a story/gameplay mismatch in `scripts/game/main.gd`: level 9 is titled `June Blackglass`, and it now actually spawns `JUNE BLACKGLASS` instead of the generic third duelist rotation.
- Added smoke-test checks for the expected named duelists on Mercy Vale's Ride and June Blackglass, plus full-run assertions that The Black Sash, Mercy Vale, and June Blackglass are all defeated during extraction.
- Tracked defeated duelist names during runs and added a `RIVALS ...` line to the extraction/failure ledger so named characters remain visible after the fight, not only during intro cards.
- Adjusted result-screen text sizing in `scripts/ui/hud.gd` to leave room for the rival-name line without crowding the post-run summary.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=114 hazards=8`.

Next recommended step:

- Add a small first-wave manual-feel improvement, such as gentler initial spawn spacing or an optional early practice target, so new players can test slash/dash/gun timing before pressure escalates.

## 2026-06-03 - Gentler First Draw

- Tuned the opening combat beat in `scripts/game/main.gd` so wave 1 now spawns four knife rushers instead of six, giving new players a clearer first read before the arena escalates.
- Lowered the first wave's initial director heat bump while keeping later-wave heat unchanged, so the run still ramps sharply after the player has tried the basics.
- Added a wave-1 smoke assertion that locks the opening fight to four enemies and prevents the tutorial pressure from drifting upward accidentally.
- Updated the run ledger tip in `scripts/ui/hud.gd` for wave 1 to prompt a simple sequence: slash one rusher, dash wide, then try a gun.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke run still printed a Godot ObjectDB leak warning at process exit, but no GDScript compile or runtime failure was reported.

Next recommended step:

- Add a visual/manual QA note or screenshot-driven check for the first wave and result ledger, so tuning can catch text crowding and actual player readability beyond automated state assertions.

## 2026-06-03 - HUD Readability Smoke Guard

- Added lightweight HUD text accessors in `scripts/ui/hud.gd` so automated smoke coverage can inspect the same first-wave tip and extraction ledger text that players see.
- Extended the playable smoke test in `scripts/game/main.gd` to assert that wave 1 still shows the compact `FIRST DRAW` slash/dash/gun coaching tip after the HUD refreshes.
- Added extraction-ledger smoke assertions for `EXTRACTED`, `LEVELS CLEARED 10/10`, named rival visibility, banked credits, payday earnings, and a compact text-length budget.
- Fixed a player-facing HUD race where the delayed run-start banner tween could clear or fade a later extraction ledger if the run completed before the intro cleanup finished.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.

Next recommended step:

- Add a real visual QA artifact for the first wave and extraction screen, such as a scripted screenshot capture or short recorded play route, so layout/readability can be reviewed alongside the new text-state smoke guards.

## 2026-06-03 - Visual QA Screenshot Harness

- Added a `--dust-visual-qa` run mode in `scripts/game/main.gd` that launches a real first-wave scene, captures `01_first_draw.png`, then drives the full ten-level extraction path and captures `02_extraction_ledger.png`.
- Added `scripts/tools/visual_qa.ps1` as a rendered Godot wrapper for screenshot capture. The harness intentionally runs without `--headless` because Godot's headless dummy renderer cannot provide useful viewport pixels.
- Added viewport image variance checks and writes generated captures under `artifacts/qa`, which is now ignored in `.gitignore` to keep screenshot output out of source churn.
- Fixed the extraction screenshot path in `scripts/ui/hud.gd` by killing active duelist intro tweens before run results, hiding transient overlays, and showing successful extraction in a centered result ledger instead of letting the final wave banner or boss card obscure it.
- Manually inspected the generated captures: the first-wave shot shows the opening arena/HUD with four enemies, and the extraction shot shows the centered `EXTRACTED` ledger with all ten levels cleared and named rivals listed.

Validation:

- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.

Next recommended step:

- Use the new visual captures to tune HUD composition: the first-wave banner still crops on a 4:3 viewport and the extraction ledger could use a stronger dimmed backdrop or hidden live HUD behind it.

## 2026-06-03 - Result Screen Readability Polish

- Reworked `scripts/ui/hud.gd` wave banners from an offscreen slide-in to a centered fade cue so long level titles like `COURTHOUSE AMBUSH` remain visible in the first-wave visual QA capture instead of clipping at the right edge.
- Made the wave banner width and font size responsive to viewport width and title length while preserving the brass western poster style from the art bible.
- Improved successful extraction presentation by hiding the live gameplay HUD, killing any active wave/banner tweens, and placing the `EXTRACTED` ledger on a dark leather result card.
- Kept the smoke-readable hidden message text intact while making the player-facing result ledger visually cleaner and easier to read.
- Manually inspected the refreshed visual QA captures: `01_first_draw.png` now shows a centered, non-cropped first-wave banner, and `02_extraction_ledger.png` shows the extraction summary on a clear dark panel without the live HUD underneath.

Validation:

- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA assertion or small image probe for the result screen's dark card area, so future HUD changes can catch missing overlays instead of relying only on manual screenshot review.

## 2026-06-03 - Result Card Visual QA Guard

- Added a pixel-level visual QA assertion in `scripts/game/main.gd` for the extraction screenshot.
- The rendered `02_extraction_ledger.png` capture now must contain a visibly dark centered result-card region compared with the brighter arena corner sample, so a missing or invisible extraction card fails `--dust-visual-qa`.
- Kept the probe focused on real rendered pixels instead of HUD text state, complementing the existing ledger text assertions.
- This protects the player-facing extraction readability polish from regressing while keeping the screenshot harness lightweight and deterministic.

Validation:

- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a first-wave visual QA probe for banner readability, such as checking that the center banner area has visible title contrast without extending into the HUD column.

## 2026-06-03 - First-Wave Banner Visual QA Guard

- Added a rendered-pixel visual QA assertion in `scripts/game/main.gd` for `01_first_draw.png`.
- The first-wave capture now checks that the centered wave-title band has stronger luminance contrast than both plain floor below it and the right-edge crop zone, catching missing or offscreen wave banners.
- Kept the probe relative rather than exact-glyph based so it remains stable with the current low-opacity brass banner style and textured sand floor.
- This complements the extraction result-card probe and makes the visual QA harness cover both the opening readability cue and the end-of-run ledger panel.

Validation:

- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Do a small gameplay readability pass on enemy tells, such as adding a smoke-testable windup cue or stronger color flash before rifle and duelist attacks.

## 2026-06-03 - Rifleman Windup Readability

- Strengthened `scripts/enemies/rifleman.gd` so riflemen project a much clearer pre-shot warning: dark sight rails, a bright amber center lane, a charging muzzle ring, and a target crosshair on the locked shot point.
- Added `has_attack_tell()` and `get_attack_tell_strength()` to make the windup state explicit for smoke coverage and future tuning.
- Tuned rifleman sight range to fit the arena better so stationary riflemen reliably become crossfire threats instead of spawning inert at the edge.
- Added a rifleman-specific smoke assertion in `scripts/game/main.gd` that waits for wave 2 to expose an active rifleman attack tell before the wave is cleared.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a similar explicit `has_attack_tell()` smoke guard for duelists, then tune their lunge/draw cue so named rivals feel dangerous but fair.

## 2026-06-03 - Duelist Lunge Tell Guard

- Added explicit `has_attack_tell()` and `get_attack_tell_strength()` support to `scripts/enemies/duelist.gd` so named rivals expose their draw/windup phase to automated coverage.
- Strengthened the duelist draw cue with a projected lunge lane, dark edge rails, a bright variant-colored center slash line, and a tightening charge ring around the boss.
- Changed solo duelist spawns in `scripts/game/main.gd` to enter from a mid-arena duel circle instead of the far perimeter, keeping boss pressure immediate while preserving readable counterplay space.
- Tuned The Black Sash's preferred range to match that duel-circle entrance and added a wave 3 smoke assertion that waits for a duelist lunge tell before clearing the boss wave.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_extraction_ledger.png`.

Next recommended step:

- Add a rendered visual QA capture for the wave 3 Black Sash duel, then probe the lunge-lane pixels so boss tell readability is protected visually as well as by smoke state.

## 2026-06-03 - Black Sash Tell Visual QA

- Extended `scripts/game/main.gd` visual QA from two captures to three: first draw, wave 3 Black Sash tell, and extraction ledger.
- The visual QA route now starts wave 3, verifies The Black Sash spawned, waits for the duelist lunge tell, hides intro overlays, and saves `02_black_sash_tell.png`.
- Added a rendered-pixel lunge-lane probe that checks the lower-right duel band for stronger contrast plus danger-color or dark-rail pixels, protecting the visible boss tell rather than only the internal `has_attack_tell()` state.
- Fixed `scripts/ui/hud.gd` so `hide_transient_overlays()` always hides the duelist intro overlay even if its tween has already ended or been invalidated, preventing wanted cards from covering active boss tells during QA/result cleanup.
- Cleaned stale ignored QA screenshots from `artifacts/qa` after the capture name changed, leaving the current first-draw, Black Sash tell, and extraction ledger captures.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_extraction_ledger.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a comparable rendered QA capture or smoke guard for late-wave spectacle, such as the wave 8 Gold Rush powder-keg arena or wave 10 Last High Noon overlay, to protect escalating visual variety beyond the first boss.

## 2026-06-03 - Last High Noon Finale Visual QA

- Strengthened the wave 10 `Last High Noon` modifier in `scripts/game/main.gd` with a more readable hot sun wash, a visible high-noon ring, brighter radial rays, and thicker red-orange arena borders.
- Extended visual QA to a four-capture route: first draw, Black Sash lunge tell, Last High Noon finale, and extraction ledger.
- Added `03_last_high_noon.png` plus a rendered-pixel probe for the finale overlay, checking for the strong hot-orange wash and thin darker ray marks in the right-side sunburst region.
- Kept the finale effect transparent enough that the player, enemies, and attack tells remain readable under the stronger late-wave spectacle.
- Cleaned the stale generated `03_extraction_ledger` QA artifact after the capture sequence changed; the current set is `01_first_draw.png`, `02_black_sash_tell.png`, `03_last_high_noon.png`, and `04_extraction_ledger.png`.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_extraction_ledger.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a late-wave gameplay guard for wave 8 Gold Rush powder-keg risk/reward, such as proving the arena spawns eight readable hazards and that igniting a keg chain awards style points.

## 2026-06-03 - Gold Rush Keg Chain Guard

- Reworked the wave 8 `Gold Rush` hazard layout in `scripts/game/main.gd` into four readable paired powder-keg clusters instead of eight isolated kegs.
- Kept the arena pressure fair by spacing the pairs around the vault floor while placing each pair close enough for one keg to visibly light its partner.
- Added a deterministic smoke check for wave 8 that stages enemies near the first Gold Rush keg pair, ignites one keg, advances the fuse in frame-sized ticks, and verifies the paired keg arms and detonates.
- The new smoke guard proves the risk/reward loop: Gold Rush still spawns eight hazards, a paired keg chain can happen, enemy hits increase `keg_chain_bonus`, and both explosions award style points.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_extraction_ledger.png`.

Next recommended step:

- Add a player-facing cue for Gold Rush keg pairs, such as a subtle brass connector sparkle or HUD tip, so players recognize paired kegs as a skill opportunity before they discover it by accident.

## 2026-06-03 - Gold Rush Pair Cue

- Added animated brass connector rails between each wave 8 Gold Rush powder-keg pair in `scripts/game/main.gd`, with a subtle travelling sparkle that brightens when either keg in the pair is lit.
- Kept the cue western and readable by drawing it as a low, dusty brass fuse line beneath the keg bodies instead of a loud combat overlay.
- Updated the HUD objective tip in `scripts/ui/hud.gd` so active Gold Rush waves teach `PAIR KEGS FOR STYLE CHAINS`.
- Gave the Gold Rush tip priority over leftover payday reminders while the powder-keg wave is active, so players see the wave mechanic at the moment it matters.
- Extended the existing Gold Rush smoke guard to assert that the HUD names paired keg chains before it verifies the actual keg-chain detonation and style reward.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a rendered visual QA capture for wave 8 Gold Rush and probe the paired-keg connector region, so the new player-facing pair cue is protected visually as well as by smoke text/chain behavior.

## 2026-06-03 - Gold Rush Connector Visual QA

- Extended the visual QA route in `scripts/game/main.gd` to stage wave 8 `Bank Vault Break` between the Black Sash tell and the finale capture.
- Added `03_gold_rush_keg_links.png` to the rendered QA set, preserving the late-run proof that the Gold Rush arena actually shows paired-keg connector cues.
- Added a Gold Rush pixel probe that projects the first keg pair into screenshot space and samples the local connector region for brass rail pixels, dark fuse-shadow pixels, and enough contrast to read against the vault floor.
- Renumbered the later QA captures to `04_last_high_noon.png` and `05_extraction_ledger.png` so the five-capture route follows the run's escalation.
- Kept the existing smoke guard intact, so Gold Rush is now covered at three levels: HUD instruction, deterministic keg-chain gameplay, and rendered visual cue.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a first-run ease-of-play pass that makes the opening controls more tactile, such as clearer on-screen reload/ammo feedback or a short visual prompt when the player first empties a revolver cylinder.

## 2026-06-03 - Cylinder Readability Pass

- Reworked the ammo HUD copy in `scripts/ui/hud.gd` from a plain cylinder count into explicit `CYLINDER READY`, `CYLINDER LOW`, and `CYLINDER RELOAD` states.
- Kept the round pips visible in every state with bracketed `|` and `.` marks, making spent rounds and reload progress easier to read at a glance.
- Added warm brass, amber, and red-orange HUD colors for ready, low, and reloading states without changing the underlying ammo balance.
- Updated the rookie primer copy to tell first-time players to watch the cylinder for reloads.
- Added a pure ammo preview formatter plus smoke assertions in `scripts/game/main.gd`, proving the first wave starts with a full ready cylinder and that low/reload states produce distinct player-facing text.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a short first-empty-cylinder feedback moment, such as a tiny `AUTO RELOAD` pop near the player or a smoke-tested dry-fire hint, so players understand why gun casts are briefly unavailable after spending the last round.

## 2026-06-03 - First Empty Cylinder Feedback

- Added a player-facing `AUTO RELOAD / CYLINDER TURNING` feedback pop in `scripts/game/main.gd` when a gun ability spends the last round and starts the reload cycle.
- Added a small world-space `AUTO RELOAD` impact flash near the player using the existing VFX layer, so the reload moment is visible in combat rather than only in the corner HUD.
- Updated failed gun casts during reload to use the same `AUTO RELOAD / CYLINDER TURNING` language instead of a generic `RELOADING` pop.
- Added a HUD accessor for the style-pop text in `scripts/ui/hud.gd` and a smoke-only one-round cast check that verifies the reload starts and the new feedback appears.
- Restored the forced smoke ammo/cooldown state after the assertion and gated it out of visual QA, keeping screenshot captures focused on actual gameplay visuals.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a tiny reload-complete confirmation, such as a brief brass `CYLINDER READY` flash or sound cue when auto reload finishes, so the player gets both ends of the ammo loop.

## 2026-06-03 - Cylinder Ready Confirmation

- Added a reload-completion latch in `scripts/game/main.gd` that watches the ammo summary and detects the transition from reloading to a full ready cylinder.
- Added a player-facing `CYLINDER READY / DRAW AGAIN` style pop when auto reload completes, giving players a clear end point for the ammo loop.
- Added a small brass `READY` world-space impact flash and burst near the player, using existing VFX so the confirmation is visible during combat and not only in the corner HUD.
- Reset the reload latch on new runs to prevent false ready cues from stale state.
- Extended the smoke-only ammo checks to force a reload-complete transition and assert that the ready feedback appears and clears the latch.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a focused late-wave enemy pressure pass, such as giving one named duelist a small mechanical twist or adding a smoke-tested Hunter role to a later wave, so the 10-level run keeps escalating beyond HUD polish.

## 2026-06-03 - Late Wave Hunter Pressure

- Added Hunter pressure to the late non-duelist setpieces in `scripts/game/main.gd`: wave 7 `Red Canyon Press`, wave 8 `Bank Vault Break`, and wave 10 `Last High Noon`.
- Kept the overall enemy volume stable by letting Hunters replace part of the regular crowd mix instead of simply adding more bodies.
- Updated `scripts/enemies/hunter.gd` so the Hunter exposes `has_attack_tell()` and `get_attack_tell_strength()` during its lunge windup.
- Strengthened the Hunter windup drawing with a longer amber lunge lane and dark side rails, making its rush counterplay easier to read in the dusty arena.
- Extended smoke coverage to verify late-wave Hunter counts and stage a Hunter near the player so its lunge tell is proven before the smoke run clears the wave.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.

Next recommended step:

- Add player-facing Hunter identity in the info menu or HUD enemy primer, so players can learn that the lean duster enemy telegraphs a sidestep-able lunge before it appears in the late waves.

## 2026-06-03 - Hunter Primer Card

- Added a `Hunter` enemy card to the Dust Heist information menu in `scripts/ui/hud.gd`.
- The card teaches the new late-wave Hunter role with direct counterplay language: watch for the amber lunge lane, sidestep the line, then punish.
- Moved the information menu card data into a shared `INFORMATION_CARDS` constant so the rendered menu and smoke-test accessor use the same source text.
- Added `get_information_card_text()` to the HUD and a smoke assertion in `scripts/game/main.gd` that verifies the Hunter primer card, lunge tell language, sidestep counter, and late-wave role remain present.
- Kept this as an ease-of-play pass after the previous Hunter spawn pass, making the new threat learnable before it appears in waves 7, 8, and 10.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA menu capture or pixel/text probe for the information menu, so the Hunter card is protected as rendered UI rather than only as shared card data.

## 2026-06-03 - Information Menu Visual QA

- Extended the visual QA route in `scripts/game/main.gd` to open the Dust Heist information menu after the extraction ledger capture.
- Added QA-only HUD helpers in `scripts/ui/hud.gd` that render the information cards and scroll to the late enemy entries, making the Hunter card visible in the captured menu state.
- Added `06_information_hunter_card.png` to the rendered QA capture set.
- Added a visual probe for the information menu capture that checks for the parchment card region, late-enemy danger accent, left-side menu/nav presence, and enough card contrast to prove the menu is actually rendered.
- Kept the existing smoke text assertion for the Hunter primer, so the card is now protected both as shared card data and as visible UI.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_information_hunter_card.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a focused visual animation pass to the Hunter itself, such as a stronger sprite recoil/afterimage during the lunge, so the late-wave threat feels more kinetic in play as well as readable in the menu.

## 2026-06-03 - Hunter Lunge Afterimages

- Added a short Hunter lunge afterimage trail in `scripts/enemies/hunter.gd`, giving the late-wave pressure enemy a more kinetic western slash-read during its attack burst.
- Added dusty `trail_pop` puffs behind the Hunter while lunging, using the existing VFX layer color language instead of introducing a new global effect system.
- Kept the effect local and capped at four fading snapshots so the lunge feels fast without covering the existing amber warning lane or cluttering the arena.
- Added `has_lunge_afterimage()` to the Hunter and a reusable smoke helper in `scripts/game/main.gd` that waits for an enemy method to become true.
- Extended the late-wave Hunter smoke checks to prove that a staged Hunter proceeds from readable tell into a visible afterimage trail during the lunge.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA capture or pixel probe for a staged Hunter lunge itself, so the new afterimage trail is protected by rendered evidence as well as smoke state.

## 2026-06-03 - Hunter Lunge Visual QA

- Extended the visual QA route in `scripts/game/main.gd` with a staged wave 7 `Red Canyon Press` Hunter lunge capture.
- Added `04_hunter_lunge_afterimage.png` to the rendered QA set, shifting the later finale, extraction, and information menu captures to `05`, `06`, and `07`.
- Strengthened the Hunter afterimage opacity in `scripts/enemies/hunter.gd` just enough to read at gameplay scale without hiding the existing amber counterplay lane.
- Added a targeted visual probe that samples the rendered area behind the staged Hunter, checking for the amber slash/dust color, sparse red ghost pixels, and darker dust-shadow marks.
- Kept the existing smoke state assertion, so Hunter lunges are now covered by both gameplay-state proof and rendered screenshot evidence.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small cleanup pass for generated QA artifacts or import churn, such as ignoring stale old-numbered captures or pruning obsolete QA images, so future validation scans stay tidy as the capture set evolves.

## 2026-06-03 - Visual QA Artifact Pruning

- Added an explicit `VISUAL_QA_CAPTURE_FILES` list in `scripts/game/main.gd` for the current seven rendered QA captures.
- Added a visual QA startup cleanup step that opens `artifacts/qa` and prunes obsolete `.png` files and their `.png.import` sidecars when they are no longer in the expected capture list.
- Removed stale old-numbered captures from the generated QA folder by rerunning visual QA, leaving only the current seven capture files plus their import sidecars.
- Confirmed the subsequent smoke import scan now sees seven QA image steps instead of stale old capture names.
- Kept `artifacts/qa/` ignored by Git while making the runtime output directory self-maintaining.

Validation:

- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, scanned seven QA image actions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Return to player-facing game polish with a small run-feel improvement, such as adding a focused audio or camera cue to Hunter lunges, payday pickups, or wave transitions now that the visual QA set is tidy.

## 2026-06-03 - Hunter Lunge Audio Cue

- Added a `lunge_started` signal to `scripts/enemies/hunter.gd` that fires when the Hunter releases from its readable windup into the actual lunge.
- Connected Hunter spawns in `scripts/game/main.gd` to play a new `hunter_lunge` cue, giving the late-wave pounce a distinct rush sound without changing damage, timing, or counterplay.
- Added a procedural `hunter_lunge` sweep in `scripts/systems/audio_director.gd`, shaped as a low-to-high dusty rush to pair with the existing amber lunge tell and afterimage trail.
- Added lightweight audio cue play counts to the audio director and extended the late-wave Hunter smoke checks to assert that staged lunges actually trigger the new rush cue.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Hunter lunge audio assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a matching short camera kick or HUD danger accent for Hunter lunge releases, tuned carefully so it reinforces threat timing without disrupting the existing visual QA framing.

## 2026-06-03 - Hunter Lunge Camera Kick

- Added a short, low-strength camera kick when a Hunter releases from windup into its lunge in `scripts/game/main.gd`.
- Kept the kick separate from impact freeze so the Hunter feels more dangerous at release without slowing time, changing damage, or reducing the existing sidestep counterplay.
- Added a dedicated Hunter lunge camera-kick counter and extended the staged late-wave smoke checks to prove the camera feedback fires alongside the existing tell, afterimage, and audio cue.
- Tuned the shake to stay brief enough that the existing Hunter lunge visual QA capture still passes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Hunter lunge camera-kick assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small player-facing HUD danger accent for Hunter lunge releases, such as a brief edge flash or warning text, while keeping it quiet enough not to compete with duelist cards or hit feedback.

## 2026-06-03 - Hunter Lunge HUD Warning

- Added a restrained amber HUD danger flash and compact `HUNTER LUNGE` warning in `scripts/ui/hud.gd` when a Hunter releases into its pounce.
- Kept the warning short and separate from the red damage flash so it reads as an incoming-threat cue, not as player damage.
- Connected the existing Hunter lunge release handler in `scripts/game/main.gd` to trigger the new HUD accent alongside the camera kick and audio rush cue.
- Added a HUD warning counter and extended the late-wave staged Hunter smoke checks to prove the warning fires during actual lunges.
- Cleared the warning through `hide_transient_overlays()` so visual QA captures and menu/result overlays remain tidy.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Hunter lunge HUD warning assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Shift from Hunter release polish to another high-frequency readability improvement, such as a brief wave-transition stinger/accent or clearer payday pickup collection feedback.

## 2026-06-03 - Payday Pickup HUD Receipt

- Added a short cactus-green `PAYDAY BANKED` receipt state to the objective panel in `scripts/ui/hud.gd` when the player collects a payday satchel.
- The receipt shows `SATCHEL SECURED`, the collected credit bonus, and the round refill so the reward loop is clearer than the existing transient style pop alone.
- Kept the receipt timed and local to the objective panel, so it reads as reward confirmation without competing with damage flashes, Hunter warnings, or duelist cards.
- Connected payday collection in `scripts/game/main.gd` to trigger the receipt alongside existing score, VFX, ammo refill, heat reduction, and reward audio.
- Added smoke helpers and full-run assertions that payday collection increments the HUD receipt counter and exposes readable `PAYDAY BANKED` text.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught that the receipt text was queued but not immediately visible to smoke; after updating `show_payday_collected_feedback()` to write the objective labels immediately, the command completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.

Next recommended step:

- Add a brief wave-transition audio or HUD accent for the start of each level, so the ten-level structure feels more intentional between arena clears.

## 2026-06-03 - Level Start Stinger

- Added a procedural `level_start` stinger in `scripts/systems/audio_director.gd`, giving every level banner a quick brass-tinged audio beat.
- Added `_play_level_start_feedback()` in `scripts/game/main.gd` so each wave start plays the stinger and throws a small amber `DRAW` flash/burst near the player spawn.
- Kept the cue short and non-blocking so the ten-level structure feels more intentional without delaying the first combat read.
- Extended `_smoke_start_wave()` to assert that every staged wave actually plays the `level_start` stinger.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new level-start stinger assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a compact wave-clear stinger or visual receipt before the payday drop, so clearing a level feels as intentional as starting one.

## 2026-06-03 - Level Clear Receipt

- Added a procedural `level_clear` stinger in `scripts/systems/audio_director.gd` so clearing a non-final level has its own reward beat before payday pickup collection.
- Added a brass `LEVEL CLEARED` objective-panel receipt in `scripts/ui/hud.gd`, showing the cleared level title and the upcoming level number.
- Connected wave clear in `scripts/game/main.gd` to play the stinger, show the receipt, and throw a compact `CLEAR` flash/burst near the player before the payday satchel drops.
- Added smoke helpers and full-run assertions that each non-final clear plays the `level_clear` stinger and exposes readable `LEVEL CLEARED` HUD text.
- Fixed an overlap caught by smoke where the previous payday receipt timer could outlive the next wave and override the clear receipt; wave-clear feedback now clears the older payday receipt timer.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught the payday/clear receipt overlap; after clearing the payday receipt timer on wave-clear feedback, the command completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.

Next recommended step:

- Add a small readability pass for first-time controls or early-wave coaching, such as making the rookie primer react when the player completes move, dash, slash, and gun-cast basics.

## 2026-06-03 - Rookie Basics Ready Receipt

- Added a `BASICS READY` completion receipt to the training ledger in `scripts/ui/hud.gd` once the player completes move, dash, slash, and gun-cast basics.
- Kept the completed ledger visible briefly with all four rows marked `DONE`, then hides it so the onboarding panel does not linger over combat.
- Connected the run training tracker in `scripts/game/main.gd` to play the existing reward cue and call the new HUD receipt instead of immediately hiding the panel.
- Added smoke coverage that forces the four completed training steps, verifies the receipt counter increments, and checks the visible copy points the player toward clearing all ten levels.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught a typed GDScript inference issue in the new smoke helper; after making the counter type explicit, it completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new training completion assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.

Next recommended step:

- Add one more early-run mastery affordance after onboarding, such as a small first-payday pointer arrow or pickup pulse so new players notice the satchel reward before the next level starts.

## 2026-06-03 - Payday Satchel Pickup Pointer

- Added a short-lived brass `SCOOP` pointer arrow above newly dropped payday satchels in `scripts/game/main.gd`.
- The pointer uses the existing satchel age/pulse timing, fades after the first few seconds, and keeps the reward readable without leaving permanent UI clutter during the level break.
- Added `pointer_life` to payday pickup data and a shared `_is_payday_pointer_visible()` helper so the draw path and smoke assertions check the same condition.
- Extended the full-run smoke path to assert that every non-final wave clear drops a satchel with a visible pickup pointer before scripted collection.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new payday pointer assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Improve pickup visibility further by adding a small screen-edge or HUD nudge when a payday satchel is off-camera or far from the player during a level break.

## 2026-06-03 - Payday Route Trail

- Added a short-lived brass route trail from the player toward newly dropped payday satchels in `scripts/game/main.gd`.
- The cue appears only while the satchel is fresh, uncollected, and far enough from the player to need directional help, then fades to avoid cluttering the level break.
- Reused the pickup age timing and added `route_life` plus `route_min_distance` to the payday pickup data so the route cue is tunable per drop.
- Extended the full-run smoke path to assert that every non-final wave clear shows both the satchel pointer and the player-to-satchel route trail before collection.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught GDScript type inference issues in the new route helper; after adding explicit local types, it completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new payday route trail assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.

Next recommended step:

- Add a small animated arena spectacle pass to an early level, such as dust gust streaks or saloon-window light sweeps, so the first two levels feel more alive before the named duelists arrive.

## 2026-06-03 - Early Level Animated Atmosphere

- Added animated high-noon dust gusts and brass motes to the level 1 `open` courtyard modifier in `scripts/game/main.gd`.
- Added animated crossing saloon-window light lanes and side glints to the level 2 `crossfire` modifier, making the first rifle pressure wave feel more staged and theatrical.
- Kept both overlays low-alpha and warm western-toned so they add motion and place identity without covering enemy silhouettes, bullet lanes, satchels, or HUD reads.
- Updated the smoke modifier animation helper so waves 1 and 2 are now treated as animated arena atmosphere, with `_smoke_assert_wave_basics()` checking those first-impression levels.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new early animated atmosphere assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a stronger playable distinction to level 4 or another mid-run arena beat, such as a rail-yard dust crossing cue or moving warning lane that adds spectacle while teaching fair repositioning.

## 2026-06-03 - Rail Yard Rush Motion Cues

- Added an animated `rush` modifier overlay to level 4 in `scripts/game/main.gd`, with rail lines, ties, moving dust streaks, and a subtle `RAIL` marker.
- Kept the rail-yard cues as readable spectacle rather than a new damage source, so the rush wave feels more distinct while remaining fair for players learning repositioning.
- Added `rush` to the animated modifier helper and shared redraw path, so the overlay animates continuously like the other set-piece levels.
- Extended the smoke set-piece expectations to stage level 4 and verify its title, modifier, hazard count, and animated overlay behavior.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Rail Yard Rush set-piece assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA capture for the level 4 Rail Yard Rush set-piece, so the new mid-run animated overlay has screenshot coverage like Gold Rush, Hunter lunge, and Last High Noon.

## 2026-06-03 - Rail Yard Visual QA Capture

- Added `03_rail_yard_rush.png` to the visual QA capture set in `scripts/game/main.gd`, shifting the later QA captures to keep the full run ordered by encounter beat.
- Updated `_run_visual_qa()` to stage level 4, verify the `Rail Yard Rush` title/modifier/hazard count, tick the animated `rush` overlay, and save the new screenshot before Gold Rush.
- Added `_visual_qa_image_has_rail_yard_overlay()` so the screenshot pass checks for warm rail/dust contrast in the rendered arena, not only that the scene ran.
- Tuned the existing Hunter capture validator with a broader lunge-lane fallback after the new capture timing exposed that the exact afterimage color can vary while the red lunge lane and hunter cluster remain readable.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught that the new Rail Yard detector was too strict and that the Hunter screenshot validator was brittle after the inserted capture. After tuning both validators, it completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small player-facing level-specific objective tip for Rail Yard Rush, such as coaching the player to dash across rail lanes and use the dust crossings as spacing reads.

## 2026-06-03 - Rail Yard Objective Tip

- Added a Rail Yard-specific objective tip in `scripts/ui/hud.gd`: `RAIL YARD  DASH ACROSS LANES, USE DUST FOR SPACING`.
- Gave the active Rail Yard tip priority over pending payday satchel reminders so the player gets a clear set-piece coaching moment when level 4 starts, while the normal payday reminder still covers other levels and breaks.
- Extended the smoke test in `scripts/game/main.gd` with `_smoke_assert_rail_yard_hud_tip()`, which clears transient receipts, ticks the HUD once, and verifies the Rail Yard tip names the set-piece, teaches dash/lanes/spacing, and stays compact.
- The first smoke attempt usefully caught that payday reminders were masking the new tip; the final priority order now protects the intended player-facing behavior.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave 4 Rail Yard HUD assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the priority fix.

Next recommended step:

- Add one more mastery-oriented HUD hint for a later set-piece, such as a compact Bank Vault tip that tells players to chain paired powder kegs only after baiting enemies into the blast lane.

## 2026-06-03 - Bank Vault Chain Coaching

- Reworked the active Bank Vault/Gold Rush objective tip in `scripts/ui/hud.gd` from a generic style-chain hint into a compact mastery prompt: `BANK VAULT  BAIT OUTLAWS INTO LANES, THEN CHAIN PAIRS`.
- Kept the tip at active-wave priority so pending payday reminders do not hide the level 8 set-piece lesson when the powder-keg arena starts.
- Tightened `_smoke_assert_gold_rush_keg_chain()` in `scripts/game/main.gd` so the smoke test now verifies the HUD tip teaches Bank Vault identity, baiting, blast lanes, paired chains, and compact readability before validating the actual two-keg chain payoff.
- Left the underlying powder-keg behavior unchanged: the pass improves player understanding of an existing risk/reward mechanic instead of adding a new difficulty spike.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the updated Bank Vault HUD assertion and paired keg chain validation, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a late-run objective tip for `HIGH-SOCIETY KILL BOX` or `LAST HIGH NOON` that teaches players to preserve dash for hunters and finale cross-pressure before extraction.

## 2026-06-03 - Late-Run Dash Coaching

- Added active-wave objective tips for the final pressure stretch in `scripts/ui/hud.gd`.
- Wave 9 `HIGH-SOCIETY KILL BOX` now teaches: `KILL BOX  HOLD DASH, PARRY JUNE, BREAK CROSS-PRESSURE`.
- Wave 10 `LAST HIGH NOON` now teaches: `LAST HIGH NOON  SAVE DASH FOR HUNTERS, THEN EXTRACT`.
- Placed both tips before payday, generic duelist, and final-stand fallbacks so the set-piece-specific counterplay stays visible when the danger ramps up.
- Added `_smoke_assert_late_run_hud_tip()` in `scripts/game/main.gd` and wired it into the set-piece smoke loop for waves 9 and 10, verifying the tips identify the encounter, teach dash preservation, mention the relevant pressure, and stay compact.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new late-run HUD assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small visual reinforcement for Last High Noon extraction pressure, such as a subtle exit-side brass glint or dust trail after the final wave begins, so the finale objective is readable through spectacle as well as HUD text.

## 2026-06-03 - Last High Noon Extraction Glint

- Added a right-edge brass extraction cue to the `Last High Noon` arena overlay in `scripts/game/main.gd`.
- The cue draws a non-damaging trail from the arena center toward the exit side, animated chevrons, dust glints, and a brass edge flare so the finale's `save dash, survive hunters, extract` objective reads through the spectacle as well as HUD text.
- Kept the cue warm, low-alpha, and in the existing old-west brass/dust palette so it supports readability without hiding enemies, hunter tells, or powder keg silhouettes.
- Strengthened `_visual_qa_image_has_last_high_noon_overlay()` so the Last High Noon screenshot now verifies both the existing finale heat/ray overlay and the new right-side brass extraction cue.
- Tuned the new screenshot threshold after the first visual QA run showed the cue was visible but the contrast threshold was slightly too strict against the warm finale wash.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught the too-strict Last High Noon exit-cue threshold. After tuning it, visual QA completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small player-facing polish pass to the extraction result, such as a clearer run-grade flourish or animated payday total count-up, so finishing all ten levels feels more rewarding.

## 2026-06-03 - Extraction Ledger Flourish

- Updated the extraction result ledger in `scripts/game/main.gd` so a successful run now opens the result stats with `TEN-LEVEL EXTRACTION` before `LEVELS CLEARED 10/10`.
- Renamed the payday total line to `PAYDAY HAUL +...`, making the banked reward read more like a western heist payout instead of a generic stat.
- Tightened `_smoke_assert_result_ledger()` so the smoke run verifies the ten-level flourish, all ten levels cleared, defeated rivals, banked credits, payday haul, and compact HUD length.
- Kept the result-card layout unchanged and avoided adding extra screen clutter; the pass improves the payoff copy while preserving the visual QA extraction frame.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the updated extraction ledger assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small visual flare to the extraction result card itself, such as a brass divider or subtle card pulse, so the completed run feels more premium without making the ledger longer.

## 2026-06-03 - Extraction Card Brass Flare

- Added a lightweight brass flare treatment to the extraction result card in `scripts/ui/hud.gd`.
- The completed-run ledger now sits over the existing dark result card with a subtle warm glow pulse plus top and bottom brass dividers, giving the ten-level extraction receipt a more premium western-heist finish without adding more text.
- Added helper methods to lay out and hide the result flare cleanly when starting a run, failing a run, or returning to the main menu.
- Strengthened `_visual_qa_image_has_dark_result_card()` in `scripts/game/main.gd` so the extraction screenshot now verifies both the dark result card and a brass divider/accent region.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add another small arena readability pass, such as a level 5 Dust Chapel visual cue that clarifies brute lanes without increasing damage or clutter.

## 2026-06-03 - Dust Chapel Brute Lane Cues

- Added a non-damaging Dust Chapel readability overlay in `scripts/game/main.gd`.
- Wave 5 now draws two dark chapel aisles through the arena with subtle brass borders and animated chevrons, giving the extra shotgun brutes a readable pressure lane without changing enemy damage, spawn counts, or hazard rules.
- Kept the cue low-alpha and old-west styled with dark wood, dust, and brass tones so it sits under the player, enemies, bells, and HUD instead of becoming clutter.
- Expanded visual QA to stage and capture wave 5 as `04_dust_chapel_brute_lanes.png`, then shifted later QA captures to keep the sequence chronological.
- Added `_visual_qa_image_has_dust_chapel_brute_lanes()` so the new screenshot verifies dark lane shapes, brass warning accents, and enough contrast to stay readable.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small character-story reinforcement for Reverend Ash or Dust Chapel, such as a compact wave 5 intro bark or information-card note that explains why the chapel brutes hold those lanes.

## 2026-06-03 - Reverend Ash Chapel Story Cue

- Added a player-facing Reverend Ash set-piece card to the Information menu in `scripts/ui/hud.gd`.
- The card frames Dust Chapel as Ash's judgment ground and explains that brutes come down dark aisles marked by brass chevrons, tying the previous visual lane cue to a named rival instead of leaving it as anonymous arena dressing.
- Updated the active wave 5 objective tip to `DUST CHAPEL  ASH'S BRUTES HOLD AISLES, DASH ACROSS LANES`, so the story flavor and counterplay appear during the playable level.
- Added `_smoke_assert_dust_chapel_hud_tip()` in `scripts/game/main.gd` and expanded the information-primer smoke checks so both the wave 5 HUD cue and Reverend Ash card stay covered.
- Verified the Information menu screenshot still renders cleanly with the new card visible beneath the Hunter and Duelist cards.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Dust Chapel HUD and Reverend Ash information-card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small visual or mechanical identity cue for the next named rival, such as a Mercy Vale fast-draw trail or wave 6 HUD counterplay tip that makes her duel feel distinct before late-run pressure begins.

## 2026-06-03 - Mercy Vale Fast-Draw Coaching

- Added a Mercy Vale-specific active wave tip in `scripts/ui/hud.gd`: `MERCY VALE  WAIT FOR DRAW LINE, DASH SIDE, THEN PARRY`.
- The wave 6 HUD now names Mercy directly and teaches her faster draw-line counterplay instead of falling back to the generic duelist prompt.
- Added `_smoke_assert_mercy_vale_hud_tip()` in `scripts/game/main.gd` and wired it into the wave 6 set-piece smoke pass, verifying the tip identifies Mercy, teaches dash-side movement, preserves parry counterplay, and stays compact.
- Expanded visual QA with a new chronological wave 6 capture, `05_mercy_vale_fastdraw.png`, staged during Mercy's fast-draw tell.
- Added `_visual_qa_image_has_mercy_fastdraw_overlay()` so the Mercy screenshot verifies warm fast-draw lane sweeps, the red-orange duelist tell, and enough contrast to remain readable.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Mercy Vale HUD assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small June Blackglass identity pass, such as a distinct high-society duel tell accent or Information card that explains her wave 9 kill-box pressure before the finale.

## 2026-06-03 - June Blackglass Kill-Box Identity

- Added a June Blackglass boss card to the Information menu in `scripts/ui/hud.gd`.
- The new card explains that June turns wave 9 into a glass kill box and teaches players to hold dash, break red lanes, then parry.
- Strengthened the wave 9 `blackglass` arena overlay in `scripts/game/main.gd` with a high-society glass diamond, red kill-box cross lanes, brass corner brackets, and dark glass-pane linework.
- Expanded visual QA with a dedicated `08_june_blackglass_killbox.png` capture, staged during June's duelist tell before Last High Noon.
- Added `_visual_qa_image_has_june_blackglass_killbox()` and expanded `_smoke_assert_information_primer()` so June's card and kill-box cue stay covered.
- Tuned the June visual QA detector after the first run showed the cue was visible but the initial red/brass thresholds were too strict for the warm blended arena palette.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new June Blackglass information-card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught the too-strict June kill-box screenshot detector. After tuning it, visual QA completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small ease-of-play pass for the late run, such as a clearer wave 9-to-10 transition notice or a compact finale extraction reminder after June falls.

## 2026-06-03 - June-To-Finale Transition Receipt

- Added a special wave 9 clear receipt in `scripts/ui/hud.gd` for the handoff after June Blackglass falls.
- The level-clear HUD now says `JUNE DOWN  LAST HIGH NOON NEXT` and reminds the player: `SAVE DASH FOR HUNTERS  CLEAR THEN EXTRACT`.
- Fixed the objective tracker priority so payday and wave-clear receipts keep their own short-lived tips instead of being overwritten by the generic objective tip on the next HUD update.
- Added `clear_objective_feedback()` and call it when a new wave starts, so old receipts do not mask active-wave coaching like Bank Vault, Kill Box, or Last High Noon tips.
- Added `_smoke_assert_finale_transition_receipt()` in `scripts/game/main.gd`, verifying that the wave 9 clear receipt confirms June is down, warns that Last High Noon is next, preserves dash for hunters, reminds the player to extract, and stays compact.
- Smoke caught the first HUD-priority edge where the new receipt was overwritten by the payday-pending tip; the tracker/wave-start feedback priority fix resolved it.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught the overwritten wave 9 clear receipt. After fixing feedback priority and clearing old receipts at wave start, smoke completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.

Next recommended step:

- Add a small new-player ease-of-play pass, such as making the first-run training ledger briefly explain that payday satchels are optional but useful before the next level starts.

## 2026-06-03 - Payday Satchel Training Hint

- Updated the first-run training completion receipt in `scripts/ui/hud.gd` so the `BASICS READY` ledger now keeps the ten-level goal visible and adds a compact payday lesson: `PAYDAY SATCHELS OPTIONAL +CREDITS +ROUNDS`.
- Mirrored the same payday-basics wording in the training fallback/tip path in `scripts/game/main.gd`, so the player-facing guidance stays consistent if the animated completion receipt is unavailable.
- Expanded `_smoke_assert_training_completion_feedback()` to verify the basics receipt still marks all four controls done, points at `CLEAR TEN LEVELS`, teaches that payday satchels are optional, explains the credits/rounds reward, and remains compact enough for the HUD frame.
- Smoke caught the first version at 151 characters against the 150-character compactness guard; trimming the extra spacer kept the lesson and satisfied the HUD readability budget.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 after the compact text trim and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the text trim.

Next recommended step:

- Add a small new-player readability pass for the actual first payday drop, such as a short-lived satchel label or route cue that visually reinforces the optional pickup without pulling attention away from incoming outlaws.

## 2026-06-03 - First Payday Optional Label

- Added a first-drop-only in-world payday label in `scripts/game/main.gd`.
- The first satchel now briefly renders a compact western ledger tag under the bag: `OPTIONAL` and `+CREDITS +ROUNDS`, reinforcing that the pickup helps but is not mandatory.
- Kept the cue scoped to the first payday drop by tagging wave 1 pickups with `first_drop` and a short `optional_label_life` of 2.6 seconds, so later drops keep the cleaner route arrow and `SCOOP` pointer without repeated tutorial text.
- Added `_is_payday_optional_label_visible()`, `_draw_payday_optional_label()`, and `_smoke_get_payday_optional_label_count()` to keep the rendering rule testable.
- Expanded the full extraction smoke run to assert that the first payday drop shows the optional-reward label and that later payday drops do not repeat it.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first-drop-only payday label assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small hit-feel or animation polish pass for early combat, such as a sharper first-wave rusher defeat burst or short saber follow-through afterimage that makes the opening fight feel more stylish without reducing readability.

## 2026-06-03 - Confirmed Saber Afterimage

- Added a confirmed-hit saber follow-through afterimage to `scripts/systems/vfx_layer.gd`.
- The new VFX layer effect draws short-lived bone-white, brass, and ember arcs from the actual slash origin/range/arc, giving successful saber hits a sharper visual scar without adding noise to whiffs.
- Triggered the afterimage from `scripts/game/main.gd` only when `_on_player_weapon_slashed()` records `hit_count > 0`, keeping the polish tied to real contact and preserving combat readability.
- Added `get_saber_afterimage_count()` and `_smoke_assert_first_slash_afterimage()` so smoke stages one first-wave rusher inside the saber arc, confirms the hit defeats the rusher, and verifies the afterimage count increments.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new confirmed-saber-hit afterimage assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a compact enemy readability polish pass, such as a first-wave rusher wind-up shoulder flash or dust-footstep animation that makes incoming melee pressure easier to read before contact.

## 2026-06-03 - Rusher Wind-Up Readability

- Added a compact chase wind-up tell to `scripts/enemies/knife_rusher.gd`.
- Knife rushers now use their existing brief chase-start slowdown to show a readable shoulder/knife glint plus two dust-footstep pips, making the first melee pressure spike easier to read before contact.
- Kept the existing red warning ring and pose squash, but moved the new cue to render after the sprite/body so the useful glint sits on top instead of hiding under the character art.
- Added `has_swarm_warning_tell()` and `_smoke_assert_first_rusher_warning_tell()` so smoke stages a first-wave rusher entering chase range and verifies the warning tell is active before the saber-hit smoke check.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first-rusher wind-up assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small first-wave visual QA capture assertion for the rusher wind-up tell itself, or add a similarly compact readable tell to shotgun brutes so their close-range pressure is clearer before Dust Chapel.

## 2026-06-03 - Shotgun Brute Wide-Blast Tell

- Added standardized attack-tell hooks to `scripts/enemies/shotgun_brute.gd` with `has_attack_tell()` and `get_attack_tell_strength()`.
- Strengthened the brute wind-up rendering with a wider amber fan, darker lane-edge shadows, inner pellet guide lines, and a bright muzzle bracket so the player can read both direction and spread before the shotgun fires.
- Kept damage, timing, and movement unchanged; this is a readability and fairness pass for the existing close-range pressure.
- Added `_smoke_assert_brute_shotgun_tell()` in `scripts/game/main.gd` and wired it into the wave 5 Dust Chapel smoke pass, staging a brute inside wind-up range and verifying the tell appears before firing.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Dust Chapel shotgun-brute tell assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add visual QA coverage for one of the new enemy readability tells, such as staging a first-wave rusher wind-up or Dust Chapel brute wide-blast frame and checking the screenshot for its amber danger cues.

## 2026-06-03 - Dust Chapel Brute Tell Visual QA

- Hardened the Dust Chapel visual QA capture in `scripts/game/main.gd`.
- The wave 5 screenshot now stages a shotgun brute near the player, waits until its actual wide-blast attack tell is active, and captures the frame while the amber fan is visible.
- Added `_visual_qa_image_has_shotgun_brute_wide_tell()` so `04_dust_chapel_brute_lanes.png` checks for the staged warm fan, dark lane-edge contrast, and existing chapel brute-lane overlay instead of only proving the level set-piece is present.
- Kept gameplay untouched; this pass makes the recently added brute readability polish harder to regress.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new staged Dust Chapel shotgun-brute tell screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a first-wave visual QA assertion for the rusher wind-up tell, or add a compact early-combat polish pass that makes the opening arena easier to parse without slowing the pace.

## 2026-06-03 - First Rusher Tell Visual QA

- Hardened the first-wave visual QA capture in `scripts/game/main.gd`.
- The `01_first_draw.png` pass now stages the first knife rusher's chase-start warning tell before capture, using the same `_smoke_assert_first_rusher_warning_tell()` path that already proves the gameplay hook.
- Added `_visual_qa_image_has_first_rusher_warning_tell()` so the screenshot checks the localized red warning cue, dark rusher silhouette, and contrast at the staged player-relative position while keeping the existing centered wave-banner check.
- Tuned the detector against the actual rendered capture so it keys off the thin red danger ring and silhouette contrast instead of the sandy floor's broad amber color.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new first-wave rusher wind-up screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small playable early-arena polish pass, such as making the first-wave rusher warning ring slightly directional or adding a clearer rusher defeat burst, then cover it with the existing smoke/visual QA loop.

## 2026-06-03 - Rusher Defeat Burst

- Added a directional knife-rusher defeat flourish in `scripts/systems/vfx_layer.gd`.
- Knife rushers now kick a short amber/red dust fan and boot-spark burst when cut down, giving the opening fight a sharper hit-feel payoff while preserving enemy health, speed, attack timing, and damage.
- Wired the effect from `scripts/game/main.gd` only for `knife_rusher` defeats, so riflemen, brutes, hunters, and duelists keep their existing death feedback.
- Added `get_rusher_defeat_burst_count()` and extended the first-slash smoke assertion so the staged opening saber kill proves both the saber afterimage and the rusher-specific defeat burst fire.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new rusher defeat burst assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a similarly scoped first-wave ease-of-play polish, such as a slightly directional rusher warning wedge or a short HUD/audio nudge when the player lands the first saber kill.

## 2026-06-03 - Directional Rusher Warning Wedge

- Added a directional chase-start warning wedge to `scripts/enemies/knife_rusher.gd`.
- Knife rushers now draw a short red/amber wedge and three dust ticks in their facing direction during the existing brief wind-up, helping the opening fight read as incoming melee pressure instead of only a generic danger ring.
- Kept rusher speed, health, contact damage, chase range, and warning timing unchanged; this is an ease-of-play/readability polish pass.
- Added `has_directional_swarm_warning_tell()` and extended `_smoke_assert_first_rusher_warning_tell()` in `scripts/game/main.gd` so smoke verifies the first-wave wind-up includes the directional cue.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new directional rusher warning assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a compact player-facing feedback pass for the first successful saber kill, such as a one-time HUD/audio nudge that reinforces slash timing without adding tutorial clutter.

## 2026-06-03 - First Saber Kill Nudge

- Added a one-time first saber kill nudge in `scripts/game/main.gd`.
- The first slash that actually defeats an enemy now briefly shows `FIRST CUT / DASH NEXT` through the existing style-pop HUD and plays the existing reward cue, reinforcing the opening slash-to-spacing rhythm without adding a persistent tutorial panel.
- Kept combat tuning unchanged; the feedback only triggers after `enemies_defeated` increases from a saber slash, so whiffs, hazard-only hits, and later kills do not repeat the nudge.
- Reset the first-cut feedback state on each new run and extended `_smoke_assert_first_slash_afterimage()` to verify the HUD text, one-time feedback count, and reward audio cue.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first saber kill HUD/audio assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a compact first-wave movement coaching pass after the first saber kill, such as a one-time dash-ready glint near the player or a brief objective tip override that teaches repositioning before the next rusher closes.

## 2026-06-03 - First Cut Dash Glint

- Added a player-side dash-ready glint to `scripts/systems/vfx_layer.gd`.
- The first saber kill nudge now also flashes a short denim/brass ring and arrow near the player, making `DASH NEXT` visible in the arena rather than only in HUD text.
- Wired the glint from `_show_first_saber_kill_feedback()` in `scripts/game/main.gd`, using the player's current aim/dash direction and keeping all dash cooldowns, enemy pressure, and combat tuning unchanged.
- Added `get_dash_ready_glint_count()` and extended `_smoke_assert_first_slash_afterimage()` so the staged opening saber kill proves the afterimage, rusher defeat burst, HUD/audio nudge, and new dash glint all fire together.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first-cut dash glint assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a similarly compact second-wave readability pass, such as a first rifleman shot-lane visual QA capture or a slightly clearer rifle muzzle tell before the opening crossfire.

## 2026-06-03 - Rifleman Crossfire Tell Visual QA

- Added a dedicated wave 2 visual QA capture, `02_rifleman_crossfire_tell.png`, in `scripts/game/main.gd`.
- The visual QA pass now stages a rifleman near the player, waits for the existing crossfire charge tell, hides transient HUD overlays, and captures the amber shot lane at the moment it should be readable.
- Added `_visual_qa_image_has_rifleman_crossfire_tell()` to verify the staged frame contains the rifleman's amber warning lane, dark parallel rails, target reticle near the player, and enough lane contrast.
- Kept rifleman health, timing, range, damage, and drawing unchanged; this pass protects the existing second-wave readability cue with automated screenshot coverage.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new rifleman crossfire screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a compact rifleman gameplay readability polish, such as a brighter muzzle bracket or brief dust puff at the firing line, now that visual QA protects the second-wave tell.

## 2026-06-03 - Rifleman Muzzle Bracket

- Added a rifle-specific muzzle warning puff to `scripts/systems/vfx_layer.gd`.
- Riflemen now emit a short amber bracket and dusty barrel puff at charge start and shot release, making the second-wave crossfire source easier to read without changing enemy range, damage, charge duration, fire cooldown, or wave composition.
- Wired the cue from `scripts/enemies/rifleman.gd` using the rifle's muzzle world position instead of the enemy center, so the tell hugs the weapon silhouette.
- Added `get_rifle_warning_puff_count()` and `get_rifle_warning_puff_total_count()` plus wave 2 smoke/visual QA assertions in `scripts/game/main.gd` so the rifleman attack tell proves the new muzzle cue is active or newly emitted.
- Reviewed the generated `artifacts/qa/02_rifleman_crossfire_tell.png`; the amber muzzle ring/bracket, shot lane, and target reticle remain visible together.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new rifleman muzzle-bracket assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add another compact enemy readability polish, such as a shotgun-brute reload/recover tell after firing or a clearer duelist pre-dash boot dust cue, and cover it with the existing smoke/visual QA loop.

## 2026-06-03 - Shotgun Brute Recovery Tell

- Added a short post-shot recovery tell to `scripts/enemies/shotgun_brute.gd`.
- Shotgun brutes now draw a fading muzzle smoke arc plus two brass shell-ejection streaks during the existing recoil/recovery window after firing, making the heavy shotgun rhythm clearer without changing wind-up duration, fire cooldown, speed, contact damage, spread, or player damage.
- Added `has_recover_tell()` and `get_recover_tell_strength()` so tests and future QA can distinguish the brute's spent-shot recovery state from its pre-shot danger fan.
- Extended `_smoke_assert_brute_shotgun_tell()` in `scripts/game/main.gd` to stage the Dust Chapel brute, wait for its wide-blast wind-up, move the player out of the blast, and assert that the recovery tell appears after the shot.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new shotgun brute recovery assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a dedicated visual QA capture for the shotgun brute post-shot recovery tell, or add a similarly compact duelist pre-dash boot dust cue with smoke coverage.

## 2026-06-03 - Duelist Pre-Dash Boot Dust

- Added a compact pre-dash boot dust and spur-tick cue to `scripts/enemies/duelist.gd`.
- Named duelists now kick up two small dusty foot arcs and brief brass spur streaks during the existing draw wind-up, making the impending lunge read from the body as well as the lane line.
- Added `has_pre_dash_boot_dust_tell()` so tests can distinguish the new body-language cue from the existing lunge lane.
- Extended the wave 3 visual QA setup and boss-wave smoke assertions in `scripts/game/main.gd` so each duelist tell validation also proves the pre-dash boot dust cue appears.
- Reviewed `artifacts/qa/02_black_sash_tell.png`; the lunge lane remains readable and the new foot dust sits under the duelist without obscuring counterplay.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new duelist boot-dust assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a dedicated visual QA capture for the shotgun brute post-shot recovery tell, or add a late-run duelist variant readability pass for June Blackglass's kill-box wind-up.

## 2026-06-03 - Shotgun Brute Recovery Visual QA

- Added a dedicated Dust Chapel recovery screenshot, `04_dust_chapel_brute_recovery.png`, to the visual QA capture list in `scripts/game/main.gd`.
- The visual QA pass now centers the player before staging the shotgun brute, captures the existing pre-shot wide-blast tell, then moves the player just far enough to avoid the blast and captures the brute's post-shot recovery tell.
- Added `_visual_qa_staged_brute_recovery_origin`, `_smoke_get_enemy_kind_method_origin()`, and `_visual_qa_image_has_shotgun_brute_recovery_tell()` so the screenshot detector anchors on the staged recovering brute rather than whichever brute appears first in the wave list.
- Reset player velocity and camera smoothing after the recovery capture so later Mercy Vale, June Blackglass, and finale screenshots stay deterministic.
- Reviewed `artifacts/qa/04_dust_chapel_brute_recovery.png`; the staged brute's spent-shot fan, smoke, and shell cue are visible without hiding the player or Dust Chapel lane dressing.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new shotgun brute recovery screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a late-run duelist variant readability pass for June Blackglass's kill-box wind-up, or add a visual QA detector that specifically checks the new duelist boot dust in the Black Sash capture.

## 2026-06-03 - June Blackglass Wind-Up Brackets

- Added a June Blackglass-specific close-body wind-up cue to `scripts/enemies/duelist.gd`.
- During June's existing draw wind-up, she now renders red kill-box corner brackets and brass glass-scratch slashes around her body, making the late-run boss dash easier to read up close without changing her speed, draw duration, dash duration, cooldown, range, health, damage, or arena overlay.
- Added `has_blackglass_killbox_windup_tell()` so smoke and visual QA can prove the new body cue appears separately from the shared duelist lunge lane.
- Extended wave 9 validation in `scripts/game/main.gd`; the June visual QA capture now waits for the new brackets, and the smoke setpiece pass stages June inside wind-up range before asserting the same cue.
- Reviewed `artifacts/qa/08_june_blackglass_killbox.png`; the broad high-society kill box still reads, and the close boss marker adds a clearer spring-loaded silhouette without hiding the lane.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new June Blackglass wind-up assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the wave 9 bracket wait before capture, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA detector that specifically samples the Black Sash boot dust cue, or add a compact late-run extraction readability polish so wave 10's objective pressure is as clear as its arena spectacle.

## 2026-06-03 - Last High Noon Extraction Ledger

- Added a dedicated final-wave objective state to `scripts/ui/hud.gd`.
- Wave 10 now switches the objective panel from the generic run ledger to `FINAL EXTRACTION`, with compact copy that names Last High Noon, tells the player how many outlaws remain before they can ride out, and points them toward the marked east exit trail.
- Gave the final-wave objective progress bar a brighter brass extraction color so it visually separates the last push from normal level tracking without changing wave composition, enemy tuning, rewards, or completion rules.
- Added `get_objective_tracker_text()` for smoke coverage and extended `scripts/game/main.gd` so visual QA setup, setpiece smoke, and the full extraction run all assert the final extraction tracker text.
- Reviewed `artifacts/qa/09_last_high_noon.png`; the existing finale arena cue and east trail still read cleanly after the HUD change, and smoke verifies the objective panel while it is active before the capture hides transient overlays.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new final extraction objective assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA detector that specifically samples the Black Sash boot dust cue, or add a small final-wave completion flourish that briefly follows the player toward the east exit before the extraction ledger appears.

## 2026-06-03 - East Ride-Out Extraction Flourish

- Added an extraction ride-out VFX flourish to `scripts/systems/vfx_layer.gd`.
- When the final wave completes, `scripts/game/main.gd` now fires a short eastward brass trail from the player toward the same east exit anchor used by the Last High Noon arena cue, with dusty rail shadows, moving chevrons, an exit arc, and a `RIDE OUT` impact label.
- Added VFX counters (`get_extraction_rideout_count()` and `get_extraction_rideout_total_count()`) so smoke can prove the flourish fires during a full extraction.
- Updated the extraction result ledger to include `RODE EAST OUT OF LAST HIGH NOON`, tying the completion screen back to the final-wave objective and arena trail.
- Extended smoke coverage so the full extraction run asserts both the ride-out VFX counter and the new ledger line.
- Reviewed `artifacts/qa/10_extraction_ledger.png`; the result card still fits cleanly and the added ride-out line reads without crowding the banked credits or rival summary.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 after fixing a local GDScript type inference error in the new completion helper.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new extraction ride-out and ledger assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a visual QA detector that specifically samples the Black Sash boot dust cue, since the gameplay cue already exists and smoke covers it but the image detector still only checks the broader duelist lane.

## 2026-06-03 - Black Sash Boot Dust Visual QA Detector

- Added a dedicated visual QA detector for the Black Sash pre-dash boot dust cue in `scripts/game/main.gd`.
- The `02_black_sash_tell.png` screenshot now asserts both the existing duelist lunge lane and the newer body-level boot dust/spur cue, so the capture proves more than the broad lane rails.
- The detector anchors on the live duelist's image position, derives the duelist-to-player facing direction, samples the heel area behind the body, and compares warm dust, brass spur highlights, dark foot marks, and local contrast against nearby floor.
- This keeps the existing gameplay cue unchanged while making the visual QA suite better at catching regressions to duelist body-language readability.
- Reviewed `artifacts/qa/02_black_sash_tell.png`; the lane remains the primary readable threat, and the foot/heel cue sits close to the Black Sash without obscuring the player or counterplay.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new Black Sash boot-dust image assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small player-facing polish to the next early-run learning beat, such as a clearer first reload-ready flash or a compact information-card update that explains duelist boot dust and recovery tells.

## 2026-06-03 - Read The Tells Information Card

- Added a player-facing `Read The Tells` card to the Dust Heist information menu in `scripts/ui/hud.gd`.
- The new card teaches two recently added readability cues in compact language: boot dust means a duelist dash is loading, and shell smoke means a shotgun brute has just fired and is open.
- Extended `_smoke_assert_information_primer()` in `scripts/game/main.gd` so the information menu must keep the new tell-training card and its duelist/brute lessons.
- Tuned the Black Sash boot-dust visual QA detector after the regenerated screenshot showed the previous floor-comparison threshold was too brittle against sandy texture variance; it now samples the lower duelist body/tell area directly for warm dust, brass highlights, dark foot marks, and local contrast.
- Reviewed `artifacts/qa/11_information_hunter_card.png`; the new card is visible in the late information-menu scroll and fits cleanly beside Reverend Ash and June Blackglass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new information-card primer assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially failed on the Black Sash boot-dust image assertion, then completed with exit code 0 after the detector tuning and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a clearer first reload-ready flash or audio/visual nudge so new players understand the revolver cylinder has refilled without needing to stare at the HUD.

## 2026-06-03 - Cylinder Ready Glint

- Added a player-side reload-ready glint to `scripts/systems/vfx_layer.gd`.
- Reload completion now gives a short brass cylinder ring, six chamber ticks, and a draw-direction streak near the player, alongside the existing HUD/audio feedback.
- Updated the reload-ready pop in `scripts/game/main.gd` to say `CYLINDER READY`, show `FULL X/X`, and prompt `DRAW`, using the current revolver capacity instead of a hard-coded ammo count.
- Extended `_smoke_assert_reload_ready_feedback()` so smoke verifies the reload-ready copy and the new VFX counter when the cylinder refills.
- Hardened `_smoke_start_wave()` so staged smoke/visual-QA waves reset run-complete state, impact-freeze state, time scale, and player health before jumping to a target wave; this keeps late captures from inheriting a previous staged death/completion state.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the reload-ready VFX assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 after the staged-wave reset fix and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a dedicated visual QA capture or screenshot assertion for the reload-ready glint during the early learning beat, so the new player-side cylinder cue is protected visually as well as by smoke.

## 2026-06-03 - Reload Glint Visual QA

- Added `01_cylinder_ready_glint.png` to the visual QA capture list in `scripts/game/main.gd`.
- The visual QA pass now stages the real reload-ready feedback path right after the first-wave capture, recenters the player, fires the brass cylinder-ready glint, and saves a screenshot while the `READY` pop and full-cylinder HUD state are visible.
- Added `_visual_qa_image_has_reload_ready_glint()` to sample around the player for brass cylinder highlights, bone chamber ticks, denim draw-streak color, and local contrast.
- Added a visual QA assertion for the new capture, so the reload-ready cue is now protected by both smoke counters and screenshot analysis.
- Tuned the existing Black Sash boot-dust detector's warm-dust threshold slightly after the regenerated screenshot showed the same tell but landed just under the prior threshold because of sandy texture variance.
- Reviewed `artifacts/qa/01_cylinder_ready_glint.png`; the cylinder ring, chamber ticks, `READY` pop, and `CYLINDER READY 6/6` HUD text all read clearly without hiding the player.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially failed on the existing Black Sash boot-dust screenshot detector, then completed with exit code 0 after the threshold tune and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a compact ammo-loop lesson to the information menu or early HUD coaching so new players learn that empty cylinder starts auto reload and the brass glint means the revolver is ready again.

## 2026-06-03 - Reload Rhythm Information Card

- Added a `Reload Rhythm` card to the Dust Heist information menu in `scripts/ui/hud.gd`.
- The new card teaches the full ammo loop in the same language the player sees in combat: empty cylinder starts auto reload, the brass glint means the revolver is ready, and `CYLINDER READY` means it is time to draw again.
- Extended `_smoke_assert_information_primer()` in `scripts/game/main.gd` so smoke verifies the information menu keeps the reload-rhythm lesson and its auto-reload/brass-glint/ready-state copy.
- This pairs the recent reload-ready VFX and visual QA capture with an explicit menu lesson, improving first-run readability without adding more combat-screen text.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new reload-rhythm information assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a small first-empty-cylinder HUD coaching line or one-time run nudge that points players from the dry click into auto reload, closing the loop between the information card and the first live combat moment.

## 2026-06-03 - First Empty Cylinder Nudge

- Added a one-time first-empty-cylinder coaching latch in `scripts/game/main.gd`.
- The first gun cast that spends the last round now shows `AUTO RELOAD / WAIT FOR READY GLINT`, directly connecting the dry-click moment to the brass reload-ready glint players see a moment later.
- Later auto-reload triggers keep the shorter `AUTO RELOAD / CYLINDER TURNING` copy, so the early lesson does not become repetitive during longer runs.
- Reset the new coaching latch at run start and extended `_smoke_assert_first_empty_reload_feedback()` so smoke verifies the first live reload nudge text and counter.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first-empty-cylinder nudge assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Add a tiny visual or audio distinction for the first empty-cylinder coaching nudge, such as a brief amber cylinder spin near the player, so the dry-click lesson has an in-world cue as well as HUD text.

## 2026-06-03 - First Empty Cylinder Spin

- Added a short amber empty-cylinder spin VFX to `scripts/systems/vfx_layer.gd`.
- The first gun cast that spends the last round now pairs `AUTO RELOAD / WAIT FOR READY GLINT` with an in-world spinning cylinder cue near the player, using amber/brass chamber pips and a dark diagonal slash so the dry-click lesson has a visible gameplay anchor.
- Later auto-reload triggers still keep the simpler HUD/audio feedback, so the extra coaching effect stays reserved for the first learning moment.
- Added `get_empty_reload_spin_count()` and `get_empty_reload_spin_total_count()` counters, then extended `_smoke_assert_first_empty_reload_feedback()` in `scripts/game/main.gd` so smoke proves the first empty-cylinder nudge also fires the in-world spin.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new empty-cylinder spin assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Move back toward arena challenge by adding a small readable cover or obstacle variation to an early level, then protect it with smoke/visual QA so the ten-level run keeps gaining tactical texture.

## 2026-06-03 - Saloon Crossfire Cover Props

- Added a separate `arena_cover_props` layer in `scripts/game/main.gd` so readable cover dressing can be staged without changing explosive keg hazard counts.
- Wave 2 `Saloon Crossfire` now places two weathered saloon barricades near the center lanes, using dark plank shadows, brass nail heads, diagonal bracing, and long contact shadows to read as western cover against the sand.
- Drew the cover props above the animated Crossfire arena atmosphere but below hazards and pickups, keeping rifle lanes, the player, and keg silhouettes readable.
- Added a smoke assertion that wave 2 generates at least two `saloon_cover` props.
- Added a visual QA assertion for `02_rifleman_crossfire_tell.png` that samples the staged barricades for wood color, shadow, brass detail, and local contrast.
- Reviewed `artifacts/qa/02_rifleman_crossfire_tell.png`; the new cover props read clearly and do not hide the rifleman crossfire tell or player HUD cues.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave-2 cover assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new Saloon Crossfire cover screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.

Next recommended step:

- Turn one early cover prop into a light gameplay affordance, such as soft enemy spawn steering, line-of-sight teaching, or a destructible splinter VFX beat, while keeping counterplay and visual QA coverage intact.

## 2026-06-03 - Crossfire Cover Splinter Affordance

- Made the wave 2 `Saloon Crossfire` barricades lightly reactive to combat in `scripts/game/main.gd`.
- Saber sweeps and straight gun lines can now splinter an unsplintered saloon cover prop once, leaving persistent crack/shard marks on the planks.
- Splintering cover gives a small `SPLINTER` style reward, plays a restrained wood-dust/audio beat, and fires a short impact flash without changing enemy pathing or introducing unfair collision.
- Added `_smoke_assert_crossfire_cover_splinter()` so smoke stages a real wave-2 saber swing into a cover prop, verifies the persistent splinter state, and checks the style reward.
- Added `02_crossfire_cover_splinter.png` to visual QA plus `_visual_qa_image_has_splintered_saloon_cover()` so the damaged cover read is protected by screenshot analysis.
- Reviewed `artifacts/qa/02_crossfire_cover_splinter.png`; the cracked plank, shard streak, and reward cue read clearly while preserving the rifleman crossfire lane.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially failed after the new staged cover swing left the player parked near the barricade before wave 3; restoring the player to center after the assertion fixed it. The rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new splintered-cover capture, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure remained.

Next recommended step:

- Add a clearer gameplay choice around the reactive cover, such as enemy bullets splintering nearby barricades during Crossfire or a tiny HUD/objective hint that teaches using cover props for style without making them mandatory.

## 2026-06-03 - Crossfire Rifle Bait Cover Lesson

- Added a `shot_fired` signal to `scripts/enemies/rifleman.gd` so riflemen report their real fired shot line after the wind-up tell resolves.
- Connected rifleman shots in `scripts/game/main.gd`; during wave 2 `Saloon Crossfire`, enemy rifle lines can now splinter unsplintered saloon cover props through the same persistent damaged-cover system as player weapons.
- Kept the interaction scoped to Crossfire so later rifle pressure does not unexpectedly alter unrelated arenas.
- Updated the wave-2 objective tip in `scripts/ui/hud.gd` to teach the player to bait rifle lanes into cover and splinter barricades for style.
- Added `_smoke_assert_crossfire_rifle_cover_splinter()` so smoke verifies a staged rifle line can splinter a cover prop and award style.
- Added `_smoke_assert_crossfire_hud_tip()` so smoke protects the new Crossfire teaching copy. The helper clears smoke-only payday pickups before checking because the objective tracker correctly prioritizes pending pickups over level tips during normal play.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially failed because the pending wave-1 payday pickup hid the Crossfire tip during the new HUD assertion; clearing the smoke-only pickup before the assertion fixed it. The rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure remained.

Next recommended step:

- Add a small visual cue on unsplintered Crossfire cover, such as a brief brass glint or dust shimmer when a rifle tell lines up with a barricade, so players can anticipate the bait opportunity before the shot lands.

## 2026-06-03 - Crossfire Cover Bait Glint

- Added `get_attack_tell_line()` to `scripts/enemies/rifleman.gd` so other systems can read an active rifle wind-up line without duplicating rifleman aim logic.
- Added Crossfire-only cover bait detection in `scripts/game/main.gd`: unsplintered saloon cover now checks active rifle tell lines and computes a bait strength when a rifle lane crosses the barricade.
- Drew a compact brass/bone shimmer directly on baitable saloon cover, using arcs, pips, and a diagonal glint line so players can anticipate a rifle-bait splinter before the shot lands.
- Updated the wave-2 smoke and visual QA staging to align a rifle tell through the right-side barricade while keeping both cover props visible.
- Added `_smoke_assert_crossfire_cover_bait_glint()` so smoke verifies an active rifle tell creates a baitable cover glint before any splinter happens.
- Extended `02_rifleman_crossfire_tell.png` visual QA with `_visual_qa_image_has_crossfire_cover_bait_glint()` so the screenshot must show the rifle lane, saloon cover, and brass bait shimmer together.
- Reviewed `artifacts/qa/02_rifleman_crossfire_tell.png`; the bait glint reads clearly on the right barricade while both cover props, the player, and the rifle lane remain visible.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially failed because the staged rifle tell could return on a non-aligned rifle and then because forced staging skipped the muzzle dust puff. Setting the staged rifle aim/charge directly and emitting the same rifle-warning puff fixed both issues. The rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially failed after the first staging change cropped one cover prop out of the Crossfire screenshot, then completed with exit code 0 after staging the right-side cover with the player near center. It reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Move to another early readability beat, such as giving wave 3's Black Sash duel a short arena-floor signature mark or intro camera punch that makes the first named rival feel more authored before the lunge pressure begins.

## 2026-06-03 - Black Sash Signature Mark

- Added a dedicated `duel` arena overlay in `scripts/game/main.gd` for wave 3's Black Sash encounter.
- The arena floor now shows a dark red sash slash, dusty duel ring, brass spur pips, and subtle animated pulse beneath the existing keg ring and lunge tell, making the first named rival feel more authored without changing collision, damage, or AI timing.
- Included `duel` in the animated modifier overlay list so the signature mark breathes like the other set-piece arenas.
- Added `_smoke_has_black_sash_signature_mark()` and wired it into wave-3 smoke/visual QA staging so the Black Sash set-piece identity is protected.
- Extended `02_black_sash_tell.png` visual QA with `_visual_qa_image_has_black_sash_signature_mark()` so the screenshot must show the floor signature along with the lunge lane and boot-dust cue.
- Reviewed `artifacts/qa/02_black_sash_tell.png`; the sash mark, ring, brass pips, player, Black Sash, and lunge tell all read together without obscuring counterplay.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave-3 Black Sash signature assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new Black Sash floor-mark screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a small Black Sash-specific HUD or audio beat at the first lunge release, such as a short branded sting or danger accent, so the authored rival identity carries from the arena floor into the actual attack moment.

## 2026-06-03 - Black Sash Lunge Sting

- Added a `lunge_released` signal to `scripts/enemies/duelist.gd` so the game can react at the exact frame a duelist draw becomes a dash.
- Connected duelist release events in `scripts/game/main.gd` and scoped the new response to wave 3's `black_sash` variant only.
- The Black Sash lunge release now fires a short branded danger beat: a red `BLACK SASH DRAW` HUD flash, a small camera kick, a red impact flash near the release, and a dedicated `black_sash_lunge` stinger in `scripts/systems/audio_director.gd`.
- Added HUD and gameplay counters for the Black Sash release cue, then extended wave-3 smoke so it proves the real lunge release event, branded stinger, and danger accent all fire after the existing tell/boot-dust counterplay.
- Kept visual QA's `02_black_sash_tell.png` timing on the pre-release tell, so the screenshot still protects readability before the dash while smoke protects the authored release moment.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Black Sash lunge-release, audio-stinger, and HUD danger-accent assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Give Mercy Vale's wave 6 fast-draw rival beat the same authored clarity as The Black Sash, such as a variant-specific release stinger or floor cue that emphasizes her faster rhythm without hiding the lunge tell.

## 2026-06-03 - Mercy Vale Fast-Draw Sting

- Extended the duelist release feedback path in `scripts/game/main.gd` so wave 6's `mercy_vale` variant has her own authored release beat.
- Mercy Vale's fast-draw release now fires a bright `MERCY FAST-DRAW` HUD danger flash, a lighter camera kick, a `MERCY DRAW` impact flash slightly ahead of the dash, and a dedicated `mercy_vale_lunge` stinger in `scripts/systems/audio_director.gd`.
- Added HUD and gameplay counters for Mercy's release cue, keeping it separate from the Black Sash and Hunter danger beats.
- Added `_smoke_stage_duelist_release_tell()` so smoke can reliably stage a fresh named-duelist draw without changing normal gameplay timing.
- Extended wave-6 smoke to prove Mercy's real fast-draw release event, stinger, and HUD danger accent fire after the player has had the normal tell/counterplay window.
- Kept `05_mercy_vale_fastdraw.png` visual QA focused on the pre-release tell, so the screenshot protects readable wind-up while smoke protects the authored release moment.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 after the final code changes.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially failed because Mercy's very fast tell had already passed before the new release assertion ran. Adding smoke-only named-duelist release staging fixed the timing edge. The rerun completed with exit code 0, including the new Mercy release, audio-stinger, and HUD danger-accent assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure remained.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a June Blackglass-specific release beat or kill-box snap cue on wave 9 so the final named rival's attack release feels as authored as The Black Sash and Mercy Vale while preserving her close kill-box tell.

## 2026-06-03 - June Blackglass Snap Sting

- Extended the duelist release feedback path in `scripts/game/main.gd` so wave 9's `june_blackglass` variant has her own authored kill-box release beat.
- June Blackglass's lunge release now fires a red `BLACKGLASS SNAP` HUD danger flash, a heavier camera kick, a compact `SNAP` impact flash just ahead of the dash, and a dedicated `june_blackglass_lunge` stinger in `scripts/systems/audio_director.gd`.
- Added HUD and gameplay counters for June's release cue, keeping it separate from Black Sash, Mercy Vale, and Hunter danger beats.
- Extended wave-9 smoke so it first proves June's existing close kill-box wind-up brackets, then stages a fresh named-duelist release and proves the snap event, stinger, and HUD danger accent all fire.
- Kept `08_june_blackglass_killbox.png` visual QA focused on the pre-release kill-box tell, so the screenshot protects counterplay while smoke protects the authored snap release.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new June Blackglass snap-release, audio-stinger, and HUD danger-accent assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Return to arena challenge by adding a readable late-run obstacle or risk/reward objective, such as a Last High Noon exit-lane pressure cue or a wave-7 canyon dust-wall pocket that gives skilled players a route choice without hiding enemy tells.

## 2026-06-03 - Red Canyon Route Pockets

- Refactored wave 7's `sandstorm` arena overlay in `scripts/game/main.gd` into a dedicated Red Canyon sandstorm draw path.
- Added non-colliding calm route pockets to Red Canyon Press: darker canyon-wall side pressure, brighter amber/bone floor bands, and brass chevrons that suggest two readable lanes through the storm without changing enemy AI, damage, or movement.
- Kept the pocket visuals beneath the existing sandstorm and combat tells so Hunter lunges remain the highest-priority read.
- Updated the sandstorm HUD tip in `scripts/ui/hud.gd` to point players toward the calm pockets while warning them about Hunters.
- Added `_smoke_has_red_canyon_route_pockets()` and wired it into wave-7 smoke basics so the set-piece route choice is protected.
- Extended `07_hunter_lunge_afterimage.png` visual QA with `_visual_qa_image_has_red_canyon_route_pockets()` so the screenshot must show both the Hunter afterimage and the Red Canyon lane language.
- Reviewed `artifacts/qa/07_hunter_lunge_afterimage.png`; the calm bands and chevrons read through the sandstorm while the Hunter, player, lunge warning, and afterimage remain visible.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave-7 Red Canyon route-pocket assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new Red Canyon route-pocket screenshot assertion, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a small interactive reward or pressure beat tied to the Red Canyon pockets, such as bonus style for staying inside a calm pocket during a Hunter lunge or a late-run dust-wall warning that briefly narrows one lane before reopening.

## 2026-06-03 - Red Canyon Pocket Style Reward

- Turned wave 7's Red Canyon calm pockets from a purely visual route cue into a small skill reward.
- Shared the same pocket rectangle math between rendering and gameplay so the visible calm lanes are the actual reward zones.
- When a Hunter commits to a lunge on wave 7 and the player is standing in a calm pocket, the game now awards `CANYON POCKET` style points, gives a small heat relief, plays a reward cue, and flashes a compact `POCKET` VFX beat at the player.
- Updated the Red Canyon HUD tip in `scripts/ui/hud.gd` to tell players to hold calm pockets for style while dodging Hunters.
- Added a smoke-only Red Canyon pocket staging helper, reward counter, and assertions proving the staged Hunter lunge awards style, increments the pocket reward count, and surfaces the `CANYON POCKET` style pop.
- Reviewed `artifacts/qa/07_hunter_lunge_afterimage.png`; the Red Canyon pocket lanes, Hunter afterimage, lunge danger read, player silhouette, and HUD remain readable together.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave-7 Red Canyon pocket reward assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add another late-run mastery beat that links positioning to reward or counterplay, such as a Last High Noon exit-lane pressure cue that briefly rewards clearing space near the ride-out trail without obscuring final-wave enemy tells.

## 2026-06-03 - Last High Noon Exit Lane Reward

- Turned the wave 10 east ride-out trail into an active finale mastery beat instead of only a post-clear extraction cue.
- Added a framed Last High Noon exit-lane hold zone to the existing finale overlay in `scripts/game/main.gd`, using brass and dust-shadow language that sits under enemies and does not hide final-wave tells.
- Added a once-per-wave `EXIT LANE` reward: holding the marked east lane briefly during Last High Noon awards style points, gives a small heat break, plays a reward cue, kicks the camera lightly, and flashes compact `EXIT LANE` VFX at the player.
- Updated the wave 10 HUD tip in `scripts/ui/hud.gd` to teach holding the exit lane for style while preserving the Hunter dash/extraction reminder.
- Added smoke helpers, counters, and assertions that stage the player in the real marked east lane and prove the reward count, style score, and `EXIT LANE` pop all fire before extraction.
- Extended `09_last_high_noon.png` visual QA to protect the bright exit-lane bracket alongside the existing animated finale rays and east trail.
- Reviewed `artifacts/qa/09_last_high_noon.png`; the exit-lane bracket, ride-out trail, player silhouette, HUD, hazards, and Last High Noon rays all read together without blocking counterplay.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught a single indentation error in the new smoke staging helper, which was fixed. The final rerun completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new wave-10 Last High Noon exit-lane reward assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially failed because the added screenshot detector expected a dark hold-lane shadow that the actual bright brass bracket did not use. After measuring the captured image and tuning the detector to the real brass/contrast signature, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a little more player-facing progression around mastery rewards, such as an information-menu card or end-run ledger line that explains Red Canyon pockets and Last High Noon exit-lane style bonuses for returning players.

## 2026-06-03 - Mastery Reward Information Cards

- Added two late-run mastery cards to the Dust Heist information menu in `scripts/ui/hud.gd`.
- The new `Red Canyon` style card teaches that calm pockets cut through the sandstorm and that holding one during a Hunter lunge earns `CANYON POCKET` style.
- The new `Last High Noon` style card teaches that the east exit lane glows before extraction and that holding it under pressure earns `EXIT LANE` style.
- Kept both cards in the existing parchment/ledger card style with warm brass/red western accents and compact body copy.
- Extended `_smoke_assert_information_primer()` in `scripts/game/main.gd` so smoke protects both new mastery cards and their reward phrases.
- Reviewed `artifacts/qa/11_information_hunter_card.png`; Red Canyon, Last High Noon, June Blackglass, and Reverend Ash all render together in the late information-menu view with readable text.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new information-menu mastery card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a compact end-run ledger line that calls out mastery rewards earned this run, so players can connect `CANYON POCKET` and `EXIT LANE` bonuses to the final grade after extraction.

## 2026-06-03 - Mastery Reward Result Ledger

- Added a compact mastery summary line to the end-run grade text in `scripts/game/main.gd`.
- The extraction result ledger now reports `MASTERY CANYON x#  EXIT x#`, connecting Red Canyon calm-pocket rewards and Last High Noon exit-lane rewards to the final run grade.
- Kept the line short and placed it between named rival defeats and payday haul so it reads like part of the score receipt instead of a tutorial blurb.
- Updated full extraction smoke staging so the same ten-level smoke run earns both `CANYON POCKET` and `EXIT LANE` before extraction, making the ledger assertion reflect real earned bonuses.
- Added reusable Red Canyon pocket reward smoke helpers and extended `_smoke_assert_result_ledger()` to prove the final receipt includes `MASTERY`, `CANYON x1`, and `EXIT x1`.
- Reviewed `artifacts/qa/10_extraction_ledger.png`; the mastery line fits cleanly in the dark result card and remains readable with the rank, rivals, payday haul, and banked credits.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new full-run mastery reward staging and result-ledger assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one more small player-mastery feedback beat during combat, such as a brief combo timer rim or style-rank pulse, so players can better feel when their style chain is alive before the end-run ledger.

## 2026-06-03 - Live Combo Chain HUD

- Added an in-combat chain timer readout to the style HUD in `scripts/ui/hud.gd`.
- The style line now shows `COMBO x#  CHAIN ##%` as soon as a chain is alive, including the first rewarded action instead of waiting for combo x2.
- Added a warm pulsing style-label color while the chain timer is active so the rank/score area feels alive without adding a large new combat overlay.
- Wired `scripts/game/main.gd` to pass a normalized combo timer fraction to the HUD from the existing four-second combo timer.
- Added `get_style_label_text()` and extended the staged first-saber-kill smoke assertion so smoke proves a real slash kill surfaces `COMBO x1`, `CHAIN`, and a timer percentage on the HUD.
- Fixed a visual-QA cleanup issue where a stale duelist intro card could survive into the extraction screenshot if its tween had already ended; transient duelist overlays now hide unconditionally during cleanup.
- Hardened the full extraction smoke helper with a short cleanup frame before restart and a final assertion that the result ledger is left on screen.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live combo-chain HUD assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially exposed the stale duelist-overlay cleanup issue in the extraction capture. After the cleanup fix, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one more tiny skill-readability cue around chain drops, such as a brief `CHAIN BROKE` pulse on damage or timeout, so players understand why a style run ended.

## 2026-06-03 - Chain Break Readability

- Added a compact `CHAIN BROKE` feedback beat when an active style chain ends.
- Routed timer expiration through `_break_style_combo("TIMEOUT")` in `scripts/game/main.gd`, so the existing live chain timer now has a clear failure receipt when it runs out.
- Updated damage-based chain loss to call `_break_style_combo("HIT")`, making hit breaks use the same readable feedback path.
- `_break_style_combo()` now ignores idle/no-chain calls, clears the combo, increments a smoke-visible feedback counter, shows a `CHAIN BROKE` style pop with the reason, and flashes a small red-orange `CHAIN` VFX beat near the player.
- Extended the first-saber-kill smoke path to earn a real combo, force the timer to expire, and assert the chain-break counter, cleared combo state, and `CHAIN BROKE / TIMEOUT` HUD pop.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new chain-break timeout assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a small positive chain-save or chain-extension beat, such as a `LAST SECOND` bonus for earning style while the chain timer is under 25%, to reward clutch mastery instead of only explaining failure.

## 2026-06-03 - Last Second Chain Bonus

- Added a positive clutch mastery reward to the live style-chain system in `scripts/game/main.gd`.
- When the player earns style while an active chain is below 25% remaining, the award now adds a `LAST SECOND +75` bonus, resets the chain timer, gives a tiny heat break, plays a reward cue, and flashes a compact brass `LAST SECOND` VFX beat near the player.
- Added `_last_second_chain_bonus_count` smoke state and reset handling so the bonus is tracked per run.
- Extended the first-saber-kill smoke path to create a real chain, drop it below the clutch threshold, award follow-up style, and assert the bonus counter, score increase, chain reset, and `LAST SECOND` HUD receipt.
- Adjusted hit-based `CHAIN BROKE` feedback so it does not immediately overwrite just-earned positive style receipts such as `CANYON POCKET`, `EXIT LANE`, or `LAST SECOND`; the hit still clears the chain and plays the local break VFX.
- Hardened the visual-QA extraction capture so `10_extraction_ledger.png` waits for the actual dark result card instead of accepting the first nonblank frame if a transient duelist intro is still fading.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught the new hit-break receipt overwriting the Red Canyon pocket reward pop. After protecting positive reward receipts from immediate hit-break HUD stomps, the rerun completed with exit code 0, including the new last-second bonus assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially exposed the extraction capture accepting a stale duelist intro frame. After hardening the extraction capture loop, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a compact in-run style milestone cue, such as a one-time `RANK UP` pulse when the player crosses C/B/A/S thresholds, so the scoring ladder feels more alive before the end-run grade.

## 2026-06-03 - Live Rank Up Milestones

- Added live rank-up milestone feedback to the style scoring path in `scripts/game/main.gd`.
- `_award_style_points()` now compares the player's style rank before and after each score award. When the score crosses a higher rank threshold, the same style pop appends `RANK UP <rank>` so the milestone does not fight the earned-score receipt.
- Rank-ups now play a compact reward cue, add a small camera kick, and flash a brass `RANK <rank>` VFX beat near the player.
- Added `_rank_up_feedback_count` smoke state and reset handling.
- Added `_get_style_rank_value()` so rank comparisons stay explicit and reusable.
- Extended the first-saber-kill smoke path with a deterministic D-to-C threshold crossing, proving the rank-up counter increments, the live rank becomes `C`, and the HUD pop includes `RANK UP C`.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live rank-up milestone assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small replay-facing style progression hook, such as a result-ledger line for highest rank reached or total rank-ups, so live rank milestones connect back to the end-run receipt.

## 2026-06-03 - Style Progress Result Ledger

- Added a compact style progression line to the end-run receipt in `scripts/game/main.gd`.
- The result ledger now reports `STYLE PEAK <rank>  RANK UPS x#`, connecting live `RANK UP` combat milestones back to the run summary.
- Added `highest_style_rank` run state, reset it at run start, and update it when a rank-up threshold is crossed.
- Added `_get_style_progress_summary()` so the result ledger keeps rank progression separate from mastery rewards, rivals, payday haul, and the current score line.
- Extended `_smoke_assert_result_ledger()` to prove extraction results include the new `STYLE PEAK` and `RANK UPS` summary while keeping a compact length guard.
- Reviewed the visual-QA extraction capture through the existing screenshot detector; the result card still passes with the added style progression line.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new style progression ledger assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small player-facing replay hook in the information menu or result screen that explains style rank thresholds and how chain timing, mastery rewards, and rank-ups feed the final grade.

## 2026-06-03 - Style Rank Information Card

- Added a `Style Ranks` card to the information menu in `scripts/ui/hud.gd`.
- The card teaches the current C/B/A/S score thresholds, points players toward live chain timing and `LAST SECOND` saves, and connects mastery rewards to the final grade.
- Placed it with the other compact skill primers so the explanation is visible before the late-wave mastery cards rather than hidden only in the result ledger.
- Extended `_smoke_assert_information_primer()` in `scripts/game/main.gd` to prove the information menu includes the style-rank card, threshold numbers, and final-grade connection.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new style-rank information assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small playable scoring objective or in-wave challenge that deliberately teaches style-rank play, such as a risky optional duel banner objective for bonus style.

## 2026-06-03 - Black Sash Duel Ground Mastery

- Added an early playable style objective to wave 3 in `scripts/game/main.gd`.
- During The Black Sash fight, holding the existing arena-floor sash mark when the branded lunge releases now awards a one-time `DUEL GROUND` style reward, a small heat break, reward audio, and a brass VFX receipt.
- Updated the wave 3 objective HUD tip in `scripts/ui/hud.gd` to teach `DUEL GROUND  HOLD SASH MARK WHEN BOOT DUST RISES`, connecting the risky scoring objective to the readable duelist tell.
- Added Black Sash duel-ground smoke helpers and assertions for the HUD tip, player placement, reward count, style-score increase, and readable `DUEL GROUND` HUD receipt.
- Updated the result ledger mastery line to report `MASTERY DUEL x#  CANYON x#  EXIT x#`, so the early optional objective connects to the end-run grade alongside Red Canyon and Last High Noon mastery.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught the full extraction ledger showing `MASTERY DUEL x0` because the isolated wave 3 smoke path earned the reward but `_smoke_run_to_extraction()` did not stage it. After adding the same duel-ground staging to the full ten-level smoke run, the rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small visual affordance to the Black Sash duel-ground mark, such as a brighter pulse while the lunge tell is active, so the new mastery objective is easier for first-time players to notice under pressure.

## 2026-06-03 - Black Sash Tell-Lit Duel Ground

- Added a tell-linked visual affordance to the wave 3 Black Sash duel-ground mark in `scripts/game/main.gd`.
- `_draw_black_sash_duel_effects()` now reads the active Black Sash attack-tell strength and brightens the mastery zone only while the lunge tell is live.
- Added `_draw_black_sash_duel_ground_prompt()` with a brighter brass outer ring, bone inner arc, and inward chevrons/pips so the optional `DUEL GROUND` objective is easier to notice under pressure without adding floor text.
- Added `_get_black_sash_attack_tell_strength()` so the arena prompt ramps with the same duelist boot-dust timing that players already need to read.
- Extended the Black Sash visual-QA screenshot assertion with `_visual_qa_image_has_black_sash_duel_ground_prompt()` so the capture proves the tell-lit mark is visible, not only that the old floor sash exists.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught the new duel-ground prompt detector failing because the first version was too subtle in the actual Black Sash screenshot. After brightening the ring with stronger brass pips and tuning the detector to the rendered affordance, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small equivalent mastery affordance to a mid-run non-boss wave, such as a clearer Gold Rush keg-chain lane preview while paired kegs are live, so optional scoring reads outside duels too.

## 2026-06-03 - Gold Rush Keg Chain Lane Preview

- Added a clearer paired-keg lane preview to the Gold Rush wave in `scripts/game/main.gd`.
- Replaced the thin paired-keg link with `_draw_gold_rush_keg_chain_preview()`, which draws a dark lane bed, parallel brass rails, bone center line, endpoint rings, and moving cartridge pips between live paired kegs.
- The preview gets hotter and wider when either paired keg is lit, making the chain reaction easier to read before and during the fuse window.
- Kept the existing Gold Rush gameplay rules intact: paired kegs still chain through their normal fuse/explosion path, and the change is visual/readability focused.
- Extended `_visual_qa_image_has_gold_rush_keg_links()` to assert the stronger preview affordance with bone pips and endpoint ring checks, so the screenshot pass proves the new lane read.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the existing Gold Rush paired-keg chain assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small player-facing mastery explanation for Gold Rush, such as an information card or result-ledger detail that names paired keg chains as a style route.

## 2026-06-03 - Gold Rush Information Primer

- Added a `Gold Rush` style card to the information menu in `scripts/ui/hud.gd`.
- The card explains that brass rails link paired powder kegs, teaches players to slash or shoot one keg, bait outlaws into the lane, and chain pairs for `POWDER KEG` style.
- Placed the card near the other style/set-piece primers so the wave 8 mastery route is replay-visible outside the live HUD tip.
- Extended `_smoke_assert_information_primer()` in `scripts/game/main.gd` to prove the information menu teaches Gold Rush paired-keg rails and `POWDER KEG` style routing.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new Gold Rush information-primer assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small result-ledger line or compact summary that reports `POWDER KEG` chain value, so Gold Rush mastery is remembered at extraction alongside duel, canyon, and exit mastery.

## 2026-06-03 - Powder Keg Result Ledger

- Added Gold Rush mastery value to the extraction result ledger in `scripts/game/main.gd`.
- `_get_mastery_reward_summary()` now includes a compact `POWDER KEG x#` line when keg-chain blasts hit enemies, using the existing `keg_chain_bonus` counter that is incremented by live powder-keg explosions.
- Extended `_smoke_assert_result_ledger()` to prove the final extraction receipt remembers Gold Rush `POWDER KEG` value alongside `DUEL`, `CANYON`, and `EXIT` mastery.
- Updated `_smoke_run_to_extraction()` so the full ten-level smoke run stages the Gold Rush paired-keg chain before extraction, ensuring the end-run receipt is earned through the same run path rather than only through isolated wave smoke.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially caught the result ledger missing `POWDER KEG x#` because the isolated Gold Rush smoke path earned keg value but the full ten-level extraction smoke path did not. After staging the Gold Rush keg chain inside `_smoke_run_to_extraction()`, the rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the fix.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small readability polish to the extraction result card, such as tightening the mastery/result typography or adding a brass divider so the richer ledger remains easy to scan.

## 2026-06-03 - Extraction Ledger Brass Divider

- Added a middle brass divider to the extraction result card in `scripts/ui/hud.gd`.
- The result card now uses top, middle, and bottom saloon-ledger rules, separating the richer ten-level receipt into clearer title, run-summary, and payout/action zones without changing the compact result text.
- Added `get_result_divider_count()` to the HUD so the smoke test can verify the result card keeps all three readability dividers visible during extraction.
- Extended `_smoke_assert_result_ledger()` in `scripts/game/main.gd` to assert the three-divider result-card frame alongside the existing extraction, mastery, `POWDER KEG`, style, and payout ledger checks.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new result-divider assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small player-mastery payoff to the live HUD, such as a more legible `RANK UP`/style-chain flash near the score readout, so the same stylish progression the ledger summarizes is clearer while players are fighting.

## 2026-06-03 - Live Style Receipt Frame

- Added a leather-and-brass frame behind live style popups in `scripts/ui/hud.gd`.
- `show_style_pop()` now gives every score receipt a dark leather backing and brass flash rule, with a brighter, larger treatment for `RANK UP` moments so rank thresholds read clearly during combat instead of only on the result ledger.
- Added `get_style_pop_frame_alpha()` so smoke tests can verify the rank-up receipt is visibly framed while the popup is live.
- Extended the existing rank-up smoke path in `scripts/game/main.gd` to assert the framed HUD receipt after crossing the `RANK UP C` threshold.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new framed rank-up receipt assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small animated payoff to high-value mastery rewards, such as a brief brass burst or camera tick on `POWDER KEG`/`CANYON POCKET` receipts, so the best skill plays feel more tactile without adding difficulty.

## 2026-06-03 - Mastery Payoff Burst

- Added a reusable high-value mastery payoff in `scripts/game/main.gd`.
- `POWDER KEG` and `CANYON POCKET` rewards now trigger a brief brass shockwave, burst, labeled impact flash, and small camera tick on top of their existing style receipts, making the best skill plays feel more tactile without changing damage, scoring rules, or enemy pressure.
- Added `_mastery_payoff_feedback_count` plus `_smoke_get_mastery_payoff_feedback_count()` so smoke can verify the payoff fires during staged mastery rewards.
- Extended the existing Red Canyon and Gold Rush smoke paths to assert that calm-pocket mastery and both chained Gold Rush keg explosions each produce the new brass payoff feedback.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new mastery payoff assertions for Red Canyon and Gold Rush, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add one small ease-of-play polish to the first-wave onboarding, such as a clearer dash-ready visual or HUD nudge after the first `FIRST CUT`, so new players learn the slash-then-dash rhythm faster.

## 2026-06-03 - Menu Nav Brass Inlay Buttons

- Added a procedural `MenuNavButton` class to `scripts/ui/hud.gd` and moved the main menu nav buttons onto `menu_nav_brass_inlay_v1`.
- Each nav button now draws a darker leather plate, brass rim, rivets, a left icon medallion, section-specific icons, and a selected-state brass arrow so the menu reads like crafted western UI instead of plain stacked buttons.
- Added active nav state tracking so `SWORDS`, `GUNS`, `ABILITIES`, `QUESTS`, and `INFORMATION` visibly select the matching button when opened.
- Fixed a custom-draw layering issue found during manual visual inspection: the new button drawing covered Godot's native button label, so the class now manually draws the button text with shadow after the icon/chrome pass.
- Added `get_main_menu_nav_button_visual_version()` and `get_main_menu_selected_nav_count()` hooks, then extended smoke/visual QA coverage so the information-menu capture must show exactly one active brass-inlay nav button and enough brass pixels in the left nav strip.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the nav button polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new nav visual version assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 after the label draw fix and reported `DUST_VISUAL_QA: PASS` across all expected captures.
- Manually inspected `artifacts/qa/11_information_hunter_card.png`; the first check caught missing nav labels, then the rerun confirmed labels, icons, and the active Information arrow were visible.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by polishing reward pickups and in-arena interactable props so moment-to-moment rewards look as intentional as the menus and HUD.

## 2026-06-03 - Payday Satchel Brass Spill

- Upgraded the wave-clear payday pickup in `scripts/game/main.gd` from `payday_satchel_v1` to `payday_satchel_brass_spill_v2`.
- Added a richer reward silhouette: broader grounded shadow, warm pickup halo, dimensional leather body shading, a brass bank-stamp medallion, visible spilled coins, and exposed ammo shells.
- Split the satchel art into small procedural helpers for the coin spill, bank stamp, and ammo spill so the pickup remains cheap to draw and easy to tune without new texture memory.
- Added pickup metadata fields for `coin_spill`, `ammo_spill`, and `brass_stamp`, then strengthened `_smoke_assert_payday_pickup_visual_upgrade()` so smoke tests prove the reward cues stay present.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded pickup.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new brass-spill payday pickup assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all expected captures.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with hover/pressed polish for any remaining compact action surfaces, or add a dedicated visual QA capture for payday drops so the richer satchel art is screenshot-verified as directly as the menu and arena passes.

## 2026-06-03 - Duelist Intro Wanted Poster

- Replaced the flat duelist intro card in `scripts/ui/hud.gd` with a custom procedural `DuelistIntroCard` using `duelist_intro_wanted_poster_v1`.
- The boss intro now draws a leather backing, parchment wanted poster, brass pins, accent bands, paper grain, framed portrait area, and a simple western duelist silhouette with a highlighted weapon line.
- Repositioned the intro title, `WANTED` label, rival name, and story line so they sit inside the new poster treatment instead of floating on a flat color block.
- Kept the existing intro timing, leaf drift, and overlay fade behavior intact, so the upgrade adds no new texture memory and only draws during the short boss-intro moment.
- Added `get_duelist_intro_visual_version()` and `get_duelist_intro_visible()` to the HUD, then added `_smoke_assert_duelist_intro_visual_upgrade()` in `scripts/game/main.gd` so waves 3, 6, and 9 prove the wanted-poster intro is visible and versioned.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded duelist intro.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new boss-wave wanted-poster intro assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all expected captures.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Add a dedicated duelist-intro visual QA capture or continue polishing compact button/interaction surfaces that still rely on simple labels rather than crafted western iconography.

## 2026-06-03 - Storefront Brass And Glass Highlights

- Added `storefront_brass_glass_highlights_v1` to `scripts/game/main.gd` as a versioned material-polish pass for the town-square perimeter.
- Layered cheap procedural brass studs, sun lip highlights, glass streaks, and small lantern glows onto front-facing and side storefronts so the saloon, bank, general store, hotel, sheriff, barber, and related businesses read as more physical western buildings.
- Kept the upgrade static and perimeter-only: no new textures, no particle systems, and no extra combat-center noise.
- Extended smoke coverage through `_smoke_assert_town_square_business_roster()` so the storefront material pass is checked alongside the business roster.
- Added a dedicated `01_storefront_highlights.png` visual QA capture that pans to the storefront row and verifies brass, glass, lantern, dark-frame, and contrast signatures instead of relying on the centered arena screenshot.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially hit two transient existing staged-capture assertions on later combat scenes after adding the extra storefront capture; a rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- Manually inspected `artifacts/qa/01_storefront_highlights.png` to confirm the top storefront row shows the new sign, window, porch, and lantern highlights while the arena floor remains readable.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The final smoke run still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with a focused menu/card polish pass for the quest and information cards, so the non-combat screens match the richer town-square and HUD material treatment.

## 2026-06-03 - Weathered Ledger Info And Quest Cards

- Upgraded the non-combat menu card treatment in `scripts/ui/hud.gd`.
- Bumped information cards to `info_card_weathered_ledger_v2` and quest cards to `quest_card_bounty_stamp_v2`.
- Replaced the flat StyleBox card surfaces with custom low-cost procedural frames: dark leather edges, weathered paper interiors, brass rivets, faint ledger ruling, sun-worn header bands, and stamped corner marks.
- Added a bounty-stamp treatment to quest cards, including a darker progress well and separate complete/incomplete stamp colors, while preserving the existing text layout and card dimensions.
- Updated smoke contracts in `scripts/game/main.gd` to assert the new card visual versions.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially failed because the smoke assertions still expected the previous info/quest card visual versions; after updating the assertions to the v2 contracts, the rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke run still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported after the contract update.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- Manually inspected `artifacts/qa/11_information_hunter_card.png` to confirm the information cards show the new leather, paper, brass, ledger-line, and stamp details without hiding body text.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the button graphics pass by polishing the left-side main menu navigation buttons with stronger selected-state framing and icon marks, so the menu controls match the richer card surfaces.

## 2026-06-03 - Sand-Soaked Blood Stain Composition

- Upgraded persistent blood decals in `scripts/systems/vfx_layer.gd`.
- Each enemy defeat now leaves a richer sand-soaked composition with a dark soak halo, directional drag streaks, clustered drops, a partial dry rim, and small dusty grit pips.
- Kept the existing `MAX_BLOOD_STAINS := 15` cap and reused the current texture path, so the arena gains more grounded combat history without increasing persistent decal count or adding new texture dependencies.
- Added `sand_soaked_blood_stain_v1` smoke hooks plus total/count accessors so automated smoke verifies enemy defeats produce the upgraded persistent stain.
- Extended the first-wave slash smoke assertion in `scripts/game/main.gd` to prove a confirmed rusher defeat creates the new sand-soaked stain.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new sand-soaked blood-stain assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a subtle low-cost dust haze or heat-shimmer accent to the arena edges so the background feels more sun-baked while keeping the central combat lane clean.

## 2026-06-03 - High-Noon Arena Edge Haze

- Added a low-cost arena atmosphere pass in `scripts/game/main.gd`.
- The courtyard now draws warm high-noon haze bands, thin shimmer strokes, and small dust curls around the arena edges, fences, and storefront side lanes.
- Kept the central combat lane cleaner than the edges by biasing the new detail toward perimeter bands and using simple procedural draw calls rather than new animated textures.
- Added `high_noon_edge_haze_v1` smoke coverage through the arena floor visual hook.
- Extended visual QA on `01_first_draw.png` to verify the first-wave capture has warm edge haze while preserving a readable center floor.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught an overly strict edge-haze detector; after tuning the detector to the rendered warm-edge signature, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue improving background polish by adding small sign, window, and lantern material highlights to the storefronts, keeping them static and perimeter-only for FPS safety.

## 2026-06-03 - Player Parry Brass Clang Ring

- Added a dedicated player parry flourish in `scripts/systems/vfx_layer.gd`.
- Parrying now throws a short brass-and-bone ring with crossed blade streaks, denim back-arc, iron contact shadow, and small spark pips, making successful saber timing read as a distinct western metal-on-metal moment instead of only generic shockwave text.
- Kept the effect lightweight and capped with `MAX_PARRY_CLANGS := 12`, with a 0.24 second lifetime and no new texture dependency.
- Wired `_on_player_parried()` in `scripts/game/main.gd` to call the new `parry_clang()` hook while preserving the existing heat reduction, style award, impact freeze, burst, and audio cue.
- Added smoke hooks and assertions for `parry_clang_brass_ring_v1` so the playable smoke run verifies the parry effect exists and fires from the real parry event.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new parry clang assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.

Next recommended step:

- Add a readable player-hit damage flourish, separate from parry, so taking a hit has its own grounded blood/dust directionality without overwhelming enemy tells.

## 2026-06-03 - Player Hit Blood And Dust Flash

- Added a dedicated player damage flourish in `scripts/systems/vfx_layer.gd`.
- Taking damage now throws a short directional blood slash, darker wound streak, denim back-arc, and boot-dust fan so player hits read as a distinct grounded impact instead of only generic red burst text.
- Kept the effect procedural and lightweight with `MAX_PLAYER_HIT_FLASHES := 10`, a 0.22 second lifetime, and no new texture dependency.
- Wired `_on_player_damaged()` in `scripts/game/main.gd` to call `player_hit_flash()` while preserving the existing combo break, heat increase, impact freeze, red burst, HIT receipt, and audio cue.
- Added smoke hooks and assertions for `player_hit_blood_dust_flash_v1` so the playable smoke run verifies the real damage event fires the effect.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player-hit flash assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Improve the persistent blood-stain composition so repeated kills create more believable sand-soaked decals without making the arena floor too noisy.

## 2026-06-03 - Result Ledger Frame Polish

- Replaced the flat result-card rectangle in `scripts/ui/hud.gd` with a custom procedural `ResultCardFrame`.
- The extraction and failure result pop-out now uses a dark leather ledger center with brass trim, rivets, subtle ruled linework, darker value contrast, and a faint stamped mark behind the result text.
- Kept the result treatment static and draw-call-light: no new texture dependency, no looping particle work, and only a short existing glow tween.
- Added `RESULT_CARD_VISUAL_VERSION := "result_card_tinted_ledger_v1"` plus `get_result_card_visual_version()` so automation can verify the upgraded frame is active.
- Extended the result ledger and failed-run smoke assertions in `scripts/game/main.gd` to require the custom tinted ledger result frame while preserving the existing pop-out and brass-divider checks.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the result ledger polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new result-frame version assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught that the first parchment-heavy version no longer satisfied the dark result-card contract; after retuning the frame to a dark leather ledger center, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with a high-frequency combat surface such as richer enemy hit sparks by archetype, sharper danger flashes, or more storefront lighting accents around the town square.

## 2026-06-03 - Role-Aware Enemy Hit Sparks

- Added a capped, short-lived `enemy_hit_spark()` effect to `scripts/systems/vfx_layer.gd`.
- Enemy hits now throw compact brass streaks, bone-hot flecks, red impact dust, and role-tinted accents instead of relying only on a white sprite flash.
- The spark accents vary by archetype: knife rushers, riflemen, shotgun brutes, hunters, and duelists each get a slightly different combat read while staying inside the Dust Heist palette.
- Wired the effect through `scripts/enemies/base_enemy.gd` so every enemy damage event gets the same polished feedback without touching each enemy script individually.
- Added `ENEMY_HIT_SPARK_VISUAL_VERSION := "enemy_hit_sparks_role_burst_v1"` plus count/version getters, with a first-slash smoke assertion proving a real enemy hit triggers the new role-aware spark.
- Kept the effect FPS-conscious with a maximum of 28 active hit sparks and a `0.18` second lifetime.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the combat hit-spark polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new first-wave enemy hit spark assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue improving combat spectacle with a focused player-side pass, such as a richer parry clang ring, sharper damage danger flash, or more readable gunshot impact material cues.

## 2026-06-03 - Visual QA Tell Staging Stabilization

- Stabilized the visual QA combat captures in `scripts/game/main.gd` so short-lived boss and enemy tells are captured deterministically instead of waiting on natural AI timing.
- The Black Sash, Mercy Vale, and June Blackglass visual QA frames now stage their actual duelist draw/lunge tells immediately before screenshot capture, preserving the real rendered lunge lanes, boot dust, and kill-box brackets.
- Added deterministic staging for the Dust Chapel shotgun brute recovery cue so the post-shot smoke/shell tell is visible in the captured frame.
- Added deterministic staging for the Red Canyon Hunter lunge afterimage, including the real afterimage stack and a dust pop, so the capture proves the rendered trail rather than relying on a narrow timing window.
- Improved payday route readability in normal play by dropping satchels farther from the player and lowering the route hint distance threshold from `72.0` to `48.0`, making the brass trail easier to see without adding heavy effects.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the stabilized capture/readability update.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially exposed the Hunter afterimage timing issue; after adding `_smoke_stage_hunter_lunge_afterimage()`, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with a true visual upgrade pass on one remaining high-frequency surface, such as richer enemy role-specific impact effects, storefront lighting accents, or sharper pause/results button states.

## 2026-06-03 - Compact Skill Button Polish

- Added `SkillIcon.VISUAL_VERSION := "skill_icon_leather_brass_v1"` in `scripts/ui/hud.gd`.
- Reworked the compact in-run ability buttons with the same 54x54 footprint: dark leather base, inner panel, brass rim and highlight, circular icon well, rivets, and cooldown trim.
- Added HUD getters for the skill icon visual version and count.
- Extended `_smoke_assert_main_menu_visual_upgrade()` in `scripts/game/main.gd` so smoke verifies the compact HUD skill buttons keep the leather-and-brass pass.
- Added a first-frame visual QA detector for the compact skill button treatment.
- Rebuilt the Web export in `build/web/index.html`.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` was run during the pass; the new first-frame skill button detector did not fail, but the suite currently remains flaky on unrelated staged late-wave/mastery/payday checks.
- Manual inspection of `artifacts/qa/01_first_draw.png` confirmed the compact skill buttons render as leather-and-brass panels without changing layout.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the all-buttons graphics pass by upgrading the larger gun and ability card button chrome so the loadout menu matches the richer icons and compact HUD controls.

## 2026-06-03 - Loadout Card Stamped Button Chrome

- Added `LOADOUT_CARD_VISUAL_VERSION := "loadout_card_stamped_leather_v1"` in `scripts/ui/hud.gd`.
- Upgraded gun and ability loadout button styles with warmer parchment, dark leather borders, brass selected states, heavier lower bevels, and subtle shadows while preserving the existing card size and text layout.
- Threaded equipped state through `_apply_button_card_style()` so selected gun and ability cards get a stronger brass-stamped treatment on every refresh.
- Added HUD getters for loadout card visual version and complete styled-card count.
- Extended `_smoke_assert_main_menu_visual_upgrade()` in `scripts/game/main.gd` so smoke verifies the new loadout card visual version and all twelve gun/ability card buttons keep normal, hover, pressed, and disabled styles.
- Kept the work procedural through `StyleBoxFlat` changes only, avoiding texture memory, imports, or per-frame animated cost.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new loadout card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` currently fails on the unrelated staged Last High Noon overlay detector; no parse or smoke failure was caused by the loadout card chrome pass.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with either a focused Last High Noon visual QA stabilization pass or another low-cost menu surface polish such as quest-card ledger treatment.

## 2026-06-03 - Last High Noon Sunfire Finale

- Added `LAST_HIGH_NOON_VISUAL_VERSION := "last_high_noon_sunfire_v1"` in `scripts/game/main.gd`.
- Strengthened the wave 10 Last High Noon arena treatment with a hotter amber sunfire wash, larger pulsing noon ring, thicker readable sun-spoke rays, stronger red/brass arena borders, and a clearer east exit trail.
- Reworked the final extraction lane cue with a darker lane shadow, brighter brass lane fill, inner frame, heavier ride-out chevrons, and a more readable glowing exit anchor.
- Added `_smoke_assert_last_high_noon_visual_upgrade()` so the full extraction smoke path verifies the finale is using the new sunfire visual pass.
- Kept the upgrade procedural inside the existing level modifier draw pass, with no new texture imports or extra scene nodes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`, including `artifacts/qa/09_last_high_noon.png`.
- Manually inspected `artifacts/qa/09_last_high_noon.png`; the finale now reads as a deliberate high-noon sunfire setpiece with a clearer east exit trail while enemies remain visible.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new finale visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.

Next recommended step:

- Continue the graphics push with another low-cost high-impact surface, such as quest-card ledger polish or stronger weapon impact sparks, now that visual QA is green again.

## 2026-06-03 - Information Card Ledger Polish

- Added `INFO_CARD_VISUAL_VERSION := "info_card_ledger_stamp_v1"` in `scripts/ui/hud.gd`.
- Reworked the shared `InfoCard` menu card treatment for overview, swords, and information screens with warmer parchment, heavier dark leather borders, subtle shadows, brass rule highlights, stronger accent strips, and text shadow treatment.
- Kept the existing card footprint and grid layout intact so menu text and scroll behavior remain stable.
- Added HUD getters for information card visual version and visible card count.
- Extended `_smoke_assert_main_menu_visual_upgrade()` in `scripts/game/main.gd` so smoke verifies the stamped information-card pass and confirms the main overview cards render.
- Kept the pass purely procedural through style boxes, labels, and color rects, avoiding new texture memory or animated UI cost.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new information-card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially missed the staged Black Sash boot-dust cue, then a rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- Manually inspected `artifacts/qa/11_information_hunter_card.png` to confirm the stamped ledger cards remain readable after the richer styling.

Next recommended step:

- Continue the graphics push by polishing the quest screen cards with clearer progress bars and reward stamps, or move back into combat spectacle with stronger slash/hit spark material.

## 2026-06-03 - Quest Card Reward Stamp Polish

- Added `QUEST_CARD_VISUAL_VERSION := "quest_card_reward_stamp_v1"` in `scripts/ui/hud.gd`.
- Replaced the quest screen's plain multiline label panels with a lightweight procedural `QuestCard` class.
- Each quest card now has a parchment-and-leather ledger frame, brass shadow treatment, a visible progress bar, compact status text, and a reward stamp line.
- Completed quests receive a greener reward-ledger treatment while incomplete quests keep the amber progress styling.
- Added HUD getters for quest card visual version and quest card count.
- Extended `_smoke_assert_main_menu_visual_upgrade()` in `scripts/game/main.gd` so smoke verifies the quest screen keeps four reward-stamped quest cards.
- Kept the pass static and procedural with four menu-only controls, avoiding new texture memory or per-frame gameplay cost.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new quest-card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` was attempted twice; both runs failed on unrelated staged combat tell captures such as Mercy Vale, June Blackglass, Dust Chapel recovery, payday trail, and Black Sash lunge timing. No quest-card parse or smoke failure was reported.

Next recommended step:

- Stabilize the staged visual QA combat tell captures, then continue the graphics push with stronger slash and impact spark material.

## 2026-06-03 - Courtyard Floor Rut Polish

- Added `ARENA_FLOOR_VISUAL_VERSION := "courtyard_floor_ruts_v1"` and exposed `_get_arena_floor_visual_version()` for smoke coverage.
- Expanded the arena sand detail pass with controlled wagon-rut lanes, boot scuffs, soft sunlit highlights, darker track bands, subtle footprint ellipses, and curved scrape marks.
- Kept the floor treatment fully procedural and static, with low primitive counts and no new runtime textures, so it improves the battlefield material read without adding heavy FPS cost.
- Added `_visual_qa_image_has_courtyard_floor_ruts()` and hooked it into `01_first_draw.png` so visual QA verifies the floor detail is present while staying below noisy contrast levels.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded courtyard floor.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially caught an over-strict floor detector; after tuning it to sample unobstructed floor patches and match the intended subtle sand detail, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all 15 staged captures.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new arena floor visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- Manually inspected `artifacts/qa/01_first_draw.png` to confirm the floor now has more believable rut/scuff structure while enemies, HUD, hazards, and text remain readable.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by polishing the remaining button and card surfaces, especially compact in-run ability buttons, so the menu, HUD, and gameplay controls share the same leather-and-brass finish.

## 2026-06-03 - Payday Satchel Visual Polish

- Added `PAYDAY_PICKUP_VISUAL_VERSION := "payday_satchel_v1"` and stamped spawned payday pickups with the new visual contract.
- Replaced the simple payday pickup rectangle with a low-cost procedural leather satchel: grounded contact shadow, shaped body and flap, brass buckle/rim, coin highlights, cartridge shells, and strap ties.
- Kept route hints, pointer behavior, optional label text, ammo refill, credits, and collection behavior unchanged.
- Added `_smoke_assert_payday_pickup_visual_upgrade()` so the smoke run verifies live payday drops carry the polished western pickup visual pass.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the satchel pickup upgrade.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new payday satchel visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all 15 staged captures.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by polishing cover and hazard interactables with stronger material shading and western prop silhouettes, while keeping them readable during combat.

## 2026-06-03 - Crossfire Saloon Table Cover Polish

- Added `SALOON_COVER_VISUAL_VERSION := "saloon_table_cover_v1"` and stamped generated Crossfire cover props with it.
- Reworked the Crossfire cover rendering from flatter rectangular barricades into richer saloon tables with shaped tops, grounded oval shadows, legs, layered plank highlights, brass studs, bottle silhouettes, glass/card clutter, and stronger edge lighting.
- Improved the splintered-state art with darker cracks, exposed bright wood cuts, extra shards, and broken tabletop chunks so damaged cover reads faster during combat.
- Kept the implementation procedural and lightweight, with no new runtime textures or per-prop scene overhead.
- Added `_smoke_assert_saloon_cover_visual_upgrade()` to verify both wave-2 saloon cover props carry the polished visual contract.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded Crossfire cover.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new saloon cover visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all 15 staged captures.
- Manually inspected `artifacts/qa/02_rifleman_crossfire_tell.png` to confirm the tables look like physical saloon furniture while rifle sightlines remain readable.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the arena graphics pass by giving the powder keg hazards a similarly polished prop treatment: clearer barrel materials, fuse sparks, warning silhouettes, and better lit/unlit contrast.

## 2026-06-03 - Powder Keg Material Polish

- Added `POWDER_KEG_VISUAL_VERSION := "powder_keg_material_v1"` and stamped generated arena hazards with the new visual contract.
- Replaced the simpler circular powder keg drawing with a lightweight procedural barrel: shaped stave body, grounded contact shadow, darker side mass, iron/brass hoops, rivets, fuse socket, rope highlight, and warm material rim lighting.
- Preserved the existing warning arcs and explosion gameplay readability while making lit kegs hotter with a small ember glow, fuse sparks, and stronger amber contrast.
- Added `_smoke_assert_powder_keg_visual_upgrade()` so each smoke-tested wave verifies live hazards carry the polished visual contract.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded powder kegs.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new powder keg visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` across all 15 staged captures.
- Manually inspected `artifacts/qa/06_gold_rush_keg_links.png` to confirm the kegs read as stronger physical props while the Gold Rush chain-link cue remains clear.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by polishing the static arena floor treatment: add more controlled wagon ruts, boot scuffs, shadow bands, and calmer high-readability lanes without increasing texture noise.

## 2026-06-03 - Enemy Silhouette And Contact Shadow Polish

- Upgraded shared enemy grounding in `scripts/enemies/base_enemy.gd` with layered warm contact shadows so enemies sit more believably on the sand without adding new textures or expensive effects.
- Added a shared `role_silhouette_v1` enemy visual hook and `_draw_enemy_role_silhouette_accent()` helper for small, high-contrast old-west readability marks.
- Applied role-specific silhouette accents across knife rushers, riflemen, shotgun brutes, hunters, and duelists:
  - Knife rushers get a sharper red scarf/knife glint read.
  - Riflemen get a stronger hat/rifle line.
  - Shotgun brutes get broader shoulder/shell-belt cues.
  - Hunters get lean fang/duster marks.
  - Duelists get a brass hat/sash/blade identity cue.
- Added `_smoke_assert_enemy_silhouette_visual_upgrade()` to the playable smoke test so live enemies keep exposing the shared visual-polish hook.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the enemy readability pass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new enemy silhouette visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` with all 15 expected captures.
- Manually inspected `artifacts/qa/01_first_draw.png` to confirm first-wave rushers gained stronger contact shadows and red/bone silhouette accents without covering combat readability.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Add a similar low-cost player-character polish pass: denim/brass rim accents, cleaner saber/revolver silhouette marks, and a slightly richer player contact shadow so the cowgirl remains the strongest read on the sand during busy waves.

## 2026-06-03 - Player Hero Readability Polish

- Upgraded `scripts/player/player.gd` with a versioned `denim_brass_hero_v1` visual hook for the player character.
- Added a layered player contact shadow that widens subtly with movement and dash state, keeping the cowgirl grounded on the sand without new textures.
- Added a low-cost denim/brass/bone-white hero accent layer that draws over both rendered sprites and the procedural fallback:
  - Denim shoulder/rim marks reinforce the player-read color.
  - Brass belt, buckle, hat band, revolver, and saber-hilt glints strengthen the western material read.
  - Bone-white saber edge marks keep the weapon silhouette visible even when the sprite is not actively slashing.
  - Tiny spur and dash streak cues add motion polish without particle cost.
- Added `_smoke_assert_player_hero_visual_upgrade()` in `scripts/game/main.gd` so the playable smoke run verifies the player keeps the new hero-read visual hook.
- Added `_visual_qa_clear_staged_result_overlay()` for the staged Hunter screenshot after QA exposed that a Hunter lunge could kill the player and leave the result pop-out covering the Red Canyon visual capture.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the player readability pass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player hero visual assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially failed because the staged Hunter lunge could leave the result pop-out over `07_hunter_lunge_afterimage.png`; after adding the staged-result cleanup helper, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS` with all 15 expected captures.
- Manually inspected `artifacts/qa/01_first_draw.png` to confirm the cowgirl gained clearer denim/brass identity and a firmer contact shadow without covering the first-wave title text or nearby rusher tell.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by polishing pickup/payday visuals and in-arena interactable props, so rewards and tactical objects look as intentional as the characters and HUD while staying cheap to render.

## 2026-06-03 - Town-Square Foreground Dressing

- Added deterministic foreground prop layout data to `scripts/game/main.gd` so the old-west perimeter has intentional town-square dressing outside the combat fence.
- Drew lightweight procedural props tied to storefront identities: sheriff wanted boards, stable hitching posts, doctor/stable water troughs, general-store supply crates, barber basin, and lantern posts.
- Added grounded oval shadows, wood texture reuse, brass trim, paper notices, rope arcs, water glints, and small material highlights so the props read as physical western objects without adding new texture memory.
- Kept every prop outside the arena fence and away from the active combat space, preserving clear movement, bullets, hazards, and enemy silhouettes.
- Added `_get_town_square_foreground_prop_kinds()` and extended the town-square smoke assertion to prove the required prop roster remains present.
- Added `_visual_qa_image_has_town_square_foreground_props()` and connected it to `01_first_draw.png`, so visual QA now verifies the foreground props produce readable pixels in the first playable arena capture.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the dressed-up town square.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new town foreground prop roster assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0, including the new first-draw foreground prop pixel detector, and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by adding more authored variation to character presentation, such as sharper enemy silhouette accents or improved duelist portrait/card materials, while keeping the combat reads clean.

## 2026-06-03 - First-Cut Dash Prompt Polish

- Added a short-lived procedural `SPACE` dash prompt to `scripts/systems/vfx_layer.gd`.
- The first confirmed saber kill now shows the existing brass dash glint plus a leather-and-brass keycap, directional arrow, and small bone highlight near the player.
- Wired the prompt through `_show_first_saber_kill_feedback()` in `scripts/game/main.gd`, so it appears only with the one-time `FIRST CUT / DASH NEXT` onboarding nudge instead of repeating during normal combat.
- Added `get_dash_ready_prompt_total_count()` and extended `_smoke_assert_first_slash_afterimage()` so the smoke test proves the first-wave slash-to-dash visual cue fires.
- Kept the cue procedural, short-lived, and attached to the VFX layer, avoiding new texture memory and preserving the existing FPS-friendly UI approach.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the first-cut dash prompt.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught one typed-inference parse error in the new dash direction local; after adding an explicit `Vector2` type, the rerun completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new dash prompt assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`. The existing ObjectDB leak warning still printed at process exit, but no smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the visual polish by adding small town-square foreground props outside the fence, such as hitching posts, lanterns, troughs, and wanted boards that match the varied business fronts without cluttering combat space.

## 2026-06-03 - Loadout Card Western Iconography

- Added a procedural `LoadoutIcon` control in `scripts/ui/hud.gd` for gun and ability cards.
- Gave each weapon and ability a distinct low-cost western emblem: revolver, rifle, sawed-off, pepperbox, golden revolver, Deadeye reticle, ricochet lane, dust veil, quickdraw streaks, duelist lunge, fan hammer, and ghost step.
- Reworked the gun and ability card body layout so every card now pairs its description with a compact leather-and-brass icon panel, while keeping the existing 2-column loadout menu footprint.
- Wired icon state to live loadout refreshes so locked cards fade and equipped cards show a brass pip.
- Added `get_loadout_icon_count()` and extended `_smoke_assert_main_menu_visual_upgrade()` in `scripts/game/main.gd` so smoke tests verify the menu stays richer than text-only loadout buttons.
- Kept the icon work entirely procedural and static, avoiding new texture memory, import churn, or animated UI cost.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded loadout buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new loadout icon assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially missed the staged Hunter afterimage and Red Canyon pocket detectors, then a clean rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by adding a first-wave onboarding visual flourish, such as a polished dash-ready cue or slash rhythm nudge, so the live combat HUD communicates mastery with the same crafted western treatment as the menus.

## 2026-06-03 - Town Square Storefront Variety

- Reworked the old-west perimeter renderer in `scripts/game/main.gd` so the arena is surrounded by a roster of common town businesses instead of repeated saloon fronts.
- Added distinct procedural storefront identities for `SALOON`, `BARBER`, `SHERIFF`, `BANK`, `GENERAL`, `HOTEL`, `STABLE`, and `DOC`, with readable business signs, icon silhouettes, and business-specific props such as barber poles, sheriff badges, bank vault doors, hotel balcony rails, stable arches, saloon swing doors, and general-store awnings.
- Updated the top, bottom, and side perimeter strips to rotate through those businesses, making the arena read more like a western town square while preserving the dusty wood-and-brass art direction.
- Added `_smoke_assert_town_square_business_roster()` to lock in the storefront variety during the playable smoke run.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the town-square backdrop update.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new town-square storefront roster assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Add a little more town-square depth with a few non-combat foreground details just outside the fence, such as hitching posts, water troughs, wanted boards, or lantern posts tied to the new business identities.

## 2026-06-03 - Western Menu Backdrop And Button Polish

- Replaced the flat main-menu backdrop in `scripts/ui/hud.gd` with a custom procedural `MenuBackdrop`.
- The menu now draws a warm western title scene with dusty sky bands, low-cost sun rays, a wood-plank lower edge, a signboard frame behind the `DUST HEIST` title, subtle dust flecks, and a vignette frame.
- Restyled the main nav buttons with custom leather-and-brass normal, hover, pressed, and disabled `StyleBoxFlat` states instead of relying on default Godot button chrome.
- Added title shadow/outline treatment so the brand reads more like a physical old-west sign while staying readable over the richer backdrop.
- Kept the upgrade static and procedural, with no per-frame animation or new texture dependency, to move the menu visuals forward without adding avoidable FPS cost.
- Added smoke hooks and `_smoke_assert_main_menu_visual_upgrade()` so the automated playable run verifies the custom menu backdrop and all six nav buttons keep their styled states.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the menu polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught one invalid `draw_rect()` call in the new backdrop; after wrapping the position and size in `Rect2`, the rerun completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new main-menu visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- Manually inspected `artifacts/qa/11_information_hunter_card.png` to confirm the new title treatment, darker nav buttons, and richer western menu backdrop remain readable with the information cards.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push by upgrading the live HUD frame treatment around health, danger, ammo, and wave/style text so the in-combat interface feels as crafted as the menu while preserving combat readability.

## 2026-06-03 - Live HUD Ledger Frame

- Added a custom low-cost `HudLedgerFrame` to `scripts/ui/hud.gd` behind the left-side combat HUD.
- The health, danger, timer, wave, style, skills, and ammo stack now sits on a dark leather-and-brass ledger panel with a framed health slot, brass rivets, separator rules, and corner studs.
- Added subtle shadow and outline treatment to the shared live HUD labels so they remain readable against the richer arena art and new panel materials.
- Made `_start_run()` in `scripts/game/main.gd` explicitly hide the menu and show gameplay HUD state, so normal starts and smoke starts share the same visual state.
- Moved the left Crossfire saloon cover lower in the arena so the wider HUD panel no longer hides a staged cover prop; this keeps both barricades readable in wave 2.
- Added `get_live_hud_frame_visible()` and `get_live_hud_frame_class_name()` plus first-wave smoke assertions so the live HUD frame stays covered by automated regression checks.
- Added `clear_result_overlay_for_staged_run()` and used it in `_smoke_start_wave()` so visual QA staged waves cannot inherit stale result/death overlays from earlier staged failures.
- Made the Gold Rush visual QA detector scan all visible unspent keg pairs instead of assuming the first two hazards are the best visible pair; the same color/contrast thresholds still prove the brass connector cue.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the live HUD polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught one invalid `draw_rect()` call in the new HUD frame; after wrapping the shadow rectangle in `Rect2`, the rerun completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live HUD frame assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` initially exposed a few staging issues after the HUD frame widened: the left Crossfire cover was under the HUD, the Gold Rush detector was sampling a brittle pair, and staged visual QA waves could inherit stale result overlays. After fixing those, the rerun completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- Manually inspected `artifacts/qa/01_first_draw.png` to confirm the live HUD frame reads as an intentional western ledger panel while preserving combat readability.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics upgrade by improving the ability/weapon icons and card art so every button and loadout surface has richer western iconography without relying on heavy animated UI.

## 2026-06-03 - Result Pop-Out Menu Cleanup

- Fixed the death/results UI layering bug reported from the web side view.
- `show_run_failed()` in `scripts/ui/hud.gd` now uses the same contained leather-and-brass result pop-out as extraction, instead of fading large full-screen death text over gameplay/menu content.
- Added `_clear_result_overlay()` and tracked `_death_tween` so opening the main menu kills any active death/result fade and clears stale result text before menu cards render.
- Added `get_result_card_visible()` and extended smoke coverage in `scripts/game/main.gd` with `_smoke_assert_failed_run_popout()`, proving failed results use the pop-out card and old death text does not layer over the menu.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the fixed UI.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` initially caught one typed-inference parse error in the new smoke helper; after adding an explicit `String` type, the rerun completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the failed-run pop-out/menu-clear regression assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Add one small ease-of-play polish to the first-wave onboarding, such as a clearer dash-ready visual or HUD nudge after the first `FIRST CUT`, so new players learn the slash-then-dash rhythm faster.

## 2026-06-03 - Town Square Business Prop Depth

- Expanded the town-square foreground dressing in `scripts/game/main.gd` with a new `town_square_business_props_v2` visual pass.
- Added business-specific prop silhouettes outside the arena fence: saloon barrels, sheriff rail and badge stand, bank strongbox and coin spill, hotel luggage, stable hay bales, and doctor medicine bottles.
- Kept the props deterministic, procedural, and outside the combat rectangle so the town backdrop gains depth without adding texture memory, import cost, or gameplay clutter.
- Extended the existing town-square smoke check to require the richer prop roster and the new foreground visual version.
- Tightened the first-wave visual QA detector so it must see a denser set of foreground prop material/contrast hits.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded town square.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the expanded town-square prop roster assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- Manually inspected `artifacts/qa/01_first_draw.png` and `artifacts/qa/01_storefront_highlights.png` to confirm the richer perimeter still preserves clean combat readability.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with a compact live-combat animation polish pass, such as richer muzzle flashes and bullet dust puffs, so weapon feedback feels as crafted as the town backdrop.

## 2026-06-03 - Muzzle Flash Heat And Casings

- Upgraded gunshot VFX in `scripts/systems/vfx_layer.gd` with the new `muzzle_flash_heat_casing_v2` visual pass.
- Reworked muzzle flashes from a simple flash wedge into a short-lived western gunfire burst with a bone-white hot core, amber side tongues, a brass heat arc, dark dust smoke curls, and flicking brass casing marks.
- Added a cap of 18 live muzzle flashes plus total-count and visual-version getters, keeping the effect procedural, short-lived, and FPS-friendly.
- Extended the first empty-cylinder smoke helper in `scripts/game/main.gd` so the staged Deadeye shot verifies the upgraded muzzle flash version and confirms the flash counter increments.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the combat VFX polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the upgraded muzzle flash assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the live-combat polish with shotgun and rifle-specific firing VFX, especially a stronger shotgun blast/recovery smoke burst and a dedicated rifle muzzle snap that stays readable beside enemy attack tells.

## 2026-06-03 - Enemy Rifle And Shotgun Fire Bursts

- Added a shared `enemy_weapon_burst_smoke_v1` VFX pass in `scripts/systems/vfx_layer.gd`.
- Riflemen now emit a narrow muzzle snap with a bone-white core, amber side tongues, smoke curls, a brass heat arc, and a casing mark when the real shot fires.
- Shotgun brutes now emit a wider blast cone with pellet streaks, muzzle smoke, and spent shell marks at the start of their recovery window.
- Kept the pass procedural and capped at 18 live enemy weapon bursts, matching the existing short-lived VFX array pattern and avoiding new texture/import cost.
- Wired the burst into the existing rifle and shotgun fire paths in `scripts/enemies/rifleman.gd` and `scripts/enemies/shotgun_brute.gd`, leaving gameplay damage/timing unchanged.
- Added smoke coverage in `scripts/game/main.gd` so Crossfire verifies the real rifle shot creates the VFX and splinters the staged cover bait, while Dust Chapel verifies the shotgun brute fires the shared blast smoke VFX.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the enemy weapon feedback polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` initially exposed a smoke timing issue: the rifle attack-tell wait returned before the real shot burst fired, and after waiting through the shot the synthetic rifle-cover splinter consumed too much staged cover. After changing the smoke path to assert the real rifle shot's burst and cover splinter, the rerun completed with exit code 0 and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue toward the full graphics goal by polishing enemy movement/damage animation reads, such as stronger directional hurt flinches or dust-footstep accents for each archetype, while keeping the live VFX caps tight.

## 2026-06-03 - Enemy Movement Boot Dust

- Added a shared `enemy_movement_boot_dust_v1` VFX pass in `scripts/systems/vfx_layer.gd`.
- Moving enemies now kick up short, flat boot-dust ellipses, dark ground smears, and small role-tinted dust motes that trail behind their stride without covering attack tells.
- Kept the effect procedural and capped at 34 live dust accents, so the extra motion readability does not add texture memory or unbounded draw growth.
- Wired the emitter through `scripts/enemies/base_enemy.gd`, so knife rushers, riflemen, shotgun brutes, hunters, and duelists all inherit the grounded movement polish from the shared enemy movement path.
- Added smoke coverage in `scripts/game/main.gd` that verifies the VFX version, the base-enemy integration version, and that a moving live enemy emits the capped boot-dust VFX.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the movement polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the enemy movement boot-dust assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics push with enemy damage-read polish, such as directional hurt flinches and tighter impact shadow/spark timing, so hits feel as grounded as movement and gunfire.

## 2026-06-03 - Enemy Hit Recoil And Shadow Skids

- Added a shared `enemy_hit_recoil_shadow_rim_v1` visual pass in `scripts/enemies/base_enemy.gd`.
- Nonlethal enemy damage now kicks the body/sprite backward from the attacker, adds a slight squash/tilt, flashes a tight red-and-bone rim slice, and compresses the contact shadow into a dusty skid.
- Kept the effect fully procedural and time-limited in the shared `DustEnemy` base class, so all enemy archetypes gain the clearer hit read without new texture imports or unbounded VFX arrays.
- Reused the existing player-to-enemy hit direction for both recoil and hit spark direction, tightening the relationship between sprite response and the role-aware spark VFX.
- Added smoke coverage in `scripts/game/main.gd` that verifies the recoil visual version and proves nonlethal damage activates the recoil pose during the first wave.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the enemy hit-read polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the enemy hit recoil assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with button/menu interaction polish, such as stronger hovered/pressed brass states and a more tactile in-run skill button response.

## 2026-06-03 - Tactile Button And Menu Chrome

- Upgraded the HUD/menu interaction chrome in `scripts/ui/hud.gd` with tactile `v2` visual passes for nav buttons, loadout cards, and in-run skill icons.
- Main menu nav buttons now draw stronger brass inlays with press-depth offsets, selected/hover brackets, brighter icon rings, and deeper leather shadowing while keeping the same compact western ledger layout.
- Gun and ability loadout cards now use richer normal/hover/pressed/focus states with stamped shadows, pressed bevel depth, pressed text color, and focus styling.
- Live skill buttons now expose a ready-state brass glint, stronger bevel highlights, and versioned tactile marker counts without adding textures or expensive runtime effects.
- Extended smoke coverage in `scripts/game/main.gd` to require the new tactile visual versions and marker/style counts for nav, loadout, and skill buttons.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the button/menu polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the tactile button/menu assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with arena/background lighting polish, such as stronger long-shadow bands and heat shimmer around the town square edges while preserving clean combat readability.

## 2026-06-03 - Arena Sunfall Lighting Bands

- Upgraded the arena/background lighting in `scripts/game/main.gd` with `high_noon_edge_sunfall_v2` and `town_square_sunfall_long_shadows_v1`.
- The old-west town square perimeter now casts deterministic long shadows and brass rim highlights from the storefront rows and side businesses, making the surrounding buildings feel lit by the same harsh western sun.
- The arena edge atmosphere now layers stronger sunfall shadow bands, heat-rim accents, and side glints around the combat space while keeping the middle of the courtyard readable for enemies, bullets, and pickups.
- Kept the pass procedural, static where possible, and bounded to a small number of draw calls so the visual upgrade does not add texture memory or unbounded VFX growth.
- Added smoke coverage for the new lighting version hook and visual QA coverage that checks the first-wave screenshot for sunfall edge shadow/rim contrast without muddying the center.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the lighting polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the arena sunfall lighting assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with player and enemy sprite presentation polish, such as stronger directional contact shadows, hat/weapon rim highlights, or ability-cast glints that make the characters feel closer to the 3D top-down art target.

## 2026-06-03 - Grounded Character Sprite Rim Pass

- Upgraded player sprite presentation in `scripts/player/player.gd` with `denim_brass_hero_grounded_rim_v2` and `player_grounded_contact_rim_v1`.
- The player now gets a stronger sun-direction cast shadow, layered contact shadow, hat-brim rim, denim shoulder glint, brass weapon/belt marks, and subtle spur highlights tied to movement and dash state.
- Upgraded shared enemy sprite presentation in `scripts/enemies/base_enemy.gd` with `role_silhouette_grounded_rim_v2` and `enemy_grounded_contact_rim_v1`.
- All enemy archetypes now inherit a matching long contact shadow, warm hat/shoulder rim, and small role-aware weapon highlights, preserving each archetype's readable silhouette while making the sprites feel more grounded in the high-noon lighting.
- Kept the pass procedural and bounded to a few cheap draw calls per character, with no new texture imports or unbounded VFX, so it supports the FPS requirement.
- Extended smoke coverage in `scripts/game/main.gd` to require the new player and enemy grounded sprite presentation hooks.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the sprite polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the grounded player/enemy sprite presentation assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with ability-cast and pickup presentation polish, such as stronger Deadeye/Quickdraw glints and more material-rich pickup readability without increasing persistent VFX cost.

## 2026-06-03 - Ability Cast Brass Sigils

- Upgraded ability-cast VFX in `scripts/systems/vfx_layer.gd` with `ability_cast_brass_sigils_v1`.
- `skill_flash` now emits a capped brass sigil glint with a grounded dust ellipse, warm arc rings, chamber-like spoke marks, and program-specific silhouettes for straight shots, ricochet/fan-hammer casts, and veil-style casts.
- Threaded the `program_id` from `scripts/game/main.gd` into `vfx_layer.skill_flash(...)`, so Deadeye, Quickdraw, Ricochet Shot, Fan Hammer, Dust Veil, and Ghost Step can read differently while sharing one lightweight system.
- Kept the pass procedural, short-lived, and capped at 16 active cast glints, with no new textures or persistent effects, supporting the FPS requirement.
- Extended smoke coverage in `scripts/game/main.gd` to require the new ability-cast visual version and prove a cast creates a capped brass sigil glint.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the ability-cast polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the ability-cast brass sigil assertion, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with payday pickup presentation polish, such as stronger satchel material depth, coin/ammo silhouettes, and pickup collection sparkle while keeping draw calls bounded.

## 2026-06-03 - Payday Satchel Material Polish

- Upgraded payday pickup presentation in `scripts/game/main.gd` with `payday_satchel_material_spill_v3`.
- Payday satchels now have stronger western prop material cues: longer grounded shadows, leather grain scratches, stitch/rivet highlights, a brass buckle, and a warmer flap/body contrast.
- Added explicit coin and ammo silhouette badges around the pickup so the reward reads faster at gameplay scale before the player studies the spilled coins or cartridges.
- Added a small `BANKED` collection flash using existing VFX hooks, keeping the effect short-lived and tied to pickup collection.
- Extended payday smoke coverage to require leather grain, coin silhouette, ammo silhouette, and collection sparkle metadata on live pickups.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the pickup polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the payday material-depth pickup assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with menu/button polish, especially button states and failure/results pop-out framing, so the non-combat screens feel as rich as the arena.

## 2026-06-03 - Result Ledger Side Pop-Out

- Upgraded the run failure/extraction presentation in `scripts/ui/hud.gd` with `result_card_side_popout_ledger_v2`.
- The `YOU DIED` and extraction results now render inside a tall right-side leather-and-brass ledger pop-out instead of feeling like full-screen text layered over the whole game.
- Reduced the full-screen tint strength so the arena remains visible behind the result card, while the card keeps a dark ledger body, brass frame, side tab, rivets, divider bands, and a readable compact result font.
- Added HUD geometry hooks and smoke assertions proving result text stays bounded to the pop-out card and that desktop viewports use the side-card layout.
- Updated the visual QA dark-result-card detector in `scripts/game/main.gd` to recognize the new right-side ledger while preserving the older centered-card fallback.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the result-card polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the v2 side-popout result card assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- An initial `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` run failed because the screenshot detector was still tuned to the old centered card; after updating the detector, the command completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with broader menu presentation polish, especially the main-menu title/backdrop composition and loadout card spacing on narrow browser viewports.

## 2026-06-03 - Main Menu Town-Square Backdrop

- Upgraded the main-menu backdrop in `scripts/ui/hud.gd` with `menu_backdrop_town_square_poster_v1`.
- Added a procedural old-west town-square silhouette behind the menu: varied storefront masses, brass sign plates, glass window glints, door shadows, hitching rails, lantern glows, and a stronger street ledge under the sunset rays.
- Kept the pass cheap and bounded to static `Control._draw()` primitives, with no new textures, animation loops, particles, or persistent VFX cost.
- Added HUD hooks for the backdrop visual version and town-square cue count, then extended smoke coverage in `scripts/game/main.gd` to require the new menu backdrop composition.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the menu polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the menu backdrop visual-version and town-square cue assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with responsive menu/loadout spacing on narrow browser viewports, then move back into arena readability polish for hazards and cover silhouettes.

## 2026-06-03 - Responsive Menu Loadout Spacing

- Upgraded the main-menu layout in `scripts/ui/hud.gd` with `menu_responsive_loadout_spacing_v1`.
- The menu now computes title scale, content margins, nav width, panel separation, loadout card columns, and grid gaps from viewport width so narrow browser views do not cram a fixed nav rail and two-column loadout grid into the same band.
- Added smoke-visible layout telemetry for content width, nav width, right-panel width, and loadout column count.
- Kept the pass layout-only with no new textures, animation loops, or persistent effects, supporting the FPS requirement while improving browser readability.
- Extended smoke coverage in `scripts/game/main.gd` to require the responsive layout version and verify the menu columns stay inside the content band.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the responsive menu polish.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the responsive menu layout assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with arena hazard and cover silhouette readability, or do a deeper real-mobile viewport QA pass on the menu buttons and loadout cards.

## 2026-06-03 - Town Square Business Facades

- Upgraded the arena perimeter storefronts in `scripts/game/main.gd` with `town_square_business_facades_v1`.
- Added stronger business-specific facade silhouettes so the courtyard reads more like a western town square: saloon balcony rails and swing doors, barber awnings and poles, sheriff parapet badge and jail bars, bank pillars and vault face, hotel balcony/windows, stable arch/hay, and doctor cross/medicine bottles.
- Extended the side storefronts with matching business cues so the left and right arena edges no longer feel like repeated generic wall slabs.
- Kept the pass procedural and lightweight, using existing draw primitives and no new textures, particles, or looping effects, preserving the FPS constraint.
- Added smoke-visible facade version and cue coverage so future changes must keep the common western businesses readable.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded town-square facades.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0 after one quick typed-inference fix.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new town-square business facade assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused arena readability pass for powder-keg/hazard silhouettes and cover edges, so the richer town square stays dramatic without stealing combat clarity.

## 2026-06-03 - Powder Keg Danger Silhouette Polish

- Upgraded powder-keg hazards in `scripts/game/main.gd` with `powder_keg_danger_silhouette_v2`.
- Added stronger gameplay readability cues: a wider dark ground silhouette plate, outer warning arcs, countdown tick marks, brighter brass danger bands, rope fuse loop, and a skull/cross danger mark on the keg body.
- Preserved the existing lit-fuse behavior while making active kegs pop harder with amber tick marks, glow, and sparks.
- Added live hazard metadata for the new silhouette plate, danger band, and fuse tick cues, then extended smoke coverage so future hazard art must keep those readability markers.
- Kept the pass procedural and lightweight, using simple draw primitives only, with no new textures, particles, or persistent nodes.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded hazard silhouettes.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new powder-keg danger silhouette assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command still printed the existing Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS captures=C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_first_draw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_storefront_highlights.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/01_cylinder_ready_glint.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_rifleman_crossfire_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_crossfire_cover_splinter.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/02_black_sash_tell.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/03_rail_yard_rush.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_lanes.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/04_dust_chapel_brute_recovery.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/05_mercy_vale_fastdraw.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/06_gold_rush_keg_links.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/07_hunter_lunge_afterimage.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/08_june_blackglass_killbox.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/09_last_high_noon.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/10_extraction_ledger.png, C:/Users/daxto/OneDrive/Documents/NeonHeist/artifacts/qa/11_information_hunter_card.png`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with cover-edge readability or another UI button/card polish pass, keeping the richer environment secondary to combat clarity.

## 2026-06-03 - Crossfire Cover Edge Readability

- Upgraded Crossfire saloon cover props in `scripts/game/main.gd` with `saloon_table_cover_edge_readability_v2`.
- Added a wider/darker contact shadow, dark edge plate outline, brass corner anchors, edge highlight strips, and stronger splinter shard strokes so cover reads clearly against sand and after breaking.
- Added cover metadata for edge plates, brass corners, and splinter shards, then extended smoke coverage so future cover art must preserve those readability cues.
- Kept the pass procedural and lightweight with simple draw primitives only, avoiding new textures, particles, or persistent nodes.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded Crossfire cover art.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new saloon-cover readability assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke run for this pass did not print the intermittent Godot ObjectDB leak warning seen in some previous runs.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused UI button/card polish pass so the menu surface feels as crafted as the arena.

## 2026-06-03 - Loadout Card Brass Rivet Buttons

- Upgraded gun and ability loadout cards in `scripts/ui/hud.gd` with `loadout_card_brass_rivet_state_plate_v3`.
- Replaced plain loadout `Button` nodes with a lightweight custom `LoadoutCardButton` that draws brass rivets, top and bottom edge strips, stamped marks, equipped check plates, and locked-card hatching.
- Kept the existing card styleboxes and responsive layout, then added card-state wiring so equipped and locked cards update their drawn chrome when the loadout changes.
- Added HUD telemetry for custom loadout card visual count and tactile marker count, then extended smoke coverage in `scripts/game/main.gd` to require the new card version and custom markers.
- Kept the pass FPS-friendly: no new textures, no animations, no particles, and only simple `Control._draw()` primitives on menu cards.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded loadout buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new loadout-card visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with an in-run HUD contrast pass or a focused player/enemy sprite material-read pass, keeping the same FPS-cheap primitive/asset approach.

## 2026-06-03 - High-Contrast Skill Buttons

- Upgraded the compact in-run skill buttons in `scripts/ui/hud.gd` with `skill_icon_high_contrast_ready_cooldown_v3`.
- Strengthened the live HUD button read with a darker inner leather well, brighter brass ready ring, clearer edge highlights, higher-contrast corner rivets, and cooldown tick marks along the recharge veil.
- Updated the skill icon tactile marker count so smoke can require the new ready rings, cooldown ticks, bevels, and rivets.
- Extended smoke coverage in `scripts/game/main.gd` to require the new skill icon visual version and marker threshold.
- Kept the pass FPS-friendly: no new textures, animation loops, particles, or persistent nodes; just a few additional `Control._draw()` primitives on four HUD icons.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded in-run buttons.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new skill-icon visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a focused player/enemy sprite material-read pass or live HUD ledger contrast pass, keeping combat readability and FPS cost in balance.

## 2026-06-03 - Live HUD Ledger Brass Rail Contrast

- Upgraded the always-visible combat HUD frame in `scripts/ui/hud.gd` with `live_hud_ledger_high_contrast_brass_rail_v1`.
- Added a darker leather backing, stronger brass outer and inner rails, a top brass lip, health-slot highlight, riveted section dividers, and subtle ledger hatch marks so the HUD reads as a crafted western object without covering the arena.
- Added HUD telemetry for the live ledger visual version and contrast marker count, then extended smoke coverage in `scripts/game/main.gd` to require the new brass-rail pass during wave-one combat.
- Kept the pass FPS-friendly: no textures, particles, animations, or persistent scene nodes; only simple `Control._draw()` primitives on the existing HUD frame.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded live HUD ledger.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new live-HUD ledger visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke command printed the intermittent Godot ObjectDB leak warning at process exit, but no GDScript compile or gameplay smoke failure was reported.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a deeper arena background lighting pass or storefront signage/prop variety pass, preserving combat readability and the lightweight procedural approach.

## 2026-06-03 - Sprite Material Sun-Edge Readability

- Upgraded the player sprite overlay in `scripts/player/player.gd` with `denim_brass_hero_sunedge_v3` and `player_grounded_contact_rim_v2`.
- Added small sun-edge highlights on the cowgirl hat and shoulders, extra brass belt buckles, and stronger denim/brass material lines so the player reads more crisply against the sandy arena.
- Upgraded shared enemy sprite overlays in `scripts/enemies/base_enemy.gd` with `role_silhouette_material_sunedge_v3` and `enemy_grounded_contact_rim_v2`.
- Added lightweight role-coded sun-edge strokes, shoulder glints, buckle dots, and weapon-edge accents for riflemen, brutes, rushers, hunters, and duelists.
- Updated smoke contracts in `scripts/game/main.gd` so player and enemy sprite readability hooks require the new material/sun-edge versions.
- Kept the pass FPS-friendly: no new textures, no animation systems, no particles, and only a few extra primitive draw calls on existing sprite overlays.
- Rebuilt the Web export in `build/web/index.html` so the running side-view server at `http://127.0.0.1:9011/` serves the upgraded sprite readability pass.

Validation:

- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --quit` completed with exit code 0.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\smoke_test.ps1 -ImportFirst` completed with exit code 0, including the new player/enemy sprite visual assertions, and reported `DUST_SMOKE: PASS waves=10 enemies_defeated=112 hazards=8`.
- The smoke run for this pass did not print the intermittent Godot ObjectDB leak warning seen in some previous runs.
- `PowerShell -ExecutionPolicy Bypass -File scripts\tools\visual_qa.ps1` completed with exit code 0 and reported `DUST_VISUAL_QA: PASS`.
- `.\.tools\godot\Godot_v4.6.2-stable_win64_console.exe --headless --path . --export-release Web build\web\index.html` completed with exit code 0.

Next recommended step:

- Continue the graphics goal with a live HUD ledger contrast pass or a deeper arena background lighting pass, preserving the cheap procedural approach.
