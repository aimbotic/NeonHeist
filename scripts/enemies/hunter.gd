extends "res://scripts/enemies/base_enemy.gd"

var _strafe_sign := 1.0

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

	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)
	var strafe: Vector2 = to_player.orthogonal() * _strafe_sign
	var aggression: float = clamp((520.0 - distance) / 520.0, 0.0, 1.0)
	var desired: Vector2 = (to_player + strafe * (0.45 - aggression * 0.35)).normalized()
	velocity = desired * speed * (1.0 + alert_level * 0.16) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(42.0)
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(1.0, 0.18, 0.82))
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
