extends "res://scripts/enemies/base_enemy.gd"

signal lunge_released(duelist: Node2D, variant_id: String, variant_name: String, origin: Vector2, direction: Vector2)

const ENEMY_SPRITE_SLUG := "enemy_duelist_male"

var _strafe_sign := 1.0
var _draw_timer := 0.0
var _dash_timer := 0.0
var _attack_cooldown := 0.7
var _duel_direction := Vector2.RIGHT
var variant_id := "black_sash"
var variant_name := "BLACK SASH DUELIST"
var variant_title := "Boss"
var variant_accent := Color(0.95, 0.08, 0.035)
var _draw_duration := 0.28
var _dash_duration := 0.18
var _dash_speed_multiplier := 3.0
var _cooldown_duration := 1.05
var _preferred_range := 430.0
var _contact_range := 54.0

func has_attack_tell() -> bool:
	return _draw_timer > 0.0

func get_attack_tell_strength() -> float:
	if _draw_timer <= 0.0:
		return 0.0
	return 1.0 - _draw_timer / maxf(_draw_duration, 0.01)

func has_pre_dash_boot_dust_tell() -> bool:
	return _draw_timer > 0.0 and get_attack_tell_strength() > 0.08

func has_blackglass_killbox_windup_tell() -> bool:
	return variant_id == "june_blackglass" and _draw_timer > 0.0 and get_attack_tell_strength() > 0.1

func _ready() -> void:
	max_health = 230.0
	health = max_health
	speed = 245.0
	contact_damage = 22.0
	_strafe_sign = -1.0 if randf() < 0.5 else 1.0
	z_index = 14
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 112.0)

func configure_variant(profile: Dictionary) -> void:
	variant_id = str(profile.get("id", variant_id))
	variant_name = str(profile.get("name", variant_name))
	variant_title = str(profile.get("title", variant_title))
	variant_accent = profile.get("accent", variant_accent)
	max_health = float(profile.get("health", max_health))
	health = max_health
	speed = float(profile.get("speed", speed))
	contact_damage = float(profile.get("contact_damage", contact_damage))
	_draw_duration = float(profile.get("draw_duration", _draw_duration))
	_dash_duration = float(profile.get("dash_duration", _dash_duration))
	_dash_speed_multiplier = float(profile.get("dash_speed_multiplier", _dash_speed_multiplier))
	_cooldown_duration = float(profile.get("cooldown", _cooldown_duration))
	_preferred_range = float(profile.get("range", _preferred_range))
	_contact_range = float(profile.get("contact_range", _contact_range))
	_attack_cooldown = minf(_attack_cooldown, _cooldown_duration)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_attack_cooldown = max(0.0, _attack_cooldown - delta)
	_draw_timer = max(0.0, _draw_timer - delta)
	_dash_timer = max(0.0, _dash_timer - delta)
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)

	if _dash_timer > 0.0:
		velocity = _duel_direction * speed * _dash_speed_multiplier * _speed_multiplier()
		move_and_slide()
		_try_contact_damage(_contact_range)
		_request_enemy_visual_redraw()
		return

	if _draw_timer > 0.0:
		_duel_direction = to_player
		velocity = Vector2.ZERO
		if _draw_timer <= delta:
			_dash_timer = _dash_duration
			lunge_released.emit(self, variant_id, variant_name, global_position, _duel_direction)
		move_and_slide()
		_request_enemy_visual_redraw()
		return

	if distance <= _preferred_range and _attack_cooldown <= 0.0:
		_draw_timer = _draw_duration
		_attack_cooldown = _cooldown_duration
		_duel_direction = to_player
		_request_enemy_visual_redraw()
		return

	var strafe := to_player.orthogonal() * _strafe_sign
	var desired := (to_player * 0.7 + strafe * 0.5).normalized()
	if distance < 150.0:
		desired = (-to_player + strafe * 0.4).normalized()
	velocity = desired * speed * (1.0 + alert_level * 0.1) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(44.0)
	_request_enemy_visual_redraw()

func _draw() -> void:
	_draw_character_shadow(1.06, Vector2(64.0, 86.0))
	var color := _health_color(variant_accent)
	var facing := _duel_direction.normalized()
	if player != null and _draw_timer <= 0.0 and _dash_timer <= 0.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	if _draw_timer > 0.0:
		var charge := get_attack_tell_strength()
		var warning_color := variant_accent.lightened(0.42)
		warning_color.a = lerpf(0.52, 0.96, charge)
		var lane_length := 150.0 + speed * _dash_speed_multiplier * _dash_duration
		var lane_width := lerpf(18.0, 34.0, charge)
		draw_line(facing * 22.0 - side * lane_width, facing * lane_length - side * lane_width, Color(0.12, 0.025, 0.015, 0.5), 6.0)
		draw_line(facing * 22.0 + side * lane_width, facing * lane_length + side * lane_width, Color(0.12, 0.025, 0.015, 0.5), 6.0)
		draw_line(facing * 18.0, facing * lane_length, warning_color, lerpf(4.0, 9.0, charge))
		draw_arc(Vector2.ZERO, lerpf(58.0, 28.0, charge), 0.0, TAU, 30, warning_color, 5.0)
		draw_line(-side * 28.0, side * 28.0, Color(1.0, 0.92, 0.58, 0.76), 4.0)
		_draw_pre_dash_boot_dust(facing, side, charge)
		if variant_id == "june_blackglass":
			_draw_blackglass_windup_brackets(facing, side, charge)
	elif _dash_timer > 0.0:
		draw_line(-facing * 32.0, -facing * 76.0, variant_accent.darkened(0.12), 8.0)

	if _has_enemy_sprite():
		var draw_ratio := get_attack_tell_strength()
		var dash_ratio := _dash_timer / maxf(_dash_duration, 0.01) if _dash_timer > 0.0 else 0.0
		var pose_offset := -facing * draw_ratio * 7.0 + facing * dash_ratio * 9.0
		var pose_scale := Vector2(1.0 + draw_ratio * 0.07 + dash_ratio * 0.04, 1.0 - draw_ratio * 0.06 + dash_ratio * 0.03)
		_draw_enemy_sprite(facing, pose_offset, pose_scale, side.x * 0.04 * draw_ratio)
		_draw_duelist_weapon_overlay(facing, side, color, maxf(draw_ratio, dash_ratio))
		_draw_enemy_role_silhouette_accent(facing, "duelist", color, 0.6 + maxf(draw_ratio, dash_ratio) * 0.35)
		return
	_draw_enemy_human_legs(facing, side, color, 1.06, 1.2)
	var cloak := PackedVector2Array([
		facing * 28.0,
		side * 16.0 + facing * 6.0,
		side * 15.0 - facing * 30.0,
		-side * 15.0 - facing * 30.0,
		-side * 16.0 + facing * 6.0,
	])
	var hat := PackedVector2Array([
		facing * 21.0,
		side * 24.0 + facing * 7.0,
		side * 28.0,
		-side * 28.0,
		-side * 24.0 + facing * 7.0,
	])
	draw_colored_polygon(cloak, Color(0.045, 0.006, 0.005, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[0]]), color, 5.0)
	draw_line(-side * 11.0 + facing * 5.0, side * 11.0 + facing * 5.0, Color(1.0, 0.12, 0.04, 0.96), 5.0)
	draw_circle(facing * 11.0, 8.0, Color(0.56, 0.36, 0.22, 1.0))
	draw_colored_polygon(hat, Color(0.006, 0.004, 0.003, 1.0))
	draw_line(facing * 10.0 - side * 9.0, facing * 11.0 + side * 9.0, Color(1.0, 0.72, 0.32, 0.88), 3.0)
	draw_line(facing * 12.0 - side * 12.0, facing * 52.0 - side * 22.0, Color(0.94, 0.9, 0.72, 0.94), 4.0)
	draw_line(facing * 17.0 + side * 9.0, facing * 42.0 + side * 20.0, Color(0.24, 0.1, 0.035, 1.0), 5.0)
	_draw_enemy_role_silhouette_accent(facing, "duelist", color, 0.65)

func _draw_duelist_weapon_overlay(facing: Vector2, side: Vector2, accent: Color, intensity: float) -> void:
	var glow := clampf(intensity, 0.0, 1.0)
	var hand := facing * 12.0 - side * 13.0
	var blade_tip := facing * (50.0 + glow * 14.0) - side * (22.0 + glow * 5.0)
	draw_line(hand, blade_tip, Color(0.08, 0.04, 0.018, 0.9), 7.0)
	draw_line(hand + facing * 5.0, blade_tip, Color(0.94, 0.84, 0.56, 0.94), 3.0)
	draw_line(facing * 9.0 + side * 10.0, facing * 34.0 + side * 22.0, Color(0.24, 0.1, 0.035, 0.92), 5.0)
	if glow > 0.0:
		draw_arc(Vector2.ZERO, 38.0 + glow * 12.0, facing.angle() - 0.7, facing.angle() + 0.7, 16, accent.lightened(0.35), 3.0)

func _draw_pre_dash_boot_dust(facing: Vector2, side: Vector2, charge: float) -> void:
	var alpha := lerpf(0.2, 0.76, charge)
	var heel_line := -facing * lerpf(24.0, 38.0, charge)
	var back_foot := heel_line - side * 16.0
	var lead_foot := -facing * 12.0 + side * 13.0
	var dust := Color(0.22, 0.095, 0.035, 0.26 * alpha)
	var brass := variant_accent.lightened(0.56)
	brass.a = 0.32 * alpha
	draw_arc(back_foot, lerpf(12.0, 36.0, charge), facing.angle() + PI - 0.92, facing.angle() + PI + 0.42, 18, dust, lerpf(5.0, 1.6, charge))
	draw_arc(lead_foot, lerpf(9.0, 24.0, charge), facing.angle() + PI - 0.34, facing.angle() + PI + 0.84, 16, dust.lightened(0.18), lerpf(4.0, 1.4, charge))
	for i in range(3):
		var offset := -facing * (18.0 + float(i) * 9.0) - side * (8.0 + float(i) * 4.0)
		draw_circle(offset, lerpf(5.0, 2.0, charge), dust)
	draw_line(back_foot - side * 8.0, back_foot + side * 5.0 + facing * 4.0, brass, lerpf(4.0, 1.6, charge))
	draw_line(lead_foot + side * 7.0, lead_foot - side * 4.0 + facing * 5.0, brass, lerpf(3.0, 1.2, charge))

func _draw_blackglass_windup_brackets(facing: Vector2, side: Vector2, charge: float) -> void:
	var alpha := lerpf(0.24, 0.82, charge)
	var accent := variant_accent.lightened(0.28)
	accent.a = alpha
	var glass := Color(0.98, 0.86, 0.58, 0.42 * alpha)
	var shadow := Color(0.07, 0.008, 0.012, 0.58 * alpha)
	var half_width := lerpf(30.0, 46.0, charge)
	var back := -facing * lerpf(24.0, 18.0, charge)
	var front := facing * lerpf(38.0, 56.0, charge)
	var side_len := lerpf(11.0, 18.0, charge)
	var face_len := lerpf(12.0, 22.0, charge)
	var corners := [
		{"point": front + side * half_width, "side_sign": 1.0, "face_sign": -1.0},
		{"point": front - side * half_width, "side_sign": -1.0, "face_sign": -1.0},
		{"point": back + side * half_width, "side_sign": 1.0, "face_sign": 1.0},
		{"point": back - side * half_width, "side_sign": -1.0, "face_sign": 1.0},
	]
	for corner in corners:
		var point: Vector2 = corner["point"]
		var side_sign := float(corner["side_sign"])
		var face_sign := float(corner["face_sign"])
		draw_line(point, point - side * side_sign * side_len, shadow, 7.0)
		draw_line(point, point + facing * face_sign * face_len, shadow, 7.0)
		draw_line(point, point - side * side_sign * side_len, accent, 3.0)
		draw_line(point, point + facing * face_sign * face_len, accent, 3.0)
	draw_line(front - side * (half_width * 0.62), back + side * (half_width * 0.62), shadow, 5.0)
	draw_line(front - side * (half_width * 0.62), back + side * (half_width * 0.62), glass, 2.0)
	draw_line(front + side * (half_width * 0.48), back - side * (half_width * 0.48), shadow, 4.0)
	draw_line(front + side * (half_width * 0.48), back - side * (half_width * 0.48), glass, 1.6)
