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
var _enemy_texture: Texture2D
var _enemy_direction_textures: Dictionary = {}
var _enemy_sprite_target_height := 104.0

func setup(target_player, game_director, effects) -> void:
	player = target_player
	director = game_director
	vfx_layer = effects

func _load_enemy_texture(path: String, target_height: float = 104.0) -> void:
	_enemy_texture = load(path) as Texture2D
	_enemy_sprite_target_height = target_height
	if _enemy_texture == null:
		push_warning("Could not load enemy sprite: %s" % path)

func _load_enemy_turnaround_textures(slug: String, target_height: float = 104.0) -> void:
	_enemy_sprite_target_height = target_height
	_enemy_direction_textures.clear()
	var directions := [
		"forward",
		"back",
		"left",
		"right",
		"top_left",
		"top_right",
		"bottom_left",
		"bottom_right",
	]
	for direction in directions:
		var path := "res://assets/enemies/turnaround/%s_%s_3d_topdown_v001.png" % [slug, direction]
		var texture := load(path) as Texture2D
		if texture == null:
			push_warning("Could not load enemy direction sprite: %s" % path)
		else:
			_enemy_direction_textures[direction] = texture
	_enemy_texture = _enemy_direction_textures.get("forward", null)

func _draw_enemy_sprite(facing: Vector2 = Vector2.DOWN) -> void:
	var texture := _get_enemy_texture_for_direction(_get_enemy_visual_facing(facing))
	if texture == null:
		return
	var visual_size := _get_enemy_sprite_size(texture)
	var draw_position := Vector2(-visual_size.x * 0.5, -visual_size.y * 0.5 + 8.0)
	var tint := Color.WHITE if _hit_flash <= 0.0 else Color(1.0, 0.92, 0.82, 1.0)
	_draw_enemy_running_sprite(texture, draw_position, visual_size, tint)

func _draw_enemy_running_sprite(texture: Texture2D, draw_position: Vector2, visual_size: Vector2, tint: Color) -> void:
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	if movement_ratio < 0.08:
		draw_texture_rect(texture, Rect2(draw_position, visual_size), false, tint)
		return

	var texture_size := texture.get_size()
	var phase := _walk_time * 3.4
	var step := sin(phase)
	var bob := absf(step) * 3.0 * movement_ratio
	var torso_ratio := 0.52
	var torso_src := Rect2(Vector2.ZERO, Vector2(texture_size.x, texture_size.y * torso_ratio))
	var torso_dest := Rect2(draw_position + Vector2(0.0, -bob), Vector2(visual_size.x, visual_size.y * torso_ratio + bob))
	draw_texture_rect_region(texture, torso_dest, torso_src, tint)

	var lower_src_y := texture_size.y * torso_ratio
	var lower_src_h := texture_size.y - lower_src_y
	var half_src_w := texture_size.x * 0.5
	var lower_dest_y := draw_position.y + visual_size.y * torso_ratio - 2.0
	var lower_dest_h := visual_size.y * (1.0 - torso_ratio) + 1.0
	var half_dest_w := visual_size.x * 0.5
	var stride := step * 9.0 * movement_ratio
	var lift := absf(step) * 4.5 * movement_ratio

	var left_src := Rect2(Vector2(0.0, lower_src_y), Vector2(half_src_w, lower_src_h))
	var right_src := Rect2(Vector2(half_src_w, lower_src_y), Vector2(half_src_w, lower_src_h))
	var left_dest := Rect2(Vector2(draw_position.x - stride * 0.55, lower_dest_y + lift), Vector2(half_dest_w + 2.0, lower_dest_h))
	var right_dest := Rect2(Vector2(draw_position.x + half_dest_w + stride * 0.55 - 2.0, lower_dest_y - lift), Vector2(half_dest_w + 2.0, lower_dest_h))
	draw_texture_rect_region(texture, left_dest, left_src, tint)
	draw_texture_rect_region(texture, right_dest, right_src, tint)
	_draw_enemy_run_contacts(visual_size, step, movement_ratio)

func _draw_enemy_run_contacts(visual_size: Vector2, step: float, movement_ratio: float) -> void:
	var base_y := visual_size.y * 0.46 + 8.0
	var foot_spread := clampf(visual_size.x * 0.25, 11.0, 23.0)
	var stride := step * 9.0 * movement_ratio
	for i in range(2):
		var side := -1.0 if i == 0 else 1.0
		var foot := Vector2(side * foot_spread + stride * side, base_y - absf(step * side) * 2.6)
		draw_set_transform(foot, 0.0, Vector2(9.0 + movement_ratio * 5.0, 2.8))
		draw_circle(Vector2.ZERO, 1.0, Color(0.035, 0.018, 0.008, 0.16 + movement_ratio * 0.14))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if movement_ratio > 0.35 and i == 0:
			draw_circle(foot - Vector2(stride * 0.4, 2.0), 2.3, Color(0.58, 0.36, 0.16, 0.14))

func _has_enemy_sprite() -> bool:
	return _enemy_texture != null or not _enemy_direction_textures.is_empty()

func _get_enemy_sprite_size(texture: Texture2D = null) -> Vector2:
	var selected_texture := texture if texture != null else _get_enemy_texture_for_direction(Vector2.DOWN)
	if selected_texture == null:
		return Vector2(58.0, 76.0)
	var texture_size := selected_texture.get_size()
	var sprite_scale := _enemy_sprite_target_height / maxf(texture_size.y, 1.0)
	return texture_size * sprite_scale

func _get_enemy_texture_for_direction(facing: Vector2) -> Texture2D:
	if _enemy_direction_textures.is_empty():
		return _enemy_texture
	var key := "forward"
	var normalized_facing := facing.normalized()
	if normalized_facing.length_squared() <= 0.001:
		normalized_facing = Vector2.DOWN
	if absf(normalized_facing.x) > 0.35 and absf(normalized_facing.y) > 0.35:
		if normalized_facing.y > 0.0:
			key = "bottom_right" if normalized_facing.x > 0.0 else "bottom_left"
		else:
			key = "top_right" if normalized_facing.x > 0.0 else "top_left"
	elif absf(normalized_facing.x) > absf(normalized_facing.y) * 1.25:
		key = "right" if normalized_facing.x > 0.0 else "left"
	elif absf(normalized_facing.y) > absf(normalized_facing.x) * 1.25:
		key = "forward" if normalized_facing.y > 0.0 else "back"
	return _enemy_direction_textures.get(key, _enemy_texture)

func _get_enemy_visual_facing(fallback_facing: Vector2 = Vector2.DOWN) -> Vector2:
	if velocity.length_squared() > 64.0:
		return velocity.normalized()
	if fallback_facing.length_squared() > 0.001:
		return fallback_facing.normalized()
	if player != null and global_position.distance_squared_to(player.global_position) > 1.0:
		return global_position.direction_to(player.global_position)
	return Vector2.DOWN

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

func _draw_character_shadow(scale: float = 1.0, fallback_size: Vector2 = Vector2(58.0, 76.0)) -> void:
	var visual_size := _get_enemy_sprite_size() if _has_enemy_sprite() else _get_largest_character_sprite_size(fallback_size * scale)
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var width := clampf(visual_size.x * 0.72 + movement_ratio * 8.0, 28.0 * scale, 112.0 * scale)
	var height := clampf(visual_size.y * 0.18, 10.0 * scale, 30.0 * scale)
	var y_offset := clampf(visual_size.y * 0.3, 18.0 * scale, 42.0 * scale)
	draw_set_transform(Vector2(0.0, y_offset), 0.0, Vector2(width * 0.5, height * 0.5))
	draw_circle(Vector2.ZERO, 1.0, Color(0.035, 0.018, 0.008, 0.3))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _get_largest_character_sprite_size(fallback_size: Vector2) -> Vector2:
	var largest := fallback_size
	for child in get_children():
		var child_size := Vector2.ZERO
		if child is Sprite2D and child.texture != null:
			child_size = child.texture.get_size() * child.scale.abs()
		elif child is AnimatedSprite2D and child.sprite_frames != null:
			var frame_texture: Texture2D = child.sprite_frames.get_frame_texture(child.animation, child.frame)
			if frame_texture != null:
				child_size = frame_texture.get_size() * child.scale.abs()
		if child_size.x * child_size.y > largest.x * largest.y:
			largest = child_size
	return largest

func _draw_enemy_human_legs(facing: Vector2, side: Vector2, accent: Color, scale: float = 1.0, stance: float = 1.0) -> void:
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0) * stance
	var gait: float = _walk_time * 1.6

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
