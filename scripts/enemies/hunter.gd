extends "res://scripts/enemies/base_enemy.gd"

var _strafe_sign := 1.0
var _windup_timer := 0.0
var _lunge_timer := 0.0
var _lunge_cooldown := 0.0
var _lunge_direction := Vector2.RIGHT

func _ready() -> void:
	max_health = 65.0
	health = max_health
	speed = 215.0
	contact_damage = 14.0
	_strafe_sign = -1.0 if randf() < 0.5 else 1.0
	z_index = 13

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_lunge_timer = max(0.0, _lunge_timer - delta)
	_lunge_cooldown = max(0.0, _lunge_cooldown - delta)

	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)
	if _lunge_timer > 0.0:
		velocity = _lunge_direction * speed * 2.65 * (1.0 + alert_level * 0.12) * _speed_multiplier()
		move_and_slide()
		_try_contact_damage(48.0)
		queue_redraw()
		return

	if _windup_timer > 0.0:
		_windup_timer = max(0.0, _windup_timer - delta)
		_lunge_direction = to_player
		velocity = Vector2.ZERO
		if _windup_timer <= 0.0:
			_lunge_timer = 0.22
		move_and_slide()
		queue_redraw()
		return

	if distance <= 390.0 + alert_level * 38.0 and _lunge_cooldown <= 0.0:
		_windup_timer = 0.34
		_lunge_cooldown = 1.2
		_lunge_direction = to_player
		velocity = Vector2.ZERO
		queue_redraw()
		return

	var strafe: Vector2 = to_player.orthogonal() * _strafe_sign
	var aggression: float = clamp((520.0 - distance) / 520.0, 0.0, 1.0)
	var desired: Vector2 = (to_player + strafe * (0.45 - aggression * 0.35)).normalized()
	velocity = desired * speed * (1.0 + alert_level * 0.16) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(42.0)
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(0.72, 0.18, 0.08))
	var facing := _lunge_direction.normalized()
	if player != null and _lunge_timer <= 0.0 and _windup_timer <= 0.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	if _windup_timer > 0.0:
		var charge := 1.0 - _windup_timer / 0.34
		color = Color(0.86, 0.62, 0.36) if int(charge * 10.0) % 2 == 0 else Color(0.72, 0.18, 0.08)
		draw_arc(Vector2.ZERO, lerpf(42.0, 26.0, charge), 0.0, TAU, 28, Color(0.72, 0.18, 0.08, 0.85), 4.0)
		draw_line(Vector2.ZERO, _lunge_direction * 54.0, Color(0.86, 0.42, 0.16, 0.95), 4.0)
	elif _lunge_timer > 0.0:
		draw_line(-_lunge_direction * 34.0, -_lunge_direction * 58.0, Color(0.62, 0.34, 0.16, 0.65), 7.0)
	_draw_crawling_legs(facing, side, color, 1.0, 1.25)

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

	draw_colored_polygon(cloak, Color(0.018, 0.012, 0.01, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[0]]), color, 4.0)
	draw_line(-side * 14.0 + facing * 2.0, -side * 29.0 - facing * 3.0, Color(0.03, 0.018, 0.014, 1.0), 5.0)
	draw_line(side * 13.0 + facing * 2.0, side * 28.0 - facing * 3.0, Color(0.03, 0.018, 0.014, 1.0), 5.0)
	draw_circle(facing * 10.0, 8.0, Color(0.12, 0.07, 0.045, 1.0))
	draw_colored_polygon(brim, Color(0.008, 0.006, 0.005, 1.0))
	draw_line(facing * 8.0 - side * 9.0, facing * 10.0 + side * 9.0, Color(0.72, 0.18, 0.08, 0.85), 3.0)
	draw_line(facing * 12.0, facing * 42.0 + side * 8.0, Color(0.86, 0.62, 0.36, 0.8), 3.0)
