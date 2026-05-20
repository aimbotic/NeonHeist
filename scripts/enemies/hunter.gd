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
	var color := _health_color(Color(1.0, 0.18, 0.82))
	if _windup_timer > 0.0:
		var charge := 1.0 - _windup_timer / 0.34
		color = Color.WHITE if int(charge * 10.0) % 2 == 0 else Color(1.0, 0.18, 0.82)
		draw_arc(Vector2.ZERO, lerpf(42.0, 26.0, charge), 0.0, TAU, 28, Color(1.0, 0.18, 0.82, 0.85), 4.0)
		draw_line(Vector2.ZERO, _lunge_direction * 54.0, Color(1.0, 0.18, 0.82, 0.95), 4.0)
	elif _lunge_timer > 0.0:
		draw_line(-_lunge_direction * 34.0, -_lunge_direction * 58.0, Color(0.2, 1.0, 1.0, 0.65), 7.0)
	var points := PackedVector2Array([
		Vector2(26, 0),
		Vector2(-18, -18),
		Vector2(-10, 0),
		Vector2(-18, 18),
	])
	draw_colored_polygon(points, Color(0.05, 0.02, 0.08, 0.98))
	var outline := PackedVector2Array([points[0], points[1], points[2], points[3], points[0]])
	draw_polyline(outline, color, 4.0)
	draw_circle(Vector2(4, 0), 5.0, Color(0.2, 1.0, 1.0))
