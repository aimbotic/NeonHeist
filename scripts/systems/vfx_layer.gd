class_name VfxLayer
extends Node2D

var _pulses: Array[Dictionary] = []
var _beams: Array[Dictionary] = []
var _blood_stains: Array[Dictionary] = []
var _impact_texts: Array[Dictionary] = []
var _muzzle_flashes: Array[Dictionary] = []
var _enemy_hit_sparks: Array[Dictionary] = []
var _parry_clangs: Array[Dictionary] = []
var _player_hit_flashes: Array[Dictionary] = []
var _saber_afterimages: Array[Dictionary] = []
var _rusher_defeat_bursts: Array[Dictionary] = []
var _dash_ready_glints: Array[Dictionary] = []
var _dash_ready_prompts: Array[Dictionary] = []
var _rifle_warning_puffs: Array[Dictionary] = []
var _enemy_weapon_bursts: Array[Dictionary] = []
var _enemy_movement_dust: Array[Dictionary] = []
var _extraction_rideouts: Array[Dictionary] = []
var _reload_ready_glints: Array[Dictionary] = []
var _empty_reload_spins: Array[Dictionary] = []
var _ability_cast_glints: Array[Dictionary] = []
var _rifle_warning_puff_total_count := 0
var _extraction_rideout_total_count := 0
var _reload_ready_glint_total_count := 0
var _empty_reload_spin_total_count := 0
var _ability_cast_glint_total_count := 0
var _muzzle_flash_total_count := 0
var _enemy_weapon_burst_total_count := 0
var _enemy_movement_dust_total_count := 0
var _blood_stain_total_count := 0
var _enemy_hit_spark_total_count := 0
var _parry_clang_total_count := 0
var _player_hit_flash_total_count := 0
var _dash_ready_prompt_total_count := 0
const MAX_BLOOD_STAINS := 10
const MUZZLE_FLASH_VISUAL_VERSION := "muzzle_flash_heat_shimmer_casing_star_v4"
const MAX_MUZZLE_FLASHES := 8
const ENEMY_WEAPON_BURST_VISUAL_VERSION := "enemy_weapon_burst_smoke_v1"
const MAX_ENEMY_WEAPON_BURSTS := 8
const ENEMY_MOVEMENT_DUST_VISUAL_VERSION := "enemy_movement_boot_dust_v1"
const MAX_ENEMY_MOVEMENT_DUST := 12
const ENEMY_HIT_SPARK_VISUAL_VERSION := "enemy_hit_sparks_role_glyph_material_v3"
const MAX_ENEMY_HIT_SPARKS := 12
const PARRY_CLANG_VISUAL_VERSION := "parry_clang_brass_ring_v1"
const MAX_PARRY_CLANGS := 6
const PLAYER_HIT_FLASH_VISUAL_VERSION := "player_hit_blood_dust_brass_spur_v2"
const MAX_PLAYER_HIT_FLASHES := 4
const ABILITY_CAST_GLINT_VISUAL_VERSION := "ability_cast_brass_sigils_v1"
const MAX_ABILITY_CAST_GLINTS := 6
const SABER_AFTERIMAGE_VISUAL_VERSION := "saber_afterimage_bone_dust_shear_v1"
const BLOOD_STAIN_VISUAL_VERSION := "sand_soaked_blood_stain_material_v2"
const TRANSIENT_VFX_REDRAW_BUDGET_VERSION := "transient_vfx_spawn_redraw_gate_8fps_v6"
const TRANSIENT_VFX_PULSE_BUDGET_VERSION := "transient_vfx_pulse_arc_budget_12seg_v4"
const TRANSIENT_VFX_REDRAW_INTERVAL := 1.0 / 8.0
const MAX_TRANSIENT_PULSES := 12
const TRANSIENT_PULSE_ARC_SEGMENTS := 12
const BLOOD_TEXTURE_PATHS := [
	"res://assets/vfx/blood_realistic_splat_01.png",
	"res://assets/vfx/blood_realistic_splat_02.png",
	"res://assets/vfx/blood_realistic_splat_03.png",
]

var _blood_textures: Array[Texture2D] = []
var _transient_redraw_timer := 0.0

func _ready() -> void:
	for path in BLOOD_TEXTURE_PATHS:
		var texture := load(path) as Texture2D
		if texture == null:
			push_warning("Could not load blood texture: %s" % path)
		else:
			_blood_textures.append(texture)

func _draw_flat_dust_ellipse(center: Vector2, radius: Vector2, color: Color, segments: int = 18) -> void:
	var points := PackedVector2Array()
	for i in range(maxi(8, segments)):
		var angle := TAU * float(i) / float(maxi(8, segments))
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)

func _process(delta: float) -> void:
	var had_active_effects := _has_active_transient_effects()
	if _transient_redraw_timer > 0.0:
		_transient_redraw_timer = maxf(0.0, _transient_redraw_timer - delta)
	for pulse in _pulses:
		pulse["age"] += delta
	for beam_data in _beams:
		beam_data["age"] += delta
	for text_data in _impact_texts:
		text_data["age"] += delta
	for flash in _muzzle_flashes:
		flash["age"] += delta
	for spark in _enemy_hit_sparks:
		spark["age"] += delta
	for clang in _parry_clangs:
		clang["age"] += delta
	for hit_flash in _player_hit_flashes:
		hit_flash["age"] += delta
	for afterimage in _saber_afterimages:
		afterimage["age"] += delta
	for burst_data in _rusher_defeat_bursts:
		burst_data["age"] += delta
	for glint in _dash_ready_glints:
		glint["age"] += delta
	for prompt in _dash_ready_prompts:
		prompt["age"] += delta
	for puff in _rifle_warning_puffs:
		puff["age"] += delta
	for burst_data in _enemy_weapon_bursts:
		burst_data["age"] += delta
	for dust in _enemy_movement_dust:
		dust["age"] += delta
	for rideout in _extraction_rideouts:
		rideout["age"] += delta
	for glint in _reload_ready_glints:
		glint["age"] += delta
	for spin in _empty_reload_spins:
		spin["age"] += delta
	for cast_glint in _ability_cast_glints:
		cast_glint["age"] += delta
	_pulses = _pulses.filter(func(pulse: Dictionary) -> bool: return pulse["age"] < pulse["life"])
	_beams = _beams.filter(func(beam_data: Dictionary) -> bool: return beam_data["age"] < beam_data["life"])
	_impact_texts = _impact_texts.filter(func(text_data: Dictionary) -> bool: return text_data["age"] < text_data["life"])
	_muzzle_flashes = _muzzle_flashes.filter(func(flash: Dictionary) -> bool: return flash["age"] < flash["life"])
	_enemy_hit_sparks = _enemy_hit_sparks.filter(func(spark: Dictionary) -> bool: return spark["age"] < spark["life"])
	_parry_clangs = _parry_clangs.filter(func(clang: Dictionary) -> bool: return clang["age"] < clang["life"])
	_player_hit_flashes = _player_hit_flashes.filter(func(hit_flash: Dictionary) -> bool: return hit_flash["age"] < hit_flash["life"])
	_saber_afterimages = _saber_afterimages.filter(func(afterimage: Dictionary) -> bool: return afterimage["age"] < afterimage["life"])
	_rusher_defeat_bursts = _rusher_defeat_bursts.filter(func(burst_data: Dictionary) -> bool: return burst_data["age"] < burst_data["life"])
	_dash_ready_glints = _dash_ready_glints.filter(func(glint: Dictionary) -> bool: return glint["age"] < glint["life"])
	_dash_ready_prompts = _dash_ready_prompts.filter(func(prompt: Dictionary) -> bool: return prompt["age"] < prompt["life"])
	_rifle_warning_puffs = _rifle_warning_puffs.filter(func(puff: Dictionary) -> bool: return puff["age"] < puff["life"])
	_enemy_weapon_bursts = _enemy_weapon_bursts.filter(func(burst_data: Dictionary) -> bool: return burst_data["age"] < burst_data["life"])
	_enemy_movement_dust = _enemy_movement_dust.filter(func(dust: Dictionary) -> bool: return dust["age"] < dust["life"])
	_extraction_rideouts = _extraction_rideouts.filter(func(rideout: Dictionary) -> bool: return rideout["age"] < rideout["life"])
	_reload_ready_glints = _reload_ready_glints.filter(func(glint: Dictionary) -> bool: return glint["age"] < glint["life"])
	_empty_reload_spins = _empty_reload_spins.filter(func(spin: Dictionary) -> bool: return spin["age"] < spin["life"])
	_ability_cast_glints = _ability_cast_glints.filter(func(cast_glint: Dictionary) -> bool: return cast_glint["age"] < cast_glint["life"])
	var has_active_effects := _has_active_transient_effects()
	if had_active_effects and not has_active_effects:
		_request_transient_redraw(true)
	elif has_active_effects and _transient_redraw_timer <= 0.0:
		_request_transient_redraw()

func _request_transient_redraw(force: bool = false) -> void:
	if force:
		_transient_redraw_timer = 0.0
		queue_redraw()
		return
	if _transient_redraw_timer > 0.0:
		return
	_transient_redraw_timer = TRANSIENT_VFX_REDRAW_INTERVAL
	queue_redraw()

func _has_active_transient_effects() -> bool:
	return not (
		_pulses.is_empty()
		and _beams.is_empty()
		and _impact_texts.is_empty()
		and _muzzle_flashes.is_empty()
		and _enemy_hit_sparks.is_empty()
		and _parry_clangs.is_empty()
		and _player_hit_flashes.is_empty()
		and _saber_afterimages.is_empty()
		and _rusher_defeat_bursts.is_empty()
		and _dash_ready_glints.is_empty()
		and _dash_ready_prompts.is_empty()
		and _rifle_warning_puffs.is_empty()
		and _enemy_weapon_bursts.is_empty()
		and _enemy_movement_dust.is_empty()
		and _extraction_rideouts.is_empty()
		and _reload_ready_glints.is_empty()
		and _empty_reload_spins.is_empty()
		and _ability_cast_glints.is_empty()
	)

func _draw() -> void:
	for stain in _blood_stains:
		var origin: Vector2 = stain["origin"]
		var color: Color = stain["color"]
		var radius: float = stain["radius"]
		var texture: Texture2D = stain.get("texture", null)
		var direction: Vector2 = stain.get("direction", Vector2.RIGHT)
		var side := direction.orthogonal()
		var soak_radius: float = stain.get("soak_radius", radius * 1.3)
		var rim_color := Color(0.46, 0.12, 0.055, 0.2)
		draw_circle(origin - direction * radius * 0.16, soak_radius, Color(0.11, 0.035, 0.018, 0.16))
		draw_arc(origin - direction * radius * 0.18, soak_radius * 1.04, direction.angle() + PI - 1.15, direction.angle() + PI + 1.15, 30, rim_color, 3.0)
		draw_arc(origin - direction * radius * 0.08, soak_radius * 0.72, direction.angle() - 0.72, direction.angle() + 0.72, 24, Color(0.72, 0.19, 0.07, 0.16), 2.0)
		if texture != null:
			var size: Vector2 = texture.get_size() * stain["scale"]
			draw_set_transform(origin, stain["rotation"], Vector2(1.0, stain["squash"]))
			draw_texture_rect(texture, Rect2(-size * 0.5, size), false, Color(0.9, 0.74, 0.62, 0.92))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for streak in stain.get("streaks", []):
			var start: Vector2 = origin + direction * float(streak["forward"]) + side * float(streak["side"])
			var end: Vector2 = start + direction * float(streak["length"]) + side * float(streak["drift"])
			var streak_color: Color = color.darkened(float(streak["darken"]))
			streak_color.a *= float(streak["alpha"])
			draw_line(start, end, streak_color, float(streak["width"]))
			draw_circle(end, float(streak["width"]) * 0.44, streak_color.lightened(0.08))
		draw_circle(origin, radius * 0.42, color.darkened(0.18))
		draw_arc(origin, radius * 0.92, 0.0, TAU, 32, Color(0.36, 0.055, 0.018, 0.22), 3.0)
		draw_line(origin - side * radius * 0.32 - direction * radius * 0.18, origin + side * radius * 0.42 - direction * radius * 0.42, Color(0.72, 0.04, 0.025, 0.3), 3.0)
		draw_line(origin - side * radius * 0.24 + direction * radius * 0.12, origin + side * radius * 0.28 - direction * radius * 0.08, Color(0.9, 0.18, 0.08, 0.18), 1.6)
		for drop in stain["drops"]:
			var drop_origin: Vector2 = origin + drop["offset"]
			draw_circle(drop_origin, drop["radius"], color.darkened(drop["darken"]))
			draw_circle(drop_origin + Vector2(-drop["radius"] * 0.26, -drop["radius"] * 0.3), drop["radius"] * 0.28, Color(0.58, 0.02, 0.01, 0.18))
		for grit in stain.get("grit", []):
			var grit_origin: Vector2 = origin + grit["offset"]
			draw_circle(grit_origin, grit["radius"], Color(0.58, 0.2, 0.1, grit["alpha"]))

	for pulse in _pulses:
		var t: float = pulse["age"] / pulse["life"]
		var color: Color = pulse["color"]
		color.a *= 1.0 - t
		draw_arc(pulse["origin"], lerpf(8.0, pulse["radius"], t), 0.0, TAU, TRANSIENT_PULSE_ARC_SEGMENTS, color, pulse["width"])

	for burst_data in _rusher_defeat_bursts:
		var t: float = burst_data["age"] / burst_data["life"]
		var origin: Vector2 = burst_data["origin"]
		var direction: Vector2 = burst_data["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var amber := Color(1.0, 0.58, 0.16, 0.38 * alpha)
		var red_dust := Color(0.72, 0.08, 0.035, 0.34 * alpha)
		var dark_dust := Color(0.055, 0.025, 0.012, 0.22 * alpha)
		var fan_reach := lerpf(22.0, 88.0, t)
		var fan_width := lerpf(30.0, 76.0, t)
		var fan := PackedVector2Array([
			origin - direction * 10.0,
			origin - direction * fan_reach + side * fan_width,
			origin - direction * (fan_reach + 24.0),
			origin - direction * fan_reach - side * fan_width,
		])
		draw_colored_polygon(fan, red_dust)
		draw_arc(origin, lerpf(16.0, 74.0, t), direction.angle() + PI - 0.84, direction.angle() + PI + 0.84, 32, amber, lerpf(8.0, 2.0, t))
		for i in range(3):
			var spread := float(i - 1) * 18.0
			var spark_origin := origin - direction * lerpf(18.0, 62.0, t) + side * spread
			draw_circle(spark_origin, lerpf(7.0, 2.0, t), amber.lightened(0.22))
			draw_circle(spark_origin + direction * 7.0, lerpf(11.0, 3.0, t), dark_dust)

	for spark in _enemy_hit_sparks:
		var t: float = spark["age"] / spark["life"]
		var origin: Vector2 = spark["origin"]
		var direction: Vector2 = spark["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var accent: Color = spark["accent"]
		var brass := Color(1.0, 0.68, 0.24, 0.72 * alpha)
		var bone := Color(1.0, 0.92, 0.68, 0.66 * alpha)
		var blood := Color(0.82, 0.045, 0.025, 0.44 * alpha)
		var dust := Color(0.22, 0.1, 0.038, 0.26 * alpha)
		var reach := lerpf(12.0, 54.0, t)
		draw_circle(origin - direction * lerpf(3.0, 14.0, t), lerpf(12.0, 3.0, t), dust)
		_draw_flat_dust_ellipse(origin - direction * lerpf(8.0, 30.0, t), Vector2(28.0, 7.0) * (1.0 - t * 0.35), Color(0.08, 0.032, 0.012, 0.16 * alpha), 16)
		draw_arc(origin, lerpf(9.0, 34.0, t), direction.angle() + PI - 0.82, direction.angle() + PI + 0.82, 18, accent.lightened(0.18), lerpf(5.0, 1.5, t))
		draw_arc(origin - direction * 3.0, lerpf(6.0, 26.0, t), direction.angle() - 0.58, direction.angle() + 0.58, 18, bone, lerpf(3.5, 0.9, t))
		_draw_enemy_hit_role_glyph(origin, direction, side, str(spark.get("kind", "")), accent, bone, alpha, t)
		for i in range(3):
			var spread := float(i - 1) * 10.0
			var start := origin + side * spread - direction * 4.0
			var end := origin - direction * (reach + float(i) * 6.0) + side * (spread * 1.8)
			draw_line(start, end, brass if i != 1 else bone, lerpf(4.0, 1.2, t))
			draw_circle(end, lerpf(3.4, 1.1, t), bone)
		if str(spark.get("kind", "")) == "shotgun_brute":
			draw_line(origin - side * 19.0, origin - direction * reach - side * 34.0, blood, lerpf(7.0, 1.6, t))
			draw_line(origin + side * 19.0, origin - direction * reach + side * 34.0, blood, lerpf(7.0, 1.6, t))
		elif str(spark.get("kind", "")) == "duelist":
			draw_line(origin + side * 18.0, origin - direction * (reach + 18.0), accent.lightened(0.35), lerpf(5.0, 1.2, t))
			draw_line(origin - side * 18.0, origin - direction * (reach + 18.0), accent.lightened(0.35), lerpf(5.0, 1.2, t))
		else:
			draw_circle(origin - direction * reach + side * 14.0, lerpf(5.0, 1.2, t), blood)
			draw_circle(origin - direction * reach - side * 10.0, lerpf(4.0, 1.0, t), accent)

	for clang in _parry_clangs:
		var t: float = clang["age"] / clang["life"]
		var origin: Vector2 = clang["origin"]
		var direction: Vector2 = clang["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var brass := Color(1.0, 0.72, 0.24, 0.78 * alpha)
		var bone := Color(1.0, 0.94, 0.68, 0.72 * alpha)
		var iron := Color(0.1, 0.07, 0.045, 0.36 * alpha)
		var denim := Color(0.18, 0.32, 0.45, 0.26 * alpha)
		var radius := lerpf(18.0, 68.0, t)
		draw_circle(origin + direction * 7.0, lerpf(18.0, 6.0, t), iron)
		draw_arc(origin, radius, direction.angle() - 1.22, direction.angle() + 1.22, 28, brass, lerpf(7.0, 1.8, t))
		draw_arc(origin, radius * 0.72, direction.angle() + PI - 0.74, direction.angle() + PI + 0.74, 22, denim, lerpf(5.0, 1.4, t))
		var blade_a := origin - side * lerpf(34.0, 52.0, t) - direction * lerpf(9.0, 22.0, t)
		var blade_b := origin + side * lerpf(34.0, 52.0, t) + direction * lerpf(9.0, 22.0, t)
		var blade_c := origin + side * lerpf(24.0, 44.0, t) - direction * lerpf(18.0, 36.0, t)
		var blade_d := origin - side * lerpf(24.0, 44.0, t) + direction * lerpf(18.0, 36.0, t)
		draw_line(blade_a, blade_b, bone, lerpf(6.0, 1.5, t))
		draw_line(blade_c, blade_d, brass.lightened(0.18), lerpf(4.5, 1.2, t))
		for i in range(4):
			var sign := -1.0 if i % 2 == 0 else 1.0
			var spark_origin := origin + side * sign * lerpf(12.0, 48.0, t) + direction * float(i - 1) * lerpf(8.0, 15.0, t)
			draw_line(spark_origin, spark_origin + side * sign * lerpf(11.0, 22.0, t) - direction * lerpf(5.0, 18.0, t), brass, lerpf(3.5, 1.0, t))
			draw_circle(spark_origin, lerpf(3.6, 1.0, t), bone)

	for hit_flash in _player_hit_flashes:
		var t: float = hit_flash["age"] / hit_flash["life"]
		var origin: Vector2 = hit_flash["origin"]
		var direction: Vector2 = hit_flash["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var blood := Color(0.88, 0.035, 0.025, 0.62 * alpha)
		var dark_blood := Color(0.28, 0.018, 0.01, 0.42 * alpha)
		var dust := Color(0.24, 0.12, 0.055, 0.3 * alpha)
		var bone := Color(1.0, 0.88, 0.58, 0.38 * alpha)
		var denim := Color(0.16, 0.3, 0.44, 0.22 * alpha)
		var brass := Color(1.0, 0.68, 0.24, 0.5 * alpha)
		var leather := Color(0.05, 0.02, 0.01, 0.34 * alpha)
		var drag := lerpf(12.0, 70.0, t)
		var fan := PackedVector2Array([
			origin - direction * 8.0,
			origin - direction * drag + side * lerpf(12.0, 34.0, t),
			origin - direction * (drag + 22.0),
			origin - direction * drag - side * lerpf(12.0, 34.0, t),
		])
		draw_colored_polygon(fan, dust)
		_draw_flat_dust_ellipse(origin + direction * 4.0 + Vector2(0.0, 25.0), Vector2(42.0, 10.0) * (1.0 - t * 0.28), Color(0.06, 0.025, 0.01, 0.18 * alpha), 18)
		draw_line(origin + side * 14.0, origin - direction * drag + side * 32.0, blood, lerpf(7.0, 1.5, t))
		draw_line(origin - side * 12.0, origin - direction * (drag + 12.0) - side * 26.0, dark_blood, lerpf(6.0, 1.4, t))
		draw_arc(origin, lerpf(14.0, 46.0, t), direction.angle() + PI - 0.7, direction.angle() + PI + 0.7, 22, blood, lerpf(6.0, 1.5, t))
		draw_arc(origin + direction * 5.0, lerpf(18.0, 58.0, t), direction.angle() - 0.9, direction.angle() + 0.9, 24, denim, lerpf(5.0, 1.2, t))
		draw_arc(origin - direction * 7.0, lerpf(20.0, 66.0, t), direction.angle() + PI - 0.45, direction.angle() + PI + 0.45, 22, brass, lerpf(4.5, 1.0, t))
		draw_line(origin - side * 18.0 + direction * 3.0, origin + side * 18.0 - direction * 4.0, leather, lerpf(8.0, 1.8, t))
		draw_line(origin + side * 10.0 - direction * 10.0, origin + side * 32.0 - direction * lerpf(24.0, 62.0, t), brass, lerpf(4.4, 1.0, t))
		draw_line(origin - side * 10.0 - direction * 6.0, origin - side * 30.0 - direction * lerpf(20.0, 54.0, t), bone, lerpf(3.4, 0.9, t))
		for shard in range(4):
			var shard_side := side * float(shard - 1.5) * lerpf(7.0, 16.0, t)
			var shard_origin := origin - direction * lerpf(10.0, 44.0, t) + shard_side
			draw_line(shard_origin, shard_origin - direction * lerpf(10.0, 24.0, t) + side * float(shard % 2 * 2 - 1) * 7.0, brass if shard % 2 == 0 else bone, lerpf(2.6, 0.8, t))
		for i in range(3):
			var spread := float(i - 1) * 12.0
			var drop_origin := origin - direction * lerpf(18.0, 58.0, t) + side * spread
			draw_circle(drop_origin, lerpf(4.2, 1.2, t), blood if i != 1 else bone)
			draw_circle(drop_origin + direction * 5.0, lerpf(6.0, 1.4, t), dust)

	for dust_data in _enemy_movement_dust:
		var t: float = dust_data["age"] / dust_data["life"]
		var origin: Vector2 = dust_data["origin"]
		var direction: Vector2 = dust_data["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var speed_scale: float = dust_data.get("speed_scale", 1.0)
		var accent: Color = dust_data.get("accent", Color(0.74, 0.42, 0.16, 0.2))
		accent.a *= 0.36 * alpha
		var dark := Color(0.12, 0.052, 0.02, 0.18 * alpha)
		var tan := Color(0.72, 0.46, 0.2, 0.2 * alpha)
		var drift := lerpf(5.0, 32.0 + speed_scale * 12.0, t)
		var spread := lerpf(8.0, 22.0 + speed_scale * 6.0, t)
		_draw_flat_dust_ellipse(origin - direction * drift, Vector2(spread, 5.0 + speed_scale * 2.0), dark)
		_draw_flat_dust_ellipse(origin - direction * (drift * 0.58) + side * 8.0, Vector2(spread * 0.55, 3.5), tan)
		draw_line(origin + side * 9.0, origin - direction * (22.0 + speed_scale * 8.0) + side * 3.0, accent, lerpf(4.0, 1.0, t))
		draw_line(origin - side * 7.0, origin - direction * (18.0 + speed_scale * 6.0) - side * 5.0, Color(0.09, 0.038, 0.014, 0.16 * alpha), lerpf(3.2, 0.9, t))
		for i in range(2):
			var mote := origin - direction * lerpf(8.0, 38.0, t) + side * float(i * 2 - 1) * lerpf(5.0, 15.0, t)
			draw_circle(mote, lerpf(2.8, 0.9, t), accent.lightened(0.15))

	for glint in _dash_ready_glints:
		var t: float = glint["age"] / glint["life"]
		var origin: Vector2 = glint["origin"]
		var direction: Vector2 = glint["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var denim := Color(0.19, 0.36, 0.49, 0.42 * alpha)
		var brass := Color(1.0, 0.72, 0.24, 0.55 * alpha)
		var reach := lerpf(34.0, 82.0, t)
		draw_arc(origin, lerpf(26.0, 58.0, t), direction.angle() - 0.95, direction.angle() + 0.95, 26, denim, lerpf(7.0, 2.0, t))
		var arrow_tip := origin + direction * reach
		var arrow_tail := origin + direction * lerpf(16.0, 42.0, t)
		draw_line(arrow_tail, arrow_tip, brass, lerpf(6.0, 2.0, t))
		draw_line(arrow_tip, arrow_tip - direction * 16.0 + side * 10.0, brass, lerpf(5.0, 1.5, t))
		draw_line(arrow_tip, arrow_tip - direction * 16.0 - side * 10.0, brass, lerpf(5.0, 1.5, t))

	for prompt in _dash_ready_prompts:
		var t: float = prompt["age"] / prompt["life"]
		var origin: Vector2 = prompt["origin"]
		var direction: Vector2 = prompt["direction"]
		var side := direction.orthogonal()
		var alpha := sin(minf(1.0, 1.0 - t) * PI) if t > 0.62 else 1.0
		var brass := Color(1.0, 0.72, 0.24, 0.78 * alpha)
		var bone := Color(0.94, 0.86, 0.68, 0.92 * alpha)
		var leather := Color(0.07, 0.03, 0.014, 0.72 * alpha)
		var prompt_origin: Vector2 = origin - side * 36.0 - direction * 18.0 + Vector2(0.0, -58.0)
		var key_rect := Rect2(prompt_origin + Vector2(-34.0, -16.0), Vector2(68.0, 30.0))
		draw_rect(Rect2(key_rect.position + Vector2(4.0, 5.0), key_rect.size), Color(0.0, 0.0, 0.0, 0.22 * alpha), true)
		draw_rect(key_rect, leather, true)
		draw_rect(key_rect, brass, false, 2.0)
		draw_line(key_rect.position + Vector2(9.0, key_rect.size.y - 7.0), key_rect.end - Vector2(9.0, 7.0), Color(1.0, 0.84, 0.48, 0.42 * alpha), 2.0)
		draw_string(ThemeDB.fallback_font, key_rect.position + Vector2(10.0, 21.0), "SPACE", HORIZONTAL_ALIGNMENT_CENTER, key_rect.size.x - 20.0, 14, bone)
		var arrow_tail := prompt_origin + Vector2(0.0, 28.0)
		var arrow_tip := arrow_tail + direction * 68.0
		draw_line(arrow_tail, arrow_tip, brass, 5.0)
		draw_line(arrow_tip, arrow_tip - direction * 16.0 + side * 10.0, brass, 4.0)
		draw_line(arrow_tip, arrow_tip - direction * 16.0 - side * 10.0, brass, 4.0)
		draw_circle(arrow_tail - direction * 8.0, 5.0, bone)

	for puff in _rifle_warning_puffs:
		var t: float = puff["age"] / puff["life"]
		var origin: Vector2 = puff["origin"]
		var direction: Vector2 = puff["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var amber := Color(1.0, 0.62, 0.18, 0.5 * alpha)
		var dark := Color(0.12, 0.05, 0.018, 0.32 * alpha)
		var brass := Color(1.0, 0.78, 0.34, 0.46 * alpha)
		var bracket_reach := lerpf(18.0, 42.0, t)
		draw_line(origin - side * 18.0, origin - side * 7.0 + direction * bracket_reach, amber, lerpf(5.0, 1.5, t))
		draw_line(origin + side * 18.0, origin + side * 7.0 + direction * bracket_reach, amber, lerpf(5.0, 1.5, t))
		draw_line(origin - side * 11.0 + direction * 6.0, origin + side * 11.0 + direction * 6.0, dark, lerpf(4.0, 1.0, t))
		for i in range(3):
			var spread := float(i - 1) * 10.0
			var dust_origin := origin - direction * lerpf(4.0, 28.0, t) + side * spread
			draw_circle(dust_origin, lerpf(7.0, 2.0, t), dark)
			draw_circle(dust_origin + direction * 5.0, lerpf(4.0, 1.5, t), brass)

	for rideout in _extraction_rideouts:
		var t: float = rideout["age"] / rideout["life"]
		var start: Vector2 = rideout["start"]
		var end: Vector2 = rideout["end"]
		var direction: Vector2 = rideout["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var trail_head := start.lerp(end, clampf(t * 1.24, 0.0, 1.0))
		var amber := Color(1.0, 0.68, 0.2, 0.42 * alpha)
		var brass := Color(1.0, 0.82, 0.34, 0.62 * alpha)
		var dust := Color(0.28, 0.12, 0.04, 0.22 * alpha)
		draw_line(start + side * 14.0, trail_head + side * 14.0, dust, lerpf(15.0, 4.0, t))
		draw_line(start - side * 14.0, trail_head - side * 14.0, dust, lerpf(15.0, 4.0, t))
		draw_line(start, trail_head, amber, lerpf(9.0, 2.0, t))
		for i in range(5):
			var marker_t := clampf(t * 1.18 - float(i) * 0.11, 0.0, 1.0)
			var marker := start.lerp(end, marker_t)
			var marker_alpha := clampf(alpha - float(i) * 0.08, 0.0, 1.0)
			var marker_color := brass
			marker_color.a *= marker_alpha
			draw_line(marker - direction * 22.0 + side * 15.0, marker + direction * 12.0, marker_color, lerpf(6.0, 1.6, t))
			draw_line(marker - direction * 22.0 - side * 15.0, marker + direction * 12.0, marker_color, lerpf(6.0, 1.6, t))
			draw_circle(marker - direction * 18.0, lerpf(8.0, 2.0, t), dust)
		draw_arc(end, lerpf(34.0, 88.0, t), direction.angle() - 0.62, direction.angle() + 0.62, 28, brass, lerpf(8.0, 2.0, t))

	for reload_glint in _reload_ready_glints:
		var t: float = reload_glint["age"] / reload_glint["life"]
		var origin: Vector2 = reload_glint["origin"]
		var direction: Vector2 = reload_glint["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var brass := Color(1.0, 0.78, 0.3, 0.82 * alpha)
		var bone := Color(1.0, 0.93, 0.68, 0.88 * alpha)
		var denim := Color(0.2, 0.38, 0.52, 0.38 * alpha)
		draw_circle(origin, lerpf(22.0, 10.0, t), Color(0.12, 0.055, 0.02, 0.26 * alpha))
		draw_arc(origin, lerpf(24.0, 64.0, t), 0.0, TAU, 40, brass, lerpf(9.0, 2.4, t))
		draw_arc(origin, lerpf(14.0, 34.0, t), -0.4, PI * 1.4, 28, bone, lerpf(5.0, 1.6, t))
		for i in range(6):
			var angle := float(i) / 6.0 * TAU + t * 0.45
			var chamber := origin + Vector2.RIGHT.rotated(angle) * lerpf(18.0, 38.0, t)
			draw_circle(chamber, lerpf(6.4, 2.2, t), brass)
			draw_circle(chamber, lerpf(3.6, 1.4, t), bone)
		var streak_start := origin + direction * 18.0
		var streak_end := origin + direction * lerpf(54.0, 112.0, t)
		draw_line(streak_start - side * 12.0, streak_end - side * 8.0, denim, lerpf(8.0, 2.4, t))
		draw_line(streak_start + side * 10.0, streak_end + side * 6.0, denim, lerpf(8.0, 2.4, t))
		draw_line(streak_start, streak_end, brass, lerpf(6.0, 1.8, t))
		draw_line(streak_start + side * 4.0, streak_end + side * 3.0, bone, lerpf(3.0, 1.0, t))
		draw_line(streak_end, streak_end - direction * 16.0 + side * 10.0, brass, lerpf(4.0, 1.2, t))
		draw_line(streak_end, streak_end - direction * 16.0 - side * 10.0, brass, lerpf(4.0, 1.2, t))

	for spin in _empty_reload_spins:
		var t: float = spin["age"] / spin["life"]
		var origin: Vector2 = spin["origin"]
		var direction: Vector2 = spin["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var amber := Color(1.0, 0.5, 0.12, 0.58 * alpha)
		var brass := Color(1.0, 0.76, 0.26, 0.62 * alpha)
		var dark := Color(0.16, 0.055, 0.018, 0.28 * alpha)
		var radius := lerpf(22.0, 44.0, t)
		draw_arc(origin, radius, t * TAU * 1.8, t * TAU * 1.8 + PI * 1.45, 28, amber, lerpf(6.0, 2.0, t))
		for i in range(3):
			var angle := t * TAU * 1.8 + float(i) * TAU / 3.0
			var chamber := origin + Vector2.RIGHT.rotated(angle) * lerpf(13.0, 25.0, t)
			draw_circle(chamber, lerpf(4.2, 1.8, t), brass)
		draw_line(origin - direction * 18.0 - side * 12.0, origin + direction * 30.0 + side * 8.0, dark, lerpf(6.0, 1.5, t))
		draw_line(origin - direction * 12.0 + side * 12.0, origin + direction * 36.0 - side * 8.0, amber, lerpf(4.0, 1.2, t))

	for cast_glint in _ability_cast_glints:
		var t: float = cast_glint["age"] / cast_glint["life"]
		var origin: Vector2 = cast_glint["origin"]
		var direction: Vector2 = cast_glint["direction"]
		var side := direction.orthogonal()
		var color: Color = cast_glint["color"]
		var program_id := str(cast_glint.get("program_id", ""))
		var alpha := 1.0 - t
		var brass := Color(1.0, 0.76, 0.26, 0.52 * alpha)
		var bone := Color(1.0, 0.92, 0.62, 0.42 * alpha)
		var dust := Color(0.22, 0.1, 0.035, 0.18 * alpha)
		var accent := color.lightened(0.26)
		accent.a = 0.34 * alpha
		_draw_flat_dust_ellipse(origin + Vector2(10.0, 28.0), Vector2(52.0 + t * 20.0, 14.0 + t * 5.0), dust, 24)
		draw_arc(origin, lerpf(24.0, 76.0, t), direction.angle() - PI * 0.78, direction.angle() + PI * 0.78, 42, accent, lerpf(8.0, 1.6, t))
		draw_arc(origin, lerpf(14.0, 54.0, t), direction.angle() + PI * 0.25, direction.angle() + PI * 1.35, 34, brass, lerpf(5.0, 1.2, t))
		for i in range(6):
			var angle := direction.angle() + float(i) * TAU / 6.0 + t * 0.55
			var spoke := Vector2.RIGHT.rotated(angle)
			var inner := origin + spoke * lerpf(18.0, 32.0, t)
			var outer := origin + spoke * lerpf(36.0, 66.0, t)
			draw_line(inner, outer, brass if i % 2 == 0 else bone, lerpf(4.0, 0.9, t))
			draw_circle(outer, lerpf(3.2, 1.0, t), bone)
		var sigil_reach := lerpf(32.0, 84.0, t)
		if program_id == "dust_veil" or program_id == "ghost_step":
			for i in range(4):
				var veil_dir := direction.rotated(lerpf(-0.7, 0.7, float(i) / 3.0))
				draw_line(origin - veil_dir * 10.0 + side * float(i - 1.5) * 8.0, origin - veil_dir * sigil_reach + side * float(i - 1.5) * 20.0, Color(0.76, 0.58, 0.34, 0.24 * alpha), lerpf(7.0, 1.5, t))
		elif program_id == "ricochet_shot" or program_id == "fan_hammer":
			for i in range(3):
				var bounce := origin + direction * (28.0 + float(i) * 20.0) + side * sin(float(i) * 2.1) * 30.0
				draw_line(origin + direction * 14.0, bounce, Color(1.0, 0.5, 0.12, 0.24 * alpha), lerpf(5.0, 1.1, t))
				draw_circle(bounce, lerpf(6.0, 1.6, t), brass)
		else:
			draw_line(origin + direction * 12.0 - side * 12.0, origin + direction * sigil_reach - side * 5.0, bone, lerpf(5.0, 1.2, t))
			draw_line(origin + direction * 12.0 + side * 12.0, origin + direction * sigil_reach + side * 5.0, brass, lerpf(5.0, 1.2, t))
			draw_line(origin + direction * sigil_reach, origin + direction * (sigil_reach - 18.0) + side * 13.0, brass, lerpf(4.0, 1.0, t))
			draw_line(origin + direction * sigil_reach, origin + direction * (sigil_reach - 18.0) - side * 13.0, brass, lerpf(4.0, 1.0, t))

	for afterimage in _saber_afterimages:
		var t: float = afterimage["age"] / afterimage["life"]
		var origin: Vector2 = afterimage["origin"]
		var base_angle: float = afterimage["angle"]
		var arc: float = afterimage["arc"]
		var reach: float = afterimage["range"]
		var alpha := 1.0 - t
		var start_angle := base_angle - arc * 0.5
		var end_angle := base_angle + arc * 0.5
		var ember := Color(1.0, 0.66, 0.25, 0.24 * alpha)
		var bone := Color(1.0, 0.92, 0.66, 0.54 * alpha)
		var white_hot := Color(1.0, 0.98, 0.82, 0.7 * alpha)
		var dust := Color(0.3, 0.12, 0.04, 0.18 * alpha)
		var side_angle := base_angle + PI * 0.5
		var dust_center := origin + Vector2.RIGHT.rotated(base_angle) * reach * lerpf(0.22, 0.46, t)
		draw_line(dust_center - Vector2.RIGHT.rotated(side_angle) * 34.0, dust_center + Vector2.RIGHT.rotated(side_angle) * 28.0, dust, lerpf(15.0, 3.0, t))
		draw_arc(origin, reach + lerpf(8.0, 24.0, t), start_angle, end_angle, 40, ember, lerpf(13.0, 4.0, t))
		draw_arc(origin, reach * 0.82 + lerpf(4.0, 14.0, t), start_angle + arc * 0.09, end_angle - arc * 0.09, 34, bone, lerpf(7.0, 2.0, t))
		draw_arc(origin, reach * 0.58 + lerpf(2.0, 9.0, t), start_angle + arc * 0.22, end_angle - arc * 0.22, 22, white_hot, lerpf(4.0, 1.0, t))
		var end_dir := Vector2.RIGHT.rotated(end_angle)
		var cut_tip := origin + end_dir * (reach + 8.0)
		draw_line(cut_tip - end_dir * 34.0, cut_tip + end_dir * 18.0, white_hot, maxf(1.0, 5.0 * alpha))

	for beam_data in _beams:
		var t: float = beam_data["age"] / beam_data["life"]
		var color: Color = beam_data["color"]
		color.a *= 1.0 - t
		draw_line(beam_data["from"], beam_data["to"], color, lerpf(8.0, 1.0, t))

	for burst_data in _enemy_weapon_bursts:
		var t: float = burst_data["age"] / burst_data["life"]
		var origin: Vector2 = burst_data["origin"]
		var direction: Vector2 = burst_data["direction"]
		var side := direction.orthogonal()
		var alpha := 1.0 - t
		var kind := str(burst_data.get("kind", "rifle"))
		var amber := Color(1.0, 0.52, 0.12, 0.58 * alpha)
		var bone := Color(1.0, 0.9, 0.56, 0.7 * alpha)
		var brass := Color(1.0, 0.72, 0.24, 0.48 * alpha)
		var smoke := Color(0.14, 0.06, 0.024, 0.26 * alpha)
		if kind == "shotgun":
			var spread := 0.54
			var reach := lerpf(38.0, 142.0, t)
			var left_dir := direction.rotated(-spread)
			var right_dir := direction.rotated(spread)
			var cone := PackedVector2Array([
				origin + direction * 12.0,
				origin + left_dir * reach,
				origin + direction * (reach + 28.0),
				origin + right_dir * reach,
			])
			draw_colored_polygon(cone, Color(0.9, 0.24, 0.055, 0.14 * alpha))
			draw_arc(origin + direction * 18.0, lerpf(22.0, 82.0, t), direction.angle() - spread, direction.angle() + spread, 34, amber, lerpf(8.0, 1.8, t))
			for i in range(5):
				var pellet_dir := direction.rotated(lerpf(-spread, spread, float(i) / 4.0))
				draw_line(origin + pellet_dir * 18.0, origin + pellet_dir * lerpf(70.0, 190.0, t), brass if i % 2 == 0 else bone, lerpf(4.0, 1.0, t))
			for i in range(5):
				var puff_origin := origin - direction * lerpf(3.0, 34.0, t) + side * float(i - 2) * lerpf(10.0, 22.0, t)
				draw_circle(puff_origin, lerpf(10.0, 2.6, t), smoke)
			for i in range(2):
				var shell_origin := origin - direction * lerpf(8.0, 38.0, t) - side * lerpf(18.0, 42.0, t) + side * float(i) * 14.0
				draw_line(shell_origin, shell_origin - side * 12.0 + direction * 5.0, brass, lerpf(4.0, 1.2, t))
		else:
			var reach := lerpf(34.0, 92.0, t)
			draw_line(origin + direction * 7.0, origin + direction * (reach + 16.0), bone, lerpf(4.5, 1.1, t))
			draw_line(origin + direction * 8.0 + side * 7.0, origin + direction * reach + side * lerpf(18.0, 4.0, t), amber, lerpf(3.5, 1.0, t))
			draw_line(origin + direction * 8.0 - side * 7.0, origin + direction * reach - side * lerpf(18.0, 4.0, t), amber, lerpf(3.5, 1.0, t))
			draw_arc(origin + direction * 18.0, lerpf(13.0, 42.0, t), direction.angle() - 0.48, direction.angle() + 0.48, 20, brass, lerpf(3.5, 1.0, t))
			for i in range(3):
				var puff_origin := origin - direction * lerpf(4.0, 30.0, t) + side * float(i - 1) * lerpf(8.0, 18.0, t)
				draw_circle(puff_origin, lerpf(6.5, 2.0, t), smoke)
			var casing_origin := origin - direction * lerpf(6.0, 28.0, t) - side * lerpf(14.0, 35.0, t)
			draw_line(casing_origin, casing_origin - side * 10.0 + direction * 6.0, brass, lerpf(2.8, 0.9, t))

	for flash in _muzzle_flashes:
		var t: float = flash["age"] / flash["life"]
		var direction: Vector2 = flash["direction"]
		var side := direction.orthogonal()
		var color: Color = flash["color"]
		var origin: Vector2 = flash["origin"]
		var alpha := 1.0 - t
		var amber := Color(1.0, 0.56, 0.12, 0.74 * alpha)
		var bone := Color(1.0, 0.94, 0.64, 0.82 * alpha)
		var brass := Color(1.0, 0.72, 0.24, 0.58 * alpha)
		var smoke := Color(0.18, 0.08, 0.032, 0.24 * alpha)
		var heat := Color(1.0, 0.82, 0.42, 0.16 * alpha)
		var soot := Color(0.05, 0.02, 0.008, 0.2 * alpha)
		color.a *= 0.46 * alpha
		var reach: float = lerpf(28.0, 70.0, t)
		var width: float = lerpf(24.0, 4.0, t)
		var points := PackedVector2Array([
			origin + direction * 10.0,
			origin + direction * reach + side * width,
			origin + direction * (reach + 22.0),
			origin + direction * reach - side * width,
		])
		draw_colored_polygon(points, color)
		var shimmer_outer := origin + direction * (reach + 10.0)
		var shimmer_inner := origin + direction * 16.0
		draw_line(shimmer_inner + side * width * 0.72, shimmer_outer + side * lerpf(12.0, 3.0, t), heat, lerpf(2.4, 0.7, t))
		draw_line(shimmer_inner - side * width * 0.72, shimmer_outer - side * lerpf(12.0, 3.0, t), heat, lerpf(2.4, 0.7, t))
		_draw_flat_dust_ellipse(origin - direction * lerpf(8.0, 26.0, t) + Vector2(0.0, 13.0), Vector2(20.0, 4.5) * (1.0 - t * 0.22), soot, 14)
		var star_center := origin + direction * lerpf(18.0, 32.0, t)
		draw_line(star_center - side * lerpf(18.0, 5.0, t), star_center + side * lerpf(18.0, 5.0, t), bone, lerpf(4.0, 0.9, t))
		draw_line(star_center - direction * lerpf(15.0, 4.0, t), star_center + direction * lerpf(20.0, 6.0, t), bone, lerpf(3.2, 0.8, t))
		draw_line(origin + direction * 5.0, origin + direction * (reach + 29.0), bone, lerpf(5.0, 1.4, t))
		draw_line(origin + direction * 7.0 + side * 5.0, origin + direction * (reach * 0.82) + side * lerpf(17.0, 5.0, t), amber, lerpf(4.0, 1.0, t))
		draw_line(origin + direction * 7.0 - side * 5.0, origin + direction * (reach * 0.82) - side * lerpf(17.0, 5.0, t), amber, lerpf(4.0, 1.0, t))
		draw_arc(origin + direction * lerpf(8.0, 20.0, t), lerpf(16.0, 42.0, t), direction.angle() - 0.72, direction.angle() + 0.72, 24, brass, lerpf(4.5, 1.0, t))
		for i in range(3):
			var smoke_origin := origin - direction * lerpf(5.0, 34.0, t) + side * float(i - 1) * lerpf(9.0, 19.0, t)
			draw_circle(smoke_origin, lerpf(7.0, 2.2, t), smoke)
		for i in range(2):
			var casing_origin: Vector2 = flash.get("casing_origin", origin) - direction * lerpf(5.0, 30.0, t) + side * float(i * 2 - 1) * lerpf(16.0, 34.0, t)
			var casing_end := casing_origin + side * float(i * 2 - 1) * 8.0 + direction * lerpf(2.0, 10.0, t)
			draw_line(casing_origin + Vector2(2.0, 4.0), casing_end + Vector2(2.0, 4.0), soot, lerpf(3.4, 0.9, t))
			draw_line(casing_origin, casing_end, brass, lerpf(3.0, 1.0, t))
			draw_circle(casing_end, lerpf(2.2, 0.8, t), Color(1.0, 0.86, 0.48, 0.52 * alpha))

	for text_data in _impact_texts:
		var t: float = text_data["age"] / text_data["life"]
		var color: Color = text_data["color"]
		color.a *= 1.0 - t
		var origin: Vector2 = text_data["origin"] + Vector2(0.0, -lerpf(0.0, text_data["rise"], t))
		var font := ThemeDB.fallback_font
		var size: int = int(lerpf(text_data["size"] + 4.0, text_data["size"], t))
		var width := 180.0
		draw_string(font, origin + Vector2(-width * 0.5 + 3.0, 3.0), text_data["text"], HORIZONTAL_ALIGNMENT_CENTER, width, size, Color(0.04, 0.018, 0.006, color.a * 0.72))
		draw_string(font, origin + Vector2(-width * 0.5, 0.0), text_data["text"], HORIZONTAL_ALIGNMENT_CENTER, width, size, color)

func _draw_enemy_hit_role_glyph(origin: Vector2, direction: Vector2, side: Vector2, kind: String, accent: Color, bone: Color, alpha: float, t: float) -> void:
	var center := origin - direction * lerpf(10.0, 32.0, t) + side * lerpf(15.0, 27.0, t)
	var glyph_alpha := 0.66 * alpha
	var dark := Color(0.035, 0.014, 0.006, 0.3 * alpha)
	var brass := accent.lightened(0.22)
	brass.a = glyph_alpha
	bone.a = 0.58 * alpha
	match kind:
		"rifleman":
			draw_line(center - side * 16.0, center + side * 19.0, dark, lerpf(4.5, 1.2, t))
			draw_line(center - side * 14.0, center + side * 16.0, brass, lerpf(2.6, 0.8, t))
			draw_circle(center + side * 20.0, lerpf(3.2, 1.0, t), bone)
		"shotgun_brute":
			draw_line(center - side * 18.0, center + direction * 12.0, dark, lerpf(5.0, 1.3, t))
			draw_line(center + side * 18.0, center + direction * 12.0, dark, lerpf(5.0, 1.3, t))
			draw_line(center - side * 16.0, center + direction * 10.0, brass, lerpf(2.8, 0.9, t))
			draw_line(center + side * 16.0, center + direction * 10.0, brass, lerpf(2.8, 0.9, t))
		"duelist":
			var badge := PackedVector2Array()
			for point in range(8):
				var radius := lerpf(8.0, 3.0, t) if point % 2 == 0 else lerpf(4.5, 1.6, t)
				var angle := -PI * 0.5 + float(point) * TAU / 8.0
				badge.append(center + Vector2(cos(angle), sin(angle)) * radius)
			draw_colored_polygon(badge, Color(0.08, 0.03, 0.012, 0.26 * alpha))
			draw_polyline(badge, brass, lerpf(1.8, 0.7, t), true)
			draw_circle(center, lerpf(2.8, 1.0, t), bone)
		"hunter":
			for i in range(3):
				var offset := float(i - 1) * 6.0
				draw_line(center + side * offset - direction * 9.0, center + side * (offset + 8.0) + direction * 10.0, dark, lerpf(3.8, 1.0, t))
				draw_line(center + side * offset - direction * 7.0, center + side * (offset + 7.0) + direction * 8.0, brass, lerpf(2.0, 0.7, t))
		_:
			draw_line(center - side * 13.0 + direction * 7.0, center + side * 12.0 - direction * 8.0, dark, lerpf(4.0, 1.1, t))
			draw_line(center - side * 11.0 + direction * 6.0, center + side * 10.0 - direction * 7.0, brass, lerpf(2.3, 0.8, t))
			draw_circle(center + side * 11.0 - direction * 8.0, lerpf(2.4, 0.8, t), bone)

func burst(origin: Vector2, color: Color, count: int) -> void:
	for i in range(count):
		_append_transient_pulse({
			"origin": origin + Vector2.RIGHT.rotated(randf() * TAU) * randf_range(4.0, 32.0),
			"radius": randf_range(28.0, 96.0),
			"life": randf_range(0.18, 0.42),
			"age": 0.0,
			"color": color,
			"width": randf_range(1.0, 3.0),
		})
	_request_transient_redraw()

func _append_transient_pulse(pulse: Dictionary) -> void:
	_pulses.append(pulse)
	while _pulses.size() > MAX_TRANSIENT_PULSES:
		_pulses.pop_front()

func blood_spill(origin: Vector2, amount: int = 9) -> void:
	var direction := Vector2.RIGHT.rotated(randf() * TAU)
	var side := direction.orthogonal()
	var drops: Array[Dictionary] = []
	for i in range(amount):
		var forward := randf_range(-10.0, 52.0)
		var spread := randf_range(-32.0, 32.0) * (1.0 - clampf(forward / 80.0, 0.0, 0.42))
		drops.append({
			"offset": direction * forward + side * spread + Vector2.RIGHT.rotated(randf() * TAU) * randf_range(1.0, 9.0),
			"radius": randf_range(3.0, 13.0),
			"darken": randf_range(0.05, 0.38),
		})
	var streaks: Array[Dictionary] = []
	for i in range(3):
		streaks.append({
			"forward": randf_range(-12.0, 10.0),
			"side": randf_range(-18.0, 18.0),
			"length": randf_range(34.0, 78.0),
			"drift": randf_range(-20.0, 20.0),
			"width": randf_range(5.0, 11.0),
			"darken": randf_range(0.08, 0.32),
			"alpha": randf_range(0.42, 0.7),
		})
	var grit: Array[Dictionary] = []
	for i in range(7):
		grit.append({
			"offset": direction * randf_range(-18.0, 58.0) + side * randf_range(-38.0, 38.0),
			"radius": randf_range(1.2, 3.4),
			"alpha": randf_range(0.08, 0.18),
		})
	_blood_stain_total_count += 1
	_blood_stains.append({
		"origin": origin,
		"radius": randf_range(16.0, 30.0),
		"color": Color(0.36, 0.004, 0.002, 0.78),
		"texture": _blood_textures.pick_random() if not _blood_textures.is_empty() else null,
		"direction": direction,
		"soak_radius": randf_range(32.0, 52.0),
		"rotation": randf() * TAU,
		"scale": randf_range(0.38, 0.58),
		"squash": randf_range(0.72, 1.08),
		"drops": drops,
		"streaks": streaks,
		"grit": grit,
	})
	while _blood_stains.size() > MAX_BLOOD_STAINS:
		_blood_stains.pop_front()
	_request_transient_redraw()

func get_blood_stain_count() -> int:
	return _blood_stains.size()

func get_blood_stain_total_count() -> int:
	return _blood_stain_total_count

func get_blood_stain_visual_version() -> String:
	return BLOOD_STAIN_VISUAL_VERSION

func get_blood_stain_material_marker_count() -> int:
	return 7

func clear_blood_stains() -> void:
	_blood_stains.clear()
	_request_transient_redraw(true)

func shockwave(origin: Vector2, color: Color) -> void:
	_append_transient_pulse({
		"origin": origin,
		"radius": 260.0,
		"life": 0.52,
		"age": 0.0,
		"color": color,
		"width": 7.0,
	})
	_request_transient_redraw()

func trail_pop(origin: Vector2, color: Color) -> void:
	_append_transient_pulse({
		"origin": origin,
		"radius": 110.0,
		"life": 0.24,
		"age": 0.0,
		"color": color,
		"width": 4.0,
	})
	_request_transient_redraw()

func saber_afterimage(origin: Vector2, direction: Vector2, slash_range: float, arc: float, hit_count: int = 1) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_saber_afterimages.append({
		"origin": origin,
		"angle": direction.angle(),
		"range": slash_range,
		"arc": arc,
		"life": 0.18 + minf(0.08, float(maxi(hit_count, 1)) * 0.018),
		"age": 0.0,
	})
	_request_transient_redraw()

func get_saber_afterimage_count() -> int:
	return _saber_afterimages.size()

func get_saber_afterimage_visual_version() -> String:
	return SABER_AFTERIMAGE_VISUAL_VERSION

func get_saber_afterimage_detail_marker_count() -> int:
	return 5

func get_transient_vfx_redraw_budget_version() -> String:
	return TRANSIENT_VFX_REDRAW_BUDGET_VERSION

func get_transient_vfx_redraw_interval() -> float:
	return TRANSIENT_VFX_REDRAW_INTERVAL

func get_transient_vfx_pulse_budget_version() -> String:
	return TRANSIENT_VFX_PULSE_BUDGET_VERSION

func get_max_transient_pulse_count() -> int:
	return MAX_TRANSIENT_PULSES

func get_transient_pulse_arc_segment_count() -> int:
	return TRANSIENT_PULSE_ARC_SEGMENTS

func rusher_defeat_burst(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_rusher_defeat_bursts.append({
		"origin": origin,
		"direction": direction,
		"life": 0.22,
		"age": 0.0,
	})
	burst(origin, Color(0.82, 0.22, 0.06), 5)
	_request_transient_redraw()

func get_rusher_defeat_burst_count() -> int:
	return _rusher_defeat_bursts.size()

func enemy_hit_spark(origin: Vector2, direction: Vector2, enemy_kind: String = "") -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	var accent := _get_enemy_hit_spark_accent(enemy_kind)
	_enemy_hit_spark_total_count += 1
	_enemy_hit_sparks.append({
		"origin": origin,
		"direction": direction,
		"kind": enemy_kind,
		"accent": accent,
		"life": 0.18,
		"age": 0.0,
	})
	while _enemy_hit_sparks.size() > MAX_ENEMY_HIT_SPARKS:
		_enemy_hit_sparks.pop_front()
	_request_transient_redraw()

func get_enemy_hit_spark_count() -> int:
	return _enemy_hit_sparks.size()

func get_enemy_hit_spark_total_count() -> int:
	return _enemy_hit_spark_total_count

func get_enemy_hit_spark_visual_version() -> String:
	return ENEMY_HIT_SPARK_VISUAL_VERSION

func get_enemy_hit_spark_material_marker_count() -> int:
	return 9

func parry_clang(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_parry_clang_total_count += 1
	_parry_clangs.append({
		"origin": origin,
		"direction": direction,
		"life": 0.24,
		"age": 0.0,
	})
	while _parry_clangs.size() > MAX_PARRY_CLANGS:
		_parry_clangs.pop_front()
	_request_transient_redraw()

func get_parry_clang_count() -> int:
	return _parry_clangs.size()

func get_parry_clang_total_count() -> int:
	return _parry_clang_total_count

func get_parry_clang_visual_version() -> String:
	return PARRY_CLANG_VISUAL_VERSION

func player_hit_flash(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_player_hit_flash_total_count += 1
	_player_hit_flashes.append({
		"origin": origin,
		"direction": direction,
		"life": 0.22,
		"age": 0.0,
	})
	while _player_hit_flashes.size() > MAX_PLAYER_HIT_FLASHES:
		_player_hit_flashes.pop_front()
	_request_transient_redraw()

func get_player_hit_flash_count() -> int:
	return _player_hit_flashes.size()

func get_player_hit_flash_total_count() -> int:
	return _player_hit_flash_total_count

func get_player_hit_flash_visual_version() -> String:
	return PLAYER_HIT_FLASH_VISUAL_VERSION

func get_player_hit_flash_material_marker_count() -> int:
	return 8

func _get_enemy_hit_spark_accent(enemy_kind: String) -> Color:
	match enemy_kind:
		"knife_rusher":
			return Color(0.92, 0.2, 0.055, 0.62)
		"rifleman":
			return Color(0.96, 0.58, 0.18, 0.62)
		"shotgun_brute":
			return Color(0.72, 0.12, 0.055, 0.66)
		"hunter":
			return Color(0.95, 0.34, 0.08, 0.66)
		"duelist":
			return Color(1.0, 0.72, 0.26, 0.68)
		_:
			return Color(0.86, 0.28, 0.08, 0.58)

func dash_ready_glint(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_dash_ready_glints.append({
		"origin": origin,
		"direction": direction,
		"life": 0.34,
		"age": 0.0,
	})
	_request_transient_redraw()

func get_dash_ready_glint_count() -> int:
	return _dash_ready_glints.size()

func dash_ready_prompt(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_dash_ready_prompt_total_count += 1
	_dash_ready_prompts.append({
		"origin": origin,
		"direction": direction,
		"life": 0.82,
		"age": 0.0,
	})
	_request_transient_redraw()

func get_dash_ready_prompt_count() -> int:
	return _dash_ready_prompts.size()

func get_dash_ready_prompt_total_count() -> int:
	return _dash_ready_prompt_total_count

func rifle_warning_puff(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_rifle_warning_puff_total_count += 1
	_rifle_warning_puffs.append({
		"origin": origin,
		"direction": direction,
		"life": 0.34,
		"age": 0.0,
	})
	_request_transient_redraw()

func get_rifle_warning_puff_count() -> int:
	return _rifle_warning_puffs.size()

func get_rifle_warning_puff_total_count() -> int:
	return _rifle_warning_puff_total_count

func enemy_weapon_burst(origin: Vector2, direction: Vector2, kind: String = "rifle") -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_enemy_weapon_burst_total_count += 1
	_enemy_weapon_bursts.append({
		"origin": origin,
		"direction": direction,
		"kind": kind,
		"life": 0.24 if kind == "shotgun" else 0.18,
		"age": 0.0,
	})
	while _enemy_weapon_bursts.size() > MAX_ENEMY_WEAPON_BURSTS:
		_enemy_weapon_bursts.pop_front()
	_request_transient_redraw()

func get_enemy_weapon_burst_count() -> int:
	return _enemy_weapon_bursts.size()

func get_enemy_weapon_burst_total_count() -> int:
	return _enemy_weapon_burst_total_count

func get_enemy_weapon_burst_visual_version() -> String:
	return ENEMY_WEAPON_BURST_VISUAL_VERSION

func enemy_movement_dust(origin: Vector2, direction: Vector2, enemy_kind: String = "", speed_scale: float = 1.0) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_enemy_movement_dust_total_count += 1
	_enemy_movement_dust.append({
		"origin": origin,
		"direction": direction,
		"kind": enemy_kind,
		"speed_scale": clampf(speed_scale, 0.35, 1.7),
		"accent": _get_enemy_movement_dust_accent(enemy_kind),
		"life": 0.34,
		"age": 0.0,
	})
	while _enemy_movement_dust.size() > MAX_ENEMY_MOVEMENT_DUST:
		_enemy_movement_dust.pop_front()
	_request_transient_redraw()

func get_enemy_movement_dust_count() -> int:
	return _enemy_movement_dust.size()

func get_enemy_movement_dust_total_count() -> int:
	return _enemy_movement_dust_total_count

func get_enemy_movement_dust_visual_version() -> String:
	return ENEMY_MOVEMENT_DUST_VISUAL_VERSION

func _get_enemy_movement_dust_accent(enemy_kind: String) -> Color:
	match enemy_kind:
		"knife_rusher":
			return Color(0.86, 0.28, 0.08, 0.34)
		"hunter":
			return Color(0.95, 0.34, 0.08, 0.32)
		"shotgun_brute":
			return Color(0.72, 0.2, 0.08, 0.3)
		"duelist":
			return Color(1.0, 0.68, 0.24, 0.28)
		"rifleman":
			return Color(0.78, 0.42, 0.16, 0.24)
		_:
			return Color(0.74, 0.42, 0.16, 0.24)

func extraction_rideout(start: Vector2, end: Vector2) -> void:
	var direction := start.direction_to(end)
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	_extraction_rideout_total_count += 1
	_extraction_rideouts.append({
		"start": start,
		"end": end,
		"direction": direction.normalized(),
		"life": 0.72,
		"age": 0.0,
	})
	impact_flash(end, Color(1.0, 0.7, 0.2), "RIDE OUT", 122.0)
	_request_transient_redraw()

func get_extraction_rideout_count() -> int:
	return _extraction_rideouts.size()

func get_extraction_rideout_total_count() -> int:
	return _extraction_rideout_total_count

func reload_ready_glint(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_reload_ready_glint_total_count += 1
	_reload_ready_glints.append({
		"origin": origin,
		"direction": direction,
		"life": 0.48,
		"age": 0.0,
	})
	_request_transient_redraw()

func get_reload_ready_glint_count() -> int:
	return _reload_ready_glints.size()

func get_reload_ready_glint_total_count() -> int:
	return _reload_ready_glint_total_count

func empty_reload_spin(origin: Vector2, direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_empty_reload_spin_total_count += 1
	_empty_reload_spins.append({
		"origin": origin,
		"direction": direction,
		"life": 0.42,
		"age": 0.0,
	})
	_request_transient_redraw()

func get_empty_reload_spin_count() -> int:
	return _empty_reload_spins.size()

func get_empty_reload_spin_total_count() -> int:
	return _empty_reload_spin_total_count

func skill_flash(origin: Vector2, color: Color, program_id: String = "") -> void:
	_ability_cast_glint_total_count += 1
	var direction := Vector2.RIGHT
	if program_id == "dust_veil" or program_id == "ghost_step":
		direction = Vector2.DOWN
	_ability_cast_glints.append({
		"origin": origin,
		"direction": direction,
		"life": 0.34,
		"age": 0.0,
		"color": color,
		"program_id": program_id,
	})
	while _ability_cast_glints.size() > MAX_ABILITY_CAST_GLINTS:
		_ability_cast_glints.pop_front()
	shockwave(origin, color)
	burst(origin, color, 8)
	_request_transient_redraw()

func program_flash(origin: Vector2, color: Color) -> void:
	skill_flash(origin, color)

func get_ability_cast_glint_count() -> int:
	return _ability_cast_glints.size()

func get_ability_cast_glint_total_count() -> int:
	return _ability_cast_glint_total_count

func get_ability_cast_glint_visual_version() -> String:
	return ABILITY_CAST_GLINT_VISUAL_VERSION

func impact_flash(origin: Vector2, color: Color, label: String = "", radius: float = 138.0) -> void:
	_append_transient_pulse({
		"origin": origin,
		"radius": radius,
		"life": 0.28,
		"age": 0.0,
		"color": color,
		"width": 5.0,
	})
	burst(origin, color, 6)
	if label != "":
		_impact_texts.append({
			"origin": origin + Vector2(randf_range(-14.0, 14.0), -34.0 + randf_range(-8.0, 8.0)),
			"text": label,
			"life": 0.46,
			"age": 0.0,
			"color": color.lightened(0.35),
			"rise": randf_range(36.0, 58.0),
			"size": 24.0 + minf(14.0, label.length() * 1.6),
		})
	_request_transient_redraw()

func muzzle_flash(origin: Vector2, direction: Vector2, color: Color) -> void:
	if direction.length_squared() <= 0.001:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	_muzzle_flash_total_count += 1
	_muzzle_flashes.append({
		"origin": origin,
		"direction": direction,
		"casing_origin": origin - direction * 8.0,
		"life": 0.16,
		"age": 0.0,
		"color": color.lightened(0.25),
	})
	while _muzzle_flashes.size() > MAX_MUZZLE_FLASHES:
		_muzzle_flashes.pop_front()
	_request_transient_redraw()

func get_muzzle_flash_count() -> int:
	return _muzzle_flashes.size()

func get_muzzle_flash_total_count() -> int:
	return _muzzle_flash_total_count

func get_muzzle_flash_visual_version() -> String:
	return MUZZLE_FLASH_VISUAL_VERSION

func get_muzzle_flash_material_marker_count() -> int:
	return 10

func beam(from: Vector2, to: Vector2, color: Color) -> void:
	_beams.append({
		"from": from,
		"to": to,
		"life": 0.18,
		"age": 0.0,
		"color": color,
	})
