extends "res://scripts/enemies/base_enemy.gd"

var _fire_timer := 0.0
var _charge_timer := 0.0
var _aim_angle := 0.0
var _shot_target := Vector2.ZERO

func _ready() -> void:
	max_health = 80.0
	health = max_health
	speed = 0.0
	contact_damage = 0.0
	z_index = 11

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_fire_timer = max(0.0, _fire_timer - delta)
	var attack_range := 520.0 + alert_level * 70.0

	if _charge_timer > 0.0:
		_charge_timer = max(0.0, _charge_timer - delta)
		_aim_angle = lerp_angle(_aim_angle, global_position.angle_to_point(_shot_target), delta * 9.0)
		if _charge_timer <= 0.0:
			_fire_timer = max(0.42, 1.15 - alert_level * 0.14)
			var shot_end := global_position + Vector2.RIGHT.rotated(_aim_angle) * attack_range
			if _distance_to_segment(player.global_position, global_position, shot_end) <= 32.0:
				player.take_damage(6.0 + alert_level * 1.5)
			if vfx_layer != null:
				vfx_layer.beam(global_position, shot_end, Color(0.82, 0.32, 0.1))
		queue_redraw()
		return

	_aim_angle = lerp_angle(_aim_angle, global_position.angle_to_point(player.global_position), delta * 5.0)
	if _fire_timer <= 0.0 and global_position.distance_to(player.global_position) <= attack_range:
		_charge_timer = 0.42
		_shot_target = player.global_position
		if vfx_layer != null:
			vfx_layer.beam(global_position, _shot_target, Color(0.78, 0.42, 0.16))
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(0.72, 0.38, 0.16))
	if _charge_timer > 0.0:
		var charge := 1.0 - _charge_timer / 0.42
		var warning_color := Color(0.82, 0.32, 0.1, lerpf(0.28, 0.9, charge))
		draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(_aim_angle) * 620.0, warning_color, lerpf(2.0, 6.0, charge))
		draw_arc(Vector2.ZERO, lerpf(36.0, 22.0, charge), 0.0, TAU, 28, warning_color, 4.0)
	draw_rect(Rect2(Vector2(-22, -22), Vector2(44, 44)), Color(0.028, 0.018, 0.014, 0.98), true)
	draw_rect(Rect2(Vector2(-22, -22), Vector2(44, 44)), color, false, 4.0)
	draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(_aim_angle) * 34.0, Color(0.86, 0.52, 0.22), 5.0)

func _distance_to_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> float:
	var segment := segment_end - segment_start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(segment_start)

	var t := clamp((point - segment_start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(segment_start + segment * t)
