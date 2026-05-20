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
var weapon_range := 96.0
var weapon_arc := 1.18
var weapon_damage := 50.0
var weapon_windup_time := 0.12
var weapon_active_time := 0.14
var weapon_recovery_time := 0.26
var weapon_cooldown := 0.52
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
var _weapon_windup_remaining := 0.0
var _weapon_active_remaining := 0.0
var _weapon_recovery_remaining := 0.0
var _weapon_swing_direction := Vector2.RIGHT
var _dash_direction := Vector2.RIGHT
var _touch_origin := Vector2.ZERO
var _touch_vector := Vector2.ZERO
var _touch_active := false

func _ready() -> void:
	z_index = 20

func _physics_process(delta: float) -> void:
	_dash_cooldown_remaining = max(0.0, _dash_cooldown_remaining - delta)
	_update_weapon_timers(delta)

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
	_draw_character()
	_draw_blade()
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
	_weapon_windup_remaining = weapon_windup_time
	_weapon_active_remaining = 0.0
	_weapon_recovery_remaining = 0.0
	_weapon_swing_direction = _dash_direction
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

func _draw_character() -> void:
	var facing := _dash_direction.normalized()
	var side := facing.orthogonal()
	var duster := PackedVector2Array([
		facing * 22.0,
		side * 18.0 + facing * 4.0,
		side * 13.0 - facing * 27.0,
		-side * 13.0 - facing * 27.0,
		-side * 18.0 + facing * 4.0,
	])
	var shirt := PackedVector2Array([
		facing * 17.0,
		side * 7.0 + facing * 2.0,
		side * 5.0 - facing * 17.0,
		-side * 5.0 - facing * 17.0,
		-side * 7.0 + facing * 2.0,
	])
	var hat_brim := PackedVector2Array([
		facing * 21.0,
		side * 24.0 + facing * 8.0,
		side * 28.0 - facing * 2.0,
		side * 10.0 - facing * 12.0,
		-side * 10.0 - facing * 12.0,
		-side * 28.0 - facing * 2.0,
		-side * 24.0 + facing * 8.0,
	])
	var hat_crown := PackedVector2Array([
		facing * 20.0,
		side * 10.0 + facing * 12.0,
		side * 9.0 - facing * 5.0,
		-side * 9.0 - facing * 5.0,
		-side * 10.0 + facing * 12.0,
	])

	draw_circle(-facing * 12.0, 22.0, Color(0.0, 0.0, 0.0, 0.25))
	draw_colored_polygon(duster, Color(0.47, 0.24, 0.11, 0.98))
	draw_polyline(PackedVector2Array([duster[0], duster[1], duster[2], duster[3], duster[4], duster[0]]), Color(0.95, 0.61, 0.27, 0.92), 2.5)
	draw_colored_polygon(shirt, Color(0.12, 0.055, 0.045, 1.0))
	draw_line(-side * 7.0 - facing * 11.0, -side * 16.0 - facing * 31.0, Color(0.075, 0.035, 0.03, 1.0), 5.0)
	draw_line(side * 7.0 - facing * 11.0, side * 16.0 - facing * 31.0, Color(0.075, 0.035, 0.03, 1.0), 5.0)
	draw_line(-side * 8.0 - facing * 31.0, -side * 18.0 - facing * 38.0, Color(0.02, 0.015, 0.02, 1.0), 4.0)
	draw_line(side * 8.0 - facing * 31.0, side * 18.0 - facing * 38.0, Color(0.02, 0.015, 0.02, 1.0), 4.0)
	draw_line(-side * 17.0 + facing * 2.0, -side * 31.0 - facing * 6.0, Color(0.23, 0.11, 0.055, 1.0), 5.0)
	draw_line(side * 17.0 + facing * 2.0, side * 31.0 - facing * 6.0, Color(0.23, 0.11, 0.055, 1.0), 5.0)
	draw_line(side * 12.0 - facing * 4.0, side * 20.0 - facing * 15.0, Color(0.95, 0.61, 0.27, 0.95), 3.0)
	draw_circle(facing * 9.0, 9.5, Color(0.78, 0.52, 0.38, 0.98))
	draw_colored_polygon(hat_brim, Color(0.34, 0.17, 0.075, 1.0))
	draw_polyline(PackedVector2Array([hat_brim[0], hat_brim[1], hat_brim[2], hat_brim[3], hat_brim[4], hat_brim[5], hat_brim[6], hat_brim[0]]), Color(0.95, 0.61, 0.27, 0.88), 2.0)
	draw_colored_polygon(hat_crown, Color(0.43, 0.22, 0.095, 1.0))
	draw_line(facing * 9.0 - side * 12.0, facing * 13.0 + side * 12.0, Color(0.015, 0.01, 0.015, 0.95), 8.0)
	draw_line(facing * 10.0 - side * 10.0, facing * 13.0 + side * 10.0, Color(0.95, 0.61, 0.27, 0.55), 1.5)
	draw_arc(Vector2.ZERO, 31.0, facing.angle() - PI * 0.78, facing.angle() + PI * 0.78, 22, Color(0.95, 0.61, 0.27, 0.5), 2.0)

func _draw_blade() -> void:
	var blade_direction := _get_blade_direction()
	var side := blade_direction.orthogonal()
	var grip_start := blade_direction * 12.0
	var hilt_center := blade_direction * 24.0
	var blade_base := blade_direction * 31.0
	var blade_tip := blade_direction * 76.0

	if _weapon_active_remaining > 0.0:
		var sweep_progress := 1.0 - _weapon_active_remaining / weapon_active_time
		var base_angle := _weapon_swing_direction.angle()
		var trail_alpha := 0.75 * (1.0 - sweep_progress * 0.35)
		draw_arc(Vector2.ZERO, weapon_range, base_angle - weapon_arc * 0.5, base_angle + weapon_arc * 0.5, 18, Color(1.0, 0.18, 0.82, trail_alpha), 6.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.78, base_angle - weapon_arc * 0.42, base_angle + weapon_arc * 0.42, 14, Color(0.2, 1.0, 1.0, trail_alpha * 0.72), 3.0)

	draw_line(grip_start, hilt_center, Color(0.08, 0.04, 0.1, 1.0), 9.0)
	draw_line(grip_start, hilt_center, Color(0.45, 0.18, 0.5, 1.0), 5.0)
	draw_line(hilt_center - side * 13.0, hilt_center + side * 13.0, Color(0.2, 1.0, 1.0, 0.95), 5.0)

	var blade := PackedVector2Array([
		blade_base - side * 5.5,
		blade_base + side * 5.5,
		blade_tip,
	])
	draw_colored_polygon(blade, Color(0.72, 0.86, 0.95, 0.98))

	var edge := PackedVector2Array([
		blade_base + side * 1.5,
		blade_base + side * 5.5,
		blade_tip,
	])
	draw_colored_polygon(edge, Color(0.96, 1.0, 1.0, 0.98))
	draw_line(blade_base - side * 5.5, blade_tip, Color(0.2, 1.0, 1.0, 0.48), 2.0)
	draw_line(blade_base + side * 5.5, blade_tip, Color(1.0, 0.18, 0.82, 0.5), 2.0)

func _get_blade_direction() -> Vector2:
	if _weapon_windup_remaining > 0.0:
		return _weapon_swing_direction.rotated(-weapon_arc * 0.52).normalized()
	if _weapon_active_remaining > 0.0:
		var swing_progress := 1.0 - _weapon_active_remaining / weapon_active_time
		return _weapon_swing_direction.rotated(lerpf(-weapon_arc * 0.5, weapon_arc * 0.5, swing_progress)).normalized()
	if _weapon_recovery_remaining > 0.0:
		return _weapon_swing_direction.rotated(weapon_arc * 0.45).normalized()
	return _dash_direction.normalized()

func _update_weapon_timers(delta: float) -> void:
	_weapon_cooldown_remaining = max(0.0, _weapon_cooldown_remaining - delta)

	if _weapon_windup_remaining > 0.0:
		_weapon_windup_remaining = max(0.0, _weapon_windup_remaining - delta)
		if _weapon_windup_remaining <= 0.0:
			_weapon_active_remaining = weapon_active_time
			weapon_slashed.emit(global_position, _weapon_swing_direction, weapon_range, weapon_arc, weapon_damage)
		return

	if _weapon_active_remaining > 0.0:
		_weapon_active_remaining = max(0.0, _weapon_active_remaining - delta)
		if _weapon_active_remaining <= 0.0:
			_weapon_recovery_remaining = weapon_recovery_time
		return

	if _weapon_recovery_remaining > 0.0:
		_weapon_recovery_remaining = max(0.0, _weapon_recovery_remaining - delta)

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
