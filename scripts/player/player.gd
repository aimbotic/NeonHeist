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

var _arena_bounds := Rect2()

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
	_keep_inside_arena()
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
	var facing: Vector2 = _dash_direction.normalized()
	var side: Vector2 = facing.orthogonal()
	var step: float = sin(_anim_time * 10.0) if _moving else sin(_anim_time * 2.0) * 0.18
	var idle_bob: float = sin(_anim_time * 2.4) * 1.1 if not _moving else sin(_anim_time * 10.0) * 1.8
	var origin: Vector2 = facing * idle_bob
	var cape_sway: float = sin(_anim_time * 2.8) * 8.0 + sin(_anim_time * 5.1) * 2.5
	var cape_lift: float = sin(_anim_time * 1.7) * 3.0
	var head: Vector2 = origin + facing * 23.0
	var chest: Vector2 = origin + facing * 7.0
	var hips: Vector2 = origin - facing * 14.0
	var left_foot: Vector2 = origin - facing * (34.0 + maxf(0.0, step) * 4.0) - side * (7.0 + step * 4.0)
	var right_foot: Vector2 = origin - facing * (34.0 + maxf(0.0, -step) * 4.0) + side * (7.0 - step * 4.0)
	var left_hand: Vector2 = origin + facing * 4.0 - side * 20.0
	var right_hand: Vector2 = origin + facing * 1.0 + side * 17.0

	var cloak := PackedVector2Array([
		head - side * 12.0,
		chest - side * 21.0,
		hips - side * 13.0,
		hips + side * 8.0,
		chest + side * 12.0,
		head + side * 8.0,
	])
	var tunic := PackedVector2Array([
		head - side * 7.0 - facing * 5.0,
		chest - side * 10.0,
		hips - side * 6.0,
		hips + side * 7.0,
		chest + side * 9.0,
		head + side * 6.0 - facing * 5.0,
	])
	var red_sash := PackedVector2Array([
		hips - side * 6.0 + facing * 3.0,
		hips + side * 9.0 + facing * 1.0,
		hips + side * 7.0 - facing * 7.0,
		hips - side * 8.0 - facing * 5.0,
	])
	var cape := PackedVector2Array([
		chest - side * 11.0,
		chest + side * 8.0,
		hips + side * (16.0 + cape_sway * 0.35) - facing * (10.0 + cape_lift),
		hips + side * (24.0 + cape_sway) - facing * (39.0 + cape_lift),
		hips + side * (9.0 + cape_sway * 0.45) - facing * 55.0,
		hips - side * (8.0 - cape_sway * 0.15) - facing * 35.0,
	])
	var cape_torn_edge := PackedVector2Array([
		cape[3],
		cape[4] + side * 2.0 - facing * 5.0,
		cape[5],
		cape[5] + side * 7.0 + facing * 9.0,
	])

	draw_circle(origin - facing * 8.0, 20.0, Color(0.0, 0.0, 0.0, 0.35))
	draw_colored_polygon(cape, Color(0.018, 0.014, 0.012, 0.96))
	draw_colored_polygon(cape_torn_edge, Color(0.09, 0.052, 0.028, 0.82))
	draw_polyline(PackedVector2Array([cape[0], cape[1], cape[2], cape[3], cape[4], cape[5]]), Color(0.24, 0.15, 0.09, 0.82), 2.0)
	draw_colored_polygon(cloak, Color(0.028, 0.023, 0.02, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[5], cloak[0]]), Color(0.26, 0.18, 0.12, 0.85), 2.0)
	draw_line(chest - side * 15.0, left_hand, Color(0.82, 0.8, 0.72, 0.96), 5.0)
	draw_line(chest + side * 12.0, right_hand, Color(0.82, 0.8, 0.72, 0.92), 5.0)
	draw_colored_polygon(tunic, Color(0.86, 0.84, 0.76, 0.98))
	draw_colored_polygon(red_sash, Color(0.58, 0.07, 0.035, 0.96))
	draw_line(hips - side * 5.0, left_foot, Color(0.82, 0.8, 0.72, 0.95), 6.0)
	draw_line(hips + side * 5.0, right_foot, Color(0.58, 0.07, 0.035, 0.95), 6.0)
	draw_line(left_foot - side * 3.0, left_foot + side * 6.0, Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_line(right_foot - side * 4.0, right_foot + side * 6.0, Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_circle(head, 8.0, Color(0.9, 0.88, 0.8, 0.98))
	draw_arc(head, 10.0, facing.angle() - PI * 0.25, facing.angle() + PI * 1.15, 14, Color(0.012, 0.01, 0.009, 0.98), 5.0)
	draw_line(head - side * 8.0 + facing * 1.0, head + side * 8.0 + facing * 2.0, Color(0.0, 0.0, 0.0, 0.98), 5.0)
	draw_line(left_hand, left_hand - facing * 30.0 - side * 8.0, Color(0.72, 0.73, 0.68, 0.94), 3.0)
	draw_line(left_hand - facing * 30.0 - side * 8.0, left_hand - facing * 40.0 - side * 11.0, Color(0.94, 0.9, 0.74, 0.9), 2.0)

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

func set_arena_bounds(arena: Rect2) -> void:
	_arena_bounds = arena.grow(-PLAYER_RADIUS)

func _read_movement_input() -> Vector2:
	var keyboard := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if keyboard.length_squared() > 0.001:
		return keyboard.normalized()
	if _touch_vector.length_squared() > 0.001:
		return _touch_vector.normalized()
	return Vector2.ZERO

func _keep_inside_arena() -> void:
	if _arena_bounds.size == Vector2.ZERO or _arena_bounds.has_point(global_position):
		return

	global_position = global_position.clamp(_arena_bounds.position, _arena_bounds.end)
	velocity = Vector2.ZERO
