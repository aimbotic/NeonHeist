extends "res://scripts/enemies/base_enemy.gd"

const ENEMY_SPRITE_SLUG := "enemy_duelist_male"

var _strafe_sign := 1.0
var _draw_timer := 0.0
var _dash_timer := 0.0
var _attack_cooldown := 0.7
var _duel_direction := Vector2.RIGHT

func _ready() -> void:
	max_health = 230.0
	health = max_health
	speed = 245.0
	contact_damage = 22.0
	_strafe_sign = -1.0 if randf() < 0.5 else 1.0
	z_index = 14
	_load_enemy_turnaround_textures(ENEMY_SPRITE_SLUG, 112.0)

func _physics_process(delta: float) -> void:
	super(delta)
	if player == null:
		return

	_attack_cooldown = max(0.0, _attack_cooldown - delta)
	_draw_timer = max(0.0, _draw_timer - delta)
	_dash_timer = max(0.0, _dash_timer - delta)
	var to_player: Vector2 = global_position.direction_to(player.global_position)
	var distance: float = global_position.distance_to(player.global_position)

	if _dash_timer > 0.0:
		velocity = _duel_direction * speed * 3.0 * _speed_multiplier()
		move_and_slide()
		_try_contact_damage(54.0)
		queue_redraw()
		return

	if _draw_timer > 0.0:
		_duel_direction = to_player
		velocity = Vector2.ZERO
		if _draw_timer <= delta:
			_dash_timer = 0.18
		move_and_slide()
		queue_redraw()
		return

	if distance <= 430.0 and _attack_cooldown <= 0.0:
		_draw_timer = 0.28
		_attack_cooldown = 1.05
		_duel_direction = to_player
		queue_redraw()
		return

	var strafe := to_player.orthogonal() * _strafe_sign
	var desired := (to_player * 0.7 + strafe * 0.5).normalized()
	if distance < 150.0:
		desired = (-to_player + strafe * 0.4).normalized()
	velocity = desired * speed * (1.0 + alert_level * 0.1) * _speed_multiplier()
	move_and_slide()
	_try_contact_damage(44.0)
	queue_redraw()

func _draw() -> void:
	_draw_character_shadow(1.06, Vector2(64.0, 86.0))
	var color := _health_color(Color(0.95, 0.08, 0.035))
	var facing := _duel_direction.normalized()
	if player != null and _draw_timer <= 0.0 and _dash_timer <= 0.0:
		facing = global_position.direction_to(player.global_position)
	var side := facing.orthogonal()
	if _draw_timer > 0.0:
		var charge := 1.0 - _draw_timer / 0.28
		draw_arc(Vector2.ZERO, lerpf(54.0, 28.0, charge), 0.0, TAU, 30, Color(1.0, 0.76, 0.34, 0.9), 5.0)
		draw_line(-side * 28.0, side * 28.0, Color(1.0, 0.92, 0.58, 0.72), 4.0)
	elif _dash_timer > 0.0:
		draw_line(-facing * 32.0, -facing * 76.0, Color(0.82, 0.08, 0.035, 0.62), 8.0)

	if _has_enemy_sprite():
		_draw_enemy_sprite(facing)
		return
	_draw_enemy_human_legs(facing, side, color, 1.06, 1.2)
	var cloak := PackedVector2Array([
		facing * 28.0,
		side * 16.0 + facing * 6.0,
		side * 15.0 - facing * 30.0,
		-side * 15.0 - facing * 30.0,
		-side * 16.0 + facing * 6.0,
	])
	var hat := PackedVector2Array([
		facing * 21.0,
		side * 24.0 + facing * 7.0,
		side * 28.0,
		-side * 28.0,
		-side * 24.0 + facing * 7.0,
	])
	draw_colored_polygon(cloak, Color(0.045, 0.006, 0.005, 0.98))
	draw_polyline(PackedVector2Array([cloak[0], cloak[1], cloak[2], cloak[3], cloak[4], cloak[0]]), color, 5.0)
	draw_line(-side * 11.0 + facing * 5.0, side * 11.0 + facing * 5.0, Color(1.0, 0.12, 0.04, 0.96), 5.0)
	draw_circle(facing * 11.0, 8.0, Color(0.56, 0.36, 0.22, 1.0))
	draw_colored_polygon(hat, Color(0.006, 0.004, 0.003, 1.0))
	draw_line(facing * 10.0 - side * 9.0, facing * 11.0 + side * 9.0, Color(1.0, 0.72, 0.32, 0.88), 3.0)
	draw_line(facing * 12.0 - side * 12.0, facing * 52.0 - side * 22.0, Color(0.94, 0.9, 0.72, 0.94), 4.0)
	draw_line(facing * 17.0 + side * 9.0, facing * 42.0 + side * 20.0, Color(0.24, 0.1, 0.035, 1.0), 5.0)
