class_name Player
extends CharacterBody2D

signal dash_used
signal player_damaged(amount: float)
signal player_down
signal weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float)

var max_speed := 420.0
var acceleration := 2600.0
var dash_speed := 1180.0
var dash_duration := 0.13
var dash_cooldown := 0.9
var weapon_range := 118.0
var weapon_arc := 1.55
var weapon_damage := 32.0
var weapon_cooldown := 0.34
var max_health := 100.0
var health := 100.0
var invulnerable := false

const PLAYER_RADIUS := 22.0
const CORRIDOR_HALF_WIDTH := 36.0

var _playable_rooms: Array[Rect2] = []
var _playable_corridors: Array[Dictionary] = []

var _dash_time := 0.0
var _dash_cooldown_remaining := 0.0
var _weapon_cooldown_remaining := 0.0
var _weapon_flash_time := 0.0
var _dash_direction := Vector2.RIGHT
var _touch_origin := Vector2.ZERO
var _touch_vector := Vector2.ZERO
var _touch_active := false

func _ready() -> void:
	z_index = 20

func _physics_process(delta: float) -> void:
	_dash_cooldown_remaining = max(0.0, _dash_cooldown_remaining - delta)
	_weapon_cooldown_remaining = max(0.0, _weapon_cooldown_remaining - delta)
	_weapon_flash_time = max(0.0, _weapon_flash_time - delta)

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
	_keep_inside_maze()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color(0.07, 0.03, 0.12, 0.95))
	draw_arc(Vector2.ZERO, 28.0, -PI * 0.2, PI * 1.2, 18, Color(0.2, 1.0, 1.0), 4.0)
	draw_line(Vector2.ZERO, _dash_direction * 32.0, Color(1.0, 0.18, 0.82), 4.0)
	draw_line(_dash_direction * 18.0, _dash_direction * 48.0, Color(0.9, 1.0, 1.0, 0.9), 3.0)
	draw_line(_dash_direction * 24.0, _dash_direction * 66.0, Color(0.2, 1.0, 1.0, 0.78), 2.0)
	if _weapon_flash_time > 0.0:
		var t := _weapon_flash_time / 0.13
		var base_angle := _dash_direction.angle()
		draw_arc(Vector2.ZERO, weapon_range * (1.0 - t * 0.12), base_angle - weapon_arc * 0.5, base_angle + weapon_arc * 0.5, 18, Color(1.0, 0.18, 0.82, t), 8.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.72, base_angle - weapon_arc * 0.42, base_angle + weapon_arc * 0.42, 14, Color(0.2, 1.0, 1.0, t), 4.0)
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

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		try_weapon_attack()
	if event.is_action_pressed("attack"):
		try_weapon_attack()

func try_dash() -> void:
	if _dash_cooldown_remaining > 0.0:
		return
	_dash_time = dash_duration
	_dash_cooldown_remaining = dash_cooldown
	invulnerable = true
	dash_used.emit()

func try_weapon_attack() -> void:
	if _weapon_cooldown_remaining > 0.0:
		return
	_weapon_cooldown_remaining = weapon_cooldown
	_weapon_flash_time = 0.13
	weapon_slashed.emit(global_position, _dash_direction, weapon_range, weapon_arc, weapon_damage)
	queue_redraw()

func take_damage(amount: float) -> void:
	if invulnerable or health <= 0.0:
		return
	health = max(0.0, health - amount)
	player_damaged.emit(amount)
	if health <= 0.0:
		player_down.emit()

func get_dash_fraction() -> float:
	return 1.0 - (_dash_cooldown_remaining / dash_cooldown)

func set_maze_geometry(rooms: Array, corridors: Array) -> void:
	_playable_rooms.clear()
	_playable_corridors.clear()

	for room in rooms:
		var rect: Rect2 = room["rect"]
		_playable_rooms.append(rect.grow(-PLAYER_RADIUS))

	for corridor in corridors:
		_playable_corridors.append({
			"from": corridor["from"],
			"to": corridor["to"],
			"radius": CORRIDOR_HALF_WIDTH,
		})

func _read_movement_input() -> Vector2:
	var keyboard := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if keyboard.length_squared() > 0.001:
		return keyboard.normalized()
	if _touch_vector.length_squared() > 0.001:
		return _touch_vector.normalized()
	return Vector2.ZERO

func _keep_inside_maze() -> void:
	if _is_inside_maze(global_position):
		return

	global_position = _nearest_maze_point(global_position)
	velocity = Vector2.ZERO

func _is_inside_maze(point: Vector2) -> bool:
	for rect in _playable_rooms:
		if rect.has_point(point):
			return true

	for corridor in _playable_corridors:
		var closest := _closest_point_on_segment(point, corridor["from"], corridor["to"])
		if point.distance_to(closest) <= corridor["radius"]:
			return true

	return false

func _nearest_maze_point(point: Vector2) -> Vector2:
	var nearest := point
	var nearest_distance := INF

	for rect in _playable_rooms:
		var candidate := point.clamp(rect.position, rect.end)
		var distance := point.distance_squared_to(candidate)
		if distance < nearest_distance:
			nearest = candidate
			nearest_distance = distance

	for corridor in _playable_corridors:
		var line_point := _closest_point_on_segment(point, corridor["from"], corridor["to"])
		var offset := point - line_point
		var candidate: Vector2
		if offset.length_squared() <= corridor["radius"] * corridor["radius"]:
			candidate = point
		else:
			candidate = line_point + offset.normalized() * corridor["radius"]

		var distance := point.distance_squared_to(candidate)
		if distance < nearest_distance:
			nearest = candidate
			nearest_distance = distance

	return nearest

func _closest_point_on_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> Vector2:
	var segment := segment_end - segment_start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return segment_start

	var t := clamp((point - segment_start).dot(segment) / length_squared, 0.0, 1.0)
	return segment_start + segment * t
