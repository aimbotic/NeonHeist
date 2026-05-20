class_name DustEnemy
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
			vfx_layer.blood_spill(global_position, 12)
			vfx_layer.burst(global_position, Color(0.32, 0.02, 0.012), 10)
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

func _draw_enemy_human_legs(facing: Vector2, side: Vector2, accent: Color, scale: float = 1.0, stance: float = 1.0) -> void:
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0) * stance
	var gait: float = _walk_time * 1.6
	var shadow_width: float = 24.0 * scale + movement_ratio * 5.0
	draw_line(-side * shadow_width - facing * 18.0 * scale, side * shadow_width - facing * 18.0 * scale, Color(0.0, 0.0, 0.0, 0.24), 7.0 * scale)

	for i in range(2):
		var side_sign: float = -1.0 if i == 0 else 1.0
		var phase: float = gait + float(i) * PI
		var stride: float = sin(phase) * 12.0 * movement_ratio
		var knee_lift: float = maxf(0.0, cos(phase)) * 5.0 * movement_ratio
		var hip: Vector2 = -facing * 5.0 * scale + side * side_sign * 7.0 * scale
		var knee: Vector2 = hip - facing * (15.0 - stride * 0.35) * scale + side * side_sign * (3.0 + knee_lift) * scale
		var boot: Vector2 = hip - facing * (32.0 + stride) * scale + side * side_sign * 9.0 * scale
		var toe: Vector2 = boot + facing * 9.0 * scale + side * side_sign * 4.0 * scale

		draw_line(hip, knee, Color(0.075, 0.035, 0.018, 1.0), 6.0 * scale)
		draw_line(knee, boot, Color(0.035, 0.02, 0.014, 1.0), 6.0 * scale)
		draw_line(boot, toe, Color(0.01, 0.008, 0.007, 1.0), 6.0 * scale)
		draw_line(knee - side * side_sign * 2.0 * scale, knee + side * side_sign * 4.0 * scale, accent, 2.0 * scale)

	if movement_ratio > 0.08:
		var dust_alpha: float = 0.12 + movement_ratio * 0.13
		draw_circle(-facing * 35.0 * scale - side * 10.0 * scale, 4.0 * scale, Color(0.64, 0.39, 0.17, dust_alpha))
		draw_circle(-facing * 32.0 * scale + side * 12.0 * scale, 3.0 * scale, Color(0.64, 0.39, 0.17, dust_alpha * 0.8))
