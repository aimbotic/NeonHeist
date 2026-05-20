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
var _anim_time := 0.0
var _moving := false

func _ready() -> void:
	z_index = 20

func _physics_process(delta: float) -> void:
	_dash_cooldown_remaining = max(0.0, _dash_cooldown_remaining - delta)
	_update_weapon_timers(delta)
	_anim_time += delta

	var input_vector := _read_movement_input()
	_moving = input_vector.length_squared() > 0.001 or velocity.length_squared() > 1200.0
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
	var step := sin(_anim_time * 10.0) if _moving else sin(_anim_time * 2.0) * 0.18
	var idle_bob := sin(_anim_time * 2.4) * 1.1 if not _moving else sin(_anim_time * 10.0) * 1.8
	var cloak_sway := sin(_anim_time * 3.0) * 3.0 if not _moving else sin(_anim_time * 10.0) * 6.0
	var origin := facing * idle_bob
	var cloak := PackedVector2Array([
		origin - side * 18.0 + facing * 4.0,
		origin - side * (34.0 + cloak_sway) - facing * 12.0,
		origin - side * (30.0 + cloak_sway * 0.6) - facing * 42.0,
		origin - side * 18.0 - facing * 58.0,
		origin - side * 4.0 - facing * 35.0,
	])
	var cloak_fringe := PackedVector2Array([
		origin - side * (30.0 + cloak_sway * 0.6) - facing * 42.0,
		origin - side * 24.0 - facing * 54.0,
		origin - side * 18.0 - facing * 58.0,
		origin - side * 11.0 - facing * 49.0,
		origin - side * 4.0 - facing * 35.0,
	])
	var duster := PackedVector2Array([
		origin + facing * 24.0,
		origin + side * 16.0 + facing * 5.0,
		origin + side * 12.0 - facing * 30.0,
		origin - side * 12.0 - facing * 30.0,
		origin - side * 18.0 + facing * 3.0,
	])
	var shirt := PackedVector2Array([
		origin + facing * 18.0,
		origin + side * 6.0 + facing * 1.0,
		origin + side * 4.0 - facing * 18.0,
		origin - side * 5.0 - facing * 18.0,
		origin - side * 7.0 + facing * 1.0,
	])
	var hat_brim := PackedVector2Array([
		origin + facing * 26.0,
		origin + side * 34.0 + facing * 10.0,
		origin + side * 40.0 - facing * 3.0,
		origin + side * 14.0 - facing * 18.0,
		origin - side * 15.0 - facing * 18.0,
		origin - side * 40.0 - facing * 3.0,
		origin - side * 34.0 + facing * 10.0,
	])
	var hat_crown := PackedVector2Array([
		origin + facing * 25.0,
		origin + side * 11.0 + facing * 15.0,
		origin + side * 10.0 - facing * 8.0,
		origin - side * 10.0 - facing * 8.0,
		origin - side * 12.0 + facing * 15.0,
	])
	var hair := PackedVector2Array([
		origin - side * 12.0 + facing * 8.0,
		origin - side * 25.0 - facing * 9.0,
		origin - side * 20.0 - facing * 34.0,
		origin + side * 3.0 - facing * 24.0,
		origin + side * 7.0 - facing * 6.0,
	])

	draw_circle(origin - facing * 14.0, 24.0, Color(0.0, 0.0, 0.0, 0.32))
	draw_colored_polygon(cloak, Color(0.09, 0.055, 0.035, 0.98))
	draw_colored_polygon(cloak_fringe, Color(0.14, 0.075, 0.036, 0.88))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4]]), Color(0.54, 0.27, 0.11, 0.7), 2.0)
	draw_colored_polygon(duster, Color(0.095, 0.055, 0.036, 0.98))
	draw_polyline(PackedVector2Array([duster[0], duster[1], duster[2], duster[3], duster[4], duster[0]]), Color(0.57, 0.31, 0.14, 0.8), 2.5)
	draw_colored_polygon(shirt, Color(0.035, 0.025, 0.02, 1.0))
	draw_line(origin - side * 7.0 - facing * 11.0, origin - side * (16.0 + step * 4.0) - facing * (31.0 + max(0.0, step) * 5.0), Color(0.025, 0.018, 0.015, 1.0), 5.0)
	draw_line(origin + side * 7.0 - facing * 11.0, origin + side * (16.0 - step * 4.0) - facing * (31.0 + max(0.0, -step) * 5.0), Color(0.025, 0.018, 0.015, 1.0), 5.0)
	draw_line(origin - side * (8.0 + step * 2.0) - facing * 31.0, origin - side * (18.0 + step * 5.0) - facing * 40.0, Color(0.01, 0.008, 0.008, 1.0), 4.0)
	draw_line(origin + side * (8.0 - step * 2.0) - facing * 31.0, origin + side * (18.0 - step * 5.0) - facing * 40.0, Color(0.01, 0.008, 0.008, 1.0), 4.0)
	draw_line(origin - side * 16.0 + facing * 2.0, origin - side * 31.0 - facing * 6.0, Color(0.045, 0.026, 0.018, 1.0), 5.0)
	draw_line(origin + side * 16.0 + facing * 2.0, origin + side * 30.0 - facing * 7.0, Color(0.045, 0.026, 0.018, 1.0), 5.0)
	draw_line(origin + side * 11.0 - facing * 4.0, origin + side * 20.0 - facing * 15.0, Color(0.55, 0.29, 0.13, 0.95), 3.0)
	draw_colored_polygon(hair, Color(0.01, 0.008, 0.008, 1.0))
	draw_circle(origin + facing * 9.0, 9.5, Color(0.54, 0.36, 0.26, 0.98))
	draw_line(origin + facing * 9.0 - side * 11.0, origin + facing * 12.0 + side * 11.0, Color(0.01, 0.007, 0.006, 1.0), 12.0)
	draw_line(origin + facing * 3.0 - side * 5.0, origin + facing * 0.0 - side * 12.0, Color(0.01, 0.008, 0.008, 1.0), 4.0)
	draw_colored_polygon(hat_brim, Color(0.025, 0.018, 0.015, 1.0))
	draw_polyline(PackedVector2Array([hat_brim[0], hat_brim[1], hat_brim[2], hat_brim[3], hat_brim[4], hat_brim[5], hat_brim[6], hat_brim[0]]), Color(0.48, 0.26, 0.11, 0.78), 2.0)
	draw_colored_polygon(hat_crown, Color(0.038, 0.026, 0.019, 1.0))
	draw_line(origin + facing * 8.0 - side * 12.0, origin + facing * 11.0 + side * 12.0, Color(0.0, 0.0, 0.0, 0.98), 10.0)
	draw_line(origin + facing * 13.0 - side * 11.0, origin + facing * 16.0 + side * 11.0, Color(0.58, 0.31, 0.14, 0.5), 1.5)
	draw_arc(origin, 36.0, facing.angle() - PI * 0.78, facing.angle() + PI * 0.78, 22, Color(0.48, 0.26, 0.11, 0.42), 2.0)

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
		draw_arc(Vector2.ZERO, weapon_range, base_angle - weapon_arc * 0.5, base_angle + weapon_arc * 0.5, 18, Color(0.86, 0.52, 0.22, trail_alpha), 6.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.78, base_angle - weapon_arc * 0.42, base_angle + weapon_arc * 0.42, 14, Color(0.95, 0.82, 0.58, trail_alpha * 0.62), 3.0)

	draw_line(grip_start, hilt_center, Color(0.035, 0.022, 0.018, 1.0), 9.0)
	draw_line(grip_start, hilt_center, Color(0.32, 0.17, 0.08, 1.0), 5.0)
	draw_line(hilt_center - side * 13.0, hilt_center + side * 13.0, Color(0.66, 0.36, 0.16, 0.95), 5.0)

	var blade := PackedVector2Array([
		blade_base - side * 5.5,
		blade_base + side * 5.5,
		blade_tip,
	])
	draw_colored_polygon(blade, Color(0.62, 0.63, 0.6, 0.98))

	var edge := PackedVector2Array([
		blade_base + side * 1.5,
		blade_base + side * 5.5,
		blade_tip,
	])
	draw_colored_polygon(edge, Color(0.9, 0.86, 0.72, 0.98))
	draw_line(blade_base - side * 5.5, blade_tip, Color(0.18, 0.12, 0.08, 0.58), 2.0)
	draw_line(blade_base + side * 5.5, blade_tip, Color(0.86, 0.52, 0.22, 0.46), 2.0)

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
