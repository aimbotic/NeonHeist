extends "res://scripts/enemies/base_enemy.gd"

var _fire_timer := 0.0
var _aim_angle := 0.0

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
	_aim_angle = lerp_angle(_aim_angle, global_position.angle_to_point(player.global_position), delta * 5.0)
	var range := 520.0 + alert_level * 70.0
	if _fire_timer <= 0.0 and global_position.distance_to(player.global_position) <= range:
		_fire_timer = max(0.38, 1.25 - alert_level * 0.15)
		player.take_damage(6.0 + alert_level * 1.5)
		if vfx_layer != null:
			vfx_layer.beam(global_position, player.global_position, Color(1.0, 0.35, 0.08))
	queue_redraw()

func _draw() -> void:
	var color := _health_color(Color(1.0, 0.48, 0.08))
	draw_rect(Rect2(Vector2(-22, -22), Vector2(44, 44)), Color(0.04, 0.02, 0.06, 0.98), true)
	draw_rect(Rect2(Vector2(-22, -22), Vector2(44, 44)), color, false, 4.0)
	draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(_aim_angle) * 34.0, Color(0.2, 1.0, 1.0), 5.0)
