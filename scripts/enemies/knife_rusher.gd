extends "res://scripts/enemies/base_enemy.gd"

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
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(0.68, 0.36, 0.16))
	var facing := Vector2.RIGHT
	if player != null and global_position.distance_squared_to(player.global_position) > 1.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	if _swarm_warning_time > 0.0:
		var pulse := _swarm_warning_time / 0.24
		draw_circle(Vector2.ZERO, lerpf(38.0, 24.0, pulse), Color(0.72, 0.08, 0.04, 0.28 * pulse))
		draw_arc(Vector2.ZERO, lerpf(44.0, 26.0, pulse), 0.0, TAU, 24, Color(0.82, 0.32, 0.1, 0.78 * pulse), 4.0)
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
