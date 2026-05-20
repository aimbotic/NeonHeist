class_name NeonEnemy
extends CharacterBody2D

signal destroyed(enemy)

var player
var director
var vfx_layer
var health := 45.0
var max_health := 45.0
var speed := 180.0
var contact_damage := 10.0
var alert_level := 0
var slow_timer := 0.0
var _hit_flash := 0.0
var _damage_cooldown := 0.0
var _walk_time := 0.0

func setup(target_player, game_director, effects) -> void:
	player = target_player
	director = game_director
	vfx_layer = effects

func _physics_process(delta: float) -> void:
	_hit_flash = max(0.0, _hit_flash - delta)
	_damage_cooldown = max(0.0, _damage_cooldown - delta)
	slow_timer = max(0.0, slow_timer - delta)
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	_walk_time += delta * lerpf(2.2, 11.0, movement_ratio)

func take_damage(amount: float) -> void:
	health -= amount
	_hit_flash = 0.12
	queue_redraw()
	if health <= 0.0:
		if vfx_layer != null:
			vfx_layer.burst(global_position, Color(1.0, 0.18, 0.82), 18)
		destroyed.emit(self)
		queue_free()

func set_alert_level(level: int) -> void:
	alert_level = level

func apply_slow(duration: float) -> void:
	slow_timer = max(slow_timer, duration)

func _speed_multiplier() -> float:
	return 0.45 if slow_timer > 0.0 else 1.0

func _try_contact_damage(range: float = 34.0) -> void:
	if player == null or _damage_cooldown > 0.0:
		return
	if global_position.distance_to(player.global_position) <= range:
		player.take_damage(contact_damage + alert_level * 2.0)
		_damage_cooldown = 0.55

func _health_color(base: Color) -> Color:
	if _hit_flash > 0.0:
		return Color.WHITE
	return base

func _draw_crawling_legs(facing: Vector2, side: Vector2, accent: Color, scale: float = 1.0, crawl_strength: float = 1.0) -> void:
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0) * crawl_strength
	var gait: float = _walk_time * 1.35
	draw_circle(-facing * 8.0 * scale, 22.0 * scale, Color(0.0, 0.0, 0.0, 0.24))

	for i in range(4):
		var side_sign: float = -1.0 if i % 2 == 0 else 1.0
		var rear_row: float = 1.0 if i >= 2 else 0.0
		var phase: float = gait + float(i % 2) * PI + rear_row * 1.45
		var stride: float = sin(phase) * 10.0 * movement_ratio
		var lift: float = maxf(0.0, cos(phase)) * 4.0 * movement_ratio
		var hip: Vector2 = -facing * (4.0 + rear_row * 11.0) * scale + side * side_sign * (8.0 + rear_row * 4.0) * scale
		var knee: Vector2 = hip - facing * (8.0 - stride * 0.35) * scale + side * side_sign * (9.0 + lift) * scale
		var foot: Vector2 = hip - facing * (19.0 + stride) * scale + side * side_sign * (17.0 + rear_row * 3.0) * scale
		var foot_tip: Vector2 = foot - facing * (6.0 + absf(stride) * 0.25) * scale

		draw_line(hip, knee, Color(0.012, 0.009, 0.008, 1.0), 5.0 * scale)
		draw_line(knee, foot, Color(0.035, 0.022, 0.016, 1.0), 5.0 * scale)
		draw_line(foot, foot_tip, Color(0.01, 0.008, 0.007, 1.0), 4.0 * scale)
		draw_circle(foot_tip, 2.8 * scale, Color(0.02, 0.012, 0.009, 1.0))

	if movement_ratio > 0.08:
		var dust_alpha: float = 0.12 + movement_ratio * 0.12
		draw_circle(-facing * 25.0 * scale - side * 13.0 * scale, 4.0 * scale, Color(0.64, 0.39, 0.17, dust_alpha))
		draw_circle(-facing * 28.0 * scale + side * 14.0 * scale, 3.0 * scale, Color(0.64, 0.39, 0.17, dust_alpha * 0.8))
