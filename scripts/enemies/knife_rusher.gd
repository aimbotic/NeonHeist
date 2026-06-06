extends "res://scripts/enemies/base_enemy.gd"

const ENEMY_SPRITE_SLUG := "enemy_knife_rusher_male"

var _patrol_angle := 0.0
var _home := Vector2.ZERO
var _was_chasing := false
var _swarm_warning_time := 0.0

func _ready() -> void:
	max_health = 38.0
	health = max_health
	speed = 165.0
	contact_damage = 8.0
	_home = global_position
	_patrol_angle = randf() * TAU
	z_index = 12
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 96.0)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_swarm_warning_time = max(0.0, _swarm_warning_time - delta)
	var distance := global_position.distance_to(player.global_position)
	var desired := Vector2.ZERO
	var chase_range := 340.0 + alert_level * 80.0
	var chasing := distance < chase_range
	if chasing:
		if not _was_chasing:
			_swarm_warning_time = 0.24
		desired = global_position.direction_to(player.global_position)
	else:
		_patrol_angle += delta * (0.8 + alert_level * 0.16)
		var patrol_target := _home + Vector2(cos(_patrol_angle), sin(_patrol_angle * 1.7)) * 120.0
		desired = global_position.direction_to(patrol_target)

	_was_chasing = chasing
	var warning_multiplier := 0.18 if _swarm_warning_time > 0.0 else 1.0
	velocity = desired * speed * (1.0 + alert_level * 0.12) * _speed_multiplier() * warning_multiplier
	move_and_slide()
	_try_contact_damage()
	_request_enemy_visual_redraw()

func _draw() -> void:
	_draw_character_shadow(0.82)
	var color := _health_color(Color(0.68, 0.36, 0.16))
	var facing := Vector2.RIGHT
	if player != null and global_position.distance_squared_to(player.global_position) > 1.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	if _swarm_warning_time > 0.0:
		var pulse := _swarm_warning_time / 0.24
		draw_circle(Vector2.ZERO, lerpf(38.0, 24.0, pulse), Color(0.72, 0.08, 0.04, 0.28 * pulse))
		draw_arc(Vector2.ZERO, lerpf(44.0, 26.0, pulse), 0.0, TAU, 24, Color(0.82, 0.32, 0.1, 0.78 * pulse), 4.0)
		_draw_swarm_warning_wedge(facing, side, pulse)
	if _has_enemy_sprite():
		var warning_ratio := _swarm_warning_time / 0.24
		var pose_scale := Vector2(1.0 + warning_ratio * 0.1, 1.0 - warning_ratio * 0.08)
		_draw_enemy_sprite(facing, -facing * 5.0 * warning_ratio, pose_scale, side.x * 0.03 * warning_ratio)
		if _swarm_warning_time > 0.0:
			_draw_swarm_warning_cues(facing, side, warning_ratio)
		_draw_enemy_role_silhouette_accent(facing, "knife_rusher", Color(0.86, 0.38, 0.08), 0.5 + warning_ratio * 0.5)
		return
	_draw_enemy_human_legs(facing, side, color, 0.82, 1.15)

	var coat := PackedVector2Array([
		facing * 22.0,
		side * 11.0 + facing * 3.0,
		side * 7.0 - facing * 18.0,
		-side * 7.0 - facing * 18.0,
		-side * 11.0 + facing * 3.0,
	])
	var scarf := PackedVector2Array([
		facing * 7.0 - side * 11.0,
		facing * 13.0 + side * 8.0,
		-facing * 4.0 + side * 10.0,
		-facing * 7.0 - side * 8.0,
	])
	draw_colored_polygon(coat, Color(0.075, 0.042, 0.024, 0.98))
	draw_polyline(PackedVector2Array([coat[0], coat[1], coat[2], coat[3], coat[4], coat[0]]), color, 3.0)
	draw_colored_polygon(scarf, Color(0.86, 0.38, 0.08, 0.96))
	draw_circle(facing * 11.0, 7.0, Color(0.52, 0.36, 0.22, 1.0))
	draw_line(facing * 13.0 - side * 9.0, facing * 14.0 + side * 9.0, Color(0.012, 0.008, 0.006, 0.98), 5.0)
	draw_line(facing * 18.0 - side * 9.0, facing * 17.0 + side * 9.0, Color(0.9, 0.48, 0.16, 0.78), 2.0)
	draw_line(-side * 11.0 + facing * 2.0, -side * 23.0 - facing * 2.0, Color(0.035, 0.022, 0.016, 1.0), 4.0)
	draw_line(side * 11.0 + facing * 2.0, side * 23.0 - facing * 2.0, Color(0.035, 0.022, 0.016, 1.0), 4.0)
	draw_line(facing * 18.0 - side * 4.0, facing * 32.0 - side * 2.0, Color(0.14, 0.075, 0.035), 5.0)
	draw_line(facing * 23.0 - side * 5.0, facing * 38.0 - side * 1.0, Color(0.82, 0.48, 0.18), 2.0)
	_draw_enemy_role_silhouette_accent(facing, "knife_rusher", Color(0.86, 0.38, 0.08), 0.58)
	if _swarm_warning_time > 0.0:
		_draw_swarm_warning_cues(facing, side, _swarm_warning_time / 0.24)

func _draw_swarm_warning_cues(facing: Vector2, side: Vector2, pulse: float) -> void:
	var alpha := clampf(pulse, 0.0, 1.0)
	var shoulder_left := facing * 8.0 - side * 19.0
	var shoulder_right := facing * 9.0 + side * 18.0
	var knife_tip := facing * (39.0 + 5.0 * alpha) - side * 2.0
	var knife_base := facing * 23.0 - side * 6.0
	draw_line(shoulder_left + facing * 2.0, shoulder_left + facing * 16.0, Color(1.0, 0.62, 0.2, 0.62 * alpha), 4.0)
	draw_line(shoulder_right + facing * 1.0, shoulder_right + facing * 13.0, Color(0.82, 0.12, 0.04, 0.58 * alpha), 4.0)
	draw_line(knife_base + Vector2(2.0, 3.0), knife_tip + Vector2(2.0, 3.0), Color(0.035, 0.018, 0.008, 0.32 * alpha), 5.0)
	draw_line(knife_base, knife_tip, Color(1.0, 0.86, 0.48, 0.86 * alpha), 3.0)
	for i in range(2):
		var side_sign := -1.0 if i == 0 else 1.0
		var boot_origin := -facing * 33.0 + side * side_sign * (14.0 + alpha * 4.0)
		draw_circle(boot_origin + facing * (6.0 * alpha), 5.0 + alpha * 2.0, Color(0.58, 0.35, 0.14, 0.2 * alpha))
		draw_arc(boot_origin, 11.0 + alpha * 5.0, 0.0, TAU, 16, Color(0.95, 0.62, 0.24, 0.2 * alpha), 2.0)

func _draw_swarm_warning_wedge(facing: Vector2, side: Vector2, pulse: float) -> void:
	var alpha := clampf(pulse, 0.0, 1.0)
	var reach := lerpf(62.0, 42.0, alpha)
	var width := lerpf(24.0, 16.0, alpha)
	var wedge := PackedVector2Array([
		facing * 8.0,
		facing * reach + side * width,
		facing * (reach + 18.0),
		facing * reach - side * width,
	])
	draw_colored_polygon(wedge, Color(0.72, 0.08, 0.035, 0.2 * alpha))
	draw_arc(facing * reach, width * 0.92, facing.angle() - 0.72, facing.angle() + 0.72, 14, Color(1.0, 0.62, 0.18, 0.44 * alpha), 3.0)
	for i in range(3):
		var spread := float(i - 1) * width * 0.58
		var tick_origin := facing * (reach + 6.0) + side * spread
		draw_circle(tick_origin, 3.0 + alpha * 1.5, Color(0.95, 0.48, 0.16, 0.32 * alpha))

func has_swarm_warning_tell() -> bool:
	return _swarm_warning_time > 0.0

func has_directional_swarm_warning_tell() -> bool:
	return _swarm_warning_time > 0.0
