class_name Player
extends CharacterBody2D

signal dash_used
signal player_damaged(amount: float)
signal player_down

var max_speed := 420.0
var acceleration := 2600.0
var dash_speed := 1180.0
var dash_duration := 0.13
var dash_cooldown := 0.9
var max_health := 100.0
var health := 100.0
var invulnerable := false

var _dash_time := 0.0
var _dash_cooldown_remaining := 0.0
var _dash_direction := Vector2.RIGHT
var _touch_origin := Vector2.ZERO
var _touch_vector := Vector2.ZERO
var _touch_active := false

func _ready() -> void:
	z_index = 20

func _physics_process(delta: float) -> void:
	_dash_cooldown_remaining = max(0.0, _dash_cooldown_remaining - delta)

	var input_vector := _read_movement_input()
	if input_vector.length_squared() > 0.001:
		_dash_direction = input_vector.normalized()

	if _dash_time > 0.0:
		_dash_time -= delta
		velocity = _dash_direction * dash_speed
	else:
		invulnerable = false
		var target_velocity := input_vector * max_speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)

	move_and_slide()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color(0.07, 0.03, 0.12, 0.95))
	draw_arc(Vector2.ZERO, 28.0, -PI * 0.2, PI * 1.2, 18, Color(0.2, 1.0, 1.0), 4.0)
	draw_line(Vector2.ZERO, _dash_direction * 32.0, Color(1.0, 0.18, 0.82), 4.0)
	if invulnerable:
		draw_arc(Vector2.ZERO, 38.0, 0.0, TAU, 32, Color(1.0, 1.0, 1.0, 0.65), 3.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_origin = event.position
			_touch_active = true
		else:
			_touch_active = false
			_touch_vector = Vector2.ZERO
	elif event is InputEventScreenDrag and _touch_active:
		_touch_vector = (event.position - _touch_origin).limit_length(96.0) / 96.0

func try_dash() -> void:
	if _dash_cooldown_remaining > 0.0:
		return
	_dash_time = dash_duration
	_dash_cooldown_remaining = dash_cooldown
	invulnerable = true
	dash_used.emit()

func take_damage(amount: float) -> void:
	if invulnerable or health <= 0.0:
		return
	health = max(0.0, health - amount)
	player_damaged.emit(amount)
	if health <= 0.0:
		player_down.emit()

func get_dash_fraction() -> float:
	return 1.0 - (_dash_cooldown_remaining / dash_cooldown)

func _read_movement_input() -> Vector2:
	var keyboard := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if keyboard.length_squared() > 0.001:
		return keyboard.normalized()
	if _touch_vector.length_squared() > 0.001:
		return _touch_vector.normalized()
	return Vector2.ZERO
