extends "res://scripts/enemies/base_enemy.gd"

signal shot_fired(shooter: Node2D, shot_start: Vector2, shot_end: Vector2, direction: Vector2)

const ENEMY_SPRITE_SLUG := "enemy_rifleman_male"
const ATTACK_RANGE := 700.0
const CHARGE_DURATION := 0.42
const RIFLEMAN_SHOT_TELL_VISUAL_VERSION := "rifleman_bounty_sightline_tell_v1"
const RIFLEMAN_SHOT_TELL_MARKER_COUNT := 12
const RIFLEMAN_SHOT_TELL_ARC_SEGMENTS := 24

var _fire_timer := 0.0
var _charge_timer := 0.0
var _recoil_timer := 0.0
var _aim_angle := 0.0
var _shot_target := Vector2.ZERO

func has_attack_tell() -> bool:
	return _charge_timer > 0.0

func get_attack_tell_strength() -> float:
	if _charge_timer <= 0.0:
		return 0.0
	return 1.0 - _charge_timer / CHARGE_DURATION

func get_attack_tell_line() -> Dictionary:
	if _charge_timer <= 0.0:
		return {}
	var direction := Vector2.RIGHT.rotated(_aim_angle)
	var attack_range := ATTACK_RANGE + alert_level * 70.0
	return {
		"start": _get_muzzle_world_position(),
		"end": global_position + direction * attack_range,
		"direction": direction,
		"strength": get_attack_tell_strength(),
	}

func get_rifleman_shot_tell_visual_version() -> String:
	return RIFLEMAN_SHOT_TELL_VISUAL_VERSION

func get_rifleman_shot_tell_marker_count() -> int:
	return RIFLEMAN_SHOT_TELL_MARKER_COUNT

func get_rifleman_shot_tell_arc_segment_count() -> int:
	return RIFLEMAN_SHOT_TELL_ARC_SEGMENTS

func _ready() -> void:
	max_health = 80.0
	health = max_health
	speed = 0.0
	contact_damage = 0.0
	z_index = 11
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 104.0)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_fire_timer = max(0.0, _fire_timer - delta)
	_recoil_timer = max(0.0, _recoil_timer - delta)
	var attack_range := ATTACK_RANGE + alert_level * 70.0

	if _charge_timer > 0.0:
		_charge_timer = max(0.0, _charge_timer - delta)
		_aim_angle = lerp_angle(_aim_angle, global_position.angle_to_point(_shot_target), delta * 9.0)
		if _charge_timer <= 0.0:
			_recoil_timer = 0.16
			_fire_timer = max(0.42, 1.15 - alert_level * 0.14)
			var shot_direction := Vector2.RIGHT.rotated(_aim_angle)
			var shot_start := _get_muzzle_world_position()
			var shot_end := global_position + shot_direction * attack_range
			if _distance_to_segment(player.global_position, global_position, shot_end) <= 32.0:
				player.take_damage(6.0 + alert_level * 1.5)
			if vfx_layer != null:
				if vfx_layer.has_method("rifle_warning_puff"):
					vfx_layer.rifle_warning_puff(shot_start, shot_direction)
				if vfx_layer.has_method("enemy_weapon_burst"):
					vfx_layer.enemy_weapon_burst(shot_start, shot_direction, "rifle")
				vfx_layer.beam(global_position, shot_end, Color(0.82, 0.32, 0.1))
			shot_fired.emit(self, shot_start, shot_end, shot_direction)
		_request_enemy_visual_redraw()
		return

	_aim_angle = lerp_angle(_aim_angle, global_position.angle_to_point(player.global_position), delta * 5.0)
	if _fire_timer <= 0.0 and global_position.distance_to(player.global_position) <= attack_range:
		_charge_timer = CHARGE_DURATION
		_shot_target = player.global_position
		if vfx_layer != null:
			if vfx_layer.has_method("rifle_warning_puff"):
				vfx_layer.rifle_warning_puff(_get_muzzle_world_position(), Vector2.RIGHT.rotated(_aim_angle))
			vfx_layer.beam(global_position, _shot_target, Color(0.78, 0.42, 0.16))
	_request_enemy_visual_redraw()

func _draw() -> void:
	_draw_character_shadow(0.9)
	var color := _health_color(Color(0.72, 0.38, 0.16))
	var facing := Vector2.RIGHT.rotated(_aim_angle)
	var side := facing.orthogonal()
	if _charge_timer > 0.0:
		var charge := get_attack_tell_strength()
		var warning_direction := Vector2.RIGHT.rotated(_aim_angle)
		var target_local := to_local(_shot_target)
		_draw_bounty_sightline_tell(warning_direction, target_local, charge)

	if _has_enemy_sprite():
		var charge_ratio := get_attack_tell_strength()
		var recoil_ratio := _recoil_timer / 0.16
		var pose_offset := -facing * (charge_ratio * 5.0 + recoil_ratio * 11.0)
		var pose_scale := Vector2(1.0 + charge_ratio * 0.06 - recoil_ratio * 0.04, 1.0 - charge_ratio * 0.05 + recoil_ratio * 0.05)
		_draw_enemy_sprite(facing, pose_offset, pose_scale, side.x * 0.025 * charge_ratio - side.x * 0.04 * recoil_ratio)
		_draw_rifle_overlay(facing, side, color, maxf(charge_ratio, recoil_ratio))
		_draw_enemy_role_silhouette_accent(facing, "rifleman", color, 0.52 + maxf(charge_ratio, recoil_ratio) * 0.45)
		return
	var poncho := PackedVector2Array([
		facing * 19.0,
		side * 17.0 + facing * 2.0,
		side * 13.0 - facing * 22.0,
		-side * 13.0 - facing * 22.0,
		-side * 17.0 + facing * 2.0,
	])
	_draw_enemy_human_legs(facing, side, color, 0.9, 0.0)
	draw_colored_polygon(poncho, Color(0.055, 0.043, 0.028, 0.98))
	draw_polyline(PackedVector2Array([poncho[0], poncho[1], poncho[2], poncho[3], poncho[4], poncho[0]]), color, 4.0)
	draw_circle(facing * 8.0, 8.0, Color(0.5, 0.32, 0.2, 1.0))
	draw_line(facing * 8.0 - side * 18.0, facing * 10.0 + side * 18.0, Color(0.012, 0.009, 0.008, 1.0), 7.0)
	draw_line(facing * 12.0 - side * 10.0, facing * 12.0 + side * 10.0, Color(0.9, 0.42, 0.12, 0.88), 3.0)
	draw_line(-side * 13.0 + facing * 1.0, -side * 28.0 + facing * 7.0, Color(0.035, 0.022, 0.016, 1.0), 5.0)
	draw_line(side * 12.0 + facing * 1.0, side * 27.0 + facing * 7.0, Color(0.035, 0.022, 0.016, 1.0), 5.0)
	draw_line(facing * 14.0 - side * 4.0, facing * 58.0 - side * 8.0, Color(0.86, 0.52, 0.22), 6.0)
	draw_line(facing * 18.0 - side * 4.0, facing * 64.0 - side * 8.0, Color(0.16, 0.09, 0.04), 2.0)
	draw_line(facing * 6.0 + side * 15.0, facing * 36.0 + side * 22.0, Color(0.25, 0.12, 0.05, 1.0), 5.0)
	_draw_enemy_role_silhouette_accent(facing, "rifleman", color, 0.56)

func _draw_rifle_overlay(facing: Vector2, side: Vector2, accent: Color, intensity: float) -> void:
	var shoulder := facing * 7.0 - side * 13.0
	var muzzle := facing * 64.0 - side * 9.0
	var glow := clampf(intensity, 0.0, 1.0)
	draw_line(shoulder, muzzle, Color(0.12, 0.07, 0.035, 0.95), 7.0)
	draw_line(shoulder + facing * 4.0, muzzle, Color(0.84, 0.52, 0.22, 0.84), 3.0)
	if glow > 0.0:
		var glow_color := accent.lightened(0.45)
		glow_color.a = 0.22 + glow * 0.38
		draw_circle(muzzle, 4.0 + glow * 4.0, glow_color)

func _draw_bounty_sightline_tell(direction: Vector2, target_local: Vector2, charge: float) -> void:
	var side := direction.orthogonal()
	var muzzle_local := direction * 64.0 - side * 9.0
	var lane_end := direction * 620.0
	var warning_color := Color(1.0, 0.54, 0.12, lerpf(0.42, 0.95, charge))
	var rail_shadow := Color(0.14, 0.035, 0.014, 0.32 + charge * 0.16)
	var brass := Color(1.0, 0.72, 0.24, 0.28 + charge * 0.36)
	var bone := Color(1.0, 0.88, 0.52, 0.22 + charge * 0.32)
	var rail_offset := lerpf(9.0, 14.0, charge)
	draw_line(muzzle_local - side * rail_offset + Vector2(3.0, 4.0), lane_end - side * rail_offset + Vector2(3.0, 4.0), rail_shadow, lerpf(4.0, 6.0, charge))
	draw_line(muzzle_local + side * rail_offset + Vector2(3.0, 4.0), lane_end + side * rail_offset + Vector2(3.0, 4.0), rail_shadow, lerpf(4.0, 6.0, charge))
	draw_line(muzzle_local - side * rail_offset, lane_end - side * rail_offset, brass, 2.0)
	draw_line(muzzle_local + side * rail_offset, lane_end + side * rail_offset, brass.darkened(0.1), 2.0)
	draw_line(muzzle_local, lane_end, warning_color, lerpf(3.0, 6.0, charge))
	for hash_index in range(3):
		var t := 0.28 + float(hash_index) * 0.18
		var hash_center := muzzle_local.lerp(lane_end, t)
		draw_line(hash_center - side * 11.0, hash_center + side * 11.0, bone, 1.4 + charge * 0.8)
	draw_arc(Vector2.ZERO, lerpf(34.0, 21.0, charge), -0.2, TAU - 0.2, RIFLEMAN_SHOT_TELL_ARC_SEGMENTS, warning_color, 3.5)
	draw_arc(target_local, 20.0 + charge * 8.0, 0.0, TAU, RIFLEMAN_SHOT_TELL_ARC_SEGMENTS, warning_color.lightened(0.18), 3.0)
	draw_line(target_local - side * 20.0, target_local + side * 20.0, warning_color, 2.6)
	draw_line(target_local - direction * 20.0, target_local + direction * 20.0, warning_color, 2.6)
	draw_line(muzzle_local - side * 12.0, muzzle_local + side * 12.0, bone.lightened(0.08), 3.2)

func _get_muzzle_world_position() -> Vector2:
	var facing := Vector2.RIGHT.rotated(_aim_angle)
	var side := facing.orthogonal()
	return global_position + facing * 64.0 - side * 9.0

func _distance_to_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> float:
	var segment := segment_end - segment_start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(segment_start)

	var t: float = clampf((point - segment_start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(segment_start + segment * t)
