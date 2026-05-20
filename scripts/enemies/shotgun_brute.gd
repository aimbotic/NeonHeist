extends "res://scripts/enemies/base_enemy.gd"

var _fire_timer := 0.0
var _windup_timer := 0.0
var _aim_direction := Vector2.RIGHT

func _ready() -> void:
	max_health = 150.0
	health = max_health
	speed = 122.0
	contact_damage = 18.0
	z_index = 13

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_fire_timer = max(0.0, _fire_timer - delta)
	_windup_timer = max(0.0, _windup_timer - delta)
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)
	_aim_direction = to_player

	if _windup_timer > 0.0:
		velocity = Vector2.ZERO
		if _windup_timer <= delta:
			_fire_shotgun(distance)
		move_and_slide()
		queue_redraw()
		return

	if distance <= 260.0 and _fire_timer <= 0.0:
		_windup_timer = 0.36
		_fire_timer = 1.7
		velocity = Vector2.ZERO
		queue_redraw()
		return

	var desired := to_player
	if distance < 150.0:
		desired = -to_player
	velocity = desired * speed * (1.0 + alert_level * 0.08) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(44.0)
	queue_redraw()

func _fire_shotgun(distance: float) -> void:
	var spread := 0.52
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	if distance <= 285.0 and abs(_aim_direction.angle_to(to_player)) <= spread:
		player.take_damage(1.0)
	if vfx_layer != null:
		for i in range(5):
			var pellet_dir := _aim_direction.rotated(lerpf(-spread, spread, float(i) / 4.0))
			vfx_layer.beam(global_position + pellet_dir * 18.0, global_position + pellet_dir * 300.0, Color(0.95, 0.5, 0.18))

func _draw() -> void:
	var color := _health_color(Color(0.82, 0.34, 0.08))
	var facing := _aim_direction.normalized()
	var side := facing.orthogonal()
	if _windup_timer > 0.0:
		var charge := 1.0 - _windup_timer / 0.36
		draw_arc(Vector2.ZERO, lerpf(46.0, 26.0, charge), -0.4, TAU - 0.4, 30, Color(0.9, 0.28, 0.08, 0.84), 5.0)
		for i in range(5):
			draw_line(Vector2.ZERO, facing.rotated(lerpf(-0.52, 0.52, float(i) / 4.0)) * 180.0, Color(0.9, 0.42, 0.1, 0.36), 3.0)

	_draw_enemy_human_legs(facing, side, color, 1.14, 0.7)
	var coat := PackedVector2Array([
		facing * 21.0,
		side * 21.0 + facing * 4.0,
		side * 17.0 - facing * 27.0,
		-side * 17.0 - facing * 27.0,
		-side * 21.0 + facing * 4.0,
	])
	draw_colored_polygon(coat, Color(0.095, 0.045, 0.022, 0.98))
	draw_polyline(PackedVector2Array([coat[0], coat[1], coat[2], coat[3], coat[4], coat[0]]), color, 5.0)
	draw_circle(facing * 8.0, 9.0, Color(0.5, 0.32, 0.2, 1.0))
	draw_line(facing * 8.0 - side * 17.0, facing * 10.0 + side * 17.0, Color(0.012, 0.009, 0.008, 1.0), 8.0)
	draw_line(facing * 13.0 - side * 8.0, facing * 48.0 - side * 16.0, Color(0.2, 0.09, 0.035, 1.0), 7.0)
	draw_line(facing * 18.0 - side * 8.0, facing * 57.0 - side * 17.0, Color(0.86, 0.52, 0.22), 3.0)
	draw_line(-side * 17.0, side * 17.0, Color(0.86, 0.18, 0.08, 0.9), 4.0)
