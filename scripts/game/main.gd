extends Node2D

const PlayerScene := preload("res://scripts/player/player.gd")
const KnifeRusherScene := preload("res://scripts/enemies/knife_rusher.gd")
const HunterScene := preload("res://scripts/enemies/hunter.gd")
const RiflemanScene := preload("res://scripts/enemies/rifleman.gd")
const ShotgunBruteScene := preload("res://scripts/enemies/shotgun_brute.gd")
const DuelistScene := preload("res://scripts/enemies/duelist.gd")
const DirectorScene := preload("res://scripts/game/game_director.gd")
const ProgramSystemScene := preload("res://scripts/systems/program_system.gd")
const SaveSystemScene := preload("res://scripts/systems/save_system.gd")
const VfxLayerScene := preload("res://scripts/systems/vfx_layer.gd")
const AudioDirectorScene := preload("res://scripts/systems/audio_director.gd")
const HudScene := preload("res://scripts/ui/hud.gd")
const VaultGeneratorScene := preload("res://scripts/game/vault_generator.gd")
const SAND_TEXTURE_PATH := "res://assets/environments/sand_realistic_tile.png"
const WOOD_TEXTURE_PATH := "res://assets/environments/wood_weathered_realistic_tile.png"
const PORCH_TEXTURE_PATH := "res://assets/environments/porch_planks_realistic_tile.png"
const FENCE_TEXTURE_PATH := "res://assets/environments/fence_rough_realistic_tile.png"
const MAX_LEVEL := 10
const PAYDAY_PICKUP_VISUAL_VERSION := "payday_satchel_material_spill_v3"
const PAYDAY_PICKUP_REDRAW_BUDGET_VERSION := "payday_pickup_redraw_budget_4fps_v1"
const DYNAMIC_ARENA_OVERLAY_VISUAL_VERSION := "dynamic_hazard_payday_overlay_primitive_budget_v2"
const DYNAMIC_ARENA_OVERLAY_PRIMITIVE_BUDGET_VERSION := "dynamic_overlay_hazard_payday_primitive_budget_v1"
const PERFORMANCE_SAMPLE_VERSION := "headless_runtime_fps_sampler_v1"
const PERF_TELEMETRY_VERSION := "perf_overlay_render_monitor_logging_v1"
const MEMORY_TELEMETRY_VERSION := "memory_release_leak_probe_v1"
const PERF_LOG_INTERVAL := 1.0
const SALOON_COVER_VISUAL_VERSION := "saloon_table_cover_edge_readability_v2"
const POWDER_KEG_VISUAL_VERSION := "powder_keg_danger_silhouette_v2"
const ARENA_FLOOR_VISUAL_VERSION := "courtyard_duel_worn_floor_readability_v2"
const ARENA_EDGE_DRESSING_VISUAL_VERSION := "courtyard_edge_dressing_western_square_v1"
const ARENA_EDGE_ATMOSPHERE_VISUAL_VERSION := "high_noon_edge_sunfall_v2"
const ARENA_STAGE_LIGHTING_VISUAL_VERSION := "courtyard_stage_lighting_depth_v1"
const ARENA_REDRAW_BUDGET_VISUAL_VERSION := "arena_timer_redraw_budget_4fps_v3"
const WAVE_ATMOSPHERE_REDRAW_BUDGET_VERSION := "wave_atmosphere_main_canvas_redraw_budget_4fps_v1"
const SCENIC_DENSITY_VISUAL_VERSION := "browser_scenic_density_budget_v1"
const RUNTIME_BACKDROP_PLATE_VISUAL_VERSION := "runtime_town_backdrop_plate_business_prop_strip_v2"
const STOREFRONT_HIGHLIGHT_VISUAL_VERSION := "storefront_brass_glass_highlights_v1"
const TOWN_FOREGROUND_VISUAL_VERSION := "town_square_business_props_v2"
const TOWN_SUNFALL_LIGHTING_VISUAL_VERSION := "town_square_sunfall_long_shadows_v1"
const TOWN_BUSINESS_FACADE_VISUAL_VERSION := "town_square_business_signature_silhouettes_v3"
const TOWN_ROOFLINE_SILHOUETTE_VISUAL_VERSION := "town_square_roofline_silhouette_depth_v1"
const TOWN_THRESHOLD_DEPTH_VISUAL_VERSION := "town_square_boardwalk_threshold_depth_v1"
const TOWN_STOREFRONT_PROP_STRIP_VISUAL_VERSION := "runtime_storefront_prop_strip_hitch_inventory_v1"
const LAST_HIGH_NOON_VISUAL_VERSION := "last_high_noon_sunfire_v1"
const ARENA_REDRAW_INTERVAL := 1.0 / 4.0
const DYNAMIC_ARENA_OVERLAY_REDRAW_INTERVAL := 1.0 / 3.0
const PAYDAY_PICKUP_REDRAW_INTERVAL := 1.0 / 4.0
const SCENIC_DENSITY_SCALE := 0.62
const HAZARD_WARNING_ARC_SEGMENTS := 14
const HAZARD_BARREL_ARC_SEGMENTS := 12
const PAYDAY_PULSE_ARC_SEGMENTS := 10
const PAYDAY_ROUTE_DOT_MAX := 5
const GOLD_RUSH_CHAIN_PIP_MAX := 3
const VISUAL_QA_CAPTURE_FILES: Array[String] = [
	"01_first_draw.png",
	"01_storefront_highlights.png",
	"01_runtime_backdrop_plate.png",
	"01_cylinder_ready_glint.png",
	"02_rifleman_crossfire_tell.png",
	"02_crossfire_cover_splinter.png",
	"02_black_sash_tell.png",
	"03_rail_yard_rush.png",
	"04_dust_chapel_brute_lanes.png",
	"04_dust_chapel_brute_recovery.png",
	"05_mercy_vale_fastdraw.png",
	"06_gold_rush_keg_links.png",
	"07_hunter_lunge_afterimage.png",
	"08_june_blackglass_killbox.png",
	"09_last_high_noon.png",
	"10_extraction_ledger.png",
	"11_information_hunter_card.png",
	"12_runtime_animation_showcase.png",
	"12_player_animation_strip_review.png",
	"13_enemy_animation_strip_review.png",
	"14_runtime_gait_contact_shift.png",
	"15_runtime_gait_contact_shift_late.png",
]
const ANIMATION_STRIP_QA_VERSION := "character_animation_strip_review_grid_v1"
const ANIMATION_STRIP_FRAME_COUNT := 8
const ANIMATION_STRIP_THUMB_SIZE := Vector2i(48, 64)
const ANIMATION_STRIP_PLAYER_DIRECTIONS: Array[String] = [
	"forward",
	"back",
	"left",
	"right",
	"angled",
	"forward_left",
	"forward_right",
	"back_left",
	"back_right",
	"top_left",
	"top_right",
	"bottom_left",
	"bottom_right",
]
const ANIMATION_STRIP_ENEMY_DIRECTIONS: Array[String] = [
	"forward",
	"back",
	"left",
	"right",
	"top_left",
	"top_right",
	"bottom_left",
	"bottom_right",
]
const ANIMATION_STRIP_ENEMY_SLUGS: Array[String] = [
	"enemy_knife_rusher_male",
	"enemy_rifleman_male",
	"enemy_shotgun_brute_male",
	"enemy_hunter_male",
	"enemy_duelist_male",
]

const LEVEL_ROSTER := [
	"Courthouse Ambush",
	"Saloon Crossfire",
	"Black Sash Draw",
	"Rail Yard Rush",
	"Dust Chapel Bells",
	"Mercy Vale's Ride",
	"Red Canyon Press",
	"Bank Vault Break",
	"June Blackglass",
	"Last High Noon",
]

const LEVEL_MODIFIERS := [
	{"id": "open", "notice": "OPEN COURTYARD", "hazards": 4, "heat": 0.0, "knife": 0, "rifle": 0, "brute": 0, "pressure": 0},
	{"id": "crossfire", "notice": "CROSSFIRE LANES", "hazards": 4, "heat": 0.04, "knife": 0, "rifle": 2, "brute": 0, "pressure": 0},
	{"id": "duel", "notice": "DUELIST KEG RING", "hazards": 5, "heat": 0.05, "knife": 0, "rifle": 0, "brute": 0, "pressure": 1},
	{"id": "rush", "notice": "RAIL YARD RUSH", "hazards": 5, "heat": 0.07, "knife": 4, "rifle": 0, "brute": 0, "pressure": 1},
	{"id": "bells", "notice": "DUST CHAPEL BRUTES", "hazards": 5, "heat": 0.08, "knife": 0, "rifle": 0, "brute": 2, "pressure": 1},
	{"id": "mercy", "notice": "FAST-DRAW DUEL", "hazards": 6, "heat": 0.1, "knife": 0, "rifle": 0, "brute": 0, "pressure": 2},
	{"id": "sandstorm", "notice": "SANDSTORM SIGHTLINES", "hazards": 6, "heat": 0.11, "knife": 2, "rifle": 1, "brute": 0, "hunter": 1, "pressure": 2},
	{"id": "gold_rush", "notice": "BANK VAULT POWDER", "hazards": 8, "heat": 0.12, "knife": 0, "rifle": 2, "brute": 1, "hunter": 1, "pressure": 2},
	{"id": "blackglass", "notice": "HIGH-SOCIETY KILL BOX", "hazards": 7, "heat": 0.14, "knife": 0, "rifle": 0, "brute": 0, "pressure": 3},
	{"id": "last_stand", "notice": "LAST HIGH NOON", "hazards": 8, "heat": 0.18, "knife": 3, "rifle": 2, "brute": 2, "hunter": 2, "pressure": 3},
]

const TOWN_BUSINESS_ROSTER := [
	{"id": "saloon", "name": "SALOON", "icon": "bottle", "plank": Color(0.2, 0.08, 0.035, 0.96), "trim": Color(0.76, 0.43, 0.18, 0.86), "accent": Color(0.82, 0.24, 0.08, 0.86)},
	{"id": "barber", "name": "BARBER", "icon": "barber", "plank": Color(0.25, 0.1, 0.055, 0.96), "trim": Color(0.86, 0.64, 0.36, 0.86), "accent": Color(0.72, 0.08, 0.04, 0.88)},
	{"id": "sheriff", "name": "SHERIFF", "icon": "badge", "plank": Color(0.15, 0.09, 0.052, 0.96), "trim": Color(0.78, 0.52, 0.19, 0.9), "accent": Color(0.93, 0.67, 0.24, 0.92)},
	{"id": "bank", "name": "BANK", "icon": "vault", "plank": Color(0.17, 0.11, 0.075, 0.96), "trim": Color(0.62, 0.46, 0.31, 0.88), "accent": Color(0.94, 0.75, 0.32, 0.9)},
	{"id": "general", "name": "GENERAL", "icon": "crate", "plank": Color(0.24, 0.13, 0.055, 0.96), "trim": Color(0.76, 0.47, 0.22, 0.86), "accent": Color(0.57, 0.45, 0.2, 0.9)},
	{"id": "hotel", "name": "HOTEL", "icon": "bed", "plank": Color(0.18, 0.085, 0.048, 0.96), "trim": Color(0.7, 0.39, 0.18, 0.86), "accent": Color(0.36, 0.2, 0.11, 0.92)},
	{"id": "stable", "name": "STABLE", "icon": "horseshoe", "plank": Color(0.21, 0.12, 0.052, 0.96), "trim": Color(0.68, 0.41, 0.19, 0.88), "accent": Color(0.5, 0.28, 0.13, 0.9)},
	{"id": "doctor", "name": "DOC", "icon": "cross", "plank": Color(0.18, 0.1, 0.058, 0.96), "trim": Color(0.68, 0.48, 0.28, 0.88), "accent": Color(0.34, 0.48, 0.24, 0.9)},
]

const TOWN_FOREGROUND_PROP_LAYOUT := [
	{"kind": "wanted_board", "edge": "top", "t": 0.24, "offset": -108.0, "business_index": 2},
	{"kind": "lantern_post", "edge": "top", "t": 0.42, "offset": -104.0, "business_index": 1},
	{"kind": "water_trough", "edge": "top", "t": 0.68, "offset": -102.0, "business_index": 7},
	{"kind": "hitching_post", "edge": "bottom", "t": 0.22, "offset": 112.0, "business_index": 6},
	{"kind": "supply_crates", "edge": "bottom", "t": 0.48, "offset": 118.0, "business_index": 4},
	{"kind": "barber_basin", "edge": "bottom", "t": 0.74, "offset": 110.0, "business_index": 1},
	{"kind": "lantern_post", "edge": "left", "t": 0.32, "offset": -112.0, "business_index": 0},
	{"kind": "water_trough", "edge": "right", "t": 0.36, "offset": 112.0, "business_index": 6},
	{"kind": "wanted_board", "edge": "left", "t": 0.68, "offset": -112.0, "business_index": 2},
	{"kind": "supply_crates", "edge": "right", "t": 0.7, "offset": 112.0, "business_index": 5},
	{"kind": "saloon_barrels", "edge": "top", "t": 0.12, "offset": -104.0, "business_index": 0},
	{"kind": "sheriff_rail", "edge": "top", "t": 0.82, "offset": -108.0, "business_index": 2},
	{"kind": "bank_strongbox", "edge": "bottom", "t": 0.36, "offset": 116.0, "business_index": 3},
	{"kind": "hotel_luggage", "edge": "bottom", "t": 0.62, "offset": 116.0, "business_index": 5},
	{"kind": "stable_hay", "edge": "left", "t": 0.5, "offset": -116.0, "business_index": 6},
	{"kind": "doc_medicine", "edge": "right", "t": 0.52, "offset": 116.0, "business_index": 7},
]

const DUELIST_ROSTER := [
	{
		"id": "black_sash",
		"name": "THE BLACK SASH",
		"title": "FIRST BLOOD RIVAL",
		"line": "She took our vault. Bring me her shadow.",
		"accent": Color(0.72, 0.08, 0.04),
		"health": 230.0,
		"speed": 245.0,
		"draw_duration": 0.28,
		"dash_duration": 0.18,
		"dash_speed_multiplier": 3.0,
		"cooldown": 1.05,
		"range": 560.0,
		"contact_range": 54.0,
	},
	{
		"id": "mercy_vale",
		"name": "MERCY VALE",
		"title": "SILVER SPUR GHOST",
		"line": "Mercy rides light, strikes fast, and never asks twice.",
		"accent": Color(0.95, 0.58, 0.18),
		"health": 205.0,
		"speed": 292.0,
		"draw_duration": 0.2,
		"dash_duration": 0.15,
		"dash_speed_multiplier": 3.45,
		"cooldown": 0.86,
		"range": 470.0,
		"contact_range": 50.0,
	},
	{
		"id": "colt_wren",
		"name": "COLT WREN",
		"title": "RAIL YARD ACE",
		"line": "He counts heartbeats like bullets.",
		"accent": Color(0.94, 0.82, 0.42),
		"health": 255.0,
		"speed": 228.0,
		"draw_duration": 0.36,
		"dash_duration": 0.22,
		"dash_speed_multiplier": 3.15,
		"cooldown": 1.18,
		"range": 520.0,
		"contact_range": 60.0,
	},
	{
		"id": "reverend_ash",
		"name": "REVEREND ASH",
		"title": "DUST CHAPEL JUDGE",
		"line": "Every sermon ends with a draw.",
		"accent": Color(0.58, 0.16, 0.08),
		"health": 285.0,
		"speed": 218.0,
		"draw_duration": 0.42,
		"dash_duration": 0.24,
		"dash_speed_multiplier": 2.85,
		"cooldown": 1.3,
		"range": 390.0,
		"contact_range": 66.0,
	},
	{
		"id": "june_blackglass",
		"name": "JUNE BLACKGLASS",
		"title": "HIGH NOON HEIRESS",
		"line": "She bought the town. Now she wants the legend.",
		"accent": Color(0.82, 0.16, 0.26),
		"health": 270.0,
		"speed": 262.0,
		"draw_duration": 0.24,
		"dash_duration": 0.2,
		"dash_speed_multiplier": 3.25,
		"cooldown": 0.95,
		"range": 455.0,
		"contact_range": 58.0,
	},
]

class StaticBackdropCache extends Node2D:
	var owner_main: Node2D

	func _draw() -> void:
		pass

class DynamicArenaOverlay extends Node2D:
	var owner_main

	func _draw() -> void:
		if owner_main == null or owner_main.vault_data.is_empty():
			return
		_draw_gold_rush_keg_links()
		_draw_arena_hazards()
		_draw_payday_pickups()

	func _draw_arena_hazards() -> void:
		for hazard in owner_main.arena_hazards:
			if bool(hazard.get("spent", false)):
				continue
			var origin: Vector2 = hazard["origin"]
			var fuse: float = float(hazard.get("fuse", 0.0))
			var lit := fuse > 0.0
			var pulse := 0.5 + sin(owner_main._hazard_anim_time * 12.0) * 0.5
			_draw_powder_keg_hazard(origin, lit, pulse)
			if lit:
				var warning_radius := lerpf(72.0, 122.0, 1.0 - fuse / float(hazard.get("fuse_max", 0.55)))
				draw_arc(origin, warning_radius, 0.0, TAU, owner_main._get_hazard_warning_arc_segment_count(), Color(1.0, 0.3, 0.06, lerpf(0.22, 0.72, pulse)), 5.0)
				draw_circle(origin + Vector2(23.0, -43.0), 7.0 + pulse * 4.0, Color(1.0, 0.74, 0.22, 0.86))
				draw_circle(origin + Vector2(23.0, -43.0), 3.0, Color(1.0, 0.94, 0.62, 0.95))

	func _draw_powder_keg_hazard(origin: Vector2, lit: bool, pulse: float) -> void:
		var body_color := Color(0.29, 0.105, 0.04, 0.98) if lit else Color(0.19, 0.078, 0.03, 0.97)
		var side_color := Color(0.105, 0.042, 0.018, 0.98) if lit else Color(0.075, 0.032, 0.014, 0.96)
		var band_color := Color(1.0, 0.66, 0.18, 0.94) if lit else Color(0.74, 0.43, 0.18, 0.86)
		var hot_color := Color(1.0, 0.48, 0.09, 0.28 + pulse * 0.2) if lit else Color(0.82, 0.52, 0.2, 0.16)
		_draw_flat_ellipse(origin + Vector2(8.0, 32.0), Vector2(58.0, 19.0), Color(0.018, 0.008, 0.003, 0.36), 24)
		draw_arc(origin + Vector2(0.0, 3.0), 48.0, -0.2, PI + 0.2, owner_main._get_hazard_barrel_arc_segment_count(), Color(1.0, 0.62, 0.16, 0.09 + pulse * 0.16), 4.0)
		draw_circle(origin + Vector2(0.0, 7.0), 35.0, Color(0.045, 0.02, 0.01, 0.92))
		var barrel_outline := PackedVector2Array([
			origin + Vector2(-30.0, -19.0),
			origin + Vector2(-20.0, -31.0),
			origin + Vector2(19.0, -31.0),
			origin + Vector2(31.0, -18.0),
			origin + Vector2(28.0, 24.0),
			origin + Vector2(17.0, 34.0),
			origin + Vector2(-18.0, 33.0),
			origin + Vector2(-29.0, 22.0),
		])
		draw_colored_polygon(barrel_outline, side_color)
		draw_colored_polygon(PackedVector2Array([
			origin + Vector2(-22.0, -23.0),
			origin + Vector2(-10.0, -29.0),
			origin + Vector2(12.0, -29.0),
			origin + Vector2(24.0, -21.0),
			origin + Vector2(22.0, 25.0),
			origin + Vector2(11.0, 31.0),
			origin + Vector2(-11.0, 30.0),
			origin + Vector2(-22.0, 22.0),
		]), body_color)
		for band_y in [-8.0, 12.0]:
			draw_line(origin + Vector2(-27.0, band_y), origin + Vector2(27.0, band_y - 1.0), Color(0.05, 0.022, 0.011, 0.78), 7.0)
			draw_line(origin + Vector2(-25.0, band_y - 1.0), origin + Vector2(25.0, band_y - 2.0), band_color, 3.0)
		draw_circle(origin + Vector2(20.0, -23.0), 5.0, hot_color)
		draw_line(origin + Vector2(16.0, -29.0), origin + Vector2(30.0, -45.0), Color(0.055, 0.026, 0.012, 0.82), 4.0)
		draw_line(origin + Vector2(29.0, -45.0), origin + Vector2(37.0, -51.0), Color(1.0, 0.64, 0.16, 0.24 + pulse * 0.24), 3.0)

	func _draw_gold_rush_keg_links() -> void:
		if str(owner_main._get_level_modifier(owner_main.current_wave).get("id", "")) != "gold_rush":
			return
		var pair_start := 0
		while pair_start + 1 < owner_main.arena_hazards.size():
			var first: Dictionary = owner_main.arena_hazards[pair_start]
			var second: Dictionary = owner_main.arena_hazards[pair_start + 1]
			if bool(first.get("spent", false)) and bool(second.get("spent", false)):
				pair_start += 2
				continue
			var first_origin: Vector2 = first["origin"]
			var second_origin: Vector2 = second["origin"]
			var lit := float(first.get("fuse", 0.0)) > 0.0 or float(second.get("fuse", 0.0)) > 0.0
			var pulse := 0.5 + sin(owner_main._hazard_anim_time * (8.0 if lit else 3.4) + float(pair_start)) * 0.5
			_draw_gold_rush_keg_chain_preview(first_origin, second_origin, pulse, lit)
			pair_start += 2

	func _draw_gold_rush_keg_chain_preview(first_origin: Vector2, second_origin: Vector2, pulse: float, lit: bool) -> void:
		var link := second_origin - first_origin
		var distance := link.length()
		if distance <= 1.0:
			return
		var direction := link / distance
		var side := direction.orthogonal()
		var hot := 1.0 if lit else 0.0
		var lane_width := 18.0 + hot * 12.0
		draw_line(first_origin + Vector2(7.0, 13.0), second_origin + Vector2(7.0, 13.0), Color(0.06, 0.025, 0.008, 0.32 + hot * 0.16), 18.0 + hot * 6.0)
		draw_line(first_origin + side * lane_width, second_origin + side * lane_width, Color(1.0, 0.68, 0.22, 0.22 + pulse * 0.16 + hot * 0.22), 4.0 + hot * 2.0)
		draw_line(first_origin - side * lane_width, second_origin - side * lane_width, Color(0.72, 0.42, 0.14, 0.2 + pulse * 0.12 + hot * 0.18), 4.0 + hot * 2.0)
		draw_line(first_origin, second_origin, Color(1.0, 0.9, 0.5, 0.16 + pulse * 0.12 + hot * 0.16), 3.0 + hot * 2.0)
		var pip_count: int = owner_main._get_gold_rush_chain_pip_max()
		for pip in range(pip_count):
			var travel := fposmod(owner_main._hazard_anim_time * (0.28 + hot * 0.42) + float(pip) / float(pip_count), 1.0)
			var point := first_origin.lerp(second_origin, travel)
			draw_circle(point, 4.0 + pulse * 1.8 + hot * 1.8, Color(1.0, 0.78, 0.28, 0.28 + pulse * 0.16 + hot * 0.22))

	func _draw_payday_pickups() -> void:
		for pickup in owner_main.payday_pickups:
			if bool(pickup.get("collected", false)):
				continue
			var origin: Vector2 = pickup["origin"]
			var age: float = float(pickup.get("age", 0.0))
			var pulse := 0.5 + sin(age * 6.0) * 0.5
			var center := origin + Vector2(0.0, sin(age * 4.4) * 4.0)
			_draw_flat_ellipse(center + Vector2(6.0, 25.0), Vector2(48.0, 14.0), Color(0.025, 0.012, 0.006, 0.25), 16)
			draw_circle(center, 37.0 + pulse * 5.0, Color(1.0, 0.72, 0.22, 0.13 + pulse * 0.08))
			if _is_payday_route_hint_visible(pickup):
				_draw_payday_route_hint(center, pickup, pulse)
			if _is_payday_pointer_visible(pickup):
				_draw_payday_pickup_pointer(center, pickup, pulse)
			if _is_payday_optional_label_visible(pickup):
				_draw_payday_optional_label(center, pickup, pulse)
			_draw_payday_satchel(center, pulse, int(pickup.get("ammo", 0)), int(pickup.get("credits", 0)))
			draw_arc(center, 48.0 + pulse * 6.0, 0.0, TAU, owner_main._get_payday_pulse_arc_segment_count(), Color(1.0, 0.84, 0.38, 0.28), 3.0)

	func _is_payday_pointer_visible(pickup: Dictionary) -> bool:
		return not bool(pickup.get("collected", false)) and float(pickup.get("age", 0.0)) <= float(pickup.get("pointer_life", 0.0))

	func _is_payday_route_hint_visible(pickup: Dictionary) -> bool:
		if bool(pickup.get("collected", false)) or owner_main.player == null:
			return false
		var distance: float = owner_main.player.global_position.distance_to(pickup["origin"])
		return distance >= float(pickup.get("route_min_distance", 72.0)) and float(pickup.get("age", 0.0)) <= float(pickup.get("route_life", 0.0))

	func _is_payday_optional_label_visible(pickup: Dictionary) -> bool:
		return not bool(pickup.get("collected", false)) and bool(pickup.get("first_drop", false)) and float(pickup.get("age", 0.0)) <= float(pickup.get("optional_label_life", 0.0))

	func _draw_payday_route_hint(center: Vector2, pickup: Dictionary, pulse: float) -> void:
		var age: float = float(pickup.get("age", 0.0))
		var route_life := maxf(0.01, float(pickup.get("route_life", 1.0)))
		var fade := clampf(1.0 - age / route_life, 0.0, 1.0)
		var start: Vector2 = owner_main.player.global_position
		var direction: Vector2 = start.direction_to(center)
		var distance: float = start.distance_to(center)
		if distance <= 1.0:
			return
		var side: Vector2 = direction.orthogonal()
		var dot_count: int = clampi(int(distance / 42.0), 2, owner_main._get_payday_route_dot_max())
		for step in range(dot_count):
			var t := float(step + 1) / float(dot_count + 1)
			var trail_pos: Vector2 = start.lerp(center, t) + side * sin(age * 7.2 + float(step)) * 4.0
			draw_circle(trail_pos + Vector2(3.0, 4.0), 7.0 + pulse * 1.5, Color(0.035, 0.016, 0.007, 0.24 * fade))
			draw_circle(trail_pos, 5.0 + pulse * 2.0, Color(1.0, 0.78, 0.24, (0.2 + t * 0.38) * fade))

	func _draw_payday_pickup_pointer(center: Vector2, pickup: Dictionary, pulse: float) -> void:
		var age: float = float(pickup.get("age", 0.0))
		var fade := clampf(1.0 - age / maxf(0.01, float(pickup.get("pointer_life", 1.0))), 0.0, 1.0)
		var arrow_tip := center + Vector2(0.0, -50.0 - pulse * 7.0)
		var arrow_base := center + Vector2(0.0, -78.0 - sin(age * 7.0) * 6.0)
		var arrow_color := Color(1.0, 0.8, 0.24, 0.24 + fade * 0.54)
		draw_line(arrow_base + Vector2(3.0, 4.0), arrow_tip + Vector2(3.0, 4.0), Color(0.045, 0.02, 0.008, 0.22 + fade * 0.28), 8.0)
		draw_line(arrow_base, arrow_tip, arrow_color, 6.0)
		draw_colored_polygon(PackedVector2Array([arrow_tip, arrow_tip + Vector2(-15.0, -23.0), arrow_tip + Vector2(15.0, -23.0)]), Color(1.0, 0.86, 0.32, 0.28 + fade * 0.58))

	func _draw_payday_optional_label(center: Vector2, pickup: Dictionary, pulse: float) -> void:
		var age: float = float(pickup.get("age", 0.0))
		var fade := clampf(1.0 - age / maxf(0.01, float(pickup.get("optional_label_life", 1.0))), 0.0, 1.0)
		var font := ThemeDB.fallback_font
		if font == null:
			return
		var label_rect := Rect2(center + Vector2(-86.0, 47.0 + pulse * 3.0), Vector2(172.0, 42.0))
		draw_rect(label_rect, Color(0.2, 0.09, 0.035, 0.68 * fade), true)
		draw_rect(label_rect, Color(0.98, 0.76, 0.28, 0.58 * fade), false, 2.0)
		draw_string(font, label_rect.position + Vector2(0.0, 18.0), "OPTIONAL", HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 18, Color(1.0, 0.84, 0.38, 0.9 * fade))
		draw_string(font, label_rect.position + Vector2(0.0, 36.0), "+CREDITS +ROUNDS", HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 15, Color(0.96, 0.86, 0.58, 0.82 * fade))

	func _draw_payday_satchel(center: Vector2, pulse: float, ammo_refill: int, credit_bonus: int) -> void:
		var brass := Color(1.0, 0.72, 0.24, 0.84 + pulse * 0.12)
		var bone := Color(0.96, 0.84, 0.48, 0.76)
		_draw_payday_coin_spill(center, pulse, credit_bonus, brass, bone)
		for i in range(clampi(ammo_refill + 1, 2, 4)):
			var shell_pos := center + Vector2(-20.0 + float(i) * 13.0, -30.0 - pulse * 1.5 + float(i % 2) * 3.0)
			draw_line(shell_pos, shell_pos + Vector2(0.0, 12.0), brass, 4.0)
			draw_circle(shell_pos + Vector2(0.0, 13.0), 2.7, bone)
		var body := PackedVector2Array([
			center + Vector2(-23.0, -12.0),
			center + Vector2(-16.0, -24.0),
			center + Vector2(18.0, -22.0),
			center + Vector2(25.0, -10.0),
			center + Vector2(21.0, 21.0),
			center + Vector2(-20.0, 23.0),
		])
		draw_colored_polygon(body, Color(0.36, 0.17, 0.065, 0.98))
		draw_polyline(PackedVector2Array([body[0], body[1], body[2], body[3], body[4], body[5], body[0]]), Color(0.02, 0.01, 0.006, 0.78), 5.0)
		draw_line(center + Vector2(-21.0, -6.0), center + Vector2(22.0, -8.0), brass, 3.4)
		draw_rect(Rect2(center + Vector2(-7.0, -10.0), Vector2(14.0, 10.0)), brass.darkened(0.08), false, 2.0)
		for i in range(7):
			var x := lerpf(-20.0, 20.0, float(i) / 6.0)
			draw_circle(center + Vector2(x, 20.0 + sin(float(i)) * 1.5), 1.6, brass.darkened(0.04))

	func _draw_payday_coin_spill(center: Vector2, pulse: float, credit_bonus: int, brass: Color, bone: Color) -> void:
		var coin_offsets := [Vector2(-32.0, 11.0), Vector2(-24.0, 23.0), Vector2(26.0, 18.0), Vector2(34.0, 4.0), Vector2(-7.0, 29.0)]
		var visible_coins := clampi(2 + credit_bonus / 22, 3, coin_offsets.size())
		for i in range(visible_coins):
			var coin_pos: Vector2 = center + coin_offsets[i]
			var coin_radius := 5.0 if i < 3 else 3.8
			draw_circle(coin_pos + Vector2(2.0, 2.5), coin_radius, Color(0.04, 0.018, 0.008, 0.26))
			draw_circle(coin_pos, coin_radius, brass.darkened(0.08))
			draw_circle(coin_pos + Vector2(-1.0, -1.0), coin_radius * 0.44, Color(1.0, 0.9, 0.52, 0.5 + pulse * 0.16))
			draw_line(coin_pos + Vector2(-coin_radius * 0.5, 0.0), coin_pos + Vector2(coin_radius * 0.45, -1.0), bone, 1.0)

	func _draw_flat_ellipse(center: Vector2, radius: Vector2, color: Color, segments: int = 24) -> void:
		var points := PackedVector2Array()
		for i in range(maxi(8, segments)):
			var angle := TAU * float(i) / float(maxi(8, segments))
			points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
		draw_colored_polygon(points, color)

const QUEST_DEFINITIONS := [
	{
		"id": "blood_noon",
		"name": "BLOOD NOON",
		"description": "Reach wave 6 in a single run.",
		"type": "wave",
		"target": 6,
		"reward_type": "ability",
		"reward_id": "fan_hammer",
		"reward": "Fan Hammer ability",
	},
	{
		"id": "three_black_sashes",
		"name": "THREE BLACK SASHES",
		"description": "Defeat 3 duelist bosses across runs.",
		"type": "boss",
		"target": 3,
		"reward_type": "ability",
		"reward_id": "ghost_step",
		"reward": "Ghost Step ability",
	},
	{
		"id": "graveyard_shift",
		"name": "GRAVEYARD SHIFT",
		"description": "Kill 100 enemies across runs.",
		"type": "kill",
		"target": 100,
		"reward_type": "blade",
		"reward_id": "grave_saber",
		"reward": "Grave Saber weapon",
	},
	{
		"id": "sandstorm_trial",
		"name": "SANDSTORM TRIAL",
		"description": "Reach wave 10 in a single run.",
		"type": "wave",
		"target": 10,
		"reward_type": "blade",
		"reward_id": "sandstorm_saber",
		"reward": "Sandstorm Saber weapon",
	},
	{
		"id": "red_canyon_oath",
		"name": "RED CANYON OATH",
		"description": "Defeat 8 duelist bosses across runs.",
		"type": "boss",
		"target": 8,
		"reward_type": "blade",
		"reward_id": "red_canyon_saber",
		"reward": "Red Canyon Saber weapon",
	},
	{
		"id": "last_sunrise",
		"name": "LAST SUNRISE",
		"description": "Kill 250 enemies across runs.",
		"type": "kill",
		"target": 250,
		"reward_type": "blade",
		"reward_id": "sunrise_saber",
		"reward": "Sunrise Saber weapon",
	},
	{
		"id": "iron_sights",
		"name": "IRON SIGHTS",
		"description": "Kill 40 enemies across runs.",
		"type": "kill",
		"target": 40,
		"reward_type": "gun",
		"reward_id": "long_rifle",
		"reward": "Long Rifle weapon",
	},
	{
		"id": "close_call",
		"name": "CLOSE CALL",
		"description": "Reach wave 8 in a single run.",
		"type": "wave",
		"target": 8,
		"reward_type": "gun",
		"reward_id": "sawed_off",
		"reward": "Sawed-Off weapon",
	},
	{
		"id": "fast_hands",
		"name": "FAST HANDS",
		"description": "Defeat 5 duelist bosses across runs.",
		"type": "boss",
		"target": 5,
		"reward_type": "gun",
		"reward_id": "pepperbox",
		"reward": "Pepperbox weapon",
	},
	{
		"id": "gold_rush",
		"name": "GOLD RUSH",
		"description": "Kill 400 enemies across runs.",
		"type": "kill",
		"target": 400,
		"reward_type": "gun",
		"reward_id": "golden_revolver",
		"reward": "Golden Revolver weapon",
	},
]

const UPGRADE_DEFINITIONS := [
	{"id": "iron_heart", "name": "Iron Heart", "category": "SURVIVAL", "description": "+1 max heart every run.", "cost": 2, "effect": "max_health_bonus", "value": 1.0},
	{"id": "tin_star_grit", "name": "Tin Star Grit", "category": "SURVIVAL", "description": "Start each run with a longer opening safety veil.", "cost": 1, "effect": "opening_grace_bonus", "value": 0.55},
	{"id": "spur_boots", "name": "Spur Boots", "category": "MOBILITY", "description": "Move 8% faster across the courtyard.", "cost": 2, "effect": "move_speed", "value": 1.08},
	{"id": "quick_spurs", "name": "Quick Spurs", "category": "MOBILITY", "description": "Dash cooldown recovers 12% faster.", "cost": 2, "effect": "dash_cooldown", "value": 0.88},
	{"id": "long_ride", "name": "Long Ride", "category": "MOBILITY", "description": "Dash carries 10% farther.", "cost": 2, "effect": "dash_duration", "value": 1.1},
	{"id": "honed_edge", "name": "Honed Edge", "category": "BLADE", "description": "Sword damage increases 12%.", "cost": 2, "effect": "blade_damage", "value": 1.12},
	{"id": "silver_reach", "name": "Silver Reach", "category": "BLADE", "description": "Sword reach increases 10%.", "cost": 2, "effect": "blade_range", "value": 1.1},
	{"id": "duelist_guard", "name": "Duelist Guard", "category": "BLADE", "description": "Parry timing lasts 18% longer.", "cost": 2, "effect": "parry_time", "value": 1.18},
	{"id": "brass_loads", "name": "Brass Loads", "category": "GUN", "description": "Gun ability damage increases 10%.", "cost": 2, "effect": "gun_damage", "value": 1.1},
	{"id": "fast_cylinder", "name": "Fast Cylinder", "category": "GUN", "description": "Reloads finish 15% sooner.", "cost": 2, "effect": "reload_speed", "value": 0.85},
	{"id": "deep_pockets", "name": "Deep Pockets", "category": "GUN", "description": "All guns carry +1 round.", "cost": 3, "effect": "ammo_capacity_bonus", "value": 1},
	{"id": "cool_hand", "name": "Cool Hand", "category": "ABILITY", "description": "Ability cooldowns are 10% shorter.", "cost": 3, "effect": "ability_cooldown", "value": 0.9},
	{"id": "dust_charm", "name": "Dust Charm", "category": "ABILITY", "description": "Dust Veil and Ghost Step last 20% longer.", "cost": 2, "effect": "veil_duration", "value": 1.2},
	{"id": "bounty_ledger", "name": "Bounty Ledger", "category": "REWARD", "description": "Payday satchels pay 35% more credits.", "cost": 2, "effect": "payday_credit_bonus", "value": 1.35},
	{"id": "combo_watch", "name": "Combo Watch", "category": "STYLE", "description": "Style chains last one second longer.", "cost": 2, "effect": "combo_timer_bonus", "value": 1.0},
]

var vault_data: Dictionary
var player
var director
var program_system
var save_system
var vfx_layer
var audio_director
var hud
var perf_overlay_layer: CanvasLayer
var perf_overlay_label: Label
var camera: Camera2D
var backdrop_cache := StaticBackdropCache.new()
var dynamic_arena_overlay := DynamicArenaOverlay.new()
var enemy_root := Node2D.new()
var enemies: Array[Node2D] = []
var run_complete := false
var current_wave := 0
var wave_in_progress := false
var wave_break_timer := 0.0
var opening_grace_timer := 0.0
var enemies_defeated := 0
var duelists_defeated := 0
var defeated_duelist_names: Array[String] = []
var style_score := 0
var combo_count := 0
var best_combo := 0
var combo_timer := 0.0
var highest_style_rank := "D"
var keg_chain_bonus := 0
var wave_clear_bonus_credits := 0
var menu_open := true
var unlocked_blades: Array[String] = ["saber"]
var equipped_blade := "saber"
var unlocked_guns: Array[String] = ["revolver"]
var equipped_gun := "revolver"
var sand_texture: Texture2D
var wood_texture: Texture2D
var porch_texture: Texture2D
var fence_texture: Texture2D
var arena_hazards: Array[Dictionary] = []
var arena_cover_props: Array[Dictionary] = []
var payday_pickups: Array[Dictionary] = []
var _hazard_anim_time := 0.0
var _arena_redraw_budget_timer := 0.0
var _dynamic_overlay_redraw_budget_timer := 0.0
var _payday_redraw_budget_timer := 0.0
var _impact_freeze_timer := 0.0
var _perf_overlay_enabled := false
var _perf_log_enabled := false
var _memory_log_enabled := false
var _perf_log_timer := 0.0
var _memory_log_timer := 0.0
var _perf_last_frame_usec := 0
var _perf_window_worst_frame_ms := 0.0
var _perf_arena_redraw_requests := 0
var _perf_dynamic_overlay_redraw_requests := 0
var _perf_payday_redraw_requests := 0
var _perf_hud_update_requests := 0
var _smoke_test_active := false
var _smoke_failures: Array[String] = []
var _visual_qa_paths: Array[String] = []
var _rewarded_waves: Array[int] = []
var _hunter_lunge_camera_kicks := 0
var _red_canyon_pocket_reward_count := 0
var _last_high_noon_exit_lane_reward_count := 0
var _last_high_noon_exit_lane_hold := 0.0
var _last_high_noon_exit_lane_rewarded := false
var _black_sash_lunge_release_count := 0
var _black_sash_duel_ground_reward_count := 0
var _black_sash_duel_ground_rewarded := false
var _mercy_vale_lunge_release_count := 0
var _june_blackglass_lunge_release_count := 0
var _visual_qa_staged_brute_recovery_origin := Vector2(-1.0, -1.0)
var _training_steps := {
	"move": false,
	"dash": false,
	"slash": false,
	"cast": false,
}
var _training_active := false
var _ammo_was_reloading := false
var _first_empty_reload_feedback_shown := false
var _first_empty_reload_feedback_count := 0
var _first_saber_kill_feedback_shown := false
var _first_saber_kill_feedback_count := 0
var _chain_break_feedback_count := 0
var _last_second_chain_bonus_count := 0
var _rank_up_feedback_count := 0
var _cover_splinter_total_count := 0
var _mastery_payoff_feedback_count := 0

func _ready() -> void:
	_configure_input()
	_load_environment_textures()
	RenderingServer.set_default_clear_color(Color(0.025, 0.018, 0.014, 1.0))

	save_system = SaveSystemScene.new()
	add_child(save_system)

	director = DirectorScene.new()
	add_child(director)
	director.alert_changed.connect(_on_alert_changed)
	director.lockdown_started.connect(_on_lockdown_started)

	program_system = ProgramSystemScene.new()
	add_child(program_system)
	program_system.unlock_starter_loadout()
	program_system.load_progress(save_system.data["unlocked_abilities"], save_system.data["equipped_abilities"])
	unlocked_blades = _to_string_array(save_system.data["unlocked_blades"])
	equipped_blade = str(save_system.data["equipped_blade"])
	unlocked_guns = _to_string_array(save_system.data["unlocked_guns"])
	equipped_gun = str(save_system.data["equipped_gun"])
	program_system.set_equipped_gun(equipped_gun)

	vfx_layer = VfxLayerScene.new()
	add_child(vfx_layer)

	audio_director = AudioDirectorScene.new()
	add_child(audio_director)

	backdrop_cache.owner_main = self
	backdrop_cache.z_index = -100
	add_child(backdrop_cache)

	dynamic_arena_overlay.owner_main = self
	add_child(dynamic_arena_overlay)

	hud = HudScene.new()
	add_child(hud)
	hud.play_requested.connect(_on_menu_play_requested)
	hud.ability_loadout_changed.connect(_on_ability_loadout_changed)
	hud.gun_loadout_changed.connect(_on_gun_loadout_changed)
	hud.upgrade_purchase_requested.connect(_on_upgrade_purchase_requested)
	if hud.has_method("set_main_menu_memory_log_enabled"):
		hud.set_main_menu_memory_log_enabled(_is_memory_log_requested())
	_apply_upgrade_modifiers_to_systems()
	hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
	hud.set_gun_loadout_data(unlocked_guns, equipped_gun)
	_refresh_upgrade_screen()
	_refresh_quest_screen()

	add_child(enemy_root)
	hud.show_main_menu()
	_setup_perf_telemetry()
	if _is_smoke_test_requested():
		call_deferred("_run_smoke_test")
	elif _is_animation_strip_qa_requested():
		call_deferred("_run_animation_strip_qa")
	elif _is_visual_qa_requested():
		call_deferred("_run_visual_qa")
	elif _is_menu_performance_test_requested():
		call_deferred("_run_menu_performance_test")
	elif _is_heavy_combat_performance_test_requested():
		call_deferred("_run_heavy_combat_performance_test")
	elif _is_performance_test_requested():
		call_deferred("_run_performance_test")

func _process(delta: float) -> void:
	_update_impact_freeze(delta)
	_update_perf_telemetry(delta)

func _physics_process(delta: float) -> void:
	if menu_open or run_complete:
		return

	if _arena_redraw_budget_timer > 0.0:
		_arena_redraw_budget_timer = maxf(0.0, _arena_redraw_budget_timer - delta)
	if _dynamic_overlay_redraw_budget_timer > 0.0:
		_dynamic_overlay_redraw_budget_timer = maxf(0.0, _dynamic_overlay_redraw_budget_timer - delta)
	if _payday_redraw_budget_timer > 0.0:
		_payday_redraw_budget_timer = maxf(0.0, _payday_redraw_budget_timer - delta)
	var heat: float = max(0.0, 1.0 - player.health / player.max_health)
	director.tick(delta, heat)
	_update_arena_hazards(delta)
	_update_payday_pickups(delta)
	_update_last_high_noon_exit_lane(delta)
	_update_style_timer(delta)
	_update_camera(delta)
	_update_wave(delta)
	_update_reload_ready_feedback()
	_update_training_tracker()
	var hud_wave := current_wave if wave_in_progress else mini(current_wave + 1, MAX_LEVEL)
	_perf_hud_update_requests += 1
	hud.update_run(player, director, program_system, hud_wave, _living_enemy_count(), MAX_LEVEL, _get_level_title(hud_wave), _get_level_notice(hud_wave), style_score, combo_count, _get_combo_fraction(), _get_style_rank(), program_system.get_ammo_summary(), wave_in_progress, wave_break_timer, _pending_payday_count())

func _is_smoke_test_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-smoke-test")

func _is_visual_qa_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-visual-qa")

func _is_animation_strip_qa_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-animation-strip-qa")

func _is_performance_test_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-performance-test")

func _is_menu_performance_test_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-menu-performance-test")

func _is_heavy_combat_performance_test_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-heavy-combat-performance-test")

func _is_perf_overlay_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-perf-overlay")

func _is_perf_log_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-perf-log")

func _is_memory_log_requested() -> bool:
	return _is_cmdline_flag_requested("--dust-memory-log")

func _is_cmdline_flag_requested(flag: String) -> bool:
	for arg in OS.get_cmdline_user_args():
		if arg == flag:
			return true
	return false

func _request_arena_visual_redraw(force: bool = false) -> void:
	if force or _smoke_test_active:
		_arena_redraw_budget_timer = 0.0
		_perf_arena_redraw_requests += 1
		queue_redraw()
		_request_dynamic_arena_overlay_redraw(true)
		return
	if _arena_redraw_budget_timer > 0.0:
		return
	_arena_redraw_budget_timer = ARENA_REDRAW_INTERVAL
	_perf_arena_redraw_requests += 1
	queue_redraw()

func _request_dynamic_arena_overlay_redraw(force: bool = false) -> void:
	if dynamic_arena_overlay == null:
		return
	if force or _smoke_test_active:
		_dynamic_overlay_redraw_budget_timer = 0.0
		_perf_dynamic_overlay_redraw_requests += 1
		dynamic_arena_overlay.queue_redraw()
		return
	if _dynamic_overlay_redraw_budget_timer > 0.0:
		return
	_dynamic_overlay_redraw_budget_timer = DYNAMIC_ARENA_OVERLAY_REDRAW_INTERVAL
	_perf_dynamic_overlay_redraw_requests += 1
	dynamic_arena_overlay.queue_redraw()

func _request_payday_visual_redraw(force: bool = false) -> void:
	if force or _smoke_test_active:
		_payday_redraw_budget_timer = 0.0
		_perf_payday_redraw_requests += 1
		_request_dynamic_arena_overlay_redraw(true)
		return
	if _payday_redraw_budget_timer > 0.0:
		return
	_payday_redraw_budget_timer = PAYDAY_PICKUP_REDRAW_INTERVAL
	_perf_payday_redraw_requests += 1
	_request_dynamic_arena_overlay_redraw()

func _setup_perf_telemetry() -> void:
	_perf_log_enabled = _is_perf_log_requested()
	_memory_log_enabled = _is_memory_log_requested()
	_perf_overlay_enabled = _is_perf_overlay_requested()
	perf_overlay_layer = CanvasLayer.new()
	perf_overlay_layer.layer = 120
	add_child(perf_overlay_layer)
	perf_overlay_label = Label.new()
	perf_overlay_label.position = Vector2(12.0, 12.0)
	perf_overlay_label.visible = _perf_overlay_enabled
	perf_overlay_label.add_theme_color_override("font_color", Color(0.96, 0.92, 0.76, 1.0))
	perf_overlay_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
	perf_overlay_label.add_theme_constant_override("shadow_offset_x", 2)
	perf_overlay_label.add_theme_constant_override("shadow_offset_y", 2)
	perf_overlay_layer.add_child(perf_overlay_label)
	_perf_last_frame_usec = Time.get_ticks_usec()
	_reset_perf_counters()
	if _perf_log_enabled:
		print("DUST_PERF_LOG: enabled version=%s" % PERF_TELEMETRY_VERSION)
	if _memory_log_enabled:
		print("DUST_MEMORY_LOG: enabled version=%s" % MEMORY_TELEMETRY_VERSION)
		_print_memory_snapshot("main_ready_after_menu_show")

func _set_perf_overlay_enabled(enabled: bool) -> void:
	_perf_overlay_enabled = enabled
	if perf_overlay_label != null and is_instance_valid(perf_overlay_label):
		perf_overlay_label.visible = enabled

func _update_perf_telemetry(delta: float) -> void:
	if not _perf_overlay_enabled and not _perf_log_enabled and not _memory_log_enabled:
		return
	var now_usec := Time.get_ticks_usec()
	if _perf_last_frame_usec > 0:
		var frame_ms := float(now_usec - _perf_last_frame_usec) / 1000.0
		_perf_window_worst_frame_ms = maxf(_perf_window_worst_frame_ms, frame_ms)
	_perf_last_frame_usec = now_usec
	if _perf_overlay_enabled and perf_overlay_label != null and is_instance_valid(perf_overlay_label):
		perf_overlay_label.text = _format_perf_snapshot("live")
	if _perf_log_enabled:
		_perf_log_timer += delta
		if _perf_log_timer >= PERF_LOG_INTERVAL:
			print("DUST_PERF_LOG: %s" % _format_perf_snapshot("live").replace("\n", " | "))
			_perf_log_timer = 0.0
			_reset_perf_counters()
	if _memory_log_enabled:
		_memory_log_timer += delta
		if _memory_log_timer >= PERF_LOG_INTERVAL:
			_print_memory_snapshot("live")
			_memory_log_timer = 0.0

func _reset_perf_counters() -> void:
	_perf_window_worst_frame_ms = 0.0
	_perf_arena_redraw_requests = 0
	_perf_dynamic_overlay_redraw_requests = 0
	_perf_payday_redraw_requests = 0
	_perf_hud_update_requests = 0

func _bytes_to_mb(value: float) -> float:
	return value / 1048576.0

func _format_memory_snapshot(label: String) -> String:
	var static_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.MEMORY_STATIC)))
	var static_max_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)))
	var texture_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)))
	var buffer_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_BUFFER_MEM_USED)))
	var video_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)))
	var object_count := int(Performance.get_monitor(Performance.OBJECT_COUNT))
	var resource_count := int(Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT))
	var node_count := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var orphan_node_count := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var menu_loaded := false
	if hud != null and is_instance_valid(hud) and hud.has_method("get_main_menu_loaded"):
		menu_loaded = bool(hud.get_main_menu_loaded())
	return (
		"label=%s version=%s menu_loaded=%s objects=%d resources=%d nodes=%d orphan_nodes=%d "
		+ "static_mb=%.1f static_max_mb=%.1f texture_mb=%.1f buffer_mb=%.1f video_mb=%.1f enemies=%d pickups=%d vfx=%d"
	) % [
		label,
		MEMORY_TELEMETRY_VERSION,
		str(menu_loaded),
		object_count,
		resource_count,
		node_count,
		orphan_node_count,
		static_mb,
		static_max_mb,
		texture_mb,
		buffer_mb,
		video_mb,
		_living_enemy_count(),
		payday_pickups.size(),
		_get_active_vfx_count(),
	]

func _print_memory_snapshot(label: String) -> void:
	if not _memory_log_enabled:
		return
	print("DUST_MEMORY_LOG: %s" % _format_memory_snapshot(label))

func _get_active_vfx_count() -> int:
	if vfx_layer != null and is_instance_valid(vfx_layer) and vfx_layer.has_method("get_active_effect_count"):
		return int(vfx_layer.get_active_effect_count())
	return 0

func _format_perf_snapshot(scenario: String, sample_data: Dictionary = {}) -> String:
	var fps := float(Performance.get_monitor(Performance.TIME_FPS))
	var process_ms := float(Performance.get_monitor(Performance.TIME_PROCESS)) * 1000.0
	var physics_ms := float(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0
	var draw_calls := int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	var render_objects := int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
	var primitives := int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	var texture_mb := float(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)) / 1048576.0
	var video_mb := float(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)) / 1048576.0
	var vfx_count := _get_active_vfx_count()
	var avg_fps := float(sample_data.get("avg_fps", fps))
	var min_fps := float(sample_data.get("min_fps", fps))
	var worst_ms := float(sample_data.get("worst_frame_ms", _perf_window_worst_frame_ms))
	return (
		"scenario=%s version=%s\nfps=%.1f avg=%.1f min=%.1f worst_ms=%.1f process_ms=%.2f physics_ms=%.2f\n"
		+ "draw_calls=%d objects=%d primitives=%d texture_mb=%.1f video_mb=%.1f\n"
		+ "enemies=%d vfx=%d arena_redraws=%d overlay_redraws=%d payday_redraws=%d hud_updates=%d"
	) % [
		scenario,
		PERF_TELEMETRY_VERSION,
		fps,
		avg_fps,
		min_fps,
		worst_ms,
		process_ms,
		physics_ms,
		draw_calls,
		render_objects,
		primitives,
		texture_mb,
		video_mb,
		_living_enemy_count(),
		vfx_count,
		_perf_arena_redraw_requests,
		_perf_dynamic_overlay_redraw_requests,
		_perf_payday_redraw_requests,
		_perf_hud_update_requests,
	]

func _sample_perf_window(scenario: String, warmup_frames: int = 20, sample_frames: int = 180) -> Dictionary:
	_reset_perf_counters()
	_print_memory_snapshot("%s_sample_before_warmup" % scenario)
	await _smoke_wait_frames(warmup_frames)
	_print_memory_snapshot("%s_sample_after_warmup" % scenario)
	var samples := 0
	var fps_sum := 0.0
	var min_fps := INF
	var worst_frame_ms := 0.0
	var sample_start_usec := Time.get_ticks_usec()
	for frame_index in range(sample_frames):
		var frame_start_usec := Time.get_ticks_usec()
		await get_tree().process_frame
		var frame_ms := float(Time.get_ticks_usec() - frame_start_usec) / 1000.0
		worst_frame_ms = maxf(worst_frame_ms, frame_ms)
		var fps := 1000.0 / maxf(0.001, frame_ms)
		if fps > 0.0:
			min_fps = minf(min_fps, fps)
			fps_sum += fps
			samples += 1
	var elapsed_ms := float(Time.get_ticks_usec() - sample_start_usec) / 1000.0
	if samples == 0:
		min_fps = 0.0
	var result := {
		"samples": samples,
		"avg_fps": fps_sum / maxf(1.0, float(samples)),
		"min_fps": min_fps,
		"worst_frame_ms": worst_frame_ms,
		"elapsed_ms": elapsed_ms,
	}
	print("DUST_PERF_DETAIL: %s" % _format_perf_snapshot(scenario, result).replace("\n", " | "))
	_print_memory_snapshot("%s_sample_after" % scenario)
	return result

func _run_animation_strip_qa() -> void:
	_smoke_test_active = true
	_smoke_failures.clear()
	_prepare_visual_qa_output_dir()
	var player_paths := _get_player_animation_strip_paths()
	var enemy_paths := _get_enemy_animation_strip_paths()
	_smoke_assert(player_paths.size() == 26, "animation strip QA should review 26 player gait and saber strips")
	_smoke_assert(enemy_paths.size() == 80, "animation strip QA should review 80 enemy gait and weapon strips")
	var player_output := _write_animation_strip_review_image(
		"12_player_animation_strip_review.png",
		player_paths,
		Color(0.16, 0.34, 0.48, 1.0)
	)
	var enemy_output := _write_animation_strip_review_image(
		"13_enemy_animation_strip_review.png",
		enemy_paths,
		Color(0.78, 0.2, 0.11, 1.0)
	)
	if _smoke_failures.is_empty():
		print("DUST_ANIMATION_STRIP_QA: PASS version=%s player_strips=%d enemy_strips=%d frame_count=%d outputs=%s,%s" % [
			ANIMATION_STRIP_QA_VERSION,
			player_paths.size(),
			enemy_paths.size(),
			ANIMATION_STRIP_FRAME_COUNT,
			player_output,
			enemy_output,
		])
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_ANIMATION_STRIP_QA: %s" % failure)
		get_tree().quit(1)

func _get_player_animation_strip_paths() -> Array[String]:
	var paths: Array[String] = []
	for direction in ANIMATION_STRIP_PLAYER_DIRECTIONS:
		paths.append("res://assets/characters/player_animation/player_cowgirl_%s_gait_strip_v001.png" % direction)
		paths.append("res://assets/characters/player_animation/player_cowgirl_%s_saber_strip_v001.png" % direction)
	return paths

func _get_enemy_animation_strip_paths() -> Array[String]:
	var paths: Array[String] = []
	for slug in ANIMATION_STRIP_ENEMY_SLUGS:
		for direction in ANIMATION_STRIP_ENEMY_DIRECTIONS:
			paths.append("res://assets/enemies/animation/%s_%s_gait_strip_v001.png" % [slug, direction])
			paths.append("res://assets/enemies/animation/%s_%s_weapon_strip_v001.png" % [slug, direction])
	return paths

func _write_animation_strip_review_image(file_name: String, strip_paths: Array[String], marker_color: Color) -> String:
	var margin := 8
	var row_gap := 4
	var marker_width := 6
	var row_height := ANIMATION_STRIP_THUMB_SIZE.y
	var canvas_width := margin * 2 + marker_width + 4 + ANIMATION_STRIP_FRAME_COUNT * ANIMATION_STRIP_THUMB_SIZE.x
	var canvas_height := margin * 2 + strip_paths.size() * row_height + maxi(0, strip_paths.size() - 1) * row_gap
	var canvas := Image.create(canvas_width, canvas_height, false, Image.FORMAT_RGBA8)
	canvas.fill(Color(0.055, 0.04, 0.03, 1.0))
	var loaded_strips := 0
	var detailed_strips := 0
	var moving_strips := 0
	var missing_detail_paths: Array[String] = []
	var missing_motion_paths: Array[String] = []
	for row_index in range(strip_paths.size()):
		var strip_path := strip_paths[row_index]
		var source := Image.load_from_file(ProjectSettings.globalize_path(strip_path))
		if source == null or source.is_empty():
			_smoke_assert(false, "animation strip QA should load %s" % strip_path)
			continue
		if source.get_width() < ANIMATION_STRIP_FRAME_COUNT or source.get_width() % ANIMATION_STRIP_FRAME_COUNT != 0:
			_smoke_assert(false, "animation strip QA strip %s should divide into eight frames" % strip_path)
			continue
		if _animation_strip_has_limb_weapon_detail(source):
			detailed_strips += 1
		else:
			missing_detail_paths.append(strip_path)
		if _animation_strip_has_frame_motion(source):
			moving_strips += 1
		else:
			missing_motion_paths.append(strip_path)
		var frame_width := source.get_width() / ANIMATION_STRIP_FRAME_COUNT
		var frame_height := source.get_height()
		var row_y := margin + row_index * (row_height + row_gap)
		_draw_animation_strip_row_marker(canvas, margin, row_y, marker_width, row_height, marker_color)
		for frame_index in range(ANIMATION_STRIP_FRAME_COUNT):
			var frame := Image.create(frame_width, frame_height, false, Image.FORMAT_RGBA8)
			frame.blit_rect(source, Rect2i(frame_index * frame_width, 0, frame_width, frame_height), Vector2i.ZERO)
			frame.resize(ANIMATION_STRIP_THUMB_SIZE.x, ANIMATION_STRIP_THUMB_SIZE.y, Image.INTERPOLATE_LANCZOS)
			var frame_x := margin + marker_width + 4 + frame_index * ANIMATION_STRIP_THUMB_SIZE.x
			canvas.blit_rect(frame, Rect2i(Vector2i.ZERO, ANIMATION_STRIP_THUMB_SIZE), Vector2i(frame_x, row_y))
		loaded_strips += 1
	var dir_path := ProjectSettings.globalize_path("res://artifacts/qa")
	var output_path := dir_path.path_join(file_name)
	var save_error := canvas.save_png(output_path)
	_smoke_assert(save_error == OK, "animation strip QA should save %s" % file_name)
	_smoke_assert(loaded_strips == strip_paths.size(), "animation strip QA should place every requested strip into %s" % file_name)
	_smoke_assert(detailed_strips == strip_paths.size(), "animation strip QA should find limb, boot, hand, and weapon detail in every strip for %s (%d/%d detailed; missing=%s)" % [file_name, detailed_strips, strip_paths.size(), ", ".join(missing_detail_paths)])
	_smoke_assert(moving_strips == strip_paths.size(), "animation strip QA should find visible frame-to-frame motion in every strip for %s (%d/%d moving; missing=%s)" % [file_name, moving_strips, strip_paths.size(), ", ".join(missing_motion_paths)])
	_smoke_assert(_animation_strip_review_has_content(canvas), "animation strip QA review %s should show visible sprite frames" % file_name)
	return output_path

func _draw_animation_strip_row_marker(canvas: Image, start_x: int, start_y: int, width: int, height: int, color: Color) -> void:
	for y in range(start_y, start_y + height):
		for x in range(start_x, start_x + width):
			canvas.set_pixel(x, y, color)

func _animation_strip_review_has_content(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var non_background_hits := 0
	var alpha_hits := 0
	var step_x := maxi(1, width / 96)
	var step_y := maxi(1, height / 96)
	for y in range(0, height, step_y):
		for x in range(0, width, step_x):
			var color := image.get_pixel(x, y)
			if color.a > 0.05:
				alpha_hits += 1
			if color.a > 0.05 and (color.r > 0.12 or color.g > 0.1 or color.b > 0.08):
				non_background_hits += 1
	return alpha_hits > 64 and non_background_hits > 16

func _animation_strip_has_limb_weapon_detail(strip: Image) -> bool:
	var width := strip.get_width()
	var height := strip.get_height()
	if width <= 0 or height <= 0:
		return false
	var skin_hits := 0
	var metal_hits := 0
	var dark_hits := 0
	var clothing_hits := 0
	var step_x := maxi(1, width / 160)
	var step_y := maxi(1, height / 48)
	for y in range(0, height, step_y):
		for x in range(0, width, step_x):
			var color := strip.get_pixel(x, y)
			if color.a <= 0.08:
				continue
			if color.r > 0.5 and color.g > 0.33 and color.b > 0.17 and color.r > color.b + 0.12:
				skin_hits += 1
			if color.r > 0.48 and color.g > 0.26 and color.b < 0.24 and color.r > color.b + 0.22:
				metal_hits += 1
			if _visual_qa_luminance(color) < 0.15:
				dark_hits += 1
			if (
				(color.b > color.r + 0.02 and color.r < 0.42 and color.g < 0.52)
				or (color.r > 0.36 and color.g < 0.34 and color.b < 0.28 and color.r > color.g + 0.06)
				or (color.r > 0.24 and color.g > 0.14 and color.b < 0.18 and color.r > color.b + 0.08)
			):
				clothing_hits += 1
	return skin_hits >= 2 and metal_hits >= 2 and dark_hits >= 8 and clothing_hits >= 10

func _animation_strip_has_frame_motion(strip: Image) -> bool:
	var width := strip.get_width()
	var height := strip.get_height()
	if width <= 0 or height <= 0 or width % ANIMATION_STRIP_FRAME_COUNT != 0:
		return false
	var frame_width := width / ANIMATION_STRIP_FRAME_COUNT
	var step_x := maxi(1, frame_width / 40)
	var step_y := maxi(1, height / 48)
	var moving_pairs := 0
	for frame_index in range(ANIMATION_STRIP_FRAME_COUNT - 1):
		var samples := 0
		var total_delta := 0.0
		var strong_delta_hits := 0
		for y in range(0, height, step_y):
			for local_x in range(0, frame_width, step_x):
				var a := strip.get_pixel(frame_index * frame_width + local_x, y)
				var b := strip.get_pixel((frame_index + 1) * frame_width + local_x, y)
				if a.a <= 0.04 and b.a <= 0.04:
					continue
				var delta := absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b) + absf(a.a - b.a)
				total_delta += delta
				if delta > 0.08:
					strong_delta_hits += 1
				samples += 1
		if samples <= 0:
			continue
		var average_delta := total_delta / float(samples)
		if average_delta > 0.012 and strong_delta_hits >= 12:
			moving_pairs += 1
	return moving_pairs >= 3

func _run_visual_qa() -> void:
	_smoke_test_active = true
	_smoke_failures.clear()
	_visual_qa_paths.clear()
	_prepare_visual_qa_output_dir()
	print("DUST_VISUAL_QA: starting first-wave, reload-ready glint, runtime animation showcase, runtime gait contact pair, rifleman crossfire, duelist tell, Rail Yard, Dust Chapel brute tells, Mercy Vale, Gold Rush, Hunter lunge, June Blackglass, finale, extraction, and information menu screenshot pass")
	menu_open = false
	hud.hide_main_menu()
	_start_run()
	opening_grace_timer = 3.2
	wave_break_timer = 0.0
	await _smoke_start_wave(1)
	await _smoke_wait_frames(5)
	_smoke_assert(_living_enemy_count() == 4, "visual QA first wave should keep four opening rushers")
	_smoke_assert_first_wave_hud()
	_smoke_assert_first_rusher_warning_tell()
	await _visual_qa_capture("01_first_draw.png")
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		var arena: Rect2 = vault_data["arena"]
		player.global_position = Vector2(arena.get_center().x, arena.position.y + 82.0)
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("01_storefront_highlights.png")
	_smoke_test_active = false
	_request_arena_visual_redraw(true)
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("01_runtime_backdrop_plate.png")
	_smoke_test_active = true
	_request_arena_visual_redraw(true)

	_smoke_clear_wave()
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()
	var reload_glints_before := -1
	if vfx_layer != null and vfx_layer.has_method("get_reload_ready_glint_total_count"):
		reload_glints_before = int(vfx_layer.get_reload_ready_glint_total_count())
	_show_reload_ready_feedback()
	_smoke_assert(reload_glints_before < 0 or int(vfx_layer.get_reload_ready_glint_total_count()) > reload_glints_before, "visual QA reload-ready staging should fire the cylinder-ready glint")
	await _smoke_wait_frames(2)
	await _visual_qa_capture("01_cylinder_ready_glint.png")

	_smoke_clear_wave()
	_smoke_assert(_visual_qa_stage_runtime_animation_showcase(), "visual QA should stage a runtime player and enemy animation showcase")
	hud.hide_transient_overlays()
	var hud_was_visible: bool = hud.visible
	hud.visible = false
	await get_tree().process_frame
	await _visual_qa_capture("12_runtime_animation_showcase.png")
	hud.visible = hud_was_visible
	_smoke_clear_wave()
	_smoke_assert(_visual_qa_stage_runtime_animation_showcase(false), "visual QA should stage a runtime carried-weapon gait contact showcase")
	hud.hide_transient_overlays()
	hud_was_visible = hud.visible
	hud.visible = false
	await _smoke_wait_frames(10)
	await _visual_qa_capture("14_runtime_gait_contact_shift.png")
	await _smoke_wait_frames(10)
	await _visual_qa_capture("15_runtime_gait_contact_shift_late.png")
	_smoke_assert(_visual_qa_runtime_gait_contact_pair_has_motion_delta(), "visual QA gait contact pair should show visible runtime movement between carried-weapon frames")
	hud.visible = hud_was_visible

	await _smoke_start_wave(2)
	_smoke_assert_wave_basics(2)
	_smoke_assert(_smoke_stage_enemy_kind_near_player("rifleman", Vector2(320.0, 0.0)), "visual QA wave 2 should stage a rifleman for crossfire tell capture")
	_smoke_assert(_smoke_stage_crossfire_rifle_bait_line(), "visual QA wave 2 should align a rifle tell through saloon cover")
	var visual_rifle_puffs_before := _smoke_get_rifle_warning_puff_total_count()
	_smoke_assert(await _smoke_wait_for_enemy_attack_tell("rifleman", 45), "visual QA wave 2 should reach the rifleman crossfire shot tell")
	_smoke_assert_rifleman_shot_tell_visual_contract()
	_smoke_assert_crossfire_cover_bait_glint()
	_smoke_assert(_smoke_get_rifle_warning_puff_total_count() > visual_rifle_puffs_before or _smoke_get_rifle_warning_puff_count() > 0, "visual QA wave 2 rifleman tell should emit a muzzle dust bracket")
	await _smoke_wait_frames(3)
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("02_rifleman_crossfire_tell.png")
	_smoke_assert_crossfire_cover_splinter()
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("02_crossfire_cover_splinter.png")

	await _smoke_start_wave(3)
	_smoke_assert_wave_basics(3)
	_smoke_assert(_smoke_has_boss_named("THE BLACK SASH"), "visual QA wave 3 should spawn The Black Sash")
	_smoke_assert(_smoke_has_black_sash_signature_mark(), "visual QA wave 3 should stage the Black Sash arena-floor signature mark")
	_smoke_assert(_smoke_stage_duelist_release_tell("black_sash", Vector2(-260.0, -90.0)), "visual QA wave 3 should stage the Black Sash lunge tell")
	_smoke_assert(_smoke_has_enemy_attack_tell("duelist"), "visual QA wave 3 should reach the Black Sash lunge tell")
	_smoke_assert(await _smoke_wait_for_enemy_method_true("duelist", "has_pre_dash_boot_dust_tell", 2), "visual QA wave 3 should show the duelist pre-dash boot dust cue")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("02_black_sash_tell.png")

	await _smoke_start_wave(4)
	_smoke_assert_wave_basics(4)
	_smoke_assert_level_identity(4, {"title": "Rail Yard Rush", "modifier": "rush", "hazards": 5, "animated": true})
	var rail_anim_time := _hazard_anim_time
	await _smoke_wait_frames(8)
	_smoke_assert(_hazard_anim_time > rail_anim_time, "visual QA wave 4 should animate Rail Yard Rush effects")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("03_rail_yard_rush.png")

	await _smoke_start_wave(5)
	_smoke_assert_wave_basics(5)
	_smoke_assert_level_identity(5, {"title": "Dust Chapel Bells", "modifier": "bells", "hazards": 5, "animated": true})
	var chapel_anim_time := _hazard_anim_time
	await _smoke_wait_frames(8)
	_smoke_assert(_hazard_anim_time > chapel_anim_time, "visual QA wave 5 should animate Dust Chapel brute lane cues")
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()
	_smoke_assert(_smoke_stage_enemy_kind_near_player("shotgun_brute", Vector2(230.0, 0.0)), "visual QA wave 5 should stage a shotgun brute for wide-blast tell capture")
	_smoke_assert(await _smoke_wait_for_enemy_attack_tell("shotgun_brute", 45), "visual QA wave 5 should reach the shotgun brute wide-blast tell")
	await _smoke_wait_frames(3)
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("04_dust_chapel_brute_lanes.png")
	if player != null and is_instance_valid(player):
		player.global_position += Vector2(-300.0, -180.0)
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()
	_smoke_assert(_smoke_stage_shotgun_brute_recovery_tell(Vector2(250.0, -20.0)), "visual QA wave 5 should stage the shotgun brute post-shot recovery tell")
	_smoke_assert(await _smoke_wait_for_enemy_method_true("shotgun_brute", "has_recover_tell", 2), "visual QA wave 5 should reach the shotgun brute post-shot recovery tell")
	_visual_qa_staged_brute_recovery_origin = _smoke_get_enemy_kind_method_origin("shotgun_brute", "has_recover_tell")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("04_dust_chapel_brute_recovery.png")
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()

	await _smoke_start_wave(6)
	_smoke_assert_wave_basics(6)
	_smoke_assert_level_identity(6, {"title": "Mercy Vale's Ride", "modifier": "mercy", "hazards": 6, "animated": true, "boss": true, "boss_name": "MERCY VALE"})
	var mercy_anim_time := _hazard_anim_time
	_smoke_assert(_smoke_stage_duelist_release_tell("mercy_vale", Vector2(-270.0, -60.0)), "visual QA wave 6 should stage Mercy Vale's fast-draw tell")
	_smoke_assert(_smoke_has_enemy_attack_tell("duelist"), "visual QA wave 6 should reach Mercy Vale's fast-draw tell")
	await _smoke_wait_frames(1)
	_smoke_assert(_hazard_anim_time > mercy_anim_time, "visual QA wave 6 should animate Mercy Vale fast-draw effects")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("05_mercy_vale_fastdraw.png")

	await _smoke_start_wave(8)
	_smoke_assert_wave_basics(8)
	_smoke_assert_level_identity(8, {"title": "Bank Vault Break", "modifier": "gold_rush", "hazards": 8, "animated": true})
	var gold_anim_time := _hazard_anim_time
	await _smoke_wait_frames(8)
	_smoke_assert(_hazard_anim_time > gold_anim_time, "visual QA wave 8 should animate Gold Rush keg links")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("06_gold_rush_keg_links.png")

	await _smoke_start_wave(7)
	_smoke_assert_wave_basics(7)
	_smoke_assert_level_identity(7, {"title": "Red Canyon Press", "modifier": "sandstorm", "hazards": 6, "animated": true, "hunter": 1})
	_smoke_assert(_smoke_stage_enemy_kind_near_player("hunter", Vector2(220.0, 0.0)), "visual QA wave 7 should stage a Hunter for lunge capture")
	_smoke_assert(_smoke_stage_hunter_lunge_afterimage(Vector2(220.0, 0.0)), "visual QA wave 7 should stage the Hunter lunge afterimage")
	_smoke_assert(await _smoke_wait_for_enemy_method_true("hunter", "has_lunge_afterimage", 2), "visual QA wave 7 should reach the Hunter lunge afterimage")
	await _smoke_wait_frames(1)
	_visual_qa_clear_staged_result_overlay()
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("07_hunter_lunge_afterimage.png")

	await _smoke_start_wave(9)
	_smoke_assert_wave_basics(9)
	_smoke_assert_level_identity(9, {"title": "June Blackglass", "modifier": "blackglass", "hazards": 7, "animated": true, "boss": true, "boss_name": "JUNE BLACKGLASS"})
	var blackglass_anim_time := _hazard_anim_time
	_smoke_assert(_smoke_stage_duelist_release_tell("june_blackglass", Vector2(-250.0, -40.0)), "visual QA wave 9 should stage June Blackglass's kill-box tell")
	_smoke_assert(_smoke_has_enemy_attack_tell("duelist"), "visual QA wave 9 should reach June Blackglass's kill-box tell")
	_smoke_assert(await _smoke_wait_for_enemy_method_true("duelist", "has_blackglass_killbox_windup_tell", 2), "visual QA wave 9 should show June Blackglass's close kill-box wind-up brackets")
	await _smoke_wait_frames(1)
	_smoke_assert(_hazard_anim_time > blackglass_anim_time, "visual QA wave 9 should animate June Blackglass kill-box effects")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("08_june_blackglass_killbox.png")

	await _smoke_start_wave(10)
	_smoke_assert_wave_basics(10)
	_smoke_assert_level_identity(10, {"title": "Last High Noon", "modifier": "last_stand", "hazards": 8, "animated": true})
	var finale_anim_time := _hazard_anim_time
	await _smoke_wait_frames(8)
	_smoke_assert_finale_objective_tracker()
	_smoke_assert(_hazard_anim_time > finale_anim_time, "visual QA wave 10 should animate Last High Noon effects")
	hud.hide_transient_overlays()
	await get_tree().process_frame
	await _visual_qa_capture("09_last_high_noon.png")

	await _smoke_run_to_extraction()
	await _smoke_wait_frames(3)
	_smoke_assert_result_ledger()
	hud.hide_transient_overlays()
	await _visual_qa_capture("10_extraction_ledger.png")

	_smoke_assert_information_primer()
	hud.show_information_menu_for_qa()
	if hud.has_method("get_main_menu_selected_nav_count"):
		_smoke_assert(int(hud.get_main_menu_selected_nav_count()) == 1, "information menu QA should show exactly one active brass-inlay nav button")
	await get_tree().process_frame
	await get_tree().process_frame
	hud.scroll_information_menu_to_late_cards_for_qa()
	await get_tree().process_frame
	await get_tree().process_frame
	await _visual_qa_capture("11_information_hunter_card.png")

	Engine.time_scale = 1.0
	if _smoke_failures.is_empty():
		print("DUST_VISUAL_QA: PASS captures=%s" % ", ".join(_visual_qa_paths))
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_VISUAL_QA: %s" % failure)
		get_tree().quit(1)

func _run_performance_test() -> void:
	_smoke_test_active = false
	_smoke_failures.clear()
	print("DUST_PERF: starting %s" % PERFORMANCE_SAMPLE_VERSION)
	menu_open = false
	hud.hide_main_menu()
	_start_run()
	opening_grace_timer = 12.0
	wave_break_timer = 0.0
	await _smoke_start_wave(8)
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		player.health = player.max_health
		player.apply_dust_veil(12.0)
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy is Node2D:
			(enemy as Node2D).global_position += Vector2(420.0, 220.0)
	_request_arena_visual_redraw(true)
	_request_dynamic_arena_overlay_redraw(true)
	var perf_result: Dictionary = await _sample_perf_window("wave_8_combat", 20, 160)
	var samples := int(perf_result["samples"])
	var avg_fps := float(perf_result["avg_fps"])
	var min_fps := float(perf_result["min_fps"])
	var worst_frame_ms := float(perf_result["worst_frame_ms"])
	var elapsed_ms := float(perf_result["elapsed_ms"])
	_smoke_assert(_get_performance_sample_version() == PERFORMANCE_SAMPLE_VERSION, "performance sampler should expose its version for progress tracking")
	_smoke_assert(avg_fps >= 45.0, "performance sample average FPS should stay at or above 45, got %.1f" % avg_fps)
	_smoke_assert(min_fps >= 30.0, "performance sample minimum FPS should stay at or above 30, got %.1f" % min_fps)
	_smoke_assert(worst_frame_ms <= 80.0, "performance sample worst frame wait should stay below 80ms, got %.1fms" % worst_frame_ms)
	if _smoke_failures.is_empty():
		print("DUST_PERF: PASS version=%s samples=%d avg_fps=%.1f min_fps=%.1f worst_frame_ms=%.1f elapsed_ms=%.1f arena_interval=%.3f overlay_interval=%.3f" % [
			PERFORMANCE_SAMPLE_VERSION,
			samples,
			avg_fps,
			min_fps,
			worst_frame_ms,
			elapsed_ms,
			ARENA_REDRAW_INTERVAL,
			DYNAMIC_ARENA_OVERLAY_REDRAW_INTERVAL,
		])
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_PERF: %s" % failure)
		get_tree().quit(1)

func _run_menu_performance_test() -> void:
	_smoke_test_active = false
	_smoke_failures.clear()
	print("DUST_MENU_PERF: starting %s" % PERF_TELEMETRY_VERSION)
	menu_open = true
	if hud != null and is_instance_valid(hud):
		hud.show_main_menu()
	queue_redraw()
	var perf_result: Dictionary = await _sample_perf_window("menu_idle", 30, 180)
	var avg_fps := float(perf_result["avg_fps"])
	var min_fps := float(perf_result["min_fps"])
	var worst_frame_ms := float(perf_result["worst_frame_ms"])
	_smoke_assert(avg_fps >= 55.0, "menu average FPS should stay at or above 55, got %.1f" % avg_fps)
	_smoke_assert(min_fps >= 45.0, "menu minimum FPS should stay at or above 45, got %.1f" % min_fps)
	_smoke_assert(worst_frame_ms <= 50.0, "menu worst frame should stay below 50ms, got %.1fms" % worst_frame_ms)
	if _smoke_failures.is_empty():
		print("DUST_MENU_PERF: PASS samples=%d avg_fps=%.1f min_fps=%.1f worst_frame_ms=%.1f elapsed_ms=%.1f" % [
			int(perf_result["samples"]),
			avg_fps,
			min_fps,
			worst_frame_ms,
			float(perf_result["elapsed_ms"]),
		])
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_MENU_PERF: %s" % failure)
		get_tree().quit(1)

func _run_heavy_combat_performance_test() -> void:
	_smoke_test_active = false
	_smoke_failures.clear()
	print("DUST_HEAVY_PERF: starting %s" % PERF_TELEMETRY_VERSION)
	menu_open = false
	hud.hide_main_menu()
	_start_run()
	opening_grace_timer = 12.0
	wave_break_timer = 0.0
	await _smoke_start_wave(10)
	if player != null and is_instance_valid(player) and not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		player.health = player.max_health
		player.apply_dust_veil(12.0)
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy is Node2D:
			var enemy_node := enemy as Node2D
			enemy_node.global_position = player.global_position + Vector2(randf_range(-360.0, 360.0), randf_range(-260.0, 260.0))
			enemy_node.queue_redraw()
	for i in range(8):
		vfx_layer.burst(player.global_position + Vector2(randf_range(-220.0, 220.0), randf_range(-160.0, 160.0)), Color(0.86, 0.36, 0.1), 46.0)
	_request_arena_visual_redraw(true)
	_request_dynamic_arena_overlay_redraw(true)
	var perf_result: Dictionary = await _sample_perf_window("wave_10_heavy_combat", 20, 180)
	var avg_fps := float(perf_result["avg_fps"])
	var min_fps := float(perf_result["min_fps"])
	var worst_frame_ms := float(perf_result["worst_frame_ms"])
	_smoke_assert(avg_fps >= 45.0, "heavy combat average FPS should stay at or above 45, got %.1f" % avg_fps)
	_smoke_assert(min_fps >= 30.0, "heavy combat minimum FPS should stay at or above 30, got %.1f" % min_fps)
	_smoke_assert(worst_frame_ms <= 80.0, "heavy combat worst frame should stay below 80ms, got %.1fms" % worst_frame_ms)
	if _smoke_failures.is_empty():
		print("DUST_HEAVY_PERF: PASS samples=%d avg_fps=%.1f min_fps=%.1f worst_frame_ms=%.1f elapsed_ms=%.1f" % [
			int(perf_result["samples"]),
			avg_fps,
			min_fps,
			worst_frame_ms,
			float(perf_result["elapsed_ms"]),
		])
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_HEAVY_PERF: %s" % failure)
		get_tree().quit(1)

func _visual_qa_clear_staged_result_overlay() -> void:
	run_complete = false
	if player != null and is_instance_valid(player):
		player.health = player.max_health
	if hud != null and is_instance_valid(hud) and hud.has_method("clear_result_overlay_for_staged_run"):
		hud.clear_result_overlay_for_staged_run()

func _run_smoke_test() -> void:
	_smoke_test_active = true
	_smoke_failures.clear()
	print("DUST_SMOKE: starting playable run smoke test")
	_smoke_assert_main_menu_visual_upgrade()
	_smoke_assert_upgrade_system()
	menu_open = false
	_start_run()
	await get_tree().process_frame
	_smoke_assert_main_menu_memory_release()
	hud.show_main_menu()
	_smoke_assert_main_menu_visual_upgrade()
	hud.hide_main_menu()
	await get_tree().process_frame
	_smoke_assert_main_menu_memory_release()
	opening_grace_timer = 0.0
	wave_break_timer = 0.0
	_smoke_assert_town_square_business_roster()
	_smoke_assert_unlock_toast_visual_upgrade()

	for target_wave in range(1, 5):
		await _smoke_start_wave(target_wave)
		_smoke_assert_wave_basics(target_wave)
		if target_wave == 1:
			_smoke_assert(_living_enemy_count() == 4, "wave 1 should stay a four-rusher first draw")
			await _smoke_wait_frames(2)
			_smoke_assert_enemy_silhouette_visual_upgrade()
			_smoke_assert_enemy_movement_dust_visual_upgrade()
			_smoke_assert_enemy_hit_recoil_visual_upgrade()
			_smoke_assert_player_hero_visual_upgrade()
			_smoke_assert_first_wave_hud()
			_smoke_assert_training_completion_feedback()
			_smoke_assert_information_primer()
			_smoke_assert_first_rusher_warning_tell()
			_smoke_assert_first_slash_afterimage()
		if target_wave == 2:
			hud.hide_transient_overlays()
			await _smoke_wait_frames(1)
			_smoke_assert_crossfire_hud_tip()
			_smoke_assert(_smoke_stage_crossfire_rifle_bait_line(), "wave 2 smoke should align a rifle tell through saloon cover")
			var rifle_puffs_before := _smoke_get_rifle_warning_puff_total_count()
			var enemy_weapon_bursts_before := _smoke_get_enemy_weapon_burst_total_count()
			var rifle_splinters_before := _cover_splinter_total_count
			_smoke_assert_enemy_weapon_burst_visual_upgrade()
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("rifleman", 45), "wave 2 rifleman should expose a readable attack tell before firing")
			_smoke_assert_rifleman_shot_tell_visual_contract()
			_smoke_assert_crossfire_cover_bait_glint()
			_smoke_assert(_smoke_get_rifle_warning_puff_total_count() > rifle_puffs_before or _smoke_get_rifle_warning_puff_count() > 0, "wave 2 rifleman tell should emit a muzzle dust bracket")
			await _smoke_wait_frames(28)
			_smoke_assert(_smoke_get_enemy_weapon_burst_total_count() > enemy_weapon_bursts_before, "wave 2 rifleman shot should throw the enemy rifle muzzle snap VFX")
			_smoke_assert(_cover_splinter_total_count > rifle_splinters_before, "real Crossfire rifle shot should splinter its staged cover bait")
			_smoke_assert_crossfire_cover_splinter()
		if target_wave % 3 == 0:
			_smoke_assert(_smoke_has_boss_enemy(), "wave %d should spawn a named duelist" % target_wave)
			if target_wave == 3:
				_smoke_assert(_smoke_has_black_sash_signature_mark(), "wave 3 should stage The Black Sash arena-floor signature mark")
				_smoke_assert_black_sash_duel_ground_tip()
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("duelist", 90), "wave %d duelist should expose a readable lunge tell before dashing" % target_wave)
			_smoke_assert(await _smoke_wait_for_enemy_method_true("duelist", "has_pre_dash_boot_dust_tell", 20), "wave %d duelist should expose a pre-dash boot dust tell" % target_wave)
			if target_wave == 3:
				var black_sash_cues_before := _smoke_get_audio_cue_count("black_sash_lunge")
				var black_sash_warnings_before := _smoke_get_black_sash_lunge_warning_count()
				var black_sash_releases_before := _black_sash_lunge_release_count
				var black_sash_duel_rewards_before := _black_sash_duel_ground_reward_count
				var black_sash_style_before := style_score
				_smoke_assert(_smoke_place_player_in_black_sash_duel_ground(), "wave 3 smoke should place the player inside The Black Sash duel-ground mark")
				opening_grace_timer = 1.0
				await _smoke_wait_frames(40)
				_smoke_assert(_black_sash_lunge_release_count > black_sash_releases_before, "wave 3 Black Sash should fire a branded lunge-release event")
				_smoke_assert(_smoke_get_audio_cue_count("black_sash_lunge") > black_sash_cues_before, "wave 3 Black Sash lunge release should play its branded stinger")
				_smoke_assert(_smoke_get_black_sash_lunge_warning_count() > black_sash_warnings_before, "wave 3 Black Sash lunge release should flash its danger accent")
				_smoke_assert_black_sash_duel_ground_reward(black_sash_duel_rewards_before, black_sash_style_before)
		if target_wave == 4:
			hud.hide_transient_overlays()
			await _smoke_wait_frames(1)
			_smoke_assert_rail_yard_hud_tip()
		if target_wave == 5:
			hud.hide_transient_overlays()
			await _smoke_wait_frames(1)
			_smoke_assert_dust_chapel_hud_tip()
		_smoke_clear_wave()
		await _smoke_wait_frames(2)

	var setpiece_expectations := {
		4: {"title": "Rail Yard Rush", "modifier": "rush", "hazards": 5, "animated": true},
		5: {"title": "Dust Chapel Bells", "modifier": "bells", "hazards": 5, "animated": true},
		6: {"title": "Mercy Vale's Ride", "modifier": "mercy", "hazards": 6, "animated": true, "boss": true, "boss_name": "MERCY VALE"},
		7: {"title": "Red Canyon Press", "modifier": "sandstorm", "hazards": 6, "animated": true, "hunter": 1},
		8: {"title": "Bank Vault Break", "modifier": "gold_rush", "hazards": 8, "animated": true, "hunter": 1},
		9: {"title": "June Blackglass", "modifier": "blackglass", "hazards": 7, "animated": true, "boss": true, "boss_name": "JUNE BLACKGLASS"},
		10: {"title": "Last High Noon", "modifier": "last_stand", "hazards": 8, "animated": true, "hunter": 2},
	}
	for target_wave in setpiece_expectations.keys():
		await _smoke_start_wave(int(target_wave))
		_smoke_assert_wave_basics(int(target_wave))
		_smoke_assert_level_identity(int(target_wave), setpiece_expectations[target_wave])
		var before_anim_time := _hazard_anim_time
		await _smoke_wait_frames(3)
		if bool(setpiece_expectations[target_wave].get("animated", false)):
			_smoke_assert(_hazard_anim_time > before_anim_time, "wave %d should tick its animated set-piece overlay" % int(target_wave))
		if int(setpiece_expectations[target_wave].get("hunter", 0)) > 0:
			if int(target_wave) == 7:
				_smoke_assert(_smoke_place_player_in_red_canyon_route_pocket(), "wave 7 smoke should place the player inside a Red Canyon calm pocket")
			_smoke_assert(_smoke_stage_enemy_kind_near_player("hunter", Vector2(220.0, 0.0)), "wave %d should stage hunter pressure for tell validation" % int(target_wave))
			var hunter_lunge_cues_before := _smoke_get_audio_cue_count("hunter_lunge")
			var hunter_lunge_kicks_before := _hunter_lunge_camera_kicks
			var hunter_lunge_warnings_before := _smoke_get_hunter_lunge_warning_count()
			var red_canyon_rewards_before := _smoke_get_red_canyon_pocket_reward_count()
			var red_canyon_style_before := style_score
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("hunter", 90), "wave %d hunter should expose a readable lunge tell before striking" % int(target_wave))
			_smoke_assert_hunter_lunge_tell_visual_contract()
			_smoke_assert(await _smoke_wait_for_enemy_method_true("hunter", "has_lunge_afterimage", 45), "wave %d hunter lunge should emit a visible afterimage trail" % int(target_wave))
			_smoke_assert(_smoke_get_audio_cue_count("hunter_lunge") > hunter_lunge_cues_before, "wave %d hunter lunge should play its rush audio cue" % int(target_wave))
			_smoke_assert(_hunter_lunge_camera_kicks > hunter_lunge_kicks_before, "wave %d hunter lunge should kick the camera at release" % int(target_wave))
			_smoke_assert(_smoke_get_hunter_lunge_warning_count() > hunter_lunge_warnings_before, "wave %d hunter lunge should flash its HUD danger accent" % int(target_wave))
			if int(target_wave) == 7:
				_smoke_assert_red_canyon_pocket_reward_result(red_canyon_rewards_before, red_canyon_style_before)
		if int(target_wave) == 8:
			_smoke_assert_gold_rush_keg_chain()
		if int(target_wave) == 9:
			_smoke_assert(_smoke_stage_enemy_kind_near_player("duelist", Vector2(360.0, 0.0)), "wave 9 should stage June Blackglass inside kill-box wind-up range")
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("duelist", 90), "wave 9 June Blackglass should expose a readable kill-box lunge tell before dashing")
			_smoke_assert(await _smoke_wait_for_enemy_method_true("duelist", "has_blackglass_killbox_windup_tell", 20), "wave 9 June Blackglass should expose close kill-box wind-up brackets")
			_smoke_assert(_smoke_stage_duelist_release_tell("june_blackglass", Vector2(340.0, 0.0)), "wave 9 smoke should stage June Blackglass for a fresh kill-box snap release")
			var june_cues_before := _smoke_get_audio_cue_count("june_blackglass_lunge")
			var june_warnings_before := _smoke_get_june_blackglass_lunge_warning_count()
			var june_releases_before := _june_blackglass_lunge_release_count
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("duelist", 90), "wave 9 June Blackglass should expose a staged snap tell before release")
			await _smoke_wait_frames(40)
			_smoke_assert(_june_blackglass_lunge_release_count > june_releases_before, "wave 9 June Blackglass should fire a branded kill-box snap release event")
			_smoke_assert(_smoke_get_audio_cue_count("june_blackglass_lunge") > june_cues_before, "wave 9 June Blackglass release should play its snap stinger")
			_smoke_assert(_smoke_get_june_blackglass_lunge_warning_count() > june_warnings_before, "wave 9 June Blackglass release should flash its snap danger accent")
		if int(target_wave) == 5:
			await _smoke_assert_brute_shotgun_tell()
		if int(target_wave) == 6:
			hud.hide_transient_overlays()
			await _smoke_wait_frames(1)
			_smoke_assert_mercy_vale_hud_tip()
			_smoke_assert(_smoke_stage_duelist_release_tell("mercy_vale", Vector2(330.0, 0.0)), "wave 6 smoke should stage Mercy Vale for a fresh fast-draw release")
			var mercy_cues_before := _smoke_get_audio_cue_count("mercy_vale_lunge")
			var mercy_warnings_before := _smoke_get_mercy_vale_lunge_warning_count()
			var mercy_releases_before := _mercy_vale_lunge_release_count
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("duelist", 90), "wave 6 Mercy Vale should expose a fast-draw tell before release")
			await _smoke_wait_frames(40)
			_smoke_assert(_mercy_vale_lunge_release_count > mercy_releases_before, "wave 6 Mercy Vale should fire a branded fast-draw release event")
			_smoke_assert(_smoke_get_audio_cue_count("mercy_vale_lunge") > mercy_cues_before, "wave 6 Mercy Vale release should play its fast-draw stinger")
			_smoke_assert(_smoke_get_mercy_vale_lunge_warning_count() > mercy_warnings_before, "wave 6 Mercy Vale release should flash its fast-draw danger accent")
		if int(target_wave) == 9 or int(target_wave) == 10:
			hud.hide_transient_overlays()
			await _smoke_wait_frames(1)
			_smoke_assert_late_run_hud_tip(int(target_wave))
		if int(target_wave) == 10:
			_smoke_assert_finale_objective_tracker()
			_smoke_assert_last_high_noon_exit_lane_reward()
		_smoke_clear_wave()
		await _smoke_wait_frames(2)

	await _smoke_run_to_extraction()
	_smoke_assert_failed_run_popout()

	_smoke_assert(current_wave >= MAX_LEVEL, "smoke test should advance through all ten waves")
	_smoke_assert(hud != null and is_instance_valid(hud), "HUD should remain alive after smoke waves")
	_smoke_assert(vfx_layer != null and is_instance_valid(vfx_layer), "VFX layer should remain alive after smoke waves")
	Engine.time_scale = 1.0
	if _smoke_failures.is_empty():
		print("DUST_SMOKE: PASS waves=%d enemies_defeated=%d hazards=%d" % [current_wave, enemies_defeated, arena_hazards.size()])
		get_tree().quit(0)
	else:
		for failure in _smoke_failures:
			push_error("DUST_SMOKE: %s" % failure)
		get_tree().quit(1)

func _smoke_wait_frames(count: int) -> void:
	for i in range(count):
		await get_tree().physics_frame

func _smoke_assert_town_square_business_roster() -> void:
	var required_names := ["SALOON", "BARBER", "SHERIFF", "BANK", "GENERAL"]
	var found_names: Array[String] = []
	for i in range(TOWN_BUSINESS_ROSTER.size()):
		found_names.append(str(_get_town_business(i).get("name", "")))
	for required_name in required_names:
		_smoke_assert(found_names.has(required_name), "town square perimeter should include a %s storefront" % required_name)
	_smoke_assert(str(_get_town_business(0).get("id", "")) != str(_get_town_business(1).get("id", "")), "town square storefronts should vary instead of repeating one building")
	var required_props := ["wanted_board", "lantern_post", "water_trough", "hitching_post", "supply_crates", "saloon_barrels", "sheriff_rail", "bank_strongbox", "hotel_luggage", "stable_hay", "doc_medicine"]
	var found_props := _get_town_square_foreground_prop_kinds()
	for required_prop in required_props:
		_smoke_assert(found_props.has(required_prop), "town square foreground should include a %s prop" % required_prop)
	_smoke_assert(TOWN_FOREGROUND_PROP_LAYOUT.size() >= 14, "town square should have enough deterministic foreground dressing outside the fence")
	_smoke_assert(_get_storefront_highlight_visual_version() == STOREFRONT_HIGHLIGHT_VISUAL_VERSION, "town storefronts should use the brass-and-glass highlight material pass")
	_smoke_assert(_get_town_foreground_visual_version() == TOWN_FOREGROUND_VISUAL_VERSION, "town foreground props should use the business-specific depth visual pass")
	_smoke_assert(_get_town_business_facade_visual_version() == TOWN_BUSINESS_FACADE_VISUAL_VERSION, "town square storefronts should use the business-specific facade silhouette pass")
	var facade_cues := _get_town_business_facade_cues()
	for required_cue in ["swing_doors", "barber_pole", "jail_bars", "vault_face", "hotel_balcony", "stable_arch", "doctor_cross", "business_shadow_awning", "saloon_bottle_shelf", "sheriff_badge_parapet", "bank_pillars", "general_store_crates", "saloon_double_door_shadow", "barber_basin_mirror", "sheriff_jail_window", "bank_teller_grille", "general_feed_sacks", "hotel_luggage_stack", "stable_hayloft_door", "doctor_medicine_case"]:
		_smoke_assert(facade_cues.has(required_cue), "town square business facades should include %s" % required_cue)
	_smoke_assert(_get_town_roofline_silhouette_visual_version() == TOWN_ROOFLINE_SILHOUETTE_VISUAL_VERSION, "town square roofline should use the silhouette depth pass")
	var roofline_cues := _get_town_roofline_silhouette_cues()
	for required_cue in ["chimney_stacks", "water_tank", "telegraph_wires", "hanging_sign_shadows", "roof_ladders", "weather_vanes"]:
		_smoke_assert(roofline_cues.has(required_cue), "town square roofline silhouettes should include %s" % required_cue)

func _smoke_assert_main_menu_visual_upgrade() -> void:
	if hud == null or not is_instance_valid(hud):
		_smoke_assert(false, "main menu visual smoke needs HUD")
		return
	if hud.has_method("get_main_menu_loaded"):
		_smoke_assert(bool(hud.get_main_menu_loaded()), "main menu should be loaded while menu visuals are being inspected")
	if hud.has_method("get_main_menu_backdrop_class_name"):
		_smoke_assert(str(hud.get_main_menu_backdrop_class_name()) == "MenuBackdrop", "main menu should use the custom western backdrop instead of a flat color panel")
	if hud.has_method("get_main_menu_backdrop_visual_version"):
		_smoke_assert(str(hud.get_main_menu_backdrop_visual_version()) == "menu_backdrop_static_low_batch_v1", "main menu backdrop should use the low-batch western street composition pass")
	if hud.has_method("get_main_menu_town_square_cue_count"):
		_smoke_assert(int(hud.get_main_menu_town_square_cue_count()) >= 32, "main menu backdrop should expose storefronts, rooflines, business cues, lanterns, street ruts, porch rails, sun shafts, and brass title-plaque cues without the high-batch idle detail pass")
	if hud.has_method("get_main_menu_title_plaque_marker_count"):
		_smoke_assert(int(hud.get_main_menu_title_plaque_marker_count()) >= 14, "main menu title plaque should expose chains, rivets, brass rails, side plates, marshal stars, center plate, shadow, and hanging-sign hardware markers")
	if hud.has_method("get_main_menu_responsive_layout_version"):
		_smoke_assert(str(hud.get_main_menu_responsive_layout_version()) == "menu_responsive_loadout_spacing_v1", "main menu should use responsive spacing for narrow browser viewports")
	if hud.has_method("get_main_menu_responsive_widths_valid"):
		_smoke_assert(bool(hud.get_main_menu_responsive_widths_valid()), "main menu responsive layout should keep nav and loadout panels inside the content band")
	if hud.has_method("get_main_menu_loadout_column_count"):
		_smoke_assert(int(hud.get_main_menu_loadout_column_count()) >= 1, "main menu loadout grids should expose at least one responsive column")
	if hud.has_method("get_main_menu_button_style_count"):
		_smoke_assert(int(hud.get_main_menu_button_style_count()) >= 6, "main menu nav buttons should have custom leather-and-brass normal/hover/pressed styles")
	if hud.has_method("get_main_menu_nav_button_visual_version"):
		_smoke_assert(str(hud.get_main_menu_nav_button_visual_version()) == "menu_nav_bounty_receipt_badge_press_hardware_v10", "main menu nav buttons should use the brass cartridge-tab, bounty-receipt edge, selected badge, press hardware, tactile icon plate redraw-gated visual pass")
	if hud.has_method("get_main_menu_nav_redraw_gate_version"):
		_smoke_assert(str(hud.get_main_menu_nav_redraw_gate_version()) == "menu_nav_state_redraw_gate_v1", "main menu nav buttons should skip redundant redraws when selection state is unchanged")
	if hud.has_method("get_main_menu_nav_tactile_marker_count"):
		_smoke_assert(int(hud.get_main_menu_nav_tactile_marker_count()) >= 276, "main menu nav buttons should expose bevels, rivets, plank grain, brass rails, cartridge tabs, receipt teeth, punch holes, endcap hardware, press hinges, bounty stars, icon plates, press-depth, western silhouette icons, selected sheriff badges, label backplates, and stamp markers")
	if hud.has_method("get_info_card_visual_version"):
		_smoke_assert(str(hud.get_info_card_visual_version()) == "info_card_weathered_ledger_v3", "overview and information cards should use the premium weathered ledger readability pass")
	if hud.has_method("get_visible_info_card_count"):
		_smoke_assert(int(hud.get_visible_info_card_count()) >= 2, "main menu overview should render the optimized stamped ledger summary cards")
	if hud.has_method("get_info_card_detail_marker_count"):
		_smoke_assert(int(hud.get_info_card_detail_marker_count()) >= 36, "main menu info cards should expose brass rails, ticks, side rule marks, rivets, and stamped ledger markers without the four-card idle layout")
	if hud.has_method("get_quest_card_visual_version"):
		_smoke_assert(str(hud.get_quest_card_visual_version()) == "quest_card_bounty_stamp_v2", "quest cards should use bounty-stamped western ledger styling")
	if hud.has_method("get_quest_card_count"):
		_smoke_assert(int(hud.get_quest_card_count()) >= 4, "quest screen should render four reward-stamped quest cards")
	if hud.has_method("get_loadout_icon_count"):
		_smoke_assert(int(hud.get_loadout_icon_count()) >= 12, "gun and ability loadout cards should render custom western icons")
	if hud.has_method("get_loadout_icon_visual_version"):
		_smoke_assert(str(hud.get_loadout_icon_visual_version()) == "loadout_icon_brass_socket_material_cues_v2", "gun and ability loadout icons should use brass socket material cues with readable weapon and ability footer marks")
	if hud.has_method("get_loadout_icon_tactile_marker_count"):
		_smoke_assert(int(hud.get_loadout_icon_tactile_marker_count()) >= 120, "gun and ability loadout icons should expose brass sockets, screws, notches, inner shine, equipped badges, and type-specific footer cues")
	if hud.has_method("get_loadout_card_visual_version"):
		_smoke_assert(str(hud.get_loadout_card_visual_version()) == "loadout_card_claim_ticket_depth_hardware_redraw_gate_v8", "gun and ability loadout card buttons should use premium tactile badges, cartridge rails, claim-ticket perforations, bounty seals, stamped selection plates, depth hardware, leather card chrome, and redraw gates")
	if hud.has_method("get_loadout_card_button_visual_count"):
		_smoke_assert(int(hud.get_loadout_card_button_visual_count()) >= 12, "gun and ability loadout card buttons should be custom drawn state-plate buttons, not plain Button nodes")
	if hud.has_method("get_loadout_card_button_tactile_marker_count"):
		_smoke_assert(int(hud.get_loadout_card_button_tactile_marker_count()) >= 480, "gun and ability loadout card buttons should expose rivets, edge strips, badges, cartridge rails, claim-ticket teeth, punch holes, ledger rules, bounty seals, state plates, depth frames, corner plates, stitches, side rails, ready plates, equipped sashes, bottom notches, and locked hatching markers")
	if hud.has_method("get_loadout_card_button_redraw_gate_version"):
		_smoke_assert(str(hud.get_loadout_card_button_redraw_gate_version()) == "loadout_card_state_redraw_gate_v1", "gun and ability loadout card buttons should skip redundant redraws when card state is unchanged")
	if hud.has_method("get_loadout_icon_redraw_gate_version"):
		_smoke_assert(str(hud.get_loadout_icon_redraw_gate_version()) == "loadout_icon_state_redraw_gate_v1", "gun and ability loadout icons should skip redundant redraws when icon state is unchanged")
	if hud.has_method("get_loadout_card_style_count"):
		_smoke_assert(int(hud.get_loadout_card_style_count()) >= 12, "gun and ability loadout card buttons should keep custom normal/hover/pressed/disabled styles")
	if hud.has_method("get_loadout_card_tactile_style_count"):
		_smoke_assert(int(hud.get_loadout_card_tactile_style_count()) >= 12, "gun and ability loadout card buttons should include focus, pressed text, and stamped shadow tactile states")

func _smoke_assert_upgrade_system() -> void:
	_smoke_assert(UPGRADE_DEFINITIONS.size() == 15, "upgrade system should define exactly 15 permanent upgrades")
	_refresh_upgrade_screen()
	if hud.has_method("get_upgrade_card_count"):
		_smoke_assert(int(hud.get_upgrade_card_count()) == 15, "upgrade menu should expose all 15 permanent upgrade cards")
	var purchased_before: Array = save_system.data.get("purchased_upgrades", [])
	var tokens_before := int(save_system.data.get("upgrade_tokens", 0))
	_award_upgrade_tokens(3, "SMOKE TOKEN CLAIM")
	var tokens_after_award := int(save_system.data.get("upgrade_tokens", 0))
	_smoke_assert(tokens_after_award >= tokens_before + 3, "upgrade tokens should persist when awarded")
	var target_upgrade := ""
	for upgrade in UPGRADE_DEFINITIONS:
		if not purchased_before.has(upgrade["id"]) and int(upgrade.get("cost", 1)) <= tokens_after_award:
			target_upgrade = str(upgrade["id"])
			break
	if target_upgrade != "":
		_on_upgrade_purchase_requested(target_upgrade)
		var purchased_after: Array = save_system.data.get("purchased_upgrades", [])
		_smoke_assert(purchased_after.has(target_upgrade), "upgrade purchase should persist the bought upgrade id")
		_smoke_assert(int(save_system.data.get("upgrade_tokens", 0)) < tokens_after_award, "upgrade purchase should spend tokens")
	var modifiers := _get_upgrade_modifiers()
	_smoke_assert(modifiers.has("max_health_bonus") and modifiers.has("gun_damage") and modifiers.has("combo_timer_bonus"), "upgrade modifiers should cover survival, gun, and style passives")
	_refresh_upgrade_screen()
	if hud.has_method("get_skill_icon_visual_version"):
		_smoke_assert(str(hud.get_skill_icon_visual_version()) == "skill_icon_brass_socket_cooldown_5step_v8", "compact in-run skill buttons should use the brass socket visual pass with 5-percent cooldown redraw buckets")
	if hud.has_method("get_skill_icon_redraw_budget_version"):
		_smoke_assert(str(hud.get_skill_icon_redraw_budget_version()) == "skill_icon_cooldown_redraw_gate_20step_v2", "compact in-run skill buttons should gate cooldown redraws to 20 buckets instead of repainting every HUD tick")
	if hud.has_method("get_skill_icon_cooldown_redraw_step"):
		_smoke_assert(float(hud.get_skill_icon_cooldown_redraw_step()) >= 0.05, "compact in-run skill buttons should quantize cooldown redraws to a 5-percent visible step")
	if hud.has_method("get_skill_icon_cooldown_redraw_bucket_count"):
		_smoke_assert(int(hud.get_skill_icon_cooldown_redraw_bucket_count()) <= 20, "compact in-run skill buttons should expose at most 20 cooldown redraw buckets")
	if hud.has_method("get_skill_icon_count"):
		_smoke_assert(int(hud.get_skill_icon_count()) >= 4, "live HUD should render four compact skill buttons")
	if hud.has_method("get_skill_icon_tactile_marker_count"):
		_smoke_assert(int(hud.get_skill_icon_tactile_marker_count()) >= 72, "live HUD skill buttons should expose readable brass socket, cylinder, and cooldown markers without costly per-tick redraws")

func _smoke_assert_main_menu_memory_release() -> void:
	if hud == null or not is_instance_valid(hud):
		_smoke_assert(false, "main menu memory smoke needs HUD")
		return
	if hud.has_method("get_main_menu_memory_mode_version"):
		_smoke_assert(str(hud.get_main_menu_memory_mode_version()) == "main_menu_release_on_gameplay_v1", "main menu should use the release-on-gameplay memory mode")
	if hud.has_method("get_main_menu_loaded"):
		_smoke_assert(not bool(hud.get_main_menu_loaded()), "main menu nodes should be released from memory during gameplay instead of only hidden")

func _smoke_assert_unlock_toast_visual_upgrade() -> void:
	_smoke_assert(hud != null and is_instance_valid(hud), "unlock toast smoke needs HUD")
	if hud == null or not is_instance_valid(hud):
		return
	hud.show_unlock("BLACK SASH SABER UNLOCKED")
	if hud.has_method("get_unlock_toast_visual_version"):
		_smoke_assert(str(hud.get_unlock_toast_visual_version()) == "unlock_toast_brass_claim_ticket_v1", "unlock toast should use the brass claim-ticket frame")
	if hud.has_method("get_unlock_toast_detail_marker_count"):
		_smoke_assert(int(hud.get_unlock_toast_detail_marker_count()) >= 24, "unlock toast should expose brass rails, badge, notches, rivets, and spark markers")
	if hud.has_method("get_unlock_toast_visible"):
		_smoke_assert(bool(hud.get_unlock_toast_visible()), "unlock toast frame should be visible while unlock text is shown")
	if hud.has_method("get_unlock_toast_text"):
		_smoke_assert(str(hud.get_unlock_toast_text()).find("UNLOCKED") >= 0, "unlock toast should keep reward text inside the framed claim ticket")
	if hud.has_method("hide_transient_overlays"):
		hud.hide_transient_overlays()

func _smoke_assert_enemy_silhouette_visual_upgrade() -> void:
	var checked := 0
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		_smoke_assert(enemy.has_method("get_enemy_silhouette_visual_version"), "enemy sprites should expose the role silhouette visual upgrade hook")
		if enemy.has_method("get_enemy_silhouette_visual_version"):
			_smoke_assert(str(enemy.get_enemy_silhouette_visual_version()) == "role_silhouette_badge_plate_readability_v8", "enemy sprites should use the direction-aware safe-cropped role plate, role badge plate, and material glint polish pass")
			checked += 1
		_smoke_assert(enemy.has_method("get_enemy_grounded_sprite_visual_version"), "enemy sprites should expose the grounded sprite presentation hook")
		if enemy.has_method("get_enemy_grounded_sprite_visual_version"):
			_smoke_assert(str(enemy.get_enemy_grounded_sprite_visual_version()) == "enemy_directional_human_motion_weapon_draw_v1", "enemy sprites should use direction-aware whole-body sprites with human gait, arms, and weapon draw overlays")
		_smoke_assert(enemy.has_method("get_enemy_human_motion_visual_version"), "enemy sprites should expose the human-motion visual hook")
		if enemy.has_method("get_enemy_human_motion_visual_version"):
			_smoke_assert(str(enemy.get_enemy_human_motion_visual_version()) == "enemy_rusher_hunter_gait_weapon_anchor_strip_v21", "enemy sprites should animate authored gameplay-scale gait and baked weapon strip frames across all roles, with low-speed stepping, slow-chase facing, whole-body idle breathing, role-weighted idle sway, role-readable long guns, blade edges, muzzle glints, support hands, body-attached carried weapons, direction-aware baked boot contacts, arm swings, braced combat limbs, keyframed whole-body gait transforms, role-specific body lean, attack anticipation, lunge commitment, role-specific two-hand weapon grips, clean strip-backed overlay suppression, clearer hip-knee-boot leg chains, planted boot contacts, stronger weapon anchors, rifleman braced-march hands, shotgun brute wide heavy foot plants, urgent knife-rusher forward stabs, and lean hunter stalking blades")
		_smoke_assert(enemy.has_method("get_enemy_human_motion_marker_count"), "enemy sprites should expose human-motion marker coverage")
		if enemy.has_method("get_enemy_human_motion_marker_count"):
			_smoke_assert(int(enemy.get_enemy_human_motion_marker_count()) >= 216, "enemy human-motion overlays should cover all-role gameplay-scale authored gait strips, baked weapon strips, low-speed stepping, slow-chase facing, compact texture budgets, whole-body idle breathing, role-weighted idle sway, idle compression, role-readable long guns, shotgun muzzles, blade edges, support-hand braces, body-attached carried weapons, direction-aware weapon anchoring, direction-aware boot contacts, baked arm swings, braced combat feet, support hands, keyframed contact holds, whole-body bob, lean, compression, four gait phases, planted boots, torso lean, shoulder/hip counter-motion, gait legs, hip-knee-boot chains, boot contact shadows, brass spur cues, arm swing, role accents, attack bracing, lunge commitment, long-gun support hands, blade guards, weapon draw markers, anchored weapon silhouettes, rifleman steady support hands, shotgun brute wide planted contacts, knife-rusher forward stab reach, hunter low stalking support hand, and strip-backed duplicate overlay suppression")
		_smoke_assert(enemy.has_method("get_enemy_strip_overlay_mode_version"), "enemy sprites should expose the strip-backed overlay mode contract")
		if enemy.has_method("get_enemy_strip_overlay_mode_version"):
			_smoke_assert(str(enemy.get_enemy_strip_overlay_mode_version()) == "enemy_strip_backed_clean_overlay_suppression_v1", "enemy baked strip frames should not receive a second procedural limb and weapon overlay")
		if enemy.has_method("get_enemy_gait_strip_visual_version"):
			_smoke_assert(str(enemy.get_enemy_gait_strip_visual_version()) == "enemy_rusher_hunter_legible_gait_strip_v7", "sprite-backed enemies should expose generated gameplay-scale authored gait strips with role-specific rifleman bracing, brute foot plants, knife-rusher forward urgency, hunter stalking posture, clearer hip-knee-boot motion, and body-attached carried weapons")
		if enemy.has_method("get_enemy_gait_strip_direction_count"):
			_smoke_assert(int(enemy.get_enemy_gait_strip_direction_count()) >= 8, "sprite-backed enemies should load generated authored gait strips for all eight enemy directions")
		if enemy.has_method("get_enemy_combat_strip_visual_version"):
			_smoke_assert(str(enemy.get_enemy_combat_strip_visual_version()) == "enemy_gameplay_scaled_anchored_weapon_strip_v5", "sprite-backed enemies should expose generated gameplay-scale authored weapon strips with braced legs, support hands, and anchored directional weapon silhouettes")
		if enemy.has_method("get_enemy_combat_strip_direction_count"):
			_smoke_assert(int(enemy.get_enemy_combat_strip_direction_count()) >= 8, "sprite-backed enemies should load generated authored weapon strips for all eight enemy directions")
		if enemy.has_method("get_enemy_animation_strip_budget_version"):
			_smoke_assert(str(enemy.get_enemy_animation_strip_budget_version()) == "enemy_animation_strip_texture_budget_v1", "sprite-backed enemies should expose the animation strip texture budget contract")
		if enemy.has_method("get_enemy_animation_texture_cache_version"):
			_smoke_assert(str(enemy.get_enemy_animation_texture_cache_version()) == "enemy_animation_texture_archetype_cache_v1", "sprite-backed enemies should reuse loaded turnaround and animation strip textures by archetype to prevent spawn-time lag")
		if enemy.has_method("get_enemy_animation_texture_cache_archetype_count"):
			_smoke_assert(int(enemy.get_enemy_animation_texture_cache_archetype_count()) >= 1, "enemy animation texture cache should contain at least the spawned archetype")
		if enemy.has_method("get_enemy_animation_strip_total_pixels"):
			_smoke_assert(int(enemy.get_enemy_animation_strip_total_pixels()) <= 4500000, "sprite-backed enemy animation strips should stay within the compact gameplay-scale texture budget")
		if enemy.has_method("get_enemy_animation_strip_max_height"):
			_smoke_assert(int(enemy.get_enemy_animation_strip_max_height()) <= 150, "sprite-backed enemy animation strips should use compact gameplay-scale frame heights")
		if enemy.has_method("get_enemy_motion_redraw_interval"):
			_smoke_assert(float(enemy.get_enemy_motion_redraw_interval()) >= 1.0 / 8.5, "enemy sprite motion redraws should be capped near 8 FPS for browser frame stability")
		if enemy.has_method("get_enemy_source_crop_visual_version"):
			_smoke_assert(str(enemy.get_enemy_source_crop_visual_version()) == "enemy_turnaround_directional_safe_source_crop_v2", "enemy sprites should crop transparent source padding per facing at draw time for stronger gameplay-scale silhouettes")
		if enemy.has_method("get_enemy_directional_source_crop_count"):
			_smoke_assert(int(enemy.get_enemy_directional_source_crop_count()) >= 8, "enemy sprites should expose safe source crops for all eight directional turnaround facings")
		_smoke_assert(enemy.has_method("get_enemy_sprite_material_marker_count"), "enemy sprites should expose material marker coverage for the sprite polish pass")
		if enemy.has_method("get_enemy_sprite_material_marker_count"):
			_smoke_assert(int(enemy.get_enemy_sprite_material_marker_count()) >= 26, "enemy sprites should include directional safe crop, role plate, role badge plate markers, whole-body hat, shoulder, contact, brass, leather, weapon, and role silhouette material markers")
	_smoke_assert(checked > 0, "enemy silhouette visual smoke should inspect at least one live enemy")

func _smoke_assert_enemy_hit_recoil_visual_upgrade() -> void:
	var target: Node = null
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.has_method("get_enemy_hit_recoil_visual_version") and enemy.has_method("has_active_hit_recoil") and enemy.has_method("take_damage"):
			target = enemy
			break
	if target == null:
		_smoke_assert(false, "enemy hit recoil smoke should inspect one live enemy")
		return
	_smoke_assert(str(target.get_enemy_hit_recoil_visual_version()) == "enemy_hit_recoil_shadow_rim_v1", "enemy damage should use the body recoil, rim, and shadow-skid visual pass")
	target.take_damage(1.0)
	_smoke_assert(bool(target.has_active_hit_recoil()), "nonlethal enemy damage should trigger an active hit recoil pose")

func _smoke_assert_player_hero_visual_upgrade() -> void:
	_smoke_assert(player != null and is_instance_valid(player), "player hero visual smoke needs a live player")
	if player == null or not is_instance_valid(player):
		return
	_smoke_assert(player.has_method("get_player_hero_visual_version"), "player should expose the denim-and-brass hero visual hook")
	if player.has_method("get_player_hero_visual_version"):
		_smoke_assert(str(player.get_player_hero_visual_version()) == "denim_brass_hero_whole_sprite_browser_safe_v12", "player should use the denim-and-brass full-sprite browser-safe visual pass")
	_smoke_assert(player.has_method("get_player_grounded_sprite_visual_version"), "player should expose the grounded sprite presentation hook")
	if player.has_method("get_player_grounded_sprite_visual_version"):
		_smoke_assert(str(player.get_player_grounded_sprite_visual_version()) == "player_directional_human_motion_weapon_draw_v1", "player should use direction-aware whole-body sprites with human gait, arms, and saber draw overlays")
	_smoke_assert(player.has_method("get_player_human_motion_visual_version"), "player should expose the human-motion visual hook")
	if player.has_method("get_player_human_motion_visual_version"):
		_smoke_assert(str(player.get_player_human_motion_visual_version()) == "player_body_attached_carried_saber_gait_strip_v21", "player should animate authored gameplay-scale gait and baked saber strip frames, with low-speed stepping, slow-turn facing, whole-body idle breathing, subtle idle weight shift, a readable saber edge, clearer holster-to-guard hand travel, off-hand guard, hilt checkpoints, draw-path glints, body-attached carried saber frames, carried-saber holster tether, support-hand guard markers, tucked ready blade angle, direction-aware baked boot contacts, arm swings, braced combat limbs, keyframed whole-body gait transforms, planted contact holds, dash commitment, torso lean, shoulder/hip counter-motion, legs, arms, hip-knee-boot chains, boot contact shadows, idle breathing, two-hand saber draw, guard, slash follow-through, anchored saber silhouettes, and clean strip-backed overlay suppression on directional sprites")
	_smoke_assert(player.has_method("get_player_human_motion_marker_count"), "player should expose human-motion marker coverage")
	if player.has_method("get_player_human_motion_marker_count"):
		_smoke_assert(int(player.get_player_human_motion_marker_count()) >= 200, "player human-motion overlay should cover gameplay-scale authored gait strips, readable baked saber strips, low-speed stepping, slow-turn facing, compact texture budgets, whole-body idle breathing, idle side-weight shift, idle compression, holster-to-draw hand travel, off-hand guard, hilt glint, draw anticipation ghost edge, holster scabbard, hilt checkpoints, guard hand path, blade draw ghost, body-attached carried saber frames, carried-saber holster tether, carried hand grip, guard hand marker, tucked ready angle, direction-aware saber anchoring, direction-aware boot contacts, baked arm swings, braced combat feet, support hands, keyframed contact holds, whole-body bob, lean, compression, four gait phases, planted boots, hip-knee-boot chains, boot contact shadows, brass spur cues, dash commitment, torso lean, shoulder/hip counter-motion, alternating boots, arm swing, idle breathing, holster, spur dust, two-hand saber draw, guard, hilt, anchored saber silhouettes, follow-through markers, and strip-backed duplicate overlay suppression")
	_smoke_assert(player.has_method("get_player_strip_overlay_mode_version"), "player should expose the strip-backed overlay mode contract")
	if player.has_method("get_player_strip_overlay_mode_version"):
		_smoke_assert(str(player.get_player_strip_overlay_mode_version()) == "player_strip_backed_clean_overlay_suppression_v1", "player baked strip frames should not receive a second procedural limb and saber overlay")
	if player.has_method("get_player_gait_strip_visual_version"):
		_smoke_assert(str(player.get_player_gait_strip_visual_version()) == "player_body_attached_carried_saber_gait_strip_v5", "player should expose generated gameplay-scale directional authored gait strips with clearer hip-knee-boot motion, holster-tethered carried saber frames, support-hand guard markers, and body-attached carried weapon posture")
	if player.has_method("get_player_gait_strip_direction_count"):
		_smoke_assert(int(player.get_player_gait_strip_direction_count()) >= 13, "player should load generated authored gait strips for all thirteen cowgirl directions")
	if player.has_method("get_player_combat_strip_visual_version"):
		_smoke_assert(str(player.get_player_combat_strip_visual_version()) == "player_gameplay_scaled_anchored_saber_strip_v5", "player should expose generated gameplay-scale directional saber strips with braced legs, off-hand guard, and anchored baked saber silhouettes")
	if player.has_method("get_player_combat_strip_direction_count"):
		_smoke_assert(int(player.get_player_combat_strip_direction_count()) >= 13, "player should load generated authored saber strips for all thirteen cowgirl directions")
	if player.has_method("get_player_animation_strip_budget_version"):
		_smoke_assert(str(player.get_player_animation_strip_budget_version()) == "player_animation_strip_texture_budget_v1", "player should expose the animation strip texture budget contract")
	if player.has_method("get_player_animation_strip_total_pixels"):
		_smoke_assert(int(player.get_player_animation_strip_total_pixels()) <= 6500000, "player animation strips should stay within the compact gameplay-scale texture budget")
	if player.has_method("get_player_animation_strip_max_height"):
		_smoke_assert(int(player.get_player_animation_strip_max_height()) <= 150, "player animation strips should use compact gameplay-scale frame heights")
	if player.has_method("get_player_motion_redraw_interval"):
		_smoke_assert(float(player.get_player_motion_redraw_interval()) >= 0.12, "player sprite redraws should be capped near 8 FPS to prevent browser lag during walking and running")
	if player.has_method("get_player_overlay_movement_gate_version"):
		_smoke_assert(str(player.get_player_overlay_movement_gate_version()) == "player_sprite_human_motion_overlay_v1", "player body-attached overlays should carry clean human motion without splitting the textured sprite")
	if player.has_method("get_player_safe_source_crop_visual_version"):
		_smoke_assert(str(player.get_player_safe_source_crop_visual_version()) == "player_directional_uncropped_full_image_v4", "player directional sprites should draw the uncropped full image so walking and aiming never show detached body fragments")
	if player.has_method("get_player_directional_source_crop_count"):
		_smoke_assert(int(player.get_player_directional_source_crop_count()) >= 13, "player should expose safe source crops for all thirteen directional cowgirl sprites")
	_smoke_assert(player.has_method("get_player_sprite_material_marker_count"), "player should expose material marker coverage for the hero sprite polish pass")
	if player.has_method("get_player_sprite_material_marker_count"):
		_smoke_assert(int(player.get_player_sprite_material_marker_count()) >= 12, "player sprite should keep readable denim, brass, leather, bone, hat, source-crop, and weapon-read markers without splitting during movement")

func _smoke_assert_arena_floor_visual_upgrade() -> void:
	_smoke_assert(_get_arena_floor_visual_version() == ARENA_FLOOR_VISUAL_VERSION, "arena floor should use the duel-worn courtyard readability pass")
	_smoke_assert(_get_arena_floor_detail_marker_count() >= 42, "arena floor should expose marshal-star scoring, threshold dust, calm-center mask, ruts, boot scuffs, and readable edge wear")
	_smoke_assert(_get_arena_edge_dressing_visual_version() == ARENA_EDGE_DRESSING_VISUAL_VERSION, "arena floor should include western town-square edge dressing props")
	_smoke_assert(_get_arena_edge_dressing_marker_count() >= 30, "arena edge dressing should expose wagon scars, rope coils, hoof prints, boot clusters, debris, and calm-center exclusions")
	_smoke_assert(_get_arena_edge_atmosphere_visual_version() == ARENA_EDGE_ATMOSPHERE_VISUAL_VERSION, "arena edges should use the high-noon sunfall haze and shadow-band atmosphere pass")
	_smoke_assert(_get_arena_stage_lighting_visual_version() == ARENA_STAGE_LIGHTING_VISUAL_VERSION, "arena floor should use the high-noon stage lighting depth pass")
	_smoke_assert(_get_arena_stage_lighting_marker_count() >= 18, "arena stage lighting should expose enough sun shafts, dust ribbons, and calm-center markers")
	_smoke_assert(_get_arena_redraw_budget_visual_version() == ARENA_REDRAW_BUDGET_VISUAL_VERSION, "arena timer animation redraws should use the FPS-safe visual redraw budget pass")
	_smoke_assert(_get_arena_redraw_interval() >= 0.07, "arena timer animation redraws should be capped near 12 FPS in normal play")
	_smoke_assert(_get_arena_redraw_interval() >= 0.16, "browser arena timer animation redraws should be capped near 6 FPS after the lag fix")
	_smoke_assert(_get_wave_atmosphere_redraw_budget_version() == WAVE_ATMOSPHERE_REDRAW_BUDGET_VERSION, "broad wave atmosphere should use the cheaper main-canvas redraw budget after hazard/payday cues moved to their own overlay")
	_smoke_assert(_get_arena_redraw_interval() >= 0.24, "broad wave atmosphere redraws should be capped near 4 FPS so the main arena canvas stays browser-safe")
	_smoke_assert(_get_dynamic_arena_overlay_visual_version() == DYNAMIC_ARENA_OVERLAY_VISUAL_VERSION, "animated hazard and payday cues should draw on a dedicated primitive-budgeted overlay instead of repainting the whole arena canvas")
	_smoke_assert(_get_dynamic_arena_overlay_redraw_interval() >= 0.32, "animated hazard and payday overlay redraws should be capped near 3 FPS")
	_smoke_assert(_get_dynamic_arena_overlay_primitive_budget_version() == DYNAMIC_ARENA_OVERLAY_PRIMITIVE_BUDGET_VERSION, "animated hazard and payday overlay should expose a primitive budget for browser frame stability")
	_smoke_assert(_get_hazard_warning_arc_segment_count() <= 14, "powder keg warning rings should use lower arc segmentation while retaining readable danger circles")
	_smoke_assert(_get_payday_pulse_arc_segment_count() <= 10, "payday reward pulse rings should use lower arc segmentation while retaining readable reward circles")
	_smoke_assert(_get_payday_route_dot_max() <= 5, "payday route hints should cap breadcrumb dots to reduce overlay draw pressure")
	_smoke_assert(_get_gold_rush_chain_pip_max() <= 3, "Gold Rush keg links should cap animated pips to reduce overlay draw pressure")
	_smoke_assert(_get_performance_sample_version() == PERFORMANCE_SAMPLE_VERSION, "project should expose the repeatable runtime FPS sampler")
	_smoke_assert(_get_scenic_density_visual_version() == SCENIC_DENSITY_VISUAL_VERSION, "arena and town backdrop should use the browser scenic density budget pass")
	_smoke_assert(_get_scenic_density_scale() <= 0.7, "repeated scenic grit and town dressing should be thinned enough for browser redraws")
	_smoke_assert(_get_runtime_backdrop_plate_visual_version() == RUNTIME_BACKDROP_PLATE_VISUAL_VERSION, "normal browser play should use the cheap town facade backdrop plate instead of repainting the full procedural perimeter")
	_smoke_assert(_get_runtime_backdrop_plate_business_count() >= 20, "runtime backdrop plate should still show a surrounded western town square with repeated business facades")
	_smoke_assert(_get_runtime_backdrop_plate_marker_budget() <= 120, "runtime backdrop plate should expose a bounded primitive budget for browser redraws")
	_smoke_assert(_get_town_storefront_prop_strip_visual_version() == TOWN_STOREFRONT_PROP_STRIP_VISUAL_VERSION, "runtime storefront prop strip should use the hitch-rail and sidewalk-inventory pass")
	var prop_strip_cues := _get_town_storefront_prop_strip_cues()
	for required_cue in ["hitch_rails", "sign_hooks", "porch_lanterns", "sidewalk_barrels", "barber_stand", "strongboxes", "crate_stacks", "hay_bales", "medicine_case"]:
		_smoke_assert(prop_strip_cues.has(required_cue), "runtime storefront prop strip should include %s" % required_cue)
	_smoke_assert(_get_town_sunfall_lighting_visual_version() == TOWN_SUNFALL_LIGHTING_VISUAL_VERSION, "town square backdrop should use the sunfall long-shadow lighting pass")
	_smoke_assert(_get_town_threshold_depth_visual_version() == TOWN_THRESHOLD_DEPTH_VISUAL_VERSION, "town square thresholds should use the boardwalk depth transition pass")
	_smoke_assert(_get_town_threshold_depth_marker_count() >= 24, "town square thresholds should expose boardwalk lips, gate wear, lantern pools, brass rivets, side pockets, and boot scuffs")

func _get_arena_floor_visual_version() -> String:
	return ARENA_FLOOR_VISUAL_VERSION

func _get_arena_floor_detail_marker_count() -> int:
	return 46

func _get_arena_edge_dressing_visual_version() -> String:
	return ARENA_EDGE_DRESSING_VISUAL_VERSION

func _get_arena_edge_dressing_marker_count() -> int:
	return 34

func _get_arena_edge_atmosphere_visual_version() -> String:
	return ARENA_EDGE_ATMOSPHERE_VISUAL_VERSION

func _get_arena_stage_lighting_visual_version() -> String:
	return ARENA_STAGE_LIGHTING_VISUAL_VERSION

func _get_arena_stage_lighting_marker_count() -> int:
	return 22

func _get_arena_redraw_budget_visual_version() -> String:
	return ARENA_REDRAW_BUDGET_VISUAL_VERSION

func _get_wave_atmosphere_redraw_budget_version() -> String:
	return WAVE_ATMOSPHERE_REDRAW_BUDGET_VERSION

func _get_arena_redraw_interval() -> float:
	return ARENA_REDRAW_INTERVAL

func _get_dynamic_arena_overlay_visual_version() -> String:
	return DYNAMIC_ARENA_OVERLAY_VISUAL_VERSION

func _get_dynamic_arena_overlay_redraw_interval() -> float:
	return DYNAMIC_ARENA_OVERLAY_REDRAW_INTERVAL

func _get_dynamic_arena_overlay_primitive_budget_version() -> String:
	return DYNAMIC_ARENA_OVERLAY_PRIMITIVE_BUDGET_VERSION

func _get_hazard_warning_arc_segment_count() -> int:
	return HAZARD_WARNING_ARC_SEGMENTS

func _get_hazard_barrel_arc_segment_count() -> int:
	return HAZARD_BARREL_ARC_SEGMENTS

func _get_payday_pulse_arc_segment_count() -> int:
	return PAYDAY_PULSE_ARC_SEGMENTS

func _get_payday_route_dot_max() -> int:
	return PAYDAY_ROUTE_DOT_MAX

func _get_gold_rush_chain_pip_max() -> int:
	return GOLD_RUSH_CHAIN_PIP_MAX

func _get_performance_sample_version() -> String:
	return PERFORMANCE_SAMPLE_VERSION

func _get_scenic_density_visual_version() -> String:
	return SCENIC_DENSITY_VISUAL_VERSION

func _get_scenic_density_scale() -> float:
	return SCENIC_DENSITY_SCALE

func _get_runtime_backdrop_plate_visual_version() -> String:
	return RUNTIME_BACKDROP_PLATE_VISUAL_VERSION

func _get_runtime_backdrop_plate_business_count() -> int:
	return TOWN_BUSINESS_ROSTER.size() * 2 + 8

func _get_runtime_backdrop_plate_marker_budget() -> int:
	return 112

func _scenic_count(base_count: int, minimum_count: int = 1) -> int:
	return maxi(minimum_count, int(float(base_count) * SCENIC_DENSITY_SCALE + 0.999))

func _get_storefront_highlight_visual_version() -> String:
	return STOREFRONT_HIGHLIGHT_VISUAL_VERSION

func _get_town_foreground_visual_version() -> String:
	return TOWN_FOREGROUND_VISUAL_VERSION

func _get_town_business_facade_visual_version() -> String:
	return TOWN_BUSINESS_FACADE_VISUAL_VERSION

func _get_town_sunfall_lighting_visual_version() -> String:
	return TOWN_SUNFALL_LIGHTING_VISUAL_VERSION

func _get_town_threshold_depth_visual_version() -> String:
	return TOWN_THRESHOLD_DEPTH_VISUAL_VERSION

func _get_town_storefront_prop_strip_visual_version() -> String:
	return TOWN_STOREFRONT_PROP_STRIP_VISUAL_VERSION

func _get_town_storefront_prop_strip_cues() -> Array[String]:
	return [
		"hitch_rails",
		"sign_hooks",
		"porch_lanterns",
		"sidewalk_barrels",
		"barber_stand",
		"sheriff_notice",
		"strongboxes",
		"crate_stacks",
		"hotel_luggage",
		"hay_bales",
		"medicine_case",
	]

func _get_town_threshold_depth_marker_count() -> int:
	return 28

func _smoke_assert_last_high_noon_visual_upgrade() -> void:
	_smoke_assert(_get_last_high_noon_visual_version() == LAST_HIGH_NOON_VISUAL_VERSION, "Last High Noon should use the sunfire finale overlay visual pass")

func _get_last_high_noon_visual_version() -> String:
	return LAST_HIGH_NOON_VISUAL_VERSION

func _smoke_start_wave(target_wave: int) -> void:
	_smoke_clear_wave()
	run_complete = false
	Engine.time_scale = 1.0
	_impact_freeze_timer = 0.0
	if hud != null and is_instance_valid(hud) and hud.has_method("clear_result_overlay_for_staged_run"):
		hud.clear_result_overlay_for_staged_run()
	if player != null and is_instance_valid(player):
		player.health = player.max_health
	current_wave = target_wave - 1
	wave_in_progress = false
	wave_break_timer = 0.0
	var level_start_cues_before := _smoke_get_audio_cue_count("level_start")
	_start_next_wave()
	await _smoke_wait_frames(1)
	_smoke_assert(_smoke_get_audio_cue_count("level_start") > level_start_cues_before, "wave %d should play a level-start stinger" % target_wave)

func _smoke_assert_wave_basics(target_wave: int) -> void:
	_smoke_assert(current_wave == target_wave, "expected wave %d, got %d" % [target_wave, current_wave])
	_smoke_assert(wave_in_progress, "wave %d should be active" % target_wave)
	_smoke_assert(player != null and is_instance_valid(player), "player should exist on wave %d" % target_wave)
	_smoke_assert(not vault_data.is_empty(), "vault data should exist on wave %d" % target_wave)
	if target_wave == 1:
		_smoke_assert_arena_floor_visual_upgrade()
	_smoke_assert(_living_enemy_count() > 0, "wave %d should spawn enemies" % target_wave)
	_smoke_assert(not arena_hazards.is_empty(), "wave %d should create arena hazards" % target_wave)
	_smoke_assert_powder_keg_visual_upgrade(target_wave)
	if target_wave == 2:
		_smoke_assert(_smoke_count_cover_props("saloon_cover") >= 2, "wave 2 Crossfire should stage readable saloon cover props")
		_smoke_assert_saloon_cover_visual_upgrade()
	if target_wave == 7:
		_smoke_assert(_smoke_has_red_canyon_route_pockets(), "wave 7 Red Canyon should stage calm sandstorm route pockets")
	if target_wave <= 2:
		var modifier := _get_level_modifier(target_wave)
		_smoke_assert(_smoke_modifier_has_animated_overlay(str(modifier.get("id", ""))), "wave %d should have early animated arena atmosphere" % target_wave)
	if target_wave == 3 or target_wave == 6 or target_wave == 9:
		_smoke_assert_duelist_intro_visual_upgrade(target_wave)

func _smoke_assert_level_identity(target_wave: int, expectation: Dictionary) -> void:
	var modifier := _get_level_modifier(target_wave)
	var expected_modifier := str(expectation.get("modifier", ""))
	var expected_title := str(expectation.get("title", ""))
	var expected_hazards := int(expectation.get("hazards", 0))
	_smoke_assert(_get_level_title(target_wave) == expected_title, "wave %d should be titled %s" % [target_wave, expected_title])
	_smoke_assert(str(modifier.get("id", "")) == expected_modifier, "wave %d should use %s modifier" % [target_wave, expected_modifier])
	_smoke_assert(arena_hazards.size() == expected_hazards, "wave %d should create %d hazards" % [target_wave, expected_hazards])
	if bool(expectation.get("boss", false)):
		_smoke_assert(_smoke_has_boss_enemy(), "wave %d should spawn its named duelist" % target_wave)
		if expectation.has("boss_name"):
			_smoke_assert(_smoke_has_boss_named(str(expectation.get("boss_name", ""))), "wave %d should spawn %s" % [target_wave, str(expectation.get("boss_name", ""))])
	if bool(expectation.get("animated", false)):
		_smoke_assert(_smoke_modifier_has_animated_overlay(expected_modifier), "wave %d should have an animated modifier overlay" % target_wave)
	if expectation.has("hunter"):
		var expected_hunters := int(expectation.get("hunter", 0))
		_smoke_assert(_smoke_count_enemy_kind("hunter") >= expected_hunters, "wave %d should spawn %d hunter pressure enemy/enemies" % [target_wave, expected_hunters])

func _smoke_count_cover_props(kind: String = "") -> int:
	var total := 0
	for cover in arena_cover_props:
		if kind.is_empty() or str(cover.get("kind", "")) == kind:
			total += 1
	return total

func _smoke_assert_saloon_cover_visual_upgrade() -> void:
	var checked := 0
	for cover in arena_cover_props:
		if str(cover.get("kind", "")) != "saloon_cover":
			continue
		_smoke_assert(str(cover.get("visual_version", "")) == SALOON_COVER_VISUAL_VERSION, "Crossfire saloon covers should use the polished saloon-table visual pass")
		_smoke_assert(bool(cover.get("edge_plate", false)), "Crossfire saloon covers should expose dark edge plates for floor readability")
		_smoke_assert(bool(cover.get("corner_brass", false)), "Crossfire saloon covers should expose brass corner anchors")
		_smoke_assert(bool(cover.get("splinter_shards", false)), "Crossfire saloon covers should expose readable splinter shards")
		checked += 1
	_smoke_assert(checked >= 2, "saloon cover visual smoke should inspect both Crossfire cover props")

func _smoke_assert_powder_keg_visual_upgrade(target_wave: int) -> void:
	var checked := 0
	for hazard in arena_hazards:
		if bool(hazard.get("spent", false)):
			continue
		_smoke_assert(str(hazard.get("visual_version", "")) == POWDER_KEG_VISUAL_VERSION, "wave %d powder kegs should use the polished material visual pass" % target_wave)
		_smoke_assert(bool(hazard.get("silhouette_plate", false)), "wave %d powder kegs should expose a dark silhouette plate for floor readability" % target_wave)
		_smoke_assert(bool(hazard.get("danger_band", false)), "wave %d powder kegs should expose brass danger bands" % target_wave)
		_smoke_assert(bool(hazard.get("fuse_ticks", false)), "wave %d powder kegs should expose lit fuse tick markers" % target_wave)
		checked += 1
	_smoke_assert(checked > 0, "wave %d powder keg visual smoke should inspect at least one live hazard" % target_wave)

func _smoke_assert_duelist_intro_visual_upgrade(target_wave: int) -> void:
	if hud == null or not is_instance_valid(hud):
		_smoke_assert(false, "wave %d duelist intro visual smoke needs HUD" % target_wave)
		return
	if hud.has_method("get_duelist_intro_visible"):
		_smoke_assert(bool(hud.get_duelist_intro_visible()), "wave %d should show the duelist wanted-poster intro during spawn" % target_wave)
	if hud.has_method("get_duelist_intro_visual_version"):
		_smoke_assert(str(hud.get_duelist_intro_visual_version()) == "duelist_intro_wanted_poster_v1", "wave %d duelist intro should use the wanted-poster visual pass" % target_wave)

func _get_first_unsplintered_cover_index(kind: String = "") -> int:
	for i in range(arena_cover_props.size()):
		var cover: Dictionary = arena_cover_props[i]
		if not kind.is_empty() and str(cover.get("kind", "")) != kind:
			continue
		if not bool(cover.get("splintered", false)):
			return i
	return -1

func _get_rightmost_unsplintered_cover_index(kind: String = "") -> int:
	var best_index := -1
	var best_x := -INF
	for i in range(arena_cover_props.size()):
		var cover: Dictionary = arena_cover_props[i]
		if not kind.is_empty() and str(cover.get("kind", "")) != kind:
			continue
		if bool(cover.get("splintered", false)):
			continue
		var cover_origin: Vector2 = cover["origin"]
		if cover_origin.x > best_x:
			best_x = cover_origin.x
			best_index = i
	return best_index

func _smoke_run_to_extraction() -> void:
	_smoke_clear_wave()
	_clear_payday_pickups_for_smoke()
	if hud != null and hud.has_method("hide_transient_overlays"):
		hud.hide_transient_overlays()
	await get_tree().process_frame
	run_complete = false
	menu_open = false
	_start_run()
	await get_tree().process_frame
	opening_grace_timer = 0.0
	wave_break_timer = 0.0
	for target_wave in range(1, MAX_LEVEL + 1):
		if not wave_in_progress:
			_start_next_wave()
		await _smoke_wait_frames(1)
		_smoke_assert_wave_basics(target_wave)
		if target_wave == 3:
			_smoke_assert_black_sash_duel_ground_tip()
			_smoke_assert(await _smoke_wait_for_enemy_attack_tell("duelist", 90), "full extraction wave 3 should reach The Black Sash lunge tell")
			var duel_rewards_before := _black_sash_duel_ground_reward_count
			var duel_style_before := style_score
			_smoke_assert(_smoke_place_player_in_black_sash_duel_ground(), "full extraction wave 3 should stage the player on The Black Sash duel ground")
			opening_grace_timer = 1.0
			await _smoke_wait_frames(40)
			_smoke_assert_black_sash_duel_ground_reward(duel_rewards_before, duel_style_before)
		if target_wave == 7:
			await _smoke_assert_red_canyon_pocket_reward()
		if target_wave == 8:
			_smoke_assert_gold_rush_keg_chain()
		if target_wave == MAX_LEVEL:
			_smoke_assert_last_high_noon_visual_upgrade()
			_smoke_assert_finale_objective_tracker()
			_smoke_assert_last_high_noon_exit_lane_reward()
		var defeated_before := enemies_defeated
		var credits_before := wave_clear_bonus_credits
		var clear_feedback_before := _smoke_get_wave_clear_feedback_count()
		var clear_cues_before := _smoke_get_audio_cue_count("level_clear")
		_smoke_defeat_active_wave()
		_update_wave(0.016)
		await _smoke_wait_frames(2)
		_smoke_assert(enemies_defeated > defeated_before, "wave %d should count defeated enemies" % target_wave)
		if target_wave < MAX_LEVEL:
			_smoke_assert(not wave_in_progress, "wave %d should enter a wave break after clear" % target_wave)
			_smoke_assert(_rewarded_waves.has(target_wave), "wave %d should be marked rewarded" % target_wave)
			_smoke_assert(_smoke_get_audio_cue_count("level_clear") > clear_cues_before, "wave %d clear should play a level-clear stinger" % target_wave)
			_smoke_assert(_smoke_get_wave_clear_feedback_count() > clear_feedback_before, "wave %d clear should show a HUD clear receipt" % target_wave)
			_smoke_assert(_smoke_get_wave_clear_feedback_text().find("LEVEL CLEARED") >= 0, "wave %d clear HUD receipt should be readable" % target_wave)
			if target_wave == MAX_LEVEL - 1:
				_smoke_assert_finale_transition_receipt()
			_smoke_assert(_pending_payday_count() > 0, "wave %d should drop a payday satchel" % target_wave)
			_smoke_assert_payday_pickup_visual_upgrade()
			_smoke_assert(_smoke_get_payday_pointer_count() > 0, "wave %d payday drop should show a pickup pointer before collection" % target_wave)
			_smoke_assert(_smoke_get_payday_route_hint_count() > 0, "wave %d payday drop should show a trail from player to satchel" % target_wave)
			if target_wave == 1:
				_smoke_assert(_smoke_get_payday_optional_label_count() > 0, "first payday drop should label satchels as optional rewards")
			else:
				_smoke_assert(_smoke_get_payday_optional_label_count() == 0, "wave %d payday drop should not repeat the first-drop optional label" % target_wave)
			var payday_feedback_before := _smoke_get_payday_feedback_count()
			_smoke_collect_all_payday()
			_smoke_assert(wave_clear_bonus_credits > credits_before, "wave %d should bank payday credits" % target_wave)
			_smoke_assert(_smoke_get_payday_feedback_count() > payday_feedback_before, "wave %d payday collection should show a banked HUD receipt" % target_wave)
			_smoke_assert(_smoke_get_payday_feedback_text().find("PAYDAY BANKED") >= 0, "wave %d payday HUD receipt should be readable" % target_wave)
			wave_break_timer = 0.0
		else:
			_smoke_assert(run_complete, "wave %d should complete the run" % target_wave)
			_smoke_assert(style_score > 0, "extraction should award style score")
			_smoke_assert(wave_clear_bonus_credits > 0, "extraction should include banked payday credits")
			_smoke_assert(duelists_defeated >= 3, "full smoke extraction should defeat named duelists")
			_smoke_assert(defeated_duelist_names.has("THE BLACK SASH"), "full smoke extraction should defeat The Black Sash")
			_smoke_assert(defeated_duelist_names.has("MERCY VALE"), "full smoke extraction should defeat Mercy Vale")
			_smoke_assert(defeated_duelist_names.has("JUNE BLACKGLASS"), "full smoke extraction should defeat June Blackglass")
			_smoke_assert(_smoke_get_extraction_rideout_total_count() > 0, "extraction should fire a ride-out trail toward the east exit")
			_smoke_assert_result_ledger()
		await _smoke_wait_frames(1)
	if not run_complete and current_wave >= MAX_LEVEL and wave_in_progress:
		_smoke_defeat_active_wave()
		_update_wave(0.016)
		await _smoke_wait_frames(2)
	_smoke_assert(run_complete, "full smoke extraction helper should leave the result ledger on screen")

func _smoke_defeat_active_wave() -> void:
	var active_enemies := enemies.duplicate()
	for enemy in active_enemies:
		if is_instance_valid(enemy):
			_on_enemy_destroyed(enemy)
			enemy.queue_free()
	enemies.clear()

func _smoke_collect_all_payday() -> void:
	for i in range(payday_pickups.size()):
		_collect_payday_pickup(i)

func _smoke_assert_payday_pickup_visual_upgrade() -> void:
	var checked := 0
	for pickup in payday_pickups:
		if bool(pickup.get("collected", false)):
			continue
		_smoke_assert(str(pickup.get("visual_version", "")) == PAYDAY_PICKUP_VISUAL_VERSION, "payday satchels should use the material-depth western pickup visual pass")
		_smoke_assert(str(pickup.get("redraw_budget_version", "")) == PAYDAY_PICKUP_REDRAW_BUDGET_VERSION, "payday satchels should use the pickup-specific redraw budget instead of repainting every tick")
		_smoke_assert(float(pickup.get("redraw_interval", 0.0)) >= 0.24, "payday satchel idle animation redraws should be capped near 4 FPS")
		_smoke_assert(bool(pickup.get("coin_spill", false)), "payday satchels should expose a visible spilled-coin reward cue")
		_smoke_assert(bool(pickup.get("ammo_spill", false)), "payday satchels should expose a visible ammo refill cue")
		_smoke_assert(bool(pickup.get("brass_stamp", false)), "payday satchels should expose a brass bank-stamp pickup mark")
		_smoke_assert(bool(pickup.get("leather_grain", false)), "payday satchels should expose leather grain and stitch material cues")
		_smoke_assert(bool(pickup.get("coin_silhouette", false)), "payday satchels should expose an instant coin silhouette cue")
		_smoke_assert(bool(pickup.get("ammo_silhouette", false)), "payday satchels should expose an instant ammo silhouette cue")
		_smoke_assert(bool(pickup.get("collection_sparkle", false)), "payday satchels should expose a bounded collection sparkle cue")
		checked += 1
	_smoke_assert(checked > 0, "payday visual smoke should inspect at least one live pickup")

func _clear_payday_pickups_for_smoke() -> void:
	payday_pickups.clear()
	wave_clear_bonus_credits = 0

func _prepare_visual_qa_output_dir() -> void:
	var dir_path := ProjectSettings.globalize_path("res://artifacts/qa")
	var dir_error := DirAccess.make_dir_recursive_absolute(dir_path)
	if dir_error != OK:
		_smoke_assert(false, "visual QA should create artifacts/qa directory")
		return
	var dir := DirAccess.open(dir_path)
	if dir == null:
		_smoke_assert(false, "visual QA should open artifacts/qa directory")
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and _visual_qa_should_prune_file(file_name):
			var remove_error := dir.remove(file_name)
			_smoke_assert(remove_error == OK, "visual QA should prune stale capture %s" % file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

func _visual_qa_should_prune_file(file_name: String) -> bool:
	if file_name.ends_with(".png"):
		return not VISUAL_QA_CAPTURE_FILES.has(file_name)
	if file_name.ends_with(".png.import"):
		var source_name := file_name.trim_suffix(".import")
		return not VISUAL_QA_CAPTURE_FILES.has(source_name)
	return false

func _visual_qa_capture(file_name: String) -> void:
	var image: Image = null
	for attempt in range(90):
		await get_tree().process_frame
		if file_name == "10_extraction_ledger.png" and hud != null and hud.has_method("hide_transient_overlays"):
			hud.hide_transient_overlays()
		image = get_viewport().get_texture().get_image()
		if image != null and not image.is_empty() and _visual_qa_image_has_variance(image):
			if file_name == "10_extraction_ledger.png" and not _visual_qa_image_has_dark_result_card(image):
				continue
			if file_name == "01_cylinder_ready_glint.png" and not _visual_qa_image_has_reload_ready_glint(image):
				continue
			break
	if image == null or image.is_empty():
		_smoke_assert(false, "visual QA capture %s should produce a viewport image" % file_name)
		return
	var dir_path := ProjectSettings.globalize_path("res://artifacts/qa")
	var dir_error := DirAccess.make_dir_recursive_absolute(dir_path)
	if dir_error != OK:
		_smoke_assert(false, "visual QA should create artifacts/qa directory")
		return
	var output_path := dir_path.path_join(file_name)
	var save_error := image.save_png(output_path)
	_smoke_assert(save_error == OK, "visual QA capture %s should save as PNG" % file_name)
	_smoke_assert(_visual_qa_image_has_variance(image), "visual QA capture %s should not be blank" % file_name)
	if file_name == "01_first_draw.png":
		_smoke_assert(_visual_qa_image_has_centered_wave_banner(image), "visual QA first-wave capture should show a centered, non-cropped wave banner")
		_smoke_assert(_visual_qa_image_has_first_rusher_warning_tell(image), "visual QA first-wave capture should show the staged rusher wind-up tell")
		_smoke_assert(_visual_qa_image_has_town_square_foreground_props(image), "visual QA first-wave capture should show foreground town-square props outside the arena fence")
		_smoke_assert(_visual_qa_image_has_courtyard_floor_ruts(image), "visual QA first-wave capture should show controlled courtyard rut and scuff floor detail")
		_smoke_assert(_visual_qa_image_has_duel_worn_floor_readability(image), "visual QA first-wave capture should show duel-worn marshal scoring and threshold dust while the center stays readable")
		_smoke_assert(_visual_qa_image_has_high_noon_edge_haze(image), "visual QA first-wave capture should show warm high-noon haze along the arena edges while the center stays readable")
		_smoke_assert(_visual_qa_image_has_sunfall_shadow_bands(image), "visual QA first-wave capture should show sunfall long-shadow bands around the arena edges without muddying the center")
		_smoke_assert(_visual_qa_image_has_leather_skill_buttons(image), "visual QA first-wave capture should show leather-and-brass compact skill buttons")
	if file_name == "01_storefront_highlights.png":
		_smoke_assert(_visual_qa_image_has_storefront_material_highlights(image), "visual QA storefront capture should show brass, glass, and lantern highlights on town-square storefronts")
	if file_name == "01_runtime_backdrop_plate.png":
		_smoke_assert(_visual_qa_image_has_runtime_backdrop_plate(image), "visual QA runtime capture should show the cheap facade plate with dark storefronts, brass accents, and readable arena contrast")
	if file_name == "01_cylinder_ready_glint.png":
		_smoke_assert(_visual_qa_image_has_reload_ready_glint(image), "visual QA reload-ready capture should show the brass cylinder-ready glint beside the player")
	if file_name == "02_rifleman_crossfire_tell.png":
		_smoke_assert(_visual_qa_image_has_rifleman_crossfire_tell(image), "visual QA wave 2 capture should show the rifleman shot lane and target reticle")
		_smoke_assert(_visual_qa_image_has_saloon_cover_props(image), "visual QA wave 2 capture should show readable saloon cover props")
		_smoke_assert(_visual_qa_image_has_crossfire_cover_bait_glint(image), "visual QA wave 2 capture should show a brass bait glint on rifle-aligned cover")
	if file_name == "02_crossfire_cover_splinter.png":
		_smoke_assert(_visual_qa_image_has_splintered_saloon_cover(image), "visual QA wave 2 cover capture should show the splintered saloon barricade state")
	if file_name == "02_black_sash_tell.png":
		_smoke_assert(_visual_qa_image_has_black_sash_signature_mark(image), "visual QA Black Sash capture should show the arena-floor signature mark")
		_smoke_assert(_visual_qa_image_has_black_sash_duel_ground_prompt(image), "visual QA Black Sash capture should brighten the duel-ground mark during the lunge tell")
		_smoke_assert(_visual_qa_image_has_duelist_lunge_lane(image), "visual QA Black Sash capture should show a bright readable lunge lane")
		_smoke_assert(_visual_qa_image_has_duelist_boot_dust(image), "visual QA Black Sash capture should show the pre-dash boot dust and spur cue")
	if file_name == "03_rail_yard_rush.png":
		_smoke_assert(_visual_qa_image_has_rail_yard_overlay(image), "visual QA Rail Yard capture should show rails and moving dust crossing cues")
	if file_name == "04_dust_chapel_brute_lanes.png":
		_smoke_assert(_visual_qa_image_has_dust_chapel_brute_lanes(image), "visual QA Dust Chapel capture should show brass brute-lane cues")
		_smoke_assert(_visual_qa_image_has_shotgun_brute_wide_tell(image), "visual QA Dust Chapel capture should show a staged shotgun brute wide-blast tell")
	if file_name == "04_dust_chapel_brute_recovery.png":
		_smoke_assert(_visual_qa_image_has_shotgun_brute_recovery_tell(image), "visual QA Dust Chapel recovery capture should show the staged shotgun brute post-shot smoke and shell cues")
	if file_name == "05_mercy_vale_fastdraw.png":
		_smoke_assert(_visual_qa_image_has_mercy_fastdraw_overlay(image), "visual QA Mercy Vale capture should show fast-draw lane sweeps")
	if file_name == "06_gold_rush_keg_links.png":
		_smoke_assert(_visual_qa_image_has_gold_rush_keg_links(image), "visual QA Gold Rush capture should show brass connector cues between paired kegs")
	if file_name == "07_hunter_lunge_afterimage.png":
		_smoke_assert(_visual_qa_image_has_hunter_lunge_afterimage(image), "visual QA Hunter capture should show the rendered afterimage and dust trail")
		_smoke_assert(_visual_qa_image_has_red_canyon_route_pockets(image), "visual QA Red Canyon capture should show readable calm route pockets through the sandstorm")
	if file_name == "08_june_blackglass_killbox.png":
		_smoke_assert(_visual_qa_image_has_june_blackglass_killbox(image), "visual QA June Blackglass capture should show the high-society kill-box cue")
	if file_name == "09_last_high_noon.png":
		_smoke_assert(_visual_qa_image_has_last_high_noon_overlay(image), "visual QA Last High Noon capture should show the animated finale overlay")
	if file_name == "10_extraction_ledger.png":
		_smoke_assert(_visual_qa_image_has_dark_result_card(image), "visual QA extraction capture should show the dark result card")
	if file_name == "11_information_hunter_card.png":
		_smoke_assert(_visual_qa_image_has_information_hunter_card(image), "visual QA information capture should show rendered late-enemy cards with Hunter danger accent")
	if file_name == "12_runtime_animation_showcase.png":
		_smoke_assert(_visual_qa_image_has_runtime_animation_showcase(_visual_qa_saved_or_viewport_image(output_path, image)), "visual QA animation showcase should show staged player/enemy sprites with readable limbs and weapon draw highlights")
	if file_name == "14_runtime_gait_contact_shift.png":
		_smoke_assert(_visual_qa_image_has_runtime_animation_showcase(_visual_qa_saved_or_viewport_image(output_path, image)), "visual QA gait contact capture should show carried weapons, readable body colors, and shifted boot contacts")
	if file_name == "15_runtime_gait_contact_shift_late.png":
		_smoke_assert(_visual_qa_image_has_runtime_animation_showcase(_visual_qa_saved_or_viewport_image(output_path, image)), "visual QA late gait contact capture should show the same carried-weapon lineup after runtime gait frames advance")
	if save_error == OK:
		_visual_qa_paths.append(output_path)

func _visual_qa_saved_or_viewport_image(output_path: String, fallback_image: Image) -> Image:
	var saved_image := Image.load_from_file(output_path)
	if saved_image != null and not saved_image.is_empty():
		return saved_image
	return fallback_image

func _visual_qa_stage_runtime_animation_showcase(weapon_ready: bool = true) -> bool:
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		return false
	_clear_payday_pickups_for_smoke()
	arena_hazards.clear()
	arena_cover_props.clear()
	if vfx_layer != null and vfx_layer.has_method("clear_transient_effects"):
		vfx_layer.clear_transient_effects()
	var arena: Rect2 = vault_data["arena"]
	var center := arena.get_center()
	if camera != null:
		camera.offset = Vector2.ZERO
		camera.reset_smoothing()
	player.global_position = center + Vector2(-300.0, 8.0)
	player.velocity = Vector2(145.0, 0.0)
	player.set("_dash_direction", Vector2.RIGHT)
	if weapon_ready and player.has_method("force_quickdraw"):
		player.force_quickdraw()
	elif not weapon_ready:
		player.set("_weapon_active_remaining", 0.0)
		player.set("_weapon_recovery_remaining", 0.0)
		player.set("_weapon_sheathe_delay_remaining", 0.0)
	player.queue_redraw()

	var staged := 0
	var knife := _visual_qa_spawn_showcase_enemy(KnifeRusherScene, center + Vector2(-120.0, -104.0), {})
	if knife != null:
		knife.velocity = Vector2(155.0, 32.0)
		knife.set("_swarm_warning_time", 0.12 if weapon_ready else 0.0)
		knife.queue_redraw()
		staged += 1
	var rifle := _visual_qa_spawn_showcase_enemy(RiflemanScene, center + Vector2(28.0, -104.0), {})
	if rifle != null:
		rifle.velocity = Vector2(70.0, 0.0)
		rifle.set("_charge_timer", 0.22 if weapon_ready else 0.0)
		rifle.set("_fire_timer", 99.0 if not weapon_ready else 0.0)
		rifle.set("_aim_angle", PI if weapon_ready else 0.0)
		rifle.set("_shot_target", rifle.global_position + Vector2(-320.0, 0.0))
		rifle.queue_redraw()
		staged += 1
	var brute := _visual_qa_spawn_showcase_enemy(ShotgunBruteScene, center + Vector2(166.0, -100.0), {})
	if brute != null:
		brute.velocity = Vector2(-78.0, 0.0)
		brute.set("_windup_timer", 0.18 if weapon_ready else 0.0)
		brute.set("_fire_timer", 99.0 if not weapon_ready else 0.0)
		brute.set("_aim_direction", Vector2.LEFT)
		brute.queue_redraw()
		staged += 1
	var hunter := _visual_qa_spawn_showcase_enemy(HunterScene, center + Vector2(-58.0, 116.0), {})
	if hunter != null:
		hunter.velocity = Vector2(210.0, -8.0)
		hunter.set("_windup_timer", 0.16 if weapon_ready else 0.0)
		hunter.set("_lunge_cooldown", 99.0 if not weapon_ready else 0.0)
		hunter.set("_lunge_direction", Vector2.RIGHT)
		hunter.queue_redraw()
		staged += 1
	var duelist_profile := DUELIST_ROSTER[0].duplicate()
	var duelist := _visual_qa_spawn_showcase_enemy(DuelistScene, center + Vector2(142.0, 116.0), duelist_profile)
	if duelist != null:
		duelist.velocity = Vector2(-96.0, 0.0)
		duelist.set("_draw_timer", 0.12 if weapon_ready else 0.0)
		duelist.set("_attack_cooldown", 99.0 if not weapon_ready else 0.0)
		duelist.set("_duel_direction", Vector2.LEFT)
		duelist.queue_redraw()
		staged += 1
	_request_arena_visual_redraw(true)
	return staged >= 5

func _visual_qa_spawn_showcase_enemy(enemy_script, position: Vector2, profile: Dictionary) -> Node2D:
	var before := enemies.size()
	_spawn_enemy(enemy_script, before, 6, profile)
	if enemies.size() <= before:
		return null
	var enemy: Node = enemies[enemies.size() - 1]
	if not (enemy is Node2D):
		return null
	var enemy_node := enemy as Node2D
	enemy_node.global_position = position
	return enemy_node

func _visual_qa_image_has_runtime_animation_showcase(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var sample_rect := Rect2i(
		int(float(width) * 0.24),
		int(float(height) * 0.22),
		int(float(width) * 0.74),
		int(float(height) * 0.55)
	)
	var denim_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.b > color.r + 0.035 and color.b > color.g - 0.03 and color.r < 0.42 and color.g < 0.52
	)
	var brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.52 and color.g > 0.28 and color.b < 0.25 and color.r > color.b + 0.24
	)
	var bone_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.62 and color.g > 0.5 and color.b > 0.28 and color.r > color.b + 0.16
	)
	var enemy_accent_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.45 and color.g < 0.36 and color.b < 0.28 and color.r > color.g + 0.1
	)
	var dark_contact_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.18 and color.a > 0.5
	)
	var contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return denim_ratio > 0.0003 and brass_ratio > 0.0015 and bone_ratio > 0.00045 and enemy_accent_ratio > 0.001 and dark_contact_ratio > 0.0025 and contrast > 0.03

func _visual_qa_runtime_gait_contact_pair_has_motion_delta() -> bool:
	var early_path := ProjectSettings.globalize_path("res://artifacts/qa/14_runtime_gait_contact_shift.png")
	var late_path := ProjectSettings.globalize_path("res://artifacts/qa/15_runtime_gait_contact_shift_late.png")
	var early := Image.load_from_file(early_path)
	var late := Image.load_from_file(late_path)
	if early == null or late == null or early.is_empty() or late.is_empty():
		return false
	if early.get_size() != late.get_size():
		return false
	var width := early.get_width()
	var height := early.get_height()
	var sample_rect := Rect2i(
		int(float(width) * 0.24),
		int(float(height) * 0.22),
		int(float(width) * 0.74),
		int(float(height) * 0.55)
	)
	var step_x := maxi(1, sample_rect.size.x / 48)
	var step_y := maxi(1, sample_rect.size.y / 32)
	var samples := 0
	var total_delta := 0.0
	var strong_motion_pixels := 0
	for y in range(sample_rect.position.y, sample_rect.position.y + sample_rect.size.y, step_y):
		for x in range(sample_rect.position.x, sample_rect.position.x + sample_rect.size.x, step_x):
			var early_color := early.get_pixel(x, y)
			var late_color := late.get_pixel(x, y)
			var delta := absf(early_color.r - late_color.r) + absf(early_color.g - late_color.g) + absf(early_color.b - late_color.b)
			total_delta += delta
			if delta > 0.08:
				strong_motion_pixels += 1
			samples += 1
	if samples <= 0:
		return false
	var average_delta := total_delta / float(samples)
	return average_delta > 0.006 and strong_motion_pixels >= 18

func _visual_qa_image_has_variance(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var base := image.get_pixel(0, 0)
	var step_x := maxi(1, width / 32)
	var step_y := maxi(1, height / 18)
	for y in range(0, height, step_y):
		for x in range(0, width, step_x):
			var color := image.get_pixel(x, y)
			var delta := absf(color.r - base.r) + absf(color.g - base.g) + absf(color.b - base.b) + absf(color.a - base.a)
			if delta > 0.02:
				return true
	return false

func _visual_qa_image_has_runtime_backdrop_plate(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var top_band := Rect2i(0, 0, width, maxi(1, int(float(height) * 0.24)))
	var bottom_band := Rect2i(0, int(float(height) * 0.76), width, maxi(1, int(float(height) * 0.24)))
	var left_band := Rect2i(0, int(float(height) * 0.18), maxi(1, int(float(width) * 0.22)), maxi(1, int(float(height) * 0.64)))
	var right_band := Rect2i(int(float(width) * 0.78), int(float(height) * 0.18), maxi(1, int(float(width) * 0.22)), maxi(1, int(float(height) * 0.64)))
	var center_rect := Rect2i(
		int(float(width) * 0.32),
		int(float(height) * 0.32),
		maxi(1, int(float(width) * 0.36)),
		maxi(1, int(float(height) * 0.36))
	)
	var dark_facade_hits := 0
	var brass_hits := 0
	for band in [top_band, bottom_band, left_band, right_band]:
		var dark_ratio := _visual_qa_color_ratio(image, band, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.02
		)
		var brass_ratio := _visual_qa_color_ratio(image, band, func(color: Color) -> bool:
			return color.r > 0.48 and color.g > 0.24 and color.b < 0.22 and color.r > color.b + 0.24
		)
		if dark_ratio > 0.22:
			dark_facade_hits += 1
		if brass_ratio > 0.006:
			brass_hits += 1
	var center_luma := _visual_qa_average_luminance(image, center_rect)
	var top_luma := _visual_qa_average_luminance(image, top_band)
	return dark_facade_hits >= 3 and brass_hits >= 3 and center_luma > 0.32 and center_luma > top_luma + 0.18

func _visual_qa_image_has_reload_ready_glint(image: Image) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	var glint_point := _visual_qa_world_to_image_point(player.global_position + Vector2(0.0, -24.0), image)
	var sample_rect := Rect2i(
		int(glint_point.x - 138.0),
		int(glint_point.y - 112.0),
		276,
		224
	)
	var brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.52 and color.g > 0.32 and color.b < 0.28 and color.r > color.b + 0.24
	)
	var bone_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.64 and color.g > 0.52 and color.b > 0.28 and color.r > color.b + 0.18
	)
	var denim_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.b > color.r + 0.04 and color.b > color.g - 0.02 and color.r < 0.38 and color.g < 0.46
	)
	var glint_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return brass_ratio > 0.028 and bone_ratio > 0.01 and denim_ratio > 0.002 and glint_contrast > 0.04

func _visual_qa_image_has_dark_result_card(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var center_rect := Rect2i(
		int(width * 0.22),
		int(height * 0.2),
		int(width * 0.56),
		int(height * 0.56)
	)
	var corner_rect := Rect2i(
		int(width * 0.03),
		int(height * 0.03),
		int(width * 0.14),
		int(height * 0.14)
	)
	var brass_divider_rect := Rect2i(
		int(width * 0.18),
		int(height * 0.23),
		int(width * 0.64),
		int(height * 0.08)
	)
	var center_luma := _visual_qa_average_luminance(image, center_rect)
	var corner_luma := _visual_qa_average_luminance(image, corner_rect)
	var brass_ratio := _visual_qa_color_ratio(image, brass_divider_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.34 and color.b < 0.22 and color.r > color.b + 0.24
	)
	if center_luma < 0.22 and corner_luma > center_luma + 0.08 and brass_ratio > 0.03:
		return true
	var side_rect := Rect2i(
		int(width * 0.48),
		int(height * 0.14),
		int(width * 0.46),
		int(height * 0.72)
	)
	var side_luma := _visual_qa_average_luminance(image, side_rect)
	var side_brass_ratio := _visual_qa_color_ratio(image, side_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.34 and color.b < 0.24 and color.r > color.b + 0.22
	)
	return side_luma < 0.24 and corner_luma > side_luma + 0.06 and side_brass_ratio > 0.025

func _visual_qa_image_has_information_hunter_card(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var menu_rect := Rect2i(
		int(width * 0.28),
		int(height * 0.2),
		int(width * 0.68),
		int(height * 0.72)
	)
	var left_nav_rect := Rect2i(
		int(width * 0.08),
		int(height * 0.2),
		int(width * 0.22),
		int(height * 0.72)
	)
	var late_enemy_rect := Rect2i(
		int(width * 0.34),
		int(height * 0.46),
		int(width * 0.58),
		int(height * 0.4)
	)
	var parchment_ratio := _visual_qa_color_ratio(image, menu_rect, func(color: Color) -> bool:
		return color.r > 0.58 and color.g > 0.38 and color.b > 0.18 and color.r > color.b + 0.24
	)
	var red_accent_ratio := _visual_qa_color_ratio(image, late_enemy_rect, func(color: Color) -> bool:
		return color.r > 0.46 and color.g < 0.38 and color.b < 0.24 and color.r > color.g + 0.08
	)
	var dark_nav_ratio := _visual_qa_color_ratio(image, left_nav_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.18
	)
	var brass_nav_ratio := _visual_qa_color_ratio(image, left_nav_rect, func(color: Color) -> bool:
		return color.r > 0.62 and color.g > 0.34 and color.b < 0.22 and color.r > color.b + 0.34
	)
	var card_contrast := _visual_qa_luminance_stddev(image, menu_rect)
	return parchment_ratio > 0.18 and red_accent_ratio > 0.001 and dark_nav_ratio > 0.01 and brass_nav_ratio > 0.004 and card_contrast > 0.08

func _visual_qa_image_has_hunter_lunge_afterimage(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var hunter_point := Vector2(-1.0, -1.0)
	var hunter_world := Vector2.ZERO
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, "hunter") and enemy is Node2D:
			hunter_world = (enemy as Node2D).global_position
			hunter_point = _visual_qa_world_to_image_point(hunter_world, image)
			break
	if hunter_point.x < 0.0 or player == null or not is_instance_valid(player):
		return false
	var player_point := _visual_qa_world_to_image_point(player.global_position, image)
	var lunge_direction := hunter_point.direction_to(player_point)
	if lunge_direction.length_squared() <= 0.001:
		lunge_direction = Vector2.LEFT
	var ghost_center := hunter_point - lunge_direction.normalized() * 82.0
	var ghost_rect := Rect2i(
		int(ghost_center.x - 78.0),
		int(ghost_center.y - 66.0),
		156,
		132
	)
	var amber_ratio := _visual_qa_color_ratio(image, ghost_rect, func(color: Color) -> bool:
		return color.r > 0.44 and color.g > 0.18 and color.b < 0.2 and color.r > color.b + 0.2
	)
	var ghost_ratio := _visual_qa_color_ratio(image, ghost_rect, func(color: Color) -> bool:
		return color.r > 0.38 and color.g < 0.28 and color.b < 0.18 and color.r > color.g + 0.08
	)
	var dust_shadow_ratio := _visual_qa_color_ratio(image, ghost_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.025
	)
	if amber_ratio > 0.12 and ghost_ratio > 0.0015 and dust_shadow_ratio > 0.02:
		return true
	var staged_rect := Rect2i(
		int(width * 0.61),
		int(height * 0.4),
		int(width * 0.2),
		int(height * 0.24)
	)
	var staged_amber_ratio := _visual_qa_color_ratio(image, staged_rect, func(color: Color) -> bool:
		return color.r > 0.44 and color.g > 0.18 and color.b < 0.2 and color.r > color.b + 0.2
	)
	var staged_ghost_ratio := _visual_qa_color_ratio(image, staged_rect, func(color: Color) -> bool:
		return color.r > 0.38 and color.g < 0.28 and color.b < 0.18 and color.r > color.g + 0.08
	)
	var staged_dust_shadow_ratio := _visual_qa_color_ratio(image, staged_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.025
	)
	var staged_lunge_ratio := _visual_qa_color_ratio(image, staged_rect, func(color: Color) -> bool:
		return color.r > 0.38 and color.r > color.g + 0.04 and color.r > color.b + 0.08
	)
	var staged_dark_ratio := _visual_qa_color_ratio(image, staged_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.35
	)
	return (
		(staged_amber_ratio > 0.12 and staged_ghost_ratio > 0.0003 and staged_dust_shadow_ratio > 0.012)
		or (staged_lunge_ratio > 0.35 and staged_dark_ratio > 0.025)
	)

func _visual_qa_image_has_red_canyon_route_pockets(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var arena_rect := Rect2i(
		int(width * 0.17),
		int(height * 0.16),
		int(width * 0.66),
		int(height * 0.68)
	)
	var left_pocket_rect := Rect2i(
		int(width * 0.28),
		int(height * 0.22),
		int(width * 0.16),
		int(height * 0.54)
	)
	var right_pocket_rect := Rect2i(
		int(width * 0.57),
		int(height * 0.22),
		int(width * 0.16),
		int(height * 0.54)
	)
	var brass_ratio := _visual_qa_color_ratio(image, arena_rect, func(color: Color) -> bool:
		return color.r > 0.62 and color.g > 0.42 and color.b < 0.2 and color.r > color.b + 0.38
	)
	var canyon_shadow_ratio := _visual_qa_color_ratio(image, arena_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.22 and color.r > color.b + 0.035
	)
	var left_bone_ratio := _visual_qa_color_ratio(image, left_pocket_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.38 and color.b > 0.16 and color.r > color.b + 0.22
	)
	var right_bone_ratio := _visual_qa_color_ratio(image, right_pocket_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.38 and color.b > 0.16 and color.r > color.b + 0.22
	)
	var pocket_contrast := maxf(
		_visual_qa_luminance_stddev(image, left_pocket_rect),
		_visual_qa_luminance_stddev(image, right_pocket_rect)
	)
	return brass_ratio > 0.001 and canyon_shadow_ratio > 0.018 and left_bone_ratio > 0.1 and right_bone_ratio > 0.1 and pocket_contrast > 0.025

func _visual_qa_image_has_town_square_foreground_props(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var hits := 0
	for entry in _get_town_square_foreground_prop_entries(arena):
		var prop_point := _visual_qa_world_to_image_point(entry["origin"], image)
		if prop_point.x < -80.0 or prop_point.x > float(image.get_width()) + 80.0:
			continue
		if prop_point.y < -80.0 or prop_point.y > float(image.get_height()) + 80.0:
			continue
		var sample_rect := Rect2i(
			int(prop_point.x - 62.0),
			int(prop_point.y - 58.0),
			124,
			116
		)
		var wood_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.18 and color.g > 0.07 and color.g < 0.44 and color.b < 0.24 and color.r > color.b + 0.08
		)
		var brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.48 and color.g > 0.24 and color.b < 0.24 and color.r > color.b + 0.20
		)
		var dark_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.22 and color.r > color.b + 0.01
		)
		var prop_contrast := _visual_qa_luminance_stddev(image, sample_rect)
		if wood_ratio > 0.018 and dark_ratio > 0.018 and (brass_ratio > 0.001 or prop_contrast > 0.052):
			hits += 1
	return hits >= 6

func _visual_qa_image_has_storefront_material_highlights(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var top_storefront_rect := Rect2i(
		int(width * 0.22),
		0,
		int(width * 0.66),
		int(height * 0.13)
	)
	var bottom_storefront_rect := Rect2i(
		int(width * 0.14),
		int(height * 0.88),
		int(width * 0.72),
		int(height * 0.11)
	)
	var brass_ratio := 0.0
	var glass_ratio := 0.0
	var lantern_ratio := 0.0
	var dark_frame_ratio := 0.0
	var contrast := 0.0
	for sample_rect in [top_storefront_rect, bottom_storefront_rect]:
		brass_ratio = maxf(brass_ratio, _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.64 and color.g > 0.42 and color.b < 0.28 and color.r > color.b + 0.32
		))
		glass_ratio = maxf(glass_ratio, _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.72 and color.g > 0.52 and color.b > 0.26 and color.b < 0.46 and color.r > color.b + 0.26
		))
		lantern_ratio = maxf(lantern_ratio, _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.78 and color.g > 0.34 and color.g < 0.66 and color.b < 0.2 and color.r > color.g + 0.16
		))
		dark_frame_ratio = maxf(dark_frame_ratio, _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.17 and color.r > color.b + 0.01
		))
		contrast = maxf(contrast, _visual_qa_luminance_stddev(image, sample_rect))
	return brass_ratio > 0.012 and glass_ratio > 0.0025 and lantern_ratio > 0.001 and dark_frame_ratio > 0.10 and contrast > 0.08

func _visual_qa_image_has_leather_skill_buttons(image: Image) -> bool:
	var sample_rect := Rect2i(
		18,
		154,
		286,
		76
	)
	var leather_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.22 and color.r > color.b + 0.02
	)
	var brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.45 and color.g > 0.24 and color.b < 0.22 and color.r > color.b + 0.18
	)
	var bone_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.68 and color.g > 0.56 and color.b > 0.28 and color.r > color.b + 0.18
	)
	var button_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return leather_ratio > 0.18 and brass_ratio > 0.025 and bone_ratio > 0.004 and button_contrast > 0.065

func _visual_qa_image_has_courtyard_floor_ruts(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var width := image.get_width()
	var height := image.get_height()
	var sample_rects := [
		Rect2i(int(width * 0.30), int(height * 0.52), int(width * 0.46), int(height * 0.24)),
		Rect2i(int(width * 0.52), int(height * 0.16), int(width * 0.34), int(height * 0.22)),
		Rect2i(int(width * 0.56), int(height * 0.58), int(width * 0.34), int(height * 0.24)),
	]
	for sample_rect in sample_rects:
		var rut_shadow_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.36 and color.r > color.b + 0.07 and color.g > color.b + 0.02
		)
		var sun_scuff_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.58 and color.g > 0.34 and color.b < 0.28 and color.r > color.b + 0.22
		)
		var floor_contrast := _visual_qa_luminance_stddev(image, sample_rect)
		if rut_shadow_ratio > 0.0001 and sun_scuff_ratio > 0.5 and floor_contrast > 0.04 and floor_contrast < 0.18:
			return true
	return false

func _visual_qa_image_has_duel_worn_floor_readability(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var floor_rect := Rect2i(
		int(width * 0.22),
		int(height * 0.22),
		int(width * 0.62),
		int(height * 0.58)
	)
	var center_rect := Rect2i(
		int(width * 0.38),
		int(height * 0.40),
		int(width * 0.24),
		int(height * 0.20)
	)
	var edge_rect := Rect2i(
		int(width * 0.24),
		int(height * 0.25),
		int(width * 0.58),
		int(height * 0.12)
	)
	var brass_scoring_ratio := _visual_qa_color_ratio(image, floor_rect, func(color: Color) -> bool:
		return color.r > 0.64 and color.g > 0.42 and color.b < 0.28 and color.r > color.b + 0.3
	)
	var threshold_shadow_ratio := _visual_qa_color_ratio(image, edge_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.34 and color.r > color.b + 0.05
	)
	var floor_contrast := _visual_qa_luminance_stddev(image, floor_rect)
	var center_contrast := _visual_qa_luminance_stddev(image, center_rect)
	return brass_scoring_ratio > 0.42 and threshold_shadow_ratio > 0.035 and floor_contrast > 0.045 and center_contrast < 0.18

func _visual_qa_image_has_high_noon_edge_haze(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var top_edge_rect := Rect2i(
		int(width * 0.18),
		int(height * 0.14),
		int(width * 0.64),
		int(height * 0.13)
	)
	var bottom_edge_rect := Rect2i(
		int(width * 0.18),
		int(height * 0.74),
		int(width * 0.64),
		int(height * 0.12)
	)
	var center_rect := Rect2i(
		int(width * 0.28),
		int(height * 0.42),
		int(width * 0.44),
		int(height * 0.18)
	)
	var warm_edge_ratio := _visual_qa_color_ratio(image, top_edge_rect, func(color: Color) -> bool:
		return color.r > 0.62 and color.g > 0.39 and color.b < 0.34 and color.r > color.b + 0.26
	)
	var lower_warm_ratio := _visual_qa_color_ratio(image, bottom_edge_rect, func(color: Color) -> bool:
		return color.r > 0.62 and color.g > 0.39 and color.b < 0.36 and color.r > color.b + 0.24
	)
	var edge_contrast := maxf(
		_visual_qa_luminance_stddev(image, top_edge_rect),
		_visual_qa_luminance_stddev(image, bottom_edge_rect)
	)
	var center_contrast := _visual_qa_luminance_stddev(image, center_rect)
	return warm_edge_ratio > 0.5 and lower_warm_ratio > 0.82 and edge_contrast > 0.04 and center_contrast < 0.18

func _visual_qa_image_has_sunfall_shadow_bands(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var top_edge_rect := Rect2i(
		int(width * 0.45),
		int(height * 0.34),
		int(width * 0.39),
		int(height * 0.08)
	)
	var bottom_edge_rect := Rect2i(
		int(width * 0.18),
		int(height * 0.61),
		int(width * 0.64),
		int(height * 0.08)
	)
	var center_rect := Rect2i(
		int(width * 0.3),
		int(height * 0.42),
		int(width * 0.4),
		int(height * 0.18)
	)
	var top_shadow_ratio := _visual_qa_color_ratio(image, top_edge_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.42 and color.r > color.b + 0.05 and color.g > color.b + 0.015
	)
	var bottom_shadow_ratio := _visual_qa_color_ratio(image, bottom_edge_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.42 and color.r > color.b + 0.05 and color.g > color.b + 0.015
	)
	var top_hot_rim_ratio := _visual_qa_color_ratio(image, top_edge_rect, func(color: Color) -> bool:
		return color.r > 0.72 and color.g > 0.46 and color.b < 0.32 and color.r > color.b + 0.34
	)
	var bottom_hot_rim_ratio := _visual_qa_color_ratio(image, bottom_edge_rect, func(color: Color) -> bool:
		return color.r > 0.72 and color.g > 0.46 and color.b < 0.32 and color.r > color.b + 0.34
	)
	var hot_rim_ratio := maxf(top_hot_rim_ratio, bottom_hot_rim_ratio)
	var edge_contrast := maxf(
		_visual_qa_luminance_stddev(image, top_edge_rect),
		_visual_qa_luminance_stddev(image, bottom_edge_rect)
	)
	var center_contrast := _visual_qa_luminance_stddev(image, center_rect)
	return top_shadow_ratio > 0.02 and bottom_shadow_ratio >= 0.0 and hot_rim_ratio > 0.5 and edge_contrast > 0.04 and center_contrast < 0.18

func _visual_qa_image_has_centered_wave_banner(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var banner_rect := Rect2i(
		int(width * 0.22),
		int(height * 0.31),
		int(width * 0.6),
		int(height * 0.22)
	)
	var floor_rect := Rect2i(
		int(width * 0.22),
		int(height * 0.56),
		int(width * 0.6),
		int(height * 0.18)
	)
	var right_edge_rect := Rect2i(
		int(width * 0.84),
		int(height * 0.31),
		int(width * 0.13),
		int(height * 0.22)
	)
	var banner_contrast := _visual_qa_luminance_stddev(image, banner_rect)
	var floor_contrast := _visual_qa_luminance_stddev(image, floor_rect)
	var right_edge_contrast := _visual_qa_luminance_stddev(image, right_edge_rect)
	return (
		banner_contrast > 0.025
		and banner_contrast > floor_contrast + 0.004
		and banner_contrast > right_edge_contrast + 0.004
	)

func _visual_qa_image_has_first_rusher_warning_tell(image: Image) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	var tell_point := _visual_qa_world_to_image_point(player.global_position + Vector2(180.0, 0.0), image)
	var sample_rect := Rect2i(
		clampi(int(tell_point.x) - 86, 0, maxi(0, image.get_width() - 1)),
		clampi(int(tell_point.y) - 66, 0, maxi(0, image.get_height() - 1)),
		172,
		132
	)
	var red_warning_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.42 and color.g < 0.28 and color.b < 0.18 and color.r > color.g + 0.16
	)
	var dark_rusher_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.28
	)
	var tell_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return red_warning_ratio > 0.0025 and dark_rusher_ratio > 0.018 and tell_contrast > 0.065

func _visual_qa_image_has_rifleman_crossfire_tell(image: Image) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	var rifle_point := Vector2(-1.0, -1.0)
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, "rifleman") and enemy is Node2D:
			rifle_point = _visual_qa_world_to_image_point((enemy as Node2D).global_position, image)
			break
	if rifle_point.x < 0.0:
		return false
	var player_point := _visual_qa_world_to_image_point(player.global_position, image)
	var center := rifle_point.lerp(player_point, 0.5)
	var half_size := Vector2(absf(rifle_point.x - player_point.x), absf(rifle_point.y - player_point.y)) * 0.5 + Vector2(56.0, 56.0)
	var lane_rect := Rect2i(
		int(center.x - half_size.x),
		int(center.y - half_size.y),
		int(half_size.x * 2.0),
		int(half_size.y * 2.0)
	)
	var target_rect := Rect2i(
		int(player_point.x - 48.0),
		int(player_point.y - 48.0),
		96,
		96
	)
	var amber_ratio := _visual_qa_color_ratio(image, lane_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.22 and color.g < 0.68 and color.b < 0.24 and color.r > color.b + 0.28
	)
	var dark_rail_ratio := _visual_qa_color_ratio(image, lane_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.02
	)
	var target_amber_ratio := _visual_qa_color_ratio(image, target_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.22 and color.g < 0.72 and color.b < 0.28 and color.r > color.b + 0.24
	)
	var lane_contrast := _visual_qa_luminance_stddev(image, lane_rect)
	return amber_ratio > 0.006 and dark_rail_ratio > 0.008 and target_amber_ratio > 0.004 and lane_contrast > 0.03

func _visual_qa_image_has_saloon_cover_props(image: Image) -> bool:
	if arena_cover_props.size() < 2:
		return false
	var hits := 0
	for cover in arena_cover_props:
		if str(cover.get("kind", "")) != "saloon_cover":
			continue
		var cover_point := _visual_qa_world_to_image_point(cover["origin"], image)
		var sample_rect := Rect2i(
			int(cover_point.x - 118.0),
			int(cover_point.y - 72.0),
			236,
			144
		)
		var wood_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.24 and color.g > 0.10 and color.g < 0.42 and color.b < 0.22 and color.r > color.b + 0.10
		)
		var shadow_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.02
		)
		var brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.52 and color.g > 0.25 and color.b < 0.24 and color.r > color.b + 0.22
		)
		var cover_contrast := _visual_qa_luminance_stddev(image, sample_rect)
		if wood_ratio > 0.035 and shadow_ratio > 0.012 and brass_ratio > 0.0008 and cover_contrast > 0.028:
			hits += 1
	return hits >= 2

func _visual_qa_image_has_crossfire_cover_bait_glint(image: Image) -> bool:
	for cover in arena_cover_props:
		if str(cover.get("kind", "")) != "saloon_cover" or bool(cover.get("splintered", false)):
			continue
		if _get_cover_rifle_bait_strength(cover) <= 0.0:
			continue
		var cover_point := _visual_qa_world_to_image_point(cover["origin"], image)
		var sample_rect := Rect2i(
			int(cover_point.x - 132.0),
			int(cover_point.y - 86.0),
			264,
			172
		)
		var brass_glint_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.62 and color.g > 0.42 and color.b < 0.28 and color.r > color.b + 0.28
		)
		var bone_glint_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.76 and color.g > 0.62 and color.b > 0.28 and color.r > color.b + 0.22
		)
		var dark_wood_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.02
		)
		var glint_contrast := _visual_qa_luminance_stddev(image, sample_rect)
		if brass_glint_ratio > 0.01 and bone_glint_ratio > 0.001 and dark_wood_ratio > 0.012 and glint_contrast > 0.035:
			return true
	return false

func _visual_qa_image_has_splintered_saloon_cover(image: Image) -> bool:
	var hits := 0
	for cover in arena_cover_props:
		if str(cover.get("kind", "")) != "saloon_cover" or not bool(cover.get("splintered", false)):
			continue
		var cover_point := _visual_qa_world_to_image_point(cover["origin"], image)
		var sample_rect := Rect2i(
			int(cover_point.x - 126.0),
			int(cover_point.y - 82.0),
			252,
			164
		)
		var dark_crack_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return _visual_qa_luminance(color) < 0.18 and color.r > color.b + 0.018
		)
		var hot_shard_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.62 and color.g > 0.30 and color.b < 0.24 and color.r > color.b + 0.28
		)
		var wood_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
			return color.r > 0.24 and color.g > 0.10 and color.g < 0.42 and color.b < 0.22 and color.r > color.b + 0.10
		)
		var splinter_contrast := _visual_qa_luminance_stddev(image, sample_rect)
		if dark_crack_ratio > 0.018 and hot_shard_ratio > 0.0015 and wood_ratio > 0.035 and splinter_contrast > 0.032:
			hits += 1
	return hits >= 1

func _visual_qa_image_has_black_sash_signature_mark(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var center_point := _visual_qa_world_to_image_point(arena.get_center(), image)
	var sample_rect := Rect2i(
		int(center_point.x - 230.0),
		int(center_point.y - 170.0),
		460,
		340
	)
	var sash_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.22 and color.g < 0.16 and color.b < 0.12 and color.r > color.g + 0.08
	)
	var dark_cloth_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.22 and color.r > color.b + 0.012
	)
	var brass_spur_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.52 and color.g > 0.28 and color.b < 0.22 and color.r > color.b + 0.24
	)
	var mark_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return sash_ratio > 0.012 and dark_cloth_ratio > 0.045 and brass_spur_ratio > 0.002 and mark_contrast > 0.032

func _visual_qa_image_has_black_sash_duel_ground_prompt(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var prompt_point := _visual_qa_world_to_image_point(_get_black_sash_duel_ground_origin(arena), image)
	var sample_rect := Rect2i(
		int(prompt_point.x - 210.0),
		int(prompt_point.y - 170.0),
		420,
		340
	)
	var bright_brass_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.6 and color.g > 0.34 and color.b < 0.3 and color.r > color.b + 0.26
	)
	var bone_ring_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.68 and color.g > 0.5 and color.b > 0.24 and color.r > color.b + 0.16
	)
	var prompt_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return bright_brass_ratio > 0.0024 and bone_ring_ratio > 0.0007 and prompt_contrast > 0.034

func _visual_qa_image_has_duelist_lunge_lane(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var lane_rect := Rect2i(
		int(width * 0.48),
		int(height * 0.5),
		int(width * 0.34),
		int(height * 0.4)
	)
	var floor_rect := Rect2i(
		int(width * 0.62),
		int(height * 0.28),
		int(width * 0.22),
		int(height * 0.16)
	)
	var lane_contrast := _visual_qa_luminance_stddev(image, lane_rect)
	var floor_contrast := _visual_qa_luminance_stddev(image, floor_rect)
	var danger_ratio := _visual_qa_color_ratio(image, lane_rect, func(color: Color) -> bool:
		return color.r > color.g + 0.035 and color.r > color.b + 0.035
	)
	var rail_ratio := _visual_qa_color_ratio(image, lane_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.31
	)
	return lane_contrast > floor_contrast + 0.012 and lane_contrast > 0.035 and (danger_ratio > 0.025 or rail_ratio > 0.025)

func _visual_qa_image_has_duelist_boot_dust(image: Image) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	var duelist_point := Vector2(-1.0, -1.0)
	var duelist_world := Vector2.ZERO
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, "duelist") and enemy is Node2D:
			duelist_world = (enemy as Node2D).global_position
			duelist_point = _visual_qa_world_to_image_point(duelist_world, image)
			break
	if duelist_point.x < 0.0:
		return false
	var player_point := _visual_qa_world_to_image_point(player.global_position, image)
	var facing := duelist_point.direction_to(player_point)
	if facing.length_squared() <= 0.001:
		facing = Vector2.LEFT
	facing = facing.normalized()
	var side := facing.orthogonal()
	var heel_center := duelist_point - facing * 18.0
	var boot_rect := Rect2i(
		int(heel_center.x - 96.0),
		int(heel_center.y - 84.0),
		192,
		168
	)
	var dust_ratio := _visual_qa_color_ratio(image, boot_rect, func(color: Color) -> bool:
		return color.r > 0.2 and color.r < 0.62 and color.g > 0.08 and color.g < 0.38 and color.b < 0.2 and color.r > color.b + 0.08
	)
	var brass_ratio := _visual_qa_color_ratio(image, boot_rect, func(color: Color) -> bool:
		return color.r > 0.5 and color.g > 0.25 and color.b < 0.24 and color.r > color.b + 0.22
	)
	var dark_spur_ratio := _visual_qa_color_ratio(image, boot_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.28 and color.r > color.b + 0.02
	)
	var boot_contrast := _visual_qa_luminance_stddev(image, boot_rect)
	return (
		dust_ratio > 0.03
		and brass_ratio > 0.0008
		and dark_spur_ratio > 0.012
		and boot_contrast > 0.026
	)

func _visual_qa_image_has_last_high_noon_overlay(image: Image) -> bool:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return false
	var finale_rect := Rect2i(
		int(width * 0.34),
		int(height * 0.14),
		int(width * 0.62),
		int(height * 0.72)
	)
	var hot_ratio := _visual_qa_color_ratio(image, finale_rect, func(color: Color) -> bool:
		return color.r > 0.45 and color.g > 0.22 and color.b < 0.22 and color.r > color.g + 0.08
	)
	var ray_shadow_ratio := _visual_qa_color_ratio(image, finale_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.34 and color.r > color.b + 0.05
	)
	var exit_rect := Rect2i(
		int(width * 0.72),
		int(height * 0.36),
		int(width * 0.24),
		int(height * 0.28)
	)
	var exit_brass_ratio := _visual_qa_color_ratio(image, exit_rect, func(color: Color) -> bool:
		return color.r > 0.52 and color.g > 0.34 and color.b < 0.2 and color.r > color.b + 0.24
	)
	var exit_contrast := _visual_qa_luminance_stddev(image, exit_rect)
	var hold_lane_rect := Rect2i(
		int(width * 0.66),
		int(height * 0.38),
		int(width * 0.24),
		int(height * 0.24)
	)
	var hold_lane_brass_ratio := _visual_qa_color_ratio(image, hold_lane_rect, func(color: Color) -> bool:
		return color.r > 0.54 and color.g > 0.34 and color.b < 0.22 and color.r > color.b + 0.24
	)
	return (
		hot_ratio > 0.68
		and ray_shadow_ratio > 0.002
		and exit_brass_ratio > 0.035
		and exit_contrast > 0.03
		and hold_lane_brass_ratio > 0.012
	)

func _visual_qa_image_has_gold_rush_keg_links(image: Image) -> bool:
	if arena_hazards.size() < 2:
		return false
	for pair_start in range(0, arena_hazards.size() - 1, 2):
		var first: Dictionary = arena_hazards[pair_start]
		var second: Dictionary = arena_hazards[pair_start + 1]
		if _visual_qa_image_has_gold_rush_keg_pair_link(image, first, second):
			return true
	return false

func _visual_qa_image_has_gold_rush_keg_pair_link(image: Image, first: Dictionary, second: Dictionary) -> bool:
	if bool(first.get("spent", false)) and bool(second.get("spent", false)):
		return false
	var first_screen := _visual_qa_world_to_image_point(first["origin"], image)
	var second_screen := _visual_qa_world_to_image_point(second["origin"], image)
	if first_screen.x < -96.0 or second_screen.x < -96.0 or first_screen.y < -96.0 or second_screen.y < -96.0:
		return false
	if first_screen.x > float(image.get_width()) + 96.0 or second_screen.x > float(image.get_width()) + 96.0 or first_screen.y > float(image.get_height()) + 96.0 or second_screen.y > float(image.get_height()) + 96.0:
		return false
	var center := first_screen.lerp(second_screen, 0.5)
	var half_size := Vector2(absf(first_screen.x - second_screen.x), absf(first_screen.y - second_screen.y)) * 0.5 + Vector2(22.0, 22.0)
	var link_rect := Rect2i(
		int(center.x - half_size.x),
		int(center.y - half_size.y),
		int(half_size.x * 2.0),
		int(half_size.y * 2.0)
	)
	var brass_ratio := _visual_qa_color_ratio(image, link_rect, func(color: Color) -> bool:
		return color.r > 0.48 and color.g > 0.26 and color.b < 0.18 and color.r > color.b + 0.22
	)
	var bone_pip_ratio := _visual_qa_color_ratio(image, link_rect, func(color: Color) -> bool:
		return color.r > 0.68 and color.g > 0.52 and color.b > 0.22 and color.r > color.b + 0.22
	)
	var rail_shadow_ratio := _visual_qa_color_ratio(image, link_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.22 and color.r > color.b + 0.025
	)
	var link_contrast := _visual_qa_luminance_stddev(image, link_rect)
	var endpoint_ring_hits := 0
	for endpoint in [first_screen, second_screen]:
		var endpoint_rect := Rect2i(
			int(endpoint.x - 70.0),
			int(endpoint.y - 70.0),
			140,
			140
		)
		var endpoint_brass_ratio := _visual_qa_color_ratio(image, endpoint_rect, func(color: Color) -> bool:
			return color.r > 0.58 and color.g > 0.34 and color.b < 0.24 and color.r > color.b + 0.28
		)
		if endpoint_brass_ratio > 0.012:
			endpoint_ring_hits += 1
	return brass_ratio > 0.025 and bone_pip_ratio > 0.001 and rail_shadow_ratio > 0.025 and link_contrast > 0.035 and endpoint_ring_hits >= 2

func _visual_qa_image_has_rail_yard_overlay(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var top_left := _visual_qa_world_to_image_point(arena.position + arena.size * 0.18, image)
	var bottom_right := _visual_qa_world_to_image_point(arena.position + arena.size * 0.82, image)
	var sample_rect := Rect2i(
		int(minf(top_left.x, bottom_right.x)),
		int(minf(top_left.y, bottom_right.y)),
		int(absf(bottom_right.x - top_left.x)),
		int(absf(bottom_right.y - top_left.y))
	)
	var rail_shadow_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.025
	)
	var brass_dust_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.42 and color.g > 0.24 and color.b < 0.2 and color.r > color.b + 0.18
	)
	var rail_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return rail_shadow_ratio > 0.008 and brass_dust_ratio > 0.08 and rail_contrast > 0.035

func _visual_qa_image_has_dust_chapel_brute_lanes(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var top_left := _visual_qa_world_to_image_point(arena.position + arena.size * 0.2, image)
	var bottom_right := _visual_qa_world_to_image_point(arena.position + arena.size * 0.8, image)
	var sample_rect := Rect2i(
		int(minf(top_left.x, bottom_right.x)),
		int(minf(top_left.y, bottom_right.y)),
		int(absf(bottom_right.x - top_left.x)),
		int(absf(bottom_right.y - top_left.y))
	)
	var dark_lane_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.26 and color.r > color.b + 0.025
	)
	var brass_lane_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.45 and color.g > 0.25 and color.b < 0.2 and color.r > color.b + 0.2
	)
	var lane_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return dark_lane_ratio > 0.018 and brass_lane_ratio > 0.05 and lane_contrast > 0.035

func _visual_qa_image_has_shotgun_brute_wide_tell(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var top_left := _visual_qa_world_to_image_point(arena.position + arena.size * 0.16, image)
	var bottom_right := _visual_qa_world_to_image_point(arena.position + arena.size * 0.84, image)
	var sample_rect := Rect2i(
		int(minf(top_left.x, bottom_right.x)),
		int(minf(top_left.y, bottom_right.y)),
		int(absf(bottom_right.x - top_left.x)),
		int(absf(bottom_right.y - top_left.y))
	)
	var amber_fan_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.55 and color.g > 0.22 and color.g < 0.68 and color.b < 0.24 and color.r > color.b + 0.28
	)
	var dark_edge_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.24 and color.r > color.b + 0.02
	)
	var tell_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return amber_fan_ratio > 0.012 and dark_edge_ratio > 0.02 and tell_contrast > 0.035

func _visual_qa_image_has_shotgun_brute_recovery_tell(image: Image) -> bool:
	var brute_point := Vector2(-1.0, -1.0)
	if _visual_qa_staged_brute_recovery_origin.x >= 0.0:
		brute_point = _visual_qa_world_to_image_point(_visual_qa_staged_brute_recovery_origin, image)
	else:
		for enemy in enemies:
			if _smoke_enemy_matches_kind(enemy, "shotgun_brute") and enemy is Node2D and enemy.has_method("has_recover_tell") and bool(enemy.call("has_recover_tell")):
				brute_point = _visual_qa_world_to_image_point((enemy as Node2D).global_position, image)
				break
	if brute_point.x < 0.0:
		return false
	var sample_rect := Rect2i(
		int(brute_point.x - 128.0),
		int(brute_point.y - 118.0),
		256,
		236
	)
	var brass_shell_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.52 and color.g > 0.28 and color.b < 0.22 and color.r > color.b + 0.24
	)
	var smoke_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.23 and color.r > color.b + 0.02
	)
	var warm_recovery_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.34 and color.g > 0.16 and color.g < 0.5 and color.b < 0.18 and color.r > color.b + 0.16
	)
	var recovery_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return brass_shell_ratio > 0.003 and smoke_ratio > 0.014 and warm_recovery_ratio > 0.045 and recovery_contrast > 0.028

func _visual_qa_image_has_mercy_fastdraw_overlay(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var top_left := _visual_qa_world_to_image_point(arena.position + arena.size * 0.16, image)
	var bottom_right := _visual_qa_world_to_image_point(arena.position + arena.size * 0.84, image)
	var sample_rect := Rect2i(
		int(minf(top_left.x, bottom_right.x)),
		int(minf(top_left.y, bottom_right.y)),
		int(absf(bottom_right.x - top_left.x)),
		int(absf(bottom_right.y - top_left.y))
	)
	var brass_sweep_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.5 and color.g > 0.3 and color.b < 0.22 and color.r > color.b + 0.24
	)
	var red_orange_tell_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.6 and color.g > 0.12 and color.g < 0.48 and color.b < 0.18
	)
	var fastdraw_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return brass_sweep_ratio > 0.075 and red_orange_tell_ratio > 0.01 and fastdraw_contrast > 0.04

func _visual_qa_image_has_june_blackglass_killbox(image: Image) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	var top_left := _visual_qa_world_to_image_point(arena.position + arena.size * 0.14, image)
	var bottom_right := _visual_qa_world_to_image_point(arena.position + arena.size * 0.86, image)
	var sample_rect := Rect2i(
		int(minf(top_left.x, bottom_right.x)),
		int(minf(top_left.y, bottom_right.y)),
		int(absf(bottom_right.x - top_left.x)),
		int(absf(bottom_right.y - top_left.y))
	)
	var red_lane_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return color.r > 0.5 and color.g < 0.36 and color.b < 0.3 and color.r > color.g + 0.12
	)
	var glass_shadow_ratio := _visual_qa_color_ratio(image, sample_rect, func(color: Color) -> bool:
		return _visual_qa_luminance(color) < 0.28 and color.r > color.b + 0.02
	)
	var killbox_contrast := _visual_qa_luminance_stddev(image, sample_rect)
	return red_lane_ratio > 0.025 and glass_shadow_ratio > 0.025 and killbox_contrast > 0.03

func _visual_qa_world_to_image_point(world_position: Vector2, image: Image) -> Vector2:
	var viewport_size := get_viewport().get_visible_rect().size
	var viewport_point: Vector2 = get_viewport().get_canvas_transform() * world_position
	var image_scale := Vector2(float(image.get_width()) / viewport_size.x, float(image.get_height()) / viewport_size.y)
	return Vector2(
		clampf(viewport_point.x * image_scale.x, 0.0, float(image.get_width() - 1)),
		clampf(viewport_point.y * image_scale.y, 0.0, float(image.get_height() - 1))
	)

func _visual_qa_average_luminance(image: Image, rect: Rect2i) -> float:
	var total := 0.0
	var samples := 0
	var step_x := maxi(1, rect.size.x / 16)
	var step_y := maxi(1, rect.size.y / 12)
	for y in range(rect.position.y, rect.position.y + rect.size.y, step_y):
		for x in range(rect.position.x, rect.position.x + rect.size.x, step_x):
			var color := image.get_pixel(clampi(x, 0, image.get_width() - 1), clampi(y, 0, image.get_height() - 1))
			total += color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			samples += 1
	if samples <= 0:
		return 1.0
	return total / float(samples)

func _visual_qa_luminance_stddev(image: Image, rect: Rect2i) -> float:
	var total := 0.0
	var total_squared := 0.0
	var samples := 0
	var step_x := maxi(1, rect.size.x / 24)
	var step_y := maxi(1, rect.size.y / 12)
	for y in range(rect.position.y, rect.position.y + rect.size.y, step_y):
		for x in range(rect.position.x, rect.position.x + rect.size.x, step_x):
			var color := image.get_pixel(clampi(x, 0, image.get_width() - 1), clampi(y, 0, image.get_height() - 1))
			var luma := color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			total += luma
			total_squared += luma * luma
			samples += 1
	if samples <= 0:
		return 0.0
	var mean := total / float(samples)
	return sqrt(maxf(0.0, total_squared / float(samples) - mean * mean))

func _visual_qa_luminance(color: Color) -> float:
	return color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722

func _visual_qa_color_ratio(image: Image, rect: Rect2i, predicate: Callable) -> float:
	var hits := 0
	var samples := 0
	var step_x := maxi(1, rect.size.x / 36)
	var step_y := maxi(1, rect.size.y / 24)
	for y in range(rect.position.y, rect.position.y + rect.size.y, step_y):
		for x in range(rect.position.x, rect.position.x + rect.size.x, step_x):
			var color := image.get_pixel(clampi(x, 0, image.get_width() - 1), clampi(y, 0, image.get_height() - 1))
			if bool(predicate.call(color)):
				hits += 1
			samples += 1
	if samples <= 0:
		return 0.0
	return float(hits) / float(samples)

func _smoke_assert_first_wave_hud() -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("FIRST DRAW") >= 0, "wave 1 HUD should show the first-draw coaching tip")
	_smoke_assert(tip.find("SLASH") >= 0 and tip.find("DASH") >= 0 and tip.find("GUN") >= 0, "wave 1 HUD should teach slash, dash, and gun options")
	_smoke_assert(tip.length() <= 72, "wave 1 HUD tip should stay compact for readability")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_frame_class_name"):
		_smoke_assert(str(hud.get_live_hud_frame_class_name()) == "HudLedgerFrame", "live HUD should use the custom leather-and-brass ledger frame")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_frame_visible"):
		_smoke_assert(bool(hud.get_live_hud_frame_visible()), "live HUD ledger frame should be visible during combat")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_ledger_visual_version"):
		_smoke_assert(str(hud.get_live_hud_ledger_visual_version()) == "live_hud_ledger_marshal_badge_label_gate_v3", "live HUD ledger should use the marshal-badge label-gated visual pass")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_label_update_gate_version"):
		_smoke_assert(str(hud.get_live_hud_label_update_gate_version()) == "live_hud_label_text_change_gate_v1", "live HUD labels should use the text-change update gate")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_label_gate_count"):
		_smoke_assert(int(hud.get_live_hud_label_gate_count()) >= 6, "live HUD should gate the heart, danger, timer, wave, style, and ammo label text rows")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_live_hud_ledger_contrast_marker_count"):
		_smoke_assert(int(hud.get_live_hud_ledger_contrast_marker_count()) >= 42, "live HUD ledger should expose enough brass rails, rivets, row plates, ammo chambers, marshal badge, dividers, and hatch markers for readability")
	var ammo_text: String = hud.get_ammo_text() if hud != null and is_instance_valid(hud) and hud.has_method("get_ammo_text") else ""
	_smoke_assert(ammo_text.find("CYLINDER READY") >= 0 and ammo_text.find("/") >= 0, "wave 1 HUD should show a ready full cylinder")
	_smoke_assert(ammo_text.find("[") >= 0 and ammo_text.find("|") >= 0 and ammo_text.find("]") >= 0, "wave 1 HUD should show readable round pips")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_ammo_preview_text"):
		var low_text: String = hud.get_ammo_preview_text({"ammo": 1, "capacity": 6, "reload": 0.0, "reload_duration": 1.25, "reloading": false})
		var reload_text: String = hud.get_ammo_preview_text({"ammo": 0, "capacity": 6, "reload": 0.7, "reload_duration": 1.25, "reloading": true})
		_smoke_assert(low_text.find("CYLINDER LOW") >= 0 and low_text.find("1/6") >= 0, "ammo HUD should warn when the cylinder is low")
		_smoke_assert(reload_text.find("CYLINDER RELOAD") >= 0 and reload_text.find("AUTO") >= 0, "ammo HUD should explain auto reload progress")
	if _is_smoke_test_requested():
		_smoke_assert_first_empty_reload_feedback()
		_smoke_assert_reload_ready_feedback()

func _smoke_assert_black_sash_duel_ground_tip() -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("DUEL GROUND") >= 0 and tip.find("SASH MARK") >= 0, "wave 3 HUD should teach the Black Sash duel-ground style objective, got: %s" % tip)
	_smoke_assert(tip.find("BOOT DUST") >= 0, "wave 3 HUD should connect the duel-ground objective to the readable boot-dust tell, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "wave 3 duel-ground HUD tip should stay compact for readability")

func _smoke_assert_black_sash_duel_ground_reward(rewards_before: int, style_before: int) -> void:
	var style_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(_black_sash_duel_ground_reward_count > rewards_before, "holding The Black Sash duel ground during release should count a style reward")
	_smoke_assert(style_score > style_before, "Black Sash duel-ground mastery should award style points")
	_smoke_assert(style_text.find("DUEL GROUND") >= 0, "Black Sash duel-ground mastery should show a readable HUD receipt, got: %s" % style_text)

func _smoke_assert_first_rusher_warning_tell() -> void:
	if player == null:
		_smoke_assert(false, "first rusher warning tell needs a player target")
		return
	var target = null
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.has_method("has_swarm_warning_tell"):
			target = enemy
			break
	if target == null:
		_smoke_assert(false, "first rusher warning tell needs a knife rusher")
		return
	if target.has_method("_physics_process"):
		target.global_position = player.global_position + Vector2(520.0, 0.0)
		target._physics_process(0.016)
		target.global_position = player.global_position + Vector2(180.0, 0.0)
		target._physics_process(0.016)
	_smoke_assert(bool(target.has_swarm_warning_tell()), "first-wave rusher should expose a readable chase wind-up before contact")
	_smoke_assert(target.has_method("has_directional_swarm_warning_tell") and bool(target.has_directional_swarm_warning_tell()), "first-wave rusher wind-up should include a directional warning wedge")

func _smoke_assert_first_slash_afterimage() -> void:
	if player == null or vfx_layer == null or not vfx_layer.has_method("get_saber_afterimage_count") or not vfx_layer.has_method("get_saber_afterimage_visual_version") or not vfx_layer.has_method("get_saber_afterimage_detail_marker_count") or not vfx_layer.has_method("get_transient_vfx_redraw_budget_version") or not vfx_layer.has_method("get_transient_vfx_redraw_interval") or not vfx_layer.has_method("get_transient_vfx_pulse_budget_version") or not vfx_layer.has_method("get_max_transient_pulse_count") or not vfx_layer.has_method("get_transient_pulse_arc_segment_count") or not vfx_layer.has_method("get_rusher_defeat_burst_count") or not vfx_layer.has_method("get_dash_ready_glint_count") or not vfx_layer.has_method("get_dash_ready_prompt_total_count") or not vfx_layer.has_method("get_enemy_hit_spark_total_count") or not vfx_layer.has_method("get_enemy_hit_spark_visual_version") or not vfx_layer.has_method("get_enemy_hit_spark_material_marker_count") or not vfx_layer.has_method("get_parry_clang_total_count") or not vfx_layer.has_method("get_parry_clang_visual_version") or not vfx_layer.has_method("get_player_hit_flash_total_count") or not vfx_layer.has_method("get_player_hit_flash_visual_version") or not vfx_layer.has_method("get_player_hit_flash_material_marker_count") or not vfx_layer.has_method("get_blood_stain_total_count") or not vfx_layer.has_method("get_blood_stain_visual_version") or not vfx_layer.has_method("get_blood_stain_material_marker_count") or not vfx_layer.has_method("get_ability_cast_glint_total_count") or not vfx_layer.has_method("get_ability_cast_glint_visual_version"):
		_smoke_assert(false, "first slash follow-through should expose VFX smoke hooks")
		return
	_smoke_assert(str(vfx_layer.get_saber_afterimage_visual_version()) == "saber_afterimage_bone_dust_shear_v1", "saber follow-through should use the bone-white dust-shear readability pass")
	_smoke_assert(int(vfx_layer.get_saber_afterimage_detail_marker_count()) >= 5, "saber follow-through should expose dust shear, hot edge, inner arc, ember arc, and tip-cut detail markers")
	_smoke_assert(str(vfx_layer.get_transient_vfx_redraw_budget_version()) == "transient_vfx_spawn_redraw_gate_8fps_v6", "transient VFX should use the spawn-gated 8 FPS redraw budget instead of letting each effect request its own browser canvas repaint")
	_smoke_assert(float(vfx_layer.get_transient_vfx_redraw_interval()) >= 1.0 / 8.5, "transient VFX redraws should be capped near 8 FPS for browser frame stability")
	_smoke_assert(str(vfx_layer.get_transient_vfx_pulse_budget_version()) == "transient_vfx_pulse_arc_budget_12seg_v4", "transient dust bursts should use the browser-friendly 12-segment pulse arc budget")
	_smoke_assert(int(vfx_layer.get_max_transient_pulse_count()) <= 12, "transient dust bursts should cap simultaneous pulse rings so large explosions do not flood the browser canvas")
	_smoke_assert(int(vfx_layer.get_transient_pulse_arc_segment_count()) <= 12, "transient dust pulse rings should use lower arc segmentation while retaining readable circular bursts")
	_smoke_assert(str(vfx_layer.get_enemy_hit_spark_visual_version()) == "enemy_hit_sparks_role_glyph_material_v3", "enemy hit sparks should use the role-glyph brass/dust material burst visual version")
	_smoke_assert(int(vfx_layer.get_enemy_hit_spark_material_marker_count()) >= 9, "enemy hit sparks should expose dust impact, contact shadow, hot rim, role sparks, blood, material chips, rifle barrel glints, brute blast ticks, duelist badges, hunter claw marks, and rusher blade nicks")
	_smoke_assert(str(vfx_layer.get_parry_clang_visual_version()) == "parry_clang_brass_ring_v1", "player parries should use the brass clang ring visual version")
	_smoke_assert(str(vfx_layer.get_player_hit_flash_visual_version()) == "player_hit_blood_dust_brass_spur_v2", "player damage should use the brass-spur blood-and-dust flash visual version")
	_smoke_assert(int(vfx_layer.get_player_hit_flash_material_marker_count()) >= 8, "player damage flash should expose dust fan, blood streaks, denim arc, brass spur snap, leather tear, bone glint, droplets, and ground shadow markers")
	_smoke_assert(str(vfx_layer.get_blood_stain_visual_version()) == "sand_soaked_blood_stain_material_v2", "persistent blood stains should use the sand-soaked material decal visual version")
	_smoke_assert(int(vfx_layer.get_blood_stain_material_marker_count()) >= 7, "persistent blood stains should expose soak, rim, texture, streak, highlight, drop, and grit material markers")
	_smoke_assert(str(vfx_layer.get_ability_cast_glint_visual_version()) == "ability_cast_brass_sigils_v1", "ability casts should use the brass sigil and dust-ring glint visual version")
	var ability_glints_before: int = int(vfx_layer.get_ability_cast_glint_total_count())
	vfx_layer.skill_flash(player.global_position, Color(0.9, 0.68, 0.32), "deadeye")
	_smoke_assert(int(vfx_layer.get_ability_cast_glint_total_count()) > ability_glints_before, "confirmed ability cast should throw a capped brass sigil glint")
	var target = null
	for enemy in enemies:
		if is_instance_valid(enemy):
			target = enemy
			break
	if target == null:
		_smoke_assert(false, "first slash follow-through smoke needs a staged rusher")
		return
	var direction := Vector2.RIGHT
	target.global_position = player.global_position + direction * 86.0
	var afterimages_before: int = int(vfx_layer.get_saber_afterimage_count())
	var rusher_bursts_before: int = int(vfx_layer.get_rusher_defeat_burst_count())
	var hit_sparks_before: int = int(vfx_layer.get_enemy_hit_spark_total_count())
	var blood_stains_before: int = int(vfx_layer.get_blood_stain_total_count())
	var dash_glints_before: int = int(vfx_layer.get_dash_ready_glint_count())
	var dash_prompts_before: int = int(vfx_layer.get_dash_ready_prompt_total_count())
	var first_cut_feedback_before := _first_saber_kill_feedback_count
	var reward_cues_before := _smoke_get_audio_cue_count("reward")
	var defeated_before := enemies_defeated
	_on_player_weapon_slashed(player.global_position, direction, player.weapon_range, player.weapon_arc, player.weapon_damage)
	_smoke_assert(int(vfx_layer.get_saber_afterimage_count()) > afterimages_before, "confirmed first-wave saber hit should leave a blade follow-through afterimage")
	_smoke_assert(int(vfx_layer.get_enemy_hit_spark_total_count()) > hit_sparks_before, "confirmed first-wave enemy hit should throw a role-aware brass/dust hit spark")
	_smoke_assert(int(vfx_layer.get_blood_stain_total_count()) > blood_stains_before, "confirmed first-wave enemy defeat should leave a sand-soaked persistent blood stain")
	_smoke_assert(int(vfx_layer.get_rusher_defeat_burst_count()) > rusher_bursts_before, "confirmed first-wave rusher defeat should kick a directional dust-and-spark burst")
	_smoke_assert(int(vfx_layer.get_dash_ready_glint_count()) > dash_glints_before, "first saber kill nudge should flash a player-side dash-ready glint")
	_smoke_assert(int(vfx_layer.get_dash_ready_prompt_total_count()) > dash_prompts_before, "first saber kill nudge should draw an in-world SPACE dash prompt")
	_smoke_assert(_first_saber_kill_feedback_count > first_cut_feedback_before, "first saber kill should show a one-time first-cut coaching nudge")
	_smoke_assert(_smoke_get_audio_cue_count("reward") > reward_cues_before, "first saber kill coaching nudge should play a reward cue")
	var style_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(style_text.find("FIRST CUT") >= 0 and style_text.find("DASH NEXT") >= 0, "first saber kill nudge should reinforce slash timing and the next dash")
	if hud != null and hud.has_method("get_style_label_text"):
		hud.update_run(player, director, program_system, current_wave, _living_enemy_count(), MAX_LEVEL, _get_level_title(current_wave), _get_level_notice(current_wave), style_score, combo_count, _get_combo_fraction(), _get_style_rank(), program_system.get_ammo_summary(), wave_in_progress, wave_break_timer, _pending_payday_count())
		var style_label_text: String = hud.get_style_label_text()
		_smoke_assert(style_label_text.find("COMBO x1") >= 0 and style_label_text.find("CHAIN") >= 0, "first saber kill should expose the live combo chain timer on the HUD, got: %s" % style_label_text)
		_smoke_assert(style_label_text.find("%") >= 0, "live combo chain HUD should show the remaining timer percentage, got: %s" % style_label_text)
	var parry_clangs_before: int = int(vfx_layer.get_parry_clang_total_count())
	_on_player_parried()
	_smoke_assert(int(vfx_layer.get_parry_clang_total_count()) > parry_clangs_before, "player parry should throw a brass clang ring and blade-spark flourish")
	var last_second_bonuses_before := _smoke_get_last_second_chain_bonus_count()
	var clutch_style_before := style_score
	combo_timer = 0.72
	_award_style_points(25, "CLUTCH")
	var last_second_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(_smoke_get_last_second_chain_bonus_count() > last_second_bonuses_before, "earning style below 25 percent chain should count a last-second bonus")
	_smoke_assert(style_score >= clutch_style_before + 100, "last-second bonus should add a visible clutch score reward")
	_smoke_assert(combo_count >= 2 and combo_timer == 4.0, "last-second bonus should keep the style chain alive")
	_smoke_assert(last_second_text.find("LAST SECOND") >= 0, "last-second bonus should show a clutch HUD receipt, got: %s" % last_second_text)
	var chain_breaks_before := _smoke_get_chain_break_feedback_count()
	combo_timer = 0.01
	_update_style_timer(0.02)
	var chain_break_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(_smoke_get_chain_break_feedback_count() > chain_breaks_before, "expiring an active combo should count a chain-break HUD receipt")
	_smoke_assert(combo_count == 0 and combo_timer == 0.0, "expiring an active combo should clear the live chain")
	_smoke_assert(chain_break_text.find("CHAIN BROKE") >= 0 and chain_break_text.find("TIMEOUT") >= 0, "combo timeout should tell the player why the chain ended, got: %s" % chain_break_text)
	var rank_ups_before := _smoke_get_rank_up_feedback_count()
	style_score = 2590
	_award_style_points(20, "RANK TEST")
	var rank_up_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(_smoke_get_rank_up_feedback_count() > rank_ups_before, "crossing a style rank threshold should count a rank-up receipt")
	_smoke_assert(_get_style_rank() == "C", "crossing 2600 style should promote the live rank to C")
	_smoke_assert(rank_up_text.find("RANK UP C") >= 0, "style rank threshold should show an in-run rank-up HUD pulse, got: %s" % rank_up_text)
	if hud != null and hud.has_method("get_style_pop_frame_alpha"):
		_smoke_assert(float(hud.get_style_pop_frame_alpha()) > 0.45, "rank-up HUD pulse should sit on a readable leather-and-brass receipt frame")
	var player_hit_flashes_before: int = int(vfx_layer.get_player_hit_flash_total_count())
	_on_player_damaged(1.0)
	_smoke_assert(int(vfx_layer.get_player_hit_flash_total_count()) > player_hit_flashes_before, "player damage should throw a directional blood-and-dust hit flash")
	_smoke_assert(enemies_defeated > defeated_before, "staged first-wave saber hit should still defeat a rusher")

func _smoke_assert_crossfire_cover_splinter() -> void:
	if player == null or not is_instance_valid(player):
		_smoke_assert(false, "Crossfire cover splinter smoke needs a player")
		return
	var cover_index := _get_first_unsplintered_cover_index("saloon_cover")
	if cover_index < 0:
		_smoke_assert(false, "Crossfire cover splinter smoke needs an unsplintered saloon cover prop")
		return
	var cover: Dictionary = arena_cover_props[cover_index]
	var cover_origin: Vector2 = cover["origin"]
	var direction := Vector2.RIGHT
	player.global_position = cover_origin - direction * 112.0
	player.velocity = Vector2.ZERO
	var splinters_before := _cover_splinter_total_count
	var style_before := style_score
	_on_player_weapon_slashed(player.global_position, direction, player.weapon_range, player.weapon_arc, player.weapon_damage)
	_smoke_assert(_cover_splinter_total_count > splinters_before, "saber sweep should splinter a staged Crossfire cover prop")
	_smoke_assert(bool(arena_cover_props[cover_index].get("splintered", false)), "splintered Crossfire cover should keep a persistent damaged state")
	_smoke_assert(style_score > style_before, "splintering Crossfire cover should award a small style reward")
	if not vault_data.is_empty():
		player.global_position = (vault_data["arena"] as Rect2).get_center()
		player.velocity = Vector2.ZERO
		if camera != null:
			camera.offset = Vector2.ZERO
			camera.reset_smoothing()

func _smoke_assert_crossfire_rifle_cover_splinter() -> void:
	var cover_index := _get_first_unsplintered_cover_index("saloon_cover")
	if cover_index < 0:
		_smoke_assert(false, "Crossfire rifle splinter smoke needs an unsplintered saloon cover prop")
		return
	var cover: Dictionary = arena_cover_props[cover_index]
	var cover_origin: Vector2 = cover["origin"]
	var direction := Vector2.RIGHT
	var splinters_before := _cover_splinter_total_count
	var style_before := style_score
	_on_rifleman_shot_fired(null, cover_origin - direction * 320.0, cover_origin + direction * 320.0, direction)
	_smoke_assert(_cover_splinter_total_count > splinters_before, "rifle shot line should splinter a staged Crossfire cover prop")
	_smoke_assert(bool(arena_cover_props[cover_index].get("splintered", false)), "rifle-splintered Crossfire cover should keep a persistent damaged state")
	_smoke_assert(style_score > style_before, "baiting rifle fire into Crossfire cover should award a small style reward")

func _smoke_stage_crossfire_rifle_bait_line() -> bool:
	if player == null or not is_instance_valid(player):
		return false
	var cover_index := _get_rightmost_unsplintered_cover_index("saloon_cover")
	if cover_index < 0:
		return false
	var rifle: Node2D = null
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, "rifleman") and enemy is Node2D:
			rifle = enemy
			break
	if rifle == null:
		return false
	var cover: Dictionary = arena_cover_props[cover_index]
	var cover_origin: Vector2 = cover["origin"]
	var direction := Vector2.RIGHT
	var player_origin := cover_origin - direction * 285.0
	if not vault_data.is_empty():
		player_origin = (vault_data["arena"] as Rect2).get_center()
		player_origin.y = cover_origin.y
	player.global_position = player_origin
	player.velocity = Vector2.ZERO
	rifle.global_position = cover_origin + direction * 300.0
	rifle.set("_fire_timer", 0.0)
	rifle.set("_charge_timer", 0.32)
	rifle.set("_aim_angle", PI)
	rifle.set("_shot_target", player.global_position)
	if vfx_layer != null and vfx_layer.has_method("rifle_warning_puff") and rifle.has_method("get_attack_tell_line"):
		var line: Dictionary = rifle.get_attack_tell_line()
		if not line.is_empty():
			vfx_layer.rifle_warning_puff(line["start"], line["direction"])
	if camera != null:
		camera.offset = Vector2.ZERO
		camera.reset_smoothing()
	return true

func _smoke_assert_crossfire_cover_bait_glint() -> void:
	var glint_found := false
	for cover in arena_cover_props:
		if _get_cover_rifle_bait_strength(cover) > 0.0:
			glint_found = true
			break
	_smoke_assert(glint_found, "active Crossfire rifle tell should glint on an unsplintered saloon cover bait target")

func _smoke_assert_crossfire_hud_tip() -> void:
	_clear_payday_pickups_for_smoke()
	if hud != null and is_instance_valid(hud):
		if hud.has_method("clear_objective_feedback"):
			hud.clear_objective_feedback()
		hud.update_run(player, director, program_system, current_wave, _living_enemy_count(), MAX_LEVEL, _get_level_title(current_wave), _get_level_notice(current_wave), style_score, combo_count, _get_combo_fraction(), _get_style_rank(), program_system.get_ammo_summary(), wave_in_progress, wave_break_timer, _pending_payday_count())
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("CROSSFIRE") >= 0, "wave 2 HUD should identify the Crossfire set-piece, got: %s" % tip)
	_smoke_assert(tip.find("BAIT") >= 0 and tip.find("RIFLES") >= 0 and tip.find("COVER") >= 0, "wave 2 HUD should teach baiting rifle lanes into cover, got: %s" % tip)
	_smoke_assert(tip.find("SPLINTER") >= 0 and tip.find("STYLE") >= 0, "wave 2 HUD should connect splintered cover to style reward, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "wave 2 HUD tip should stay compact for readability")

func _smoke_assert_rail_yard_hud_tip() -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("RAIL YARD") >= 0, "wave 4 HUD should identify the Rail Yard set-piece, got: %s" % tip)
	_smoke_assert(tip.find("DASH") >= 0 and tip.find("LANES") >= 0 and tip.find("SPACING") >= 0, "wave 4 HUD should teach dashing across rail lanes and spacing reads, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "wave 4 HUD tip should stay compact for readability")

func _smoke_assert_dust_chapel_hud_tip() -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("DUST CHAPEL") >= 0, "wave 5 HUD should identify the Dust Chapel set-piece, got: %s" % tip)
	_smoke_assert(tip.find("ASH") >= 0 and tip.find("BRUTES") >= 0, "wave 5 HUD should tie the lane pressure to Reverend Ash's brutes, got: %s" % tip)
	_smoke_assert(tip.find("AISLES") >= 0 and tip.find("DASH") >= 0 and tip.find("LANES") >= 0, "wave 5 HUD should teach crossing chapel aisles and lane pressure, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "wave 5 HUD tip should stay compact for readability")

func _smoke_assert_mercy_vale_hud_tip() -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("MERCY VALE") >= 0, "wave 6 HUD should identify Mercy Vale, got: %s" % tip)
	_smoke_assert(tip.find("DRAW LINE") >= 0 and tip.find("DASH SIDE") >= 0, "wave 6 HUD should teach Mercy's fast-draw lane counterplay, got: %s" % tip)
	_smoke_assert(tip.find("PARRY") >= 0, "wave 6 HUD should preserve parry counterplay, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "wave 6 HUD tip should stay compact for readability")

func _smoke_assert_late_run_hud_tip(target_wave: int) -> void:
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	if target_wave == 9:
		_smoke_assert(tip.find("KILL BOX") >= 0 and tip.find("DASH") >= 0, "wave 9 HUD should identify the Kill Box and preserve dash, got: %s" % tip)
		_smoke_assert(tip.find("JUNE") >= 0 and tip.find("CROSS-PRESSURE") >= 0, "wave 9 HUD should teach June and cross-pressure counterplay, got: %s" % tip)
	elif target_wave == 10:
		_smoke_assert(tip.find("LAST HIGH NOON") >= 0 and tip.find("DASH") >= 0, "wave 10 HUD should identify the finale and preserve dash, got: %s" % tip)
		_smoke_assert(tip.find("HUNTERS") >= 0 and tip.find("EXTRACT") >= 0, "wave 10 HUD should teach hunter pressure and extraction, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "late-run HUD tip should stay compact for readability")

func _smoke_assert_finale_objective_tracker() -> void:
	var tracker: String = hud.get_objective_tracker_text() if hud != null and is_instance_valid(hud) and hud.has_method("get_objective_tracker_text") else ""
	_smoke_assert(tracker.find("FINAL EXTRACTION") >= 0, "wave 10 objective tracker should switch to final extraction framing, got: %s" % tracker)
	_smoke_assert(tracker.find("LAST HIGH NOON") >= 0 and tracker.find("RIDE OUT") >= 0, "wave 10 objective tracker should tie the finale to riding out, got: %s" % tracker)
	_smoke_assert(tracker.find("EAST EXIT TRAIL") >= 0, "wave 10 objective tracker should point players toward the marked east extraction trail, got: %s" % tracker)
	_smoke_assert(tracker.length() <= 170, "wave 10 objective tracker should stay compact for the HUD frame")

func _smoke_assert_red_canyon_pocket_reward() -> void:
	_smoke_assert(_smoke_place_player_in_red_canyon_route_pocket(), "wave 7 smoke should place the player inside a Red Canyon calm pocket")
	_smoke_assert(_smoke_stage_enemy_kind_near_player("hunter", Vector2(220.0, 0.0)), "wave 7 smoke should stage a Hunter for calm-pocket reward validation")
	var rewards_before := _smoke_get_red_canyon_pocket_reward_count()
	var style_before := style_score
	_smoke_assert(await _smoke_wait_for_enemy_attack_tell("hunter", 90), "wave 7 Hunter should expose a tell before the calm-pocket reward")
	_smoke_assert(await _smoke_wait_for_enemy_method_true("hunter", "has_lunge_afterimage", 45), "wave 7 Hunter lunge should release while player holds a calm pocket")
	_smoke_assert_red_canyon_pocket_reward_result(rewards_before, style_before)

func _smoke_assert_red_canyon_pocket_reward_result(rewards_before: int, style_before: int) -> void:
	_smoke_assert(_smoke_get_red_canyon_pocket_reward_count() > rewards_before, "wave 7 Hunter lunge should reward holding a Red Canyon calm pocket")
	_smoke_assert(style_score > style_before, "wave 7 Red Canyon pocket reward should award style points")
	var pocket_style_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(pocket_style_text.find("CANYON POCKET") >= 0, "wave 7 Red Canyon pocket reward should show a style pop, got: %s" % pocket_style_text)
	_smoke_assert(_smoke_get_mastery_payoff_feedback_count() > 0, "wave 7 Red Canyon pocket reward should trigger a brass mastery payoff burst")

func _smoke_assert_hunter_lunge_tell_visual_contract() -> void:
	for enemy in enemies:
		if not is_instance_valid(enemy) or not _smoke_enemy_matches_kind(enemy, "hunter"):
			continue
		_smoke_assert(enemy.has_method("get_hunter_lunge_tell_visual_version"), "Hunter should expose its lunge tell visual version")
		if enemy.has_method("get_hunter_lunge_tell_visual_version"):
			_smoke_assert(str(enemy.get_hunter_lunge_tell_visual_version()) == "hunter_wanted_lane_lunge_tell_v1", "Hunter lunge tell should use the wanted-lane warning pass")
		_smoke_assert(enemy.has_method("get_hunter_lunge_tell_marker_count"), "Hunter should expose lunge tell marker coverage")
		if enemy.has_method("get_hunter_lunge_tell_marker_count"):
			_smoke_assert(int(enemy.get_hunter_lunge_tell_marker_count()) >= 11, "Hunter wanted-lane tell should expose rails, center strike, charge ring, boot bar, claw ticks, corners, and strike endcap markers")
		return
	_smoke_assert(false, "Hunter lunge tell visual contract needs a live Hunter enemy")

func _smoke_assert_rifleman_shot_tell_visual_contract() -> void:
	for enemy in enemies:
		if not is_instance_valid(enemy) or not _smoke_enemy_matches_kind(enemy, "rifleman"):
			continue
		_smoke_assert(enemy.has_method("get_rifleman_shot_tell_visual_version"), "Rifleman should expose its shot tell visual version")
		if enemy.has_method("get_rifleman_shot_tell_visual_version"):
			_smoke_assert(str(enemy.get_rifleman_shot_tell_visual_version()) == "rifleman_bounty_sightline_tell_v1", "Rifleman shot tell should use the bounty sightline warning pass")
		_smoke_assert(enemy.has_method("get_rifleman_shot_tell_marker_count"), "Rifleman should expose shot tell marker coverage")
		if enemy.has_method("get_rifleman_shot_tell_marker_count"):
			_smoke_assert(int(enemy.get_rifleman_shot_tell_marker_count()) >= 12, "Rifleman bounty sightline should expose shadow rails, brass rails, center line, hash marks, origin ring, target reticle, crosshair, and muzzle bracket markers")
		_smoke_assert(enemy.has_method("get_rifleman_shot_tell_arc_segment_count"), "Rifleman should expose shot tell arc budget")
		if enemy.has_method("get_rifleman_shot_tell_arc_segment_count"):
			_smoke_assert(int(enemy.get_rifleman_shot_tell_arc_segment_count()) <= 24, "Rifleman bounty sightline should cap reticle arc segments for browser frame stability")
		return
	_smoke_assert(false, "Rifleman shot tell visual contract needs a live Rifleman enemy")

func _smoke_assert_last_high_noon_exit_lane_reward() -> void:
	_smoke_assert(_smoke_place_player_in_last_high_noon_exit_lane(), "wave 10 smoke should place the player inside the marked east exit lane")
	var rewards_before := _smoke_get_last_high_noon_exit_lane_reward_count()
	var style_before := style_score
	_update_last_high_noon_exit_lane(0.18)
	_update_last_high_noon_exit_lane(0.18)
	_smoke_assert(_smoke_get_last_high_noon_exit_lane_reward_count() > rewards_before, "wave 10 should reward holding the marked east exit lane before extraction")
	_smoke_assert(style_score > style_before, "wave 10 exit lane hold should award style points")
	var style_text: String = hud.get_style_pop_text() if hud != null and hud.has_method("get_style_pop_text") else ""
	_smoke_assert(style_text.find("EXIT LANE") >= 0, "wave 10 exit lane reward should show a style pop, got: %s" % style_text)

func _smoke_assert_finale_transition_receipt() -> void:
	var receipt := _smoke_get_wave_clear_feedback_text()
	_smoke_assert(receipt.find("JUNE DOWN") >= 0, "wave 9 clear receipt should confirm June is down, got: %s" % receipt)
	_smoke_assert(receipt.find("LAST HIGH NOON NEXT") >= 0, "wave 9 clear receipt should warn that Last High Noon is next, got: %s" % receipt)
	_smoke_assert(receipt.find("SAVE DASH") >= 0 and receipt.find("HUNTERS") >= 0, "wave 9 clear receipt should preserve dash for hunters, got: %s" % receipt)
	_smoke_assert(receipt.find("EXTRACT") >= 0, "wave 9 clear receipt should remind the player to extract after the finale, got: %s" % receipt)
	_smoke_assert(receipt.length() <= 120, "wave 9 clear receipt should stay compact for readability")

func _smoke_assert_training_completion_feedback() -> void:
	if hud == null or not is_instance_valid(hud) or not hud.has_method("get_training_tracker_text"):
		_smoke_assert(false, "rookie training ledger should expose readable smoke text")
		return
	var steps_before := _training_steps.duplicate(true)
	var active_before := _training_active
	var completion_before: int = int(hud.get_training_completion_count()) if hud.has_method("get_training_completion_count") else 0
	for key in _training_steps.keys():
		_training_steps[key] = true
	_training_active = true
	_update_training_tracker()
	var ledger_text: String = hud.get_training_tracker_text()
	_smoke_assert(hud.has_method("get_training_completion_count") and hud.get_training_completion_count() > completion_before, "training completion should show a basics-ready receipt")
	_smoke_assert(ledger_text.find("BASICS READY") >= 0, "training completion should headline basics readiness")
	_smoke_assert(ledger_text.find("DONE MOVE") >= 0 and ledger_text.find("DONE DASH") >= 0 and ledger_text.find("DONE SLASH") >= 0 and ledger_text.find("DONE CAST") >= 0, "training completion should mark every basic as done")
	_smoke_assert(ledger_text.find("CLEAR TEN LEVELS") >= 0, "training completion should point the player toward the ten-level run goal")
	_smoke_assert(ledger_text.find("PAYDAY SATCHELS OPTIONAL") >= 0, "training completion should teach that payday satchels are optional")
	_smoke_assert(ledger_text.find("CREDITS") >= 0 and ledger_text.find("ROUNDS") >= 0, "training completion should explain why payday satchels help")
	_smoke_assert(ledger_text.length() <= 150, "training completion receipt should stay compact for the HUD frame")
	_training_steps = steps_before
	_training_active = active_before
	hud.update_training_tracker(_training_steps, _get_training_tip(), _training_active)

func _smoke_assert_information_primer() -> void:
	if hud == null or not is_instance_valid(hud) or not hud.has_method("get_information_card_text"):
		return
	var info_text: String = hud.get_information_card_text()
	_smoke_assert(info_text.find("Hunter") >= 0, "information menu should include a Hunter enemy card")
	_smoke_assert(info_text.find("amber lunge lane") >= 0 and info_text.find("Sidestep") >= 0, "Hunter card should teach the lunge tell and sidestep counter")
	_smoke_assert(info_text.find("Late-wave pressure") >= 0, "Hunter card should identify its late-wave role")
	_smoke_assert(info_text.find("Read The Tells") >= 0, "information menu should include a compact combat-tells card")
	_smoke_assert(info_text.find("Boot dust") >= 0 and info_text.find("duelist dash") >= 0, "combat-tells card should teach duelist boot dust")
	_smoke_assert(info_text.find("Shell smoke") >= 0 and info_text.find("brute just fired") >= 0, "combat-tells card should teach shotgun brute recovery smoke")
	_smoke_assert(info_text.find("Reload Rhythm") >= 0, "information menu should include a compact reload-rhythm card")
	_smoke_assert(info_text.find("auto reload") >= 0 and info_text.find("brass glint") >= 0 and info_text.find("CYLINDER READY") >= 0, "reload-rhythm card should teach auto reload and the brass ready glint")
	_smoke_assert(info_text.find("Style Ranks") >= 0, "information menu should include a style-rank progression card")
	_smoke_assert(info_text.find("C 2600") >= 0 and info_text.find("S 12500") >= 0, "style-rank card should teach rank thresholds")
	_smoke_assert(info_text.find("LAST SECOND") >= 0 and info_text.find("mastery rewards") >= 0 and info_text.find("final grade") >= 0, "style-rank card should connect chain timing, mastery rewards, and final grade")
	_smoke_assert(info_text.find("Reverend Ash") >= 0, "information menu should include Reverend Ash set-piece flavor")
	_smoke_assert(info_text.find("Dust Chapel") >= 0 and info_text.find("brass chevrons") >= 0, "Reverend Ash card should teach Dust Chapel brute lanes")
	_smoke_assert(info_text.find("Gold Rush") >= 0, "information menu should include Gold Rush mastery flavor")
	_smoke_assert(info_text.find("Brass rails") >= 0 and info_text.find("paired powder kegs") >= 0, "Gold Rush card should teach paired-keg lane rails")
	_smoke_assert(info_text.find("chain pairs") >= 0 and info_text.find("POWDER KEG") >= 0, "Gold Rush card should teach paired keg chains as a style route")
	_smoke_assert(info_text.find("Red Canyon") >= 0, "information menu should include Red Canyon mastery flavor")
	_smoke_assert(info_text.find("Calm pockets") >= 0 and info_text.find("CANYON POCKET") >= 0, "Red Canyon card should teach calm-pocket style reward")
	_smoke_assert(info_text.find("June Blackglass") >= 0, "information menu should include June Blackglass boss flavor")
	_smoke_assert(info_text.find("glass kill box") >= 0 and info_text.find("Hold dash") >= 0, "June Blackglass card should teach kill-box pressure and dash preservation")
	_smoke_assert(info_text.find("Last High Noon") >= 0, "information menu should include Last High Noon mastery flavor")
	_smoke_assert(info_text.find("east exit lane") >= 0 and info_text.find("EXIT LANE") >= 0, "Last High Noon card should teach final exit-lane style reward")

func _smoke_assert_result_ledger() -> void:
	var ledger: String = hud.get_message_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(ledger.find("EXTRACTED") >= 0, "result ledger should announce extraction")
	_smoke_assert(ledger.find("TEN-LEVEL EXTRACTION") >= 0, "result ledger should celebrate a ten-level extraction")
	_smoke_assert(ledger.find("LEVELS CLEARED 10/10") >= 0, "result ledger should show all ten levels cleared")
	_smoke_assert(ledger.find("RODE EAST") >= 0 and ledger.find("LAST HIGH NOON") >= 0, "result ledger should confirm the ride-out from Last High Noon")
	_smoke_assert(ledger.find("RIVALS") >= 0 and ledger.find("JUNE BLACKGLASS") >= 0, "result ledger should show defeated named rivals")
	_smoke_assert(ledger.find("MASTERY") >= 0 and ledger.find("DUEL x1") >= 0 and ledger.find("CANYON x1") >= 0 and ledger.find("EXIT x1") >= 0, "result ledger should call out earned mastery rewards, got: %s" % ledger)
	_smoke_assert(ledger.find("POWDER KEG x") >= 0, "result ledger should remember Gold Rush powder-keg chain value, got: %s" % ledger)
	_smoke_assert(ledger.find("STYLE PEAK") >= 0 and ledger.find("RANK UPS x") >= 0, "result ledger should summarize live rank progression, got: %s" % ledger)
	_smoke_assert(ledger.find("BANKED") >= 0 and ledger.find("PAYDAY HAUL") >= 0, "result ledger should show banked credits and payday haul")
	_smoke_assert(ledger.length() <= 370, "result ledger should stay compact enough for the HUD frame")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_divider_count"):
		_smoke_assert(hud.get_result_divider_count() >= 3, "result ledger card should keep three brass dividers for scan readability")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_card_visual_version"):
		_smoke_assert(str(hud.get_result_card_visual_version()) == "result_card_side_receipt_detached_popout_light_wash_v6", "result ledger card should use the detached side receipt popout frame without a duplicate banner")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_card_detail_marker_count"):
		_smoke_assert(int(hud.get_result_card_detail_marker_count()) >= 62, "result ledger card should expose brass, ledger, receipt teeth, cartridge row, stamp, action rail, warrant badge, powder smear, side tabs, chips, stitches, rivets, seam loops, folded paper, staples, and audit plate markers")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_backdrop_dim_alpha"):
		_smoke_assert(float(hud.get_result_backdrop_dim_alpha()) <= 0.28, "result ledger should use a light stage wash instead of a heavy full-screen blackout")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_duplicate_banner_hidden"):
		_smoke_assert(bool(hud.get_result_duplicate_banner_hidden()), "result ledger should hide the duplicate top-screen banner so the popout owns the result presentation")
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_label_inset_in_card"):
		var result_geometry_debug := str(hud.get_result_geometry_debug()) if hud.has_method("get_result_geometry_debug") else ""
		_smoke_assert(bool(hud.get_result_label_inset_in_card()), "result ledger text should stay inset inside the popout card %s" % result_geometry_debug)
	if hud != null and is_instance_valid(hud) and hud.has_method("get_result_card_side_popout"):
		_smoke_assert(bool(hud.get_result_card_side_popout()), "result ledger card should sit as a side popout on desktop viewports")

func _smoke_assert_failed_run_popout() -> void:
	if hud == null or not is_instance_valid(hud):
		_smoke_assert(false, "failed run popout smoke needs HUD")
		return
	hud.show_run_failed("FELL AT LEVEL 1/10\nRANK D  SCORE 0")
	var death_text: String = hud.get_death_text() if hud.has_method("get_death_text") else ""
	_smoke_assert(death_text.find("YOU DIED") >= 0 and death_text.find("FELL AT LEVEL") >= 0, "failed run result should render inside the result popout label")
	if hud.has_method("get_result_card_visible"):
		_smoke_assert(bool(hud.get_result_card_visible()), "failed run result should use the popout result card instead of naked full-screen text")
	if hud.has_method("get_result_card_visual_version"):
		_smoke_assert(str(hud.get_result_card_visual_version()) == "result_card_side_receipt_detached_popout_light_wash_v6", "failed run popout should use the detached side receipt result frame")
	if hud.has_method("get_result_card_detail_marker_count"):
		_smoke_assert(int(hud.get_result_card_detail_marker_count()) >= 62, "failed run popout should expose brass, ledger, receipt teeth, cartridge row, stamp, action rail, warrant badge, powder smear, side tabs, chips, stitches, rivets, seam loops, folded paper, staples, and audit plate markers")
	if hud.has_method("get_result_backdrop_dim_alpha"):
		_smoke_assert(float(hud.get_result_backdrop_dim_alpha()) <= 0.28, "failed run popout should use a light stage wash instead of a heavy full-screen blackout")
	if hud.has_method("get_result_divider_count"):
		_smoke_assert(hud.get_result_divider_count() >= 3, "failed run popout should keep the brass result dividers visible")
	if hud.has_method("get_result_label_inset_in_card"):
		var failed_geometry_debug := str(hud.get_result_geometry_debug()) if hud.has_method("get_result_geometry_debug") else ""
		_smoke_assert(bool(hud.get_result_label_inset_in_card()), "failed run result text should stay inset inside the popout card %s" % failed_geometry_debug)
	if hud.has_method("get_result_card_side_popout"):
		_smoke_assert(bool(hud.get_result_card_side_popout()), "failed run result should sit as a side popout on desktop viewports")
	hud.show_main_menu()
	_smoke_assert(hud.get_death_text() == "", "opening the main menu should clear old death/result text instead of layering it over menu cards")

func _smoke_assert_first_empty_reload_feedback() -> void:
	if program_system == null or not is_instance_valid(program_system) or hud == null or not is_instance_valid(hud):
		return
	if not hud.has_method("get_style_pop_text"):
		return
	if vfx_layer == null or not vfx_layer.has_method("get_empty_reload_spin_total_count") or not vfx_layer.has_method("get_muzzle_flash_total_count") or not vfx_layer.has_method("get_muzzle_flash_visual_version") or not vfx_layer.has_method("get_muzzle_flash_material_marker_count"):
		_smoke_assert(false, "first empty reload nudge should expose VFX spin and muzzle flash counters")
		return
	_smoke_assert(str(vfx_layer.get_muzzle_flash_visual_version()) == "muzzle_flash_heat_shimmer_casing_star_v4", "gunshots should use the heat-shimmer, casing, and muzzle-star visual pass")
	_smoke_assert(int(vfx_layer.get_muzzle_flash_material_marker_count()) >= 10, "gunshots should expose heat cone, bone core, muzzle star, amber side jets, brass ring, smoke puffs, casing markers, shimmer rails, soot contact shadow, and casing ground shadows")
	var cooldowns_before: Dictionary = program_system.cooldowns.duplicate()
	var ammo_before: int = program_system.ammo_current
	var reload_before: float = program_system.reload_remaining
	var first_empty_before := _first_empty_reload_feedback_count
	var spins_before: int = int(vfx_layer.get_empty_reload_spin_total_count())
	var muzzle_flashes_before: int = int(vfx_layer.get_muzzle_flash_total_count())
	program_system.cooldowns.clear()
	program_system.ammo_current = 1
	program_system.reload_remaining = 0.0
	_first_empty_reload_feedback_shown = false
	_cast_program("deadeye")
	var ammo: Dictionary = program_system.get_ammo_summary()
	var pop_text: String = hud.get_style_pop_text()
	_smoke_assert(bool(ammo.get("reloading", false)), "spending the last round should start auto reload")
	_smoke_assert(pop_text.find("AUTO RELOAD") >= 0 and pop_text.find("READY GLINT") >= 0, "first last-round cast should point players toward the ready glint")
	_smoke_assert(_first_empty_reload_feedback_count > first_empty_before, "first last-round cast should count the one-time empty-cylinder coaching nudge")
	_smoke_assert(int(vfx_layer.get_empty_reload_spin_total_count()) > spins_before, "first last-round cast should flash an in-world empty-cylinder spin")
	_smoke_assert(int(vfx_layer.get_muzzle_flash_total_count()) > muzzle_flashes_before, "first last-round gun cast should throw the upgraded muzzle flash and casing VFX")
	program_system.cooldowns = cooldowns_before
	program_system.ammo_current = ammo_before
	program_system.reload_remaining = reload_before
	_first_empty_reload_feedback_shown = true

func _smoke_assert_reload_ready_feedback() -> void:
	if program_system == null or not is_instance_valid(program_system) or hud == null or not is_instance_valid(hud):
		return
	if not hud.has_method("get_style_pop_text"):
		return
	if vfx_layer == null or not vfx_layer.has_method("get_reload_ready_glint_total_count"):
		_smoke_assert(false, "reload-ready feedback should expose a VFX glint counter")
		return
	var ammo_before: int = program_system.ammo_current
	var reload_before: float = program_system.reload_remaining
	var latch_before := _ammo_was_reloading
	var glints_before: int = int(vfx_layer.get_reload_ready_glint_total_count())
	program_system.ammo_current = program_system.ammo_capacity
	program_system.reload_remaining = 0.0
	_ammo_was_reloading = true
	_update_reload_ready_feedback()
	var pop_text: String = hud.get_style_pop_text()
	_smoke_assert(pop_text.find("CYLINDER READY") >= 0 and pop_text.find("FULL") >= 0 and pop_text.find("DRAW") >= 0, "reload completion should show a full-cylinder ready feedback pop")
	_smoke_assert(int(vfx_layer.get_reload_ready_glint_total_count()) > glints_before, "reload completion should flash a player-side cylinder-ready glint")
	_smoke_assert(not _ammo_was_reloading, "reload-ready feedback should clear the reload latch")
	program_system.ammo_current = ammo_before
	program_system.reload_remaining = reload_before
	_ammo_was_reloading = latch_before

func _smoke_assert(condition: bool, message: String) -> void:
	if not condition:
		_smoke_failures.append(message)

func _smoke_modifier_has_animated_overlay(modifier_id: String) -> bool:
	return modifier_id == "open" or modifier_id == "crossfire" or modifier_id == "duel" or modifier_id == "rush" or modifier_id == "bells" or modifier_id == "mercy" or modifier_id == "sandstorm" or modifier_id == "gold_rush" or modifier_id == "blackglass" or modifier_id == "last_stand"

func _smoke_has_boss_enemy() -> bool:
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.has_meta("boss"):
			return true
	return false

func _smoke_has_black_sash_signature_mark() -> bool:
	return current_wave == 3 and str(_get_level_modifier(current_wave).get("id", "")) == "duel" and _smoke_has_boss_named("THE BLACK SASH") and not vault_data.is_empty()

func _smoke_place_player_in_black_sash_duel_ground() -> bool:
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		return false
	player.global_position = _get_black_sash_duel_ground_origin(vault_data["arena"] as Rect2)
	player.velocity = Vector2.ZERO
	if camera != null:
		camera.offset = Vector2.ZERO
		camera.reset_smoothing()
	return _is_point_in_black_sash_duel_ground(player.global_position)

func _smoke_has_red_canyon_route_pockets() -> bool:
	return current_wave == 7 and str(_get_level_modifier(current_wave).get("id", "")) == "sandstorm" and not vault_data.is_empty()

func _smoke_place_player_in_red_canyon_route_pocket() -> bool:
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		return false
	var pockets := _get_red_canyon_route_pocket_rects(vault_data["arena"] as Rect2)
	if pockets.is_empty():
		return false
	player.global_position = (pockets[0] as Rect2).get_center()
	player.velocity = Vector2.ZERO
	if camera != null:
		camera.offset = Vector2.ZERO
		camera.reset_smoothing()
	return true

func _smoke_place_player_in_last_high_noon_exit_lane() -> bool:
	if player == null or not is_instance_valid(player) or vault_data.is_empty() or not vault_data.has("arena"):
		return false
	player.global_position = _get_last_high_noon_exit_lane_rect(vault_data["arena"] as Rect2).get_center()
	player.velocity = Vector2.ZERO
	if camera != null:
		camera.offset = Vector2.ZERO
		camera.reset_smoothing()
	return true

func _smoke_has_boss_named(expected_name: String) -> bool:
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.has_meta("boss") and str(enemy.get_meta("duelist_name", "")) == expected_name:
			return true
	return false

func _smoke_enemy_matches_kind(enemy: Node, enemy_kind: String) -> bool:
	if not is_instance_valid(enemy):
		return false
	if enemy_kind == "":
		return true
	var script_path := ""
	var enemy_script: Script = enemy.get_script()
	if enemy_script != null:
		script_path = str(enemy_script.resource_path)
	return script_path.find(enemy_kind) >= 0

func _smoke_count_enemy_kind(enemy_kind: String) -> int:
	var count := 0
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, enemy_kind):
			count += 1
	return count

func _smoke_stage_enemy_kind_near_player(enemy_kind: String, offset: Vector2) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	for enemy in enemies:
		if _smoke_enemy_matches_kind(enemy, enemy_kind) and enemy is Node2D:
			var enemy_node := enemy as Node2D
			enemy_node.global_position = player.global_position + offset
			return true
	return false

func _smoke_stage_duelist_release_tell(variant_id: String, offset: Vector2) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	for enemy in enemies:
		if not _smoke_enemy_matches_kind(enemy, "duelist") or not (enemy is Node2D):
			continue
		if str(enemy.get("variant_id")) != variant_id:
			continue
		var enemy_node := enemy as Node2D
		enemy_node.global_position = player.global_position + offset
		var direction := enemy_node.global_position.direction_to(player.global_position)
		if direction.length_squared() <= 0.001:
			direction = Vector2.LEFT
		enemy.set("_attack_cooldown", 0.0)
		enemy.set("_dash_timer", 0.0)
		enemy.set("_draw_timer", 0.16)
		enemy.set("_duel_direction", direction.normalized())
		enemy_node.queue_redraw()
		return true
	return false

func _smoke_stage_shotgun_brute_recovery_tell(offset: Vector2) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	for enemy in enemies:
		if not _smoke_enemy_matches_kind(enemy, "shotgun_brute") or not (enemy is Node2D):
			continue
		var enemy_node := enemy as Node2D
		enemy_node.global_position = player.global_position + offset
		var direction := enemy_node.global_position.direction_to(player.global_position)
		if direction.length_squared() <= 0.001:
			direction = Vector2.LEFT
		enemy.set("_windup_timer", 0.0)
		enemy.set("_recoil_timer", 0.08)
		enemy.set("_recover_tell_timer", 0.30)
		enemy.set("_aim_direction", direction.normalized())
		enemy_node.queue_redraw()
		return true
	return false

func _smoke_stage_hunter_lunge_afterimage(offset: Vector2) -> bool:
	if player == null or not is_instance_valid(player):
		return false
	for enemy in enemies:
		if not _smoke_enemy_matches_kind(enemy, "hunter") or not (enemy is Node2D):
			continue
		var enemy_node := enemy as Node2D
		enemy_node.global_position = player.global_position + offset
		var direction := enemy_node.global_position.direction_to(player.global_position)
		if direction.length_squared() <= 0.001:
			direction = Vector2.LEFT
		var facing := direction.normalized()
		enemy.set("_windup_timer", 0.0)
		enemy.set("_lunge_timer", 0.12)
		enemy.set("_lunge_cooldown", 0.8)
		enemy.set("_lunge_direction", facing)
		enemy.set("_lunge_afterimages", [
			{"offset": -facing * 88.0, "age": 0.0, "life": 0.22, "facing": facing},
			{"offset": -facing * 58.0, "age": 0.03, "life": 0.22, "facing": facing},
			{"offset": -facing * 34.0, "age": 0.06, "life": 0.22, "facing": facing},
		])
		enemy_node.queue_redraw()
		if vfx_layer != null and vfx_layer.has_method("trail_pop"):
			vfx_layer.trail_pop(enemy_node.global_position - facing * 72.0, Color(0.78, 0.42, 0.18))
		return true
	return false

func _smoke_has_enemy_attack_tell(enemy_kind: String = "") -> bool:
	for enemy in enemies:
		if not is_instance_valid(enemy) or not enemy.has_method("has_attack_tell"):
			continue
		if enemy_kind != "":
			if not _smoke_enemy_matches_kind(enemy, enemy_kind):
				continue
		if bool(enemy.call("has_attack_tell")):
			return true
	return false

func _smoke_wait_for_enemy_attack_tell(enemy_kind: String, max_frames: int) -> bool:
	for frame in range(max_frames):
		if _smoke_has_enemy_attack_tell(enemy_kind):
			return true
		await get_tree().physics_frame
	return false

func _smoke_wait_for_enemy_method_true(enemy_kind: String, method_name: String, max_frames: int) -> bool:
	for frame in range(max_frames):
		for enemy in enemies:
			if not _smoke_enemy_matches_kind(enemy, enemy_kind) or not enemy.has_method(method_name):
				continue
			if bool(enemy.call(method_name)):
				return true
		await get_tree().physics_frame
	return false

func _smoke_get_enemy_kind_method_origin(enemy_kind: String, method_name: String) -> Vector2:
	for enemy in enemies:
		if not _smoke_enemy_matches_kind(enemy, enemy_kind) or not enemy.has_method(method_name) or not (enemy is Node2D):
			continue
		if bool(enemy.call(method_name)):
			return (enemy as Node2D).global_position
	return Vector2(-1.0, -1.0)

func _smoke_get_audio_cue_count(cue: String) -> int:
	if audio_director != null and audio_director.has_method("get_played_count"):
		return int(audio_director.get_played_count(cue))
	return 0

func _smoke_get_hunter_lunge_warning_count() -> int:
	if hud != null and hud.has_method("get_hunter_lunge_warning_count"):
		return int(hud.get_hunter_lunge_warning_count())
	return 0

func _smoke_get_red_canyon_pocket_reward_count() -> int:
	return _red_canyon_pocket_reward_count

func _smoke_get_last_high_noon_exit_lane_reward_count() -> int:
	return _last_high_noon_exit_lane_reward_count

func _smoke_get_chain_break_feedback_count() -> int:
	return _chain_break_feedback_count

func _smoke_get_last_second_chain_bonus_count() -> int:
	return _last_second_chain_bonus_count

func _smoke_get_rank_up_feedback_count() -> int:
	return _rank_up_feedback_count

func _smoke_get_mastery_payoff_feedback_count() -> int:
	return _mastery_payoff_feedback_count

func _smoke_get_black_sash_lunge_warning_count() -> int:
	if hud != null and hud.has_method("get_black_sash_lunge_warning_count"):
		return int(hud.get_black_sash_lunge_warning_count())
	return 0

func _smoke_get_mercy_vale_lunge_warning_count() -> int:
	if hud != null and hud.has_method("get_mercy_vale_lunge_warning_count"):
		return int(hud.get_mercy_vale_lunge_warning_count())
	return 0

func _smoke_get_june_blackglass_lunge_warning_count() -> int:
	if hud != null and hud.has_method("get_june_blackglass_lunge_warning_count"):
		return int(hud.get_june_blackglass_lunge_warning_count())
	return 0

func _smoke_get_rifle_warning_puff_count() -> int:
	if vfx_layer != null and vfx_layer.has_method("get_rifle_warning_puff_count"):
		return int(vfx_layer.get_rifle_warning_puff_count())
	return 0

func _smoke_get_rifle_warning_puff_total_count() -> int:
	if vfx_layer != null and vfx_layer.has_method("get_rifle_warning_puff_total_count"):
		return int(vfx_layer.get_rifle_warning_puff_total_count())
	return 0

func _smoke_assert_enemy_weapon_burst_visual_upgrade() -> void:
	if vfx_layer == null or not is_instance_valid(vfx_layer) or not vfx_layer.has_method("get_enemy_weapon_burst_visual_version") or not vfx_layer.has_method("get_enemy_weapon_burst_total_count"):
		_smoke_assert(false, "enemy weapon burst visual smoke needs VFX version and counter hooks")
		return
	_smoke_assert(str(vfx_layer.get_enemy_weapon_burst_visual_version()) == "enemy_weapon_burst_smoke_v1", "enemy rifle and shotgun fire should use the shared smoke-and-shell burst visual pass")

func _smoke_assert_enemy_movement_dust_visual_upgrade() -> void:
	if vfx_layer == null or not is_instance_valid(vfx_layer) or not vfx_layer.has_method("get_enemy_movement_dust_visual_version") or not vfx_layer.has_method("get_enemy_movement_dust_total_count"):
		_smoke_assert(false, "enemy movement dust smoke needs VFX version and counter hooks")
		return
	_smoke_assert(str(vfx_layer.get_enemy_movement_dust_visual_version()) == "enemy_movement_boot_dust_v1", "moving enemies should use capped boot-dust VFX")
	var target: Node2D = null
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy is Node2D:
			if enemy.has_method("get_enemy_movement_dust_integration_version"):
				_smoke_assert(str(enemy.get_enemy_movement_dust_integration_version()) == "enemy_movement_boot_dust_v1", "enemy movement dust should be integrated through base enemy movement")
			target = enemy
			break
	if target == null:
		_smoke_assert(false, "enemy movement dust smoke needs a live enemy")
		return
	var dust_before := int(vfx_layer.get_enemy_movement_dust_total_count())
	if player != null and is_instance_valid(player):
		target.global_position = player.global_position + Vector2(320.0, 0.0)
	if target.has_method("_physics_process"):
		for step in range(8):
			target._physics_process(0.08)
			if int(vfx_layer.get_enemy_movement_dust_total_count()) > dust_before:
				break
	_smoke_assert(int(vfx_layer.get_enemy_movement_dust_total_count()) > dust_before, "moving enemy should emit capped boot-dust VFX")

func _smoke_get_enemy_weapon_burst_total_count() -> int:
	if vfx_layer != null and vfx_layer.has_method("get_enemy_weapon_burst_total_count"):
		return int(vfx_layer.get_enemy_weapon_burst_total_count())
	return 0

func _smoke_get_extraction_rideout_total_count() -> int:
	if vfx_layer != null and vfx_layer.has_method("get_extraction_rideout_total_count"):
		return int(vfx_layer.get_extraction_rideout_total_count())
	return 0

func _smoke_get_payday_feedback_count() -> int:
	if hud != null and hud.has_method("get_payday_feedback_count"):
		return int(hud.get_payday_feedback_count())
	return 0

func _smoke_get_payday_feedback_text() -> String:
	if hud != null and hud.has_method("get_payday_feedback_text"):
		return str(hud.get_payday_feedback_text())
	return ""

func _smoke_get_payday_pointer_count() -> int:
	var count := 0
	for pickup in payday_pickups:
		if _is_payday_pointer_visible(pickup):
			count += 1
	return count

func _smoke_get_payday_route_hint_count() -> int:
	var count := 0
	for pickup in payday_pickups:
		if _is_payday_route_hint_visible(pickup):
			count += 1
	return count

func _smoke_get_payday_optional_label_count() -> int:
	var count := 0
	for pickup in payday_pickups:
		if _is_payday_optional_label_visible(pickup):
			count += 1
	return count

func _smoke_get_wave_clear_feedback_count() -> int:
	if hud != null and hud.has_method("get_wave_clear_feedback_count"):
		return int(hud.get_wave_clear_feedback_count())
	return 0

func _smoke_get_wave_clear_feedback_text() -> String:
	if hud != null and hud.has_method("get_wave_clear_feedback_text"):
		return str(hud.get_wave_clear_feedback_text())
	return ""

func _smoke_assert_gold_rush_keg_chain() -> void:
	_smoke_assert(arena_hazards.size() == 8, "wave 8 Gold Rush should spawn eight powder kegs")
	var tip: String = hud.get_objective_tip_text() if hud != null and is_instance_valid(hud) else ""
	_smoke_assert(tip.find("BANK VAULT") >= 0 and tip.find("BAIT") >= 0, "Gold Rush HUD tip should identify the Bank Vault and teach baiting enemies, got: %s" % tip)
	_smoke_assert(tip.find("LANES") >= 0 and tip.find("CHAIN PAIRS") >= 0, "Gold Rush HUD tip should teach blast lanes and paired keg chains, got: %s" % tip)
	_smoke_assert(tip.length() <= 72, "Gold Rush HUD tip should stay compact for readability")
	if arena_hazards.size() < 2:
		return
	var first_hazard: Dictionary = arena_hazards[0]
	var second_hazard: Dictionary = arena_hazards[1]
	var first_origin: Vector2 = first_hazard["origin"]
	var second_origin: Vector2 = second_hazard["origin"]
	var chain_distance: float = first_origin.distance_to(second_origin)
	_smoke_assert(chain_distance <= float(first_hazard.get("radius", 120.0)) * 1.1, "Gold Rush should pair kegs close enough to chain")
	var active_enemies := enemies.filter(func(enemy: Node2D) -> bool: return is_instance_valid(enemy))
	_smoke_assert(active_enemies.size() >= 4, "Gold Rush smoke should have enemies to reward keg mastery")
	if active_enemies.size() < 4:
		return
	active_enemies[0].global_position = first_origin + Vector2(18.0, 0.0)
	active_enemies[1].global_position = first_origin + Vector2(-22.0, 14.0)
	active_enemies[2].global_position = second_origin + Vector2(18.0, 0.0)
	active_enemies[3].global_position = second_origin + Vector2(-22.0, 14.0)
	var score_before := style_score
	var keg_hits_before := keg_chain_bonus
	var mastery_payoffs_before := _smoke_get_mastery_payoff_feedback_count()
	_ignite_arena_hazard(0)
	_smoke_tick_hazard_fuse(float(first_hazard.get("fuse_max", 0.55)) + 0.05)
	_smoke_assert(bool(arena_hazards[0].get("spent", false)), "first Gold Rush keg should explode after its fuse")
	_smoke_assert(float(arena_hazards[1].get("fuse", 0.0)) > 0.0, "first Gold Rush keg should light its paired keg")
	_smoke_assert(keg_chain_bonus >= keg_hits_before + 2, "first Gold Rush keg should hit staged enemies")
	_smoke_assert(style_score > score_before, "first Gold Rush keg should award style points")
	_smoke_assert(_smoke_get_mastery_payoff_feedback_count() > mastery_payoffs_before, "first Gold Rush keg should trigger a brass mastery payoff burst")
	var score_after_first := style_score
	_smoke_tick_hazard_fuse(float(second_hazard.get("fuse_max", 0.55)) + 0.05)
	_smoke_assert(bool(arena_hazards[1].get("spent", false)), "paired Gold Rush keg should finish the chain")
	_smoke_assert(keg_chain_bonus >= keg_hits_before + 4, "paired Gold Rush keg should add chained enemy hits")
	_smoke_assert(style_score > score_after_first, "paired Gold Rush keg should award extra style")
	_smoke_assert(_smoke_get_mastery_payoff_feedback_count() >= mastery_payoffs_before + 2, "paired Gold Rush keg should add a second brass mastery payoff burst")

func _smoke_assert_brute_shotgun_tell() -> void:
	_smoke_assert(_smoke_count_enemy_kind("shotgun_brute") > 0, "Dust Chapel should spawn shotgun brutes for tell validation")
	_smoke_assert(_smoke_stage_enemy_kind_near_player("shotgun_brute", Vector2(230.0, 0.0)), "Dust Chapel smoke should stage a shotgun brute inside wind-up range")
	var enemy_weapon_bursts_before := _smoke_get_enemy_weapon_burst_total_count()
	_smoke_assert_enemy_weapon_burst_visual_upgrade()
	_smoke_assert(await _smoke_wait_for_enemy_attack_tell("shotgun_brute", 45), "shotgun brute should expose a readable wide-blast wind-up before firing")
	if player != null and is_instance_valid(player):
		player.global_position += Vector2(-420.0, -180.0)
	_smoke_assert(await _smoke_wait_for_enemy_method_true("shotgun_brute", "has_recover_tell", 60), "shotgun brute should show a readable recovery tell after firing")
	_smoke_assert(_smoke_get_enemy_weapon_burst_total_count() > enemy_weapon_bursts_before, "shotgun brute should throw the enemy shotgun blast smoke VFX")

func _smoke_tick_hazard_fuse(duration: float) -> void:
	var remaining := duration
	while remaining > 0.0:
		var step := minf(0.05, remaining)
		_update_arena_hazards(step)
		remaining -= step

func _smoke_clear_wave() -> void:
	for enemy in enemy_root.get_children():
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()

func _draw() -> void:
	if vault_data.is_empty():
		return

	var arena: Rect2 = vault_data["arena"]
	_draw_dark_western_backdrop()
	draw_rect(arena, Color(0.69, 0.43, 0.18, 1.0), true)
	if sand_texture != null:
		draw_texture_rect(sand_texture, arena, true, Color(0.96, 0.86, 0.68, 0.95))
	draw_rect(arena, Color(0.42, 0.24, 0.09, 0.16), true)
	draw_rect(arena.grow(-14.0), Color(1.0, 0.82, 0.46, 0.16), false, 3.0)
	draw_rect(arena, Color(0.43, 0.24, 0.1, 0.72), false, 8.0)
	draw_rect(arena.grow(-42.0), Color(1.0, 0.9, 0.56, 0.14), false, 2.0)

	_draw_sand_detail(arena)
	_draw_high_noon_stage_lighting(arena)
	_draw_high_noon_edge_atmosphere(arena)
	_draw_level_modifier_effects(arena)
	_draw_arena_cover_props()

func _load_environment_textures() -> void:
	sand_texture = load(SAND_TEXTURE_PATH) as Texture2D
	if sand_texture == null:
		push_warning("Could not load sand texture: %s" % SAND_TEXTURE_PATH)
	wood_texture = load(WOOD_TEXTURE_PATH) as Texture2D
	if wood_texture == null:
		push_warning("Could not load wood texture: %s" % WOOD_TEXTURE_PATH)
	porch_texture = load(PORCH_TEXTURE_PATH) as Texture2D
	if porch_texture == null:
		push_warning("Could not load porch texture: %s" % PORCH_TEXTURE_PATH)
	fence_texture = load(FENCE_TEXTURE_PATH) as Texture2D
	if fence_texture == null:
		push_warning("Could not load fence texture: %s" % FENCE_TEXTURE_PATH)

func _draw_dark_western_backdrop() -> void:
	var bounds := _get_vault_bounds().grow(520.0)
	var arena := _get_vault_bounds()
	if _should_use_runtime_backdrop_plate():
		_draw_runtime_town_backdrop_plate(bounds, arena)
		return
	draw_rect(bounds, Color(0.028, 0.019, 0.014, 1.0), true)

	var horizon_y := bounds.position.y + bounds.size.y * 0.22
	draw_rect(Rect2(bounds.position, Vector2(bounds.size.x, bounds.size.y * 0.24)), Color(0.008, 0.006, 0.006, 1.0), true)
	draw_line(Vector2(bounds.position.x, horizon_y), Vector2(bounds.end.x, horizon_y), Color(0.62, 0.28, 0.12, 0.42), 4.0)

	for i in range(7):
		var t := float(i) / 6.0
		var y := lerpf(horizon_y + 50.0, bounds.end.y - 80.0, t)
		var alpha := lerpf(0.12, 0.035, t)
		draw_line(Vector2(bounds.position.x, y), Vector2(bounds.end.x, y), Color(0.62, 0.34, 0.16, alpha), 2.0)

	for i in range(12):
		var x := bounds.position.x + i * 220.0
		draw_line(Vector2(x, horizon_y), Vector2(x - 260.0, bounds.end.y), Color(0.52, 0.25, 0.1, 0.055), 2.0)
		draw_line(Vector2(x, horizon_y), Vector2(x + 260.0, bounds.end.y), Color(0.52, 0.25, 0.1, 0.055), 2.0)

	for i in range(9):
		var dune_y := bounds.position.y + bounds.size.y * (0.36 + i * 0.055)
		var start := Vector2(bounds.position.x - 80.0, dune_y)
		var end := Vector2(bounds.end.x + 80.0, dune_y + sin(i * 1.7) * 52.0)
		draw_line(start, end, Color(0.33, 0.18, 0.08, 0.16), 10.0)

	for i in range(10):
		var mesa_x := bounds.position.x + 160.0 + i * 310.0
		var mesa_w := 90.0 + float((i * 37) % 70)
		var mesa_h := 55.0 + float((i * 23) % 80)
		var mesa_rect := Rect2(Vector2(mesa_x, horizon_y - mesa_h), Vector2(mesa_w, mesa_h))
		draw_rect(mesa_rect, Color(0.055, 0.03, 0.022, 0.9), true)
		draw_rect(mesa_rect, Color(0.48, 0.22, 0.09, 0.28), false, 2.0)

	_draw_old_west_perimeter(bounds, arena)

func _should_use_runtime_backdrop_plate() -> bool:
	return not _smoke_test_active

func _draw_runtime_town_backdrop_plate(bounds: Rect2, arena: Rect2) -> void:
	draw_rect(bounds, Color(0.028, 0.019, 0.014, 1.0), true)
	var horizon_y := bounds.position.y + bounds.size.y * 0.22
	draw_rect(Rect2(bounds.position, Vector2(bounds.size.x, bounds.size.y * 0.24)), Color(0.008, 0.006, 0.006, 1.0), true)
	draw_line(Vector2(bounds.position.x, horizon_y), Vector2(bounds.end.x, horizon_y), Color(0.62, 0.28, 0.12, 0.42), 4.0)
	for band in range(4):
		var t := float(band) / 3.0
		var y := lerpf(horizon_y + 72.0, bounds.end.y - 130.0, t)
		draw_line(Vector2(bounds.position.x, y), Vector2(bounds.end.x, y + sin(float(band) * 1.7) * 18.0), Color(0.44, 0.24, 0.1, 0.075), 5.0)

	var street_color := Color(0.31, 0.17, 0.073, 0.58)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 260.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.end.y + 30.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 30.0), Vector2(arena.position.x - bounds.position.x - 30.0, arena.size.y + 60.0)), street_color, true)
	draw_rect(Rect2(Vector2(arena.end.x + 30.0, arena.position.y - 30.0), Vector2(bounds.end.x - arena.end.x - 30.0, arena.size.y + 60.0)), street_color, true)

	var business_count := TOWN_BUSINESS_ROSTER.size()
	for i in range(business_count):
		var top_width := 168.0 + float(i % 3) * 18.0
		var top_x := arena.position.x - 92.0 + float(i) * ((arena.size.x + 184.0) / maxf(1.0, float(business_count - 1))) - top_width * 0.5
		var top_rect := Rect2(Vector2(top_x, arena.position.y - 236.0 - float(i % 2) * 10.0), Vector2(top_width, 198.0))
		_draw_runtime_business_facade(top_rect, TOWN_BUSINESS_ROSTER[i], "top")
		_draw_runtime_storefront_prop_strip(top_rect, TOWN_BUSINESS_ROSTER[i], "top", i)
		var bottom_index := (i + 3) % business_count
		var bottom_width := 158.0 + float(bottom_index % 4) * 16.0
		var bottom_x := arena.position.x - 76.0 + float(i) * ((arena.size.x + 152.0) / maxf(1.0, float(business_count - 1))) - bottom_width * 0.5
		var bottom_rect := Rect2(Vector2(bottom_x, arena.end.y + 54.0 + float(i % 2) * 9.0), Vector2(bottom_width, 184.0))
		_draw_runtime_business_facade(bottom_rect, TOWN_BUSINESS_ROSTER[bottom_index], "bottom")
		_draw_runtime_storefront_prop_strip(bottom_rect, TOWN_BUSINESS_ROSTER[bottom_index], "bottom", bottom_index)

	for side_i in range(4):
		var left_business: Dictionary = TOWN_BUSINESS_ROSTER[(side_i + 5) % business_count]
		var right_business: Dictionary = TOWN_BUSINESS_ROSTER[(side_i + 1) % business_count]
		var y := arena.position.y + 76.0 + float(side_i) * ((arena.size.y - 152.0) / 3.0)
		var left_rect := Rect2(Vector2(arena.position.x - 260.0, y - 76.0), Vector2(184.0, 152.0))
		var right_rect := Rect2(Vector2(arena.end.x + 76.0, y - 76.0), Vector2(184.0, 152.0))
		_draw_runtime_business_facade(left_rect, left_business, "left")
		_draw_runtime_storefront_prop_strip(left_rect, left_business, "left", side_i + 5)
		_draw_runtime_business_facade(right_rect, right_business, "right")
		_draw_runtime_storefront_prop_strip(right_rect, right_business, "right", side_i + 1)

	_draw_runtime_threshold_plate(arena)

func _draw_runtime_business_facade(rect: Rect2, business: Dictionary, edge: String) -> void:
	var plank: Color = business.get("plank", Color(0.2, 0.09, 0.04, 0.96))
	var trim: Color = business.get("trim", Color(0.72, 0.44, 0.18, 0.86))
	var accent: Color = business.get("accent", Color(0.84, 0.5, 0.18, 0.86))
	var shadow := Color(0.012, 0.006, 0.003, 0.38)
	draw_rect(Rect2(rect.position + Vector2(10.0, 12.0), rect.size), shadow, true)
	draw_rect(rect, plank.darkened(0.18), true)
	draw_rect(rect.grow(-7.0), plank.lightened(0.08), true)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x, 26.0)), trim.darkened(0.18), true)
	draw_rect(Rect2(rect.position + Vector2(8.0, 8.0), Vector2(maxf(0.0, rect.size.x - 16.0), 12.0)), accent.darkened(0.08), true)
	draw_line(rect.position + Vector2(12.0, 36.0), rect.position + Vector2(rect.size.x - 12.0, 34.0), Color(1.0, 0.7, 0.24, 0.16), 2.0)
	draw_line(rect.position + Vector2(12.0, rect.size.y - 18.0), rect.position + Vector2(rect.size.x - 12.0, rect.size.y - 20.0), Color(0.02, 0.008, 0.004, 0.42), 3.0)
	var door := Rect2(rect.position + Vector2(rect.size.x * 0.5 - 18.0, rect.size.y - 72.0), Vector2(36.0, 62.0))
	draw_rect(door, Color(0.055, 0.024, 0.012, 0.86), true)
	draw_line(door.position + Vector2(door.size.x * 0.5, 6.0), door.position + Vector2(door.size.x * 0.5, door.size.y - 4.0), Color(0.86, 0.48, 0.18, 0.28), 1.4)
	for window_x in [rect.size.x * 0.23, rect.size.x * 0.77]:
		var window := Rect2(rect.position + Vector2(window_x - 14.0, rect.size.y - 82.0), Vector2(28.0, 36.0))
		draw_rect(window, Color(0.035, 0.018, 0.012, 0.82), true)
		draw_rect(window.grow(-4.0), Color(0.95, 0.58, 0.16, 0.13), true)
		draw_rect(window, trim, false, 1.3)
	var icon_center := rect.position + Vector2(rect.size.x * 0.5, 52.0)
	_draw_business_icon(icon_center, str(business.get("icon", "crate")), accent.lightened(0.12), 0.58)
	var font := ThemeDB.fallback_font
	if font != null and rect.size.x >= 135.0 and (edge == "top" or edge == "bottom"):
		var label_rect := Rect2(rect.position + Vector2(12.0, 72.0), Vector2(rect.size.x - 24.0, 20.0))
		draw_string(font, label_rect.position + Vector2(1.0, 15.0), str(business.get("name", "")), HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 14, Color(0.02, 0.009, 0.004, 0.78))
		draw_string(font, label_rect.position + Vector2(0.0, 14.0), str(business.get("name", "")), HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 14, Color(0.95, 0.78, 0.48, 0.84))

func _draw_runtime_storefront_prop_strip(rect: Rect2, business: Dictionary, edge: String, index: int) -> void:
	var business_id := str(business.get("id", "saloon"))
	var trim: Color = business.get("trim", Color(0.72, 0.44, 0.18, 0.86))
	var accent: Color = business.get("accent", Color(0.84, 0.5, 0.18, 0.86))
	var shadow := Color(0.012, 0.006, 0.003, 0.24)
	var rail := Color(0.11, 0.048, 0.021, 0.74)
	var brass := Color(1.0, 0.7, 0.24, 0.24)
	var front_y := rect.end.y - 14.0 if edge == "top" else rect.position.y + 12.0
	if edge == "left" or edge == "right":
		front_y = rect.position.y + rect.size.y * 0.68
	var start_x := rect.position.x + 18.0
	var end_x := rect.end.x - 18.0
	draw_line(Vector2(start_x, front_y + 7.0), Vector2(end_x, front_y + 4.0), shadow, 7.0)
	draw_line(Vector2(start_x, front_y), Vector2(end_x, front_y - 3.0), rail, 3.0)
	for post in range(3):
		var t := float(post) / 2.0
		var x := lerpf(start_x + 8.0, end_x - 8.0, t)
		draw_line(Vector2(x, front_y - 17.0), Vector2(x + 2.0, front_y + 13.0), rail.darkened(0.12), 2.6)
		draw_circle(Vector2(x, front_y - 16.0), 2.2, brass)
	var hook_origin := rect.position + Vector2(rect.size.x * 0.78, 31.0)
	draw_line(hook_origin, hook_origin + Vector2(0.0, 24.0), Color(0.035, 0.016, 0.008, 0.6), 1.7)
	draw_arc(hook_origin + Vector2(0.0, 21.0), 7.0, 0.2, PI * 1.25, 10, trim.lightened(0.05), 1.4)
	match business_id:
		"saloon":
			_draw_runtime_sidewalk_barrels(rect.position + Vector2(rect.size.x * 0.2, front_y - 7.0), accent)
			_draw_business_icon(rect.position + Vector2(rect.size.x * 0.72, front_y - 22.0), "bottle", accent.lightened(0.16), 0.36)
		"barber":
			_draw_runtime_barber_stand(rect.position + Vector2(rect.size.x * 0.18, front_y - 30.0), accent)
		"sheriff":
			_draw_runtime_hitch_rail_notice(rect.position + Vector2(rect.size.x * 0.18, front_y - 28.0), accent)
		"bank":
			_draw_runtime_strongbox_stack(rect.position + Vector2(rect.size.x * 0.18, front_y - 13.0), accent)
		"general":
			_draw_runtime_crate_stack(rect.position + Vector2(rect.size.x * 0.2, front_y - 13.0), trim)
		"hotel":
			_draw_runtime_luggage_stack(rect.position + Vector2(rect.size.x * 0.2, front_y - 13.0), accent)
		"stable":
			_draw_runtime_hay_bales(rect.position + Vector2(rect.size.x * 0.2, front_y - 11.0), trim)
		"doctor":
			_draw_runtime_medicine_case(rect.position + Vector2(rect.size.x * 0.19, front_y - 14.0), accent)
		_:
			_draw_runtime_crate_stack(rect.position + Vector2(rect.size.x * 0.2, front_y - 13.0), trim)
	if index % 2 == 0:
		var lamp := Rect2(rect.position + Vector2(rect.size.x * 0.58, 43.0), Vector2(13.0, 18.0))
		draw_rect(lamp, Color(0.045, 0.02, 0.009, 0.72), true)
		draw_rect(lamp.grow(-3.0), Color(1.0, 0.58, 0.14, 0.18), true)
		draw_rect(lamp, accent.lightened(0.14), false, 1.0)

func _draw_runtime_sidewalk_barrels(origin: Vector2, accent: Color) -> void:
	for i in range(2):
		var center := origin + Vector2(float(i) * 18.0, 0.0)
		_draw_flat_ellipse(center + Vector2(3.0, 10.0), Vector2(13.0, 4.0), Color(0.012, 0.006, 0.003, 0.22), 12)
		draw_rect(Rect2(center + Vector2(-8.0, -15.0), Vector2(16.0, 26.0)), Color(0.12, 0.052, 0.024, 0.78), true)
		draw_line(center + Vector2(-8.0, -4.0), center + Vector2(8.0, -5.0), accent, 1.4)
		draw_line(center + Vector2(-8.0, 6.0), center + Vector2(8.0, 5.0), accent.darkened(0.12), 1.4)

func _draw_runtime_barber_stand(origin: Vector2, accent: Color) -> void:
	draw_line(origin + Vector2(4.0, -22.0), origin + Vector2(4.0, 18.0), Color(0.04, 0.018, 0.009, 0.76), 4.0)
	for stripe in range(4):
		var y := origin.y - 17.0 + float(stripe) * 9.0
		draw_line(Vector2(origin.x - 4.0, y), Vector2(origin.x + 12.0, y + 6.0), Color(0.82, 0.08, 0.04, 0.52), 2.0)
	draw_circle(origin + Vector2(4.0, -24.0), 4.0, accent.lightened(0.14))

func _draw_runtime_hitch_rail_notice(origin: Vector2, accent: Color) -> void:
	draw_rect(Rect2(origin + Vector2(-4.0, -30.0), Vector2(30.0, 24.0)), Color(0.15, 0.075, 0.034, 0.82), true)
	draw_rect(Rect2(origin + Vector2(2.0, -25.0), Vector2(18.0, 12.0)), Color(0.82, 0.64, 0.38, 0.72), true)
	_draw_business_icon(origin + Vector2(32.0, -18.0), "badge", accent.lightened(0.12), 0.32)

func _draw_runtime_strongbox_stack(origin: Vector2, accent: Color) -> void:
	for i in range(2):
		var box := Rect2(origin + Vector2(float(i) * 18.0, -18.0 - float(i) * 6.0), Vector2(30.0, 18.0))
		draw_rect(Rect2(box.position + Vector2(3.0, 4.0), box.size), Color(0.012, 0.006, 0.003, 0.24), true)
		draw_rect(box, Color(0.09, 0.052, 0.034, 0.88), true)
		draw_rect(box, accent.lightened(0.08), false, 1.2)
		draw_circle(box.get_center(), 3.0, accent.lightened(0.18))

func _draw_runtime_crate_stack(origin: Vector2, trim: Color) -> void:
	for i in range(3):
		var box := Rect2(origin + Vector2(float(i % 2) * 19.0, -16.0 - float(i) * 5.0), Vector2(26.0, 18.0))
		draw_rect(Rect2(box.position + Vector2(3.0, 4.0), box.size), Color(0.012, 0.006, 0.003, 0.22), true)
		draw_rect(box, Color(0.16, 0.074, 0.032, 0.8), true)
		draw_line(box.position + Vector2(4.0, 5.0), box.end - Vector2(4.0, 5.0), trim.lightened(0.08), 1.1)

func _draw_runtime_luggage_stack(origin: Vector2, accent: Color) -> void:
	for i in range(2):
		var bag := Rect2(origin + Vector2(float(i) * 18.0, -15.0 - float(i) * 8.0), Vector2(30.0, 17.0))
		draw_rect(bag, Color(0.09, 0.043, 0.024, 0.84), true)
		draw_rect(bag, accent, false, 1.1)
		draw_line(bag.position + Vector2(8.0, -2.0), bag.position + Vector2(21.0, -2.0), accent.lightened(0.12), 1.2)

func _draw_runtime_hay_bales(origin: Vector2, trim: Color) -> void:
	for i in range(2):
		var bale := Rect2(origin + Vector2(float(i) * 25.0, -14.0), Vector2(30.0, 16.0))
		draw_rect(bale, Color(0.48, 0.28, 0.09, 0.72), true)
		draw_line(bale.position + Vector2(3.0, 5.0), bale.end - Vector2(3.0, 7.0), trim.lightened(0.16), 1.0)
		draw_line(Vector2(bale.position.x + 14.0, bale.position.y), Vector2(bale.position.x + 14.0, bale.end.y), Color(0.08, 0.034, 0.014, 0.32), 1.1)

func _draw_runtime_medicine_case(origin: Vector2, accent: Color) -> void:
	var case_rect := Rect2(origin + Vector2(0.0, -22.0), Vector2(34.0, 22.0))
	draw_rect(case_rect, Color(0.09, 0.045, 0.025, 0.84), true)
	draw_rect(case_rect, accent.lightened(0.12), false, 1.2)
	_draw_business_icon(case_rect.get_center(), "cross", accent.lightened(0.2), 0.28)

func _draw_runtime_threshold_plate(arena: Rect2) -> void:
	var rail := Color(0.15, 0.072, 0.032, 0.86)
	var highlight := Color(1.0, 0.64, 0.22, 0.13)
	for edge in ["top", "bottom"]:
		var y := arena.position.y - 34.0 if edge == "top" else arena.end.y + 34.0
		draw_rect(Rect2(Vector2(arena.position.x - 44.0, y - 11.0), Vector2(arena.size.x + 88.0, 22.0)), Color(0.035, 0.014, 0.006, 0.56), true)
		draw_line(Vector2(arena.position.x - 34.0, y - 4.0), Vector2(arena.end.x + 34.0, y - 2.0), rail, 5.0)
		draw_line(Vector2(arena.position.x - 34.0, y + 5.0), Vector2(arena.end.x + 34.0, y + 3.0), highlight, 2.0)
	for edge in ["left", "right"]:
		var x := arena.position.x - 34.0 if edge == "left" else arena.end.x + 34.0
		draw_rect(Rect2(Vector2(x - 11.0, arena.position.y - 44.0), Vector2(22.0, arena.size.y + 88.0)), Color(0.035, 0.014, 0.006, 0.5), true)
		draw_line(Vector2(x - 3.0, arena.position.y - 34.0), Vector2(x - 1.0, arena.end.y + 34.0), rail, 5.0)
		draw_line(Vector2(x + 5.0, arena.position.y - 34.0), Vector2(x + 3.0, arena.end.y + 34.0), highlight, 2.0)

func _draw_old_west_perimeter(bounds: Rect2, arena: Rect2) -> void:
	var street_color := Color(0.34, 0.19, 0.08, 0.56)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 260.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.end.y + 30.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 30.0), Vector2(arena.position.x - bounds.position.x - 30.0, arena.size.y + 60.0)), street_color, true)
	draw_rect(Rect2(Vector2(arena.end.x + 30.0, arena.position.y - 30.0), Vector2(bounds.end.x - arena.end.x - 30.0, arena.size.y + 60.0)), street_color, true)

	_draw_town_square_sunfall_lighting(bounds, arena)
	_draw_town_square_threshold_depth(arena)

	var courtyard_shadow := arena.grow(34.0)
	draw_rect(courtyard_shadow, Color(0.08, 0.035, 0.018, 0.28), false, 16.0)
	_draw_courtyard_fences(arena)

	var top_y := arena.position.y - 248.0
	var bottom_y := arena.end.y + 58.0
	var left_x := arena.position.x - 266.0
	var right_x := arena.end.x + 34.0

	for i in range(7):
		var x := arena.position.x - 130.0 + i * 310.0
		var w := 286.0 + float((i * 37) % 42)
		var h := 190.0 + float((i * 19) % 28)
		_draw_saloon_front(Vector2(x, top_y + float((i % 2) * 10)), Vector2(w, h), i, _get_town_business(i))
		_draw_saloon_front(Vector2(x + 24.0, bottom_y + float(((i + 1) % 2) * 10)), Vector2(w - 18.0, h + 10.0), i + 9, _get_town_business(i + 5))

	for i in range(4):
		var y := arena.position.y - 24.0 + i * 330.0
		_draw_side_storefront(Vector2(left_x, y), Vector2(236.0, 286.0), -1.0, i, _get_town_business(i + 3))
		_draw_side_storefront(Vector2(right_x, y + 18.0), Vector2(236.0, 270.0), 1.0, i + 5, _get_town_business(i + 10))

	_draw_town_square_roofline_silhouettes(arena)
	_draw_town_square_foreground_props(arena)

	var perimeter_prop_count := _scenic_count(26, 14)
	for i in range(perimeter_prop_count):
		var angle := TAU * float(i) / float(perimeter_prop_count)
		var radius := Vector2(arena.size.x * 0.62, arena.size.y * 0.62)
		var center := arena.get_center()
		var pos := center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
		if arena.grow(72.0).has_point(pos):
			continue
		_draw_western_prop(pos, i)

func _draw_town_square_sunfall_lighting(_bounds: Rect2, arena: Rect2) -> void:
	var shadow := Color(0.055, 0.021, 0.009, 0.18)
	var soft_shadow := Color(0.12, 0.052, 0.018, 0.105)
	var brass := Color(1.0, 0.66, 0.24, 0.105)
	var top_start_y := arena.position.y - 252.0
	var top_shadow_count := _scenic_count(9, 6)
	for i in range(top_shadow_count):
		var x := arena.position.x - 180.0 + float(i) * 260.0
		var start := Vector2(x, top_start_y + float(i % 3) * 9.0)
		var end := start + Vector2(190.0, 92.0)
		draw_line(start + Vector2(0.0, 8.0), end + Vector2(0.0, 8.0), shadow, 34.0)
		draw_line(start, end, soft_shadow, 18.0)
		draw_line(start + Vector2(8.0, -7.0), end + Vector2(8.0, -7.0), brass, 2.0)

	var bottom_start_y := arena.end.y + 44.0
	var bottom_shadow_count := _scenic_count(9, 6)
	for i in range(bottom_shadow_count):
		var x := arena.position.x - 150.0 + float(i) * 268.0
		var start := Vector2(x, bottom_start_y + float((i + 1) % 3) * 11.0)
		var end := start + Vector2(220.0, 108.0)
		draw_line(start + Vector2(0.0, 10.0), end + Vector2(0.0, 10.0), shadow, 38.0)
		draw_line(start, end, soft_shadow, 20.0)
		draw_line(start + Vector2(12.0, -6.0), end + Vector2(12.0, -6.0), brass, 2.2)

	var side_shadow_count := _scenic_count(5, 4)
	for i in range(side_shadow_count):
		var y := arena.position.y + 48.0 + float(i) * (arena.size.y - 96.0) / float(maxi(1, side_shadow_count - 1))
		draw_line(Vector2(arena.position.x - 62.0, y), Vector2(arena.position.x - 180.0, y + 68.0), shadow, 26.0)
		draw_line(Vector2(arena.end.x + 62.0, y + 18.0), Vector2(arena.end.x + 196.0, y + 86.0), shadow, 26.0)

	draw_line(Vector2(arena.position.x - 28.0, arena.position.y - 20.0), Vector2(arena.end.x + 28.0, arena.position.y - 22.0), Color(1.0, 0.78, 0.34, 0.18), 3.0)
	draw_line(Vector2(arena.position.x - 28.0, arena.end.y + 20.0), Vector2(arena.end.x + 28.0, arena.end.y + 22.0), Color(0.09, 0.035, 0.012, 0.24), 5.0)

func _draw_town_square_threshold_depth(arena: Rect2) -> void:
	var shadow := Color(0.035, 0.014, 0.006, 0.22)
	var deep_shadow := Color(0.012, 0.006, 0.003, 0.32)
	var warm_edge := Color(1.0, 0.72, 0.28, 0.15)
	var brass := Color(0.96, 0.62, 0.22, 0.34)
	var leather := Color(0.08, 0.032, 0.014, 0.42)
	var threshold_top := Rect2(Vector2(arena.position.x - 72.0, arena.position.y - 92.0), Vector2(arena.size.x + 144.0, 46.0))
	var threshold_bottom := Rect2(Vector2(arena.position.x - 72.0, arena.end.y + 46.0), Vector2(arena.size.x + 144.0, 50.0))
	_draw_boardwalk_threshold_rect(threshold_top, true)
	_draw_boardwalk_threshold_rect(threshold_bottom, false)
	draw_line(Vector2(arena.position.x - 54.0, arena.position.y - 42.0), Vector2(arena.end.x + 54.0, arena.position.y - 42.0), deep_shadow, 18.0)
	draw_line(Vector2(arena.position.x - 48.0, arena.end.y + 43.0), Vector2(arena.end.x + 48.0, arena.end.y + 43.0), deep_shadow, 20.0)
	draw_line(Vector2(arena.position.x - 52.0, arena.position.y - 58.0), Vector2(arena.end.x + 52.0, arena.position.y - 58.0), warm_edge, 2.0)
	draw_line(Vector2(arena.position.x - 52.0, arena.end.y + 56.0), Vector2(arena.end.x + 52.0, arena.end.y + 56.0), warm_edge.darkened(0.08), 2.0)

	for gate_index in range(5):
		var t := (float(gate_index) + 0.5) / 5.0
		var x := lerpf(arena.position.x + 84.0, arena.end.x - 84.0, t)
		var top_gate := Vector2(x, arena.position.y - 56.0 + sin(float(gate_index)) * 4.0)
		var bottom_gate := Vector2(x + 28.0, arena.end.y + 57.0 + sin(float(gate_index) * 1.3) * 4.0)
		_draw_threshold_gate_wear(top_gate, Vector2.DOWN, gate_index)
		_draw_threshold_gate_wear(bottom_gate, Vector2.UP, gate_index + 7)

	for side_index in range(4):
		var t := (float(side_index) + 0.5) / 4.0
		var y := lerpf(arena.position.y + 130.0, arena.end.y - 130.0, t)
		_draw_side_threshold_pocket(Vector2(arena.position.x - 58.0, y), -1.0, side_index)
		_draw_side_threshold_pocket(Vector2(arena.end.x + 58.0, y + 24.0), 1.0, side_index + 5)

	var lantern_count := _scenic_count(6, 4)
	for lantern_index in range(lantern_count):
		var t := float(lantern_index) / float(maxi(1, lantern_count - 1))
		var top := Vector2(lerpf(arena.position.x + 48.0, arena.end.x - 48.0, t), arena.position.y - 86.0 + float(lantern_index % 2) * 12.0)
		var bottom := Vector2(lerpf(arena.position.x + 82.0, arena.end.x - 82.0, t), arena.end.y + 86.0 + float((lantern_index + 1) % 2) * 11.0)
		_draw_flat_ellipse(top + Vector2(14.0, 18.0), Vector2(52.0, 10.0), shadow, 18)
		_draw_flat_ellipse(top + Vector2(0.0, 0.0), Vector2(24.0, 6.0), Color(1.0, 0.6, 0.16, 0.055), 18)
		_draw_flat_ellipse(bottom + Vector2(16.0, 20.0), Vector2(56.0, 11.0), shadow, 18)
		_draw_flat_ellipse(bottom + Vector2(0.0, 1.0), Vector2(26.0, 6.0), Color(1.0, 0.6, 0.16, 0.048), 18)

	var rail_rivet_count := _scenic_count(10, 6)
	for rail_index in range(rail_rivet_count):
		var t := float(rail_index) / float(maxi(1, rail_rivet_count - 1))
		var top_pos := Vector2(lerpf(arena.position.x + 34.0, arena.end.x - 34.0, t), arena.position.y - 70.0)
		var bottom_pos := Vector2(lerpf(arena.position.x + 34.0, arena.end.x - 34.0, t), arena.end.y + 73.0)
		draw_circle(top_pos, 2.2, brass)
		draw_circle(bottom_pos, 2.2, brass.darkened(0.12))
		if rail_index % 2 == 0:
			draw_line(top_pos + Vector2(-16.0, 10.0), top_pos + Vector2(18.0, 21.0), leather, 1.6)
			draw_line(bottom_pos + Vector2(-18.0, 12.0), bottom_pos + Vector2(20.0, 22.0), leather, 1.6)

func _draw_boardwalk_threshold_rect(rect: Rect2, top_side: bool) -> void:
	draw_rect(Rect2(rect.position + Vector2(8.0, 11.0), rect.size), Color(0.012, 0.006, 0.003, 0.24), true)
	if porch_texture != null:
		draw_texture_rect(porch_texture, rect, true, Color(0.52, 0.29, 0.12, 0.5))
	else:
		draw_rect(rect, Color(0.14, 0.07, 0.032, 0.48), true)
	draw_rect(rect, Color(0.08, 0.032, 0.014, 0.2), true)
	var plank_count := _scenic_count(9, 6)
	for plank in range(plank_count):
		var y := rect.position.y + 5.0 + float(plank) * rect.size.y / float(plank_count)
		var line_color := Color(0.025, 0.012, 0.006, 0.32) if plank % 2 == 0 else Color(1.0, 0.7, 0.28, 0.08)
		draw_line(Vector2(rect.position.x + 10.0, y), Vector2(rect.end.x - 10.0, y + sin(float(plank) * 1.6) * 2.0), line_color, 1.4)
	var lip_y := rect.end.y if top_side else rect.position.y
	draw_line(Vector2(rect.position.x + 6.0, lip_y), Vector2(rect.end.x - 6.0, lip_y), Color(0.02, 0.009, 0.004, 0.46), 7.0)
	draw_line(Vector2(rect.position.x + 12.0, lip_y - (3.0 if top_side else -3.0)), Vector2(rect.end.x - 12.0, lip_y - (3.0 if top_side else -3.0)), Color(1.0, 0.72, 0.3, 0.16), 1.5)

func _draw_threshold_gate_wear(origin: Vector2, direction: Vector2, index: int) -> void:
	var side := direction.orthogonal()
	var shadow := Color(0.08, 0.032, 0.012, 0.16)
	var dust := Color(0.72, 0.46, 0.2, 0.1)
	_draw_flat_ellipse(origin + direction * 16.0 + side * 4.0, Vector2(46.0, 9.0), shadow, 18)
	draw_line(origin - side * 36.0, origin + side * 34.0 + direction * 6.0, Color(0.035, 0.014, 0.006, 0.2), 5.0)
	draw_line(origin - side * 28.0 + direction * 7.0, origin + side * 24.0 + direction * 12.0, dust, 2.0)
	for boot in range(3):
		var boot_origin := origin + side * float(boot - 1) * 20.0 + direction * (22.0 + float((index + boot) % 3) * 7.0)
		_draw_flat_ellipse(boot_origin, Vector2(8.0, 3.0), Color(0.09, 0.04, 0.016, 0.11), 10)

func _draw_side_threshold_pocket(origin: Vector2, direction: float, index: int) -> void:
	var horizontal := Vector2(direction, 0.0)
	var vertical := Vector2(0.0, 1.0)
	_draw_flat_ellipse(origin + horizontal * 14.0 + Vector2(0.0, 18.0), Vector2(16.0, 54.0), Color(0.018, 0.008, 0.004, 0.22), 18)
	draw_line(origin - vertical * 48.0, origin + vertical * 52.0, Color(0.08, 0.032, 0.014, 0.28), 6.0)
	draw_line(origin + horizontal * 9.0 - vertical * 42.0, origin + horizontal * 9.0 + vertical * 44.0, Color(1.0, 0.7, 0.28, 0.08), 1.5)
	for nick in range(4):
		var p := origin + vertical * (-33.0 + float(nick) * 22.0) + horizontal * (8.0 + float((index + nick) % 2) * 7.0)
		draw_line(p - horizontal * 10.0, p + horizontal * 8.0 + vertical * 5.0, Color(0.72, 0.42, 0.16, 0.12), 1.4)

func _draw_town_square_roofline_silhouettes(arena: Rect2) -> void:
	var dark := Color(0.025, 0.011, 0.006, 0.76)
	var warm_edge := Color(1.0, 0.67, 0.24, 0.18)
	var wire := Color(0.035, 0.018, 0.01, 0.62)
	var top_wire_y := arena.position.y - 286.0
	var bottom_wire_y := arena.end.y + 44.0
	for wire_index in range(2):
		var wire_offset := float(wire_index) * 13.0
		draw_line(Vector2(arena.position.x - 320.0, top_wire_y + wire_offset), Vector2(arena.end.x + 320.0, top_wire_y + 18.0 + wire_offset), wire, 1.7)
		draw_line(Vector2(arena.position.x - 320.0, bottom_wire_y + wire_offset), Vector2(arena.end.x + 320.0, bottom_wire_y + 16.0 + wire_offset), wire, 1.7)
	for pole_index in range(6):
		var t := float(pole_index) / 5.0
		var x := lerpf(arena.position.x - 170.0, arena.end.x + 170.0, t)
		var top_base := Vector2(x, arena.position.y - 246.0 + float(pole_index % 2) * 8.0)
		var bottom_base := Vector2(x + 28.0, arena.end.y + 68.0 + float((pole_index + 1) % 2) * 10.0)
		_draw_town_roofline_telegraph_pole(top_base, 86.0 + float(pole_index % 3) * 8.0, -1.0)
		_draw_town_roofline_telegraph_pole(bottom_base, 78.0 + float((pole_index + 1) % 3) * 8.0, 1.0)
	for i in range(7):
		var x := arena.position.x - 88.0 + float(i) * 308.0
		var top_roof_y := arena.position.y - 250.0 + float(i % 2) * 10.0
		var bottom_roof_y := arena.end.y + 52.0 + float((i + 1) % 2) * 10.0
		_draw_town_roofline_chimney(Vector2(x + 46.0, top_roof_y - 34.0), 0.82 + float(i % 3) * 0.08, dark, warm_edge)
		if i % 2 == 0:
			_draw_town_roofline_ladder(Vector2(x + 148.0, top_roof_y - 18.0), 62.0, -0.12)
		if i == 2 or i == 5:
			_draw_town_roofline_water_tank(Vector2(x + 210.0, top_roof_y - 38.0), 0.82)
		if i % 3 == 1:
			_draw_town_roofline_weather_vane(Vector2(x + 228.0, top_roof_y - 44.0), 0.82)
		_draw_town_hanging_sign_shadow(Vector2(x + 92.0, top_roof_y + 90.0), 1.0)
		_draw_town_roofline_chimney(Vector2(x + 72.0, bottom_roof_y - 28.0), 0.78 + float((i + 1) % 3) * 0.08, dark, warm_edge)
		if i % 2 == 1:
			_draw_town_roofline_ladder(Vector2(x + 170.0, bottom_roof_y - 8.0), 58.0, 0.1)
		if i == 1 or i == 4:
			_draw_town_roofline_water_tank(Vector2(x + 228.0, bottom_roof_y - 24.0), 0.76)
		if i % 3 == 0:
			_draw_town_roofline_weather_vane(Vector2(x + 238.0, bottom_roof_y - 32.0), 0.76)
		_draw_town_hanging_sign_shadow(Vector2(x + 116.0, bottom_roof_y + 94.0), 0.92)
	for side_index in range(4):
		var y := arena.position.y + 32.0 + float(side_index) * 322.0
		_draw_town_roofline_chimney(Vector2(arena.position.x - 292.0, y + 8.0), 0.68, dark, warm_edge)
		_draw_town_roofline_chimney(Vector2(arena.end.x + 292.0, y + 28.0), 0.68, dark, warm_edge)
		_draw_town_roofline_ladder(Vector2(arena.position.x - 238.0, y + 88.0), 54.0, PI * 0.5)
		_draw_town_roofline_ladder(Vector2(arena.end.x + 250.0, y + 102.0), 54.0, PI * 0.5)
		_draw_town_hanging_sign_shadow(Vector2(arena.position.x - 146.0, y + 96.0), 0.72)
		_draw_town_hanging_sign_shadow(Vector2(arena.end.x + 148.0, y + 110.0), 0.72)

func _draw_town_roofline_chimney(position: Vector2, scale: float, dark: Color, warm_edge: Color) -> void:
	var shaft := Rect2(position + Vector2(-7.0, -24.0) * scale, Vector2(14.0, 38.0) * scale)
	draw_rect(Rect2(shaft.position + Vector2(5.0, 7.0), shaft.size), Color(0.012, 0.006, 0.003, 0.26), true)
	draw_rect(shaft, dark, true)
	draw_rect(shaft, Color(0.42, 0.19, 0.08, 0.34), false, 1.4 * scale)
	draw_rect(Rect2(shaft.position + Vector2(-4.0, -5.0) * scale, Vector2(22.0, 8.0) * scale), Color(0.07, 0.032, 0.016, 0.92), true)
	draw_line(shaft.position + Vector2(3.0, 3.0), shaft.position + Vector2(3.0, shaft.size.y - 4.0), warm_edge, 1.0 * scale)
	draw_circle(position + Vector2(4.0, -32.0) * scale, 5.0 * scale, Color(0.075, 0.035, 0.016, 0.18))
	draw_circle(position + Vector2(13.0, -41.0) * scale, 8.0 * scale, Color(0.075, 0.035, 0.016, 0.09))

func _draw_town_roofline_water_tank(position: Vector2, scale: float) -> void:
	var shadow := Color(0.012, 0.006, 0.003, 0.28)
	var wood := Color(0.12, 0.058, 0.028, 0.9)
	var brass := Color(0.92, 0.57, 0.22, 0.36)
	_draw_flat_ellipse(position + Vector2(5.0, 20.0) * scale, Vector2(36.0, 9.0) * scale, shadow)
	draw_rect(Rect2(position + Vector2(-23.0, -18.0) * scale, Vector2(46.0, 34.0) * scale), wood, true)
	_draw_flat_ellipse(position + Vector2(0.0, -18.0) * scale, Vector2(24.0, 8.0) * scale, Color(0.18, 0.082, 0.035, 0.92))
	_draw_flat_ellipse(position + Vector2(0.0, 15.0) * scale, Vector2(24.0, 8.0) * scale, Color(0.055, 0.026, 0.014, 0.82))
	for band in [-7.0, 8.0]:
		draw_line(position + Vector2(-23.0, band) * scale, position + Vector2(23.0, band) * scale, brass, 2.0 * scale)
	for leg_x in [-17.0, 17.0]:
		draw_line(position + Vector2(leg_x, 14.0) * scale, position + Vector2(leg_x - 8.0, 38.0) * scale, Color(0.05, 0.024, 0.012, 0.72), 2.4 * scale)

func _draw_town_roofline_telegraph_pole(base: Vector2, height: float, direction: float) -> void:
	var top := base + Vector2(direction * 10.0, -height)
	draw_line(base + Vector2(5.0, 6.0), top + Vector2(5.0, 6.0), Color(0.01, 0.005, 0.002, 0.22), 5.0)
	draw_line(base, top, Color(0.08, 0.038, 0.018, 0.78), 4.0)
	draw_line(top + Vector2(-28.0, 4.0), top + Vector2(28.0, -4.0), Color(0.1, 0.048, 0.02, 0.78), 3.0)
	for knob in [-22.0, 22.0]:
		draw_circle(top + Vector2(knob, 0.0), 3.0, Color(0.72, 0.52, 0.28, 0.46))

func _draw_town_roofline_ladder(position: Vector2, length: float, rotation: float) -> void:
	var side := Vector2.RIGHT.rotated(rotation)
	var down := Vector2.DOWN.rotated(rotation)
	var dark := Color(0.055, 0.026, 0.014, 0.66)
	var edge := Color(0.72, 0.42, 0.18, 0.24)
	draw_line(position - side * 8.0, position - side * 8.0 + down * length, dark, 2.2)
	draw_line(position + side * 8.0, position + side * 8.0 + down * length, dark, 2.2)
	for rung in range(5):
		var rung_origin := position + down * (8.0 + float(rung) * (length - 16.0) / 4.0)
		draw_line(rung_origin - side * 9.0, rung_origin + side * 9.0, edge, 1.4)

func _draw_town_roofline_weather_vane(position: Vector2, scale: float) -> void:
	var iron := Color(0.035, 0.018, 0.012, 0.78)
	var brass := Color(0.94, 0.66, 0.24, 0.34)
	draw_line(position + Vector2(0.0, 18.0) * scale, position + Vector2(0.0, -14.0) * scale, iron, 2.0 * scale)
	draw_line(position + Vector2(-18.0, -6.0) * scale, position + Vector2(18.0, -6.0) * scale, brass, 1.6 * scale)
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(18.0, -6.0) * scale,
		position + Vector2(7.0, -12.0) * scale,
		position + Vector2(7.0, 0.0) * scale,
	]), brass)
	draw_line(position + Vector2(-13.0, -10.0) * scale, position + Vector2(-19.0, -2.0) * scale, iron, 1.4 * scale)

func _draw_town_hanging_sign_shadow(position: Vector2, scale: float) -> void:
	var shadow := Color(0.018, 0.008, 0.004, 0.22)
	draw_line(position + Vector2(-18.0, -26.0) * scale, position + Vector2(2.0, -8.0) * scale, shadow, 2.2 * scale)
	draw_rect(Rect2(position + Vector2(-25.0, -8.0) * scale, Vector2(50.0, 23.0) * scale), shadow, true)
	draw_line(position + Vector2(-18.0, 4.0) * scale, position + Vector2(18.0, 4.0) * scale, Color(0.7, 0.38, 0.14, 0.12), 1.2 * scale)

func _get_town_business(index: int) -> Dictionary:
	if TOWN_BUSINESS_ROSTER.is_empty():
		return {}
	return TOWN_BUSINESS_ROSTER[posmod(index, TOWN_BUSINESS_ROSTER.size())]

func _get_town_square_foreground_prop_kinds() -> Array[String]:
	var kinds: Array[String] = []
	for layout in TOWN_FOREGROUND_PROP_LAYOUT:
		var kind := str(layout.get("kind", ""))
		if kind != "" and not kinds.has(kind):
			kinds.append(kind)
	return kinds

func _get_town_business_facade_cues() -> Array[String]:
	return [
		"swing_doors",
		"barber_pole",
		"jail_bars",
		"vault_face",
		"hotel_balcony",
		"stable_arch",
		"doctor_cross",
		"general_awning",
		"business_shadow_awning",
		"saloon_bottle_shelf",
		"sheriff_badge_parapet",
		"bank_pillars",
		"general_store_crates",
		"saloon_double_door_shadow",
		"barber_basin_mirror",
		"sheriff_jail_window",
		"bank_teller_grille",
		"general_feed_sacks",
		"hotel_luggage_stack",
		"stable_hayloft_door",
		"doctor_medicine_case",
	]

func _get_town_roofline_silhouette_visual_version() -> String:
	return TOWN_ROOFLINE_SILHOUETTE_VISUAL_VERSION

func _get_town_roofline_silhouette_cues() -> Array[String]:
	return [
		"chimney_stacks",
		"water_tank",
		"telegraph_wires",
		"hanging_sign_shadows",
		"roof_ladders",
		"weather_vanes",
	]

func _get_town_square_foreground_prop_entries(arena: Rect2) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for layout in TOWN_FOREGROUND_PROP_LAYOUT:
		var origin := _resolve_town_square_foreground_prop_origin(arena, layout)
		entries.append({
			"kind": str(layout.get("kind", "crate")),
			"origin": origin,
			"edge": str(layout.get("edge", "top")),
			"business": _get_town_business(int(layout.get("business_index", 0))),
		})
	return entries

func _resolve_town_square_foreground_prop_origin(arena: Rect2, layout: Dictionary) -> Vector2:
	var edge := str(layout.get("edge", "top"))
	var t := float(layout.get("t", 0.5))
	var offset := float(layout.get("offset", 96.0))
	match edge:
		"top":
			return Vector2(lerpf(arena.position.x, arena.end.x, t), arena.position.y + offset)
		"bottom":
			return Vector2(lerpf(arena.position.x, arena.end.x, t), arena.end.y + offset)
		"left":
			return Vector2(arena.position.x + offset, lerpf(arena.position.y, arena.end.y, t))
		"right":
			return Vector2(arena.end.x + offset, lerpf(arena.position.y, arena.end.y, t))
		_:
			return arena.get_center()

func _draw_town_square_foreground_props(arena: Rect2) -> void:
	for entry in _get_town_square_foreground_prop_entries(arena):
		_draw_town_square_foreground_prop(
			entry["origin"],
			str(entry.get("kind", "crate")),
			entry.get("business", {}),
			str(entry.get("edge", "top"))
		)

func _draw_town_square_foreground_prop(position: Vector2, kind: String, business: Dictionary, edge: String) -> void:
	var accent: Color = business.get("accent", Color(0.82, 0.48, 0.2, 0.86))
	var trim: Color = business.get("trim", Color(0.68, 0.42, 0.2, 0.84))
	var plank: Color = business.get("plank", Color(0.18, 0.08, 0.035, 0.92))
	var shadow := Color(0.018, 0.009, 0.004, 0.32)
	var side_bias := -1.0 if edge == "left" else (1.0 if edge == "right" else 0.0)
	_draw_flat_ellipse(position + Vector2(side_bias * 8.0, 29.0), Vector2(44.0, 11.0), shadow)
	match kind:
		"wanted_board":
			var board := Rect2(position + Vector2(-34.0, -34.0), Vector2(68.0, 54.0))
			_draw_wood_panel_rect(board, plank.lightened(0.16))
			draw_rect(board.grow(-7.0), Color(0.82, 0.65, 0.4, 0.86), true)
			draw_rect(board.grow(-7.0), Color(0.18, 0.075, 0.035, 0.52), false, 2.0)
			draw_circle(board.position + Vector2(board.size.x * 0.5, 19.0), 8.0, Color(0.08, 0.035, 0.018, 0.86))
			draw_line(board.position + Vector2(16.0, 35.0), board.position + Vector2(52.0, 35.0), Color(0.18, 0.075, 0.035, 0.72), 3.0)
			draw_line(board.position + Vector2(20.0, 43.0), board.position + Vector2(48.0, 43.0), Color(0.18, 0.075, 0.035, 0.58), 2.0)
			_draw_textured_post(position + Vector2(-26.0, 18.0), 44.0, 7.0, trim.darkened(0.05))
			_draw_textured_post(position + Vector2(26.0, 18.0), 44.0, 7.0, trim.darkened(0.05))
		"lantern_post":
			_draw_textured_post(position + Vector2(0.0, -44.0), 84.0, 8.0, trim.darkened(0.05))
			draw_line(position + Vector2(0.0, -38.0), position + Vector2(28.0, -52.0), trim, 4.0)
			draw_line(position + Vector2(28.0, -52.0), position + Vector2(28.0, -34.0), trim.darkened(0.15), 2.5)
			var lamp := Rect2(position + Vector2(18.0, -34.0), Vector2(20.0, 24.0))
			draw_rect(lamp, Color(0.06, 0.028, 0.014, 0.9), true)
			draw_rect(lamp.grow(-4.0), Color(1.0, 0.62, 0.18, 0.34), true)
			draw_rect(lamp, accent.lightened(0.18), false, 1.8)
			draw_circle(lamp.get_center(), 14.0, Color(1.0, 0.55, 0.14, 0.08))
		"water_trough":
			var trough := Rect2(position + Vector2(-48.0, -14.0), Vector2(96.0, 28.0))
			draw_rect(Rect2(trough.position + Vector2(7.0, 8.0), trough.size), shadow, true)
			_draw_wood_panel_rect(trough, plank.lightened(0.1))
			draw_rect(trough.grow(-8.0), Color(0.08, 0.14, 0.12, 0.82), true)
			draw_line(trough.position + Vector2(12.0, trough.size.y * 0.5), trough.position + Vector2(trough.size.x - 12.0, trough.size.y * 0.5 + 2.0), Color(0.28, 0.46, 0.42, 0.58), 3.0)
			draw_circle(trough.position + Vector2(18.0, trough.size.y * 0.52), 3.0, Color(0.64, 0.78, 0.66, 0.44))
		"hitching_post":
			var rail_start := position + Vector2(-58.0, -10.0)
			var rail_end := position + Vector2(58.0, -10.0)
			_draw_textured_rail(rail_start, rail_end, trim, 9.0)
			for x in [-44.0, 0.0, 44.0]:
				_draw_textured_post(position + Vector2(x, -16.0), 48.0, 8.0, trim.darkened(0.04))
			draw_arc(position + Vector2(-22.0, 0.0), 12.0, -0.1, PI * 0.95, 18, Color(0.62, 0.48, 0.28, 0.72), 2.0)
			draw_arc(position + Vector2(31.0, 0.0), 10.0, -0.1, PI * 0.95, 18, Color(0.62, 0.48, 0.28, 0.62), 2.0)
		"supply_crates":
			for i in range(3):
				var crate_pos := position + Vector2(-34.0 + i * 31.0, -12.0 + float(i % 2) * 12.0)
				_draw_business_icon(crate_pos, "crate", trim.lightened(0.08), 0.82)
			var sack := Rect2(position + Vector2(30.0, 2.0), Vector2(26.0, 24.0))
			_draw_flat_ellipse(sack.get_center(), sack.size * 0.5, Color(0.42, 0.32, 0.18, 0.78))
			draw_line(sack.position + Vector2(7.0, 7.0), sack.position + Vector2(20.0, 5.0), accent.darkened(0.18), 2.0)
		"barber_basin":
			var stand_top := position + Vector2(0.0, -20.0)
			_draw_textured_post(position + Vector2(0.0, -8.0), 42.0, 6.0, trim)
			draw_circle(stand_top, 20.0, Color(0.72, 0.64, 0.46, 0.82))
			draw_circle(stand_top, 12.0, Color(0.16, 0.075, 0.04, 0.86))
			for i in range(4):
				var stripe_y := stand_top.y - 18.0 + i * 10.0
				draw_line(Vector2(stand_top.x - 14.0, stripe_y), Vector2(stand_top.x + 14.0, stripe_y + 8.0), Color(0.82, 0.08, 0.06, 0.74), 2.0)
			draw_circle(stand_top + Vector2(10.0, -8.0), 3.0, Color(0.92, 0.84, 0.64, 0.82))
		"saloon_barrels":
			for i in range(3):
				var barrel_center := position + Vector2(-26.0 + i * 26.0, -2.0 + float(i % 2) * 8.0)
				draw_circle(barrel_center, 15.0, Color(0.12, 0.052, 0.024, 0.94))
				draw_circle(barrel_center, 10.0, plank.lightened(0.08))
				draw_line(barrel_center + Vector2(-13.0, -2.0), barrel_center + Vector2(13.0, 2.0), trim.lightened(0.08), 2.2)
				draw_line(barrel_center + Vector2(-10.0, 7.0), barrel_center + Vector2(10.0, 7.0), Color(0.04, 0.018, 0.008, 0.62), 1.6)
			_draw_business_icon(position + Vector2(36.0, -22.0), "bottle", accent.lightened(0.12), 0.55)
		"sheriff_rail":
			var rail_y := position.y - 12.0
			_draw_textured_rail(Vector2(position.x - 54.0, rail_y), Vector2(position.x + 54.0, rail_y), trim.lightened(0.02), 8.0)
			for x in [-42.0, 0.0, 42.0]:
				_draw_textured_post(position + Vector2(x, -20.0), 48.0, 7.0, trim.darkened(0.08))
			_draw_business_icon(position + Vector2(0.0, -42.0), "badge", accent.lightened(0.16), 0.62)
			for mark in [-28.0, 28.0]:
				draw_line(position + Vector2(mark - 8.0, 8.0), position + Vector2(mark + 8.0, 22.0), Color(0.08, 0.035, 0.016, 0.72), 2.0)
		"bank_strongbox":
			var chest := Rect2(position + Vector2(-39.0, -24.0), Vector2(78.0, 48.0))
			draw_rect(Rect2(chest.position + Vector2(7.0, 8.0), chest.size), shadow, true)
			_draw_wood_panel_rect(chest, Color(0.18, 0.12, 0.08, 0.96))
			draw_rect(chest.grow(-5.0), Color(0.08, 0.055, 0.04, 0.82), false, 3.0)
			draw_rect(Rect2(chest.position + Vector2(29.0, 14.0), Vector2(20.0, 17.0)), accent.lightened(0.08), true)
			draw_circle(chest.position + Vector2(39.0, 24.0), 5.0, Color(0.05, 0.025, 0.012, 0.82))
			for coin in range(4):
				draw_circle(position + Vector2(-22.0 + coin * 11.0, 31.0 + float(coin % 2) * 4.0), 4.0, Color(1.0, 0.72, 0.28, 0.72))
		"hotel_luggage":
			for i in range(3):
				var bag := Rect2(position + Vector2(-43.0 + i * 31.0, -18.0 + float(i % 2) * 10.0), Vector2(30.0, 28.0))
				draw_rect(Rect2(bag.position + Vector2(5.0, 6.0), bag.size), shadow, true)
				draw_rect(bag, Color(0.16, 0.075, 0.038, 0.94), true)
				draw_rect(bag, trim.lightened(0.05), false, 2.0)
				draw_line(bag.position + Vector2(7.0, 1.0), bag.position + Vector2(22.0, 1.0), accent.lightened(0.16), 3.0)
				draw_line(bag.position + Vector2(15.0, 4.0), bag.position + Vector2(15.0, 25.0), Color(0.04, 0.018, 0.008, 0.5), 1.5)
			_draw_business_icon(position + Vector2(40.0, -28.0), "bed", accent.lightened(0.1), 0.48)
		"stable_hay":
			for i in range(2):
				var bale := Rect2(position + Vector2(-45.0 + i * 42.0, -18.0 + float(i) * 8.0), Vector2(48.0, 30.0))
				draw_rect(Rect2(bale.position + Vector2(6.0, 7.0), bale.size), shadow, true)
				draw_rect(bale, Color(0.64, 0.45, 0.18, 0.88), true)
				draw_rect(bale, Color(0.18, 0.085, 0.035, 0.54), false, 1.8)
				for strand in range(4):
					var y := bale.position.y + 6.0 + strand * 6.0
					draw_line(Vector2(bale.position.x + 5.0, y), Vector2(bale.end.x - 5.0, y + sin(float(strand + i)) * 3.0), Color(0.95, 0.72, 0.3, 0.32), 1.5)
			_draw_business_icon(position + Vector2(32.0, -32.0), "horseshoe", trim.lightened(0.1), 0.52)
		"doc_medicine":
			var table := Rect2(position + Vector2(-42.0, -14.0), Vector2(84.0, 26.0))
			draw_rect(Rect2(table.position + Vector2(7.0, 7.0), table.size), shadow, true)
			_draw_wood_panel_rect(table, plank.lightened(0.12))
			for i in range(3):
				var bottle := Rect2(position + Vector2(-28.0 + i * 18.0, -35.0 + float(i % 2) * 5.0), Vector2(10.0, 24.0))
				draw_rect(bottle, Color(0.08, 0.17, 0.09, 0.86), true)
				draw_rect(bottle.grow(-3.0), Color(0.44, 0.62, 0.32, 0.32), true)
				draw_line(bottle.position + Vector2(2.0, 6.0), bottle.position + Vector2(8.0, 4.0), Color(0.92, 0.84, 0.62, 0.42), 1.4)
			_draw_business_icon(position + Vector2(31.0, -29.0), "cross", accent.lightened(0.2), 0.44)
		_:
			_draw_western_prop(position, 0)

func _draw_flat_ellipse(center: Vector2, radius: Vector2, color: Color, segments: int = 24) -> void:
	var points := PackedVector2Array()
	for i in range(maxi(8, segments)):
		var angle := TAU * float(i) / float(maxi(8, segments))
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)

func _draw_courtyard_fences(arena: Rect2) -> void:
	var fence_color := Color(0.72, 0.44, 0.22, 0.88)
	var shadow_color := Color(0.025, 0.012, 0.006, 0.34)
	var top_y := arena.position.y - 48.0
	var bottom_y := arena.end.y + 48.0
	var left_x := arena.position.x - 58.0
	var right_x := arena.end.x + 58.0
	_draw_fence_run(Vector2(arena.position.x - 70.0, top_y), Vector2(arena.end.x + 70.0, top_y), fence_color, shadow_color)
	_draw_fence_run(Vector2(arena.position.x - 70.0, bottom_y), Vector2(arena.end.x + 70.0, bottom_y), fence_color, shadow_color)
	_draw_fence_run(Vector2(left_x, arena.position.y - 52.0), Vector2(left_x, arena.end.y + 52.0), fence_color, shadow_color)
	_draw_fence_run(Vector2(right_x, arena.position.y - 52.0), Vector2(right_x, arena.end.y + 52.0), fence_color, shadow_color)

func _draw_fence_run(start: Vector2, end: Vector2, tint: Color, shadow: Color) -> void:
	var direction := (end - start).normalized()
	var side := direction.orthogonal()
	var length := start.distance_to(end)
	draw_line(start + side * 14.0 + Vector2(9.0, 12.0), end + side * 14.0 + Vector2(9.0, 12.0), shadow, 9.0)
	draw_line(start - side * 14.0 + Vector2(9.0, 12.0), end - side * 14.0 + Vector2(9.0, 12.0), shadow, 9.0)
	_draw_textured_rail(start + side * 14.0, end + side * 14.0, tint, 8.0)
	_draw_textured_rail(start - side * 14.0, end - side * 14.0, tint.darkened(0.1), 8.0)
	var post_count: int = max(2, int(length / 92.0))
	for i in range(post_count + 1):
		var t := float(i) / float(post_count)
		var post_center := start.lerp(end, t)
		_draw_textured_post(post_center - side * 26.0, 52.0, 10.0, tint.darkened(0.03))

func _draw_wood_panel_rect(rect: Rect2, tint: Color) -> void:
	draw_rect(rect, tint.darkened(0.28), true)
	if wood_texture != null:
		draw_texture_rect(wood_texture, rect, true, tint)
	else:
		draw_rect(rect, tint, true)
	draw_rect(rect, Color(0.018, 0.009, 0.004, 0.24), false, 2.0)
	draw_line(rect.position + Vector2(0.0, 3.0), rect.position + Vector2(rect.size.x, 3.0), Color(1.0, 0.72, 0.34, 0.16), 2.0)

func _draw_porch_rect(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(8.0, 10.0), rect.size), Color(0.025, 0.012, 0.006, 0.32), true)
	if porch_texture != null:
		draw_texture_rect(porch_texture, rect, true, Color(0.78, 0.48, 0.24, 0.96))
	else:
		draw_rect(rect, Color(0.12, 0.06, 0.03, 0.95), true)
	for i in range(4):
		var y := rect.position.y + 5.0 + i * rect.size.y / 4.0
		draw_line(Vector2(rect.position.x + 5.0, y), Vector2(rect.end.x - 5.0, y + sin(i * 1.7) * 2.0), Color(0.025, 0.012, 0.006, 0.36), 2.0)
	draw_rect(rect, Color(0.9, 0.58, 0.25, 0.34), false, 2.0)

func _draw_textured_post(center_top: Vector2, height: float, width: float, tint: Color) -> void:
	var rect := Rect2(center_top - Vector2(width * 0.5, 0.0), Vector2(width, height))
	draw_rect(Rect2(rect.position + Vector2(5.0, 6.0), rect.size), Color(0.018, 0.008, 0.004, 0.32), true)
	if fence_texture != null:
		draw_texture_rect(fence_texture, rect, true, tint)
	else:
		draw_rect(rect, tint, true)
	draw_rect(rect, Color(0.02, 0.01, 0.005, 0.44), false, 1.5)

func _draw_textured_rail(start: Vector2, end: Vector2, tint: Color, width: float) -> void:
	var rail_direction := end - start
	var length := rail_direction.length()
	if length <= 0.1:
		return
	draw_set_transform(start + rail_direction * 0.5, rail_direction.angle(), Vector2.ONE)
	var rect := Rect2(Vector2(-length * 0.5, -width * 0.5), Vector2(length, width))
	if fence_texture != null:
		draw_texture_rect(fence_texture, rect, true, tint)
	else:
		draw_rect(rect, tint, true)
	draw_rect(rect, Color(0.02, 0.01, 0.005, 0.42), false, 1.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_saloon_front(position: Vector2, size: Vector2, index: int, business: Dictionary = {}) -> void:
	if business.is_empty():
		business = _get_town_business(index)
	var body := Rect2(position, size)
	var roof_height := 34.0
	var porch_height := 26.0
	var business_id := str(business.get("id", "saloon"))
	var plank_color: Color = business.get("plank", Color(0.16 + float(index % 3) * 0.025, 0.075, 0.032, 0.96))
	var trim_color: Color = business.get("trim", Color(0.55, 0.31, 0.15, 0.82))
	var accent_color: Color = business.get("accent", Color(0.9, 0.56, 0.24, 0.84))
	var shadow_color := Color(0.035, 0.018, 0.012, 0.96)

	_draw_wood_panel_rect(body, plank_color)
	var roof_width_bonus := 26.0 if business_id == "hotel" or business_id == "bank" else 16.0
	var roof := Rect2(position + Vector2(-roof_width_bonus * 0.5, -roof_height), Vector2(size.x + roof_width_bonus, roof_height))
	var roof_tint := Color(0.36, 0.17, 0.08, 0.98)
	if business_id == "bank":
		roof_tint = Color(0.25, 0.18, 0.13, 0.98)
	elif business_id == "doctor":
		roof_tint = Color(0.26, 0.16, 0.1, 0.98)
	_draw_wood_panel_rect(roof, roof_tint)
	draw_rect(roof, Color(0.02, 0.011, 0.006, 0.35), true)
	draw_rect(body, accent_color.lightened(0.08), false, 3.0)
	_draw_business_facade_roofline(body, roof, business, trim_color, accent_color)
	_draw_business_facade_depth_accents(body, business, trim_color, accent_color)

	for plank in range(6):
		var x := position.x + 22.0 + plank * (size.x - 44.0) / 5.0
		draw_line(Vector2(x, position.y), Vector2(x, position.y + size.y), Color(0.025, 0.012, 0.006, 0.46), 2.0)
		draw_line(Vector2(x + 2.0, position.y + 3.0), Vector2(x + 2.0, position.y + size.y - 5.0), Color(0.92, 0.58, 0.26, 0.18), 1.0)

	var sign_rect := Rect2(position + Vector2(size.x * 0.26, 18.0), Vector2(size.x * 0.48, 32.0))
	_draw_business_sign(sign_rect, business, true)

	var door := Rect2(position + Vector2(size.x * 0.42, size.y * 0.47), Vector2(size.x * 0.16, size.y * 0.46))
	draw_rect(door, shadow_color, true)
	draw_line(door.position + Vector2(door.size.x * 0.5, 8.0), door.position + Vector2(door.size.x * 0.5, door.size.y - 4.0), trim_color, 2.0)
	draw_circle(door.position + Vector2(door.size.x * 0.38, door.size.y * 0.52), 2.0, trim_color)
	draw_circle(door.position + Vector2(door.size.x * 0.62, door.size.y * 0.52), 2.0, trim_color)

	for side_index in range(2):
		var wx := position.x + size.x * (0.17 if side_index == 0 else 0.73)
		var window := Rect2(Vector2(wx, position.y + size.y * 0.48), Vector2(size.x * 0.15, size.y * 0.2))
		draw_rect(window, Color(0.02, 0.012, 0.009, 0.96), true)
		draw_rect(window, trim_color, false, 2.0)
		draw_line(window.position + Vector2(0.0, window.size.y * 0.5), window.position + Vector2(window.size.x, window.size.y * 0.5), Color(0.82, 0.55, 0.24, 0.35), 2.0)
		draw_line(window.position + Vector2(window.size.x * 0.5, 0.0), window.position + Vector2(window.size.x * 0.5, window.size.y), Color(0.82, 0.55, 0.24, 0.35), 2.0)

	_draw_business_front_details(body, door, business, trim_color, accent_color)
	_draw_business_signature_silhouette(body, door, business, trim_color, accent_color)
	_draw_storefront_material_highlights(body, sign_rect, door, business, trim_color, accent_color)

	var porch := Rect2(position + Vector2(-16.0, size.y - porch_height), Vector2(size.x + 32.0, porch_height))
	_draw_porch_rect(porch)
	for post in range(4):
		var px := porch.position.x + 20.0 + post * (porch.size.x - 40.0) / 3.0
		_draw_textured_post(Vector2(px, porch.position.y - 4.0), position.y + size.y + 18.0 - porch.position.y + 4.0, 7.0, trim_color)
	draw_line(porch.position, porch.position + Vector2(porch.size.x, 0.0), Color(0.9, 0.6, 0.28, 0.42), 3.0)

func _draw_side_storefront(position: Vector2, size: Vector2, direction: float, index: int, business: Dictionary = {}) -> void:
	if business.is_empty():
		business = _get_town_business(index)
	var body := Rect2(position, size)
	var front_x := position.x if direction < 0.0 else position.x + size.x
	var fade_x := position.x + size.x if direction < 0.0 else position.x
	var plank_color: Color = business.get("plank", Color(0.5, 0.28, 0.13, 0.94))
	var trim_color: Color = business.get("trim", Color(0.75, 0.45, 0.2, 0.72))
	var accent_color: Color = business.get("accent", Color(0.75, 0.45, 0.2, 0.72))
	_draw_wood_panel_rect(body, plank_color.lightened(0.08))
	draw_rect(body, accent_color, false, 3.0)
	_draw_textured_post(Vector2(front_x, position.y - 18.0), size.y + 34.0, 9.0, trim_color)
	draw_line(Vector2(fade_x, position.y), Vector2(fade_x, position.y + size.y), Color(0.02, 0.012, 0.009, 0.5), 14.0)
	for floor_index in range(3):
		var y := position.y + 42.0 + floor_index * 58.0
		draw_line(Vector2(position.x + 14.0, y), Vector2(position.x + size.x - 14.0, y + sin(index + floor_index) * 5.0), Color(0.92, 0.56, 0.25, 0.3), 4.0)
	var hanging_sign := Rect2(Vector2(front_x - direction * 72.0 - 36.0, position.y + 36.0), Vector2(72.0, 34.0))
	draw_line(Vector2(front_x, position.y + 30.0), hanging_sign.position + Vector2(36.0, 0.0), Color(0.42, 0.22, 0.1, 0.88), 3.0)
	_draw_business_sign(hanging_sign, business, false)
	_draw_business_icon(Vector2(front_x - direction * 32.0, position.y + size.y * 0.56), str(business.get("icon", "crate")), accent_color.lightened(0.16), 0.75)
	_draw_side_business_facade_depth_accents(body, direction, business, trim_color, accent_color)
	var side_door := Rect2(Vector2(front_x - direction * 72.0 - (0.0 if direction < 0.0 else 54.0), position.y + size.y * 0.68), Vector2(54.0, size.y * 0.26))
	draw_rect(side_door, Color(0.03, 0.014, 0.008, 0.82), true)
	draw_rect(side_door, trim_color, false, 2.0)
	_draw_side_business_facade_details(body, side_door, direction, business, trim_color, accent_color)
	_draw_side_business_signature_silhouette(body, side_door, direction, business, trim_color, accent_color)
	_draw_side_storefront_material_highlights(body, hanging_sign, side_door, direction, business, trim_color, accent_color)

func _draw_business_sign(sign_rect: Rect2, business: Dictionary, wide: bool) -> void:
	var trim_color: Color = business.get("trim", Color(0.75, 0.45, 0.2, 0.72))
	var accent_color: Color = business.get("accent", Color(0.84, 0.48, 0.2, 0.86))
	var sign_name := str(business.get("name", "SHOP"))
	draw_rect(sign_rect, Color(0.19, 0.075, 0.032, 0.98), true)
	draw_rect(sign_rect, accent_color.darkened(0.18), false, 3.0)
	draw_rect(sign_rect.grow(-4.0), trim_color.darkened(0.04), false, 1.0)
	var icon_center := sign_rect.position + Vector2(sign_rect.size.x * (0.2 if wide else 0.5), sign_rect.size.y * 0.5)
	_draw_business_icon(icon_center, str(business.get("icon", "crate")), accent_color.lightened(0.18), 0.52 if wide else 0.44)
	if wide:
		var font := ThemeDB.fallback_font
		if font != null:
			draw_string(font, sign_rect.position + Vector2(sign_rect.size.x * 0.34, sign_rect.size.y * 0.68), sign_name, HORIZONTAL_ALIGNMENT_LEFT, sign_rect.size.x * 0.62, 12, Color(0.98, 0.84, 0.56, 0.9))
	else:
		_draw_saloon_sign_marks(sign_rect.grow(-8.0), trim_color.lightened(0.12))

func _draw_business_facade_roofline(body: Rect2, roof: Rect2, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	match business_id:
		"saloon":
			var balcony := Rect2(body.position + Vector2(20.0, body.size.y * 0.31), Vector2(body.size.x - 40.0, 19.0))
			draw_rect(Rect2(balcony.position + Vector2(4.0, 6.0), balcony.size), Color(0.025, 0.012, 0.006, 0.28), true)
			draw_rect(balcony, Color(0.16, 0.064, 0.026, 0.9), true)
			draw_rect(balcony, trim_color.lightened(0.04), false, 2.0)
			for rung in range(7):
				var x := balcony.position.x + 9.0 + float(rung) * (balcony.size.x - 18.0) / 6.0
				draw_line(Vector2(x, balcony.position.y + 2.0), Vector2(x, balcony.end.y - 2.0), trim_color.darkened(0.1), 1.8)
		"barber":
			var awning := Rect2(body.position + Vector2(body.size.x * 0.12, body.size.y * 0.27), Vector2(body.size.x * 0.76, 20.0))
			for stripe in range(8):
				var stripe_rect := Rect2(awning.position + Vector2(float(stripe) * awning.size.x / 8.0, 0.0), Vector2(awning.size.x / 8.0, awning.size.y))
				draw_rect(stripe_rect, Color(0.78, 0.08, 0.05, 0.9) if stripe % 2 == 0 else Color(0.86, 0.78, 0.58, 0.92), true)
			draw_rect(awning, trim_color.darkened(0.08), false, 1.6)
		"sheriff":
			var parapet := Rect2(roof.position + Vector2(roof.size.x * 0.34, -18.0), Vector2(roof.size.x * 0.32, 24.0))
			draw_rect(parapet, Color(0.1, 0.055, 0.032, 0.96), true)
			draw_rect(parapet, trim_color, false, 2.0)
			_draw_business_icon(parapet.get_center() + Vector2(0.0, 1.0), "badge", accent_color.lightened(0.16), 0.48)
		"bank":
			for pillar_x in [body.position.x + body.size.x * 0.18, body.end.x - body.size.x * 0.18]:
				var pillar := Rect2(Vector2(pillar_x - 9.0, body.position.y + body.size.y * 0.24), Vector2(18.0, body.size.y * 0.62))
				draw_rect(pillar, Color(0.11, 0.075, 0.052, 0.96), true)
				draw_rect(pillar, trim_color.lightened(0.05), false, 2.0)
				for groove in range(3):
					var gx := pillar.position.x + 5.0 + float(groove) * 4.0
					draw_line(Vector2(gx, pillar.position.y + 7.0), Vector2(gx, pillar.end.y - 7.0), Color(0.03, 0.018, 0.012, 0.28), 1.1)
		"hotel":
			for column in range(4):
				var x := body.position.x + body.size.x * (0.26 + float(column) * 0.16)
				var window := Rect2(Vector2(x, body.position.y + body.size.y * 0.19), Vector2(body.size.x * 0.08, body.size.y * 0.13))
				draw_rect(window, Color(0.02, 0.012, 0.009, 0.86), true)
				draw_rect(window, trim_color, false, 1.5)
				draw_line(window.position + Vector2(4.0, 6.0), window.end - Vector2(4.0, 8.0), Color(1.0, 0.75, 0.34, 0.16), 1.1)
		"stable":
			draw_line(roof.position + Vector2(20.0, roof.size.y * 0.62), roof.position + Vector2(roof.size.x * 0.5, 5.0), trim_color.darkened(0.08), 5.0)
			draw_line(roof.position + Vector2(roof.size.x - 20.0, roof.size.y * 0.62), roof.position + Vector2(roof.size.x * 0.5, 5.0), trim_color.darkened(0.08), 5.0)
			_draw_business_icon(body.position + Vector2(body.size.x * 0.5, body.size.y * 0.2), "horseshoe", accent_color.lightened(0.12), 0.54)
		"doctor":
			var clinic_cross := body.position + Vector2(body.size.x * 0.5, body.size.y * 0.28)
			_draw_business_icon(clinic_cross, "cross", accent_color.lightened(0.22), 0.72)
		_:
			pass

func _draw_business_facade_depth_accents(body: Rect2, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	var awning := Rect2(body.position + Vector2(body.size.x * 0.08, body.size.y * 0.34), Vector2(body.size.x * 0.84, 15.0))
	draw_rect(Rect2(awning.position + Vector2(5.0, 8.0), awning.size), Color(0.02, 0.01, 0.005, 0.25), true)
	draw_rect(awning, Color(0.11, 0.052, 0.024, 0.84), true)
	draw_line(awning.position + Vector2(4.0, 2.0), awning.position + Vector2(awning.size.x - 4.0, 2.0), trim_color.lightened(0.08), 2.0)
	for bracket in range(5):
		var x := awning.position.x + 12.0 + float(bracket) * (awning.size.x - 24.0) / 4.0
		draw_line(Vector2(x, awning.end.y - 1.0), Vector2(x - 5.0, awning.end.y + 8.0), Color(0.035, 0.018, 0.009, 0.5), 1.5)
	match business_id:
		"saloon":
			var shelf := Rect2(body.position + Vector2(body.size.x * 0.62, body.size.y * 0.58), Vector2(body.size.x * 0.22, 9.0))
			draw_rect(shelf, trim_color.darkened(0.14), true)
			for bottle in range(4):
				var bottle_x := shelf.position.x + 9.0 + float(bottle) * (shelf.size.x - 18.0) / 3.0
				draw_rect(Rect2(Vector2(bottle_x - 3.0, shelf.position.y - 19.0), Vector2(6.0, 18.0)), Color(0.08, 0.18, 0.08, 0.84), true)
				draw_line(Vector2(bottle_x - 2.0, shelf.position.y - 14.0), Vector2(bottle_x + 2.0, shelf.position.y - 17.0), Color(1.0, 0.86, 0.52, 0.28), 1.0)
		"barber":
			for stripe in range(7):
				var stripe_rect := Rect2(awning.position + Vector2(float(stripe) * awning.size.x / 7.0, 1.0), Vector2(awning.size.x / 7.0, awning.size.y - 2.0))
				draw_rect(stripe_rect, Color(0.78, 0.08, 0.05, 0.62) if stripe % 2 == 0 else Color(0.9, 0.82, 0.62, 0.66), true)
		"sheriff":
			var star_plate := Rect2(body.position + Vector2(body.size.x * 0.38, body.size.y * 0.38), Vector2(body.size.x * 0.24, 18.0))
			draw_rect(star_plate, Color(0.08, 0.04, 0.02, 0.82), true)
			draw_rect(star_plate, trim_color, false, 1.5)
			_draw_business_icon(star_plate.get_center(), "badge", accent_color.lightened(0.18), 0.38)
		"bank":
			for column in range(3):
				var x := body.position.x + body.size.x * (0.3 + float(column) * 0.2)
				draw_line(Vector2(x, body.position.y + body.size.y * 0.38), Vector2(x, body.position.y + body.size.y * 0.86), trim_color.lightened(0.03), 4.0)
				draw_line(Vector2(x + 5.0, body.position.y + body.size.y * 0.38), Vector2(x + 5.0, body.position.y + body.size.y * 0.86), Color(0.025, 0.014, 0.008, 0.28), 1.5)
		"general":
			for crate in range(3):
				var crate_rect := Rect2(body.position + Vector2(body.size.x * (0.6 + float(crate) * 0.08), body.size.y * 0.76 - float(crate % 2) * 7.0), Vector2(body.size.x * 0.07, body.size.y * 0.08))
				draw_rect(crate_rect, Color(0.18, 0.08, 0.032, 0.88), true)
				draw_rect(crate_rect, trim_color.darkened(0.06), false, 1.3)
				draw_line(crate_rect.position, crate_rect.end, Color(0.035, 0.016, 0.008, 0.45), 1.1)
		_:
			pass

func _draw_side_business_facade_depth_accents(body: Rect2, direction: float, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var front_x := body.position.x if direction < 0.0 else body.end.x
	var awning := Rect2(Vector2(front_x - direction * 116.0 - (0.0 if direction < 0.0 else 82.0), body.position.y + body.size.y * 0.26), Vector2(82.0, 14.0))
	draw_rect(Rect2(awning.position + Vector2(direction * 5.0, 7.0), awning.size), Color(0.02, 0.01, 0.005, 0.24), true)
	draw_rect(awning, Color(0.11, 0.052, 0.024, 0.82), true)
	draw_line(awning.position + Vector2(4.0, 2.0), awning.position + Vector2(awning.size.x - 4.0, 2.0), trim_color.lightened(0.05), 1.8)
	var business_id := str(business.get("id", "saloon"))
	if business_id == "barber":
		for stripe in range(5):
			var stripe_rect := Rect2(awning.position + Vector2(float(stripe) * awning.size.x / 5.0, 1.0), Vector2(awning.size.x / 5.0, awning.size.y - 2.0))
			draw_rect(stripe_rect, Color(0.78, 0.08, 0.05, 0.58) if stripe % 2 == 0 else Color(0.9, 0.82, 0.62, 0.62), true)
	elif business_id == "sheriff":
		_draw_business_icon(Vector2(front_x - direction * 76.0, body.position.y + body.size.y * 0.27), "badge", accent_color.lightened(0.14), 0.36)
	elif business_id == "bank":
		for pillar in range(2):
			var px := front_x - direction * (48.0 + float(pillar) * 46.0)
			draw_line(Vector2(px, body.position.y + body.size.y * 0.38), Vector2(px, body.position.y + body.size.y * 0.84), trim_color.lightened(0.04), 3.5)

func _draw_business_signature_silhouette(body: Rect2, door: Rect2, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	var dark := Color(0.018, 0.009, 0.005, 0.64)
	var warm_shadow := Color(0.08, 0.035, 0.014, 0.38)
	match business_id:
		"saloon":
			var shadow_door := door.grow(7.0)
			draw_rect(shadow_door, Color(0.025, 0.01, 0.005, 0.42), true)
			for side in [-1.0, 1.0]:
				var panel := Rect2(door.get_center() + Vector2(side * 3.0, -door.size.y * 0.15), Vector2(door.size.x * 0.52 * side, door.size.y * 0.48)).abs()
				draw_rect(panel, Color(0.24, 0.095, 0.036, 0.94), true)
				draw_rect(panel.grow(-4.0), Color(0.055, 0.023, 0.01, 0.38), false, 1.5)
				draw_line(panel.position + Vector2(5.0, panel.size.y * 0.5), panel.position + Vector2(panel.size.x - 5.0, panel.size.y * 0.5), trim_color.lightened(0.08), 1.6)
			draw_line(door.position + Vector2(-10.0, door.size.y * 0.72), door.position + Vector2(door.size.x + 10.0, door.size.y * 0.7), accent_color.lightened(0.18), 2.0)
		"barber":
			var mirror := Rect2(body.position + Vector2(body.size.x * 0.67, body.size.y * 0.55), Vector2(body.size.x * 0.16, body.size.y * 0.18))
			draw_rect(Rect2(mirror.position + Vector2(4.0, 5.0), mirror.size), dark, true)
			draw_rect(mirror, Color(0.08, 0.13, 0.12, 0.78), true)
			draw_rect(mirror, trim_color.lightened(0.08), false, 2.0)
			draw_line(mirror.position + Vector2(5.0, 7.0), mirror.position + Vector2(mirror.size.x - 5.0, 3.0), Color(1.0, 0.86, 0.62, 0.26), 1.5)
			var basin := Rect2(body.position + Vector2(body.size.x * 0.64, body.size.y * 0.77), Vector2(body.size.x * 0.22, body.size.y * 0.08))
			draw_rect(basin, Color(0.78, 0.68, 0.48, 0.74), true)
			draw_rect(basin, accent_color.darkened(0.18), false, 1.6)
			draw_line(basin.position + Vector2(4.0, basin.size.y * 0.48), basin.position + Vector2(basin.size.x - 5.0, basin.size.y * 0.4), Color(1.0, 0.9, 0.66, 0.28), 1.2)
		"sheriff":
			var jail := Rect2(body.position + Vector2(body.size.x * 0.66, body.size.y * 0.52), Vector2(body.size.x * 0.2, body.size.y * 0.26))
			draw_rect(Rect2(jail.position + Vector2(5.0, 6.0), jail.size), warm_shadow, true)
			draw_rect(jail, Color(0.018, 0.01, 0.006, 0.94), true)
			draw_rect(jail, trim_color.darkened(0.12), false, 2.0)
			for bar in range(5):
				var x := jail.position.x + 7.0 + float(bar) * (jail.size.x - 14.0) / 4.0
				draw_line(Vector2(x, jail.position.y + 4.0), Vector2(x, jail.end.y - 5.0), Color(0.88, 0.66, 0.32, 0.7), 2.0)
		"bank":
			var teller := Rect2(body.position + Vector2(body.size.x * 0.3, body.size.y * 0.46), Vector2(body.size.x * 0.4, body.size.y * 0.16))
			draw_rect(Rect2(teller.position + Vector2(5.0, 6.0), teller.size), dark, true)
			draw_rect(teller, Color(0.035, 0.023, 0.016, 0.84), true)
			draw_rect(teller, trim_color.lightened(0.05), false, 2.0)
			for bar in range(6):
				var x := teller.position.x + 7.0 + float(bar) * (teller.size.x - 14.0) / 5.0
				draw_line(Vector2(x, teller.position.y + 4.0), Vector2(x, teller.end.y - 4.0), Color(0.92, 0.72, 0.34, 0.62), 1.6)
			draw_line(teller.position + Vector2(4.0, teller.size.y * 0.52), teller.position + Vector2(teller.size.x - 4.0, teller.size.y * 0.5), Color(1.0, 0.84, 0.44, 0.2), 1.4)
		"general":
			for sack in range(4):
				var sack_pos := body.position + Vector2(body.size.x * (0.58 + float(sack % 2) * 0.12), body.size.y * (0.76 - float(sack / 2) * 0.08))
				draw_set_transform(sack_pos, -0.08 + float(sack % 3) * 0.07, Vector2(1.0, 0.72))
				draw_circle(Vector2.ZERO, body.size.x * 0.045, Color(0.55, 0.39, 0.18, 0.82))
				draw_circle(Vector2(-2.0, -2.0), body.size.x * 0.022, Color(0.92, 0.72, 0.34, 0.18))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			draw_line(body.position + Vector2(body.size.x * 0.57, body.size.y * 0.7), body.position + Vector2(body.size.x * 0.84, body.size.y * 0.67), trim_color.lightened(0.08), 2.0)
		"hotel":
			for bag in range(3):
				var bag_rect := Rect2(body.position + Vector2(body.size.x * (0.62 + float(bag) * 0.08), body.size.y * (0.78 - float(bag % 2) * 0.05)), Vector2(body.size.x * 0.075, body.size.y * 0.08))
				draw_rect(Rect2(bag_rect.position + Vector2(4.0, 5.0), bag_rect.size), dark, true)
				draw_rect(bag_rect, Color(0.18, 0.085, 0.04, 0.88), true)
				draw_rect(bag_rect, trim_color.darkened(0.08), false, 1.4)
				draw_line(bag_rect.position + Vector2(bag_rect.size.x * 0.5, -2.0), bag_rect.position + Vector2(bag_rect.size.x * 0.5, 5.0), accent_color.lightened(0.12), 1.2)
		"stable":
			var hayloft := Rect2(body.position + Vector2(body.size.x * 0.37, body.size.y * 0.28), Vector2(body.size.x * 0.26, body.size.y * 0.16))
			draw_rect(Rect2(hayloft.position + Vector2(4.0, 6.0), hayloft.size), dark, true)
			draw_rect(hayloft, Color(0.08, 0.035, 0.014, 0.92), true)
			draw_rect(hayloft, trim_color, false, 2.0)
			draw_line(hayloft.position, hayloft.end, trim_color.darkened(0.08), 1.6)
			draw_line(Vector2(hayloft.end.x, hayloft.position.y), Vector2(hayloft.position.x, hayloft.end.y), trim_color.darkened(0.08), 1.6)
			for strand in range(4):
				draw_line(hayloft.position + Vector2(8.0 + strand * 11.0, hayloft.size.y + 2.0), hayloft.position + Vector2(4.0 + strand * 12.0, hayloft.size.y + 16.0), Color(0.92, 0.68, 0.22, 0.28), 1.2)
		"doctor":
			var case_rect := Rect2(body.position + Vector2(body.size.x * 0.59, body.size.y * 0.72), Vector2(body.size.x * 0.22, body.size.y * 0.12))
			draw_rect(Rect2(case_rect.position + Vector2(4.0, 5.0), case_rect.size), dark, true)
			draw_rect(case_rect, Color(0.13, 0.16, 0.09, 0.88), true)
			draw_rect(case_rect, trim_color.lightened(0.04), false, 1.8)
			_draw_business_icon(case_rect.get_center(), "cross", accent_color.lightened(0.22), 0.32)
			for bottle in range(3):
				var bottle_pos := case_rect.position + Vector2(8.0 + float(bottle) * case_rect.size.x * 0.22, -18.0)
				draw_rect(Rect2(bottle_pos, Vector2(7.0, 20.0)), Color(0.07, 0.2, 0.09, 0.82), true)
				draw_line(bottle_pos + Vector2(1.0, 5.0), bottle_pos + Vector2(6.0, 2.0), Color(1.0, 0.9, 0.62, 0.24), 1.0)
		_:
			pass

func _draw_side_business_signature_silhouette(body: Rect2, door: Rect2, direction: float, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	var front_x := body.position.x if direction < 0.0 else body.end.x
	var dark := Color(0.018, 0.009, 0.005, 0.6)
	var signature_center := Vector2(front_x - direction * 92.0, body.position.y + body.size.y * 0.66)
	match business_id:
		"saloon":
			var half_door := Rect2(signature_center + Vector2(-direction * 4.0 - 36.0, -34.0), Vector2(72.0, 52.0))
			draw_rect(half_door, Color(0.24, 0.095, 0.036, 0.9), true)
			draw_rect(half_door.grow(-5.0), Color(0.055, 0.023, 0.01, 0.36), false, 1.3)
			draw_line(half_door.position + Vector2(7.0, half_door.size.y * 0.5), half_door.position + Vector2(half_door.size.x - 7.0, half_door.size.y * 0.46), trim_color.lightened(0.08), 1.5)
		"barber":
			var mirror := Rect2(signature_center + Vector2(-24.0, -38.0), Vector2(48.0, 34.0))
			draw_rect(Rect2(mirror.position + Vector2(4.0, 5.0), mirror.size), dark, true)
			draw_rect(mirror, Color(0.08, 0.13, 0.12, 0.76), true)
			draw_rect(mirror, trim_color, false, 1.5)
			draw_rect(Rect2(signature_center + Vector2(-27.0, 2.0), Vector2(54.0, 14.0)), Color(0.78, 0.68, 0.48, 0.7), true)
		"sheriff":
			var cell := Rect2(signature_center + Vector2(-26.0, -36.0), Vector2(52.0, 56.0))
			draw_rect(cell, Color(0.018, 0.01, 0.006, 0.92), true)
			draw_rect(cell, trim_color.darkened(0.1), false, 1.8)
			for bar in range(5):
				var x := cell.position.x + 7.0 + float(bar) * (cell.size.x - 14.0) / 4.0
				draw_line(Vector2(x, cell.position.y + 4.0), Vector2(x, cell.end.y - 5.0), Color(0.88, 0.66, 0.32, 0.66), 1.7)
		"bank":
			var grille := Rect2(signature_center + Vector2(-34.0, -30.0), Vector2(68.0, 36.0))
			draw_rect(grille, Color(0.035, 0.023, 0.016, 0.86), true)
			draw_rect(grille, trim_color.lightened(0.05), false, 1.7)
			for bar in range(6):
				var x := grille.position.x + 7.0 + float(bar) * (grille.size.x - 14.0) / 5.0
				draw_line(Vector2(x, grille.position.y + 4.0), Vector2(x, grille.end.y - 4.0), Color(0.92, 0.72, 0.34, 0.6), 1.3)
		"general":
			for sack in range(3):
				var sack_pos := signature_center + Vector2(float(sack - 1) * 18.0, 11.0 - float(sack % 2) * 12.0)
				draw_set_transform(sack_pos, -0.08 + float(sack) * 0.08, Vector2(1.0, 0.72))
				draw_circle(Vector2.ZERO, 14.0, Color(0.55, 0.39, 0.18, 0.8))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"hotel":
			for bag in range(3):
				var bag_rect := Rect2(signature_center + Vector2(float(bag - 1) * 19.0, 7.0 - float(bag % 2) * 10.0), Vector2(20.0, 18.0))
				draw_rect(bag_rect, Color(0.18, 0.085, 0.04, 0.88), true)
				draw_rect(bag_rect, trim_color.darkened(0.08), false, 1.2)
		"stable":
			var loft := Rect2(Vector2(front_x - direction * 118.0 - (0.0 if direction < 0.0 else 54.0), body.position.y + body.size.y * 0.3), Vector2(54.0, 38.0))
			draw_rect(loft, Color(0.08, 0.035, 0.014, 0.9), true)
			draw_rect(loft, trim_color, false, 1.6)
			draw_line(loft.position, loft.end, trim_color.darkened(0.08), 1.3)
			draw_line(Vector2(loft.end.x, loft.position.y), Vector2(loft.position.x, loft.end.y), trim_color.darkened(0.08), 1.3)
		"doctor":
			var case_rect := Rect2(signature_center + Vector2(-28.0, -8.0), Vector2(56.0, 26.0))
			draw_rect(case_rect, Color(0.13, 0.16, 0.09, 0.88), true)
			draw_rect(case_rect, trim_color.lightened(0.04), false, 1.4)
			_draw_business_icon(case_rect.get_center(), "cross", accent_color.lightened(0.22), 0.28)
		_:
			pass

func _draw_business_front_details(body: Rect2, door: Rect2, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	match business_id:
		"saloon":
			for side in [-1.0, 1.0]:
				var swing := Rect2(door.get_center() + Vector2(side * 3.0, -door.size.y * 0.08), Vector2(door.size.x * 0.42 * side, door.size.y * 0.34)).abs()
				draw_rect(swing, Color(0.31, 0.13, 0.055, 0.9), true)
				draw_rect(swing, trim_color, false, 1.5)
			_draw_business_icon(body.position + Vector2(body.size.x * 0.82, body.size.y * 0.25), "bottle", accent_color.lightened(0.16), 0.42)
		"barber":
			var pole := Rect2(body.position + Vector2(body.size.x * 0.1, body.size.y * 0.34), Vector2(14.0, body.size.y * 0.48))
			draw_rect(pole, Color(0.04, 0.02, 0.012, 0.85), true)
			for i in range(7):
				var stripe := Rect2(pole.position + Vector2(2.0, 3.0 + i * pole.size.y / 7.0), Vector2(pole.size.x - 4.0, pole.size.y / 12.0))
				draw_rect(stripe, Color(0.82, 0.1, 0.07, 0.9) if i % 2 == 0 else Color(0.85, 0.79, 0.62, 0.92), true)
			draw_rect(pole, Color(0.72, 0.45, 0.22, 0.9), false, 1.5)
			draw_circle(pole.position + Vector2(pole.size.x * 0.5, -4.0), 6.0, Color(0.86, 0.78, 0.58, 0.92))
			draw_circle(pole.position + Vector2(pole.size.x * 0.5, pole.size.y + 5.0), 6.0, Color(0.78, 0.08, 0.05, 0.92))
		"sheriff":
			_draw_business_icon(door.get_center() + Vector2(0.0, -door.size.y * 0.1), "badge", accent_color.lightened(0.18), 0.54)
			var jail := Rect2(body.position + Vector2(body.size.x * 0.72, body.size.y * 0.7), Vector2(body.size.x * 0.16, body.size.y * 0.16))
			draw_rect(jail, Color(0.018, 0.01, 0.006, 0.9), true)
			for bar in range(4):
				var x := jail.position.x + 6.0 + bar * (jail.size.x - 12.0) / 3.0
				draw_line(Vector2(x, jail.position.y + 3.0), Vector2(x, jail.end.y - 3.0), trim_color, 1.8)
		"bank":
			_draw_business_icon(body.position + Vector2(body.size.x * 0.5, body.size.y * 0.72), "vault", accent_color.lightened(0.1), 0.82)
			draw_rect(Rect2(body.position + Vector2(body.size.x * 0.18, body.size.y * 0.28), Vector2(body.size.x * 0.64, 8.0)), trim_color.darkened(0.15), true)
			draw_rect(Rect2(body.position + Vector2(body.size.x * 0.33, body.size.y * 0.58), Vector2(body.size.x * 0.34, body.size.y * 0.29)), Color(0.07, 0.045, 0.032, 0.72), false, 4.0)
		"general":
			var awning := Rect2(body.position + Vector2(body.size.x * 0.1, body.size.y * 0.31), Vector2(body.size.x * 0.8, 18.0))
			for i in range(6):
				var stripe := Rect2(awning.position + Vector2(i * awning.size.x / 6.0, 0.0), Vector2(awning.size.x / 6.0, awning.size.y))
				draw_rect(stripe, accent_color.lightened(0.1) if i % 2 == 0 else Color(0.72, 0.48, 0.26, 0.86), true)
			draw_rect(awning, trim_color, false, 1.5)
			_draw_business_icon(body.position + Vector2(body.size.x * 0.22, body.size.y * 0.82), "crate", trim_color.lightened(0.12), 0.55)
		"hotel":
			var balcony_y := body.position.y + body.size.y * 0.38
			draw_line(Vector2(body.position.x + 24.0, balcony_y), Vector2(body.end.x - 24.0, balcony_y), trim_color, 4.0)
			for post in range(6):
				var x := body.position.x + 28.0 + post * (body.size.x - 56.0) / 5.0
				draw_line(Vector2(x, balcony_y), Vector2(x, balcony_y + 24.0), trim_color.darkened(0.1), 2.0)
		"stable":
			var arch_center := body.position + Vector2(body.size.x * 0.5, body.size.y * 0.68)
			draw_arc(arch_center, body.size.x * 0.16, PI, TAU, 24, trim_color, 4.0)
			draw_line(arch_center + Vector2(-body.size.x * 0.16, 0.0), arch_center + Vector2(-body.size.x * 0.16, body.size.y * 0.22), trim_color, 4.0)
			draw_line(arch_center + Vector2(body.size.x * 0.16, 0.0), arch_center + Vector2(body.size.x * 0.16, body.size.y * 0.22), trim_color, 4.0)
			for bale in range(3):
				var bale_rect := Rect2(body.position + Vector2(body.size.x * 0.18 + float(bale) * body.size.x * 0.12, body.size.y * 0.78), Vector2(body.size.x * 0.1, body.size.y * 0.08))
				draw_rect(bale_rect, Color(0.68, 0.48, 0.18, 0.82), true)
				draw_line(bale_rect.position + Vector2(3.0, bale_rect.size.y * 0.5), bale_rect.end - Vector2(3.0, bale_rect.size.y * 0.5), Color(0.96, 0.72, 0.28, 0.28), 1.3)
		"doctor":
			_draw_business_icon(body.position + Vector2(body.size.x * 0.8, body.size.y * 0.28), "cross", accent_color.lightened(0.22), 0.58)
			draw_rect(Rect2(body.position + Vector2(body.size.x * 0.12, body.size.y * 0.7), Vector2(body.size.x * 0.16, body.size.y * 0.12)), Color(0.08, 0.14, 0.08, 0.78), true)
			draw_rect(Rect2(body.position + Vector2(body.size.x * 0.12, body.size.y * 0.7), Vector2(body.size.x * 0.16, body.size.y * 0.12)), trim_color, false, 1.5)
			for bottle in range(3):
				var x := body.position.x + body.size.x * 0.14 + float(bottle) * body.size.x * 0.045
				draw_rect(Rect2(Vector2(x, body.position.y + body.size.y * 0.64), Vector2(7.0, 22.0)), Color(0.07, 0.18, 0.08, 0.82), true)
				draw_line(Vector2(x + 2.0, body.position.y + body.size.y * 0.67), Vector2(x + 5.0, body.position.y + body.size.y * 0.72), Color(0.86, 0.82, 0.56, 0.34), 1.1)

func _draw_side_business_facade_details(body: Rect2, door: Rect2, direction: float, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var business_id := str(business.get("id", "saloon"))
	var front_x := body.position.x if direction < 0.0 else body.end.x
	match business_id:
		"saloon":
			var rail_start := Vector2(body.position.x + 20.0, body.position.y + body.size.y * 0.32)
			var rail_end := Vector2(body.end.x - 20.0, body.position.y + body.size.y * 0.32)
			_draw_textured_rail(rail_start, rail_end, trim_color.lightened(0.03), 5.0)
			for bottle in range(3):
				_draw_business_icon(Vector2(front_x - direction * (52.0 + float(bottle) * 18.0), body.position.y + body.size.y * 0.48), "bottle", accent_color.lightened(0.16), 0.34)
		"barber":
			var pole := Rect2(Vector2(front_x - direction * 34.0 - (0.0 if direction < 0.0 else 12.0), body.position.y + body.size.y * 0.34), Vector2(12.0, body.size.y * 0.42))
			draw_rect(pole, Color(0.04, 0.02, 0.012, 0.86), true)
			for stripe in range(6):
				var stripe_rect := Rect2(pole.position + Vector2(2.0, 3.0 + float(stripe) * pole.size.y / 6.0), Vector2(pole.size.x - 4.0, pole.size.y / 11.0))
				draw_rect(stripe_rect, Color(0.82, 0.08, 0.05, 0.9) if stripe % 2 == 0 else Color(0.86, 0.8, 0.62, 0.92), true)
			draw_rect(pole, trim_color, false, 1.3)
		"sheriff":
			_draw_business_icon(door.get_center() + Vector2(0.0, -10.0), "badge", accent_color.lightened(0.16), 0.48)
			var cell := Rect2(Vector2(front_x - direction * 104.0 - (0.0 if direction < 0.0 else 46.0), body.position.y + body.size.y * 0.45), Vector2(46.0, 38.0))
			draw_rect(cell, Color(0.018, 0.01, 0.006, 0.86), true)
			for bar in range(4):
				var x := cell.position.x + 7.0 + float(bar) * (cell.size.x - 14.0) / 3.0
				draw_line(Vector2(x, cell.position.y + 4.0), Vector2(x, cell.end.y - 4.0), trim_color, 1.6)
		"bank":
			_draw_business_icon(door.get_center() + Vector2(0.0, -16.0), "vault", accent_color.lightened(0.08), 0.55)
			for pillar_offset in [42.0, 96.0]:
				var pillar_x: float = front_x - direction * float(pillar_offset)
				draw_line(Vector2(pillar_x, body.position.y + body.size.y * 0.28), Vector2(pillar_x, body.position.y + body.size.y * 0.82), trim_color.lightened(0.04), 5.0)
		"hotel":
			var balcony_y := body.position.y + body.size.y * 0.35
			_draw_textured_rail(Vector2(body.position.x + 18.0, balcony_y), Vector2(body.end.x - 18.0, balcony_y), trim_color, 5.0)
			for post in range(5):
				var x := body.position.x + 22.0 + float(post) * (body.size.x - 44.0) / 4.0
				draw_line(Vector2(x, balcony_y), Vector2(x, balcony_y + 22.0), trim_color.darkened(0.08), 1.6)
		"stable":
			var arch_center := Vector2(front_x - direction * 66.0, body.position.y + body.size.y * 0.64)
			draw_arc(arch_center, 31.0, PI, TAU, 24, trim_color, 3.0)
			draw_line(arch_center + Vector2(-31.0, 0.0), arch_center + Vector2(-31.0, 48.0), trim_color, 3.0)
			draw_line(arch_center + Vector2(31.0, 0.0), arch_center + Vector2(31.0, 48.0), trim_color, 3.0)
			_draw_business_icon(Vector2(front_x - direction * 38.0, body.position.y + body.size.y * 0.36), "horseshoe", accent_color.lightened(0.12), 0.48)
		"doctor":
			_draw_business_icon(Vector2(front_x - direction * 52.0, body.position.y + body.size.y * 0.36), "cross", accent_color.lightened(0.22), 0.58)
			for bottle in range(3):
				var bottle_rect := Rect2(Vector2(front_x - direction * (84.0 + float(bottle) * 14.0) - (0.0 if direction < 0.0 else 8.0), body.position.y + body.size.y * 0.55), Vector2(8.0, 22.0))
				draw_rect(bottle_rect, Color(0.07, 0.18, 0.08, 0.82), true)
				draw_line(bottle_rect.position + Vector2(2.0, 5.0), bottle_rect.position + Vector2(6.0, 3.0), Color(0.86, 0.82, 0.56, 0.34), 1.0)
		_:
			pass

func _draw_storefront_material_highlights(body: Rect2, sign_rect: Rect2, door: Rect2, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var brass := Color(1.0, 0.74, 0.28, 0.56)
	var glass := Color(1.0, 0.84, 0.48, 0.26)
	var business_id := str(business.get("id", "saloon"))
	draw_line(body.position + Vector2(8.0, 6.0), body.position + Vector2(body.size.x - 10.0, 4.0), Color(1.0, 0.67, 0.28, 0.18), 2.0)
	draw_line(sign_rect.position + Vector2(8.0, 5.0), sign_rect.position + Vector2(sign_rect.size.x - 8.0, 4.0), brass, 2.0)
	for stud in [
		sign_rect.position + Vector2(7.0, 7.0),
		sign_rect.position + Vector2(sign_rect.size.x - 7.0, 7.0),
		sign_rect.position + Vector2(7.0, sign_rect.size.y - 7.0),
		sign_rect.position + Vector2(sign_rect.size.x - 7.0, sign_rect.size.y - 7.0),
	]:
		draw_circle(stud, 2.2, Color(0.08, 0.035, 0.014, 0.52))
		draw_circle(stud + Vector2(-0.7, -0.7), 1.2, brass)
	for side_index in range(2):
		var wx := body.position.x + body.size.x * (0.17 if side_index == 0 else 0.73)
		var window := Rect2(Vector2(wx, body.position.y + body.size.y * 0.48), Vector2(body.size.x * 0.15, body.size.y * 0.2))
		draw_rect(window.grow(-5.0), Color(0.92, 0.62, 0.24, 0.075), true)
		draw_line(window.position + Vector2(window.size.x * 0.2, window.size.y * 0.22), window.position + Vector2(window.size.x * 0.82, window.size.y * 0.08), glass, 2.0)
		draw_line(window.position + Vector2(window.size.x * 0.16, window.size.y * 0.58), window.position + Vector2(window.size.x * 0.72, window.size.y * 0.36), Color(1.0, 0.9, 0.62, 0.18), 1.4)
		draw_circle(window.position + Vector2(window.size.x * 0.78, window.size.y * 0.24), 2.0, Color(1.0, 0.88, 0.58, 0.34))
	for side in [-1.0, 1.0]:
		var lamp_center := door.position + Vector2(door.size.x * 0.5 + side * (body.size.x * 0.17), door.size.y * 0.18)
		draw_line(lamp_center + Vector2(-side * 2.0, -6.0), lamp_center + Vector2(-side * 16.0, -15.0), trim_color.darkened(0.15), 2.0)
		draw_rect(Rect2(lamp_center + Vector2(-5.0, -5.0), Vector2(10.0, 14.0)), Color(0.055, 0.026, 0.014, 0.82), true)
		draw_rect(Rect2(lamp_center + Vector2(-3.0, -2.0), Vector2(6.0, 8.0)), Color(1.0, 0.62, 0.2, 0.32), true)
		draw_circle(lamp_center + Vector2(0.0, 2.0), 11.0, Color(1.0, 0.55, 0.14, 0.045))
	if business_id == "sheriff":
		draw_circle(door.position + Vector2(door.size.x * 0.5 - 5.0, door.size.y * 0.23), 3.2, Color(1.0, 0.82, 0.34, 0.68))
	elif business_id == "bank":
		draw_line(body.position + Vector2(body.size.x * 0.2, body.size.y * 0.31), body.position + Vector2(body.size.x * 0.8, body.size.y * 0.29), Color(1.0, 0.78, 0.34, 0.32), 2.0)
	elif business_id == "barber":
		draw_line(body.position + Vector2(body.size.x * 0.1, body.size.y * 0.35), body.position + Vector2(body.size.x * 0.1, body.size.y * 0.78), Color(1.0, 0.87, 0.66, 0.28), 1.5)
	else:
		draw_line(body.position + Vector2(body.size.x * 0.3, body.size.y * 0.87), body.position + Vector2(body.size.x * 0.7, body.size.y * 0.86), accent_color.lightened(0.25), 1.5)

func _draw_side_storefront_material_highlights(body: Rect2, sign_rect: Rect2, door: Rect2, direction: float, business: Dictionary, trim_color: Color, accent_color: Color) -> void:
	var front_x := body.position.x if direction < 0.0 else body.end.x
	var brass := Color(1.0, 0.74, 0.28, 0.44)
	draw_line(body.position + Vector2(10.0, 9.0), body.position + Vector2(body.size.x - 10.0, 7.0), Color(1.0, 0.64, 0.25, 0.13), 2.0)
	draw_line(sign_rect.position + Vector2(8.0, 5.0), sign_rect.position + Vector2(sign_rect.size.x - 8.0, 4.0), brass, 1.8)
	draw_circle(sign_rect.position + Vector2(sign_rect.size.x * 0.5, 7.0), 2.2, Color(1.0, 0.82, 0.38, 0.5))
	var window := Rect2(Vector2(front_x - direction * 88.0 - (0.0 if direction < 0.0 else 42.0), body.position.y + body.size.y * 0.36), Vector2(42.0, 28.0))
	draw_rect(window, Color(0.02, 0.012, 0.009, 0.78), true)
	draw_rect(window, trim_color.darkened(0.03), false, 1.5)
	draw_line(window.position + Vector2(7.0, 8.0), window.position + Vector2(window.size.x - 8.0, 5.0), Color(1.0, 0.86, 0.54, 0.24), 1.8)
	draw_line(window.position + Vector2(8.0, 19.0), window.position + Vector2(window.size.x - 10.0, 13.0), Color(0.95, 0.62, 0.24, 0.16), 1.2)
	var lamp_center := door.position + Vector2(door.size.x * 0.5, -12.0)
	draw_line(Vector2(front_x, lamp_center.y - 8.0), lamp_center + Vector2(-direction * 7.0, -4.0), trim_color.darkened(0.12), 2.0)
	draw_rect(Rect2(lamp_center + Vector2(-5.0, -2.0), Vector2(10.0, 13.0)), Color(0.055, 0.026, 0.014, 0.82), true)
	draw_rect(Rect2(lamp_center + Vector2(-3.0, 1.0), Vector2(6.0, 7.0)), Color(1.0, 0.58, 0.18, 0.28), true)
	draw_circle(lamp_center + Vector2(0.0, 4.0), 11.0, Color(1.0, 0.52, 0.12, 0.04))
	draw_line(door.position + Vector2(6.0, 8.0), door.position + Vector2(door.size.x - 7.0, 6.0), accent_color.lightened(0.18), 1.3)

func _draw_business_icon(center: Vector2, icon: String, color: Color, scale: float) -> void:
	var dark := Color(0.035, 0.016, 0.008, 0.86)
	match icon:
		"badge":
			draw_circle(center, 12.0 * scale, dark)
			for i in range(6):
				var angle := TAU * float(i) / 6.0
				draw_line(center, center + Vector2(cos(angle), sin(angle)) * 19.0 * scale, color, 3.0 * scale)
			draw_circle(center, 7.0 * scale, color)
		"barber":
			var pole := Rect2(center + Vector2(-6.0, -17.0) * scale, Vector2(12.0, 34.0) * scale)
			draw_rect(pole, dark, true)
			for i in range(5):
				var stripe := Rect2(pole.position + Vector2(2.0 * scale, (3.0 + i * 6.0) * scale), Vector2(8.0, 4.0) * scale)
				draw_rect(stripe, Color(0.84, 0.08, 0.06, 0.9) if i % 2 == 0 else Color(0.88, 0.82, 0.66, 0.9), true)
			draw_rect(pole, color, false, 1.3 * scale)
		"vault":
			draw_circle(center, 17.0 * scale, dark)
			draw_arc(center, 17.0 * scale, 0.0, TAU, 28, color, 2.2 * scale)
			draw_circle(center, 5.0 * scale, color)
			for i in range(6):
				var angle := TAU * float(i) / 6.0
				draw_line(center, center + Vector2(cos(angle), sin(angle)) * 13.0 * scale, color.darkened(0.1), 1.4 * scale)
		"bottle":
			draw_rect(Rect2(center + Vector2(-6.0, -4.0) * scale, Vector2(12.0, 18.0) * scale), Color(0.12, 0.22, 0.12, 0.9), true)
			draw_rect(Rect2(center + Vector2(-3.0, -14.0) * scale, Vector2(6.0, 10.0) * scale), Color(0.12, 0.22, 0.12, 0.9), true)
			draw_line(center + Vector2(-7.0, 4.0) * scale, center + Vector2(7.0, 4.0) * scale, color, 2.0 * scale)
		"crate":
			var crate := Rect2(center + Vector2(-15.0, -12.0) * scale, Vector2(30.0, 24.0) * scale)
			draw_rect(crate, Color(0.16, 0.075, 0.032, 0.92), true)
			draw_rect(crate, color, false, 2.0 * scale)
			draw_line(crate.position, crate.end, color.darkened(0.12), 1.6 * scale)
			draw_line(Vector2(crate.end.x, crate.position.y), Vector2(crate.position.x, crate.end.y), color.darkened(0.12), 1.6 * scale)
		"bed":
			draw_rect(Rect2(center + Vector2(-16.0, -4.0) * scale, Vector2(32.0, 13.0) * scale), dark, true)
			draw_rect(Rect2(center + Vector2(-17.0, -10.0) * scale, Vector2(7.0, 8.0) * scale), color, true)
			draw_line(center + Vector2(-18.0, -11.0) * scale, center + Vector2(-18.0, 13.0) * scale, color, 2.0 * scale)
			draw_line(center + Vector2(18.0, -11.0) * scale, center + Vector2(18.0, 13.0) * scale, color, 2.0 * scale)
		"horseshoe":
			draw_arc(center, 17.0 * scale, 0.2, PI - 0.2, 28, color, 4.0 * scale)
			draw_circle(center + Vector2(-13.0, 3.0) * scale, 2.4 * scale, color)
			draw_circle(center + Vector2(13.0, 3.0) * scale, 2.4 * scale, color)
		"cross":
			draw_rect(Rect2(center + Vector2(-4.0, -16.0) * scale, Vector2(8.0, 32.0) * scale), color, true)
			draw_rect(Rect2(center + Vector2(-15.0, -5.0) * scale, Vector2(30.0, 10.0) * scale), color, true)
			draw_rect(Rect2(center + Vector2(-16.0, -16.0) * scale, Vector2(32.0, 32.0) * scale), dark, false, 1.4 * scale)
		_:
			_draw_saloon_sign_marks(Rect2(center + Vector2(-18.0, -10.0) * scale, Vector2(36.0, 20.0) * scale), color)

func _draw_saloon_sign_marks(sign_rect: Rect2, color: Color) -> void:
	var y := sign_rect.position.y + sign_rect.size.y * 0.55
	for i in range(5):
		var x := sign_rect.position.x + 12.0 + i * (sign_rect.size.x - 24.0) / 4.0
		draw_line(Vector2(x - 5.0, y), Vector2(x + 5.0, y), color, 3.0)
		draw_line(Vector2(x, y - 7.0), Vector2(x, y + 7.0), color, 2.0)

func _draw_western_prop(position: Vector2, index: int) -> void:
	match index % 5:
		0:
			draw_rect(Rect2(position + Vector2(-12.0, -12.0), Vector2(24.0, 24.0)), Color(0.12, 0.06, 0.03, 0.92), true)
			draw_rect(Rect2(position + Vector2(-12.0, -12.0), Vector2(24.0, 24.0)), Color(0.58, 0.32, 0.14, 0.54), false, 2.0)
			draw_line(position + Vector2(-15.0, 0.0), position + Vector2(15.0, 0.0), Color(0.04, 0.02, 0.01, 0.76), 3.0)
		1:
			draw_circle(position, 18.0, Color(0.11, 0.052, 0.024, 0.9))
			draw_circle(position, 12.0, Color(0.055, 0.026, 0.014, 0.96))
			draw_line(position + Vector2(-18.0, -2.0), position + Vector2(18.0, 2.0), Color(0.72, 0.42, 0.18, 0.5), 3.0)
		2:
			draw_line(position + Vector2(0.0, -24.0), position + Vector2(0.0, 28.0), Color(0.18, 0.08, 0.035, 0.94), 5.0)
			draw_circle(position + Vector2(0.0, -30.0), 8.0, Color(0.82, 0.42, 0.16, 0.36))
			draw_circle(position + Vector2(0.0, -30.0), 4.0, Color(1.0, 0.74, 0.32, 0.48))
		3:
			var hitch := Rect2(position + Vector2(-30.0, -8.0), Vector2(60.0, 10.0))
			draw_rect(hitch, Color(0.12, 0.055, 0.024, 0.94), true)
			draw_line(position + Vector2(-24.0, -8.0), position + Vector2(-24.0, 18.0), Color(0.2, 0.1, 0.045, 0.9), 4.0)
			draw_line(position + Vector2(24.0, -8.0), position + Vector2(24.0, 18.0), Color(0.2, 0.1, 0.045, 0.9), 4.0)
		_:
			draw_line(position + Vector2(-22.0, -10.0), position + Vector2(22.0, 12.0), Color(0.09, 0.04, 0.018, 0.9), 5.0)
			draw_line(position + Vector2(-18.0, 12.0), position + Vector2(18.0, -10.0), Color(0.09, 0.04, 0.018, 0.9), 5.0)
			draw_circle(position + Vector2(-24.0, 14.0), 6.0, Color(0.04, 0.02, 0.01, 0.9))
			draw_circle(position + Vector2(24.0, 14.0), 6.0, Color(0.04, 0.02, 0.01, 0.9))

func _draw_sand_detail(arena: Rect2) -> void:
	_draw_courtyard_floor_rut_pass(arena)
	_draw_duel_worn_floor_readability_pass(arena)
	_draw_courtyard_edge_dressing(arena)
	var sand_wave_count := _scenic_count(16, 10)
	for i in range(sand_wave_count):
		var y := lerpf(arena.position.y + 90.0, arena.end.y - 90.0, float(i) / float(maxi(1, sand_wave_count - 1)))
		var wave := sin(i * 1.8) * 34.0
		var color := Color(1.0, 0.84, 0.5, 0.1) if i % 2 == 0 else Color(0.36, 0.2, 0.08, 0.08)
		draw_line(Vector2(arena.position.x + 70.0, y), Vector2(arena.end.x - 70.0, y + wave), color, 5.0)

	for i in range(_scenic_count(96, 48)):
		var x := arena.position.x + float((i * 173) % int(arena.size.x - 160.0)) + 80.0
		var y := arena.position.y + float((i * 97) % int(arena.size.y - 160.0)) + 80.0
		var radius := 1.0 + float((i * 11) % 4)
		var tint := Color(0.28, 0.16, 0.06, 0.12) if i % 3 == 0 else Color(1.0, 0.88, 0.58, 0.12)
		draw_circle(Vector2(x, y), radius, tint)

	for i in range(_scenic_count(18, 10)):
		var x := arena.position.x + float((i * 251) % int(arena.size.x - 220.0)) + 110.0
		var y := arena.position.y + float((i * 149) % int(arena.size.y - 220.0)) + 110.0
		var length := 30.0 + float((i * 17) % 54)
		var angle := -0.2 + sin(i * 2.1) * 0.35
		var start := Vector2(x, y)
		var end := start + Vector2.RIGHT.rotated(angle) * length
		draw_line(start, end, Color(0.32, 0.18, 0.07, 0.13), 2.0)
		draw_line(start + Vector2(0, 5), end + Vector2(0, 5), Color(1.0, 0.84, 0.5, 0.09), 1.5)

	for i in range(_scenic_count(10, 7)):
		var x := arena.position.x + float((i * 337) % int(arena.size.x - 260.0)) + 130.0
		var y := arena.position.y + float((i * 211) % int(arena.size.y - 260.0)) + 130.0
		var rock := Rect2(Vector2(x, y), Vector2(18.0 + (i % 4) * 7.0, 8.0 + (i % 3) * 5.0))
		draw_rect(rock, Color(0.13, 0.075, 0.045, 0.26), true)
		draw_rect(rock, Color(0.54, 0.34, 0.18, 0.18), false, 1.5)

func _draw_courtyard_floor_rut_pass(arena: Rect2) -> void:
	var center := arena.get_center()
	var lane_shadow := Color(0.22, 0.115, 0.04, 0.105)
	var lane_highlight := Color(1.0, 0.82, 0.46, 0.09)
	var long_shadow := Color(0.12, 0.055, 0.02, 0.12)
	for lane_index in range(4):
		var y := lerpf(arena.position.y + arena.size.y * 0.22, arena.end.y - arena.size.y * 0.19, float(lane_index) / 3.0)
		var bow := sin(float(lane_index) * 1.4) * 48.0
		var start := Vector2(arena.position.x + 92.0, y)
		var end := Vector2(arena.end.x - 92.0, y + bow)
		draw_line(start + Vector2(0.0, 7.0), end + Vector2(0.0, 7.0), long_shadow, 13.0)
		draw_line(start, end, lane_shadow, 8.0)
		draw_line(start + Vector2(0.0, -8.0), end + Vector2(0.0, -8.0), lane_highlight, 4.0)
		var rut_marker_count := _scenic_count(5, 3)
		for marker_index in range(rut_marker_count):
			var t := (float(marker_index) + 0.5) / float(rut_marker_count)
			var marker := start.lerp(end, t) + Vector2(sin(float(marker_index) * 1.7 + lane_index) * 18.0, 0.0)
			draw_line(marker + Vector2(-24.0, -7.0), marker + Vector2(18.0, 5.0), Color(0.11, 0.052, 0.02, 0.11), 3.0)
			draw_line(marker + Vector2(-20.0, -10.0), marker + Vector2(15.0, 1.0), Color(1.0, 0.84, 0.5, 0.055), 1.5)
	for rut_index in range(6):
		var t := float(rut_index) / 5.0
		var x := lerpf(arena.position.x + 150.0, arena.end.x - 150.0, t)
		var y := center.y + sin(float(rut_index) * 1.31) * arena.size.y * 0.18
		var radius := 44.0 + float((rut_index * 13) % 30)
		draw_arc(Vector2(x, y), radius, 0.15, PI * 0.86, 24, Color(0.18, 0.085, 0.032, 0.105), 5.0)
		draw_arc(Vector2(x + 6.0, y - 8.0), radius * 0.72, PI * 1.04, PI * 1.8, 20, Color(0.95, 0.74, 0.36, 0.075), 3.0)
	for footprint_index in range(_scenic_count(28, 16)):
		var x := arena.position.x + float((footprint_index * 197) % int(arena.size.x - 260.0)) + 130.0
		var y := arena.position.y + float((footprint_index * 131) % int(arena.size.y - 260.0)) + 130.0
		var offset := Vector2(7.0, 3.0) if footprint_index % 2 == 0 else Vector2(-7.0, -2.0)
		_draw_flat_ellipse(Vector2(x, y) + offset, Vector2(8.0, 3.0), Color(0.12, 0.056, 0.022, 0.09), 12)
		_draw_flat_ellipse(Vector2(x, y) - offset, Vector2(6.0, 2.5), Color(0.92, 0.72, 0.34, 0.045), 12)

func _draw_duel_worn_floor_readability_pass(arena: Rect2) -> void:
	var center := arena.get_center()
	var calm_rect := Rect2(center - arena.size * 0.18, arena.size * 0.36)
	draw_rect(calm_rect, Color(1.0, 0.82, 0.46, 0.034), true)
	draw_rect(calm_rect.grow(38.0), Color(0.12, 0.052, 0.018, 0.052), false, 4.0)
	draw_rect(calm_rect.grow(64.0), Color(1.0, 0.78, 0.34, 0.038), false, 2.0)

	var threshold_shadow := Color(0.105, 0.043, 0.014, 0.14)
	var threshold_hot := Color(1.0, 0.74, 0.28, 0.085)
	var thresholds := [
		{"start": Vector2(arena.position.x + 118.0, arena.position.y + 84.0), "end": Vector2(arena.end.x - 118.0, arena.position.y + 112.0), "side": Vector2(0.0, -1.0)},
		{"start": Vector2(arena.position.x + 132.0, arena.end.y - 116.0), "end": Vector2(arena.end.x - 126.0, arena.end.y - 86.0), "side": Vector2(0.0, 1.0)},
		{"start": Vector2(arena.position.x + 92.0, arena.position.y + 168.0), "end": Vector2(arena.position.x + 122.0, arena.end.y - 174.0), "side": Vector2(-1.0, 0.0)},
		{"start": Vector2(arena.end.x - 112.0, arena.position.y + 162.0), "end": Vector2(arena.end.x - 82.0, arena.end.y - 170.0), "side": Vector2(1.0, 0.0)},
	]
	for entry in thresholds:
		var start: Vector2 = entry["start"]
		var end: Vector2 = entry["end"]
		var side: Vector2 = entry["side"]
		draw_line(start + side * 8.0 + Vector2(0.0, 7.0), end + side * 8.0 + Vector2(0.0, 7.0), threshold_shadow, 10.0)
		draw_line(start, end, threshold_hot, 3.0)
		for tick in range(4):
			var t := (float(tick) + 0.5) / 4.0
			var mark := start.lerp(end, t)
			draw_line(mark - side.orthogonal() * 13.0, mark + side.orthogonal() * 13.0, Color(0.13, 0.055, 0.02, 0.08), 2.0)

	var scoring_points := [
		center + Vector2(-arena.size.x * 0.23, -arena.size.y * 0.18),
		center + Vector2(arena.size.x * 0.22, -arena.size.y * 0.16),
		center + Vector2(-arena.size.x * 0.20, arena.size.y * 0.18),
		center + Vector2(arena.size.x * 0.24, arena.size.y * 0.17),
	]
	for i in range(scoring_points.size()):
		_draw_floor_marshal_scoring(scoring_points[i], 30.0 + float(i % 2) * 5.0, float(i) * 0.3)

	for shell_index in range(_scenic_count(12, 8)):
		var side_sign := -1.0 if shell_index % 2 == 0 else 1.0
		var x := center.x + side_sign * (arena.size.x * 0.18 + float((shell_index * 47) % 92))
		var y := arena.position.y + 150.0 + float((shell_index * 137) % int(arena.size.y - 300.0))
		var angle := -0.22 + float(shell_index % 5) * 0.11
		var start := Vector2(x, y)
		draw_line(start + Vector2(2.0, 4.0), start + Vector2.RIGHT.rotated(angle) * 18.0 + Vector2(2.0, 4.0), Color(0.055, 0.022, 0.008, 0.11), 4.0)
		draw_line(start, start + Vector2.RIGHT.rotated(angle) * 18.0, Color(0.88, 0.56, 0.19, 0.12), 2.0)
		draw_circle(start, 2.0, Color(1.0, 0.76, 0.32, 0.16))

func _draw_floor_marshal_scoring(origin: Vector2, radius: float, rotation: float) -> void:
	var shadow := Color(0.08, 0.032, 0.011, 0.11)
	var brass := Color(1.0, 0.72, 0.28, 0.13)
	var dust := Color(0.28, 0.13, 0.045, 0.075)
	draw_arc(origin + Vector2(4.0, 6.0), radius, -0.2 + rotation, PI * 1.28 + rotation, 24, shadow, 5.0)
	draw_arc(origin, radius, -0.2 + rotation, PI * 1.28 + rotation, 24, brass, 2.2)
	draw_arc(origin + Vector2(-5.0, -4.0), radius * 0.64, PI * 0.72 + rotation, PI * 1.78 + rotation, 18, dust, 3.0)
	for point in range(5):
		var angle := rotation + TAU * float(point) / 5.0 - PI * 0.5
		var tip := origin + Vector2.RIGHT.rotated(angle) * (radius * 0.58)
		var root := origin + Vector2.RIGHT.rotated(angle) * (radius * 0.24)
		draw_line(root + Vector2(2.0, 3.0), tip + Vector2(2.0, 3.0), shadow, 3.4)
		draw_line(root, tip, brass, 1.4)

func _draw_courtyard_edge_dressing(arena: Rect2) -> void:
	var shadow := Color(0.08, 0.032, 0.012, 0.13)
	var deep_shadow := Color(0.035, 0.014, 0.006, 0.18)
	var sun_worn := Color(1.0, 0.78, 0.38, 0.08)
	var rope := Color(0.58, 0.36, 0.15, 0.18)
	var wood := Color(0.22, 0.1, 0.04, 0.18)
	var iron := Color(0.055, 0.032, 0.022, 0.22)
	var hoof := Color(0.09, 0.04, 0.016, 0.13)

	var wheel_scars := [
		Vector2(arena.position.x + 132.0, arena.position.y + 132.0),
		Vector2(arena.end.x - 172.0, arena.position.y + 118.0),
		Vector2(arena.position.x + 154.0, arena.end.y - 128.0),
		Vector2(arena.end.x - 130.0, arena.end.y - 148.0),
	]
	for i in range(wheel_scars.size()):
		var center: Vector2 = wheel_scars[i]
		var radius := 42.0 + float(i % 2) * 9.0
		var start_angle := -0.42 + float(i) * 0.33
		var end_angle := start_angle + PI * 1.25
		draw_arc(center + Vector2(7.0, 8.0), radius, start_angle, end_angle, 28, shadow, 6.0)
		draw_arc(center, radius, start_angle, end_angle, 28, Color(0.18, 0.075, 0.025, 0.12), 3.4)
		draw_arc(center + Vector2(4.0, -5.0), radius * 0.72, start_angle + 0.18, end_angle - 0.18, 20, sun_worn, 2.0)
		for spoke_index in range(3):
			var angle := start_angle + (end_angle - start_angle) * (float(spoke_index) + 0.5) / 3.0
			var spoke_start := center + Vector2.RIGHT.rotated(angle) * (radius * 0.38)
			var spoke_end := center + Vector2.RIGHT.rotated(angle) * (radius * 0.92)
			draw_line(spoke_start, spoke_end, Color(0.12, 0.052, 0.018, 0.09), 2.0)

	var rope_coils := [
		Vector2(arena.position.x + 270.0, arena.position.y + 84.0),
		Vector2(arena.end.x - 260.0, arena.end.y - 78.0),
		Vector2(arena.position.x + 86.0, arena.get_center().y + 148.0),
		Vector2(arena.end.x - 92.0, arena.get_center().y - 128.0),
	]
	for i in range(rope_coils.size()):
		var origin: Vector2 = rope_coils[i]
		_draw_flat_ellipse(origin + Vector2(10.0, 12.0), Vector2(35.0, 9.0), deep_shadow, 18)
		for ring in range(3):
			var radius := 17.0 + float(ring) * 7.0
			draw_arc(origin, radius, 0.15, TAU - 0.2, 30, rope, 3.0)
			draw_arc(origin + Vector2(-2.0, -2.0), radius * 0.84, 0.4, TAU - 0.45, 26, Color(0.92, 0.68, 0.32, 0.08), 1.4)
		draw_line(origin + Vector2(22.0, 2.0), origin + Vector2(58.0, 15.0 + float(i % 2) * 9.0), rope, 3.0)
		draw_line(origin + Vector2(25.0, 7.0), origin + Vector2(61.0, 20.0 + float(i % 2) * 9.0), shadow, 1.4)

	for i in range(_scenic_count(34, 20)):
		var side_index := i % 4
		var t := float((i * 7) % 29) / 28.0
		var base := Vector2.ZERO
		var forward := Vector2.RIGHT
		if side_index == 0:
			base = Vector2(lerpf(arena.position.x + 110.0, arena.end.x - 110.0, t), arena.position.y + 56.0 + sin(float(i)) * 18.0)
			forward = Vector2(1.0, 0.18).normalized()
		elif side_index == 1:
			base = Vector2(lerpf(arena.position.x + 110.0, arena.end.x - 110.0, t), arena.end.y - 60.0 + sin(float(i) * 1.2) * 17.0)
			forward = Vector2(1.0, -0.14).normalized()
		elif side_index == 2:
			base = Vector2(arena.position.x + 58.0 + sin(float(i) * 1.4) * 18.0, lerpf(arena.position.y + 118.0, arena.end.y - 118.0, t))
			forward = Vector2(0.16, 1.0).normalized()
		else:
			base = Vector2(arena.end.x - 62.0 + sin(float(i) * 1.1) * 16.0, lerpf(arena.position.y + 118.0, arena.end.y - 118.0, t))
			forward = Vector2(-0.18, 1.0).normalized()
		var side := forward.orthogonal()
		if i % 3 == 0:
			_draw_flat_ellipse(base - side * 6.0, Vector2(7.0, 3.0), hoof, 10)
			_draw_flat_ellipse(base + side * 7.0 + forward * 8.0, Vector2(7.0, 3.0), hoof, 10)
			draw_line(base - side * 14.0 - forward * 4.0, base + side * 13.0 + forward * 13.0, Color(0.92, 0.72, 0.34, 0.04), 1.2)
		else:
			_draw_flat_ellipse(base - side * 5.0, Vector2(6.0, 2.4), Color(0.11, 0.05, 0.018, 0.1), 10)
			_draw_flat_ellipse(base + side * 5.0 + forward * 10.0, Vector2(5.0, 2.2), Color(0.95, 0.73, 0.36, 0.045), 10)

	for i in range(_scenic_count(18, 10)):
		var side_index := i % 4
		var t := float((i * 11) % 23) / 22.0
		var pos := Vector2.ZERO
		if side_index == 0:
			pos = Vector2(lerpf(arena.position.x + 82.0, arena.end.x - 82.0, t), arena.position.y + 98.0 + sin(float(i)) * 26.0)
		elif side_index == 1:
			pos = Vector2(lerpf(arena.position.x + 82.0, arena.end.x - 82.0, t), arena.end.y - 98.0 + sin(float(i) * 1.2) * 24.0)
		elif side_index == 2:
			pos = Vector2(arena.position.x + 94.0 + sin(float(i) * 1.3) * 24.0, lerpf(arena.position.y + 112.0, arena.end.y - 112.0, t))
		else:
			pos = Vector2(arena.end.x - 96.0 + sin(float(i) * 1.1) * 24.0, lerpf(arena.position.y + 112.0, arena.end.y - 112.0, t))
		var plank := Rect2(pos, Vector2(26.0 + float(i % 4) * 7.0, 6.0 + float(i % 3) * 3.0))
		draw_rect(Rect2(plank.position + Vector2(5.0, 6.0), plank.size), deep_shadow, true)
		draw_rect(plank, wood, true)
		draw_rect(plank, Color(0.78, 0.48, 0.22, 0.11), false, 1.2)
		if i % 4 == 0:
			draw_circle(pos + Vector2(5.0, -7.0), 2.2, iron)
			draw_circle(pos + Vector2(14.0, -4.0), 1.8, Color(0.9, 0.67, 0.32, 0.12))

func _draw_high_noon_stage_lighting(arena: Rect2) -> void:
	var center := arena.get_center()
	var pulse := 0.5 + sin(_hazard_anim_time * 0.85) * 0.5
	var calm_zone := Rect2(
		center - Vector2(arena.size.x * 0.31, arena.size.y * 0.25),
		Vector2(arena.size.x * 0.62, arena.size.y * 0.5)
	)
	_draw_flat_ellipse(center + Vector2(16.0, -10.0), Vector2(arena.size.x * 0.34, arena.size.y * 0.22), Color(1.0, 0.79, 0.36, 0.042), _scenic_count(42, 28))
	_draw_flat_ellipse(center + Vector2(12.0, 28.0), Vector2(arena.size.x * 0.4, arena.size.y * 0.26), Color(0.18, 0.075, 0.024, 0.052), _scenic_count(42, 28))
	draw_rect(calm_zone, Color(1.0, 0.86, 0.48, 0.028), true)
	draw_rect(calm_zone, Color(0.12, 0.05, 0.018, 0.055), false, 3.0)

	var sun_shaft_count := _scenic_count(6, 4)
	for i in range(sun_shaft_count):
		var t := float(i) / float(maxi(1, sun_shaft_count - 1))
		var start := Vector2(lerpf(arena.position.x + 72.0, arena.end.x - 240.0, t), arena.position.y + 26.0 + float(i % 2) * 22.0)
		var end := start + Vector2(260.0 + float(i % 3) * 64.0, arena.size.y * 0.42 + float(i) * 9.0)
		draw_line(start + Vector2(0.0, 14.0), end + Vector2(0.0, 14.0), Color(0.08, 0.03, 0.01, 0.07), 24.0)
		draw_line(start, end, Color(1.0, 0.72, 0.26, 0.052 + pulse * 0.014), 11.0)
		draw_line(start + Vector2(8.0, -5.0), end + Vector2(8.0, -5.0), Color(1.0, 0.88, 0.52, 0.036 + pulse * 0.012), 2.0)

	var low_shadow_count := _scenic_count(5, 3)
	for i in range(low_shadow_count):
		var t := float(i) / float(maxi(1, low_shadow_count - 1))
		var start := Vector2(lerpf(arena.position.x + 116.0, arena.end.x - 180.0, t), arena.end.y - 76.0 - float(i % 2) * 24.0)
		var end := start + Vector2(150.0 + float(i) * 18.0, 48.0)
		draw_line(start, end, Color(0.055, 0.021, 0.008, 0.12), 20.0)
		draw_line(start + Vector2(0.0, -7.0), end + Vector2(0.0, -7.0), Color(1.0, 0.72, 0.28, 0.033 + pulse * 0.012), 2.0)

	var dust_ribbon_count := _scenic_count(7, 4)
	for i in range(dust_ribbon_count):
		var t := float(i) / float(maxi(1, dust_ribbon_count - 1))
		var y := lerpf(arena.position.y + arena.size.y * 0.2, arena.end.y - arena.size.y * 0.18, t)
		var drift := sin(float(i) * 1.7) * 42.0
		var start := Vector2(arena.position.x + 92.0 + drift, y)
		var end := Vector2(arena.end.x - 104.0 + drift * 0.28, y + 18.0 + sin(float(i) * 1.2) * 12.0)
		draw_line(start, end, Color(1.0, 0.83, 0.48, 0.035 + pulse * 0.01), 2.0)
		draw_line(start + Vector2(0.0, 5.0), end + Vector2(0.0, 5.0), Color(0.16, 0.07, 0.024, 0.045), 5.0)

	for i in range(4):
		var inset := 88.0 + float(i) * 42.0
		var alpha := 0.07 - float(i) * 0.011
		draw_rect(arena.grow(-inset), Color(0.055, 0.022, 0.008, alpha), false, 5.0)

func _draw_high_noon_edge_atmosphere(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 1.15) * 0.5
	var edge_depth := clampf(minf(arena.size.x, arena.size.y) * 0.14, 118.0, 172.0)
	var top_band := Rect2(arena.position, Vector2(arena.size.x, edge_depth))
	var bottom_band := Rect2(Vector2(arena.position.x, arena.end.y - edge_depth), Vector2(arena.size.x, edge_depth))
	var left_band := Rect2(arena.position, Vector2(edge_depth * 0.72, arena.size.y))
	var right_band := Rect2(Vector2(arena.end.x - edge_depth * 0.72, arena.position.y), Vector2(edge_depth * 0.72, arena.size.y))
	draw_rect(top_band, Color(1.0, 0.72, 0.32, 0.065 + pulse * 0.018), true)
	draw_rect(bottom_band, Color(0.42, 0.18, 0.06, 0.055), true)
	draw_rect(left_band, Color(0.42, 0.18, 0.06, 0.035), true)
	draw_rect(right_band, Color(1.0, 0.72, 0.32, 0.035 + pulse * 0.012), true)
	draw_rect(arena.grow(-edge_depth * 0.72), Color(1.0, 0.86, 0.48, 0.026), false, 5.0)
	var top_haze_count := _scenic_count(11, 7)
	for i in range(top_haze_count):
		var t := float(i) / float(maxi(1, top_haze_count - 1))
		var y := lerpf(arena.position.y + 34.0, arena.position.y + edge_depth - 24.0, t)
		var drift := sin(_hazard_anim_time * 0.7 + float(i) * 0.82) * 9.0
		var start := Vector2(arena.position.x + 58.0 + drift, y)
		var end := Vector2(arena.end.x - 62.0 + drift * 0.35, y + sin(float(i) * 1.3) * 10.0)
		draw_line(start + Vector2(0.0, 4.0), end + Vector2(0.0, 4.0), Color(0.22, 0.095, 0.032, 0.08), 5.0)
		draw_line(start, end, Color(1.0, 0.82, 0.46, 0.095 + pulse * 0.02), 2.2)
	var bottom_arc_count := _scenic_count(8, 5)
	for i in range(bottom_arc_count):
		var t := float(i) / float(maxi(1, bottom_arc_count - 1))
		var x := lerpf(arena.position.x + 72.0, arena.end.x - 72.0, t)
		var y := arena.end.y - edge_depth + 28.0 + sin(float(i) * 1.6) * 22.0
		draw_arc(Vector2(x, y), 32.0 + float(i % 3) * 7.0, -0.15, PI + 0.1, 18, Color(0.28, 0.12, 0.045, 0.095), 3.0)
		draw_arc(Vector2(x + 7.0, y - 3.0), 24.0 + float(i % 2) * 6.0, 0.1, PI - 0.1, 16, Color(1.0, 0.76, 0.34, 0.062 + pulse * 0.018), 2.0)
	for side_index in range(2):
		var x := arena.position.x + edge_depth * 0.42 if side_index == 0 else arena.end.x - edge_depth * 0.42
		var curl_count := _scenic_count(5, 3)
		for i in range(curl_count):
			var y := lerpf(arena.position.y + edge_depth * 0.42, arena.end.y - edge_depth * 0.42, float(i) / float(maxi(1, curl_count - 1)))
			var curl_center := Vector2(x + sin(float(i) * 1.2 + float(side_index)) * 14.0, y)
			draw_arc(curl_center, 18.0 + float(i % 2) * 5.0, 0.0, TAU * 0.68, 18, Color(0.86, 0.56, 0.22, 0.055), 2.0)
	_draw_sunfall_edge_shadow_bands(arena, edge_depth, pulse)

func _draw_sunfall_edge_shadow_bands(arena: Rect2, edge_depth: float, pulse: float) -> void:
	var shadow := Color(0.09, 0.035, 0.012, 0.18)
	var hot := Color(1.0, 0.74, 0.28, 0.1 + pulse * 0.03)
	for i in range(3):
		var top_cast_y := arena.position.y + edge_depth * (0.72 + float(i) * 0.16)
		var bottom_cast_y := arena.end.y - edge_depth * (0.92 - float(i) * 0.13)
		var top_start := Vector2(arena.position.x + 24.0 + float(i) * 84.0, top_cast_y)
		var top_end := Vector2(arena.end.x - 42.0 + float(i) * 20.0, top_cast_y + 30.0)
		var bottom_start := Vector2(arena.position.x + 48.0 + float(i) * 96.0, bottom_cast_y)
		var bottom_end := Vector2(arena.end.x - 36.0 + float(i) * 26.0, bottom_cast_y + 36.0)
		draw_line(top_start, top_end, Color(0.06, 0.023, 0.009, 0.09), 18.0)
		draw_line(top_start + Vector2(0.0, -5.0), top_end + Vector2(0.0, -5.0), Color(1.0, 0.77, 0.32, 0.038 + pulse * 0.012), 2.0)
		draw_line(bottom_start, bottom_end, Color(0.055, 0.02, 0.008, 0.105), 20.0)
		draw_line(bottom_start + Vector2(0.0, -6.0), bottom_end + Vector2(0.0, -6.0), Color(1.0, 0.72, 0.26, 0.034 + pulse * 0.012), 2.0)

	var cast_count := _scenic_count(7, 4)
	for i in range(cast_count):
		var t := float(i) / float(maxi(1, cast_count - 1))
		var top_y := lerpf(arena.position.y + 18.0, arena.position.y + edge_depth * 0.78, t)
		var top_start := Vector2(arena.position.x + 44.0 + float(i % 2) * 36.0, top_y)
		var top_end := top_start + Vector2(arena.size.x * 0.34, 34.0 + float(i % 3) * 10.0)
		draw_line(top_start + Vector2(0.0, 6.0), top_end + Vector2(0.0, 6.0), shadow, 18.0)
		draw_line(top_start, top_end, hot, 2.0)

		var bottom_y := lerpf(arena.end.y - edge_depth * 0.74, arena.end.y - 18.0, t)
		var bottom_start := Vector2(arena.position.x + 68.0 + float(i % 2) * 54.0, bottom_y)
		var bottom_end := bottom_start + Vector2(arena.size.x * 0.38, 42.0)
		draw_line(bottom_start + Vector2(0.0, 8.0), bottom_end + Vector2(0.0, 8.0), Color(0.055, 0.022, 0.008, 0.17), 20.0)
		draw_line(bottom_start, bottom_end, Color(1.0, 0.7, 0.24, 0.055 + pulse * 0.02), 2.0)

	for side_index in range(2):
		var side_x := arena.position.x + edge_depth * 0.18 if side_index == 0 else arena.end.x - edge_depth * 0.18
		var side_band_count := _scenic_count(6, 4)
		for i in range(side_band_count):
			var y := lerpf(arena.position.y + 42.0, arena.end.y - 42.0, float(i) / float(maxi(1, side_band_count - 1)))
			var start := Vector2(side_x, y)
			var end := start + Vector2(54.0 if side_index == 0 else -54.0, 18.0)
			draw_line(start, end, Color(1.0, 0.8, 0.36, 0.05 + pulse * 0.018), 2.0)

func _draw_arena_hazards() -> void:
	_draw_gold_rush_keg_links()
	for hazard in arena_hazards:
		if bool(hazard.get("spent", false)):
			continue
		var origin: Vector2 = hazard["origin"]
		var fuse: float = float(hazard.get("fuse", 0.0))
		var lit := fuse > 0.0
		var pulse := 0.5 + sin(_hazard_anim_time * 12.0) * 0.5
		var flash_alpha := lerpf(0.22, 0.72, pulse) if lit else 0.16
		_draw_powder_keg_hazard(origin, lit, pulse)
		if lit:
			var warning_radius := lerpf(72.0, 122.0, 1.0 - fuse / float(hazard.get("fuse_max", 0.55)))
			draw_arc(origin, warning_radius, 0.0, TAU, 46, Color(1.0, 0.3, 0.06, flash_alpha), 5.0)
			draw_circle(origin + Vector2(23.0, -43.0), 7.0 + pulse * 4.0, Color(1.0, 0.74, 0.22, 0.86))
			draw_circle(origin + Vector2(23.0, -43.0), 3.0, Color(1.0, 0.94, 0.62, 0.95))

func _draw_powder_keg_hazard(origin: Vector2, lit: bool, pulse: float) -> void:
	var body_color := Color(0.29, 0.105, 0.04, 0.98) if lit else Color(0.19, 0.078, 0.03, 0.97)
	var side_color := Color(0.105, 0.042, 0.018, 0.98) if lit else Color(0.075, 0.032, 0.014, 0.96)
	var band_color := Color(1.0, 0.66, 0.18, 0.94) if lit else Color(0.74, 0.43, 0.18, 0.86)
	var hot_color := Color(1.0, 0.48, 0.09, 0.28 + pulse * 0.2) if lit else Color(0.82, 0.52, 0.2, 0.16)
	var warning_alpha := 0.18 + pulse * 0.16 if lit else 0.09
	_draw_flat_ellipse(origin + Vector2(8.0, 32.0), Vector2(58.0, 19.0), Color(0.018, 0.008, 0.003, 0.36), 28)
	_draw_flat_ellipse(origin + Vector2(0.0, 26.0), Vector2(44.0, 12.0), Color(0.09, 0.035, 0.012, 0.22), 24)
	draw_arc(origin + Vector2(0.0, 3.0), 48.0, -0.2, PI + 0.2, 36, Color(1.0, 0.62, 0.16, warning_alpha), 4.0)
	draw_arc(origin + Vector2(0.0, 3.0), 39.0, PI + 0.2, TAU - 0.15, 30, Color(0.035, 0.014, 0.006, 0.22), 3.0)
	for tick_index in range(8):
		var angle := TAU * float(tick_index) / 8.0 + 0.22
		var direction := Vector2(cos(angle), sin(angle))
		var tick_color := Color(1.0, 0.75, 0.24, 0.2 + pulse * 0.2) if lit and tick_index % 2 == 0 else Color(0.09, 0.035, 0.012, 0.28)
		draw_line(origin + direction * 48.0, origin + direction * 55.0, tick_color, 2.0)
	draw_circle(origin + Vector2(0.0, 7.0), 35.0, Color(0.045, 0.02, 0.01, 0.92))
	var barrel_outline := [
		origin + Vector2(-30.0, -19.0),
		origin + Vector2(-20.0, -31.0),
		origin + Vector2(19.0, -31.0),
		origin + Vector2(31.0, -18.0),
		origin + Vector2(28.0, 24.0),
		origin + Vector2(17.0, 34.0),
		origin + Vector2(-18.0, 33.0),
		origin + Vector2(-29.0, 22.0),
	]
	draw_colored_polygon(barrel_outline, side_color)
	draw_colored_polygon([
		origin + Vector2(-22.0, -23.0),
		origin + Vector2(-10.0, -29.0),
		origin + Vector2(12.0, -29.0),
		origin + Vector2(24.0, -21.0),
		origin + Vector2(22.0, 25.0),
		origin + Vector2(11.0, 31.0),
		origin + Vector2(-11.0, 30.0),
		origin + Vector2(-22.0, 22.0),
	], body_color)
	draw_arc(origin + Vector2(0.0, -18.0), 26.0, PI * 0.08, PI * 0.92, 24, Color(0.86, 0.48, 0.18, 0.44), 4.0)
	draw_arc(origin + Vector2(0.0, 18.0), 24.0, PI * 1.08, PI * 1.92, 24, Color(0.04, 0.018, 0.008, 0.55), 4.0)
	for stave_x in [-15.0, 0.0, 15.0]:
		var top := origin + Vector2(stave_x * 0.58, -26.0)
		var bottom := origin + Vector2(stave_x, 27.0)
		draw_line(top, bottom, Color(0.055, 0.022, 0.01, 0.46), 2.0)
		draw_line(top + Vector2(2.0, 1.0), bottom + Vector2(2.0, -1.0), Color(0.72, 0.38, 0.14, 0.18), 1.2)
	for band_y in [-8.0, 12.0]:
		draw_line(origin + Vector2(-27.0, band_y), origin + Vector2(27.0, band_y - 1.0), Color(0.05, 0.022, 0.011, 0.78), 7.0)
		draw_line(origin + Vector2(-25.0, band_y - 2.0), origin + Vector2(25.0, band_y - 3.0), band_color, 4.0)
		draw_circle(origin + Vector2(-18.0, band_y - 2.0), 2.5, Color(0.98, 0.76, 0.34, 0.72))
		draw_circle(origin + Vector2(18.0, band_y - 3.0), 2.5, Color(0.98, 0.76, 0.34, 0.72))
	draw_line(origin + Vector2(-25.0, 2.0), origin + Vector2(25.0, 1.0), Color(1.0, 0.72, 0.22, (0.42 + pulse * 0.18) if lit else 0.3), 3.0)
	draw_circle(origin + Vector2(0.0, 1.0), 9.0, Color(0.035, 0.014, 0.006, 0.72))
	draw_circle(origin + Vector2(-4.0, -1.0), 2.7, Color(0.9, 0.75, 0.46, 0.74))
	draw_circle(origin + Vector2(4.0, -1.0), 2.7, Color(0.9, 0.75, 0.46, 0.74))
	draw_line(origin + Vector2(-6.0, 8.0), origin + Vector2(6.0, 8.0), Color(0.9, 0.75, 0.46, 0.64), 2.0)
	draw_line(origin + Vector2(-15.0, 15.0), origin + Vector2(15.0, 25.0), Color(0.92, 0.74, 0.4, 0.5), 2.0)
	draw_line(origin + Vector2(15.0, 15.0), origin + Vector2(-15.0, 25.0), Color(0.92, 0.74, 0.4, 0.5), 2.0)
	draw_line(origin + Vector2(-19.0, 27.0), origin + Vector2(20.0, 27.0), Color(0.86, 0.48, 0.16, 0.38), 2.0)
	draw_circle(origin + Vector2(10.0, -25.0), 7.0, Color(0.035, 0.017, 0.008, 1.0))
	draw_circle(origin + Vector2(10.0, -25.0), 3.6, Color(0.74, 0.45, 0.2, 0.78))
	draw_line(origin + Vector2(10.0, -30.0), origin + Vector2(22.0, -43.0), Color(0.045, 0.026, 0.014, 1.0), 4.0)
	draw_line(origin + Vector2(12.0, -31.0), origin + Vector2(23.0, -43.0), Color(0.62, 0.43, 0.24, 0.62), 1.4)
	draw_arc(origin + Vector2(18.0, -38.0), 13.0, -0.4, PI * 0.9, 16, Color(0.13, 0.075, 0.038, 0.82), 2.2)
	draw_arc(origin + Vector2(18.0, -38.0), 8.0, -0.2, PI * 0.85, 14, Color(0.72, 0.5, 0.26, 0.42), 1.2)
	draw_arc(origin + Vector2(-3.0, -1.0), 31.0, -0.7, 2.65, 28, hot_color, 3.0)
	if lit:
		draw_circle(origin, 39.0 + pulse * 6.0, Color(1.0, 0.24, 0.05, 0.07 + pulse * 0.06))
		draw_line(origin + Vector2(21.0, -42.0), origin + Vector2(28.0, -50.0), Color(1.0, 0.58, 0.12, 0.82), 4.0)
		draw_line(origin + Vector2(23.0, -43.0), origin + Vector2(16.0, -52.0), Color(1.0, 0.85, 0.36, 0.68), 2.5)
		for spark_index in range(3):
			var spark_angle := -1.25 + float(spark_index) * 0.42 + pulse * 0.18
			var start := origin + Vector2(23.0, -43.0)
			draw_line(start, start + Vector2(cos(spark_angle), sin(spark_angle)) * (13.0 + float(spark_index) * 3.0), Color(1.0, 0.78, 0.28, 0.42 + pulse * 0.28), 1.8)

func _draw_arena_cover_props() -> void:
	for cover in arena_cover_props:
		if str(cover.get("kind", "")) == "saloon_cover":
			_draw_saloon_cover_prop(cover)

func _draw_saloon_cover_prop(cover: Dictionary) -> void:
	var origin: Vector2 = cover["origin"]
	var size: Vector2 = cover.get("size", Vector2(210.0, 72.0))
	var angle: float = float(cover.get("angle", 0.0))
	var splintered := bool(cover.get("splintered", false))
	var bait_strength := _get_cover_rifle_bait_strength(cover)
	var half := size * 0.5
	draw_set_transform(origin + Vector2(24.0, 32.0), angle, Vector2.ONE)
	_draw_flat_ellipse(Vector2.ZERO, Vector2(size.x * 0.64, size.y * 0.54), Color(0.018, 0.008, 0.004, 0.34), 30)
	_draw_flat_ellipse(Vector2(-8.0, -1.0), Vector2(size.x * 0.48, size.y * 0.35), Color(0.08, 0.035, 0.014, 0.18), 24)
	draw_set_transform(origin, angle, Vector2.ONE)
	var table_outline := [
		Vector2(-half.x + 16.0, -half.y - 2.0),
		Vector2(half.x - 12.0, -half.y + 4.0),
		Vector2(half.x + 8.0, -half.y + 22.0),
		Vector2(half.x - 18.0, half.y + 4.0),
		Vector2(-half.x + 12.0, half.y + 5.0),
		Vector2(-half.x - 10.0, half.y - 18.0),
	]
	draw_colored_polygon(table_outline, Color(0.07, 0.028, 0.012, 0.98))
	draw_polyline(PackedVector2Array(table_outline + [table_outline[0]]), Color(0.018, 0.007, 0.003, 0.9), 8.0)
	draw_polyline(PackedVector2Array(table_outline + [table_outline[0]]), Color(0.88, 0.55, 0.22, 0.22), 2.0)
	for leg in [
		Rect2(Vector2(-half.x + 18.0, half.y - 8.0), Vector2(12.0, 26.0)),
		Rect2(Vector2(half.x - 30.0, half.y - 8.0), Vector2(12.0, 26.0)),
		Rect2(Vector2(-half.x + 24.0, -half.y + 5.0), Vector2(10.0, 20.0)),
		Rect2(Vector2(half.x - 34.0, -half.y + 8.0), Vector2(10.0, 18.0)),
	]:
		draw_rect(leg, Color(0.055, 0.024, 0.011, 0.88), true)
	var plank_height := size.y / 3.0
	for plank_index in range(3):
		var inset := 9.0 + float(plank_index % 2) * 5.0
		var plank_rect := Rect2(Vector2(-half.x + inset, -half.y + 4.0 + plank_height * float(plank_index)), Vector2(size.x - inset * 2.0, plank_height - 4.0))
		var plank_color := Color(0.49, 0.29, 0.135, 0.94) if plank_index % 2 == 0 else Color(0.36, 0.19, 0.085, 0.96)
		draw_rect(plank_rect, plank_color, true)
		draw_line(plank_rect.position + Vector2(6.0, 5.0), plank_rect.position + Vector2(plank_rect.size.x - 8.0, 3.0), Color(0.83, 0.55, 0.24, 0.22), 1.5)
		draw_line(plank_rect.position + Vector2(0.0, plank_rect.size.y), plank_rect.position + Vector2(plank_rect.size.x, plank_rect.size.y), Color(0.08, 0.035, 0.015, 0.6), 2.0)
	draw_line(Vector2(-half.x + 18.0, -half.y + 9.0), Vector2(half.x - 24.0, half.y - 11.0), Color(0.18, 0.075, 0.03, 0.82), 10.0)
	draw_line(Vector2(-half.x + 20.0, -half.y + 5.0), Vector2(half.x - 24.0, half.y - 15.0), Color(0.69, 0.43, 0.18, 0.5), 3.0)
	draw_line(Vector2(-half.x + 10.0, -half.y + 3.0), Vector2(half.x - 12.0, -half.y + 6.0), Color(0.9, 0.6, 0.24, 0.56), 3.0)
	draw_line(Vector2(-half.x + 14.0, half.y - 1.0), Vector2(half.x - 15.0, half.y - 1.0), Color(0.09, 0.038, 0.015, 0.76), 4.0)
	for edge_mark in [
		{"a": Vector2(-half.x + 6.0, -half.y + 3.0), "b": Vector2(-half.x + 46.0, -half.y + 8.0)},
		{"a": Vector2(half.x - 48.0, -half.y + 7.0), "b": Vector2(half.x + 2.0, -half.y + 20.0)},
		{"a": Vector2(-half.x - 4.0, half.y - 17.0), "b": Vector2(-half.x + 42.0, half.y + 2.0)},
		{"a": Vector2(half.x - 54.0, half.y + 0.0), "b": Vector2(half.x - 10.0, half.y + 3.0)},
	]:
		var a: Vector2 = edge_mark["a"]
		var b: Vector2 = edge_mark["b"]
		draw_line(a, b, Color(0.025, 0.011, 0.005, 0.82), 6.0)
		draw_line(a + Vector2(1.0, -1.0), b + Vector2(1.0, -1.0), Color(0.95, 0.62, 0.24, 0.42), 2.0)
	for x_offset in [-half.x + 22.0, -half.x + 82.0, half.x - 82.0, half.x - 22.0]:
		draw_circle(Vector2(x_offset, -half.y + 14.0), 4.0, Color(0.86, 0.57, 0.22, 0.9))
		draw_circle(Vector2(x_offset, half.y - 15.0), 3.4, Color(0.69, 0.39, 0.13, 0.86))
	for corner in [
		Vector2(-half.x + 18.0, -half.y + 7.0),
		Vector2(half.x - 16.0, -half.y + 12.0),
		Vector2(-half.x + 15.0, half.y - 8.0),
		Vector2(half.x - 19.0, half.y - 8.0),
	]:
		draw_rect(Rect2(corner + Vector2(-7.0, -5.0), Vector2(14.0, 10.0)), Color(0.08, 0.035, 0.014, 0.7), true)
		draw_rect(Rect2(corner + Vector2(-5.0, -3.0), Vector2(10.0, 6.0)), Color(0.94, 0.62, 0.24, 0.62), true)
	if not splintered:
		for bottle in [
			{"pos": Vector2(-half.x + 52.0, -half.y + 20.0), "tilt": -0.12, "glass": Color(0.12, 0.24, 0.12, 0.88)},
			{"pos": Vector2(half.x - 54.0, half.y - 24.0), "tilt": 0.16, "glass": Color(0.13, 0.18, 0.11, 0.86)},
		]:
			var bottle_pos: Vector2 = bottle["pos"]
			draw_set_transform(origin, angle + float(bottle.get("tilt", 0.0)), Vector2.ONE)
			draw_rect(Rect2(bottle_pos + Vector2(-5.0, -13.0), Vector2(10.0, 25.0)), bottle["glass"], true)
			draw_rect(Rect2(bottle_pos + Vector2(-3.0, -24.0), Vector2(6.0, 11.0)), Color(0.08, 0.13, 0.08, 0.9), true)
			draw_line(bottle_pos + Vector2(1.0, -20.0), bottle_pos + Vector2(2.0, 9.0), Color(0.86, 0.82, 0.52, 0.42), 1.4)
			draw_set_transform(origin, angle, Vector2.ONE)
		draw_arc(Vector2(-8.0, -9.0), 13.0, 0.2, TAU - 0.2, 24, Color(0.84, 0.76, 0.48, 0.5), 2.0)
		draw_line(Vector2(8.0, -4.0), Vector2(21.0, -10.0), Color(0.86, 0.72, 0.42, 0.46), 2.0)
		for card_index in range(3):
			var card := Rect2(Vector2(half.x - 90.0 + float(card_index) * 12.0, -6.0 + float(card_index) * 3.0), Vector2(20.0, 13.0))
			draw_rect(card, Color(0.78, 0.66, 0.44, 0.72), true)
			draw_rect(card, Color(0.13, 0.055, 0.025, 0.54), false, 1.0)
	if splintered:
		draw_line(Vector2(-half.x + 38.0, -half.y + 8.0), Vector2(-18.0, half.y - 9.0), Color(0.035, 0.014, 0.006, 0.9), 7.0)
		draw_line(Vector2(-half.x + 42.0, -half.y + 10.0), Vector2(-10.0, half.y - 12.0), Color(0.98, 0.68, 0.28, 0.54), 2.4)
		draw_line(Vector2(half.x - 34.0, -half.y + 6.0), Vector2(half.x - 68.0, half.y - 7.0), Color(0.035, 0.014, 0.006, 0.84), 5.0)
		draw_colored_polygon([
			Vector2(-half.x + 74.0, -half.y + 4.0),
			Vector2(-half.x + 120.0, -half.y + 17.0),
			Vector2(-half.x + 84.0, -half.y + 33.0),
		], Color(0.06, 0.025, 0.011, 0.68))
		draw_colored_polygon([
			Vector2(half.x - 82.0, half.y - 3.0),
			Vector2(half.x - 40.0, half.y - 24.0),
			Vector2(half.x - 34.0, half.y + 8.0),
		], Color(0.83, 0.49, 0.18, 0.56))
		for shard in [
			Vector2(-half.x + 64.0, -half.y + 20.0),
			Vector2(-12.0, 2.0),
			Vector2(half.x - 56.0, half.y - 18.0),
			Vector2(half.x - 16.0, 11.0),
		]:
			draw_line(shard, shard + Vector2(24.0, 8.0), Color(0.90, 0.56, 0.20, 0.64), 3.0)
			draw_circle(shard + Vector2(8.0, 9.0), 4.0, Color(0.12, 0.055, 0.022, 0.55))
		for shard_line in [
			{"a": Vector2(-half.x + 42.0, -half.y + 32.0), "b": Vector2(-half.x + 112.0, half.y + 18.0)},
			{"a": Vector2(-half.x + 116.0, -half.y + 18.0), "b": Vector2(-half.x + 172.0, -half.y + 44.0)},
			{"a": Vector2(half.x - 90.0, half.y - 28.0), "b": Vector2(half.x - 28.0, half.y + 18.0)},
		]:
			var shard_a: Vector2 = shard_line["a"]
			var shard_b: Vector2 = shard_line["b"]
			draw_line(shard_a, shard_b, Color(0.035, 0.014, 0.006, 0.88), 5.0)
			draw_line(shard_a + Vector2(2.0, -1.0), shard_b + Vector2(2.0, -1.0), Color(1.0, 0.68, 0.24, 0.5), 1.8)
	elif bait_strength > 0.0:
		var shimmer := 0.55 + sin(_hazard_anim_time * 14.0) * 0.45
		var alpha := 0.28 + bait_strength * 0.36 + shimmer * 0.12
		draw_arc(Vector2.ZERO, half.x * 0.42, -0.2, PI + 0.2, 32, Color(1.0, 0.82, 0.28, alpha), 5.0)
		draw_arc(Vector2.ZERO, half.x * 0.27, PI + 0.15, TAU - 0.15, 24, Color(1.0, 0.93, 0.62, alpha * 0.76), 3.0)
		draw_line(Vector2(-half.x + 32.0, -half.y + 18.0), Vector2(half.x - 30.0, half.y - 16.0), Color(1.0, 0.76, 0.26, alpha * 0.82), 4.0)
		for pip in [Vector2(-half.x + 46.0, -half.y + 22.0), Vector2(0.0, 0.0), Vector2(half.x - 48.0, half.y - 22.0)]:
			draw_circle(pip, 5.0 + shimmer * 2.0, Color(1.0, 0.86, 0.34, alpha))
			draw_circle(pip, 2.0, Color(1.0, 0.97, 0.72, alpha * 0.92))
	draw_polyline(table_outline + [table_outline[0]], Color(0.92, 0.64, 0.25, 0.26), 2.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _get_cover_rifle_bait_strength(cover: Dictionary) -> float:
	if str(_get_level_modifier(current_wave).get("id", "")) != "crossfire":
		return 0.0
	if bool(cover.get("splintered", false)):
		return 0.0
	var cover_origin: Vector2 = cover["origin"]
	var best_strength := 0.0
	for line in _get_active_rifle_tell_lines():
		var start: Vector2 = line["start"]
		var end: Vector2 = line["end"]
		if _distance_to_segment(cover_origin, start, end) <= 84.0:
			best_strength = maxf(best_strength, maxf(0.42, float(line.get("strength", 0.0))))
	return best_strength

func _get_active_rifle_tell_lines() -> Array[Dictionary]:
	var lines: Array[Dictionary] = []
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if not _smoke_enemy_matches_kind(enemy, "rifleman"):
			continue
		if not enemy.has_method("get_attack_tell_line"):
			continue
		var line: Dictionary = enemy.get_attack_tell_line()
		if not line.is_empty():
			lines.append(line)
	return lines

func _draw_gold_rush_keg_links() -> void:
	if str(_get_level_modifier(current_wave).get("id", "")) != "gold_rush":
		return
	var pair_start := 0
	while pair_start + 1 < arena_hazards.size():
		var first: Dictionary = arena_hazards[pair_start]
		var second: Dictionary = arena_hazards[pair_start + 1]
		if bool(first.get("spent", false)) and bool(second.get("spent", false)):
			pair_start += 2
			continue
		var first_origin: Vector2 = first["origin"]
		var second_origin: Vector2 = second["origin"]
		var lit := float(first.get("fuse", 0.0)) > 0.0 or float(second.get("fuse", 0.0)) > 0.0
		var speed := 8.0 if lit else 3.4
		var pulse := 0.5 + sin(_hazard_anim_time * speed + float(pair_start)) * 0.5
		_draw_gold_rush_keg_chain_preview(first_origin, second_origin, pulse, lit)
		var spark_t := 0.5 + sin(_hazard_anim_time * 2.2 + float(pair_start)) * 0.22
		var spark_origin := first_origin.lerp(second_origin, spark_t)
		draw_circle(spark_origin, 6.0 + pulse * 3.0, Color(1.0, 0.82, 0.32, 0.22 + pulse * 0.24))
		draw_line(spark_origin + Vector2(-8.0, 0.0), spark_origin + Vector2(8.0, 0.0), Color(1.0, 0.9, 0.48, 0.18 + pulse * 0.2), 2.0)
		draw_line(spark_origin + Vector2(0.0, -8.0), spark_origin + Vector2(0.0, 8.0), Color(1.0, 0.9, 0.48, 0.18 + pulse * 0.2), 2.0)
		pair_start += 2

func _draw_gold_rush_keg_chain_preview(first_origin: Vector2, second_origin: Vector2, pulse: float, lit: bool) -> void:
	var link := second_origin - first_origin
	var distance := link.length()
	if distance <= 1.0:
		return
	var direction := link / distance
	var side := direction.orthogonal()
	var hot := 1.0 if lit else 0.0
	var rail_alpha := 0.22 + pulse * 0.16 + hot * 0.22
	var lane_width := 18.0 + hot * 12.0
	var brass := Color(1.0, 0.68, 0.22, rail_alpha)
	var bone := Color(1.0, 0.9, 0.5, 0.16 + pulse * 0.12 + hot * 0.16)
	draw_line(first_origin + Vector2(7.0, 13.0), second_origin + Vector2(7.0, 13.0), Color(0.06, 0.025, 0.008, 0.32 + hot * 0.16), 18.0 + hot * 6.0)
	draw_line(first_origin + side * lane_width, second_origin + side * lane_width, brass, 4.0 + hot * 2.0)
	draw_line(first_origin - side * lane_width, second_origin - side * lane_width, brass.darkened(0.08), 4.0 + hot * 2.0)
	draw_line(first_origin, second_origin, bone, 3.0 + hot * 2.0)
	for endpoint in [first_origin, second_origin]:
		draw_arc(endpoint, 46.0 + pulse * 5.0 + hot * 7.0, 0.0, TAU, 42, Color(1.0, 0.7, 0.22, 0.18 + pulse * 0.1 + hot * 0.18), 4.0 + hot * 2.0)
		draw_arc(endpoint, 32.0, 0.0, TAU, 30, Color(0.08, 0.035, 0.014, 0.22), 2.0)
	for pip in range(5):
		var travel := fposmod(_hazard_anim_time * (0.28 + hot * 0.42) + float(pip) / 5.0, 1.0)
		var point := first_origin.lerp(second_origin, travel)
		draw_circle(point, 4.0 + pulse * 1.8 + hot * 1.8, Color(1.0, 0.78, 0.28, 0.28 + pulse * 0.16 + hot * 0.22))
		draw_circle(point + side * lane_width, 3.0 + hot * 1.5, Color(1.0, 0.9, 0.48, 0.18 + hot * 0.18))
		draw_circle(point - side * lane_width, 3.0 + hot * 1.5, Color(1.0, 0.74, 0.26, 0.16 + hot * 0.16))

func _draw_payday_pickups() -> void:
	for pickup in payday_pickups:
		if bool(pickup.get("collected", false)):
			continue
		var origin: Vector2 = pickup["origin"]
		var age: float = float(pickup.get("age", 0.0))
		var pulse := 0.5 + sin(age * 6.0) * 0.5
		var bob := sin(age * 4.4) * 4.0
		var center := origin + Vector2(0.0, bob)
		_draw_flat_ellipse(center + Vector2(6.0, 25.0), Vector2(48.0, 14.0), Color(0.025, 0.012, 0.006, 0.25), 24)
		draw_circle(center, 37.0 + pulse * 5.0, Color(1.0, 0.72, 0.22, 0.13 + pulse * 0.08))
		draw_arc(center, 43.0 + pulse * 4.0, -0.2, PI + 0.25, 34, Color(1.0, 0.86, 0.38, 0.18 + pulse * 0.1), 3.0)
		if _is_payday_route_hint_visible(pickup):
			_draw_payday_route_hint(center, pickup, pulse)
		if _is_payday_pointer_visible(pickup):
			_draw_payday_pickup_pointer(center, pickup, pulse)
		if _is_payday_optional_label_visible(pickup):
			_draw_payday_optional_label(center, pickup, pulse)
		_draw_payday_satchel(center, pulse, int(pickup.get("ammo", 0)), int(pickup.get("credits", 0)))
		draw_arc(center, 48.0 + pulse * 6.0, 0.0, TAU, 38, Color(1.0, 0.84, 0.38, 0.28), 3.0)

func _draw_payday_satchel(center: Vector2, pulse: float, ammo_refill: int, credit_bonus: int) -> void:
	var shadow_center := center + Vector2(6.0, 21.0)
	draw_set_transform(shadow_center, 0.0, Vector2(35.0, 8.0))
	draw_circle(Vector2.ZERO, 1.0, Color(0.025, 0.012, 0.006, 0.22))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_line(center + Vector2(-5.0, 24.0), center + Vector2(42.0, 39.0), Color(0.04, 0.016, 0.006, 0.16), 10.0)
	draw_line(center + Vector2(-17.0, 22.0), center + Vector2(21.0, 35.0), Color(0.12, 0.05, 0.016, 0.08), 5.0)

	var body := PackedVector2Array([
		center + Vector2(-23.0, -12.0),
		center + Vector2(-16.0, -24.0),
		center + Vector2(18.0, -22.0),
		center + Vector2(25.0, -10.0),
		center + Vector2(21.0, 21.0),
		center + Vector2(-20.0, 23.0),
	])
	var flap := PackedVector2Array([
		center + Vector2(-17.0, -19.0),
		center + Vector2(17.0, -18.0),
		center + Vector2(11.0, -1.0),
		center + Vector2(-10.0, 1.0),
	])
	var brass := Color(1.0, 0.72, 0.24, 0.84 + pulse * 0.12)
	var bone := Color(0.96, 0.84, 0.48, 0.76)
	var leather_dark := Color(0.12, 0.055, 0.026, 0.98)
	var leather_mid := Color(0.36, 0.17, 0.065, 0.98)
	_draw_payday_coin_spill(center, pulse, credit_bonus, brass, bone)

	draw_colored_polygon(body, Color(0.055, 0.025, 0.012, 0.98))
	draw_polyline(PackedVector2Array([body[0], body[1], body[2], body[3], body[4], body[5], body[0]]), Color(0.02, 0.01, 0.006, 0.78), 6.0)
	draw_colored_polygon(body, leather_mid)
	draw_colored_polygon([
		center + Vector2(-18.0, -8.0),
		center + Vector2(18.0, -9.0),
		center + Vector2(15.0, 19.0),
		center + Vector2(-15.0, 20.0),
	], Color(0.46, 0.22, 0.085, 0.52))
	_draw_payday_satchel_grain(center, pulse, leather_dark, brass, bone)
	draw_colored_polygon(flap, leather_dark)
	draw_polyline(PackedVector2Array([flap[0], flap[1], flap[2], flap[3], flap[0]]), Color(0.78, 0.42, 0.16, 0.72), 2.4)
	draw_line(center + Vector2(-15.0, -20.0), center + Vector2(14.0, -19.0), Color(0.88, 0.48, 0.18, 0.34), 1.4)
	draw_line(center + Vector2(-21.0, -6.0), center + Vector2(22.0, -8.0), brass, 3.4)
	draw_line(center + Vector2(-18.0, 16.0), center + Vector2(18.0, 14.0), Color(0.09, 0.04, 0.018, 0.68), 4.0)
	draw_line(center + Vector2(-14.0, 16.0), center + Vector2(14.0, 14.0), Color(0.74, 0.42, 0.17, 0.54), 1.8)
	draw_rect(Rect2(center + Vector2(-7.0, -10.0), Vector2(14.0, 10.0)), brass.darkened(0.08), false, 2.0)
	draw_line(center + Vector2(-5.0, -5.0), center + Vector2(5.0, -5.0), Color(0.04, 0.018, 0.008, 0.8), 2.0)
	_draw_payday_bank_stamp(center, pulse, brass, bone)
	_draw_payday_ammo_spill(center, pulse, ammo_refill, brass, bone)
	_draw_payday_reward_silhouettes(center, pulse, ammo_refill, credit_bonus, brass, bone)
	draw_line(center + Vector2(-27.0, -3.0), center + Vector2(-34.0, 12.0), Color(0.48, 0.24, 0.09, 0.78), 3.2)
	draw_line(center + Vector2(27.0, -4.0), center + Vector2(34.0, 11.0), Color(0.48, 0.24, 0.09, 0.78), 3.2)

func _draw_payday_satchel_grain(center: Vector2, pulse: float, leather_dark: Color, brass: Color, bone: Color) -> void:
	for i in range(5):
		var y := -4.0 + float(i) * 5.5
		var start := center + Vector2(-16.0 + float(i % 2) * 3.0, y)
		var end := center + Vector2(16.0 - float((i + 1) % 2) * 4.0, y - 2.0)
		draw_line(start, end, Color(leather_dark.r, leather_dark.g, leather_dark.b, 0.24), 1.2)
		if i < 3:
			draw_line(start + Vector2(1.0, -2.0), start + Vector2(8.0, -3.0), Color(0.74, 0.38, 0.14, 0.16 + pulse * 0.06), 1.0)
	for i in range(7):
		var x := lerpf(-20.0, 20.0, float(i) / 6.0)
		draw_circle(center + Vector2(x, 20.0 + sin(float(i)) * 1.5), 1.6, brass.darkened(0.04))
		draw_circle(center + Vector2(x, -15.0 + cos(float(i)) * 1.2), 1.2, Color(bone.r, bone.g, bone.b, 0.28))

func _draw_payday_reward_silhouettes(center: Vector2, pulse: float, ammo_refill: int, credit_bonus: int, brass: Color, bone: Color) -> void:
	var coin_badge := center + Vector2(-32.0, -15.0)
	var ammo_badge := center + Vector2(32.0, -15.0)
	draw_circle(coin_badge + Vector2(2.0, 2.0), 8.0, Color(0.025, 0.012, 0.006, 0.24))
	draw_circle(coin_badge, 7.5 + pulse * 0.8, brass)
	draw_circle(coin_badge, 3.2, Color(0.08, 0.036, 0.016, 0.7))
	draw_line(coin_badge + Vector2(-4.0, 0.0), coin_badge + Vector2(4.0, 0.0), bone, 1.2)
	draw_line(ammo_badge + Vector2(2.0, 3.0), ammo_badge + Vector2(2.0, 15.0), Color(0.025, 0.012, 0.006, 0.26), 6.0)
	draw_line(ammo_badge, ammo_badge + Vector2(0.0, 14.0), brass, 5.0)
	draw_circle(ammo_badge + Vector2(0.0, 15.0), 3.2, bone)
	if credit_bonus > 30:
		draw_arc(coin_badge, 12.0 + pulse * 1.2, -0.4, PI + 0.6, 22, Color(1.0, 0.9, 0.48, 0.18 + pulse * 0.08), 2.0)
	if ammo_refill > 1:
		draw_line(ammo_badge + Vector2(-5.0, 5.0), ammo_badge + Vector2(5.0, 5.0), Color(1.0, 0.86, 0.42, 0.22 + pulse * 0.08), 1.4)

func _draw_payday_coin_spill(center: Vector2, pulse: float, credit_bonus: int, brass: Color, bone: Color) -> void:
	var coin_offsets := [
		Vector2(-32.0, 11.0),
		Vector2(-24.0, 23.0),
		Vector2(26.0, 18.0),
		Vector2(34.0, 4.0),
		Vector2(-7.0, 29.0),
	]
	var visible_coins := clampi(2 + credit_bonus / 22, 3, coin_offsets.size())
	for i in range(visible_coins):
		var coin_pos: Vector2 = center + coin_offsets[i]
		var coin_radius := 5.0 if i < 3 else 3.8
		draw_circle(coin_pos + Vector2(2.0, 2.5), coin_radius, Color(0.04, 0.018, 0.008, 0.26))
		draw_circle(coin_pos, coin_radius, brass.darkened(0.08))
		draw_circle(coin_pos + Vector2(-1.0, -1.0), coin_radius * 0.44, Color(1.0, 0.9, 0.52, 0.5 + pulse * 0.16))
		draw_line(coin_pos + Vector2(-coin_radius * 0.5, 0.0), coin_pos + Vector2(coin_radius * 0.45, -1.0), bone, 1.0)

func _draw_payday_bank_stamp(center: Vector2, pulse: float, brass: Color, bone: Color) -> void:
	var stamp_center := center + Vector2(0.0, -5.0)
	for i in range(8):
		var angle := TAU * float(i) / 8.0
		draw_line(stamp_center, stamp_center + Vector2(cos(angle), sin(angle)) * 9.0, brass.darkened(0.05), 2.0)
	draw_circle(stamp_center, 7.2, brass)
	draw_circle(stamp_center, 3.2, Color(0.08, 0.036, 0.016, 0.86))
	draw_arc(stamp_center, 12.0 + pulse * 1.5, -0.7, PI + 0.5, 24, Color(bone.r, bone.g, bone.b, 0.26 + pulse * 0.12), 2.0)

func _draw_payday_ammo_spill(center: Vector2, pulse: float, ammo_refill: int, brass: Color, bone: Color) -> void:
	var shell_count := clampi(ammo_refill + 1, 2, 4)
	for i in range(shell_count):
		var shell_pos := center + Vector2(-20.0 + float(i) * 13.0, -30.0 - pulse * 1.5 + float(i % 2) * 3.0)
		draw_line(shell_pos + Vector2(2.0, 3.0), shell_pos + Vector2(2.0, 15.0), Color(0.035, 0.018, 0.008, 0.38), 5.0)
		draw_line(shell_pos, shell_pos + Vector2(0.0, 12.0), brass, 4.0)
		draw_line(shell_pos + Vector2(-1.4, 2.0), shell_pos + Vector2(-1.4, 9.0), Color(1.0, 0.86, 0.42, 0.34), 1.1)
		draw_circle(shell_pos + Vector2(0.0, 13.0), 2.7, bone)

func _is_payday_pointer_visible(pickup: Dictionary) -> bool:
	if bool(pickup.get("collected", false)):
		return false
	return float(pickup.get("age", 0.0)) <= float(pickup.get("pointer_life", 0.0))

func _is_payday_route_hint_visible(pickup: Dictionary) -> bool:
	if bool(pickup.get("collected", false)) or player == null:
		return false
	var distance: float = player.global_position.distance_to(pickup["origin"])
	return distance >= float(pickup.get("route_min_distance", 72.0)) and float(pickup.get("age", 0.0)) <= float(pickup.get("route_life", 0.0))

func _is_payday_optional_label_visible(pickup: Dictionary) -> bool:
	if bool(pickup.get("collected", false)):
		return false
	return bool(pickup.get("first_drop", false)) and float(pickup.get("age", 0.0)) <= float(pickup.get("optional_label_life", 0.0))

func _draw_payday_route_hint(center: Vector2, pickup: Dictionary, pulse: float) -> void:
	var age: float = float(pickup.get("age", 0.0))
	var route_life := maxf(0.01, float(pickup.get("route_life", 1.0)))
	var fade := clampf(1.0 - age / route_life, 0.0, 1.0)
	var start: Vector2 = player.global_position
	var direction: Vector2 = start.direction_to(center)
	var distance: float = start.distance_to(center)
	if distance <= 1.0:
		return
	var side: Vector2 = direction.orthogonal()
	var dot_count := clampi(int(distance / 42.0), 2, 7)
	for step in range(dot_count):
		var t := float(step + 1) / float(dot_count + 1)
		var trail_pos: Vector2 = start.lerp(center, t) + side * sin(age * 7.2 + float(step)) * 4.0
		var step_alpha := (0.2 + t * 0.38) * fade
		draw_circle(trail_pos + Vector2(3.0, 4.0), 7.0 + pulse * 1.5, Color(0.035, 0.016, 0.007, 0.24 * fade))
		draw_circle(trail_pos, 5.0 + pulse * 2.0, Color(1.0, 0.78, 0.24, step_alpha))
		draw_arc(trail_pos, 11.0 + pulse * 3.0, 0.0, TAU, 18, Color(1.0, 0.86, 0.36, step_alpha * 0.55), 2.0)
	var arrow_center: Vector2 = start.lerp(center, 0.76)
	var arrow_tip: Vector2 = arrow_center + direction * 22.0
	var arrow_back: Vector2 = arrow_center - direction * 12.0
	var arrow_color := Color(1.0, 0.82, 0.26, 0.28 + fade * 0.46)
	draw_line(arrow_back + Vector2(3.0, 4.0), arrow_tip + Vector2(3.0, 4.0), Color(0.035, 0.016, 0.007, 0.22 + fade * 0.2), 7.0)
	draw_line(arrow_back, arrow_tip, arrow_color, 5.0)
	draw_line(arrow_tip, arrow_tip - direction * 17.0 + side * 12.0, arrow_color, 5.0)
	draw_line(arrow_tip, arrow_tip - direction * 17.0 - side * 12.0, arrow_color, 5.0)

func _draw_payday_pickup_pointer(center: Vector2, pickup: Dictionary, pulse: float) -> void:
	var age: float = float(pickup.get("age", 0.0))
	var pointer_life := maxf(0.01, float(pickup.get("pointer_life", 1.0)))
	var fade := clampf(1.0 - age / pointer_life, 0.0, 1.0)
	var lift := 78.0 + sin(age * 7.0) * 6.0
	var arrow_tip := center + Vector2(0.0, -50.0 - pulse * 7.0)
	var arrow_base := center + Vector2(0.0, -lift)
	var arrow_color := Color(1.0, 0.8, 0.24, 0.24 + fade * 0.54)
	var shadow_color := Color(0.045, 0.02, 0.008, 0.22 + fade * 0.28)
	draw_line(arrow_base + Vector2(3.0, 4.0), arrow_tip + Vector2(3.0, 4.0), shadow_color, 8.0)
	draw_line(arrow_base, arrow_tip, arrow_color, 6.0)
	draw_colored_polygon([
		arrow_tip,
		arrow_tip + Vector2(-15.0, -23.0),
		arrow_tip + Vector2(15.0, -23.0),
	], Color(1.0, 0.86, 0.32, 0.28 + fade * 0.58))
	var font := ThemeDB.fallback_font
	var label_origin := center + Vector2(-72.0, -106.0 - pulse * 5.0)
	draw_string(font, label_origin + Vector2(3.0, 3.0), "SCOOP", HORIZONTAL_ALIGNMENT_CENTER, 144.0, 24, shadow_color)
	draw_string(font, label_origin, "SCOOP", HORIZONTAL_ALIGNMENT_CENTER, 144.0, 24, Color(1.0, 0.86, 0.36, 0.36 + fade * 0.62))

func _draw_payday_optional_label(center: Vector2, pickup: Dictionary, pulse: float) -> void:
	var age: float = float(pickup.get("age", 0.0))
	var label_life := maxf(0.01, float(pickup.get("optional_label_life", 1.0)))
	var fade := clampf(1.0 - age / label_life, 0.0, 1.0)
	var font := ThemeDB.fallback_font
	var label_center := center + Vector2(0.0, 58.0 + pulse * 3.0)
	var label_rect := Rect2(label_center + Vector2(-86.0, -11.0), Vector2(172.0, 42.0))
	draw_rect(label_rect.grow(3.0), Color(0.04, 0.018, 0.008, 0.24 * fade), true)
	draw_rect(label_rect, Color(0.2, 0.09, 0.035, 0.68 * fade), true)
	draw_rect(label_rect, Color(0.98, 0.76, 0.28, 0.58 * fade), false, 2.0)
	draw_string(font, label_rect.position + Vector2(0.0, 18.0), "OPTIONAL", HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 18, Color(1.0, 0.84, 0.38, 0.9 * fade))
	draw_string(font, label_rect.position + Vector2(0.0, 36.0), "+CREDITS +ROUNDS", HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 15, Color(0.96, 0.86, 0.58, 0.82 * fade))

func _draw_level_modifier_effects(arena: Rect2) -> void:
	var modifier := _get_level_modifier(current_wave)
	var modifier_id := str(modifier.get("id", ""))
	if modifier_id == "open":
		_draw_open_courtyard_effects(arena)
	elif modifier_id == "crossfire":
		_draw_saloon_crossfire_effects(arena)
	elif modifier_id == "duel":
		_draw_black_sash_duel_effects(arena)
	elif modifier_id == "rush":
		_draw_rail_yard_rush_effects(arena)
	elif modifier_id == "bells":
		_draw_chapel_bell_effects(arena)
	elif modifier_id == "mercy":
		_draw_mercy_fastdraw_effects(arena)
	elif modifier_id == "sandstorm":
		_draw_red_canyon_sandstorm_effects(arena)
	elif modifier_id == "gold_rush":
		_draw_bank_vault_effects(arena)
	elif modifier_id == "blackglass":
		_draw_blackglass_effects(arena)
	elif modifier_id == "last_stand":
		_draw_last_high_noon_effects(arena)

func _draw_red_canyon_sandstorm_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 2.2) * 0.5
	draw_rect(arena, Color(0.78, 0.55, 0.26, 0.08), true)
	_draw_red_canyon_route_pockets(arena, pulse)
	for i in range(14):
		var y := arena.position.y + 80.0 + float(i) * 92.0 + sin(_hazard_anim_time * 1.6 + float(i)) * 18.0
		var start := Vector2(arena.position.x + 40.0, y)
		var end := Vector2(arena.end.x - 40.0, y - 120.0)
		draw_line(start, end, Color(0.96, 0.74, 0.38, 0.14), 9.0)
		draw_line(start + Vector2(0.0, 14.0), end + Vector2(0.0, 14.0), Color(0.32, 0.18, 0.08, 0.1), 4.0)

func _get_red_canyon_route_pocket_rects(arena: Rect2) -> Array:
	var pocket_width := clampf(arena.size.x * 0.18, 150.0, 230.0)
	var pocket_height := arena.size.y - 170.0
	var pocket_y := arena.position.y + 86.0
	var left_center_x := arena.position.x + arena.size.x * 0.33
	var right_center_x := arena.position.x + arena.size.x * 0.67
	return [
		Rect2(Vector2(left_center_x - pocket_width * 0.5, pocket_y), Vector2(pocket_width, pocket_height)),
		Rect2(Vector2(right_center_x - pocket_width * 0.5, pocket_y), Vector2(pocket_width, pocket_height)),
	]

func _draw_red_canyon_route_pockets(arena: Rect2, pulse: float) -> void:
	var canyon_shadow := Color(0.15, 0.055, 0.025, 0.16 + pulse * 0.04)
	draw_rect(Rect2(Vector2(arena.position.x + 36.0, arena.position.y + 64.0), Vector2(arena.size.x * 0.18, arena.size.y - 128.0)), canyon_shadow, true)
	draw_rect(Rect2(Vector2(arena.end.x - arena.size.x * 0.18 - 36.0, arena.position.y + 64.0), Vector2(arena.size.x * 0.18, arena.size.y - 128.0)), canyon_shadow, true)
	for pocket in _get_red_canyon_route_pocket_rects(arena):
		draw_rect(pocket.grow(16.0), Color(0.12, 0.055, 0.025, 0.12), true)
		draw_rect(pocket, Color(0.78, 0.56, 0.3, 0.1 + pulse * 0.04), true)
		draw_rect(pocket.grow(-10.0), Color(0.96, 0.78, 0.42, 0.07 + pulse * 0.035), true)
		draw_rect(pocket, Color(1.0, 0.78, 0.28, 0.2 + pulse * 0.08), false, 3.0)
		for mark in range(5):
			var t := float(mark) / 4.0
			var y := lerpf(pocket.position.y + 42.0, pocket.end.y - 42.0, t)
			var center := Vector2(pocket.get_center().x, y + sin(_hazard_anim_time * 1.7 + float(mark)) * 5.0)
			var chevron_size := 15.0 + pulse * 3.0
			draw_line(center + Vector2(-chevron_size, -8.0), center, Color(1.0, 0.78, 0.24, 0.38 + pulse * 0.18), 3.0)
			draw_line(center, center + Vector2(chevron_size, -8.0), Color(1.0, 0.78, 0.24, 0.38 + pulse * 0.18), 3.0)
			draw_line(center + Vector2(-chevron_size, 7.0), center + Vector2(0.0, 15.0), Color(0.21, 0.09, 0.035, 0.18), 2.0)
			draw_line(center + Vector2(0.0, 15.0), center + Vector2(chevron_size, 7.0), Color(0.21, 0.09, 0.035, 0.18), 2.0)

func _draw_open_courtyard_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 2.0) * 0.5
	draw_rect(arena, Color(0.92, 0.66, 0.34, 0.035 + pulse * 0.025), true)
	for i in range(9):
		var lane_t := float(i) / 8.0
		var sweep := fposmod(_hazard_anim_time * (42.0 + float(i % 3) * 9.0) + float(i) * 137.0, arena.size.x + 260.0) - 130.0
		var y := arena.position.y + arena.size.y * (0.12 + lane_t * 0.78) + sin(_hazard_anim_time * 1.25 + float(i)) * 14.0
		var start := Vector2(arena.position.x + sweep - 86.0, y)
		var end := start + Vector2(210.0, -50.0)
		var alpha := 0.055 + pulse * 0.035
		draw_line(start + Vector2(0.0, 13.0), end + Vector2(0.0, 13.0), Color(0.16, 0.075, 0.028, 0.07), 5.0)
		draw_line(start, end, Color(1.0, 0.82, 0.44, alpha), 9.0)
		draw_circle(end, 4.0 + pulse * 2.0, Color(1.0, 0.86, 0.5, alpha * 1.8))
	for i in range(7):
		var t := float(i) / 6.0
		var pos := Vector2(lerpf(arena.position.x + 120.0, arena.end.x - 120.0, t), arena.position.y + 46.0 + sin(_hazard_anim_time * 1.4 + float(i)) * 5.0)
		draw_line(pos + Vector2(-18.0, 0.0), pos + Vector2(18.0, 0.0), Color(0.98, 0.74, 0.36, 0.12 + pulse * 0.08), 3.0)
		draw_circle(pos, 4.0 + pulse * 1.5, Color(1.0, 0.82, 0.38, 0.12 + pulse * 0.09))

func _draw_saloon_crossfire_effects(arena: Rect2) -> void:
	var sweep := 0.5 + sin(_hazard_anim_time * 3.2) * 0.5
	draw_rect(arena, Color(0.38, 0.17, 0.055, 0.045 + sweep * 0.025), true)
	for i in range(6):
		var y := arena.position.y + arena.size.y * (0.18 + float(i) * 0.13)
		var offset := sin(_hazard_anim_time * 2.6 + float(i) * 1.3) * 78.0
		var left_start := Vector2(arena.position.x + 54.0, y + offset * 0.1)
		var left_end := Vector2(arena.end.x - 80.0, y + 82.0 - offset * 0.14)
		var right_start := Vector2(arena.end.x - 54.0, y - offset * 0.1)
		var right_end := Vector2(arena.position.x + 80.0, y + 82.0 + offset * 0.14)
		var alpha := 0.075 + sweep * 0.075
		draw_line(left_start + Vector2(0.0, 12.0), left_end + Vector2(0.0, 12.0), Color(0.08, 0.03, 0.012, 0.12), 5.0)
		draw_line(right_start + Vector2(0.0, 12.0), right_end + Vector2(0.0, 12.0), Color(0.08, 0.03, 0.012, 0.12), 5.0)
		draw_line(left_start, left_end, Color(1.0, 0.64, 0.22, alpha), 6.0)
		draw_line(right_start, right_end, Color(1.0, 0.72, 0.28, alpha * 0.82), 5.0)
	for i in range(5):
		var t := float(i) / 4.0
		var window_left := Vector2(arena.position.x - 34.0, lerpf(arena.position.y + 110.0, arena.end.y - 110.0, t))
		var window_right := Vector2(arena.end.x + 34.0, window_left.y + 18.0)
		var glint := 0.45 + sin(_hazard_anim_time * 4.0 + float(i)) * 0.35
		draw_rect(Rect2(window_left + Vector2(-5.0, -18.0), Vector2(10.0, 36.0)), Color(1.0, 0.74, 0.28, 0.13 + glint * 0.12), true)
		draw_rect(Rect2(window_right + Vector2(-5.0, -18.0), Vector2(10.0, 36.0)), Color(1.0, 0.66, 0.24, 0.1 + glint * 0.1), true)

func _draw_black_sash_duel_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 4.4) * 0.5
	var center := arena.get_center()
	var duel_ground_center := _get_black_sash_duel_ground_origin(arena)
	var tell_strength := _get_black_sash_attack_tell_strength()
	draw_rect(arena, Color(0.2, 0.055, 0.028, 0.035 + pulse * 0.018), true)
	draw_circle(center + Vector2(10.0, 18.0), 178.0, Color(0.035, 0.014, 0.008, 0.2))
	draw_arc(center, 166.0 + pulse * 8.0, -0.28, TAU - 0.28, 72, Color(0.08, 0.025, 0.015, 0.42), 10.0)
	draw_arc(center, 150.0, -0.3, PI + 0.46, 58, Color(0.6, 0.08, 0.035, 0.2 + pulse * 0.08), 5.0)
	draw_arc(center, 118.0, PI + 0.22, TAU - 0.18, 48, Color(0.94, 0.58, 0.18, 0.12 + pulse * 0.07), 3.0)
	if tell_strength > 0.05:
		_draw_black_sash_duel_ground_prompt(duel_ground_center, tell_strength, pulse)
	var sash_direction := Vector2(1.0, 0.28).normalized()
	var sash_side := sash_direction.orthogonal()
	var start := center - sash_direction * 228.0
	var finish := center + sash_direction * 228.0
	draw_line(start + Vector2(11.0, 17.0), finish + Vector2(11.0, 17.0), Color(0.022, 0.01, 0.006, 0.3), 42.0)
	draw_line(start, finish, Color(0.045, 0.012, 0.008, 0.78), 35.0)
	draw_line(start + sash_side * 7.0, finish + sash_side * 7.0, Color(0.5, 0.055, 0.026, 0.48 + pulse * 0.12), 12.0)
	draw_line(start - sash_side * 9.0, finish - sash_side * 9.0, Color(0.12, 0.026, 0.015, 0.68), 9.0)
	for stitch in range(9):
		var t := float(stitch) / 8.0
		var point := start.lerp(finish, t)
		draw_line(point - sash_side * 22.0, point - sash_side * 9.0, Color(0.86, 0.52, 0.18, 0.34 + pulse * 0.08), 2.5)
		draw_line(point + sash_side * 10.0, point + sash_side * 23.0, Color(0.9, 0.62, 0.24, 0.3 + pulse * 0.08), 2.0)
	for i in range(10):
		var angle := TAU * float(i) / 10.0 + 0.18
		var spur := center + Vector2(cos(angle) * 154.0, sin(angle) * 118.0)
		draw_circle(spur + Vector2(4.0, 6.0), 8.0, Color(0.025, 0.012, 0.006, 0.22))
		draw_circle(spur, 4.5 + pulse * 1.2, Color(0.9, 0.56, 0.18, 0.28 + pulse * 0.15))
		draw_line(spur - Vector2(cos(angle), sin(angle)) * 13.0, spur + Vector2(cos(angle), sin(angle)) * 13.0, Color(0.92, 0.66, 0.28, 0.16 + pulse * 0.08), 2.0)
	draw_line(center + Vector2(-82.0, -46.0), center + Vector2(88.0, 50.0), Color(0.98, 0.84, 0.52, 0.18), 3.0)
	draw_line(center + Vector2(-78.0, 48.0), center + Vector2(70.0, -52.0), Color(0.04, 0.018, 0.01, 0.32), 5.0)

func _draw_black_sash_duel_ground_prompt(center: Vector2, tell_strength: float, pulse: float) -> void:
	var strength := clampf(tell_strength, 0.0, 1.0)
	var ring_alpha := 0.32 + strength * 0.54 + pulse * 0.12
	var brass := Color(1.0, 0.76, 0.25, ring_alpha)
	var bone := Color(1.0, 0.92, 0.58, 0.3 + strength * 0.36)
	var shadow := Color(0.05, 0.018, 0.008, 0.28 + strength * 0.18)
	var outer_radius := 168.0 + pulse * 8.0 + strength * 18.0
	var inner_radius := 122.0 + pulse * 6.0
	draw_circle(center, 68.0 + strength * 10.0, Color(1.0, 0.66, 0.2, 0.045 + strength * 0.08))
	draw_arc(center + Vector2(9.0, 14.0), outer_radius, -0.24, TAU - 0.24, 84, shadow, 14.0)
	draw_arc(center, outer_radius, -0.24, TAU - 0.24, 84, brass, 10.0 + strength * 4.0)
	draw_arc(center, inner_radius, 0.18, PI + 0.64, 52, bone, 5.0 + strength * 2.0)
	for pip in range(12):
		var pip_angle := TAU * float(pip) / 12.0 + 0.06
		var pip_direction := Vector2(cos(pip_angle), sin(pip_angle))
		draw_circle(center + pip_direction * (outer_radius - 8.0), 4.5 + strength * 2.5, Color(1.0, 0.82, 0.32, 0.42 + strength * 0.32))
	for i in range(8):
		var angle := TAU * float(i) / 8.0 + 0.18
		var direction := Vector2(cos(angle), sin(angle))
		var side := direction.orthogonal()
		var point := center + direction * (110.0 + strength * 8.0)
		var tip := point - direction * (18.0 + strength * 10.0)
		var wing := 13.0 + strength * 5.0
		draw_line(point + side * wing, tip, shadow, 6.0)
		draw_line(point - side * wing, tip, shadow, 6.0)
		draw_line(point + side * wing, tip, brass, 3.0)
		draw_line(point - side * wing, tip, brass, 3.0)

func _draw_rail_yard_rush_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 4.2) * 0.5
	draw_rect(arena, Color(0.31, 0.17, 0.07, 0.045 + pulse * 0.02), true)
	for lane in range(3):
		var lane_y := arena.position.y + arena.size.y * (0.26 + float(lane) * 0.24)
		var rail_start := Vector2(arena.position.x + 76.0, lane_y)
		var rail_end := Vector2(arena.end.x - 76.0, lane_y - 58.0)
		var direction := rail_start.direction_to(rail_end)
		var side := direction.orthogonal()
		draw_line(rail_start + side * 16.0, rail_end + side * 16.0, Color(0.07, 0.03, 0.014, 0.44), 8.0)
		draw_line(rail_start - side * 16.0, rail_end - side * 16.0, Color(0.07, 0.03, 0.014, 0.44), 8.0)
		draw_line(rail_start + side * 16.0, rail_end + side * 16.0, Color(0.64, 0.38, 0.16, 0.42), 4.0)
		draw_line(rail_start - side * 16.0, rail_end - side * 16.0, Color(0.64, 0.38, 0.16, 0.42), 4.0)
		for tie in range(9):
			var t := float(tie) / 8.0
			var tie_center := rail_start.lerp(rail_end, t)
			draw_line(tie_center - side * 34.0, tie_center + side * 34.0, Color(0.17, 0.075, 0.028, 0.42), 6.0)
		var sweep := fposmod(_hazard_anim_time * (0.34 + float(lane) * 0.05), 1.0)
		var gust_center := rail_start.lerp(rail_end, sweep)
		var gust_alpha := 0.13 + pulse * 0.09
		draw_line(gust_center - direction * 96.0 + side * 38.0, gust_center + direction * 118.0 - side * 24.0, Color(1.0, 0.74, 0.3, gust_alpha), 12.0)
		draw_line(gust_center - direction * 96.0 + side * 50.0 + Vector2(0.0, 14.0), gust_center + direction * 118.0 - side * 12.0 + Vector2(0.0, 14.0), Color(0.08, 0.03, 0.012, 0.16), 4.0)
	var font := ThemeDB.fallback_font
	var label_color := Color(1.0, 0.74, 0.28, 0.2 + pulse * 0.18)
	draw_string(font, arena.get_center() + Vector2(-90.0, -arena.size.y * 0.36), "RAIL", HORIZONTAL_ALIGNMENT_CENTER, 180.0, 25, Color(0.06, 0.025, 0.01, 0.24))
	draw_string(font, arena.get_center() + Vector2(-92.0, -arena.size.y * 0.36 - 2.0), "RAIL", HORIZONTAL_ALIGNMENT_CENTER, 180.0, 25, label_color)

func _draw_chapel_bell_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 5.4) * 0.5
	draw_rect(arena, Color(0.24, 0.12, 0.055, 0.08 + pulse * 0.04), true)
	_draw_chapel_brute_lane_cues(arena, pulse)
	for i in range(4):
		var side := -1.0 if i < 2 else 1.0
		var row := float(i % 2)
		var x := arena.get_center().x + side * (arena.size.x * 0.38 + row * 40.0)
		var y := arena.position.y + arena.size.y * (0.28 + row * 0.34)
		var bell := Vector2(x, y)
		draw_circle(bell + Vector2(8.0, 14.0), 30.0, Color(0.03, 0.014, 0.007, 0.22))
		draw_arc(bell, 36.0 + pulse * 18.0, 0.0, TAU, 42, Color(0.92, 0.58, 0.22, 0.16 + pulse * 0.14), 4.0)
		draw_line(bell + Vector2(-16.0, -28.0), bell + Vector2(16.0, -28.0), Color(0.18, 0.075, 0.03, 0.88), 5.0)
		draw_rect(Rect2(bell + Vector2(-13.0, -28.0), Vector2(26.0, 30.0)), Color(0.48, 0.25, 0.1, 0.82), true)
		draw_arc(bell + Vector2(0.0, 1.0), 17.0, PI, TAU, 18, Color(0.9, 0.58, 0.24, 0.72), 5.0)
		draw_circle(bell + Vector2(0.0, 11.0), 5.0, Color(0.95, 0.72, 0.32, 0.78))
	for i in range(10):
		var t := float(i) / 9.0
		var x := lerpf(arena.position.x + 110.0, arena.end.x - 110.0, t)
		var y := arena.position.y + 44.0 + sin(_hazard_anim_time * 1.5 + float(i)) * 5.0
		_draw_crowd_silhouette(Vector2(x, y), 0.72 + float(i % 3) * 0.08)

func _draw_chapel_brute_lane_cues(arena: Rect2, pulse: float) -> void:
	var center := arena.get_center()
	var lane_width := 88.0
	var vertical_lane := Rect2(
		Vector2(center.x - lane_width * 0.5, arena.position.y + 120.0),
		Vector2(lane_width, arena.size.y - 240.0)
	)
	var horizontal_lane := Rect2(
		Vector2(arena.position.x + 210.0, center.y - lane_width * 0.5),
		Vector2(arena.size.x - 420.0, lane_width)
	)
	var lanes := [vertical_lane, horizontal_lane]
	for lane: Rect2 in lanes:
		draw_rect(lane, Color(0.055, 0.023, 0.012, 0.2 + pulse * 0.05), true)
		draw_rect(lane, Color(0.86, 0.48, 0.16, 0.1 + pulse * 0.08), false, 4.0)
		draw_rect(lane.grow(-12.0), Color(0.95, 0.64, 0.24, 0.06 + pulse * 0.06), false, 2.0)
	for i in range(9):
		var t := float(i) / 8.0
		var y := lerpf(vertical_lane.position.y + 28.0, vertical_lane.end.y - 28.0, t)
		var offset := sin(_hazard_anim_time * 3.4 + float(i) * 0.8) * 6.0
		var x := center.x + offset
		_draw_chapel_lane_chevron(Vector2(x, y), Vector2(0.0, 1.0), pulse)
	for i in range(8):
		var t := float(i) / 7.0
		var x := lerpf(horizontal_lane.position.x + 32.0, horizontal_lane.end.x - 32.0, t)
		var offset := cos(_hazard_anim_time * 3.2 + float(i) * 0.7) * 6.0
		var y := center.y + offset
		_draw_chapel_lane_chevron(Vector2(x, y), Vector2(1.0, 0.0), pulse)

func _draw_chapel_lane_chevron(position: Vector2, direction: Vector2, pulse: float) -> void:
	var side := Vector2(-direction.y, direction.x)
	var tip := position + direction * 15.0
	var left := position - direction * 10.0 + side * 12.0
	var right := position - direction * 10.0 - side * 12.0
	var shadow := Vector2(3.0, 4.0)
	draw_line(left + shadow, tip + shadow, Color(0.025, 0.012, 0.006, 0.35), 5.0)
	draw_line(right + shadow, tip + shadow, Color(0.025, 0.012, 0.006, 0.35), 5.0)
	draw_line(left, tip, Color(1.0, 0.67, 0.22, 0.24 + pulse * 0.18), 4.0)
	draw_line(right, tip, Color(1.0, 0.67, 0.22, 0.24 + pulse * 0.18), 4.0)

func _draw_mercy_fastdraw_effects(arena: Rect2) -> void:
	var sweep := 0.5 + sin(_hazard_anim_time * 4.8) * 0.5
	draw_rect(arena, Color(0.58, 0.23, 0.08, 0.06), true)
	for i in range(5):
		var y := arena.position.y + arena.size.y * (0.16 + float(i) * 0.17)
		var offset := sin(_hazard_anim_time * 2.8 + float(i) * 1.7) * 90.0
		var start := Vector2(arena.position.x + 74.0, y + offset * 0.12)
		var end := Vector2(arena.end.x - 74.0, y - 80.0 + offset * 0.12)
		draw_line(start, end, Color(1.0, 0.72, 0.24, 0.12 + sweep * 0.1), 7.0)
		draw_line(start + Vector2(0.0, 14.0), end + Vector2(0.0, 14.0), Color(0.09, 0.035, 0.015, 0.1), 3.0)
	var center := arena.get_center()
	draw_arc(center, minf(arena.size.x, arena.size.y) * 0.32 + sweep * 18.0, -0.2, PI + 0.2, 54, Color(0.95, 0.58, 0.18, 0.2), 5.0)
	for i in range(12):
		var angle := TAU * float(i) / 12.0 + _hazard_anim_time * 0.12
		var pos := center + Vector2(cos(angle) * arena.size.x * 0.43, sin(angle) * arena.size.y * 0.43)
		_draw_crowd_silhouette(pos, 0.64)

func _draw_crowd_silhouette(position: Vector2, scale: float) -> void:
	draw_circle(position + Vector2(0.0, -13.0) * scale, 8.0 * scale, Color(0.035, 0.018, 0.011, 0.72))
	draw_rect(Rect2(position + Vector2(-7.0, -5.0) * scale, Vector2(14.0, 24.0) * scale), Color(0.035, 0.018, 0.011, 0.68), true)
	draw_line(position + Vector2(-18.0, 0.0) * scale, position + Vector2(18.0, 0.0) * scale, Color(0.035, 0.018, 0.011, 0.52), 3.0 * scale)

func _draw_bank_vault_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 4.8) * 0.5
	var center := arena.get_center()
	draw_rect(arena, Color(0.36, 0.19, 0.055, 0.07 + pulse * 0.025), true)
	draw_circle(center, 150.0 + pulse * 10.0, Color(0.04, 0.025, 0.015, 0.28))
	draw_circle(center, 118.0, Color(0.16, 0.09, 0.04, 0.76))
	draw_arc(center, 118.0, 0.0, TAU, 72, Color(0.92, 0.62, 0.2, 0.68), 8.0)
	draw_arc(center, 72.0, 0.0, TAU, 58, Color(0.9, 0.5, 0.16, 0.42), 5.0)
	for i in range(12):
		var angle := TAU * float(i) / 12.0 + _hazard_anim_time * 0.18
		var spoke := Vector2(cos(angle), sin(angle))
		draw_line(center + spoke * 28.0, center + spoke * 96.0, Color(0.86, 0.5, 0.16, 0.5), 3.0)
	for i in range(22):
		var x := arena.position.x + float((i * 197) % int(arena.size.x - 180.0)) + 90.0
		var y := arena.position.y + float((i * 109) % int(arena.size.y - 180.0)) + 90.0
		var sparkle := 0.45 + sin(_hazard_anim_time * 5.0 + float(i)) * 0.35
		draw_circle(Vector2(x, y), 3.5 + sparkle * 1.8, Color(1.0, 0.78, 0.24, 0.18 + sparkle * 0.18))
		draw_line(Vector2(x - 8.0, y), Vector2(x + 8.0, y), Color(1.0, 0.88, 0.46, 0.16), 2.0)
		draw_line(Vector2(x, y - 8.0), Vector2(x, y + 8.0), Color(1.0, 0.88, 0.46, 0.16), 2.0)

func _draw_blackglass_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 5.6) * 0.5
	draw_rect(arena, Color(0.13, 0.035, 0.035, 0.09 + pulse * 0.025), true)
	_draw_blackglass_killbox_cue(arena, pulse)
	for i in range(5):
		var t := float(i) / 4.0
		var x := lerpf(arena.position.x + 130.0, arena.end.x - 130.0, t)
		var top := arena.position.y + 70.0
		var bottom := arena.end.y - 90.0
		draw_line(Vector2(x, top), Vector2(x + sin(_hazard_anim_time * 1.8 + float(i)) * 34.0, bottom), Color(0.92, 0.18, 0.16, 0.08 + pulse * 0.05), 9.0)
		draw_circle(Vector2(x, top + 20.0), 16.0 + pulse * 4.0, Color(0.98, 0.62, 0.26, 0.18 + pulse * 0.12))
	for i in range(14):
		var side := -1.0 if i % 2 == 0 else 1.0
		var y := arena.position.y + 90.0 + float(i / 2) * 82.0
		var x := arena.get_center().x + side * (arena.size.x * 0.45)
		_draw_crowd_silhouette(Vector2(x, y), 0.6)
	draw_rect(arena.grow(-52.0), Color(0.82, 0.16, 0.26, 0.14 + pulse * 0.08), false, 4.0)
	draw_rect(arena.grow(-94.0), Color(0.95, 0.72, 0.36, 0.08 + pulse * 0.05), false, 2.0)

func _draw_blackglass_killbox_cue(arena: Rect2, pulse: float) -> void:
	var center := arena.get_center()
	var inner := arena.grow(-132.0)
	var diamond := PackedVector2Array([
		center + Vector2(0.0, -inner.size.y * 0.34),
		center + Vector2(inner.size.x * 0.36, 0.0),
		center + Vector2(0.0, inner.size.y * 0.34),
		center + Vector2(-inner.size.x * 0.36, 0.0),
		center + Vector2(0.0, -inner.size.y * 0.34),
	])
	draw_polyline(diamond, Color(0.95, 0.62, 0.28, 0.14 + pulse * 0.09), 5.0)
	draw_polyline(diamond, Color(0.09, 0.018, 0.014, 0.2), 2.0)
	draw_line(center + Vector2(-inner.size.x * 0.42, 0.0), center + Vector2(inner.size.x * 0.42, 0.0), Color(0.9, 0.08, 0.13, 0.24 + pulse * 0.16), 12.0)
	draw_line(center + Vector2(0.0, -inner.size.y * 0.4), center + Vector2(0.0, inner.size.y * 0.4), Color(0.9, 0.08, 0.13, 0.22 + pulse * 0.15), 12.0)
	draw_line(center + Vector2(-inner.size.x * 0.44, 18.0), center + Vector2(inner.size.x * 0.44, 18.0), Color(0.07, 0.014, 0.012, 0.24), 5.0)
	draw_line(center + Vector2(18.0, -inner.size.y * 0.42), center + Vector2(18.0, inner.size.y * 0.42), Color(0.07, 0.014, 0.012, 0.22), 5.0)
	for i in range(4):
		var angle := TAU * float(i) / 4.0 + PI * 0.25
		var corner := center + Vector2(cos(angle) * inner.size.x * 0.45, sin(angle) * inner.size.y * 0.42)
		var toward_center := corner.direction_to(center)
		var side := toward_center.orthogonal()
		draw_line(corner, corner + toward_center * 58.0, Color(0.98, 0.72, 0.34, 0.3 + pulse * 0.18), 5.0)
		draw_line(corner, corner + side * 42.0, Color(0.98, 0.72, 0.34, 0.22 + pulse * 0.14), 4.0)
		draw_circle(corner, 7.0 + pulse * 2.5, Color(0.98, 0.62, 0.26, 0.2 + pulse * 0.16))
	for i in range(6):
		var t := float(i) / 5.0
		var y := lerpf(inner.position.y + 40.0, inner.end.y - 40.0, t)
		var slant := sin(_hazard_anim_time * 1.4 + float(i)) * 34.0
		draw_line(Vector2(inner.position.x + 32.0, y), Vector2(inner.end.x - 32.0, y + slant), Color(0.04, 0.012, 0.012, 0.24), 4.4)
		draw_line(Vector2(inner.position.x + 32.0, y - 9.0), Vector2(inner.end.x - 32.0, y + slant - 9.0), Color(0.92, 0.18, 0.2, 0.105 + pulse * 0.06), 3.0)

func _draw_last_high_noon_effects(arena: Rect2) -> void:
	var pulse := 0.5 + sin(_hazard_anim_time * 6.0) * 0.5
	var center := arena.get_center()
	draw_rect(arena, Color(0.92, 0.34, 0.035, 0.29 + pulse * 0.035), true)
	draw_rect(arena.grow(-14.0), Color(1.0, 0.58, 0.1, 0.11 + pulse * 0.045), false, 7.0)
	draw_circle(center, 122.0 + pulse * 22.0, Color(1.0, 0.58, 0.12, 0.18 + pulse * 0.1))
	draw_arc(center, 146.0 + pulse * 30.0, 0.0, TAU, 72, Color(1.0, 0.8, 0.34, 0.28 + pulse * 0.15), 8.0)
	for i in range(13):
		var angle := -1.16 + float(i) * 0.19 + sin(_hazard_anim_time * 0.7) * 0.05
		var start := center + Vector2(cos(angle), sin(angle)) * 48.0
		var end := center + Vector2(cos(angle), sin(angle)) * maxf(arena.size.x, arena.size.y)
		draw_line(start + Vector2(0.0, 14.0), end + Vector2(0.0, 14.0), Color(0.11, 0.032, 0.012, 0.18), 5.0)
		draw_line(start, end, Color(1.0, 0.66, 0.14, 0.22 + pulse * 0.1), 18.0)
		draw_line(start, end, Color(1.0, 0.86, 0.34, 0.13 + pulse * 0.08), 5.0)
	draw_arc(center, minf(arena.size.x, arena.size.y) * 0.4 + pulse * 26.0, 0.0, TAU, 72, Color(1.0, 0.52, 0.12, 0.3 + pulse * 0.16), 8.0)
	draw_rect(arena.grow(-28.0), Color(0.9, 0.13, 0.035, 0.23 + pulse * 0.1), false, 12.0)
	draw_rect(arena.grow(-76.0), Color(1.0, 0.64, 0.18, 0.17 + pulse * 0.1), false, 6.0)
	_draw_last_high_noon_extraction_cue(arena, pulse)

func _draw_last_high_noon_extraction_cue(arena: Rect2, pulse: float) -> void:
	var center := arena.get_center()
	var trail_start := center + Vector2(arena.size.x * 0.16, 0.0)
	var trail_end := Vector2(arena.end.x - 126.0, center.y)
	var exit_anchor := Vector2(arena.end.x - 70.0, center.y)
	var hold_lane := _get_last_high_noon_exit_lane_rect(arena)
	draw_rect(hold_lane.grow(14.0), Color(0.13, 0.043, 0.014, 0.22), true)
	draw_rect(hold_lane, Color(1.0, 0.62, 0.12, 0.16 + pulse * 0.07), true)
	draw_rect(hold_lane, Color(1.0, 0.86, 0.28, 0.34 + pulse * 0.15), false, 6.0)
	draw_rect(hold_lane.grow(-18.0), Color(1.0, 0.8, 0.22, 0.13 + pulse * 0.06), false, 3.0)
	draw_line(trail_start + Vector2(0.0, 20.0), trail_end + Vector2(0.0, 20.0), Color(0.12, 0.042, 0.014, 0.32), 13.0)
	draw_line(trail_start, trail_end, Color(1.0, 0.7, 0.16, 0.26 + pulse * 0.16), 9.0)
	draw_line(trail_start + Vector2(0.0, -16.0), trail_end + Vector2(0.0, -16.0), Color(1.0, 0.82, 0.28, 0.13 + pulse * 0.08), 4.0)
	for i in range(8):
		var marker_t := fposmod(_hazard_anim_time * 0.48 + float(i) * 0.19, 1.0)
		var marker := trail_start.lerp(trail_end, marker_t)
		var fade := 0.3 + pulse * 0.23
		draw_line(marker + Vector2(-34.0, -20.0), marker, Color(1.0, 0.86, 0.34, fade), 6.0)
		draw_line(marker + Vector2(-34.0, 20.0), marker, Color(1.0, 0.86, 0.34, fade), 6.0)
		draw_circle(marker, 5.0 + pulse * 2.5, Color(1.0, 0.74, 0.18, 0.25 + pulse * 0.16))
	draw_circle(exit_anchor, 46.0 + pulse * 8.0, Color(1.0, 0.62, 0.12, 0.28 + pulse * 0.15))
	draw_arc(exit_anchor, 62.0 + pulse * 11.0, -PI * 0.42, PI * 0.42, 28, Color(1.0, 0.88, 0.32, 0.46 + pulse * 0.2), 8.0)
	draw_line(exit_anchor + Vector2(-38.0, -46.0), exit_anchor + Vector2(26.0, 0.0), Color(1.0, 0.88, 0.32, 0.48 + pulse * 0.2), 7.0)
	draw_line(exit_anchor + Vector2(-38.0, 46.0), exit_anchor + Vector2(26.0, 0.0), Color(1.0, 0.88, 0.32, 0.48 + pulse * 0.2), 7.0)

func _get_last_high_noon_exit_lane_rect(arena: Rect2) -> Rect2:
	var center := arena.get_center()
	var lane_width := clampf(arena.size.x * 0.18, 220.0, 330.0)
	var lane_height := clampf(arena.size.y * 0.22, 150.0, 230.0)
	return Rect2(
		Vector2(arena.end.x - lane_width - 88.0, center.y - lane_height * 0.5),
		Vector2(lane_width, lane_height)
	)

func _generate_arena_hazards(wave: int = 1) -> void:
	arena_hazards.clear()
	var modifier := _get_level_modifier(wave)
	var hazard_count: int = int(modifier.get("hazards", 6))
	var arena: Rect2 = vault_data["arena"].grow(-260.0)
	var center := arena.get_center()
	var positions := [
		center + Vector2(-520.0, -240.0),
		center + Vector2(520.0, -220.0),
		center + Vector2(-430.0, 310.0),
		center + Vector2(450.0, 300.0),
		center + Vector2(0.0, -430.0),
		center + Vector2(0.0, 430.0),
		center + Vector2(-760.0, 0.0),
		center + Vector2(760.0, 0.0),
	]
	if str(modifier.get("id", "")) == "duel" or str(modifier.get("id", "")) == "blackglass":
		positions = [
			center + Vector2(-360.0, -260.0),
			center + Vector2(360.0, -260.0),
			center + Vector2(-360.0, 260.0),
			center + Vector2(360.0, 260.0),
			center + Vector2(0.0, -410.0),
			center + Vector2(0.0, 410.0),
			center + Vector2(-680.0, 0.0),
			center + Vector2(680.0, 0.0),
		]
	elif str(modifier.get("id", "")) == "gold_rush":
		positions = [
			center + Vector2(-470.0, -250.0),
			center + Vector2(-356.0, -206.0),
			center + Vector2(420.0, -270.0),
			center + Vector2(530.0, -222.0),
			center + Vector2(-420.0, 280.0),
			center + Vector2(-304.0, 324.0),
			center + Vector2(360.0, 255.0),
			center + Vector2(476.0, 302.0),
		]
	for i in range(mini(hazard_count, positions.size())):
		var position: Vector2 = positions[i].clamp(arena.position, arena.end)
		arena_hazards.append({
			"id": i,
			"origin": position,
			"radius": 120.0,
			"damage": 96.0,
			"fuse": 0.0,
			"fuse_max": 0.55,
			"spent": false,
			"visual_version": POWDER_KEG_VISUAL_VERSION,
			"silhouette_plate": true,
			"danger_band": true,
			"fuse_ticks": true,
		})

func _generate_arena_cover_props(wave: int = 1) -> void:
	arena_cover_props.clear()
	if vault_data.is_empty():
		return
	var modifier := _get_level_modifier(wave)
	if str(modifier.get("id", "")) != "crossfire":
		return
	var arena: Rect2 = vault_data["arena"].grow(-340.0)
	var center := arena.get_center()
	var positions := [
		center + Vector2(-270.0, 42.0),
		center + Vector2(285.0, 120.0),
	]
	for i in range(positions.size()):
		arena_cover_props.append({
			"id": i,
			"kind": "saloon_cover",
			"origin": (positions[i] as Vector2).clamp(arena.position, arena.end),
			"size": Vector2(214.0, 74.0),
			"angle": -0.18 if i == 0 else 0.16,
			"splintered": false,
			"visual_version": SALOON_COVER_VISUAL_VERSION,
			"edge_plate": true,
			"corner_brass": true,
			"splinter_shards": true,
		})

func _splinter_cover_props_hit_by_sword(origin: Vector2, direction: Vector2, slash_range: float, arc: float) -> bool:
	for i in range(arena_cover_props.size()):
		var cover: Dictionary = arena_cover_props[i]
		if bool(cover.get("splintered", false)):
			continue
		var cover_origin: Vector2 = cover["origin"]
		if _sword_sweep_hits_point(origin, direction, slash_range, arc, cover_origin, 72.0):
			_splinter_cover_prop(i, cover_origin, direction)
			return true
	return false

func _splinter_cover_props_hit_by_line(start: Vector2, end: Vector2, direction: Vector2) -> bool:
	for i in range(arena_cover_props.size()):
		var cover: Dictionary = arena_cover_props[i]
		if bool(cover.get("splintered", false)):
			continue
		var cover_origin: Vector2 = cover["origin"]
		if _distance_to_segment(cover_origin, start, end) <= 74.0:
			_splinter_cover_prop(i, cover_origin, direction)
			return true
	return false

func _splinter_cover_prop(index: int, hit_origin: Vector2, direction: Vector2) -> void:
	if index < 0 or index >= arena_cover_props.size():
		return
	var cover: Dictionary = arena_cover_props[index]
	if bool(cover.get("splintered", false)):
		return
	cover["splintered"] = true
	arena_cover_props[index] = cover
	_cover_splinter_total_count += 1
	_award_style_points(55, "SPLINTER")
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	if vfx_layer != null:
		vfx_layer.burst(hit_origin, Color(0.86, 0.49, 0.16), 8)
		vfx_layer.impact_flash(hit_origin + direction * 18.0, Color(0.96, 0.64, 0.24), "SPLINTER", 92.0)
	_play_audio_cue("slash", 0.38)
	queue_redraw()

func _update_arena_hazards(delta: float) -> void:
	if arena_hazards.is_empty():
		return
	_hazard_anim_time += delta
	var needs_redraw := false
	var modifier_id := str(_get_level_modifier(current_wave).get("id", ""))
	var modifier_animates := _smoke_modifier_has_animated_overlay(modifier_id)
	if modifier_animates:
		needs_redraw = true
	for i in range(arena_hazards.size()):
		var hazard: Dictionary = arena_hazards[i]
		if bool(hazard.get("spent", false)):
			continue
		var fuse: float = float(hazard.get("fuse", 0.0))
		if fuse > 0.0:
			fuse = maxf(0.0, fuse - delta)
			hazard["fuse"] = fuse
			arena_hazards[i] = hazard
			needs_redraw = true
			if fuse <= 0.0:
				_explode_arena_hazard(i)
				needs_redraw = true
	if needs_redraw:
		_request_dynamic_arena_overlay_redraw()
		if modifier_animates:
			_request_arena_visual_redraw()

func _update_payday_pickups(delta: float) -> void:
	if payday_pickups.is_empty():
		return
	var needs_redraw := false
	for i in range(payday_pickups.size()):
		var pickup: Dictionary = payday_pickups[i]
		if bool(pickup.get("collected", false)):
			continue
		pickup["age"] = float(pickup.get("age", 0.0)) + delta
		payday_pickups[i] = pickup
		needs_redraw = true
		if player != null and player.global_position.distance_to(pickup["origin"]) <= float(pickup.get("radius", 54.0)):
			_collect_payday_pickup(i)
	if needs_redraw:
		_request_payday_visual_redraw()

func _pending_payday_count() -> int:
	var count := 0
	for pickup in payday_pickups:
		if not bool(pickup.get("collected", false)):
			count += 1
	return count

func _spawn_payday_pickup(wave: int, credit_bonus: int, ammo_refill: int) -> void:
	if player == null or vault_data.is_empty():
		return
	var arena: Rect2 = vault_data["arena"].grow(-90.0)
	var offset := Vector2(118.0 + float((wave * 17) % 42), -54.0 + float((wave * 31) % 94))
	var origin: Vector2 = (player.global_position + offset).clamp(arena.position, arena.end)
	payday_pickups.append({
		"origin": origin,
		"credits": credit_bonus,
		"ammo": ammo_refill,
		"wave": wave,
		"age": 0.0,
		"radius": 58.0,
		"first_drop": wave == 1,
		"optional_label_life": 2.6,
		"pointer_life": 3.75,
		"route_life": 2.8,
		"route_min_distance": 48.0,
		"visual_version": PAYDAY_PICKUP_VISUAL_VERSION,
		"redraw_budget_version": PAYDAY_PICKUP_REDRAW_BUDGET_VERSION,
		"redraw_interval": PAYDAY_PICKUP_REDRAW_INTERVAL,
		"coin_spill": true,
		"ammo_spill": true,
		"brass_stamp": true,
		"leather_grain": true,
		"coin_silhouette": true,
		"ammo_silhouette": true,
		"collection_sparkle": true,
		"collected": false,
	})
	if vfx_layer != null:
		vfx_layer.burst(origin, Color(1.0, 0.74, 0.24), 14)
	_request_payday_visual_redraw(true)

func _collect_payday_pickup(index: int) -> void:
	if index < 0 or index >= payday_pickups.size():
		return
	var pickup: Dictionary = payday_pickups[index]
	if bool(pickup.get("collected", false)):
		return
	pickup["collected"] = true
	payday_pickups[index] = pickup
	var credit_bonus: int = int(pickup.get("credits", 0))
	var ammo_refill: int = int(pickup.get("ammo", 0))
	wave_clear_bonus_credits += credit_bonus
	program_system.refill_ammo(ammo_refill)
	director.add_heat(-0.18)
	_award_style_points(120 + int(pickup.get("wave", 1)) * 25, "PAYDAY")
	hud.show_style_pop("PAYDAY +%d CREDITS\n+%d ROUNDS" % [credit_bonus, ammo_refill], _get_style_rank(), combo_count)
	if hud.has_method("show_payday_collected_feedback"):
		hud.show_payday_collected_feedback(credit_bonus, ammo_refill)
	if vfx_layer != null:
		var origin: Vector2 = pickup["origin"]
		vfx_layer.shockwave(origin, Color(1.0, 0.74, 0.24))
		vfx_layer.burst(origin, Color(0.96, 0.72, 0.22), 20)
		vfx_layer.impact_flash(origin + Vector2(0.0, -22.0), Color(1.0, 0.78, 0.28), "BANKED", 86.0)
	_play_audio_cue("reward", 0.9)
	_request_payday_visual_redraw(true)

func _ignite_arena_hazard(index: int) -> void:
	if index < 0 or index >= arena_hazards.size():
		return
	var hazard: Dictionary = arena_hazards[index]
	if bool(hazard.get("spent", false)) or float(hazard.get("fuse", 0.0)) > 0.0:
		return
	hazard["fuse"] = float(hazard.get("fuse_max", 0.55))
	arena_hazards[index] = hazard
	if vfx_layer != null:
		vfx_layer.burst(hazard["origin"], Color(1.0, 0.58, 0.16), 10)
	_request_dynamic_arena_overlay_redraw(true)

func _explode_arena_hazard(index: int) -> void:
	if index < 0 or index >= arena_hazards.size():
		return
	var hazard: Dictionary = arena_hazards[index]
	if bool(hazard.get("spent", false)):
		return
	hazard["spent"] = true
	arena_hazards[index] = hazard
	var origin: Vector2 = hazard["origin"]
	var radius: float = float(hazard.get("radius", 120.0))
	var damage: float = float(hazard.get("damage", 96.0))
	if vfx_layer != null:
		vfx_layer.shockwave(origin, Color(1.0, 0.48, 0.12))
		vfx_layer.burst(origin, Color(0.86, 0.28, 0.08), 30)
		vfx_layer.impact_flash(origin, Color(1.0, 0.52, 0.14), "BOOM", radius * 1.5)
	_trigger_impact_freeze(0.055, 12.0, 0.15)
	_play_audio_cue("explosion", 1.2)
	var enemies_hit := 0
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(origin) <= radius:
			enemies_hit += 1
			enemy.take_damage(damage)
			hud.flash_hit()
	if enemies_hit > 0:
		keg_chain_bonus += enemies_hit
		_award_style_points(95 + enemies_hit * 35, "POWDER KEG")
		_play_mastery_payoff(origin, "POWDER KEG", Color(1.0, 0.66, 0.2), 2.2, 0.06)
	if player != null and player.global_position.distance_to(origin) <= radius * 0.72:
		player.take_damage(1.0)
	director.add_heat(0.12)
	for i in range(arena_hazards.size()):
		if i != index:
			var other: Dictionary = arena_hazards[i]
			if not bool(other.get("spent", false)) and float(other.get("fuse", 0.0)) <= 0.0:
				var other_origin: Vector2 = other["origin"]
				if other_origin.distance_to(origin) <= radius * 1.1:
					_ignite_arena_hazard(i)
	_request_dynamic_arena_overlay_redraw(true)

func _ignite_hazards_hit_by_sword(origin: Vector2, direction: Vector2, slash_range: float, arc: float) -> bool:
	var ignited := false
	for i in range(arena_hazards.size()):
		var hazard: Dictionary = arena_hazards[i]
		if bool(hazard.get("spent", false)):
			continue
		var hazard_origin: Vector2 = hazard["origin"]
		if _sword_sweep_hits_point(origin, direction, slash_range, arc, hazard_origin, 34.0):
			_ignite_arena_hazard(i)
			ignited = true
	return ignited

func _ignite_hazards_in_radius(origin: Vector2, radius: float) -> void:
	for i in range(arena_hazards.size()):
		var hazard: Dictionary = arena_hazards[i]
		if bool(hazard.get("spent", false)):
			continue
		var hazard_origin: Vector2 = hazard["origin"]
		if hazard_origin.distance_to(origin) <= radius:
			_ignite_arena_hazard(i)

func _get_vault_bounds() -> Rect2:
	return vault_data["arena"]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_F3:
		_set_perf_overlay_enabled(not _perf_overlay_enabled)
		get_viewport().set_input_as_handled()
		return
	if menu_open:
		return
	if run_complete:
		if event is InputEventKey and event.pressed:
			menu_open = true
			hud.show_main_menu()
			_clear_run_entities()
			queue_redraw()
			_request_dynamic_arena_overlay_redraw(true)
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_SPACE:
				player.try_dash()
			KEY_J:
				player.try_weapon_attack()
			KEY_1:
				_cast_equipped_program(0)
			KEY_2:
				_cast_equipped_program(1)
			KEY_3:
				_cast_equipped_program(2)
			KEY_4:
				_cast_equipped_program(3)

func _clear_run_entities() -> void:
	for child in enemy_root.get_children():
		child.queue_free()
	enemies.clear()
	arena_hazards.clear()
	arena_cover_props.clear()
	payday_pickups.clear()
	_request_dynamic_arena_overlay_redraw(true)
	if player != null:
		player.queue_free()
		player = null

func _on_menu_play_requested() -> void:
	menu_open = false
	_start_run()

func _start_run() -> void:
	run_complete = false
	Engine.time_scale = 1.0
	_impact_freeze_timer = 0.0
	if hud != null and is_instance_valid(hud):
		hud.hide_main_menu()
	_ammo_was_reloading = false
	current_wave = 0
	wave_in_progress = false
	wave_break_timer = 3.2
	opening_grace_timer = 3.2
	enemies_defeated = 0
	duelists_defeated = 0
	defeated_duelist_names.clear()
	style_score = 0
	combo_count = 0
	best_combo = 0
	combo_timer = 0.0
	highest_style_rank = "D"
	keg_chain_bonus = 0
	wave_clear_bonus_credits = 0
	_first_empty_reload_feedback_shown = false
	_first_empty_reload_feedback_count = 0
	_first_saber_kill_feedback_shown = false
	_first_saber_kill_feedback_count = 0
	_chain_break_feedback_count = 0
	_last_second_chain_bonus_count = 0
	_rank_up_feedback_count = 0
	_cover_splinter_total_count = 0
	_mastery_payoff_feedback_count = 0
	_red_canyon_pocket_reward_count = 0
	_last_high_noon_exit_lane_reward_count = 0
	_last_high_noon_exit_lane_hold = 0.0
	_last_high_noon_exit_lane_rewarded = false
	_black_sash_lunge_release_count = 0
	_black_sash_duel_ground_reward_count = 0
	_black_sash_duel_ground_rewarded = false
	_mercy_vale_lunge_release_count = 0
	_june_blackglass_lunge_release_count = 0
	_rewarded_waves.clear()
	payday_pickups.clear()
	_reset_training_tracker()
	director.reset()
	program_system.reset()
	_apply_upgrade_modifiers_to_systems()
	vfx_layer.clear_blood_stains()

	for child in enemy_root.get_children():
		child.queue_free()
	enemies.clear()

	if player != null:
		player.queue_free()

	var generator: RefCounted = VaultGeneratorScene.new()
	var seed_value := int(Time.get_unix_time_from_system()) + randi()
	vault_data = generator.generate(seed_value)
	backdrop_cache.queue_redraw()

	player = PlayerScene.new()
	add_child(player)
	player.position = vault_data["spawn"]
	player.set_arena_bounds(vault_data["arena"])
	player.apply_weapon_profile(equipped_blade)
	player.set_upgrade_modifiers(_get_upgrade_modifiers())
	opening_grace_timer += float(_get_upgrade_effect_value("opening_grace_bonus", 0.0))
	player.apply_dust_veil(opening_grace_timer)
	player.dash_used.connect(_on_player_dash)
	player.weapon_slashed.connect(_on_player_weapon_slashed)
	player.player_damaged.connect(_on_player_damaged)
	player.player_parried.connect(_on_player_parried)
	player.player_down.connect(_on_player_down)

	camera = Camera2D.new()
	camera.zoom = Vector2(0.9, 0.9)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	player.add_child(camera)
	camera.make_current()

	hud.show_run_start(vault_data["seed"])
	hud.show_rookie_primer()
	vfx_layer.burst(vault_data["spawn"], Color(0.72, 0.38, 0.16), 36)
	queue_redraw()
	_request_dynamic_arena_overlay_redraw(true)

func _update_wave(delta: float) -> void:
	opening_grace_timer = maxf(0.0, opening_grace_timer - delta)
	enemies = enemies.filter(func(enemy: Node2D) -> bool: return is_instance_valid(enemy))
	if wave_in_progress and enemies.is_empty():
		if current_wave >= MAX_LEVEL:
			_complete_run()
			return
		_grant_wave_clear_reward(current_wave)
		wave_in_progress = false
		wave_break_timer = 1.15
		director.add_heat(-0.35)

	if not wave_in_progress and wave_break_timer > 0.0:
		wave_break_timer = max(0.0, wave_break_timer - delta)
		if wave_break_timer <= 0.0:
			_start_next_wave()

func _reset_training_tracker() -> void:
	for key in _training_steps.keys():
		_training_steps[key] = false
	_training_active = not _smoke_test_active
	if hud != null:
		hud.update_training_tracker(_training_steps, _get_training_tip(), _training_active)

func _update_training_tracker() -> void:
	if not _training_active or player == null or hud == null:
		return
	if player.velocity.length() > 150.0:
		_training_steps["move"] = true
	if _training_steps.values().all(func(value) -> bool: return bool(value)):
		_training_active = false
		if hud.has_method("show_training_complete_feedback"):
			hud.show_training_complete_feedback(_training_steps)
		else:
			hud.update_training_tracker(_training_steps, "CLEAR TEN LEVELS\nPAYDAY SATCHELS OPTIONAL +CREDITS +ROUNDS", false)
		_play_audio_cue("reward", 0.38)
		return
	hud.update_training_tracker(_training_steps, _get_training_tip(), true)

func _update_last_high_noon_exit_lane(delta: float) -> void:
	if current_wave != MAX_LEVEL or not wave_in_progress or _last_high_noon_exit_lane_rewarded:
		_last_high_noon_exit_lane_hold = 0.0
		return
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		_last_high_noon_exit_lane_hold = 0.0
		return
	if not _is_point_in_last_high_noon_exit_lane(player.global_position):
		_last_high_noon_exit_lane_hold = 0.0
		return
	_last_high_noon_exit_lane_hold += delta
	if _last_high_noon_exit_lane_hold < 0.32:
		return
	_last_high_noon_exit_lane_rewarded = true
	_last_high_noon_exit_lane_reward_count += 1
	_award_style_points(260, "EXIT LANE")
	director.add_heat(-0.06)
	_shake_camera(2.0, 0.06)
	if vfx_layer != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -48.0), Color(1.0, 0.78, 0.24), "EXIT LANE", 96.0)
		vfx_layer.burst(player.global_position, Color(0.98, 0.72, 0.22), 12)
	_play_audio_cue("reward", 0.52)

func _is_point_in_last_high_noon_exit_lane(point: Vector2) -> bool:
	if vault_data.is_empty() or not vault_data.has("arena"):
		return false
	return _get_last_high_noon_exit_lane_rect(vault_data["arena"] as Rect2).grow(12.0).has_point(point)

func _get_training_tip() -> String:
	if not bool(_training_steps.get("move", false)):
		return "FIRST: MOVE BEFORE THE OUTLAWS FAN OUT"
	if not bool(_training_steps.get("dash", false)):
		return "DASH THROUGH BAD ANGLES, NOT INTO THEM"
	if not bool(_training_steps.get("slash", false)):
		return "SLASH CLOSE THREATS AND POWDER KEGS"
	if not bool(_training_steps.get("cast", false)):
		return "CAST A GUN ABILITY TO CONTROL A LANE"
	return "CLEAR TEN LEVELS\nPAYDAY SATCHELS OPTIONAL +CREDITS +ROUNDS"

func _grant_wave_clear_reward(wave: int) -> void:
	if wave <= 0 or _rewarded_waves.has(wave):
		return
	_rewarded_waves.append(wave)
	var credit_bonus: int = 18 + wave * 7
	credit_bonus = int(round(float(credit_bonus) * float(_get_upgrade_effect_value("payday_credit_bonus", 1.0))))
	var ammo_refill: int = 2 if wave < 3 else 1
	_play_wave_clear_feedback(wave)
	_spawn_payday_pickup(wave, credit_bonus, ammo_refill)
	hud.show_style_pop("PAYDAY DROPPED", _get_style_rank(), combo_count)

func _play_wave_clear_feedback(wave: int) -> void:
	_play_audio_cue("level_clear", 0.6 + minf(0.3, float(wave) * 0.025))
	if hud != null and hud.has_method("show_wave_clear_feedback"):
		hud.show_wave_clear_feedback(wave, _get_level_title(wave), mini(wave + 1, MAX_LEVEL), MAX_LEVEL)
	if vfx_layer != null and player != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -54.0), Color(1.0, 0.72, 0.24), "CLEAR", 92.0)
		vfx_layer.burst(player.global_position, Color(0.96, 0.72, 0.24), 10)

func _start_next_wave() -> void:
	current_wave += 1
	wave_in_progress = true
	if current_wave == 3:
		_black_sash_duel_ground_rewarded = false
	if current_wave == MAX_LEVEL:
		_last_high_noon_exit_lane_hold = 0.0
		_last_high_noon_exit_lane_rewarded = false
	if hud != null and hud.has_method("clear_objective_feedback"):
		hud.clear_objective_feedback()
	_generate_arena_hazards(current_wave)
	_generate_arena_cover_props(current_wave)
	_request_dynamic_arena_overlay_redraw(true)
	_request_arena_visual_redraw(true)
	hud.show_wave_banner(current_wave, _get_level_title(current_wave), MAX_LEVEL)
	_play_level_start_feedback()
	_record_wave_progress(current_wave)
	_spawn_wave(current_wave)
	var modifier := _get_level_modifier(current_wave)
	var opening_heat := 0.045 if current_wave == 1 else 0.1 + current_wave * 0.025
	director.add_heat(opening_heat + float(modifier.get("heat", 0.0)))

func _play_level_start_feedback() -> void:
	_play_audio_cue("level_start", 0.52 + minf(0.36, float(current_wave) * 0.035))
	if vfx_layer != null and player != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -46.0), Color(1.0, 0.68, 0.2), "DRAW", 82.0)
		vfx_layer.burst(player.global_position, Color(0.96, 0.62, 0.22), 8)

func _spawn_wave(wave: int) -> void:
	var modifier := _get_level_modifier(wave)
	var total: int = 4 if wave == 1 else 4 + wave * 2
	var duelist_count: int = 1 if wave % 3 == 0 else 0
	if duelist_count > 0:
		var duelist_profile := _get_duelist_profile(wave)
		hud.show_duelist_intro(
			duelist_profile["name"],
			duelist_profile["accent"],
			duelist_profile["title"],
			duelist_profile["line"]
		)
		_spawn_enemy(DuelistScene, 0, 1, duelist_profile)
		return

	var post_boss_pressure: int = maxi(0, wave - 3) + duelists_defeated * 2 + int(modifier.get("pressure", 0))
	var brute_count: int = int(mini(maxi(0, wave - 2 + post_boss_pressure) / 2, 7)) + int(modifier.get("brute", 0))
	var rifleman_count: int = int(mini(maxi(1, wave + post_boss_pressure) / 2, 8)) + int(modifier.get("rifle", 0))
	var hunter_count: int = int(modifier.get("hunter", 0))
	var knife_count: int = maxi(1, total - brute_count - rifleman_count - hunter_count - duelist_count) + int(modifier.get("knife", 0))
	var spawn_total: int = knife_count + rifleman_count + brute_count + hunter_count + duelist_count
	var index := 0

	for i in range(knife_count):
		_spawn_enemy(KnifeRusherScene, index, spawn_total)
		index += 1
	for i in range(rifleman_count):
		_spawn_enemy(RiflemanScene, index, spawn_total)
		index += 1
	for i in range(hunter_count):
		_spawn_enemy(HunterScene, index, spawn_total)
		index += 1
	for i in range(brute_count):
		_spawn_enemy(ShotgunBruteScene, index, spawn_total)
		index += 1
	for i in range(duelist_count):
		_spawn_enemy(DuelistScene, index, spawn_total)
		index += 1

func _spawn_enemy(enemy_script, index: int, total: int, profile: Dictionary = {}) -> void:
	var enemy: Node2D = enemy_script.new()
	var spawn_position := _get_wave_spawn_position(index, total)
	if enemy_script == DuelistScene and total == 1:
		spawn_position = _get_duelist_spawn_position(profile)
	enemy.position = spawn_position
	enemy_root.add_child(enemy)
	enemy.setup(player, director, vfx_layer)
	if enemy_script == DuelistScene and enemy.has_method("configure_variant"):
		enemy.configure_variant(profile)
	enemy.destroyed.connect(_on_enemy_destroyed)
	if enemy_script == HunterScene and enemy.has_signal("lunge_started"):
		enemy.connect("lunge_started", _on_hunter_lunge_started)
	if enemy_script == RiflemanScene and enemy.has_signal("shot_fired"):
		enemy.connect("shot_fired", _on_rifleman_shot_fired)
	if enemy_script == DuelistScene and enemy.has_signal("lunge_released"):
		enemy.connect("lunge_released", _on_duelist_lunge_released)
	enemy.set_alert_level(int(min(4, current_wave / 2 + duelists_defeated)))
	if enemy_script == DuelistScene:
		enemy.set_meta("boss", true)
		enemy.set_meta("duelist_name", profile.get("name", "DUELIST"))
		enemy.set_meta("duelist_id", profile.get("id", "duelist"))
	enemies.append(enemy)

func _get_duelist_profile(wave: int) -> Dictionary:
	var boss_index: int = maxi(0, int(wave / 3) - 1)
	match wave:
		3:
			boss_index = 0
		6:
			boss_index = 1
		9:
			boss_index = 4
	var profile: Dictionary = DUELIST_ROSTER[boss_index % DUELIST_ROSTER.size()].duplicate()
	var cycle: int = int(boss_index / DUELIST_ROSTER.size())
	if cycle > 0:
		profile["health"] = float(profile["health"]) + cycle * 36.0
		profile["speed"] = float(profile["speed"]) + cycle * 8.0
		profile["cooldown"] = maxf(0.72, float(profile["cooldown"]) - cycle * 0.04)
	return profile

func _get_duelist_spawn_position(profile: Dictionary) -> Vector2:
	var arena: Rect2 = vault_data["arena"].grow(-220.0)
	var center := arena.get_center()
	var range_radius := clampf(float(profile.get("range", 560.0)) - 54.0, 380.0, 560.0)
	var angle := -0.65 + float(current_wave % 4) * 0.42
	var position := center + Vector2.RIGHT.rotated(angle) * range_radius
	return position.clamp(arena.position, arena.end)

func _get_wave_spawn_position(index: int, total: int) -> Vector2:
	var arena: Rect2 = vault_data["arena"].grow(-90.0)
	var angle: float = TAU * float(index) / maxf(1.0, float(total)) + randf_range(-0.22, 0.22)
	var center: Vector2 = arena.get_center()
	var radius := Vector2(arena.size.x * 0.5, arena.size.y * 0.5)
	var edge_point: Vector2 = center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
	return edge_point.clamp(arena.position, arena.end)

func _update_camera(delta: float) -> void:
	if camera == null:
		return
	var speed_factor: float = clamp(player.velocity.length() / player.max_speed, 0.0, 1.0)
	var target_zoom: float = 0.92 - speed_factor * 0.08 - director.alert_level * 0.025
	camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), delta * 3.0)
	camera.rotation = lerpf(camera.rotation, player.velocity.x * 0.000035, delta * 4.0)

func _update_impact_freeze(delta: float) -> void:
	if _impact_freeze_timer <= 0.0:
		return
	_impact_freeze_timer = maxf(0.0, _impact_freeze_timer - delta / maxf(Engine.time_scale, 0.01))
	if _impact_freeze_timer <= 0.0:
		Engine.time_scale = 1.0

func _trigger_impact_freeze(duration: float, shake_strength: float, shake_duration: float) -> void:
	_impact_freeze_timer = maxf(_impact_freeze_timer, duration)
	Engine.time_scale = minf(Engine.time_scale, 0.18)
	_shake_camera(shake_strength, shake_duration)

func _shake_camera(strength: float, duration: float) -> void:
	if camera == null:
		return
	camera.offset = Vector2(randf_range(-strength, strength), randf_range(-strength * 0.78, strength * 0.78))
	var tween := create_tween()
	tween.tween_property(camera, "offset", Vector2.ZERO, duration)

func _play_audio_cue(cue: String, strength: float = 1.0) -> void:
	if audio_director != null and audio_director.has_method("play_cue"):
		audio_director.play_cue(cue, strength)

func _on_hunter_lunge_started(enemy: Node2D) -> void:
	if not is_instance_valid(enemy):
		return
	_hunter_lunge_camera_kicks += 1
	_shake_camera(2.6, 0.07)
	_try_award_red_canyon_pocket_reward()
	if hud != null and hud.has_method("show_hunter_lunge_warning"):
		hud.show_hunter_lunge_warning()
	_play_audio_cue("hunter_lunge", 0.72 + minf(0.28, float(current_wave) * 0.025))

func _try_award_red_canyon_pocket_reward() -> void:
	if current_wave != 7 or str(_get_level_modifier(current_wave).get("id", "")) != "sandstorm":
		return
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		return
	if not _is_point_in_red_canyon_route_pocket(player.global_position):
		return
	_red_canyon_pocket_reward_count += 1
	_award_style_points(180, "CANYON POCKET")
	director.add_heat(-0.04)
	_play_mastery_payoff(player.global_position, "CANYON POCKET", Color(1.0, 0.76, 0.28), 1.8, 0.055)
	if vfx_layer != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -46.0), Color(1.0, 0.78, 0.28), "POCKET", 86.0)
		vfx_layer.burst(player.global_position, Color(0.96, 0.72, 0.32), 10)
	_play_audio_cue("reward", 0.48)

func _play_mastery_payoff(origin: Vector2, label: String, color: Color, shake_strength: float, shake_duration: float) -> void:
	_mastery_payoff_feedback_count += 1
	_shake_camera(shake_strength, shake_duration)
	if vfx_layer != null:
		vfx_layer.shockwave(origin, color)
		vfx_layer.burst(origin, color, 18)
		vfx_layer.impact_flash(origin + Vector2(0.0, -54.0), color.lightened(0.12), label, 112.0)

func _is_point_in_red_canyon_route_pocket(point: Vector2) -> bool:
	if vault_data.is_empty():
		return false
	var arena: Rect2 = vault_data["arena"]
	for pocket in _get_red_canyon_route_pocket_rects(arena):
		if (pocket as Rect2).grow(10.0).has_point(point):
			return true
	return false

func _on_duelist_lunge_released(duelist: Node2D, variant_id: String, _variant_name: String, origin: Vector2, direction: Vector2) -> void:
	if not is_instance_valid(duelist):
		return
	if current_wave == 3 and variant_id == "black_sash":
		_black_sash_lunge_release_count += 1
		_shake_camera(4.2, 0.09)
		_try_award_black_sash_duel_ground_reward()
		if hud != null and hud.has_method("show_black_sash_lunge_warning"):
			hud.show_black_sash_lunge_warning()
		if vfx_layer != null:
			var black_sash_flash_origin := origin
			if direction.length_squared() > 0.001:
				black_sash_flash_origin += direction.normalized() * 44.0
			vfx_layer.impact_flash(black_sash_flash_origin, Color(0.88, 0.08, 0.035), "BLACK SASH", 118.0)
		_play_audio_cue("black_sash_lunge", 0.9)
	elif current_wave == 6 and variant_id == "mercy_vale":
		_mercy_vale_lunge_release_count += 1
		_shake_camera(3.4, 0.07)
		if hud != null and hud.has_method("show_mercy_vale_lunge_warning"):
			hud.show_mercy_vale_lunge_warning()
		if vfx_layer != null:
			var mercy_flash_origin := origin
			if direction.length_squared() > 0.001:
				mercy_flash_origin += direction.normalized() * 58.0
			vfx_layer.impact_flash(mercy_flash_origin, Color(1.0, 0.62, 0.18), "MERCY DRAW", 108.0)
		_play_audio_cue("mercy_vale_lunge", 0.88)
	elif current_wave == 9 and variant_id == "june_blackglass":
		_june_blackglass_lunge_release_count += 1
		_shake_camera(5.0, 0.1)
		if hud != null and hud.has_method("show_june_blackglass_lunge_warning"):
			hud.show_june_blackglass_lunge_warning()
		if vfx_layer != null:
			var june_flash_origin := origin
			if direction.length_squared() > 0.001:
				june_flash_origin += direction.normalized() * 52.0
			vfx_layer.impact_flash(june_flash_origin, Color(0.95, 0.1, 0.16), "SNAP", 122.0)
		_play_audio_cue("june_blackglass_lunge", 0.94)

func _try_award_black_sash_duel_ground_reward() -> void:
	if _black_sash_duel_ground_rewarded or current_wave != 3 or str(_get_level_modifier(current_wave).get("id", "")) != "duel":
		return
	if player == null or not is_instance_valid(player) or vault_data.is_empty():
		return
	if not _is_point_in_black_sash_duel_ground(player.global_position):
		return
	_black_sash_duel_ground_rewarded = true
	_black_sash_duel_ground_reward_count += 1
	_award_style_points(220, "DUEL GROUND")
	director.add_heat(-0.05)
	if vfx_layer != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -48.0), Color(1.0, 0.62, 0.22), "DUEL GROUND", 102.0)
		vfx_layer.burst(player.global_position, Color(0.96, 0.58, 0.2), 10)
	_play_audio_cue("reward", 0.5)

func _is_point_in_black_sash_duel_ground(point: Vector2) -> bool:
	if vault_data.is_empty():
		return false
	var origin := _get_black_sash_duel_ground_origin(vault_data["arena"] as Rect2)
	return point.distance_to(origin) <= 172.0

func _get_black_sash_duel_ground_origin(arena: Rect2) -> Vector2:
	return arena.get_center() + Vector2(10.0, 18.0)

func _get_black_sash_attack_tell_strength() -> float:
	if current_wave != 3:
		return 0.0
	var strongest := 0.0
	for enemy in enemies:
		if not is_instance_valid(enemy) or not enemy.has_meta("duelist_name"):
			continue
		if str(enemy.get_meta("duelist_name", "")) != "THE BLACK SASH":
			continue
		if enemy.has_method("has_attack_tell") and bool(enemy.has_attack_tell()) and enemy.has_method("get_attack_tell_strength"):
			strongest = maxf(strongest, float(enemy.get_attack_tell_strength()))
	return strongest

func _on_rifleman_shot_fired(_shooter: Node2D, shot_start: Vector2, shot_end: Vector2, direction: Vector2) -> void:
	if str(_get_level_modifier(current_wave).get("id", "")) != "crossfire":
		return
	_splinter_cover_props_hit_by_line(shot_start, shot_end, direction)

func _cast_program(program_id: String) -> void:
	if not program_system.can_cast(program_id):
		if program_system.has_method("get_ammo_summary"):
			var ammo: Dictionary = program_system.get_ammo_summary()
			if ammo.get("reloading", false) or int(ammo.get("ammo", 0)) <= 0:
				hud.show_style_pop("AUTO RELOAD\nCYLINDER TURNING", _get_style_rank(), combo_count)
				_play_audio_cue("dry", 0.7)
		return

	var ammo_before: Dictionary = program_system.get_ammo_summary() if program_system.has_method("get_ammo_summary") else {}
	var result: Dictionary = program_system.cast(program_id, player.global_position, _get_mouse_aim_direction(), enemies)
	_training_steps["cast"] = true
	director.add_heat(result["heat"])
	vfx_layer.skill_flash(player.global_position, result["color"], program_id)
	if _is_player_gun_program(program_id):
		var ammo_after: Dictionary = program_system.get_ammo_summary()
		if int(ammo_before.get("ammo", 0)) == 1 and bool(ammo_after.get("reloading", false)):
			_show_auto_reload_feedback()
	if result.get("shot_from", Vector2.ZERO) != result.get("shot_to", Vector2.ZERO):
		vfx_layer.beam(result["shot_from"], result["shot_to"], result["color"])
		vfx_layer.muzzle_flash(result["shot_from"], (result["shot_to"] - result["shot_from"]).normalized(), result["color"])
	if result.get("effect", "") == "veil":
		player.apply_dust_veil(result.get("veil_duration", 1.0))
	if result.get("effect", "") == "quickdraw":
		player.force_quickdraw()
	if result.get("effect", "") == "duelist_lunge":
		player.force_lunge()
		player.force_quickdraw()

	var hit_count := 0
	for enemy in result["hit_enemies"]:
		if is_instance_valid(enemy):
			enemy.take_damage(result["damage"])
			hit_count += 1
	if result.get("shot_from", Vector2.ZERO) != result.get("shot_to", Vector2.ZERO):
		var shot_direction: Vector2 = (result["shot_to"] - result["shot_from"]).normalized()
		if _splinter_cover_props_hit_by_line(result["shot_from"], result["shot_to"], shot_direction):
			hit_count += 1

	if result["chain_radius"] > 0.0:
		_trigger_chain_reaction(player.global_position, result["chain_radius"], result["damage"] * 0.7)
		hit_count += 1
	if hit_count > 0:
		hud.flash_hit()
		var impact_origin: Vector2 = result.get("shot_to", player.global_position)
		vfx_layer.impact_flash(impact_origin, result["color"], "BANG", 112.0)
		_trigger_impact_freeze(0.035, 6.0, 0.09)
		_play_audio_cue("gun", 1.0 + minf(0.55, float(hit_count) * 0.08))

func _is_player_gun_program(program_id: String) -> bool:
	return ["deadeye", "ricochet_shot", "quickdraw", "fan_hammer"].has(program_id)

func _show_auto_reload_feedback() -> void:
	var pop_text := "AUTO RELOAD\nCYLINDER TURNING"
	if not _first_empty_reload_feedback_shown:
		_first_empty_reload_feedback_shown = true
		_first_empty_reload_feedback_count += 1
		pop_text = "AUTO RELOAD\nWAIT FOR READY GLINT"
	hud.show_style_pop(pop_text, _get_style_rank(), combo_count)
	if vfx_layer != null and player != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -42.0), Color(1.0, 0.58, 0.18), "AUTO RELOAD", 88.0)
		if pop_text.find("READY GLINT") >= 0 and vfx_layer.has_method("empty_reload_spin"):
			vfx_layer.empty_reload_spin(player.global_position + Vector2(0.0, -24.0), player.get_aim_direction())
	_play_audio_cue("dry", 0.45)

func _update_reload_ready_feedback() -> void:
	if program_system == null or not is_instance_valid(program_system) or not program_system.has_method("get_ammo_summary"):
		_ammo_was_reloading = false
		return
	var ammo: Dictionary = program_system.get_ammo_summary()
	var reloading := bool(ammo.get("reloading", false))
	var ready := not reloading and int(ammo.get("ammo", 0)) >= int(ammo.get("capacity", 0))
	if _ammo_was_reloading and ready:
		_show_reload_ready_feedback()
	_ammo_was_reloading = reloading

func _show_reload_ready_feedback() -> void:
	var capacity: int = program_system.ammo_capacity if program_system != null and is_instance_valid(program_system) else 6
	hud.show_style_pop("CYLINDER READY\nFULL %d/%d - DRAW" % [capacity, capacity], _get_style_rank(), combo_count)
	if vfx_layer != null and player != null:
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -42.0), Color(1.0, 0.74, 0.28), "READY", 78.0)
		vfx_layer.burst(player.global_position, Color(1.0, 0.74, 0.28), 8)
		if vfx_layer.has_method("reload_ready_glint"):
			vfx_layer.reload_ready_glint(player.global_position + Vector2(0.0, -24.0), player.get_aim_direction())
	_play_audio_cue("reward", 0.42)

func _trigger_chain_reaction(origin: Vector2, radius: float, damage: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(origin) <= radius:
			enemy.take_damage(damage)
			hud.flash_hit()
	_ignite_hazards_in_radius(origin, radius)
	if vfx_layer != null:
		vfx_layer.impact_flash(origin, Color(0.92, 0.42, 0.12), "CHAIN", 126.0)
	_trigger_impact_freeze(0.03, 5.0, 0.08)
	_play_audio_cue("chain", 0.82)
	director.add_heat(0.08)

func _update_style_timer(delta: float) -> void:
	if combo_count <= 0:
		return
	combo_timer = maxf(0.0, combo_timer - delta)
	if combo_timer <= 0.0:
		_break_style_combo("TIMEOUT")

func _get_combo_fraction() -> float:
	if combo_count <= 0:
		return 0.0
	return clampf(combo_timer / 4.0, 0.0, 1.0)

func _award_style_points(base_points: int, reason: String = "") -> void:
	var previous_rank := _get_style_rank()
	var last_second_bonus := 0
	if combo_count > 0 and _get_combo_fraction() <= 0.25:
		last_second_bonus = 75
		_last_second_chain_bonus_count += 1
	combo_count += 1
	best_combo = maxi(best_combo, combo_count)
	combo_timer = 4.0 + float(_get_upgrade_effect_value("combo_timer_bonus", 0.0))
	var combo_multiplier: float = 1.0 + minf(2.5, float(combo_count - 1) * 0.16)
	var earned := int(round(float(base_points) * combo_multiplier))
	earned += last_second_bonus
	style_score += earned
	var new_rank := _get_style_rank()
	var pop_text := "+%d %s" % [earned, reason]
	if last_second_bonus > 0:
		pop_text += "\nLAST SECOND +%d" % last_second_bonus
		director.add_heat(-0.03)
		_play_audio_cue("reward", 0.36)
		if vfx_layer != null and player != null and is_instance_valid(player):
			vfx_layer.impact_flash(player.global_position + Vector2(0.0, -46.0), Color(1.0, 0.78, 0.26), "LAST SECOND", 96.0)
	if _get_style_rank_value(new_rank) > _get_style_rank_value(previous_rank):
		_rank_up_feedback_count += 1
		highest_style_rank = new_rank
		pop_text += "\nRANK UP %s" % new_rank
		_play_audio_cue("reward", 0.55)
		_shake_camera(1.8, 0.05)
		if vfx_layer != null and player != null and is_instance_valid(player):
			vfx_layer.impact_flash(player.global_position + Vector2(0.0, -58.0), Color(1.0, 0.82, 0.34), "RANK %s" % new_rank, 108.0)
	hud.show_style_pop(pop_text, _get_style_rank(), combo_count)

func _break_style_combo(reason: String = "") -> void:
	if combo_count <= 0:
		combo_timer = 0.0
		return
	combo_count = 0
	combo_timer = 0.0
	_chain_break_feedback_count += 1
	var should_show_pop := true
	if reason == "HIT" and hud != null and hud.has_method("get_style_pop_text"):
		var current_pop: String = hud.get_style_pop_text()
		should_show_pop = not (current_pop.begins_with("+") or current_pop.find("CANYON") >= 0 or current_pop.find("EXIT LANE") >= 0 or current_pop.find("LAST SECOND") >= 0)
	if should_show_pop and hud != null and hud.has_method("show_style_pop"):
		var break_text := "CHAIN BROKE"
		if reason != "":
			break_text += "\n%s" % reason
		hud.show_style_pop(break_text, _get_style_rank(), 0)
	if vfx_layer != null and player != null and is_instance_valid(player):
		vfx_layer.impact_flash(player.global_position + Vector2(0.0, -40.0), Color(0.86, 0.22, 0.12), "CHAIN", 74.0)

func _get_style_rank() -> String:
	if style_score >= 12500:
		return "S"
	if style_score >= 8500:
		return "A"
	if style_score >= 5200:
		return "B"
	if style_score >= 2600:
		return "C"
	return "D"

func _get_style_rank_value(rank: String) -> int:
	match rank:
		"S":
			return 4
		"A":
			return 3
		"B":
			return 2
		"C":
			return 1
		_:
			return 0

func _get_run_grade_text() -> String:
	return "RANK %s  SCORE %d\nBEST COMBO x%d  DUELISTS %d\n%s\n%s\n%s\nOUTLAWS %d  PAYDAY HAUL +%d" % [
		_get_style_rank(),
		style_score,
		best_combo,
		duelists_defeated,
		_get_defeated_duelist_summary(),
		_get_mastery_reward_summary(),
		_get_style_progress_summary(),
		enemies_defeated,
		wave_clear_bonus_credits,
	]

func _get_mastery_reward_summary() -> String:
	if _black_sash_duel_ground_reward_count <= 0 and _red_canyon_pocket_reward_count <= 0 and _last_high_noon_exit_lane_reward_count <= 0 and keg_chain_bonus <= 0:
		return "MASTERY NONE"
	var mastery_text := "MASTERY DUEL x%d  CANYON x%d  EXIT x%d" % [_black_sash_duel_ground_reward_count, _red_canyon_pocket_reward_count, _last_high_noon_exit_lane_reward_count]
	if keg_chain_bonus > 0:
		mastery_text += "\nPOWDER KEG x%d" % keg_chain_bonus
	return mastery_text

func _get_style_progress_summary() -> String:
	return "STYLE PEAK %s  RANK UPS x%d" % [highest_style_rank, _rank_up_feedback_count]

func _get_run_result_text(credits: int, extracted: bool) -> String:
	var level_text := "TEN-LEVEL EXTRACTION\nLEVELS CLEARED 10/10\nRODE EAST OUT OF LAST HIGH NOON" if extracted else "FELL AT LEVEL %d/%d" % [clampi(current_wave, 1, MAX_LEVEL), MAX_LEVEL]
	return "%s\n%s\nBANKED +%d CREDITS" % [level_text, _get_run_grade_text(), credits]

func _get_defeated_duelist_summary() -> String:
	if defeated_duelist_names.is_empty():
		return "RIVALS NONE"
	var shown_names: Array[String] = []
	for name in defeated_duelist_names:
		if shown_names.size() >= 3:
			break
		shown_names.append(name)
	return "RIVALS %s" % ", ".join(shown_names)

func _on_player_dash() -> void:
	_training_steps["dash"] = true
	director.add_heat(0.03)
	vfx_layer.trail_pop(player.global_position, Color(0.68, 0.36, 0.16))

func _on_player_weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float) -> void:
	_training_steps["slash"] = true
	director.add_heat(0.025)
	vfx_layer.trail_pop(origin + direction * 62.0, Color(0.86, 0.58, 0.28))
	var hit_count := 0
	var defeated_before := enemies_defeated

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		if _sword_sweep_hits_enemy(origin, direction, slash_range, arc, enemy.global_position):
			enemy.take_damage(damage)
			hit_count += 1
	if _ignite_hazards_hit_by_sword(origin, direction, slash_range, arc):
		hit_count += 1
	if _splinter_cover_props_hit_by_sword(origin, direction, slash_range, arc):
		hit_count += 1
	if hit_count > 0:
		hud.flash_hit()
		if vfx_layer.has_method("saber_afterimage"):
			vfx_layer.saber_afterimage(origin, direction, slash_range, arc, hit_count)
		vfx_layer.impact_flash(origin + direction * 92.0, Color(1.0, 0.72, 0.32), "SLASH", 120.0)
		_trigger_impact_freeze(0.032, 5.5, 0.08)
		_play_audio_cue("slash", 0.92)
		if enemies_defeated > defeated_before:
			_show_first_saber_kill_feedback()

func _show_first_saber_kill_feedback() -> void:
	if _first_saber_kill_feedback_shown:
		return
	_first_saber_kill_feedback_shown = true
	_first_saber_kill_feedback_count += 1
	var dash_direction: Vector2 = player.get_aim_direction() if player != null and is_instance_valid(player) else Vector2.RIGHT
	if hud != null and hud.has_method("show_style_pop"):
		hud.show_style_pop("FIRST CUT\nDASH NEXT", _get_style_rank(), combo_count)
	if vfx_layer != null and vfx_layer.has_method("dash_ready_glint") and player != null and is_instance_valid(player):
		vfx_layer.dash_ready_glint(player.global_position, dash_direction)
	if vfx_layer != null and vfx_layer.has_method("dash_ready_prompt") and player != null and is_instance_valid(player):
		vfx_layer.dash_ready_prompt(player.global_position, dash_direction)
	_play_audio_cue("reward", 0.5)

func _sword_sweep_hits_enemy(origin: Vector2, direction: Vector2, slash_range: float, arc: float, enemy_position: Vector2) -> bool:
	return _sword_sweep_hits_point(origin, direction, slash_range, arc, enemy_position, 34.0)

func _sword_sweep_hits_point(origin: Vector2, direction: Vector2, slash_range: float, arc: float, point: Vector2, point_radius: float) -> bool:
	var blade_base := 31.0
	var blade_tip := slash_range + 18.0
	var blade_width := 28.0
	var base_angle := direction.angle()
	var samples := 17
	for i in range(samples):
		var t := 0.0 if samples <= 1 else float(i) / float(samples - 1)
		var slash_direction := Vector2.RIGHT.rotated(lerpf(base_angle - arc * 0.5, base_angle + arc * 0.5, t))
		var segment_start := origin + slash_direction * blade_base
		var segment_end := origin + slash_direction * blade_tip
		if _distance_to_segment(point, segment_start, segment_end) <= point_radius + blade_width:
			return true
	return false

func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)
	var t := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * t)

func _on_player_damaged(amount: float) -> void:
	if opening_grace_timer > 0.0:
		return
	_break_style_combo("HIT")
	director.add_heat(0.18)
	_trigger_impact_freeze(0.045, 13.0, 0.16)
	if vfx_layer.has_method("player_hit_flash"):
		vfx_layer.player_hit_flash(player.global_position, -player.get_aim_direction())
	vfx_layer.burst(player.global_position, Color(0.72, 0.08, 0.04), 24)
	vfx_layer.impact_flash(player.global_position, Color(0.82, 0.08, 0.03), "HIT", 124.0)
	_play_audio_cue("hit", 1.0)

func _on_player_parried() -> void:
	director.add_heat(-0.08)
	_award_style_points(140, "PARRY")
	_trigger_impact_freeze(0.04, 7.0, 0.1)
	if vfx_layer.has_method("parry_clang"):
		vfx_layer.parry_clang(player.global_position, player.get_aim_direction())
	vfx_layer.shockwave(player.global_position, Color(1.0, 0.9, 0.5))
	vfx_layer.burst(player.global_position, Color(1.0, 0.82, 0.34), 12)
	vfx_layer.impact_flash(player.global_position, Color(1.0, 0.9, 0.48), "CLANG", 132.0)
	_play_audio_cue("parry", 1.05)

func _on_player_down() -> void:
	run_complete = true
	Engine.time_scale = 1.0
	_impact_freeze_timer = 0.0
	var credits: int = enemies_defeated * 5 + max(0, current_wave - 1) * 35 + wave_clear_bonus_credits
	save_system.add_credits(credits)
	hud.show_run_failed(_get_run_result_text(credits, false))
	vfx_layer.shockwave(player.global_position, Color(0.72, 0.08, 0.04))

func _complete_run() -> void:
	run_complete = true
	Engine.time_scale = 1.0
	_impact_freeze_timer = 0.0
	_award_style_points(900 + current_wave * 80, "EXTRACTED")
	var credits: int = enemies_defeated * 8 + MAX_LEVEL * 55 + duelists_defeated * 90 + wave_clear_bonus_credits
	save_system.add_credits(credits)
	_play_extraction_rideout_feedback()
	hud.show_run_complete(credits, _get_run_result_text(credits, true))
	if player != null:
		vfx_layer.shockwave(player.global_position, Color(1.0, 0.72, 0.24))
		vfx_layer.burst(player.global_position, Color(0.94, 0.58, 0.18), 42)

func _play_extraction_rideout_feedback() -> void:
	if vfx_layer == null or player == null or not is_instance_valid(player):
		return
	var end: Vector2 = player.global_position + Vector2(360.0, 0.0)
	if not vault_data.is_empty() and vault_data.has("arena"):
		var arena: Rect2 = vault_data["arena"]
		end = Vector2(arena.end.x - 70.0, player.global_position.y)
	vfx_layer.extraction_rideout(player.global_position, end)

func _get_level_title(wave: int) -> String:
	if wave <= 0:
		return ""
	var index := clampi(wave - 1, 0, LEVEL_ROSTER.size() - 1)
	return LEVEL_ROSTER[index]

func _get_level_modifier(wave: int) -> Dictionary:
	if wave <= 0:
		return {}
	var index := clampi(wave - 1, 0, LEVEL_MODIFIERS.size() - 1)
	return LEVEL_MODIFIERS[index]

func _get_level_notice(wave: int) -> String:
	var modifier := _get_level_modifier(wave)
	return str(modifier.get("notice", ""))

func _on_enemy_destroyed(enemy) -> void:
	enemies_defeated += 1
	var base_points := 110
	var reason := "OUTLAW"
	var enemy_node := enemy as Node2D
	if enemy_node != null and _enemy_script_path_contains(enemy, "knife_rusher") and vfx_layer != null and vfx_layer.has_method("rusher_defeat_burst"):
		var burst_direction := Vector2.RIGHT
		if player != null and is_instance_valid(player):
			burst_direction = player.global_position.direction_to(enemy_node.global_position)
		vfx_layer.rusher_defeat_burst(enemy_node.global_position, burst_direction)
	_record_quest_progress("kill", 1)
	if enemy.has_meta("boss"):
		duelists_defeated += 1
		base_points = 850
		reason = str(enemy.get_meta("duelist_name", "DUELIST"))
		if not defeated_duelist_names.has(reason):
			defeated_duelist_names.append(reason)
		_record_quest_progress("boss", 1)
		var boss_id := str(enemy.get_meta("duelist_id", reason.to_lower().replace(" ", "_")))
		var boss_tokens := 1
		if save_system.claim_boss_token(boss_id):
			boss_tokens += 1
		_award_upgrade_tokens(boss_tokens, "%s DEFEATED" % reason)
		var reward: String = program_system.award_boss_reward()
		var blade_unlocked := false
		if not unlocked_blades.has("black_sash_saber"):
			unlocked_blades.append("black_sash_saber")
			equipped_blade = "black_sash_saber"
			save_system.unlock_blade("black_sash_saber")
			save_system.set_equipped_blade(equipped_blade)
			blade_unlocked = true
			if player != null:
				player.apply_weapon_profile(equipped_blade)
		if reward != "":
			save_system.unlock_ability(reward)
			hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
		if reward != "" and blade_unlocked:
			hud.show_unlock("BLACK SASH SABER + %s UNLOCKED" % program_system.get_program_name(reward).to_upper())
		elif reward != "":
			hud.show_unlock("%s UNLOCKED" % program_system.get_program_name(reward).to_upper())
		elif blade_unlocked:
			hud.show_unlock("BLACK SASH SABER UNLOCKED")
	_award_style_points(base_points, reason)
	enemies = enemies.filter(func(other: Node2D) -> bool: return is_instance_valid(other) and other != enemy)

func _enemy_script_path_contains(enemy: Node, needle: String) -> bool:
	if not is_instance_valid(enemy):
		return false
	var enemy_script: Script = enemy.get_script()
	return enemy_script != null and str(enemy_script.resource_path).find(needle) >= 0

func _cast_equipped_program(slot: int) -> void:
	var program_id: String = program_system.get_equipped_id(slot)
	if program_id == "":
		return
	_cast_program(program_id)

func _get_mouse_aim_direction() -> Vector2:
	var aim: Vector2 = player.global_position.direction_to(get_global_mouse_position())
	if aim.length_squared() <= 0.001:
		return player.get_aim_direction()
	return aim

func _on_ability_loadout_changed(equipped_ids: Array[String]) -> void:
	program_system.set_equipped(equipped_ids)
	save_system.set_equipped_abilities(program_system.equipped)
	hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)

func _on_gun_loadout_changed(gun_id: String) -> void:
	if not unlocked_guns.has(gun_id):
		return
	equipped_gun = gun_id
	program_system.set_equipped_gun(equipped_gun)
	save_system.set_equipped_gun(equipped_gun)
	hud.set_gun_loadout_data(unlocked_guns, equipped_gun)

func _record_wave_progress(wave: int) -> void:
	for quest in QUEST_DEFINITIONS:
		if quest["type"] == "wave":
			var progress: int = save_system.set_quest_progress(quest["id"], wave, quest["target"])
			_try_complete_quest(quest, progress)
	_refresh_quest_screen()

func _record_quest_progress(type: String, amount: int) -> void:
	for quest in QUEST_DEFINITIONS:
		if quest["type"] != type:
			continue
		var progress: int = save_system.add_quest_progress(quest["id"], amount, quest["target"])
		_try_complete_quest(quest, progress)
	_refresh_quest_screen()

func _try_complete_quest(quest: Dictionary, progress: int) -> void:
	var completed: Array = save_system.data["quest_completed"]
	if completed.has(quest["id"]) or progress < int(quest["target"]):
		return
	save_system.complete_quest(quest["id"])
	var token_reward := int(quest.get("token_reward", 1))
	if token_reward > 0:
		_award_upgrade_tokens(token_reward, "%s COMPLETE" % str(quest["name"]))
	var reward_id: String = quest["reward_id"]
	var reward_name: String = quest["reward"]
	if quest["reward_type"] == "ability":
		if program_system.unlock_program(reward_id):
			save_system.unlock_ability(reward_id)
			hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
	elif quest["reward_type"] == "blade":
		if not unlocked_blades.has(reward_id):
			unlocked_blades.append(reward_id)
			equipped_blade = reward_id
			save_system.unlock_blade(reward_id)
			save_system.set_equipped_blade(equipped_blade)
			if player != null:
				player.apply_weapon_profile(equipped_blade)
	elif quest["reward_type"] == "gun":
		if not unlocked_guns.has(reward_id):
			unlocked_guns.append(reward_id)
			equipped_gun = reward_id
			save_system.unlock_gun(reward_id)
			save_system.set_equipped_gun(equipped_gun)
			program_system.set_equipped_gun(equipped_gun)
			hud.set_gun_loadout_data(unlocked_guns, equipped_gun)
	hud.show_unlock("%s COMPLETE - %s UNLOCKED" % [str(quest["name"]), reward_name.to_upper()])

func _refresh_quest_screen() -> void:
	var quests: Array[Dictionary] = []
	var progress_data: Dictionary = save_system.data.get("quest_progress", {})
	var completed: Array = save_system.data.get("quest_completed", [])
	for quest in QUEST_DEFINITIONS:
		var entry: Dictionary = quest.duplicate()
		entry["progress"] = int(progress_data.get(quest["id"], 0))
		entry["complete"] = completed.has(quest["id"])
		quests.append(entry)
	hud.set_quest_data(quests)
	_refresh_upgrade_screen()

func _award_upgrade_tokens(amount: int, source: String) -> void:
	if amount <= 0:
		return
	var total: int = save_system.add_upgrade_tokens(amount)
	_refresh_upgrade_screen()
	if hud != null and is_instance_valid(hud):
		hud.show_unlock("+%d UPGRADE TOKEN%s\n%s\nTOKENS BANKED %d" % [amount, "" if amount == 1 else "S", source, total])

func _on_upgrade_purchase_requested(upgrade_id: String) -> void:
	var upgrade := _get_upgrade_definition(upgrade_id)
	if upgrade.is_empty():
		return
	if _has_upgrade(upgrade_id):
		hud.show_unlock("%s ALREADY OWNED" % str(upgrade.get("name", "UPGRADE")).to_upper())
		return
	var cost := int(upgrade.get("cost", 1))
	if not save_system.purchase_upgrade(upgrade_id, cost):
		hud.show_unlock("NEED %d TOKENS\n%s" % [cost, str(upgrade.get("name", "UPGRADE")).to_upper()])
		return
	_apply_upgrade_modifiers_to_systems()
	_refresh_upgrade_screen()
	hud.show_unlock("%s BOUGHT\nPERMANENT UPGRADE ACTIVE" % str(upgrade.get("name", "UPGRADE")).to_upper())

func _refresh_upgrade_screen() -> void:
	if hud == null or not is_instance_valid(hud) or not hud.has_method("set_upgrade_data"):
		return
	var purchased: Array = save_system.data.get("purchased_upgrades", [])
	var upgrades: Array[Dictionary] = []
	for upgrade in UPGRADE_DEFINITIONS:
		var entry: Dictionary = upgrade.duplicate(true)
		entry["owned"] = purchased.has(upgrade["id"])
		upgrades.append(entry)
	hud.set_upgrade_data(upgrades, int(save_system.data.get("upgrade_tokens", 0)))

func _apply_upgrade_modifiers_to_systems() -> void:
	var modifiers := _get_upgrade_modifiers()
	if program_system != null and is_instance_valid(program_system) and program_system.has_method("set_upgrade_modifiers"):
		program_system.set_upgrade_modifiers(modifiers)
	if player != null and is_instance_valid(player) and player.has_method("set_upgrade_modifiers"):
		player.set_upgrade_modifiers(modifiers)

func _get_upgrade_modifiers() -> Dictionary:
	var modifiers := {
		"max_health_bonus": 0.0,
		"opening_grace_bonus": 0.0,
		"move_speed": 1.0,
		"acceleration": 1.0,
		"dash_speed": 1.0,
		"dash_duration": 1.0,
		"dash_cooldown": 1.0,
		"blade_damage": 1.0,
		"blade_range": 1.0,
		"parry_time": 1.0,
		"gun_damage": 1.0,
		"reload_speed": 1.0,
		"ammo_capacity_bonus": 0,
		"ability_cooldown": 1.0,
		"veil_duration": 1.0,
		"payday_credit_bonus": 1.0,
		"combo_timer_bonus": 0.0,
	}
	for upgrade in UPGRADE_DEFINITIONS:
		if not _has_upgrade(str(upgrade["id"])):
			continue
		var effect := str(upgrade.get("effect", ""))
		var value = upgrade.get("value", 0.0)
		if ["move_speed", "acceleration", "dash_speed", "dash_duration", "dash_cooldown", "blade_damage", "blade_range", "parry_time", "gun_damage", "reload_speed", "ability_cooldown", "veil_duration", "payday_credit_bonus"].has(effect):
			modifiers[effect] = float(modifiers.get(effect, 1.0)) * float(value)
		elif effect == "ammo_capacity_bonus":
			modifiers[effect] = int(modifiers.get(effect, 0)) + int(value)
		else:
			modifiers[effect] = float(modifiers.get(effect, 0.0)) + float(value)
	return modifiers

func _get_upgrade_effect_value(effect: String, default_value: Variant) -> Variant:
	return _get_upgrade_modifiers().get(effect, default_value)

func _get_upgrade_definition(upgrade_id: String) -> Dictionary:
	for upgrade in UPGRADE_DEFINITIONS:
		if str(upgrade.get("id", "")) == upgrade_id:
			return upgrade
	return {}

func _has_upgrade(upgrade_id: String) -> bool:
	var purchased: Array = save_system.data.get("purchased_upgrades", [])
	return purchased.has(upgrade_id)

func _to_string_array(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(str(value))
	return result

func _living_enemy_count() -> int:
	var count := 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			count += 1
	return count

func _on_alert_changed(level: int, meter: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.set_alert_level(level)

func _on_lockdown_started() -> void:
	queue_redraw()

func _configure_input() -> void:
	var mappings := {
		"dash": KEY_SPACE,
		"attack": KEY_J,
		"program_1": KEY_1,
		"program_2": KEY_2,
		"program_3": KEY_3,
		"program_4": KEY_4,
		"ui_left": KEY_A,
		"ui_right": KEY_D,
		"ui_up": KEY_W,
		"ui_down": KEY_S,
	}
	for action in mappings.keys():
		_add_key_mapping(action, mappings[action])

func _add_key_mapping(action: String, keycode: int) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == keycode:
			return
	var input := InputEventKey.new()
	input.physical_keycode = keycode
	InputMap.action_add_event(action, input)
