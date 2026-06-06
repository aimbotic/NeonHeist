extends "res://scripts/enemies/base_enemy.gd"

signal lunge_started(hunter: Node2D)

const ENEMY_SPRITE_SLUG := "enemy_hunter_male"
const HUNTER_LUNGE_TELL_VISUAL_VERSION := "hunter_wanted_lane_lunge_tell_v1"
const HUNTER_LUNGE_TELL_MARKER_COUNT := 11

var _strafe_sign := 1.0
var _windup_timer := 0.0
var _lunge_timer := 0.0
var _lunge_cooldown := 0.0
var _lunge_direction := Vector2.RIGHT
var _lunge_afterimages: Array[Dictionary] = []
var _afterimage_emit_timer := 0.0

func _ready() -> void:
	max_health = 65.0
	health = max_health
	speed = 215.0
	contact_damage = 14.0
	_strafe_sign = -1.0 if randf() < 0.5 else 1.0
	z_index = 13
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 108.0)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_lunge_timer = max(0.0, _lunge_timer - delta)
	_lunge_cooldown = max(0.0, _lunge_cooldown - delta)
	_update_lunge_afterimages(delta)

	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)
	if _lunge_timer > 0.0:
		velocity = _lunge_direction * speed * 2.65 * (1.0 + alert_level * 0.12) * _speed_multiplier()
		move_and_slide()
		_emit_lunge_afterimage(delta)
		_try_contact_damage(48.0)
		_request_enemy_visual_redraw()
		return

	if _windup_timer > 0.0:
		_windup_timer = max(0.0, _windup_timer - delta)
		_lunge_direction = to_player
		velocity = Vector2.ZERO
		if _windup_timer <= 0.0:
			_lunge_timer = 0.22
			lunge_started.emit(self)
		move_and_slide()
		_request_enemy_visual_redraw()
		return

	if distance <= 390.0 + alert_level * 38.0 and _lunge_cooldown <= 0.0:
		_windup_timer = 0.34
		_lunge_cooldown = 1.2
		_lunge_direction = to_player
		velocity = Vector2.ZERO
		_request_enemy_visual_redraw()
		return

	var strafe: Vector2 = to_player.orthogonal() * _strafe_sign
	var aggression: float = clamp((520.0 - distance) / 520.0, 0.0, 1.0)
	var desired: Vector2 = (to_player + strafe * (0.45 - aggression * 0.35)).normalized()
	velocity = desired * speed * (1.0 + alert_level * 0.16) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(42.0)
	_request_enemy_visual_redraw()

func has_attack_tell() -> bool:
	return _windup_timer > 0.0

func get_attack_tell_strength() -> float:
	if _windup_timer <= 0.0:
		return 0.0
	return clampf(1.0 - _windup_timer / 0.34, 0.0, 1.0)

func get_hunter_lunge_tell_visual_version() -> String:
	return HUNTER_LUNGE_TELL_VISUAL_VERSION

func get_hunter_lunge_tell_marker_count() -> int:
	return HUNTER_LUNGE_TELL_MARKER_COUNT

func has_lunge_afterimage() -> bool:
	return not _lunge_afterimages.is_empty()

func _update_lunge_afterimages(delta: float) -> void:
	for ghost in _lunge_afterimages:
		ghost["age"] = float(ghost.get("age", 0.0)) + delta
	_lunge_afterimages = _lunge_afterimages.filter(func(ghost: Dictionary) -> bool:
		return float(ghost.get("age", 0.0)) < float(ghost.get("life", 0.16))
	)
	_afterimage_emit_timer = maxf(0.0, _afterimage_emit_timer - delta)

func _emit_lunge_afterimage(delta: float) -> void:
	if _afterimage_emit_timer > 0.0:
		return
	_afterimage_emit_timer = 0.035
	_lunge_afterimages.append({
		"offset": -_lunge_direction.normalized() * (28.0 + float(_lunge_afterimages.size()) * 10.0),
		"age": 0.0,
		"life": 0.16,
		"facing": _lunge_direction.normalized(),
	})
	if _lunge_afterimages.size() > 4:
		_lunge_afterimages.pop_front()
	if vfx_layer != null:
		vfx_layer.trail_pop(global_position - _lunge_direction.normalized() * 34.0, Color(0.78, 0.42, 0.18))

func _draw() -> void:
	_draw_character_shadow(1.0)
	var color := _health_color(Color(0.72, 0.18, 0.08))
	var facing := _lunge_direction.normalized()
	if player != null and _lunge_timer <= 0.0 and _windup_timer <= 0.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	_draw_lunge_afterimages(facing)
	if _windup_timer > 0.0:
		var charge := get_attack_tell_strength()
		color = Color(0.86, 0.62, 0.36) if int(charge * 10.0) % 2 == 0 else Color(0.72, 0.18, 0.08)
		_draw_wanted_lunge_lane(facing, side, charge)
	elif _lunge_timer > 0.0:
		draw_line(-_lunge_direction * 34.0, -_lunge_direction * 58.0, Color(0.62, 0.34, 0.16, 0.65), 7.0)
	if _has_enemy_sprite():
		var windup_ratio := 1.0 - _windup_timer / 0.34 if _windup_timer > 0.0 else 0.0
		var lunge_ratio := _lunge_timer / 0.22 if _lunge_timer > 0.0 else 0.0
		var pose_scale := Vector2(1.0 + windup_ratio * 0.1 + lunge_ratio * 0.06, 1.0 - windup_ratio * 0.08 + lunge_ratio * 0.03)
		var pose_offset := -facing * windup_ratio * 6.0 + facing * lunge_ratio * 12.0
		_draw_enemy_sprite(facing, pose_offset, pose_scale, side.x * 0.05 * windup_ratio)
		_draw_hunter_blade_overlay(facing, side, color, maxf(windup_ratio, lunge_ratio))
		_draw_enemy_role_silhouette_accent(facing, "hunter", color, 0.52 + maxf(windup_ratio, lunge_ratio) * 0.45)
		return
	_draw_enemy_human_legs(facing, side, color, 1.0, 1.25)

	var cloak := PackedVector2Array([
		facing * 25.0,
		side * 15.0 + facing * 4.0,
		side * 11.0 - facing * 24.0,
		-side * 11.0 - facing * 24.0,
		-side * 15.0 + facing * 4.0,
	])
	var brim := PackedVector2Array([
		facing * 19.0,
		side * 20.0 + facing * 8.0,
		side * 23.0,
		side * 7.0 - facing * 8.0,
		-side * 7.0 - facing * 8.0,
		-side * 23.0,
		-side * 20.0 + facing * 8.0,
	])

	draw_colored_polygon(cloak, Color(0.055, 0.012, 0.008, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[0]]), color, 4.0)
	draw_line(-side * 9.0 + facing * 5.0, side * 9.0 + facing * 5.0, Color(0.9, 0.1, 0.035, 0.94), 5.0)
	draw_line(-side * 14.0 + facing * 2.0, -side * 29.0 - facing * 3.0, Color(0.03, 0.018, 0.014, 1.0), 5.0)
	draw_line(side * 13.0 + facing * 2.0, side * 28.0 - facing * 3.0, Color(0.03, 0.018, 0.014, 1.0), 5.0)
	draw_circle(facing * 10.0, 8.0, Color(0.46, 0.28, 0.18, 1.0))
	draw_colored_polygon(brim, Color(0.008, 0.006, 0.005, 1.0))
	draw_line(facing * 8.0 - side * 9.0, facing * 10.0 + side * 9.0, Color(0.72, 0.18, 0.08, 0.85), 3.0)
	draw_line(facing * 13.0 - side * 9.0, facing * 46.0 - side * 18.0, Color(0.9, 0.9, 0.72, 0.9), 4.0)
	draw_line(facing * 12.0, facing * 42.0 + side * 8.0, Color(0.86, 0.62, 0.36, 0.8), 3.0)
	_draw_enemy_role_silhouette_accent(facing, "hunter", color, 0.6)

func _draw_lunge_afterimages(facing: Vector2) -> void:
	if _lunge_afterimages.is_empty():
		return
	var side := facing.orthogonal()
	for ghost in _lunge_afterimages:
		var age := float(ghost.get("age", 0.0))
		var life := maxf(0.01, float(ghost.get("life", 0.16)))
		var fade := 1.0 - age / life
		var offset: Vector2 = ghost.get("offset", Vector2.ZERO)
		if _has_enemy_sprite():
			var texture := _get_enemy_texture_for_direction(_get_enemy_visual_facing(facing))
			if texture != null:
				var visual_size := _get_enemy_sprite_size(texture)
				var draw_position := Vector2(-visual_size.x * 0.5, -visual_size.y * 0.5 + 8.0) + offset
				draw_texture_rect(texture, Rect2(draw_position, visual_size), false, Color(0.94, 0.38, 0.14, 0.28 * fade))
				continue
		var cloak := PackedVector2Array([
			offset + facing * 23.0,
			offset + side * 13.0 + facing * 2.0,
			offset + side * 10.0 - facing * 22.0,
			offset - side * 10.0 - facing * 22.0,
			offset - side * 13.0 + facing * 2.0,
		])
		draw_colored_polygon(cloak, Color(0.74, 0.18, 0.08, 0.24 * fade))
		draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[0]]), Color(0.95, 0.58, 0.18, 0.28 * fade), 3.0)
		draw_circle(offset + facing * 8.0, 7.0, Color(0.24, 0.1, 0.035, 0.18 * fade))

func _draw_wanted_lunge_lane(facing: Vector2, side: Vector2, charge: float) -> void:
	var lane_length := lerpf(118.0, 184.0, charge)
	var lane_width := lerpf(16.0, 31.0, charge)
	var start := facing * 18.0
	var end := facing * lane_length
	var amber := Color(1.0, 0.62, 0.18, lerpf(0.42, 0.92, charge))
	var bone := Color(1.0, 0.9, 0.58, lerpf(0.22, 0.66, charge))
	var blood := Color(0.72, 0.055, 0.03, lerpf(0.22, 0.58, charge))
	var shadow := Color(0.065, 0.022, 0.01, lerpf(0.34, 0.56, charge))
	draw_line(start - side * lane_width + Vector2(0.0, 6.0), end - side * lane_width + Vector2(0.0, 6.0), shadow, 7.0)
	draw_line(start + side * lane_width + Vector2(0.0, 6.0), end + side * lane_width + Vector2(0.0, 6.0), shadow, 7.0)
	draw_line(start - side * lane_width, end - side * lane_width, amber, lerpf(3.0, 6.0, charge))
	draw_line(start + side * lane_width, end + side * lane_width, amber.darkened(0.1), lerpf(3.0, 6.0, charge))
	draw_line(facing * 12.0, end + facing * 10.0, bone, lerpf(2.5, 5.0, charge))
	draw_arc(Vector2.ZERO, lerpf(48.0, 25.0, charge), 0.0, TAU, 26, blood, lerpf(3.0, 5.0, charge))
	draw_line(-side * 30.0, side * 30.0, Color(0.04, 0.014, 0.006, 0.62), 5.0)
	draw_line(-side * 22.0 + facing * 3.0, side * 22.0 + facing * 3.0, bone, 2.3)
	for i in range(4):
		var t := (float(i) + 0.25) / 4.25
		var center := start.lerp(end, t)
		var claw_len := lerpf(15.0, 27.0, charge)
		var side_sign := -1.0 if i % 2 == 0 else 1.0
		draw_line(center + side * lane_width * side_sign, center + side * (lane_width + claw_len) * side_sign - facing * 7.0, shadow, 4.0)
		draw_line(center + side * (lane_width - 5.0) * side_sign, center + side * (lane_width + claw_len - 4.0) * side_sign - facing * 7.0, blood.lightened(0.14), 2.0)
	for corner_sign_value in [-1.0, 1.0]:
		var corner_sign := float(corner_sign_value)
		var near_corner: Vector2 = start + side * lane_width * corner_sign
		var far_corner: Vector2 = end + side * lane_width * corner_sign
		draw_line(near_corner, near_corner + facing * 24.0, bone, 2.0)
		draw_line(near_corner, near_corner - side * corner_sign * 16.0, bone, 2.0)
		draw_line(far_corner, far_corner - facing * 25.0, amber, 2.5)
		draw_line(far_corner, far_corner - side * corner_sign * 18.0, amber, 2.5)
	draw_circle(end, lerpf(5.0, 10.0, charge), Color(1.0, 0.74, 0.22, 0.2 + charge * 0.22))

func _draw_hunter_blade_overlay(facing: Vector2, side: Vector2, accent: Color, intensity: float) -> void:
	var glow := clampf(intensity, 0.0, 1.0)
	var hand := facing * 12.0 - side * 10.0
	var tip := facing * (48.0 + glow * 12.0) - side * (19.0 + glow * 4.0)
	draw_line(hand, tip, Color(0.08, 0.045, 0.022, 0.92), 7.0)
	draw_line(hand + facing * 4.0, tip, Color(0.92, 0.82, 0.56, 0.9), 3.0)
	if glow > 0.0:
		draw_line(Vector2.ZERO, facing * (48.0 + glow * 16.0), accent.lightened(0.25), 3.0)
