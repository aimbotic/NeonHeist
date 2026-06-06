extends "res://scripts/enemies/base_enemy.gd"

const ENEMY_SPRITE_SLUG := "enemy_shotgun_brute_male"
const WINDUP_DURATION := 0.36
const RECOIL_DURATION := 0.2
const RECOVER_TELL_DURATION := 0.42

var _fire_timer := 0.0
var _windup_timer := 0.0
var _recoil_timer := 0.0
var _recover_tell_timer := 0.0
var _aim_direction := Vector2.RIGHT

func has_attack_tell() -> bool:
	return _windup_timer > 0.0

func get_attack_tell_strength() -> float:
	if _windup_timer <= 0.0:
		return 0.0
	return clampf(1.0 - _windup_timer / WINDUP_DURATION, 0.0, 1.0)

func has_recover_tell() -> bool:
	return _recover_tell_timer > 0.0

func get_recover_tell_strength() -> float:
	if _recover_tell_timer <= 0.0:
		return 0.0
	return clampf(1.0 - _recover_tell_timer / RECOVER_TELL_DURATION, 0.0, 1.0)

func _ready() -> void:
	max_health = 150.0
	health = max_health
	speed = 122.0
	contact_damage = 18.0
	z_index = 13
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 118.0)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_fire_timer = max(0.0, _fire_timer - delta)
	_windup_timer = max(0.0, _windup_timer - delta)
	_recoil_timer = max(0.0, _recoil_timer - delta)
	_recover_tell_timer = max(0.0, _recover_tell_timer - delta)
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)
	_aim_direction = to_player

	if _windup_timer > 0.0:
		velocity = Vector2.ZERO
		if _windup_timer <= delta:
			_fire_shotgun(distance)
		move_and_slide()
		_request_enemy_visual_redraw()
		return

	if distance <= 260.0 and _fire_timer <= 0.0:
		_windup_timer = WINDUP_DURATION
		_fire_timer = 1.7
		velocity = Vector2.ZERO
		_request_enemy_visual_redraw()
		return

	var desired := to_player
	if distance < 150.0:
		desired = -to_player
	velocity = desired * speed * (1.0 + alert_level * 0.08) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(44.0)
	_request_enemy_visual_redraw()

func _fire_shotgun(distance: float) -> void:
	_recoil_timer = RECOIL_DURATION
	_recover_tell_timer = RECOVER_TELL_DURATION
	var spread := 0.52
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	if distance <= 285.0 and abs(_aim_direction.angle_to(to_player)) <= spread:
		player.take_damage(1.0)
	if vfx_layer != null:
		var muzzle := global_position + _aim_direction * 58.0 - _aim_direction.orthogonal() * 18.0
		if vfx_layer.has_method("enemy_weapon_burst"):
			vfx_layer.enemy_weapon_burst(muzzle, _aim_direction, "shotgun")
		for i in range(5):
			var pellet_dir := _aim_direction.rotated(lerpf(-spread, spread, float(i) / 4.0))
			vfx_layer.beam(global_position + pellet_dir * 18.0, global_position + pellet_dir * 300.0, Color(0.95, 0.5, 0.18))

func _draw() -> void:
	_draw_character_shadow(1.14, Vector2(70.0, 82.0))
	var color := _health_color(Color(0.82, 0.34, 0.08))
	var facing := _aim_direction.normalized()
	var side := facing.orthogonal()
	if _windup_timer > 0.0:
		_draw_shotgun_windup_lanes(facing, side, get_attack_tell_strength())
	if _recover_tell_timer > 0.0:
		_draw_shotgun_recover_tell(facing, side, get_recover_tell_strength())

	if _has_enemy_sprite():
		var windup_ratio := 1.0 - _windup_timer / WINDUP_DURATION if _windup_timer > 0.0 else 0.0
		var recoil_ratio := _recoil_timer / RECOIL_DURATION
		var pose_scale := Vector2(1.0 + windup_ratio * 0.09 - recoil_ratio * 0.06, 1.0 - windup_ratio * 0.07 + recoil_ratio * 0.06)
		var pose_offset := -facing * (windup_ratio * 4.0 + recoil_ratio * 15.0)
		_draw_enemy_sprite(facing, pose_offset, pose_scale, side.x * 0.02 * windup_ratio - side.x * 0.04 * recoil_ratio)
		_draw_shotgun_overlay(facing, side, color, maxf(windup_ratio, recoil_ratio))
		_draw_enemy_role_silhouette_accent(facing, "shotgun_brute", color, 0.56 + maxf(windup_ratio, recoil_ratio) * 0.4)
		return
	_draw_enemy_human_legs(facing, side, color, 1.14, 0.7)
	var coat := PackedVector2Array([
		facing * 21.0,
		side * 21.0 + facing * 4.0,
		side * 17.0 - facing * 27.0,
		-side * 17.0 - facing * 27.0,
		-side * 21.0 + facing * 4.0,
	])
	draw_colored_polygon(coat, Color(0.095, 0.045, 0.022, 0.98))
	draw_polyline(PackedVector2Array([coat[0], coat[1], coat[2], coat[3], coat[4], coat[0]]), color, 5.0)
	draw_circle(facing * 8.0, 9.0, Color(0.5, 0.32, 0.2, 1.0))
	draw_line(facing * 8.0 - side * 17.0, facing * 10.0 + side * 17.0, Color(0.012, 0.009, 0.008, 1.0), 8.0)
	draw_line(facing * 13.0 - side * 8.0, facing * 48.0 - side * 16.0, Color(0.2, 0.09, 0.035, 1.0), 7.0)
	draw_line(facing * 18.0 - side * 8.0, facing * 57.0 - side * 17.0, Color(0.86, 0.52, 0.22), 3.0)
	draw_line(-side * 17.0, side * 17.0, Color(0.86, 0.18, 0.08, 0.9), 4.0)
	_draw_enemy_role_silhouette_accent(facing, "shotgun_brute", color, 0.6)

func _draw_shotgun_overlay(facing: Vector2, side: Vector2, accent: Color, intensity: float) -> void:
	var stock := facing * 5.0 - side * 10.0
	var muzzle := facing * 58.0 - side * 18.0
	var glow := clampf(intensity, 0.0, 1.0)
	draw_line(stock, muzzle, Color(0.12, 0.055, 0.026, 0.98), 10.0)
	draw_line(stock + facing * 6.0, muzzle, Color(0.82, 0.48, 0.19, 0.9), 4.0)
	if glow > 0.0:
		var cone := PackedVector2Array([
			muzzle,
			muzzle + facing.rotated(-0.28) * (24.0 + glow * 16.0),
			muzzle + facing * (34.0 + glow * 18.0),
			muzzle + facing.rotated(0.28) * (24.0 + glow * 16.0),
		])
		draw_colored_polygon(cone, Color(1.0, 0.58, 0.18, 0.12 + glow * 0.24))

func _draw_shotgun_windup_lanes(facing: Vector2, side: Vector2, charge: float) -> void:
	var spread := 0.52
	var muzzle := facing * 58.0 - side * 18.0
	var lane_length := lerpf(145.0, 220.0, charge)
	var lane_alpha := lerpf(0.28, 0.66, charge)
	var left_dir := facing.rotated(-spread)
	var right_dir := facing.rotated(spread)
	var center_end := muzzle + facing * lane_length
	var left_end := muzzle + left_dir * lane_length
	var right_end := muzzle + right_dir * lane_length
	var fan := PackedVector2Array([muzzle, left_end, center_end + facing * (20.0 + charge * 16.0), right_end])
	draw_colored_polygon(fan, Color(0.9, 0.28, 0.08, 0.08 + charge * 0.16))
	draw_line(muzzle + Vector2(3.0, 4.0), left_end + Vector2(3.0, 4.0), Color(0.08, 0.024, 0.012, 0.34 + charge * 0.2), 7.0)
	draw_line(muzzle + Vector2(3.0, 4.0), right_end + Vector2(3.0, 4.0), Color(0.08, 0.024, 0.012, 0.34 + charge * 0.2), 7.0)
	draw_line(muzzle, left_end, Color(1.0, 0.58, 0.18, lane_alpha), 4.0)
	draw_line(muzzle, right_end, Color(1.0, 0.58, 0.18, lane_alpha), 4.0)
	draw_line(muzzle, center_end, Color(1.0, 0.78, 0.34, 0.24 + charge * 0.42), 3.0 + charge * 2.0)
	for i in range(3):
		var pellet_dir := facing.rotated(lerpf(-spread * 0.58, spread * 0.58, float(i) / 2.0))
		draw_line(muzzle, muzzle + pellet_dir * (lane_length * 0.72), Color(1.0, 0.74, 0.28, 0.16 + charge * 0.26), 2.0)
	draw_arc(Vector2.ZERO, lerpf(50.0, 28.0, charge), -0.4, TAU - 0.4, 30, Color(0.9, 0.28, 0.08, 0.58 + charge * 0.28), 5.0)
	draw_line(muzzle - side * 10.0, muzzle + side * 10.0, Color(1.0, 0.88, 0.5, 0.52 + charge * 0.34), 4.0)

func _draw_shotgun_recover_tell(facing: Vector2, side: Vector2, recover: float) -> void:
	var alpha := 1.0 - recover
	var muzzle := facing * 58.0 - side * 18.0
	var breech := facing * 17.0 - side * 11.0
	var smoke_color := Color(0.13, 0.06, 0.024, 0.28 * alpha)
	var brass_color := Color(1.0, 0.72, 0.24, 0.48 * alpha)
	draw_arc(muzzle, lerpf(24.0, 52.0, recover), facing.angle() - 0.5, facing.angle() + 0.5, 24, smoke_color, lerpf(7.0, 2.0, recover))
	draw_line(breech - side * 20.0, breech - side * 46.0 - facing * 16.0, brass_color, lerpf(5.0, 2.0, recover))
	draw_line(breech - side * 9.0 - facing * 5.0, breech - side * 34.0 - facing * 24.0, brass_color.darkened(0.12), lerpf(4.0, 1.5, recover))
	for i in range(3):
		var puff_origin := muzzle - facing * lerpf(8.0, 38.0, recover) + side * float(i - 1) * 10.0
		draw_circle(puff_origin, lerpf(8.0, 2.5, recover), smoke_color)
