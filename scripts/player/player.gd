class_name Player
extends CharacterBody2D

signal dash_used
signal player_damaged(amount: float)
signal player_down
signal player_parried
signal weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float)

var max_speed := 420.0
var acceleration := 2600.0
var dash_speed := 1180.0
var dash_duration := 0.13
var dash_cooldown := 0.9
var weapon_range := 92.0
var weapon_arc := 2.35
var weapon_damage := 50.0
var weapon_windup_time := 0.0
var weapon_active_time := 0.09
var weapon_recovery_time := 0.22
var weapon_cooldown := 0.25
var weapon_sheathe_delay := 0.45
var weapon_parry_time := 0.08
var max_health := 1.0
var health := 1.0
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
var _weapon_sheathe_delay_remaining := 0.0
var _weapon_parry_remaining := 0.0
var _parry_flash_remaining := 0.0
var _weapon_swing_direction := Vector2.RIGHT
var _dash_direction := Vector2.RIGHT
var _veil_remaining := 0.0
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
	_parry_flash_remaining = max(0.0, _parry_flash_remaining - delta)
	_veil_remaining = max(0.0, _veil_remaining - delta)
	_anim_time += delta

	var input_vector := _read_movement_input()
	_moving = input_vector.length_squared() > 0.001 or velocity.length_squared() > 1200.0
	if input_vector.length_squared() > 0.001:
		_dash_direction = input_vector.normalized()

	if _dash_time > 0.0:
		_dash_time -= delta
		velocity = _dash_direction * dash_speed
	else:
		invulnerable = _veil_remaining > 0.0
		var target_velocity := input_vector * max_speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)

	move_and_slide()
	_keep_inside_arena()
	queue_redraw()

func _draw() -> void:
	_draw_character()
	_draw_blade()
	if _parry_flash_remaining > 0.0:
		var flash := _parry_flash_remaining / 0.16
		draw_arc(Vector2.ZERO, lerpf(58.0, 34.0, flash), 0.0, TAU, 36, Color(1.0, 0.92, 0.62, flash), 5.0)
		draw_line(-_weapon_swing_direction * 42.0, _weapon_swing_direction * 46.0, Color(1.0, 0.96, 0.72, flash), 4.0)
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
	force_quickdraw()

func force_quickdraw() -> void:
	_weapon_cooldown_remaining = weapon_cooldown
	_weapon_windup_remaining = 0.0
	_weapon_active_remaining = weapon_active_time
	_weapon_recovery_remaining = 0.0
	_weapon_sheathe_delay_remaining = 0.0
	_weapon_parry_remaining = weapon_parry_time
	_weapon_swing_direction = _dash_direction
	weapon_slashed.emit(global_position, _weapon_swing_direction, weapon_range, weapon_arc, weapon_damage)
	queue_redraw()

func take_damage(amount: float) -> void:
	if invulnerable or health <= 0.0:
		return
	if _weapon_parry_remaining > 0.0:
		_weapon_parry_remaining = 0.0
		_parry_flash_remaining = 0.16
		player_parried.emit()
		queue_redraw()
		return
	health = max(0.0, health - amount)
	player_damaged.emit(amount)
	if health <= 0.0:
		player_down.emit()

func apply_dust_veil(duration: float) -> void:
	_veil_remaining = max(_veil_remaining, duration)
	invulnerable = true
	queue_redraw()

func get_aim_direction() -> Vector2:
	return _dash_direction.normalized()

func get_dash_fraction() -> float:
	return 1.0 - (_dash_cooldown_remaining / dash_cooldown)

func _draw_character() -> void:
	var facing: Vector2 = _dash_direction.normalized()
	var side: Vector2 = Vector2.RIGHT
	var step: float = sin(_anim_time * 10.0) if _moving else sin(_anim_time * 2.0) * 0.18
	var idle_bob: float = sin(_anim_time * 2.4) * 1.1 if not _moving else sin(_anim_time * 10.0) * 1.8
	var origin: Vector2 = Vector2(0.0, idle_bob)
	var cape_sway: float = sin(_anim_time * 2.8) * 8.0 + sin(_anim_time * 5.1) * 2.5
	var cape_lift: float = sin(_anim_time * 1.7) * 3.0
	var hair_sway: float = sin(_anim_time * 3.0 + 0.7) * 7.0 + sin(_anim_time * 5.4) * 2.0
	var hair_lift: float = sin(_anim_time * 2.1 + 1.2) * 2.0
	var look: Vector2 = facing * 5.0
	var head: Vector2 = origin + Vector2(0.0, -25.0) + look
	var chest: Vector2 = origin + Vector2(0.0, -5.0)
	var hips: Vector2 = origin + Vector2(0.0, 16.0)
	var left_foot: Vector2 = origin + Vector2(-8.0 - step * 4.0, 38.0 + maxf(0.0, step) * 4.0)
	var right_foot: Vector2 = origin + Vector2(8.0 - step * 4.0, 38.0 + maxf(0.0, -step) * 4.0)
	var left_hand: Vector2 = origin + Vector2(-21.0, 0.0) + facing * 5.0
	var saber_hand: Vector2 = origin + Vector2(13.0, 14.0) + facing * 4.0

	var cloak := PackedVector2Array([
		head + Vector2(-12.0, 7.0),
		chest + Vector2(-21.0, 0.0),
		hips + Vector2(-13.0, 0.0),
		hips + Vector2(8.0, 0.0),
		chest + Vector2(12.0, 0.0),
		head + Vector2(8.0, 7.0),
	])
	var tunic := PackedVector2Array([
		head + Vector2(-7.0, 7.0),
		chest + Vector2(-10.0, 0.0),
		hips + Vector2(-6.0, 0.0),
		hips + Vector2(7.0, 0.0),
		chest + Vector2(9.0, 0.0),
		head + Vector2(6.0, 7.0),
	])
	var red_sash := PackedVector2Array([
		hips + Vector2(-8.0, -5.0),
		hips + Vector2(9.0, -3.0),
		hips + Vector2(7.0, 7.0),
		hips + Vector2(-8.0, 5.0),
	])
	var cape := PackedVector2Array([
		chest + Vector2(-13.0, 0.0),
		chest + Vector2(9.0, 0.0),
		hips + Vector2(16.0 + cape_sway * 0.35, 11.0 + cape_lift),
		hips + Vector2(24.0 + cape_sway, 42.0 + cape_lift),
		hips + Vector2(9.0 + cape_sway * 0.45, 58.0),
		hips + Vector2(-9.0 + cape_sway * 0.15, 38.0),
	])
	var cape_torn_edge := PackedVector2Array([
		cape[3],
		cape[4] + side * 2.0 - facing * 5.0,
		cape[5],
		cape[5] + side * 7.0 + facing * 9.0,
	])
	var hair_mass := PackedVector2Array([
		head + Vector2(-9.0, -4.0),
		head + Vector2(7.0, -5.0),
		chest + Vector2(13.0 + hair_sway * 0.25, -3.0 + hair_lift),
		hips + Vector2(18.0 + hair_sway * 0.75, 21.0 + hair_lift),
		hips + Vector2(4.0 + hair_sway * 0.45, 46.0),
		chest + Vector2(-15.0 + hair_sway * 0.18, 14.0),
	])

	draw_circle(origin + Vector2(0.0, 10.0), 20.0, Color(0.0, 0.0, 0.0, 0.35))
	draw_colored_polygon(cape, Color(0.018, 0.014, 0.012, 0.96))
	draw_colored_polygon(cape_torn_edge, Color(0.09, 0.052, 0.028, 0.82))
	draw_polyline(PackedVector2Array([cape[0], cape[1], cape[2], cape[3], cape[4], cape[5]]), Color(0.24, 0.15, 0.09, 0.82), 2.0)
	draw_colored_polygon(hair_mass, Color(0.012, 0.01, 0.009, 0.98))
	draw_polyline(PackedVector2Array([
		head + Vector2(-8.0, 1.0),
		chest + Vector2(-18.0 + hair_sway * 0.2, 10.0),
		hips + Vector2(-8.0 + hair_sway * 0.34, 42.0),
	]), Color(0.04, 0.026, 0.018, 0.92), 4.0)
	draw_polyline(PackedVector2Array([
		head + Vector2(1.0, 0.0),
		chest + Vector2(5.0 + hair_sway * 0.42, 16.0 + hair_lift),
		hips + Vector2(12.0 + hair_sway * 0.78, 54.0),
	]), Color(0.055, 0.035, 0.022, 0.86), 5.0)
	draw_polyline(PackedVector2Array([
		head + Vector2(7.0, 1.0),
		chest + Vector2(16.0 + hair_sway * 0.55, 7.0 + hair_lift),
		hips + Vector2(23.0 + hair_sway, 34.0),
	]), Color(0.032, 0.022, 0.016, 0.9), 3.0)
	draw_colored_polygon(cloak, Color(0.028, 0.023, 0.02, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[5], cloak[0]]), Color(0.26, 0.18, 0.12, 0.85), 2.0)
	draw_line(chest + Vector2(-15.0, 0.0), left_hand, Color(0.82, 0.8, 0.72, 0.96), 5.0)
	draw_line(chest + Vector2(12.0, 0.0), saber_hand, Color(0.82, 0.8, 0.72, 0.92), 5.0)
	draw_colored_polygon(tunic, Color(0.86, 0.84, 0.76, 0.98))
	draw_colored_polygon(red_sash, Color(0.58, 0.07, 0.035, 0.96))
	draw_line(hips + Vector2(-5.0, 0.0), left_foot, Color(0.82, 0.8, 0.72, 0.95), 6.0)
	draw_line(hips + Vector2(5.0, 0.0), right_foot, Color(0.58, 0.07, 0.035, 0.95), 6.0)
	draw_line(left_foot + Vector2(-3.0, 0.0), left_foot + Vector2(6.0, 0.0), Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_line(right_foot + Vector2(-4.0, 0.0), right_foot + Vector2(6.0, 0.0), Color(0.015, 0.012, 0.01, 1.0), 4.0)
	draw_circle(head, 8.0, Color(0.9, 0.88, 0.8, 0.98))
	draw_arc(head, 10.0, -PI * 0.15, PI * 1.15, 14, Color(0.012, 0.01, 0.009, 0.98), 5.0)
	draw_line(head + Vector2(-8.0, 2.0) + facing * 2.0, head + Vector2(8.0, 2.0) + facing * 2.0, Color(0.0, 0.0, 0.0, 0.98), 5.0)
	draw_line(left_hand, left_hand + facing * 26.0 + Vector2(-8.0, 10.0), Color(0.72, 0.73, 0.68, 0.94), 3.0)
	draw_line(left_hand + facing * 26.0 + Vector2(-8.0, 10.0), left_hand + facing * 34.0 + Vector2(-10.0, 14.0), Color(0.94, 0.9, 0.74, 0.9), 2.0)
	draw_circle(saber_hand, 4.0, Color(0.76, 0.58, 0.42, 0.98))

func _draw_blade() -> void:
	if not _is_blade_unsheathed():
		_draw_sheath()
		return

	var blade_direction := _get_blade_direction()
	var side := blade_direction.orthogonal()
	var grip_start := blade_direction * 12.0
	var hilt_center := blade_direction * 24.0
	var blade_base := blade_direction * 31.0
	var blade_tip := blade_direction * weapon_range
	var curve := side * 7.0

	if _weapon_active_remaining > 0.0:
		var sweep_progress: float = 1.0 - _weapon_active_remaining / weapon_active_time
		var base_angle: float = _weapon_swing_direction.angle()
		var start_angle: float = base_angle - weapon_arc * 0.5
		var end_angle: float = base_angle + weapon_arc * 0.5
		var current_angle: float = lerpf(start_angle, end_angle, sweep_progress)
		var trail_alpha: float = 0.92 * (1.0 - sweep_progress * 0.42)
		var slash_direction: Vector2 = Vector2.RIGHT.rotated(current_angle)
		var slash_side: Vector2 = slash_direction.orthogonal()
		var flash_tip: Vector2 = slash_direction * weapon_range
		var flash_base: Vector2 = slash_direction * 44.0
		var crescent := PackedVector2Array([
			flash_base - slash_side * 14.0,
			flash_tip - slash_side * 10.0,
			flash_tip + slash_direction * 10.0,
			flash_tip + slash_side * 17.0,
			flash_base + slash_side * 8.0,
		])
		draw_arc(Vector2.ZERO, weapon_range, start_angle, end_angle, 32, Color(0.92, 0.48, 0.18, trail_alpha), 12.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.82, start_angle + weapon_arc * 0.08, end_angle - weapon_arc * 0.08, 26, Color(0.98, 0.78, 0.42, trail_alpha * 0.72), 6.0)
		draw_arc(Vector2.ZERO, weapon_range * 0.58, start_angle + weapon_arc * 0.18, end_angle - weapon_arc * 0.18, 18, Color(1.0, 0.94, 0.68, trail_alpha * 0.45), 3.0)
		draw_colored_polygon(crescent, Color(1.0, 0.84, 0.48, trail_alpha * 0.24))
		draw_line(Vector2.RIGHT.rotated(start_angle) * 52.0, Vector2.RIGHT.rotated(start_angle) * (weapon_range - 4.0), Color(0.96, 0.68, 0.34, trail_alpha * 0.38), 4.0)
		draw_line(Vector2.RIGHT.rotated(end_angle) * 52.0, Vector2.RIGHT.rotated(end_angle) * (weapon_range - 4.0), Color(1.0, 0.9, 0.55, trail_alpha * 0.54), 5.0)

	draw_line(grip_start, hilt_center, Color(0.035, 0.022, 0.018, 1.0), 9.0)
	draw_line(grip_start, hilt_center, Color(0.32, 0.17, 0.08, 1.0), 5.0)
	draw_arc(hilt_center + blade_direction * 2.0, 13.0, blade_direction.angle() + PI * 0.5, blade_direction.angle() + PI * 1.52, 12, Color(0.78, 0.45, 0.2, 0.98), 4.0)
	draw_line(hilt_center - side * 6.0, hilt_center + side * 13.0, Color(0.66, 0.36, 0.16, 0.95), 4.0)

	var blade := PackedVector2Array([
		blade_base - side * 5.5,
		blade_base + side * 5.5,
		blade_tip + curve,
		blade_tip - side * 2.0,
	])
	draw_colored_polygon(blade, Color(0.62, 0.63, 0.6, 0.98))

	var edge := PackedVector2Array([
		blade_base + side * 1.5,
		blade_base + side * 5.5,
		blade_tip + curve,
	])
	draw_colored_polygon(edge, Color(0.9, 0.86, 0.72, 0.98))
	draw_polyline(PackedVector2Array([blade_base - side * 5.5, blade_tip - side * 2.0, blade_tip + curve]), Color(0.18, 0.12, 0.08, 0.58), 2.0)
	draw_line(blade_base + side * 5.5, blade_tip + curve, Color(0.86, 0.52, 0.22, 0.46), 2.0)

func _draw_sheath() -> void:
	var facing: Vector2 = _dash_direction.normalized()
	var sheath_direction: Vector2 = Vector2(0.34, 0.94).normalized()
	if facing.x < -0.25:
		sheath_direction.x *= -1.0
	var side := sheath_direction.orthogonal()
	var sheath_start := Vector2(-9.0, 2.0) + facing * 3.0
	var sheath_end := sheath_start + sheath_direction * 58.0
	var hilt_start := sheath_start - sheath_direction * 6.0
	draw_line(sheath_start, sheath_end, Color(0.018, 0.012, 0.009, 1.0), 11.0)
	draw_line(sheath_start, sheath_end, Color(0.18, 0.075, 0.035, 1.0), 7.0)
	draw_line(sheath_start + side * 4.0, sheath_end + side * 4.0, Color(0.54, 0.29, 0.12, 0.72), 2.0)
	draw_line(sheath_start - side * 7.0, sheath_start + side * 7.0, Color(0.62, 0.34, 0.16, 0.95), 4.0)
	draw_line(hilt_start, sheath_start + sheath_direction * 11.0, Color(0.035, 0.022, 0.018, 1.0), 8.0)
	draw_line(hilt_start, sheath_start + sheath_direction * 11.0, Color(0.32, 0.17, 0.08, 1.0), 4.0)
	draw_circle(sheath_start + side * 2.0, 4.5, Color(0.76, 0.58, 0.42, 0.98))
	draw_arc(sheath_start, 12.0, sheath_direction.angle() + PI * 0.44, sheath_direction.angle() + PI * 1.5, 12, Color(0.78, 0.45, 0.2, 0.95), 3.0)

func _is_blade_unsheathed() -> bool:
	return _weapon_windup_remaining > 0.0 or _weapon_active_remaining > 0.0 or _weapon_recovery_remaining > 0.0 or _weapon_sheathe_delay_remaining > 0.0

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
	_weapon_sheathe_delay_remaining = max(0.0, _weapon_sheathe_delay_remaining - delta)
	_weapon_parry_remaining = max(0.0, _weapon_parry_remaining - delta)

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
		var was_recovering := _weapon_recovery_remaining > 0.0
		_weapon_recovery_remaining = max(0.0, _weapon_recovery_remaining - delta)
		if was_recovering and _weapon_recovery_remaining <= 0.0:
			_weapon_sheathe_delay_remaining = weapon_sheathe_delay

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
