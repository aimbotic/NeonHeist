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

func setup(target_player, game_director, effects) -> void:
	player = target_player
	director = game_director
	vfx_layer = effects

func _physics_process(delta: float) -> void:
	_hit_flash = max(0.0, _hit_flash - delta)
	_damage_cooldown = max(0.0, _damage_cooldown - delta)
	slow_timer = max(0.0, slow_timer - delta)

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
