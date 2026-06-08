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
var _enemy_gait_strip_textures: Dictionary = {}
var _enemy_combat_strip_textures: Dictionary = {}
var _enemy_sprite_target_height := 104.0
var _enemy_sprite_slug := ""
const ENEMY_SILHOUETTE_VISUAL_VERSION := "role_silhouette_badge_plate_readability_v8"
const ENEMY_MOVEMENT_DUST_INTEGRATION_VERSION := "enemy_movement_boot_dust_v1"
const ENEMY_HIT_RECOIL_VISUAL_VERSION := "enemy_hit_recoil_shadow_rim_v1"
const ENEMY_GROUNDED_SPRITE_VISUAL_VERSION := "enemy_directional_human_motion_weapon_draw_v1"
const ENEMY_HUMAN_MOTION_VISUAL_VERSION := "enemy_rusher_hunter_gait_weapon_anchor_strip_v21"
const ENEMY_GAIT_STRIP_VISUAL_VERSION := "enemy_rusher_hunter_legible_gait_strip_v7"
const ENEMY_COMBAT_STRIP_VISUAL_VERSION := "enemy_gameplay_scaled_anchored_weapon_strip_v5"
const ENEMY_ANIMATION_STRIP_BUDGET_VERSION := "enemy_animation_strip_texture_budget_v1"
const ENEMY_ANIMATION_TEXTURE_CACHE_VERSION := "enemy_animation_texture_archetype_cache_v1"
const ENEMY_STRIP_OVERLAY_MODE_VERSION := "enemy_strip_backed_clean_overlay_suppression_v1"
const ENEMY_SOURCE_CROP_VISUAL_VERSION := "enemy_turnaround_directional_safe_source_crop_v2"
const ENEMY_LOW_SPEED_GAIT_THRESHOLD_SQ := 16.0
const ENEMY_MOTION_REDRAW_INTERVAL := 1.0 / 8.0
const ENEMY_IDLE_REDRAW_INTERVAL := 1.0 / 4.0
static var _enemy_turnaround_texture_cache: Dictionary = {}
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
	_enemy_sprite_slug = slug
	var cached_textures := _get_or_build_enemy_turnaround_texture_cache(slug)
	_enemy_direction_textures = cached_textures["directions"]
	_enemy_gait_strip_textures = cached_textures["gait"]
	_enemy_combat_strip_textures = cached_textures["combat"]
	_enemy_texture = _enemy_direction_textures.get("forward", null)

func _get_or_build_enemy_turnaround_texture_cache(slug: String) -> Dictionary:
	if _enemy_turnaround_texture_cache.has(slug):
		return _enemy_turnaround_texture_cache[slug]
	var direction_textures := {}
	var gait_strip_textures := {}
	var combat_strip_textures := {}
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
			direction_textures[direction] = texture
		var strip_path := "res://assets/enemies/animation/%s_%s_gait_strip_v001.png" % [slug, direction]
		var strip_texture := _load_png_texture(strip_path)
		if strip_texture != null:
			gait_strip_textures[direction] = strip_texture
		var combat_strip_path := "res://assets/enemies/animation/%s_%s_weapon_strip_v001.png" % [slug, direction]
		var combat_strip_texture := _load_png_texture(combat_strip_path)
		if combat_strip_texture != null:
			combat_strip_textures[direction] = combat_strip_texture
	var cache_entry := {
		"directions": direction_textures,
		"gait": gait_strip_textures,
		"combat": combat_strip_textures,
	}
	_enemy_turnaround_texture_cache[slug] = cache_entry
	return cache_entry

func _draw_enemy_sprite(facing: Vector2 = Vector2.DOWN, pose_offset: Vector2 = Vector2.ZERO, pose_scale: Vector2 = Vector2.ONE, pose_rotation: float = 0.0) -> void:
	var texture := _get_enemy_texture_for_direction(_get_enemy_visual_facing(facing))
	if texture == null:
		return
	var source_rect := _get_enemy_source_rect(texture)
	var strip_texture := _get_enemy_combat_strip_texture()
	if strip_texture == null:
		strip_texture = _get_enemy_gait_strip_texture()
	var using_animation_strip := false
	if strip_texture != null:
		texture = strip_texture
		source_rect = _get_enemy_strip_source_rect(strip_texture, _get_enemy_strip_frame_index())
		using_animation_strip = true
	var visual_size := _get_enemy_sprite_size(texture, source_rect)
	var draw_position := Vector2(-visual_size.x * 0.5, -visual_size.y * 0.5 + 8.0)
	var tint := Color.WHITE if _hit_flash <= 0.0 else Color(1.0, 0.92, 0.82, 1.0)
	var recoil_ratio := _get_hit_recoil_ratio()
	var recoil_offset := _get_hit_recoil_offset() if recoil_ratio > 0.0 else Vector2.ZERO
	var recoil_rotation := _hit_recoil_direction.orthogonal().x * 0.055 * recoil_ratio
	var recoil_scale := Vector2(1.0 + recoil_ratio * 0.045, 1.0 - recoil_ratio * 0.035)
	var body_pose := _get_enemy_body_gait_pose(_get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	draw_set_transform(pose_offset + recoil_offset + body_pose["offset"], pose_rotation + recoil_rotation + body_pose["rotation"], pose_scale * recoil_scale * body_pose["scale"])
	_draw_enemy_role_readability_plate(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	_draw_enemy_running_sprite(texture, draw_position, visual_size, source_rect, tint)
	if not using_animation_strip:
		_draw_enemy_human_motion_overlay(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	_draw_enemy_whole_sprite_role_glints(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	if recoil_ratio > 0.0 or _hit_flash > 0.0:
		_draw_enemy_sprite_material_rim(visual_size, _get_enemy_visual_facing(facing), _get_enemy_kind_for_vfx())
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_draw_hit_recoil_rim(visual_size, recoil_ratio)

func _draw_enemy_running_sprite(texture: Texture2D, draw_position: Vector2, visual_size: Vector2, source_rect: Rect2, tint: Color) -> void:
	draw_texture_rect_region(texture, Rect2(draw_position, visual_size), source_rect, tint)

func _load_png_texture(path: String) -> Texture2D:
	var image := Image.load_from_file(ProjectSettings.globalize_path(path))
	if image == null or image.is_empty():
		return null
	return ImageTexture.create_from_image(image)

func _get_strip_texture_total_pixels(textures: Dictionary) -> int:
	var total := 0
	for texture in textures.values():
		if texture is Texture2D:
			total += int(texture.get_width() * texture.get_height())
	return total

func _get_strip_texture_max_height(textures: Dictionary) -> int:
	var max_height := 0
	for texture in textures.values():
		if texture is Texture2D:
			max_height = maxi(max_height, int(texture.get_height()))
	return max_height

func _get_enemy_gait_strip_texture() -> Texture2D:
	if velocity.length_squared() <= ENEMY_LOW_SPEED_GAIT_THRESHOLD_SQ and _get_enemy_attack_motion_ratio() <= 0.0:
		return null
	return _enemy_gait_strip_textures.get(_enemy_sprite_direction_key, null)

func _get_enemy_combat_strip_texture() -> Texture2D:
	if _get_enemy_attack_motion_ratio() <= 0.02:
		return null
	return _enemy_combat_strip_textures.get(_enemy_sprite_direction_key, null)

func _get_enemy_strip_source_rect(texture: Texture2D, frame_index: int) -> Rect2:
	var frame_width := texture.get_width() / 8.0
	return Rect2(Vector2(frame_width * float(frame_index), 0.0), Vector2(frame_width, texture.get_height()))

func _get_enemy_strip_frame_index() -> int:
	if _get_enemy_attack_motion_ratio() > 0.02:
		return _get_enemy_combat_strip_frame_index()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var clock := _get_enemy_keyframed_gait_clock(movement_ratio, _get_enemy_kind_for_vfx())
	return int(floor(wrapf(clock, 0.0, TAU) / (TAU / 8.0))) % 8

func _get_enemy_combat_strip_frame_index() -> int:
	var attack_ratio := _get_enemy_attack_motion_ratio()
	return clampi(int(floor(clampf(attack_ratio, 0.0, 1.0) * 7.0)), 0, 7)

func _get_enemy_body_gait_pose(facing: Vector2, role: String) -> Dictionary:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var attack_ratio := _get_enemy_attack_motion_ratio()
	var lunge_ratio := _get_enemy_lunge_motion_ratio()
	var idle_ratio: float = clampf(1.0 - movement_ratio - attack_ratio - lunge_ratio, 0.0, 1.0)
	var gait_clock := _get_enemy_keyframed_gait_clock(movement_ratio, role)
	var footfall := absf(sin(gait_clock))
	var sway := cos(gait_clock)
	var role_weight := 1.22 if role == "shotgun_brute" else 0.82 if role == "knife_rusher" else 1.0
	var weapon_brace := attack_ratio * (1.8 if role in ["rifleman", "shotgun_brute"] else 1.0)
	var idle_breath_rate := 1.25 if role == "shotgun_brute" else 2.05 if role == "knife_rusher" else 1.65
	var idle_breath := sin(_walk_time * idle_breath_rate) * idle_ratio
	var idle_sway := cos(_walk_time * idle_breath_rate * 0.63) * idle_ratio
	var body_drop := footfall * movement_ratio * 2.0 * role_weight + lunge_ratio * 1.6 + idle_breath * (0.9 if role == "shotgun_brute" else 0.65)
	var forward_drive := movement_ratio * 1.0 + lunge_ratio * 4.5 + weapon_brace
	var side_settle := sway * movement_ratio * 1.45 / role_weight + idle_sway * (0.45 if role == "shotgun_brute" else 0.62)
	var rotation := clampf(sway * movement_ratio * 0.017 + idle_sway * 0.005 + facing.x * (lunge_ratio * 0.036 + attack_ratio * 0.015), -0.08, 0.08)
	var compression := clampf(footfall * movement_ratio * 0.016 * role_weight + lunge_ratio * 0.025 + attack_ratio * 0.008 + maxf(0.0, idle_breath) * 0.007, 0.0, 0.06)
	return {
		"offset": facing * forward_drive + facing.orthogonal() * side_settle + Vector2(0.0, body_drop),
		"rotation": rotation,
		"scale": Vector2(1.0 + compression * 0.5, 1.0 - compression),
	}

func _get_enemy_keyframed_gait_clock(movement_ratio: float, role: String) -> float:
	var role_rate := 1.18 if role == "knife_rusher" else 0.82 if role == "shotgun_brute" else 1.0
	if movement_ratio <= 0.05:
		return _walk_time * lerpf(1.3, 2.6, movement_ratio) * role_rate
	var frame_count := 8.0
	var raw_clock := _walk_time * lerpf(3.0, 12.0, movement_ratio) * 0.42 * role_rate
	var cycle := wrapf(raw_clock / TAU, 0.0, 1.0)
	var frame_index: float = floor(cycle * frame_count)
	var frame_progress: float = cycle * frame_count - frame_index
	var contact_hold := 0.2 if role in ["rifleman", "shotgun_brute"] else 0.14
	var eased_progress := smoothstep(contact_hold, 1.0 - contact_hold, frame_progress)
	return ((frame_index + eased_progress) / frame_count) * TAU

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

func get_enemy_human_motion_visual_version() -> String:
	return ENEMY_HUMAN_MOTION_VISUAL_VERSION

func get_enemy_human_motion_marker_count() -> int:
	return 216

func get_enemy_gait_strip_visual_version() -> String:
	return ENEMY_GAIT_STRIP_VISUAL_VERSION if _enemy_gait_strip_textures.size() >= 8 else ""

func get_enemy_gait_strip_direction_count() -> int:
	return _enemy_gait_strip_textures.size()

func get_enemy_combat_strip_visual_version() -> String:
	return ENEMY_COMBAT_STRIP_VISUAL_VERSION if _enemy_combat_strip_textures.size() >= 8 else ""

func get_enemy_combat_strip_direction_count() -> int:
	return _enemy_combat_strip_textures.size()

func get_enemy_animation_strip_budget_version() -> String:
	return ENEMY_ANIMATION_STRIP_BUDGET_VERSION

func get_enemy_animation_texture_cache_version() -> String:
	return ENEMY_ANIMATION_TEXTURE_CACHE_VERSION

func get_enemy_animation_texture_cache_archetype_count() -> int:
	return _enemy_turnaround_texture_cache.size()

func get_enemy_strip_overlay_mode_version() -> String:
	return ENEMY_STRIP_OVERLAY_MODE_VERSION

func get_enemy_animation_strip_total_pixels() -> int:
	return _get_strip_texture_total_pixels(_enemy_gait_strip_textures) + _get_strip_texture_total_pixels(_enemy_combat_strip_textures)

func get_enemy_animation_strip_max_height() -> int:
	return maxi(_get_strip_texture_max_height(_enemy_gait_strip_textures), _get_strip_texture_max_height(_enemy_combat_strip_textures))

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
	if velocity.length_squared() > ENEMY_LOW_SPEED_GAIT_THRESHOLD_SQ:
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
	var has_active_visual := velocity.length_squared() > ENEMY_LOW_SPEED_GAIT_THRESHOLD_SQ or _hit_flash > 0.0 or _hit_recoil_timer > 0.0 or slow_timer > 0.0 or has_attack_tell_active or has_recover_tell_active
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

func _draw_enemy_human_motion_overlay(visual_size: Vector2, facing: Vector2, role: String) -> void:
	if facing.length_squared() <= 0.001:
		facing = Vector2.DOWN
	facing = facing.normalized()
	var side := facing.orthogonal()
	var movement_ratio: float = clampf(velocity.length() / maxf(speed, 1.0), 0.0, 1.0)
	var attack_ratio := _get_enemy_attack_motion_ratio()
	var recoil_ratio := _get_hit_recoil_ratio()
	var lunge_ratio := _get_enemy_lunge_motion_ratio()
	var gait_clock := _get_enemy_keyframed_gait_clock(movement_ratio, role)
	var step := sin(gait_clock)
	var counter_step := cos(gait_clock)
	var gait_frame := int(floor(wrapf(gait_clock, 0.0, TAU) / (TAU * 0.25))) % 4
	var left_planted := gait_frame == 0 or gait_frame == 3
	var right_planted := gait_frame == 1 or gait_frame == 2
	var push_power := maxf(1.0 if gait_frame == 1 or gait_frame == 3 else 0.35, lunge_ratio)
	var reach_power := maxf(1.0 if gait_frame == 0 or gait_frame == 2 else 0.45, lunge_ratio * 0.85)
	var shoulder_y := clampf(-visual_size.y * 0.09, -17.0, -7.0)
	var hip_y := clampf(visual_size.y * 0.08, 5.0, 15.0)
	var boot_y := clampf(visual_size.y * 0.38, 30.0, 52.0)
	var shoulder_half := clampf(visual_size.x * 0.18, 12.0, 23.0)
	var hip_half := clampf(visual_size.x * 0.13, 9.0, 18.0)
	var stride := step * lerpf(2.0, 11.0, movement_ratio + attack_ratio * 0.25)
	var lift := absf(step) * 2.7 * movement_ratio
	var accent := _get_enemy_material_accent(role)
	var coat := accent.darkened(0.45)
	coat.a = 0.34 + movement_ratio * 0.12 + attack_ratio * 0.1
	var leather := Color(0.032, 0.016, 0.008, 0.56)
	var brass := Color(0.98, 0.7, 0.24, 0.34 + attack_ratio * 0.28 + recoil_ratio * 0.14)
	var bone := Color(0.94, 0.86, 0.62, 0.28 + attack_ratio * 0.24)
	var role_bulk := 1.2 if role == "shotgun_brute" else 0.82 if role == "knife_rusher" else 1.0
	var attack_hold := 1.0 if attack_ratio > 0.55 else attack_ratio * 1.8
	var weapon_hold := maxf(attack_hold, lunge_ratio * 0.75)
	var attack_brace := -facing * attack_hold * (5.0 if role in ["rifleman", "shotgun_brute"] else 2.0)
	var torso_lean := facing * (movement_ratio * (3.0 + push_power * 1.1) + weapon_hold * 3.4 + lunge_ratio * 7.0) + attack_brace
	var shoulder_center := Vector2(0.0, shoulder_y) + torso_lean + side * counter_step * movement_ratio * (1.5 + reach_power * 0.7) - side * weapon_hold * 2.6
	var hip_center := Vector2(0.0, hip_y) + facing * movement_ratio * 1.0 - side * counter_step * movement_ratio * 1.5
	if lunge_ratio > 0.0:
		hip_center -= facing * lunge_ratio * 3.5
		shoulder_center += facing * lunge_ratio * 4.5
	var neck_center := shoulder_center - facing * 5.0 + Vector2(0.0, -4.0)
	var coat_tail := hip_center - facing * (15.0 + movement_ratio * 5.0) - torso_lean * 0.25
	var torso_glow := accent.lightened(0.18)
	torso_glow.a = 0.18 + movement_ratio * 0.1 + attack_ratio * 0.13
	draw_line(hip_center + Vector2(2.0, 3.0), shoulder_center + Vector2(2.0, 3.0), Color(0.018, 0.008, 0.004, 0.28), 8.0 * role_bulk)
	draw_line(hip_center, shoulder_center, torso_glow, 4.8 * role_bulk)
	draw_line(shoulder_center - side * shoulder_half * 0.9, shoulder_center + side * shoulder_half * 0.9, Color(0.08, 0.035, 0.016, 0.36 + attack_ratio * 0.12), 2.5 * role_bulk)
	draw_line(hip_center - side * hip_half * 1.05, hip_center + side * hip_half * 1.05, brass, 1.8 * role_bulk)
	draw_line(hip_center - side * hip_half * 0.52, coat_tail - side * (5.0 + movement_ratio * 3.0), Color(0.025, 0.012, 0.006, 0.28 + movement_ratio * 0.16), 3.0)
	draw_line(hip_center + side * hip_half * 0.52, coat_tail + side * (5.0 + movement_ratio * 3.0), Color(0.025, 0.012, 0.006, 0.22 + movement_ratio * 0.13), 3.0)
	draw_circle(neck_center, 2.0 + attack_ratio * 0.8, Color(accent.r, accent.g, accent.b, 0.18 + attack_ratio * 0.14))

	for i in range(2):
		var side_sign := -1.0 if i == 0 else 1.0
		var phase := step * side_sign
		var planted := left_planted if i == 0 else right_planted
		var plant_power := maxf(1.0 if planted else 0.35, lunge_ratio * 0.95)
		var hip := hip_center + side * hip_half * side_sign
		var lunge_stretch := lunge_ratio * 12.0 * side_sign
		var knee := hip + facing * (9.0 + stride * side_sign * 0.22 - plant_power * 1.8 + lunge_stretch * 0.24) + side * side_sign * (2.0 + (1.0 - plant_power) * 3.0)
		var boot := Vector2(0.0, boot_y + lift * (1.0 if phase > 0.0 else 0.35) - plant_power * movement_ratio * 2.0) + side * (hip_half * side_sign + stride * side_sign * (0.72 + plant_power * 0.28)) + facing * lunge_stretch
		draw_line(hip, knee, coat, 4.6)
		draw_line(knee, boot, leather, 5.0)
		draw_line(boot - side * side_sign * 2.0, boot + side * side_sign * 7.0 + facing * 2.5, Color(0.01, 0.007, 0.005, 0.64), 4.0)
		if movement_ratio > 0.08:
			draw_set_transform(boot + facing * 2.0, facing.angle(), Vector2(7.0 + plant_power * 7.0, 1.8 + plant_power * 1.5))
			draw_circle(Vector2.ZERO, 1.0, Color(0.025, 0.012, 0.006, 0.14 + plant_power * movement_ratio * 0.18))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if movement_ratio > 0.14:
			draw_line(boot - facing * 3.0, boot - facing * (9.0 + absf(stride) * 0.35), Color(0.72, 0.4, 0.15, 0.13 + movement_ratio * 0.14), 1.8)

	var left_shoulder := shoulder_center - side * shoulder_half
	var right_shoulder := shoulder_center + side * shoulder_half
	var arm_swing := step * lerpf(1.0, 9.0, movement_ratio) + (reach_power - 0.5) * movement_ratio * 2.6
	var weapon_side := -1.0
	var weapon_shoulder := left_shoulder
	var off_shoulder := right_shoulder
	if role == "shotgun_brute":
		weapon_side = 1.0
		weapon_shoulder = right_shoulder
		off_shoulder = left_shoulder
	var off_hand := off_shoulder + side * (-weapon_side) * (4.0 - arm_swing * 0.2) + facing * (10.0 - arm_swing * 0.22)
	var weapon_hand := weapon_shoulder + side * weapon_side * (3.0 + arm_swing * 0.24) + facing * (9.0 + weapon_hold * 18.0)
	weapon_hand -= side * weapon_side * weapon_hold * 8.0
	if weapon_hold > 0.0:
		off_hand += facing * (5.0 + weapon_hold * 4.0) - side * weapon_side * 3.0
		weapon_hand += facing * (4.0 + weapon_hold * 5.0 + lunge_ratio * 4.0)
	if role == "rifleman":
		off_hand = weapon_hand + facing * (18.0 + weapon_hold * 8.0) - side * weapon_side * (6.0 + weapon_hold * 2.0)
	elif role == "shotgun_brute":
		off_hand = weapon_hand + facing * (15.0 + weapon_hold * 7.0) - side * weapon_side * (10.0 + weapon_hold * 4.0)
	draw_line(off_shoulder, off_hand, Color(0.1, 0.055, 0.03, 0.44), 4.8)
	draw_line(off_shoulder + facing * 2.0, off_hand, coat.lightened(0.28), 1.8)
	draw_line(weapon_shoulder, weapon_hand, Color(0.095, 0.045, 0.022, 0.58 + attack_ratio * 0.16), 5.2)
	draw_line(weapon_shoulder + facing * 3.0, weapon_hand, brass, 1.8)
	draw_circle(weapon_hand, 2.2 + attack_ratio * 1.2, brass)
	_draw_enemy_drawn_weapon_pose(weapon_hand, off_hand, facing, side, role, weapon_hold, brass, bone)

func _get_enemy_attack_motion_ratio() -> float:
	var ratio := 0.0
	if has_method("get_attack_tell_strength"):
		ratio = maxf(ratio, clampf(float(call("get_attack_tell_strength")), 0.0, 1.0))
	if has_method("get_recover_tell_strength"):
		ratio = maxf(ratio, 1.0 - clampf(float(call("get_recover_tell_strength")), 0.0, 1.0))
	if has_method("has_swarm_warning_tell") and bool(call("has_swarm_warning_tell")):
		ratio = maxf(ratio, 0.85)
	if _get_enemy_kind_for_vfx() == "knife_rusher" and velocity.length_squared() > 1200.0:
		ratio = maxf(ratio, 0.45)
	if _hit_recoil_timer > 0.0:
		ratio = maxf(ratio, _get_hit_recoil_ratio() * 0.5)
	return clampf(ratio, 0.0, 1.0)

func _get_enemy_lunge_motion_ratio() -> float:
	if speed <= 0.0:
		return 0.0
	var velocity_ratio := velocity.length() / maxf(speed, 1.0)
	var role := _get_enemy_kind_for_vfx()
	if role == "duelist" and velocity_ratio > 1.45:
		return clampf((velocity_ratio - 1.45) / 1.8, 0.0, 1.0)
	if role == "hunter" and velocity_ratio > 1.25:
		return clampf((velocity_ratio - 1.25) / 1.7, 0.0, 1.0)
	if role == "knife_rusher" and velocity_ratio > 1.05:
		return clampf((velocity_ratio - 1.05) / 1.15, 0.0, 0.7)
	return 0.0

func _draw_enemy_drawn_weapon_pose(hand: Vector2, off_hand: Vector2, facing: Vector2, side: Vector2, role: String, attack_ratio: float, brass: Color, bone: Color) -> void:
	var draw := clampf(attack_ratio, 0.0, 1.0)
	match role:
		"rifleman":
			var muzzle := hand + facing * (44.0 + draw * 18.0) - side * (5.0 + draw * 4.0)
			var stock := hand - facing * (12.0 + draw * 4.0) + side * 6.0
			draw_line(stock + Vector2(2.0, 3.0), hand + Vector2(2.0, 3.0), Color(0.025, 0.012, 0.006, 0.32), 7.0)
			draw_line(stock, hand, Color(0.18, 0.095, 0.045, 0.78), 5.2)
			draw_line(hand + Vector2(2.0, 3.0), muzzle + Vector2(2.0, 3.0), Color(0.035, 0.018, 0.008, 0.35), 6.0)
			draw_line(hand, muzzle, Color(0.1, 0.055, 0.028, 0.74), 4.6)
			draw_line(hand + facing * 6.0, muzzle, brass, 1.8)
			draw_line(off_hand - side * 2.0, muzzle - facing * (10.0 + draw * 4.0), Color(0.94, 0.82, 0.56, 0.34), 2.0)
			draw_circle(off_hand, 2.2, bone)
		"shotgun_brute":
			var muzzle := hand + facing * (42.0 + draw * 14.0) - side * (10.0 + draw * 8.0)
			var stock := hand - facing * (11.0 + draw * 4.0) + side * 8.0
			draw_line(stock + Vector2(2.0, 4.0), hand + Vector2(2.0, 4.0), Color(0.025, 0.012, 0.006, 0.36), 10.0)
			draw_line(stock, hand, Color(0.19, 0.088, 0.036, 0.82), 7.8)
			draw_line(hand + Vector2(2.0, 4.0), muzzle + Vector2(2.0, 4.0), Color(0.035, 0.018, 0.008, 0.36), 9.0)
			draw_line(hand, muzzle, Color(0.11, 0.052, 0.024, 0.8), 7.2)
			draw_line(hand + facing * 7.0, muzzle, brass, 2.5)
			draw_line(off_hand, muzzle - facing * (13.0 + draw * 4.0), Color(0.94, 0.82, 0.56, 0.34), 2.6)
			draw_circle(off_hand, 2.8, bone)
		"knife_rusher":
			var tip := hand + facing * (21.0 + draw * 19.0) - side * (2.0 + draw * 4.0)
			draw_line(hand + Vector2(1.5, 2.0), tip + Vector2(1.5, 2.0), Color(0.025, 0.012, 0.006, 0.34), 4.8)
			draw_line(hand, tip, bone.lightened(0.08), 2.6)
			draw_line(off_hand, off_hand + facing * (8.0 + draw * 6.0) + side * 6.0, Color(0.16, 0.08, 0.04, 0.4), 3.2)
		"hunter":
			var tip := hand + facing * (28.0 + draw * 24.0) - side * (7.0 + draw * 6.0)
			draw_line(hand + Vector2(1.5, 2.5), tip + Vector2(1.5, 2.5), Color(0.025, 0.012, 0.006, 0.36), 5.6)
			draw_line(hand, tip, bone.lightened(0.05), 3.0)
			draw_line(off_hand, off_hand + facing * (12.0 + draw * 7.0) + side * 4.0, Color(0.14, 0.07, 0.035, 0.42), 3.6)
		"duelist":
			var tip := hand + facing * (34.0 + draw * 32.0) - side * (10.0 + draw * 9.0)
			draw_line(off_hand, hand - facing * 8.0 + side * 5.0, Color(0.14, 0.07, 0.035, 0.42), 3.6)
			draw_line(hand - side * 6.0, hand + side * 6.0, brass, 2.0)
			draw_line(hand + Vector2(2.0, 3.0), tip + Vector2(2.0, 3.0), Color(0.025, 0.012, 0.006, 0.34), 6.0)
			draw_line(hand, tip, bone.lightened(0.1), 3.0)
			if draw > 0.0:
				draw_arc(Vector2.ZERO, 36.0 + draw * 16.0, facing.angle() - 0.6, facing.angle() + 0.6, 16, Color(brass.r, brass.g, brass.b, 0.18 + draw * 0.24), 2.0)
		_:
			var muzzle := hand + facing * (24.0 + draw * 16.0)
			draw_line(hand, muzzle, brass, 2.0)

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
