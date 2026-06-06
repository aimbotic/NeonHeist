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
var _hit_recoil_timer := 0.0
var _hit_recoil_direction := Vector2.DOWN
var _damage_cooldown := 0.0
var _walk_time := 0.0
var _movement_dust_timer := 0.0
var _enemy_texture: Texture2D
var _enemy_direction_textures: Dictionary = {}
var _enemy_sprite_target_height := 104.0
const ENEMY_SILHOUETTE_VISUAL_VERSION := "role_silhouette_badge_plate_readability_v8"
const ENEMY_MOVEMENT_DUST_INTEGRATION_VERSION := "enemy_movement_boot_dust_v1"
const ENEMY_HIT_RECOIL_VISUAL_VERSION := "enemy_hit_recoil_shadow_rim_v1"
const ENEMY_GROUNDED_SPRITE_VISUAL_VERSION := "enemy_directional_safe_crop_motion_redraw_budget_8fps_v10"
const ENEMY_SOURCE_CROP_VISUAL_VERSION := "enemy_turnaround_directional_safe_source_crop_v2"
const ENEMY_MOTION_REDRAW_INTERVAL := 1.0 / 8.0
const ENEMY_IDLE_REDRAW_INTERVAL := 1.0 / 4.0
var _motion_redraw_timer := 0.0
var _enemy_sprite_direction_key := "forward"

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

func _draw_enemy_sprite(facing: Vector2 = Vector2.DOWN, pose_offset: Vector2 = Vector2.ZERO, pose_scale: Vector2 = Vector2.ONE, pose_rotation: float = 0.0) -> void:
	var texture := _get_enemy_texture_for_direction(_get_enemy_visual_facing(facing))
	if texture == null:
		return
	var source_rect := _get_enemy_source_rect(texture)
	var visual_size := _get_enemy_sprite_size(texture, source_rect)
	var draw_position := Vector2(-visual_size.x * 0.5, -visual_size.y * 0.5 + 8.0)
	var tint := Color.WHITE if _hit_flash <= 0.0 else Color(1.0, 0.92, 0.82, 1.0)
	var recoil_ratio := _get_hit_recoil_ratio()
	var recoil_offset := _get_hit_recoil_offset() if recoil_ratio > 0.0 else Vector2.ZERO
	var recoil_rotation := _hit_recoil_direction.orthogonal().x * 0.055 * recoil_ratio
	var recoil_scale := Vector2(1.0 + recoil_ratio * 0.045, 1.0 - recoil_ratio * 0.035)
	draw_set_transform(pose_offset + recoil_offset, pose_rotation + recoil_rotation, pose_scale * recoil_scale)
	_draw_enemy_role_readability_plate(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	_draw_enemy_running_sprite(texture, draw_position, visual_size, source_rect, tint)
	_draw_enemy_whole_sprite_role_glints(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	if recoil_ratio > 0.0 or _hit_flash > 0.0:
		_draw_enemy_sprite_material_rim(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_draw_hit_recoil_rim(visual_size, recoil_ratio)

func _draw_enemy_running_sprite(texture: Texture2D, draw_position: Vector2, visual_size: Vector2, source_rect: Rect2, tint: Color) -> void:
	draw_texture_rect_region(texture, Rect2(draw_position, visual_size), source_rect, tint)

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

func get_enemy_silhouette_visual_version() -> String:
	return ENEMY_SILHOUETTE_VISUAL_VERSION

func get_enemy_grounded_sprite_visual_version() -> String:
	return ENEMY_GROUNDED_SPRITE_VISUAL_VERSION

func get_enemy_motion_redraw_interval() -> float:
	return ENEMY_MOTION_REDRAW_INTERVAL

func get_enemy_sprite_material_marker_count() -> int:
	return 26

func get_enemy_source_crop_visual_version() -> String:
	return ENEMY_SOURCE_CROP_VISUAL_VERSION

func get_enemy_directional_source_crop_count() -> int:
	return 8

func _get_enemy_sprite_size(texture: Texture2D = null, source_rect: Rect2 = Rect2()) -> Vector2:
	var selected_texture := texture if texture != null else _get_enemy_texture_for_direction(Vector2.DOWN)
	if selected_texture == null:
		return Vector2(58.0, 76.0)
	var selected_source_rect := source_rect if source_rect.size.length_squared() > 0.001 else _get_enemy_source_rect(selected_texture)
	var sprite_scale := _enemy_sprite_target_height / maxf(selected_source_rect.size.y, 1.0)
	return selected_source_rect.size * sprite_scale

func _get_enemy_source_rect(texture: Texture2D) -> Rect2:
	if texture == null:
		return Rect2(Vector2.ZERO, Vector2(58.0, 76.0))
	var texture_size := texture.get_size()
	var crop := _get_directional_enemy_source_crop(_enemy_sprite_direction_key)
	var crop_position := Vector2(texture_size.x * crop.x, texture_size.y * crop.y)
	var crop_size := Vector2(texture_size.x * crop.z, texture_size.y * crop.w)
	return Rect2(crop_position, crop_size)

func _get_directional_enemy_source_crop(key: String) -> Vector4:
	match key:
		"back":
			return Vector4(0.115, 0.064, 0.770, 0.850)
		"left":
			return Vector4(0.086, 0.076, 0.775, 0.850)
		"right":
			return Vector4(0.140, 0.076, 0.775, 0.850)
		"top_left":
			return Vector4(0.095, 0.068, 0.775, 0.850)
		"top_right":
			return Vector4(0.135, 0.068, 0.775, 0.850)
		"bottom_left":
			return Vector4(0.095, 0.076, 0.775, 0.850)
		"bottom_right":
			return Vector4(0.135, 0.076, 0.775, 0.850)
		_:
			return Vector4(0.115, 0.076, 0.770, 0.850)

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
	_enemy_sprite_direction_key = key
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
	if _motion_redraw_timer > 0.0:
		_motion_redraw_timer = maxf(0.0, _motion_redraw_timer - delta)
	_hit_flash = max(0.0, _hit_flash - delta)
	_hit_recoil_timer = max(0.0, _hit_recoil_timer - delta)
	_damage_cooldown = max(0.0, _damage_cooldown - delta)
	slow_timer = max(0.0, slow_timer - delta)
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	_walk_time += delta * lerpf(2.2, 11.0, movement_ratio)
	_emit_movement_dust_if_needed(delta, movement_ratio)

func get_enemy_movement_dust_integration_version() -> String:
	return ENEMY_MOVEMENT_DUST_INTEGRATION_VERSION

func _emit_movement_dust_if_needed(delta: float, movement_ratio: float) -> void:
	if vfx_layer == null or not vfx_layer.has_method("enemy_movement_dust"):
		return
	if movement_ratio < 0.2 or velocity.length_squared() <= 64.0:
		_movement_dust_timer = minf(_movement_dust_timer, 0.08)
		return
	_movement_dust_timer -= delta
	if _movement_dust_timer > 0.0:
		return
	var direction := velocity.normalized()
	var stride_gap := lerpf(0.42, 0.24, clampf(movement_ratio, 0.0, 1.0))
	_movement_dust_timer = stride_gap
	vfx_layer.enemy_movement_dust(global_position - direction * 24.0 + Vector2(0.0, 28.0), direction, _get_enemy_kind_for_vfx(), movement_ratio)

func take_damage(amount: float) -> void:
	health -= amount
	_hit_flash = 0.12
	_hit_recoil_timer = 0.16
	_hit_recoil_direction = _get_hit_recoil_direction()
	_play_enemy_hit_spark()
	_request_enemy_visual_redraw(true)
	if health <= 0.0:
		if vfx_layer != null:
			vfx_layer.blood_spill(global_position, 12)
			vfx_layer.burst(global_position, Color(0.32, 0.02, 0.012), 10)
		destroyed.emit(self)
		queue_free()

func _play_enemy_hit_spark() -> void:
	if vfx_layer == null or not vfx_layer.has_method("enemy_hit_spark"):
		return
	vfx_layer.enemy_hit_spark(global_position, _get_hit_recoil_direction(), _get_enemy_kind_for_vfx())

func get_enemy_hit_recoil_visual_version() -> String:
	return ENEMY_HIT_RECOIL_VISUAL_VERSION

func has_active_hit_recoil() -> bool:
	return _hit_recoil_timer > 0.0

func _get_hit_recoil_ratio() -> float:
	return clampf(_hit_recoil_timer / 0.16, 0.0, 1.0)

func _get_hit_recoil_direction() -> Vector2:
	if player != null and is_instance_valid(player) and player is Node2D:
		var player_node := player as Node2D
		if player_node.global_position.distance_squared_to(global_position) > 1.0:
			return player_node.global_position.direction_to(global_position).normalized()
	if velocity.length_squared() > 0.001:
		return -velocity.normalized()
	return _hit_recoil_direction.normalized() if _hit_recoil_direction.length_squared() > 0.001 else Vector2.DOWN

func _get_hit_recoil_offset(scale: float = 1.0) -> Vector2:
	var ratio := _get_hit_recoil_ratio()
	return _hit_recoil_direction.normalized() * lerpf(12.0, 2.0, 1.0 - ratio) * ratio * scale

func _get_enemy_kind_for_vfx() -> String:
	var script_path := ""
	var enemy_script: Script = get_script()
	if enemy_script != null:
		script_path = str(enemy_script.resource_path)
	for kind in ["knife_rusher", "rifleman", "shotgun_brute", "hunter", "duelist"]:
		if script_path.find(kind) >= 0:
			return kind
	return ""

func _request_enemy_visual_redraw(force: bool = false) -> void:
	if force:
		_motion_redraw_timer = 0.0
		queue_redraw()
		return
	if _motion_redraw_timer > 0.0:
		return
	var has_attack_tell_active := has_method("has_attack_tell") and bool(call("has_attack_tell"))
	var has_recover_tell_active := has_method("has_recover_tell") and bool(call("has_recover_tell"))
	var has_active_visual := velocity.length_squared() > 64.0 or _hit_flash > 0.0 or _hit_recoil_timer > 0.0 or slow_timer > 0.0 or has_attack_tell_active or has_recover_tell_active
	_motion_redraw_timer = ENEMY_MOTION_REDRAW_INTERVAL if has_active_visual else ENEMY_IDLE_REDRAW_INTERVAL
	queue_redraw()

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
	var recoil_ratio := _get_hit_recoil_ratio()
	var width := clampf(visual_size.x * 0.72 + movement_ratio * 8.0 + recoil_ratio * 14.0, 28.0 * scale, 112.0 * scale)
	var height := clampf(visual_size.y * 0.18 - recoil_ratio * 2.0, 8.0 * scale, 30.0 * scale)
	var y_offset := clampf(visual_size.y * 0.3, 18.0 * scale, 42.0 * scale)
	var cast_direction := Vector2(0.78, 0.36).normalized()
	var cast_length := clampf(visual_size.y * (0.22 + movement_ratio * 0.08 + recoil_ratio * 0.1), 16.0 * scale, 54.0 * scale)
	var cast_origin := Vector2(2.0 * scale, y_offset + 7.0 * scale)
	draw_line(cast_origin, cast_origin + cast_direction * cast_length, Color(0.045, 0.018, 0.007, 0.13 + recoil_ratio * 0.08), clampf(height * 0.48, 5.0 * scale, 13.0 * scale))
	draw_line(cast_origin - Vector2(9.0 * scale, 2.0 * scale), cast_origin - Vector2(9.0 * scale, 2.0 * scale) + cast_direction * cast_length * 0.7, Color(0.12, 0.055, 0.018, 0.07 + movement_ratio * 0.03), clampf(height * 0.28, 3.0 * scale, 8.0 * scale))
	if recoil_ratio > 0.0:
		var skid_origin := _get_hit_recoil_offset(scale) * 0.38 + Vector2(0.0, y_offset + 4.0 * scale)
		draw_set_transform(skid_origin, _hit_recoil_direction.angle(), Vector2(24.0 * scale + recoil_ratio * 18.0, 3.2 * scale))
		draw_circle(Vector2.ZERO, 1.0, Color(0.12, 0.035, 0.014, 0.26 * recoil_ratio))
		draw_set_transform(skid_origin - _hit_recoil_direction * 10.0 * scale, _hit_recoil_direction.angle(), Vector2(15.0 * scale, 2.0 * scale))
		draw_circle(Vector2.ZERO, 1.0, Color(0.72, 0.42, 0.16, 0.16 * recoil_ratio))
	draw_set_transform(Vector2(9.0 * scale, y_offset + 7.0 * scale), 0.0, Vector2(width * 0.62, height * 0.42))
	draw_circle(Vector2.ZERO, 1.0, Color(0.025, 0.012, 0.006, 0.2))
	draw_set_transform(Vector2(-5.0 * scale, y_offset + 2.0 * scale), 0.0, Vector2(width * 0.42, height * 0.24))
	draw_circle(Vector2.ZERO, 1.0, Color(0.09, 0.045, 0.018, 0.12))
	draw_set_transform(Vector2(0.0, y_offset), 0.0, Vector2(width * 0.5, height * 0.5))
	draw_circle(Vector2.ZERO, 1.0, Color(0.035, 0.018, 0.008, 0.34))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_enemy_sprite_material_rim(visual_size: Vector2, facing: Vector2, role: String) -> void:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var side := facing.orthogonal()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var recoil_ratio := _get_hit_recoil_ratio()
	var accent := _get_enemy_material_accent(role)
	var rim := accent.lightened(0.36)
	rim.a = 0.22 + movement_ratio * 0.08 + recoil_ratio * 0.18
	var brass := Color(0.98, 0.72, 0.28, 0.28 + recoil_ratio * 0.16)
	var sun_edge := Color(1.0, 0.82, 0.42, 0.16 + movement_ratio * 0.07 + recoil_ratio * 0.14)
	var dark := Color(0.022, 0.011, 0.006, 0.36)
	var head := -facing * clampf(visual_size.y * 0.1, 7.0, 17.0) + Vector2(0.0, -3.0)
	var hat_width := clampf(visual_size.x * 0.3, 14.0, 26.0)
	var shoulder_width := clampf(visual_size.x * 0.24, 12.0, 22.0)
	draw_line(head - side * hat_width, head + side * hat_width, dark, 5.0)
	draw_line(head - side * hat_width * 0.68 - facing * 2.0, head + side * hat_width * 0.68 - facing * 2.0, rim, 2.0)
	draw_line(head - side * hat_width * 0.42 - facing * 5.0, head + side * hat_width * 0.42 - facing * 5.0, sun_edge, 1.3)
	draw_line(-facing * 2.0 - side * shoulder_width, facing * 1.0 + side * shoulder_width, Color(0.05, 0.022, 0.012, 0.3), 4.0)
	draw_line(facing * 2.0 - side * shoulder_width * 0.78, facing * 4.0 + side * shoulder_width * 0.78, brass, 1.8)
	draw_line(-facing * 5.0 - side * shoulder_width * 0.62, -facing * 3.0 + side * shoulder_width * 0.62, sun_edge, 1.1)
	draw_circle(facing * 2.0 - side * shoulder_width * 0.32, 1.7, brass)
	draw_circle(facing * 3.0 + side * shoulder_width * 0.32, 1.7, brass.darkened(0.08))
	var foot_y := clampf(visual_size.y * 0.39, 27.0, 48.0)
	var contact_alpha := 0.11 + movement_ratio * 0.09 + recoil_ratio * 0.12
	draw_line(Vector2(-shoulder_width * 0.92, foot_y), Vector2(shoulder_width * 0.74, foot_y + 3.0), Color(0.048, 0.018, 0.007, contact_alpha), 3.0)
	draw_line(Vector2(-shoulder_width * 0.6, foot_y - 2.0), Vector2(shoulder_width * 0.46, foot_y + 0.8), Color(0.98, 0.68, 0.24, 0.1 + recoil_ratio * 0.1), 1.1)
	draw_line(head + side * hat_width * 0.48 + facing * 3.0, head + side * hat_width * 0.86 + facing * 6.0, Color(1.0, 0.84, 0.5, 0.15 + recoil_ratio * 0.16), 1.1)
	draw_circle(-facing * 9.0 - side * shoulder_width * 0.46, 1.8, rim)
	draw_circle(-facing * 8.0 + side * shoulder_width * 0.48, 1.6, brass)
	match role:
		"rifleman":
			draw_line(facing * 12.0 - side * 14.0, facing * 62.0 - side * 10.0, rim, 1.6)
			draw_line(facing * 28.0 - side * 13.0, facing * 68.0 - side * 11.0, sun_edge, 1.0)
		"shotgun_brute":
			draw_line(facing * 11.0 - side * 16.0, facing * 55.0 - side * 22.0, rim, 2.2)
			draw_line(facing * 19.0 - side * 17.0, facing * 50.0 - side * 24.0, sun_edge, 1.2)
		"knife_rusher":
			draw_line(facing * 20.0 - side * 6.0, facing * 42.0 - side * 1.0, Color(1.0, 0.88, 0.58, 0.34 + recoil_ratio * 0.2), 1.8)
			draw_line(facing * 25.0 - side * 4.0, facing * 44.0 + side * 1.0, sun_edge, 1.0)
		"hunter":
			draw_line(facing * 14.0 - side * 12.0, facing * 48.0 - side * 18.0, Color(0.96, 0.84, 0.58, 0.3 + recoil_ratio * 0.16), 1.8)
			draw_line(facing * 9.0 + side * 12.0, facing * 37.0 + side * 18.0, sun_edge, 1.0)
		"duelist":
			draw_line(facing * 13.0 - side * 13.0, facing * 55.0 - side * 23.0, Color(1.0, 0.9, 0.62, 0.34 + recoil_ratio * 0.18), 2.0)
			draw_line(facing * 14.0 + side * 13.0, facing * 48.0 + side * 21.0, sun_edge, 1.1)

func _draw_enemy_whole_sprite_role_glints(visual_size: Vector2, facing: Vector2, role: String) -> void:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var side := facing.orthogonal()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var accent := _get_enemy_material_accent(role)
	var rim := accent.lightened(0.28)
	rim.a = 0.24
	var brass := Color(0.98, 0.72, 0.28, 0.26)
	var leather := Color(0.03, 0.016, 0.008, 0.28)
	var iron := Color(0.12, 0.095, 0.072, 0.34)
	var bone := Color(0.94, 0.86, 0.62, 0.24)
	var hat_y := -visual_size.y * 0.27
	var shoulder_y := -visual_size.y * 0.1
	var belt_y := visual_size.y * 0.05
	var boot_y := visual_size.y * 0.35
	var hat_half := clampf(visual_size.x * 0.21, 12.0, 24.0)
	var shoulder_half := clampf(visual_size.x * 0.18, 11.0, 21.0)

	draw_line(Vector2(0.0, hat_y) - side * hat_half, Vector2(0.0, hat_y) + side * hat_half, leather, 3.0)
	draw_line(Vector2(0.0, hat_y - 2.0) - side * hat_half * 0.48, Vector2(0.0, hat_y - 2.0) + side * hat_half * 0.48, rim, 1.2)
	draw_line(Vector2(0.0, shoulder_y) - side * shoulder_half, Vector2(0.0, shoulder_y + 1.0) + side * shoulder_half, rim, 1.7)
	draw_line(Vector2(0.0, belt_y) - side * shoulder_half * 0.82, Vector2(0.0, belt_y + 1.0) + side * shoulder_half * 0.82, brass, 1.6)
	draw_circle(Vector2(0.0, belt_y) + facing * 1.5, 1.8, brass)
	draw_line(Vector2(0.0, belt_y + 3.0) - side * shoulder_half * 0.72, Vector2(0.0, boot_y - 6.0) - side * shoulder_half * 0.5, leather, 1.8)
	draw_line(Vector2(0.0, boot_y), Vector2(0.0, boot_y) + side * shoulder_half * 0.92, Color(0.045, 0.018, 0.008, 0.16 + movement_ratio * 0.1), 2.2)
	match role:
		"rifleman":
			draw_line(Vector2(0.0, belt_y + 2.0) - side * shoulder_half * 0.96, Vector2(0.0, belt_y + 22.0) - side * shoulder_half * 1.18 + facing * 12.0, iron, 2.2)
			draw_line(Vector2(0.0, belt_y + 2.0) - side * shoulder_half * 0.96, Vector2(0.0, belt_y + 22.0) - side * shoulder_half * 1.18 + facing * 12.0, brass, 0.9)
		"shotgun_brute":
			draw_line(Vector2(0.0, shoulder_y + 8.0) + side * shoulder_half * 0.9, Vector2(0.0, belt_y + 20.0) + side * shoulder_half * 1.18 + facing * 10.0, iron, 3.0)
			draw_line(Vector2(0.0, shoulder_y + 9.0) + side * shoulder_half * 0.9, Vector2(0.0, belt_y + 20.0) + side * shoulder_half * 1.18 + facing * 10.0, rim, 1.0)
		"knife_rusher":
			draw_line(Vector2(0.0, belt_y + 4.0) - side * shoulder_half * 0.84, Vector2(0.0, belt_y + 26.0) - side * shoulder_half * 1.02 + facing * 14.0, bone, 1.4)
		"hunter":
			draw_line(Vector2(0.0, shoulder_y + 4.0) - side * shoulder_half * 0.95, Vector2(0.0, boot_y - 12.0) - side * shoulder_half * 1.08, rim, 1.2)
			draw_line(Vector2(0.0, shoulder_y + 5.0) + side * shoulder_half * 0.95, Vector2(0.0, boot_y - 12.0) + side * shoulder_half * 1.08, leather, 1.5)
		"duelist":
			draw_line(Vector2(0.0, shoulder_y + 2.0) - side * shoulder_half * 0.9, Vector2(0.0, belt_y + 18.0) - side * shoulder_half * 1.05 + facing * 10.0, bone, 1.5)
			draw_circle(Vector2(0.0, belt_y + 7.0) + side * shoulder_half * 0.96, 1.7, brass)
	if movement_ratio > 0.18:
		draw_line(Vector2(0.0, boot_y + 3.0) - side * shoulder_half * 0.78, Vector2(0.0, boot_y + 8.0) - side * shoulder_half * 1.04, Color(0.8, 0.42, 0.16, 0.12 + movement_ratio * 0.12), 1.3)

func _draw_enemy_role_readability_plate(visual_size: Vector2, facing: Vector2, role: String) -> void:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var side := facing.orthogonal()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var recoil_ratio := _get_hit_recoil_ratio()
	var accent := _get_enemy_material_accent(role)
	var foot_y := clampf(visual_size.y * 0.42, 31.0, 58.0)
	var half_width := clampf(visual_size.x * 0.34, 18.0, 36.0)
	var plate_alpha := 0.16 + movement_ratio * 0.06 + recoil_ratio * 0.1
	draw_line(Vector2(-half_width, foot_y + 7.0), Vector2(half_width, foot_y + 7.0), Color(0.02, 0.009, 0.004, 0.28 + recoil_ratio * 0.12), 7.0)
	draw_line(Vector2(-half_width * 0.78, foot_y + 3.0), Vector2(half_width * 0.78, foot_y + 3.0), Color(accent.r, accent.g, accent.b, plate_alpha), 4.0)
	draw_line(Vector2(-half_width * 0.52, foot_y), Vector2(half_width * 0.52, foot_y), Color(1.0, 0.76, 0.3, 0.1 + recoil_ratio * 0.08), 1.5)
	match role:
		"rifleman":
			draw_line(Vector2(-half_width * 0.34, foot_y - 3.0), Vector2(half_width * 0.44, foot_y - 7.0), Color(1.0, 0.72, 0.24, 0.18), 1.2)
		"shotgun_brute":
			draw_line(Vector2(-half_width * 0.62, foot_y - 2.0), Vector2(half_width * 0.62, foot_y - 2.0), Color(0.88, 0.18, 0.06, 0.16), 2.4)
		"knife_rusher":
			draw_line(Vector2(-half_width * 0.42, foot_y - 1.0), Vector2(half_width * 0.16, foot_y - 11.0), Color(1.0, 0.84, 0.45, 0.22), 1.5)
		"hunter":
			draw_line(Vector2(-half_width * 0.54, foot_y - 5.0), Vector2(half_width * 0.54, foot_y + 2.0), Color(0.9, 0.22, 0.08, 0.16), 1.4)
		"duelist":
			draw_line(Vector2(-half_width * 0.5, foot_y - 4.0), Vector2(half_width * 0.5, foot_y - 4.0), Color(1.0, 0.84, 0.42, 0.22), 2.0)
	_draw_enemy_role_badge_plate(Vector2(half_width * 0.54, foot_y + 1.0), facing, side, role, accent)

func _draw_enemy_role_badge_plate(center: Vector2, facing: Vector2, side: Vector2, role: String, accent: Color) -> void:
	var dark := Color(0.025, 0.01, 0.004, 0.46)
	var brass := Color(1.0, 0.72, 0.26, 0.32)
	var red := Color(0.86, 0.08, 0.035, 0.28)
	draw_circle(center + Vector2(1.2, 1.6), 8.0, dark)
	draw_circle(center, 6.0, Color(accent.r, accent.g, accent.b, 0.2))
	draw_arc(center, 6.0, 0.0, TAU, 16, brass, 1.0)
	match role:
		"knife_rusher":
			draw_line(center - side * 4.0 - facing * 4.0, center + side * 4.0 + facing * 5.0, Color(1.0, 0.86, 0.48, 0.5), 1.4)
			draw_line(center - side * 3.0 + facing * 5.0, center + side * 5.0 - facing * 3.0, red, 1.2)
		"rifleman":
			draw_line(center - side * 6.0, center + side * 6.0, brass, 1.6)
			draw_circle(center + side * 6.5, 1.6, Color(1.0, 0.86, 0.46, 0.42))
		"shotgun_brute":
			for shell in range(3):
				var shell_center := center + side * float(shell - 1) * 4.0
				draw_rect(Rect2(shell_center - Vector2(1.5, 4.0), Vector2(3.0, 8.0)), Color(0.12, 0.046, 0.016, 0.42), true)
				draw_circle(shell_center + Vector2(0.0, 3.5), 1.2, brass)
		"hunter":
			for claw in range(3):
				var claw_offset := side * float(claw - 1) * 3.4
				draw_line(center + claw_offset - facing * 5.0, center + claw_offset + facing * 5.0 + side * 2.0, red, 1.2)
		"duelist":
			var star := PackedVector2Array()
			for point in range(10):
				var radius := 5.6 if point % 2 == 0 else 2.7
				var angle := -PI * 0.5 + float(point) * TAU / 10.0
				star.append(center + Vector2(cos(angle), sin(angle)) * radius)
			draw_colored_polygon(star, Color(0.12, 0.052, 0.018, 0.32))
			draw_polyline(star, brass, 0.9, true)
		_:
			draw_line(center - side * 4.0, center + side * 4.0, brass, 1.2)

func _get_enemy_material_accent(role: String) -> Color:
	match role:
		"knife_rusher":
			return Color(0.86, 0.38, 0.08, 1.0)
		"rifleman":
			return Color(0.72, 0.38, 0.16, 1.0)
		"shotgun_brute":
			return Color(0.82, 0.34, 0.08, 1.0)
		"hunter":
			return Color(0.72, 0.18, 0.08, 1.0)
		"duelist":
			return Color(0.95, 0.58, 0.18, 1.0)
		_:
			return Color(0.76, 0.44, 0.18, 1.0)

func _draw_hit_recoil_rim(visual_size: Vector2, recoil_ratio: float) -> void:
	if recoil_ratio <= 0.0:
		return
	var side := _hit_recoil_direction.orthogonal()
	var edge_center := -_hit_recoil_direction * clampf(visual_size.y * 0.16, 12.0, 28.0) + Vector2(0.0, 7.0)
	var blood := Color(0.82, 0.035, 0.025, 0.34 * recoil_ratio)
	var bone := Color(1.0, 0.9, 0.62, 0.42 * recoil_ratio)
	draw_line(edge_center - side * visual_size.x * 0.24, edge_center + side * visual_size.x * 0.18, blood, 4.0)
	draw_line(edge_center - side * visual_size.x * 0.16, edge_center + side * visual_size.x * 0.12, bone, 1.8)

func _draw_enemy_role_silhouette_accent(facing: Vector2, role: String, accent: Color, intensity: float = 0.55) -> void:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var side := facing.orthogonal()
	var glow := clampf(intensity, 0.0, 1.0)
	var dark := Color(0.025, 0.012, 0.006, 0.58)
	var brass := Color(0.95, 0.68, 0.28, 0.68 + glow * 0.18)
	var red := Color(0.86, 0.12, 0.055, 0.62 + glow * 0.2)
	var mark := accent.lightened(0.35)
	mark.a = 0.48 + glow * 0.32

	match role:
		"knife_rusher":
			var scarf := PackedVector2Array([
				facing * 7.0 - side * 19.0,
				facing * 17.0 - side * 4.0,
				-facing * 2.0 + side * 12.0,
				-facing * 8.0 - side * 6.0,
			])
			draw_colored_polygon(scarf, red)
			draw_line(facing * 23.0 - side * 5.0, facing * 43.0 - side * 1.0, dark, 5.0)
			draw_line(facing * 25.0 - side * 5.0, facing * 45.0 - side * 1.0, Color(1.0, 0.88, 0.56, 0.78), 2.2)
		"rifleman":
			draw_line(facing * 7.0 - side * 20.0, facing * 10.0 + side * 20.0, dark, 6.0)
			draw_line(facing * 10.0 - side * 14.0, facing * 11.0 + side * 14.0, brass, 2.5)
			draw_line(facing * 15.0 - side * 8.0, facing * 69.0 - side * 11.0, Color(0.09, 0.045, 0.02, 0.72), 4.0)
			draw_line(facing * 20.0 - side * 8.0, facing * 74.0 - side * 11.0, mark, 1.8)
		"shotgun_brute":
			draw_line(-side * 25.0 + facing * 2.0, side * 25.0 + facing * 2.0, dark, 9.0)
			draw_line(-side * 21.0 + facing * 3.0, side * 21.0 + facing * 3.0, red, 4.0)
			for i in range(4):
				var shell_x := lerpf(-15.0, 15.0, float(i) / 3.0)
				draw_circle(side * shell_x + facing * 9.0, 2.3, brass)
			draw_line(facing * 15.0 - side * 15.0, facing * 61.0 - side * 23.0, Color(0.12, 0.055, 0.026, 0.68), 7.0)
		"hunter":
			var fang_left := PackedVector2Array([
				facing * 16.0 - side * 18.0,
				facing * 29.0 - side * 6.0,
				facing * 1.0 - side * 8.0,
			])
			var fang_right := PackedVector2Array([
				facing * 14.0 + side * 16.0,
				facing * 25.0 + side * 4.0,
				-facing * 3.0 + side * 8.0,
			])
			draw_colored_polygon(fang_left, Color(0.1, 0.025, 0.012, 0.54))
			draw_colored_polygon(fang_right, Color(0.1, 0.025, 0.012, 0.42))
			draw_line(facing * 17.0 - side * 12.0, facing * 50.0 - side * 20.0, Color(1.0, 0.85, 0.56, 0.72), 2.4)
			draw_line(facing * 8.0 - side * 12.0, facing * 8.0 + side * 12.0, red, 3.2)
		"duelist":
			draw_line(facing * 9.0 - side * 25.0, facing * 10.0 + side * 25.0, dark, 7.0)
			draw_line(facing * 13.0 - side * 17.0, facing * 13.0 + side * 17.0, brass, 2.8)
			draw_line(-side * 14.0 + facing * 6.0, side * 14.0 + facing * 6.0, mark, 4.0)
			draw_line(facing * 15.0 - side * 13.0, facing * 56.0 - side * 23.0, Color(0.98, 0.92, 0.66, 0.72), 2.8)

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
