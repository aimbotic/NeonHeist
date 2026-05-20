extends "res://scripts/enemies/base_enemy.gd"

var _patrol_angle := 0.0
var _home := Vector2.ZERO

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

	var distance := global_position.distance_to(player.global_position)
	var desired := Vector2.ZERO
	if distance < 340.0 + alert_level * 80.0:
		desired = global_position.direction_to(player.global_position)
	else:
		_patrol_angle += delta * (0.8 + alert_level * 0.16)
		var patrol_target := _home + Vector2(cos(_patrol_angle), sin(_patrol_angle * 1.7)) * 120.0
		desired = global_position.direction_to(patrol_target)

	velocity = desired * speed * (1.0 + alert_level * 0.12) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage()
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(0.15, 0.95, 1.0))
	draw_circle(Vector2.ZERO, 18.0, Color(0.03, 0.02, 0.07, 0.98))
	draw_arc(Vector2.ZERO, 22.0, 0.0, TAU, 24, color, 3.0)
	draw_line(Vector2(-20, 0), Vector2(20, 0), Color(1.0, 0.18, 0.82), 2.0)
