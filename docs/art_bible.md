# Dust Heist Art Bible

## Purpose

This document is the visual source of truth for Dust Heist. Use it when creating, generating, reviewing, or importing any game art: characters, enemies, props, environments, UI, effects, icons, marketing images, and promotional screenshots.

The goal is a standardized visual language where every asset looks like it belongs to the same game, even when assets are created at different times.

## Core Identity

Dust Heist is a fast, lethal arena-action western heist game with stylish cowgirl grit. The world should feel dangerous, sun-baked, sharp, and dramatic: dusty courthouse yards, weathered timber, leather holsters, brass weapons, long shadows, swinging saloon doors, and compact combat spaces built for quick reads.

The target look is realistic 3D top-down western game art. Assets should feel like cohesive game-ready 3D renders with physically believable materials, consistent camera angle, grounded shadows, and strong gameplay readability.

The player should read the screen instantly. Art can be rich, but combat clarity wins over decorative detail.

## Visual Pillars

- Stylish danger: every frame should feel like a frontier robbery going sideways at high noon.
- Readable silhouettes: characters and threats must be identifiable at gameplay size.
- High contrast: warm sun, cool shadows, dark silhouettes, bright muzzle flashes, and blood marks carry gameplay emphasis.
- Controlled detail: backgrounds can be textured, but gameplay objects must stay clean.
- Cinematic lighting: hard sunlight, dust haze, rim light, and long graphic shadows define the look.
- Consistent perspective: assets must share the same camera angle, scale, and lighting logic.

## Camera And Composition

Primary gameplay camera:

- Fixed top-down or slightly angled orthographic camera.
- Use the same camera height, tilt, and apparent focal length across gameplay assets.
- Characters should be readable from above, with shoulders, head, weapons, and movement direction clearly visible.
- Avoid low side-view poses unless used for portraits, intro cards, menus, or promotional art.
- Avoid extreme perspective distortion on gameplay props.

Asset composition rules:

- Characters: centered, full body, clear weapon silhouette, transparent background for source assets.
- Props: isolated, three-quarter top-down angle, transparent background unless part of an environment tile.
- Backgrounds: built in readable zones with clear walkable space, cover, hazards, and boundary language.
- UI icons: simple, bold, readable at small sizes, using the same palette and edge treatment.

## Rendering Style

Target style:

- Realistic 3D top-down old-west game art.
- Game-ready 3D render quality, not painterly illustration or flat concept art.
- Physically believable materials: sun-bleached wood, dusty sand, leather, denim, brass, iron, gunmetal, cloth, rope, glass bottles, and blood on dirt.
- Consistent orthographic or near-orthographic top-down presentation.
- Sharp readable silhouettes with realistic contact shadows.
- Slightly exaggerated weapons and body language only when needed for gameplay clarity.
- Dust haze, heat shimmer, muzzle flash glow, and sun bloom are allowed, but gameplay assets must remain readable without heavy post-processing.

Avoid:

- 2D illustration or painterly concept art.
- Soft watercolor.
- Flat cel shading unless used for UI icons.
- Cute cartoon proportions.
- Muddy realism that hides gameplay information.
- Low-poly toy-like models.
- Cyberpunk neon, sci-fi armor, holograms, futuristic guns, and corporate tech.
- Medieval fantasy details.
- Random readable text in generated images.
- Inconsistent camera angles.
- Overly busy textures on important gameplay objects.

## Palette

Core colors:

| Role | Color | Hex |
| --- | --- | --- |
| Charcoal | Deep shadow base | `#14100D` |
| Dust tan | Main ground value | `#B9854E` |
| Sun-baked sand | Arena highlight | `#D8B06A` |
| Weathered wood | Buildings, cover, crates | `#6F4428` |
| Dark leather | Boots, belts, holsters | `#3A2118` |
| Brass gold | Revolvers, badges, UI highlights | `#C99336` |
| Denim blue | Player/cowgirl accent | `#315A7C` |
| Cactus green | Pickups, rare confirmation | `#5E7F3B` |
| Muzzle amber | Shots, heat, danger highlights | `#FFB02E` |
| Blood red | Damage, lethal hits, danger accents | `#E11D48` |
| Bone white | Tiny highlights, UI text | `#EFE2C6` |

Palette rules:

- Most of the screen should be warm earth values with strong readable shadows.
- Use denim blue to identify the player/cowgirl and brass gold for valuables, UI highlights, and weapon detail.
- Use cactus green and muzzle amber sparingly so they remain meaningful.
- Reserve red for damage, death, high danger, and blood.
- Avoid cyberpunk cyan/magenta neon palettes unless intentionally used for a rare supernatural or dreamlike effect.

## Lighting

Standard gameplay lighting:

- Warm high sun or late-afternoon western light.
- Long readable shadows from buildings, cover, hats, and characters.
- Amber muzzle flash and dust bursts for combat emphasis.
- Small bright highlights on brass, iron, glass bottles, spurs, belt buckles, and weapons.
- Realistic contact shadows under characters, weapons, props, and cover.
- Dust and ground shading should anchor objects without making the floor visually noisy.
- Shadows should be readable, not soft and muddy.

Lighting consistency checklist:

- Does the asset have the same sun direction as similar assets?
- Are highlights placed on believable metal, leather, glass, and cloth edges?
- Does the asset still read if dust haze is reduced?
- Are gameplay-critical shapes visible against sandy floors?

## Materials

Use physically based material treatments consistently:

- Dusty ground: warm tan, uneven, subtly tracked by boots and combat.
- Weathered wood: cracked, sun-bleached, rough, with strong edge shadows.
- Iron and gunmetal: dark, slightly worn, with bright edge scratches.
- Brass: warm gold highlights, used on revolvers, badges, buckles, cartridges, and vault detail.
- Leather: dark brown, worn edges, soft highlights on belts, boots, gloves, and saddlebags.
- Denim and cloth: low gloss, readable folds, faded western colors.
- Glass: bright small highlights, mostly bottles, windows, lamps, and lanterns.
- Rope and canvas: fibrous, matte, dusty.
- Blood: saturated red, dusty at the edges, readable against sand and wood.

## Character Standards

Player character:

- Sharp, agile silhouette.
- Cowgirl outlaw or frontier duelist language: hat, coat or vest, boots, holster, scarf, gloves, revolver, and saber or knife.
- Denim blue, bone white, or brass should be the primary player-read accent.
- Weapon shape must be readable at gameplay scale.

Enemies:

- Enemies should read as male human western threats: outlaws, deputies, bounty hunters, gamblers, shotgun brutes, riflemen, and rival duelists.
- Enemy designs should feel like male counterparts from the same material world as the cowgirl player: dark hats, worn denim or dark coats, brown leather belts and holsters, brass buckles, iron or brass weapons, dusty cloth, and grounded realistic proportions.
- Red, black, brass, or amber accents identify danger.
- Each archetype needs a unique silhouette:
  - Knife rusher: forward-leaning, compact blade, bandana, aggressive posture.
  - Rifleman: long rifle line, squared stance, hat brim silhouette.
  - Shotgun brute: large shoulders, heavy coat, wide weapon shape.
  - Duelist: elegant, upright, high-status silhouette with a signature revolver or saber.
  - Hunter: lean, predatory, duster coat or poncho profile.

Character asset rules:

- Always generate characters in the approved camera angle.
- Every gameplay character must have separate directional sprites for `forward`, `back`, `left`, `right`, `top_left`, `top_right`, `bottom_left`, and `bottom_right`.
- Direction names are screen-space: `forward` means facing down toward the bottom of the screen, `back` means facing up toward the top of the screen.
- Characters must switch sprites based on their current movement, aim, chase, or attack direction. Do not reuse one static sprite for all turns.
- Keep hands, weapons, and head readable.
- Avoid random extra gear that changes the archetype.
- Avoid tiny costume details that disappear in gameplay.
- Create a clean source render before making animation frames.
- Maintain consistent scale, shadow softness, and ground contact across characters.
- Male enemy sprite sources should be saved per archetype under `assets/enemies/` using names like `enemy_rifleman_male_3d_topdown_v001.png`.
- Male enemy directional sprites should be saved under `assets/enemies/turnaround/` using names like `enemy_rifleman_male_top_right_3d_topdown_v001.png`.

## Environment Standards

Primary environments:

- Sandy courthouse courtyard.
- Old bank interior.
- Saloon brawl room.
- Train platform or rail yard.
- Desert canyon ambush.
- Sheriff office and jail.
- Mine entrance or gold vault.

Environment language:

- Sandy floors with readable boundaries.
- Signs, lamps, windows, and architecture should frame gameplay, not obscure it.
- Walkable paths must be visually calmer than walls, props, and hazards.
- Cover and obstacles need consistent shape language.
- Doors, exits, vaults, hitching posts, barrels, crates, jail cells, and pickups must be immediately identifiable.
- Dust, footprints, cracks, blood, and floor detail must not hide characters, bullets, hazards, or pickups.

Environment avoid list:

- Cyberpunk streets, neon corporate vaults, holographic terminals, sci-fi rooftops, and futuristic transit platforms.
- Overly detailed floor noise that hides blood, bullets, hazards, or characters.
- Random generated signs with unreadable fake text as focal elements.

## Props And Pickups

Prop rules:

- Props use the same top-down or slightly angled orthographic perspective as gameplay.
- Props should be grouped by material and function.
- Important props need stronger rim lights than background clutter.
- Breakable or interactive props should include brass, bone white, cactus green, or amber cues.
- Props should cast believable contact shadows and sit naturally on the floor.

Pickup rules:

- Health, coins, ammo, and ability items must each have a distinct color and silhouette.
- Pickups should be brighter than floor props.
- Pickups should avoid complex detail; they need instant recognition.

## Weapons

Weapon standards:

- Blades: clean bright edge, bone-white highlight, dark leather or wood handle.
- Pistols: compact, high-contrast shape, amber muzzle flash.
- Rifles: long readable line, clear barrel direction.
- Shotguns: thick silhouette and wide muzzle flash.
- Throwables and tools: readable rope, dynamite, lantern, smoke bomb, or caltrop shapes.

Every weapon should be recognizable from its silhouette before color is considered.

## VFX

Core VFX:

- Sword slash: bright bone-white arc with a short-lived dust trail.
- Enemy hit: red impact spark plus dust burst.
- Muzzle flash: amber-white core with small smoke or heat shimmer.
- Dash: tan dust streak and quick afterimage, minimal blur, fast fade.
- Ability cast: brass flash, dust ring, or cactus-green pickup pulse.
- Blood: saturated red splatter, grounded decal, persistent enough to show combat history.

VFX rules:

- Effects must be short, readable, and tied to gameplay meaning.
- Avoid giant glow clouds that cover enemy tells.
- Keep VFX color-coded by function.
- Use animation timing consistently across similar effects.
- Realistic smoke, sparks, glass, and debris should support readability, not become simulation noise.

## UI And Typography

UI style:

- Minimal western poster and saloon-ledger interface.
- Dark leather, weathered paper, brass dividers, clear text, restrained ornament.
- Icons should be bold, simple, and high contrast.
- Avoid decorative UI frames that compete with combat.

Suggested UI color meanings:

- Denim blue: player status, selected ability, interact.
- Dark red: enemies, wave pressure, damage.
- Amber or brass: ammo, cooldown warning, heat.
- Cactus green: upgrade, pickup, confirmation.
- Red: damage, failure, lethal danger.

Typography:

- Use a readable western slab serif or condensed display face for headings.
- Use highly readable sans-serif for body and HUD numbers.
- Do not rely on tiny stylized text for critical information.

## Asset Sizes

Use high-resolution source renders or source model captures, then export optimized versions for Godot.

| Asset Type | Source Size | Game Export Target |
| --- | ---: | ---: |
| Character source render | `1024x1024` or `2048x2048` | Downscale as needed |
| Enemy source render | `1024x1024` or `2048x2048` | Downscale as needed |
| Small prop | `512x512` | `128x128` to `256x256` |
| Large prop | `1024x1024` | `256x256` to `512x512` |
| Pickup icon | `512x512` | `64x64` to `128x128` |
| UI icon | `256x256` | `32x32` to `96x96` |
| Background plate | `1920x1080` or larger | Match target view |
| Tile texture | `1024x1024` or `2048x2048` | Power-of-two texture |

Export rules:

- Keep transparent PNG source files for gameplay objects.
- Use WebP or compressed textures only after source approval.
- Store source and export files separately when possible.
- Name files by category, subject, view, and version.
- If using actual 3D models, store model sources separately from rendered sprites or textures.

Example naming:

```text
char_cowgirl_duelist_3d_topdown_v001.png
enemy_rifleman_3d_topdown_v001.png
prop_bank_vault_3d_topdown_v001.png
bg_courthouse_arena_plate_v001.png
icon_ability_deadeye_v001.png
```

## AI Image Prompt Template

Use this base style block for all AI-generated Dust Heist assets:

```text
Dust Heist game asset, realistic 3D top-down western game render, old west cowgirl action style, orthographic slightly angled top-down camera, physically based materials, dusty sand, weathered wood, leather, denim, brass, iron, warm sunlight, realistic contact shadows, sharp readable silhouette, high contrast, game-ready asset, controlled detail, no text, no watermark.
```

Gameplay character template:

```text
Dust Heist game asset, realistic 3D top-down western game render, old west cowgirl action style, orthographic slightly angled top-down camera, physically based materials, dusty sand, weathered wood, leather, denim, brass, iron, warm sunlight, realistic contact shadows, sharp readable silhouette, high contrast, game-ready asset, controlled detail, no text, no watermark.

Subject: [character or enemy archetype]
Camera: fixed orthographic slightly angled top-down gameplay view
Pose: readable combat-ready stance
Background: transparent
Important details: [weapon, role color, silhouette feature]
Style lock: consistent with Dust Heist art bible
```

Prop template:

```text
Dust Heist game asset, realistic 3D top-down western game render, old west cowgirl action style, orthographic slightly angled top-down camera, physically based materials, dusty sand, weathered wood, leather, denim, brass, iron, warm sunlight, realistic contact shadows, sharp readable silhouette, high contrast, game-ready asset, controlled detail, no text, no watermark.

Subject: [prop name]
Camera: fixed orthographic slightly angled top-down gameplay view
Background: transparent
Material: [weathered wood, leather, brass, iron, denim, glass, rope, canvas, dusty sand, etc.]
Function cue color: [denim blue, brass, cactus green, amber, red]
Style lock: consistent with Dust Heist art bible
```

Environment template:

```text
Dust Heist game environment, realistic 3D top-down western game render, old west cowgirl action style, orthographic slightly angled top-down camera, physically based materials, dusty sandy ground, weathered wood buildings, leather, brass, iron, warm sunlight, long readable shadows, readable gameplay space, clean composition, high contrast, controlled detail, no readable text, no watermark.

Location: [environment name]
Camera: fixed orthographic slightly angled top-down arena view
Gameplay needs: clear walkable floor, readable cover, visible boundaries, obstacle zones
Mood: tense frontier heist, dusty high noon, outlaw ambush
Style lock: consistent with Dust Heist art bible
```

Negative prompt block:

```text
2D illustration, painterly concept art, anime, cartoon, pixel art, flat shading, low-poly, toy-like, cyberpunk, neon city, futuristic armor, hologram, sci-fi weapon, tactical modern soldier, corporate office, inconsistent style, different camera angle, side view, first person, blurry, low resolution, muddy colors, pastel palette, fantasy medieval elements, random text, readable logo, watermark, extra limbs, distorted anatomy, distorted weapon, noisy background, overexposed glow, photorealistic real-world camera photo
```

## Reference Asset Set

Before producing many assets, create and approve this small reference set:

- Player character source.
- One rusher enemy.
- One rifleman enemy.
- One brute enemy.
- One duelist miniboss portrait or intro card.
- One small prop.
- One large interactive prop.
- One pickup icon.
- One arena background plate.
- One UI HUD mockup.
- One VFX sheet with slash, muzzle flash, dash, hit spark, and blood.

No large batch of assets should be generated until this reference set feels cohesive.

## Review Checklist

Every asset should pass these questions:

- Does it match the Dust Heist palette?
- Does it use the approved camera angle?
- Does it look like a realistic 3D top-down game render?
- Does the silhouette read at gameplay scale?
- Does the lighting direction match similar assets?
- Does it have believable material response and contact shadows?
- Does it avoid random text, logos, or unrelated genre details?
- Does it have the right detail density for its importance?
- Does the function read before the player studies it?
- Does it look good beside the approved reference assets?
- Is the transparent edge clean?
- Is the file named and stored consistently?

## Godot Import Notes

- Keep original source art outside destructive export workflows.
- Use transparent PNG for gameplay sprites during iteration.
- Use consistent pixels-per-unit or scale settings for each asset category.
- Use filtered high-resolution art for this realistic 3D style.
- If the game uses pre-rendered 3D sprites, keep all characters and props rendered from the same virtual camera setup.
- If the game uses real-time 3D assets, keep PBR materials, lighting rigs, and import scale consistent.
- Test each asset in the actual arena before final approval.
- Check readability during motion, not only in a static preview.

## Folder Suggestions

Recommended structure:

```text
assets/
  art_source/
    characters/
    enemies/
    props/
    environments/
    ui/
    vfx/
  characters/
  enemies/
  props/
  environments/
  ui/
  vfx/
docs/
  art_bible.md
```

## Neon Heist Migration Note

Earlier drafts explored a cyberpunk Neon Heist direction. This bible now favors an old western cowgirl identity with sandy arenas, outlaws, revolvers, saber combat, dust effects, and duelist cards.

If any cyberpunk elements remain, replace them with western equivalents:

| Neon Heist Element | Dust Heist Equivalent |
| --- | --- |
| Rain-slick neon arena | Sandy courthouse courtyard |
| Corporate vault | Old bank vault or mine vault |
| Security contractors | Outlaws, deputies, bounty hunters, rival duelists |
| Holographic interference | Dust veil, smoke, heat shimmer |
| Neural aim | Deadeye focus |
| Smart round | Ricochet shot |
| Reflex overdrive | Quickdraw |
| Blood on wet asphalt | Blood on sand or weathered wood |

Do not mix these identities accidentally. If a sci-fi element remains, make it a deliberate rare motif, not asset-generation drift.
