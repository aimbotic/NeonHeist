class_name Player
extends CharacterBody2D

signal dash_used
signal player_damaged(amount: float)
signal player_down
signal player_parried
signal weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float)

var max_speed := 630.0
var acceleration := 3900.0
var dash_speed := 1770.0
var dash_duration := 0.13
var dash_cooldown := 0.9
var weapon_range := 126.0
var weapon_arc := 2.55
var weapon_damage := 50.0
var weapon_windup_time := 0.0
var weapon_active_time := 0.09
var weapon_recovery_time := 0.22
var weapon_cooldown := 0.0
var weapon_sheathe_delay := 0.45
var weapon_parry_time := 0.08
var max_health := 3.0
var health := 3.0
var invulnerable := false

const PLAYER_RADIUS := 22.0
const CORRIDOR_HALF_WIDTH := 36.0
const PLAYER_SPRITE_PATH := "res://assets/characters/player_cowgirl_3d_topdown_v001.png"
const PLAYER_SPRITE_FORWARD_PATH := "res://assets/characters/player_turnaround/player_cowgirl_forward_3d_topdown_v001.png"
const PLAYER_SPRITE_BACK_PATH := "res://assets/characters/player_turnaround/player_cowgirl_back_3d_topdown_v001.png"
const PLAYER_SPRITE_LEFT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_left_3d_topdown_v001.png"
const PLAYER_SPRITE_RIGHT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_right_3d_topdown_v001.png"
const PLAYER_SPRITE_ANGLED_PATH := "res://assets/characters/player_turnaround/player_cowgirl_angled_3d_topdown_v001.png"
const PLAYER_SPRITE_FORWARD_LEFT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_forward_left_3d_topdown_v001.png"
const PLAYER_SPRITE_FORWARD_RIGHT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_forward_right_3d_topdown_v001.png"
const PLAYER_SPRITE_BACK_LEFT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_back_left_3d_topdown_v001.png"
const PLAYER_SPRITE_BACK_RIGHT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_back_right_3d_topdown_v001.png"
const PLAYER_SPRITE_TOP_LEFT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_top_left_3d_topdown_v001.png"
const PLAYER_SPRITE_TOP_RIGHT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_top_right_3d_topdown_v001.png"
const PLAYER_SPRITE_BOTTOM_LEFT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_bottom_left_3d_topdown_v001.png"
const PLAYER_SPRITE_BOTTOM_RIGHT_PATH := "res://assets/characters/player_turnaround/player_cowgirl_bottom_right_3d_topdown_v001.png"
const PLAYER_SPRITE_TARGET_HEIGHT := 118.0
const PLAYER_HERO_VISUAL_VERSION := "denim_brass_hero_whole_sprite_browser_safe_v12"
const PLAYER_GROUNDED_SPRITE_VISUAL_VERSION := "player_locked_whole_body_sprite_perf_v14"
const PLAYER_MOTION_REDRAW_INTERVAL := 1.0 / 8.0
const PLAYER_IDLE_REDRAW_INTERVAL := 1.0 / 4.0
const PLAYER_OVERLAY_MOVEMENT_SUPPRESSION_SPEED_SQ := 1600.0
const PLAYER_SAFE_SOURCE_CROP_VISUAL_VERSION := "player_directional_uncropped_full_image_v4"

var _arena_bounds := Rect2()
var _character_texture: Texture2D
var _direction_textures: Dictionary = {}

var _dash_time := 0.0
var _dash_cooldown_remaining := 0.0
var _weapon_cooldown_remaining := 0.0
var _weapon_windup_remaining := 0.0
var _weapon_active_remaining := 0.0
var _weapon_recovery_remaining := 0.0
var _weapon_sheathe_delay_remaining := 0.0
var _weapon_parry_remaining := 0.0
var _parry_flash_remaining := 0.0
var _weapon_swing_direction := Vector2.RIGHT
var _dash_direction := Vector2.RIGHT
var _veil_remaining := 0.0
var _touch_origin := Vector2.ZERO
var _touch_vector := Vector2.ZERO
var _touch_active := false
var _anim_time := 0.0
var _moving := false
var _motion_redraw_timer := 0.0
var _sprite_direction_key := "angled"

func _ready() -> void:
	z_index = 20
	_load_character_texture()

func _physics_process(delta: float) -> void:
	if _motion_redraw_timer > 0.0:
		_motion_redraw_timer = maxf(0.0, _motion_redraw_timer - delta)
	_dash_cooldown_remaining = max(0.0, _dash_cooldown_remaining - delta)
	_update_weapon_timers(delta)
	_parry_flash_remaining = max(0.0, _parry_flash_remaining - delta)
	_veil_remaining = max(0.0, _veil_remaining - delta)
	_anim_time += delta

	var input_vector := _read_movement_input()
	_moving = input_vector.length_squared() > 0.001 or velocity.length_squared() > 1200.0
	if input_vector.length_squared() > 0.001:
		_dash_direction = input_vector.normalized()

	if _dash_time > 0.0:
		_dash_time -= delta
		velocity = _dash_direction * dash_speed
	else:
		invulnerable = _veil_remaining > 0.0
		var target_velocity := input_vector * max_speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)

	move_and_slide()
	_keep_inside_arena()
	_request_motion_redraw()

func _draw() -> void:
	var visual_size := _get_character_visual_size()
	_draw_character_shadow(visual_size)
	if _character_texture != null:
		_draw_character_sprite()
	else:
		_draw_character()
	if _should_draw_sprite_detail_overlay():
		_draw_whole_sprite_equipment_glints(visual_size)
	if _should_draw_body_attached_effect_overlay():
		_draw_player_sprite_material_rim(visual_size)
		_draw_player_hero_accent()
	if _character_texture == null or _weapon_active_remaining > 0.0:
		_draw_blade()
	if _parry_flash_remaining > 0.0:
		var flash := _parry_flash_remaining / 0.16
		draw_arc(Vector2.ZERO, lerpf(58.0, 34.0, flash), 0.0, TAU, 36, Color(1.0, 0.92, 0.62, flash), 5.0)
		draw_line(-_weapon_swing_direction * 42.0, _weapon_swing_direction * 46.0, Color(1.0, 0.96, 0.72, flash), 4.0)
	if invulnerable:
		draw_arc(Vector2.ZERO, 38.0, 0.0, TAU, 32, Color(1.0, 1.0, 1.0, 0.65), 3.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_origin = event.position
			_touch_active = true
		else:
			_touch_active = false
			_touch_vector = Vector2.ZERO
	elif event is InputEventScreenDrag and _touch_active:
		_touch_vector = (event.position - _touch_origin).limit_length(96.0) / 96.0

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		try_weapon_attack()
	if event.is_action_pressed("attack"):
		try_weapon_attack()

func try_dash() -> void:
	if _dash_cooldown_remaining > 0.0:
		return
	_dash_time = dash_duration
	_dash_cooldown_remaining = dash_cooldown
	invulnerable = true
	dash_used.emit()

func force_lunge() -> void:
	_dash_time = dash_duration
	_dash_cooldown_remaining = minf(_dash_cooldown_remaining, dash_cooldown * 0.35)
	invulnerable = true
	dash_used.emit()

func try_weapon_attack() -> void:
	force_quickdraw()

func force_quickdraw() -> void:
	_weapon_cooldown_remaining = weapon_cooldown
	_weapon_windup_remaining = 0.0
	_weapon_active_remaining = weapon_active_time
	_weapon_recovery_remaining = 0.0
	_weapon_sheathe_delay_remaining = 0.0
	_weapon_parry_remaining = weapon_parry_time
	_weapon_swing_direction = _dash_direction
	weapon_slashed.emit(global_position, _weapon_swing_direction, weapon_range, weapon_arc, weapon_damage)
	queue_redraw()

func take_damage(amount: float) -> void:
	if invulnerable or health <= 0.0:
		return
	if _weapon_parry_remaining > 0.0:
		_weapon_parry_remaining = 0.0
		_parry_flash_remaining = 0.16
		player_parried.emit()
		queue_redraw()
		return
	health = max(0.0, health - 1.0)
	player_damaged.emit(amount)
	if health <= 0.0:
		player_down.emit()

func apply_dust_veil(duration: float) -> void:
	_veil_remaining = max(_veil_remaining, duration)
	invulnerable = true
	queue_redraw()

func apply_weapon_profile(profile_id: String) -> void:
	match profile_id:
		"black_sash_saber":
			weapon_range = 146.0
			weapon_arc = 2.75
			weapon_damage = 58.0
			weapon_active_time = 0.08
			weapon_cooldown = 0.0
			weapon_parry_time = 0.1
		"grave_saber":
			weapon_range = 160.0
			weapon_arc = 2.9
			weapon_damage = 68.0
			weapon_active_time = 0.08
			weapon_cooldown = 0.0
			weapon_parry_time = 0.11
		"sandstorm_saber":
			weapon_range = 154.0
			weapon_arc = 3.05
			weapon_damage = 62.0
			weapon_active_time = 0.085
			weapon_cooldown = 0.0
			weapon_parry_time = 0.13
		"red_canyon_saber":
			weapon_range = 170.0
			weapon_arc = 2.65
			weapon_damage = 78.0
			weapon_active_time = 0.075
			weapon_cooldown = 0.0
			weapon_parry_time = 0.1
		"sunrise_saber":
			weapon_range = 178.0
			weapon_arc = 3.1
			weapon_damage = 84.0
			weapon_active_time = 0.075
			weapon_cooldown = 0.0
			weapon_parry_time = 0.14
		_:
			weapon_range = 126.0
			weapon_arc = 2.55
			weapon_damage = 50.0
			weapon_active_time = 0.09
			weapon_cooldown = 0.0
			weapon_parry_time = 0.08
	queue_redraw()

func get_aim_direction() -> Vector2:
	return _dash_direction.normalized()

func get_dash_fraction() -> float:
	return 1.0 - (_dash_cooldown_remaining / dash_cooldown)

func get_player_hero_visual_version() -> String:
	return PLAYER_HERO_VISUAL_VERSION

func get_player_grounded_sprite_visual_version() -> String:
	return PLAYER_GROUNDED_SPRITE_VISUAL_VERSION

func get_player_sprite_material_marker_count() -> int:
	return 12

func get_player_motion_redraw_interval() -> float:
	return PLAYER_MOTION_REDRAW_INTERVAL

func get_player_overlay_movement_gate_version() -> String:
	return "player_whole_sprite_no_body_overlay_v3"

func get_player_safe_source_crop_visual_version() -> String:
	return PLAYER_SAFE_SOURCE_CROP_VISUAL_VERSION

func get_player_directional_source_crop_count() -> int:
	return 13

func _draw_character() -> void:
	var facing: Vector2 = _dash_direction.normalized()
	var side: Vector2 = Vector2.RIGHT
	var step: float = sin(_anim_time * 10.0) if _moving else sin(_anim_time * 2.0) * 0.18
	var idle_bob: float = sin(_anim_time * 2.4) * 1.1 if not _moving else sin(_anim_time * 10.0) * 1.8
	var origin: Vector2 = Vector2(0.0, idle_bob)
	var cape_sway: float = sin(_anim_time * 2.8) * 8.0 + sin(_anim_time * 5.1) * 2.5
	var cape_lift: float = sin(_anim_time * 1.7) * 3.0
	var hair_sway: float = sin(_anim_time * 3.0 + 0.7) * 7.0 + sin(_anim_time * 5.4) * 2.0
	var hair_lift: float = sin(_anim_time * 2.1 + 1.2) * 2.0
	var look: Vector2 = facing * 5.0
	var head: Vector2 = origin + Vector2(0.0, -25.0) + look
	var chest: Vector2 = origin + Vector2(0.0, -5.0)
	var hips: Vector2 = origin + Vector2(0.0, 16.0)
	var left_foot: Vector2 = origin + Vector2(-8.0 - step * 4.0, 38.0 + maxf(0.0, step) * 4.0)
	var right_foot: Vector2 = origin + Vector2(8.0 - step * 4.0, 38.0 + maxf(0.0, -step) * 4.0)
	var left_hand: Vector2 = origin + Vector2(-21.0, 0.0) + facing * 5.0
	var saber_hand: Vector2 = origin + Vector2(13.0, 14.0) + facing * 4.0

	var cloak := PackedVector2Array([
		head + Vector2(-12.0, 7.0),
		chest + Vector2(-21.0, 0.0),
		hips + Vector2(-13.0, 0.0),
		hips + Vector2(8.0, 0.0),
		chest + Vector2(12.0, 0.0),
		head + Vector2(8.0, 7.0),
	])
	var tunic := PackedVector2Array([
		head + Vector2(-7.0, 7.0),
		chest + Vector2(-10.0, 0.0),
		hips + Vector2(-6.0, 0.0),
		hips + Vector2(7.0, 0.0),
		chest + Vector2(9.0, 0.0),
		head + Vector2(6.0, 7.0),
	])
	var red_sash := PackedVector2Array([
		hips + Vector2(-8.0, -5.0),
		hips + Vector2(9.0, -3.0),
		hips + Vector2(7.0, 7.0),
		hips + Vector2(-8.0, 5.0),
	])
	var cape := PackedVector2Array([
		chest + Vector2(-13.0, 0.0),
		chest + Vector2(9.0, 0.0),
		hips + Vector2(16.0 + cape_sway * 0.35, 11.0 + cape_lift),
		hips + Vector2(24.0 + cape_sway, 42.0 + cape_lift),
		hips + Vector2(9.0 + cape_sway * 0.45, 58.0),
		hips + Vector2(-9.0 + cape_sway * 0.15, 38.0),
	])
	var cape_torn_edge := PackedVector2Array([
		cape[3],
		cape[4] + side * 2.0 - facing * 5.0,
		cape[5],
		cape[5] + side * 7.0 + facing * 9.0,
	])
	var hair_mass := PackedVector2Array([
		head + Vector2(-9.0, -4.0),
		head + Vector2(7.0, -5.0),
		chest + Vector2(13.0 + hair_sway * 0.25, -3.0 + hair_lift),
		hips + Vector2(18.0 + hair_sway * 0.75, 21.0 + hair_lift),
		hips + Vector2(4.0 + hair_sway * 0.45, 46.0),
		chest + Vector2(-15.0 + hair_sway * 0.18, 14.0),
	])

	draw_colored_polygon(cape, Color(0.018, 0.014, 0.012, 0.96))
	draw_colored_polygon(cape_torn_edge, Color(0.09, 0.052, 0.028, 0.82))
	draw_polyline(PackedVector2Array([cape[0], cape[1], cape[2], cape[3], cape[4], cape[5]]), Color(0.24, 0.15, 0.09, 0.82), 2.0)
	draw_colored_polygon(hair_mass, Color(0.012, 0.01, 0.009, 0.98))
	draw_polyline(PackedVector2Array([
		head + Vector2(-8.0, 1.0),
		chest + Vector2(-18.0 + hair_sway * 0.2, 10.0),
		hips + Vector2(-8.0 + hair_sway * 0.34, 42.0),
	]), Color(0.04, 0.026, 0.018, 0.92), 4.0)
	draw_polyline(PackedVector2Array([
		head + Vector2(1.0, 0.0),
		chest + Vector2(5.0 + hair_sway * 0.42, 16.0 + hair_lift),
		hips + Vector2(12.0 + hair_sway * 0.78, 54.0),
	]), Color(0.055, 0.035, 0.022, 0.86), 5.0)
	draw_polyline(PackedVector2Array([
		head + Vector2(7.0, 1.0),
		chest + Vector2(16.0 + hair_sway * 0.55, 7.0 + hair_lift),
		hips + Vector2(23.0 + hair_sway, 34.0),
	]), Color(0.032, 0.022, 0.016, 0.9), 3.0)
	draw_colored_polygon(cloak, Color(0.028, 0.023, 0.02, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[5], cloak[0]]), Color(0.26, 0.18, 0.12, 0.85), 2.0)
	draw_line(chest + Vector2(-15.0, 0.0), left_hand, Color(0.82, 0.8, 0.72, 0.96), 5.0)
	draw_line(chest + Vector2(12.0, 0.0), saber_hand, Color(0.82, 0.8, 0.72, 0.92), 5.0)
	draw_colored_polygon(tunic, Color(0.86, 0.84, 0.76, 0.98))
	draw_colored_polygon(red_sash, Color(0.58, 0.07, 0.035, 0.96))
	draw_line(hips + Vector2(-5.0, 0.0), left_foot, Color(0.82, 0.8, 0.72, 0.95), 6.0)
	draw_line(hips + Vector2(5.0, 0.0), right_foot, Color(0.58, 0.07, 0.035, 0.95), 6.0)
	draw_line(left_foot + Vector2(-3.0, 0.0), left_foot + Vector2(6.0, 0.0), Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_line(right_foot + Vector2(-4.0, 0.0), right_foot + Vector2(6.0, 0.0), Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_circle(head, 8.0, Color(0.54, 0.43, 0.34, 0.55))
	var hat_brim := PackedVector2Array([
		head + Vector2(-32.0, -4.0) + facing * 3.0,
		head + Vector2(-21.0, -12.0) + facing * 4.0,
		head + Vector2(-7.0, -15.0) + facing * 5.0,
		head + Vector2(10.0, -15.0) + facing * 5.0,
		head + Vector2(25.0, -11.0) + facing * 4.0,
		head + Vector2(34.0, -2.0) + facing * 3.0,
		head + Vector2(20.0, 5.0) + facing * 4.0,
		head + Vector2(3.0, 8.0) + facing * 4.0,
		head + Vector2(-16.0, 6.0) + facing * 4.0,
	])
	var hat_crown := PackedVector2Array([
		head + Vector2(-15.0, -11.0) + facing * 4.0,
		head + Vector2(-10.0, -30.0) + facing * 3.0,
		head + Vector2(0.0, -35.0) + facing * 2.0,
		head + Vector2(12.0, -31.0) + facing * 3.0,
		head + Vector2(17.0, -11.0) + facing * 4.0,
	])
	draw_colored_polygon(hat_brim, Color(0.055, 0.032, 0.018, 1.0))
	draw_polyline(PackedVector2Array([hat_brim[0], hat_brim[1], hat_brim[2], hat_brim[3], hat_brim[4], hat_brim[5], hat_brim[6], hat_brim[7], hat_brim[8], hat_brim[0]]), Color(0.34, 0.19, 0.08, 0.92), 2.0)
	draw_colored_polygon(hat_crown, Color(0.075, 0.045, 0.026, 1.0))
	draw_polyline(PackedVector2Array([hat_crown[0], hat_crown[1], hat_crown[2], hat_crown[3], hat_crown[4]]), Color(0.42, 0.25, 0.11, 0.82), 2.0)
	draw_line(head + Vector2(-17.0, -10.0) + facing * 4.0, head + Vector2(17.0, -10.0) + facing * 4.0, Color(0.015, 0.01, 0.008, 1.0), 5.0)
	draw_line(head + Vector2(-23.0, 2.0) + facing * 4.0, head + Vector2(23.0, 2.0) + facing * 4.0, Color(0.0, 0.0, 0.0, 0.98), 9.0)
	draw_line(left_hand, left_hand + facing * 26.0 + Vector2(-8.0, 10.0), Color(0.72, 0.73, 0.68, 0.94), 3.0)
	draw_line(left_hand + facing * 26.0 + Vector2(-8.0, 10.0), left_hand + facing * 34.0 + Vector2(-10.0, 14.0), Color(0.94, 0.9, 0.74, 0.9), 2.0)
	draw_circle(saber_hand, 4.0, Color(0.76, 0.58, 0.42, 0.98))

func _load_character_texture() -> void:
	_character_texture = load(PLAYER_SPRITE_PATH) as Texture2D
	if _character_texture == null:
		push_warning("Could not load player character sprite: %s" % PLAYER_SPRITE_PATH)
		return
	_direction_textures = {
		"forward": load(PLAYER_SPRITE_FORWARD_PATH) as Texture2D,
		"back": load(PLAYER_SPRITE_BACK_PATH) as Texture2D,
		"left": load(PLAYER_SPRITE_LEFT_PATH) as Texture2D,
		"right": load(PLAYER_SPRITE_RIGHT_PATH) as Texture2D,
		"angled": load(PLAYER_SPRITE_ANGLED_PATH) as Texture2D,
		"forward_left": load(PLAYER_SPRITE_FORWARD_LEFT_PATH) as Texture2D,
		"forward_right": load(PLAYER_SPRITE_FORWARD_RIGHT_PATH) as Texture2D,
		"back_left": load(PLAYER_SPRITE_BACK_LEFT_PATH) as Texture2D,
		"back_right": load(PLAYER_SPRITE_BACK_RIGHT_PATH) as Texture2D,
		"top_left": load(PLAYER_SPRITE_TOP_LEFT_PATH) as Texture2D,
		"top_right": load(PLAYER_SPRITE_TOP_RIGHT_PATH) as Texture2D,
		"bottom_left": load(PLAYER_SPRITE_BOTTOM_LEFT_PATH) as Texture2D,
		"bottom_right": load(PLAYER_SPRITE_BOTTOM_RIGHT_PATH) as Texture2D,
	}

func _draw_character_sprite() -> void:
	var texture := _get_character_texture_for_direction()
	var source_rect := _get_character_source_rect(texture)
	var visual_size := _get_scaled_source_size(source_rect)
	var draw_position := Vector2(-visual_size.x * 0.5, -visual_size.y * 0.5 + 8.0)
	_draw_running_sprite(texture, draw_position, visual_size, source_rect)

func _draw_running_sprite(texture: Texture2D, draw_position: Vector2, visual_size: Vector2, source_rect: Rect2) -> void:
	draw_texture_rect_region(texture, Rect2(draw_position, visual_size), source_rect)

func _request_motion_redraw(force: bool = false) -> void:
	if force:
		_motion_redraw_timer = 0.0
		queue_redraw()
		return
	if _motion_redraw_timer > 0.0:
		return
	var has_active_visual := _moving or velocity.length_squared() > 240.0 or _dash_time > 0.0 or _weapon_active_remaining > 0.0 or _weapon_recovery_remaining > 0.0 or _weapon_sheathe_delay_remaining > 0.0 or _parry_flash_remaining > 0.0 or invulnerable
	_motion_redraw_timer = PLAYER_MOTION_REDRAW_INTERVAL if has_active_visual else PLAYER_IDLE_REDRAW_INTERVAL
	queue_redraw()

func _has_active_player_effect_overlay() -> bool:
	return _dash_time > 0.0 or _weapon_active_remaining > 0.0 or _parry_flash_remaining > 0.0 or invulnerable

func _should_draw_body_attached_effect_overlay() -> bool:
	if not _has_active_player_effect_overlay():
		return false
	if _character_texture == null:
		return true
	return false

func _should_draw_sprite_detail_overlay() -> bool:
	if _character_texture == null:
		return true
	return false

func _draw_run_contacts(visual_size: Vector2, step: float, movement_ratio: float) -> void:
	var base_y := visual_size.y * 0.46 + 8.0
	var foot_spread := clampf(visual_size.x * 0.26, 12.0, 24.0)
	var stride := step * 10.0 * movement_ratio
	for i in range(2):
		var side := -1.0 if i == 0 else 1.0
		var phase_sign := side
		var foot := Vector2(side * foot_spread + stride * phase_sign, base_y - absf(step * phase_sign) * 3.0)
		draw_set_transform(foot, 0.0, Vector2(10.0 + movement_ratio * 5.0, 3.0))
		draw_circle(Vector2.ZERO, 1.0, Color(0.035, 0.018, 0.008, 0.18 + movement_ratio * 0.16))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if movement_ratio > 0.35 and i == 0:
			draw_circle(foot - Vector2(stride * 0.4, 2.0), 2.5, Color(0.58, 0.36, 0.16, 0.16))

func _get_character_visual_size() -> Vector2:
	if _character_texture != null:
		return _get_scaled_texture_size(_get_character_texture_for_direction())
	return Vector2(72.0, 110.0)

func _get_character_texture_for_direction() -> Texture2D:
	var key := "angled"
	_sprite_direction_key = key
	var directional_texture: Texture2D = _direction_textures.get(key, null)
	if directional_texture != null:
		return directional_texture
	return _character_texture

func _is_using_stable_run_sprite() -> bool:
	return true

func _get_character_texture_key_for_direction() -> String:
	var key := _sprite_direction_key
	var facing := _dash_direction.normalized()
	if absf(facing.x) > 0.35 and absf(facing.y) > 0.35:
		if facing.y > 0.0:
			key = "bottom_right" if facing.x > 0.0 else "bottom_left"
		else:
			key = "top_right" if facing.x > 0.0 else "top_left"
	elif absf(facing.x) > absf(facing.y) * 1.25:
		key = "right" if facing.x > 0.0 else "left"
	elif absf(facing.y) > absf(facing.x) * 1.25:
		key = "forward" if facing.y > 0.0 else "back"
	return key

func _get_scaled_texture_size(texture: Texture2D) -> Vector2:
	return _get_scaled_source_size(_get_character_source_rect(texture))

func _get_character_source_rect(texture: Texture2D) -> Rect2:
	if texture == null:
		return Rect2(Vector2.ZERO, Vector2(72.0, 110.0))
	var texture_size := texture.get_size()
	return _get_directional_source_crop_rect(texture_size, _sprite_direction_key)

func _get_directional_source_crop_rect(texture_size: Vector2, key: String) -> Rect2:
	return Rect2(Vector2.ZERO, texture_size)

func _get_scaled_source_size(source_rect: Rect2) -> Vector2:
	var sprite_scale := PLAYER_SPRITE_TARGET_HEIGHT / maxf(source_rect.size.y, 1.0)
	return source_rect.size * sprite_scale

func _draw_character_shadow(fallback_size: Vector2) -> void:
	var visual_size := _get_largest_character_sprite_size(fallback_size)
	var movement_ratio: float = clampf(velocity.length() / maxf(max_speed, 1.0), 0.0, 1.0)
	var dash_ratio: float = _dash_time / maxf(dash_duration, 0.01)
	var width := clampf(visual_size.x * 0.72 + movement_ratio * 10.0 + dash_ratio * 16.0, 34.0, 112.0)
	var height := clampf(visual_size.y * 0.18, 12.0, 28.0)
	var y_offset := clampf(visual_size.y * 0.32, 22.0, 42.0)
	var cast_direction := Vector2(0.78, 0.36).normalized()
	var cast_length := clampf(visual_size.y * (0.28 + movement_ratio * 0.08 + dash_ratio * 0.12), 24.0, 62.0)
	draw_line(Vector2(2.0, y_offset + 8.0), Vector2(2.0, y_offset + 8.0) + cast_direction * cast_length, Color(0.045, 0.018, 0.007, 0.16 + dash_ratio * 0.08), clampf(height * 0.58, 7.0, 15.0))
	draw_line(Vector2(-10.0, y_offset + 5.0), Vector2(-10.0, y_offset + 5.0) + cast_direction * cast_length * 0.74, Color(0.12, 0.055, 0.018, 0.09), clampf(height * 0.34, 4.0, 9.0))
	draw_set_transform(Vector2(10.0, y_offset + 7.0), 0.0, Vector2(width * 0.64, height * 0.42))
	draw_circle(Vector2.ZERO, 1.0, Color(0.025, 0.012, 0.006, 0.22))
	draw_set_transform(Vector2(-6.0, y_offset + 2.0), 0.0, Vector2(width * 0.44, height * 0.24))
	draw_circle(Vector2.ZERO, 1.0, Color(0.09, 0.045, 0.018, 0.13))
	draw_set_transform(Vector2(-_dash_direction.x * dash_ratio * 12.0, y_offset), 0.0, Vector2(width * 0.5, height * 0.5))
	draw_circle(Vector2.ZERO, 1.0, Color(0.035, 0.018, 0.008, 0.36))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_player_sprite_material_rim(visual_size: Vector2) -> void:
	var facing := _dash_direction.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var side := facing.orthogonal()
	var moving_ratio: float = clampf(velocity.length() / maxf(max_speed, 1.0), 0.0, 1.0)
	var dash_ratio: float = clampf(_dash_time / maxf(dash_duration, 0.01), 0.0, 1.0)
	var weapon_flash: float = clampf(_weapon_active_remaining / maxf(weapon_active_time, 0.01), 0.0, 1.0)
	var upper := -facing * clampf(visual_size.y * 0.1, 8.0, 18.0) + Vector2(0.0, -4.0)
	var hat_width := clampf(visual_size.x * 0.34, 17.0, 28.0)
	var shoulder_width := clampf(visual_size.x * 0.25, 14.0, 23.0)
	var brass := Color(1.0, 0.74, 0.28, 0.38 + dash_ratio * 0.18 + weapon_flash * 0.18)
	var denim := Color(0.38, 0.62, 0.78, 0.24 + dash_ratio * 0.18)
	var sun_edge := Color(1.0, 0.86, 0.48, 0.22 + dash_ratio * 0.12 + weapon_flash * 0.14)
	var leather_shadow := Color(0.022, 0.011, 0.006, 0.42)
	draw_line(upper - side * hat_width, upper + side * hat_width, leather_shadow, 6.0)
	draw_line(upper - side * hat_width * 0.72 - facing * 2.0, upper + side * hat_width * 0.72 - facing * 2.0, brass, 2.0)
	draw_line(upper - side * hat_width * 0.44 - facing * 5.0, upper + side * hat_width * 0.44 - facing * 5.0, sun_edge, 1.5)
	draw_line(-facing * 4.0 - side * shoulder_width, -facing * 2.0 + side * shoulder_width, denim, 2.5)
	draw_line(-facing * 7.0 - side * shoulder_width * 0.72, -facing * 5.0 + side * shoulder_width * 0.72, sun_edge, 1.3)
	draw_line(facing * 6.0 + side * shoulder_width * 0.45, facing * 28.0 + side * shoulder_width * 0.72, brass, 1.8)
	var contact_y := clampf(visual_size.y * 0.36, 26.0, 46.0)
	var contact_alpha := 0.14 + moving_ratio * 0.08 + dash_ratio * 0.14
	draw_line(Vector2(-shoulder_width * 1.05, contact_y), Vector2(shoulder_width * 0.82, contact_y + 4.0), Color(0.055, 0.024, 0.01, contact_alpha), 3.4)
	draw_line(Vector2(-shoulder_width * 0.74, contact_y - 2.0), Vector2(shoulder_width * 0.54, contact_y + 1.0), Color(1.0, 0.78, 0.38, 0.12 + dash_ratio * 0.08), 1.2)
	draw_circle(-facing * 10.0 - side * shoulder_width * 0.52, 2.0, Color(0.92, 0.68, 0.28, 0.22 + weapon_flash * 0.16))
	draw_circle(-facing * 8.0 + side * shoulder_width * 0.5, 1.7, Color(0.24, 0.46, 0.64, 0.22 + dash_ratio * 0.12))
	draw_line(upper + side * hat_width * 0.5 + facing * 3.0, upper + side * hat_width * 0.88 + facing * 7.0, Color(1.0, 0.9, 0.58, 0.18 + weapon_flash * 0.14), 1.2)
	if moving_ratio > 0.12:
		var heel_y := clampf(visual_size.y * 0.34, 24.0, 42.0)
		draw_line(Vector2(-shoulder_width * 0.55, heel_y), Vector2(-shoulder_width * 1.1, heel_y + 9.0), Color(0.95, 0.64, 0.22, 0.12 + moving_ratio * 0.12), 1.8)
		draw_line(Vector2(shoulder_width * 0.5, heel_y), Vector2(shoulder_width * 0.95, heel_y + 8.0), Color(0.95, 0.64, 0.22, 0.1 + moving_ratio * 0.1), 1.6)

func _draw_whole_sprite_equipment_glints(visual_size: Vector2) -> void:
	var facing := _dash_direction.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var side := facing.orthogonal()
	var movement_ratio: float = clampf(velocity.length() / maxf(max_speed, 1.0), 0.0, 1.0)
	var hat_y := -visual_size.y * 0.28
	var shoulder_y := -visual_size.y * 0.12
	var belt_y := visual_size.y * 0.03
	var boot_y := visual_size.y * 0.32
	var hat_half := clampf(visual_size.x * 0.22, 13.0, 23.0)
	var shoulder_half := clampf(visual_size.x * 0.18, 11.0, 19.0)
	var brass := Color(0.96, 0.68, 0.28, 0.38)
	var denim := Color(0.28, 0.52, 0.7, 0.32)
	var bone := Color(0.94, 0.88, 0.68, 0.34)
	var leather := Color(0.035, 0.018, 0.01, 0.3)

	draw_line(Vector2(0.0, hat_y) - side * hat_half, Vector2(0.0, hat_y) + side * hat_half, leather, 3.0)
	draw_line(Vector2(0.0, hat_y - 2.0) - side * hat_half * 0.52, Vector2(0.0, hat_y - 2.0) + side * hat_half * 0.52, brass, 1.2)
	draw_line(Vector2(0.0, shoulder_y) - side * shoulder_half, Vector2(0.0, shoulder_y) + side * shoulder_half, denim, 2.0)
	draw_line(Vector2(0.0, belt_y) - side * shoulder_half * 0.82, Vector2(0.0, belt_y + 1.0) + side * shoulder_half * 0.86, brass, 1.8)
	draw_circle(Vector2(0.0, belt_y) + facing * 2.0, 2.0, Color(0.98, 0.74, 0.34, 0.48))
	draw_line(Vector2(0.0, belt_y + 4.0) - side * shoulder_half * 0.82, Vector2(0.0, boot_y - 5.0) - side * shoulder_half * 0.42, leather, 2.2)
	draw_line(Vector2(0.0, belt_y + 2.0) + side * shoulder_half * 0.72, Vector2(0.0, belt_y + 12.0) + side * shoulder_half * 0.92 + facing * 5.0, Color(0.08, 0.05, 0.035, 0.42), 3.0)
	draw_line(Vector2(0.0, belt_y + 3.0) + side * shoulder_half * 0.72, Vector2(0.0, belt_y + 12.0) + side * shoulder_half * 0.92 + facing * 5.0, brass, 1.1)
	draw_line(Vector2(0.0, belt_y + 6.0) - side * shoulder_half * 0.9, Vector2(0.0, belt_y + 32.0) - side * shoulder_half * 1.04 + facing * 4.0, bone, 1.4)
	if movement_ratio > 0.08:
		var spur_alpha := 0.18 + movement_ratio * 0.16
		draw_line(Vector2(0.0, boot_y) - side * shoulder_half * 0.74, Vector2(0.0, boot_y + 5.0) - side * shoulder_half * 1.08, Color(0.96, 0.66, 0.24, spur_alpha), 1.5)
		draw_line(Vector2(0.0, boot_y) + side * shoulder_half * 0.74, Vector2(0.0, boot_y + 5.0) + side * shoulder_half * 1.08, Color(0.96, 0.66, 0.24, spur_alpha), 1.5)

func _draw_player_hero_accent() -> void:
	var facing := _dash_direction.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var side := facing.orthogonal()
	var moving_ratio: float = clampf(velocity.length() / maxf(max_speed, 1.0), 0.0, 1.0)
	var dash_ratio: float = clampf(_dash_time / maxf(dash_duration, 0.01), 0.0, 1.0)
	var weapon_flash: float = clampf(_weapon_active_remaining / maxf(weapon_active_time, 0.01), 0.0, 1.0)
	var denim := Color(0.18, 0.35, 0.52, 0.72 + dash_ratio * 0.12)
	var denim_edge := Color(0.52, 0.76, 0.92, 0.42 + dash_ratio * 0.2)
	var brass := Color(0.96, 0.68, 0.28, 0.74 + weapon_flash * 0.18)
	var bone := Color(0.94, 0.88, 0.68, 0.7 + weapon_flash * 0.16)
	var dark := Color(0.028, 0.014, 0.008, 0.64)
	var sun_edge := Color(1.0, 0.84, 0.44, 0.28 + dash_ratio * 0.18 + weapon_flash * 0.16)

	var shoulder_left := facing * 4.0 - side * 17.0
	var shoulder_right := facing * 6.0 + side * 17.0
	var belt_left := -facing * 12.0 - side * 16.0
	var belt_right := -facing * 9.0 + side * 17.0
	var hat_center := facing * 18.0
	var saber_hand := facing * 13.0 - side * 14.0
	var revolver_hand := facing * 8.0 + side * 16.0

	draw_line(shoulder_left, shoulder_right, dark, 7.0)
	draw_line(shoulder_left + facing * 2.0, shoulder_right + facing * 2.0, denim, 4.0)
	draw_line(shoulder_left + facing * 4.0, shoulder_right + facing * 4.0, denim_edge, 1.6)
	draw_line(shoulder_left - facing * 2.0, shoulder_right - facing * 2.0, sun_edge, 1.2)
	draw_line(belt_left, belt_right, Color(0.08, 0.036, 0.018, 0.72), 6.0)
	draw_line(belt_left + facing * 2.0, belt_right + facing * 2.0, brass, 2.2)
	draw_circle((belt_left + belt_right) * 0.5 + facing * 2.0, 3.2, brass)
	draw_circle(belt_left + facing * 1.4, 1.7, sun_edge)
	draw_circle(belt_right + facing * 1.4, 1.7, sun_edge)

	draw_line(hat_center - side * 23.0, hat_center + side * 23.0, dark, 6.0)
	draw_line(hat_center - side * 14.0 + facing * 3.0, hat_center + side * 14.0 + facing * 3.0, brass, 2.0)
	draw_line(hat_center - side * 18.0 - facing * 2.0, hat_center + side * 18.0 - facing * 2.0, sun_edge, 1.4)
	draw_line(hat_center - side * 12.0 - facing * 2.0, hat_center + side * 12.0 - facing * 2.0, Color(0.02, 0.012, 0.008, 0.78), 3.0)

	draw_line(saber_hand, saber_hand + facing * (34.0 + weapon_flash * 18.0) - side * 4.0, Color(0.06, 0.034, 0.018, 0.62), 5.0)
	draw_line(saber_hand + facing * 4.0, saber_hand + facing * (38.0 + weapon_flash * 18.0) - side * 4.0, bone, 2.2)
	draw_circle(saber_hand, 3.4, brass)
	draw_line(revolver_hand, revolver_hand + facing * 25.0 + side * 5.0, dark, 5.0)
	draw_line(revolver_hand + facing * 3.0, revolver_hand + facing * 27.0 + side * 5.0, brass, 2.0)
	draw_circle(revolver_hand + facing * 5.0 + side * 3.0, 3.0, Color(0.035, 0.022, 0.016, 0.86))

	if moving_ratio > 0.1:
		var spur_alpha := 0.16 + moving_ratio * 0.18
		draw_line(-facing * 34.0 - side * 12.0, -facing * 43.0 - side * 18.0, Color(0.95, 0.66, 0.24, spur_alpha), 2.0)
		draw_line(-facing * 34.0 + side * 12.0, -facing * 43.0 + side * 18.0, Color(0.95, 0.66, 0.24, spur_alpha), 2.0)
	if dash_ratio > 0.0:
		var streak_alpha := 0.28 * dash_ratio
		draw_line(-facing * 18.0 - side * 18.0, -facing * (58.0 + dash_ratio * 32.0) - side * 28.0, Color(0.18, 0.35, 0.52, streak_alpha), 5.0)
		draw_line(-facing * 14.0 + side * 16.0, -facing * (52.0 + dash_ratio * 30.0) + side * 24.0, Color(0.96, 0.68, 0.28, streak_alpha), 3.0)

func _get_largest_character_sprite_size(fallback_size: Vector2) -> Vector2:
	var largest := fallback_size
	for child in get_children():
		var child_size := Vector2.ZERO
		if child is Sprite2D and child.texture != null:
			child_size = child.texture.get_size() * child.scale.abs()
		elif child is AnimatedSprite2D and child.sprite_frames != null:
			var frame_texture: Texture2D = child.sprite_frames.get_frame_texture(child.animation, child.frame)
			if frame_texture != null:
				child_size = frame_texture.get_size() * child.scale.abs()
		if child_size.x * child_size.y > largest.x * largest.y:
			largest = child_size
	return largest

func _draw_blade() -> void:
	if not _is_blade_unsheathed():
		_draw_sheath()
		return

	var blade_direction := _get_blade_direction()
	var side := blade_direction.orthogonal()
	var grip_start := blade_direction * 12.0
	var hilt_center := blade_direction * 24.0
	var blade_base := blade_direction * 31.0
	var blade_tip := blade_direction * weapon_range
	var curve := side * 7.0

	if _weapon_active_remaining > 0.0:
		var sweep_progress: float = 1.0 - _weapon_active_remaining / weapon_active_time
		var base_angle: float = _weapon_swing_direction.angle()
		var start_angle: float = base_angle - weapon_arc * 0.5
		var end_angle: float = base_angle + weapon_arc * 0.5
		var current_angle: float = lerpf(start_angle, end_angle, sweep_progress)
		var trail_alpha: float = 0.92 * (1.0 - sweep_progress * 0.42)
		var slash_direction: Vector2 = Vector2.RIGHT.rotated(current_angle)
		var slash_side: Vector2 = slash_direction.orthogonal()
		var flash_tip: Vector2 = slash_direction * weapon_range
		var flash_base: Vector2 = slash_direction * 44.0
		var crescent := PackedVector2Array([
			flash_base - slash_side * 14.0,
			flash_tip - slash_side * 10.0,
			flash_tip + slash_direction * 10.0,
			flash_tip + slash_side * 17.0,
			flash_base + slash_side * 8.0,
		])
		draw_arc(Vector2.ZERO, weapon_range, start_angle, end_angle, 32, Color(0.92, 0.48, 0.18, trail_alpha), 12.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.82, start_angle + weapon_arc * 0.08, end_angle - weapon_arc * 0.08, 26, Color(0.98, 0.78, 0.42, trail_alpha * 0.72), 6.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.58, start_angle + weapon_arc * 0.18, end_angle - weapon_arc * 0.18, 18, Color(1.0, 0.94, 0.68, trail_alpha * 0.45), 3.0)
		draw_colored_polygon(crescent, Color(1.0, 0.84, 0.48, trail_alpha * 0.24))
		draw_line(Vector2.RIGHT.rotated(start_angle) * 52.0, Vector2.RIGHT.rotated(start_angle) * (weapon_range - 4.0), Color(0.96, 0.68, 0.34, trail_alpha * 0.38), 4.0)
		draw_line(Vector2.RIGHT.rotated(end_angle) * 52.0, Vector2.RIGHT.rotated(end_angle) * (weapon_range - 4.0), Color(1.0, 0.9, 0.55, trail_alpha * 0.54), 5.0)

	draw_line(grip_start, hilt_center, Color(0.035, 0.022, 0.018, 1.0), 9.0)
	draw_line(grip_start, hilt_center, Color(0.32, 0.17, 0.08, 1.0), 5.0)
	draw_arc(hilt_center + blade_direction * 2.0, 13.0, blade_direction.angle() + PI * 0.5, blade_direction.angle() + PI * 1.52, 12, Color(0.78, 0.45, 0.2, 0.98), 4.0)
	draw_line(hilt_center - side * 6.0, hilt_center + side * 13.0, Color(0.66, 0.36, 0.16, 0.95), 4.0)

	var blade := PackedVector2Array([
		blade_base - side * 5.5,
		blade_base + side * 5.5,
		blade_tip + curve,
		blade_tip - side * 2.0,
	])
	draw_colored_polygon(blade, Color(0.62, 0.63, 0.6, 0.98))

	var edge := PackedVector2Array([
		blade_base + side * 1.5,
		blade_base + side * 5.5,
		blade_tip + curve,
	])
	draw_colored_polygon(edge, Color(0.9, 0.86, 0.72, 0.98))
	draw_polyline(PackedVector2Array([blade_base - side * 5.5, blade_tip - side * 2.0, blade_tip + curve]), Color(0.18, 0.12, 0.08, 0.58), 2.0)
	draw_line(blade_base + side * 5.5, blade_tip + curve, Color(0.86, 0.52, 0.22, 0.46), 2.0)

func _draw_sheath() -> void:
	var facing: Vector2 = _dash_direction.normalized()
	var sheath_direction: Vector2 = Vector2(0.34, 0.94).normalized()
	if facing.x < -0.25:
		sheath_direction.x *= -1.0
	var side := sheath_direction.orthogonal()
	var sheath_start := Vector2(-9.0, 2.0) + facing * 3.0
	var sheath_end := sheath_start + sheath_direction * 58.0
	var hilt_start := sheath_start - sheath_direction * 6.0
	draw_line(sheath_start, sheath_end, Color(0.018, 0.012, 0.009, 1.0), 11.0)
	draw_line(sheath_start, sheath_end, Color(0.18, 0.075, 0.035, 1.0), 7.0)
	draw_line(sheath_start + side * 4.0, sheath_end + side * 4.0, Color(0.54, 0.29, 0.12, 0.72), 2.0)
	draw_line(sheath_start - side * 7.0, sheath_start + side * 7.0, Color(0.62, 0.34, 0.16, 0.95), 4.0)
	draw_line(hilt_start, sheath_start + sheath_direction * 11.0, Color(0.035, 0.022, 0.018, 1.0), 8.0)
	draw_line(hilt_start, sheath_start + sheath_direction * 11.0, Color(0.32, 0.17, 0.08, 1.0), 4.0)
	draw_circle(sheath_start + side * 2.0, 4.5, Color(0.76, 0.58, 0.42, 0.98))
	draw_arc(sheath_start, 12.0, sheath_direction.angle() + PI * 0.44, sheath_direction.angle() + PI * 1.5, 12, Color(0.78, 0.45, 0.2, 0.95), 3.0)

func _is_blade_unsheathed() -> bool:
	return _weapon_windup_remaining > 0.0 or _weapon_active_remaining > 0.0 or _weapon_recovery_remaining > 0.0 or _weapon_sheathe_delay_remaining > 0.0

func _get_blade_direction() -> Vector2:
	if _weapon_windup_remaining > 0.0:
		return _weapon_swing_direction.rotated(-weapon_arc * 0.52).normalized()
	if _weapon_active_remaining > 0.0:
		var swing_progress := 1.0 - _weapon_active_remaining / weapon_active_time
		return _weapon_swing_direction.rotated(lerpf(-weapon_arc * 0.5, weapon_arc * 0.5, swing_progress)).normalized()
	if _weapon_recovery_remaining > 0.0:
		return _weapon_swing_direction.rotated(weapon_arc * 0.45).normalized()
	return _dash_direction.normalized()

func _update_weapon_timers(delta: float) -> void:
	_weapon_cooldown_remaining = max(0.0, _weapon_cooldown_remaining - delta)
	_weapon_sheathe_delay_remaining = max(0.0, _weapon_sheathe_delay_remaining - delta)
	_weapon_parry_remaining = max(0.0, _weapon_parry_remaining - delta)

	if _weapon_windup_remaining > 0.0:
		_weapon_windup_remaining = max(0.0, _weapon_windup_remaining - delta)
		if _weapon_windup_remaining <= 0.0:
			_weapon_active_remaining = weapon_active_time
			weapon_slashed.emit(global_position, _weapon_swing_direction, weapon_range, weapon_arc, weapon_damage)
		return

	if _weapon_active_remaining > 0.0:
		_weapon_active_remaining = max(0.0, _weapon_active_remaining - delta)
		if _weapon_active_remaining <= 0.0:
			_weapon_recovery_remaining = weapon_recovery_time
		return

	if _weapon_recovery_remaining > 0.0:
		var was_recovering := _weapon_recovery_remaining > 0.0
		_weapon_recovery_remaining = max(0.0, _weapon_recovery_remaining - delta)
		if was_recovering and _weapon_recovery_remaining <= 0.0:
			_weapon_sheathe_delay_remaining = weapon_sheathe_delay

func set_arena_bounds(arena: Rect2) -> void:
	_arena_bounds = arena.grow(-PLAYER_RADIUS)

func _read_movement_input() -> Vector2:
	var keyboard := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if keyboard.length_squared() > 0.001:
		return keyboard.normalized()
	if _touch_vector.length_squared() > 0.001:
		return _touch_vector.normalized()
	return Vector2.ZERO

func _keep_inside_arena() -> void:
	if _arena_bounds.size == Vector2.ZERO or _arena_bounds.has_point(global_position):
		return

	global_position = global_position.clamp(_arena_bounds.position, _arena_bounds.end)
	velocity = Vector2.ZERO
