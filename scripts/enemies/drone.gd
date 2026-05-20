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
	var color := _health_color(Color(0.15, 0.95, 1.0))
	if _swarm_warning_time > 0.0:
		var pulse := _swarm_warning_time / 0.24
		draw_circle(Vector2.ZERO, lerpf(38.0, 24.0, pulse), Color(1.0, 0.18, 0.82, 0.3 * pulse))
		draw_arc(Vector2.ZERO, lerpf(44.0, 26.0, pulse), 0.0, TAU, 24, Color(1.0, 0.18, 0.82, 0.8 * pulse), 4.0)
	draw_circle(Vector2.ZERO, 18.0, Color(0.03, 0.02, 0.07, 0.98))
	draw_arc(Vector2.ZERO, 22.0, 0.0, TAU, 24, color, 3.0)
	draw_line(Vector2(-20, 0), Vector2(20, 0), Color(1.0, 0.18, 0.82), 2.0)
