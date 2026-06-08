extends SceneTree

const FRAME_COUNT := 8
const PLAYER_DIRECTIONS := [
	"forward",
	"back",
	"left",
	"right",
	"angled",
	"forward_left",
	"forward_right",
	"back_left",
	"back_right",
	"top_left",
	"top_right",
	"bottom_left",
	"bottom_right",
]
const ENEMY_DIRECTIONS := [
	"forward",
	"back",
	"left",
	"right",
	"top_left",
	"top_right",
	"bottom_left",
	"bottom_right",
]
const ENEMY_SLUGS := [
	"enemy_knife_rusher_male",
	"enemy_rifleman_male",
	"enemy_shotgun_brute_male",
	"enemy_hunter_male",
	"enemy_duelist_male",
]
const PLAYER_FRAME_SIZE := Vector2i(192, 144)
const ENEMY_FRAME_SIZE := Vector2i(176, 136)
const BRUTE_FRAME_SIZE := Vector2i(196, 148)

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets/characters/player_animation"))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets/enemies/animation"))
	for direction in PLAYER_DIRECTIONS:
		_write_gait_strip(
			"res://assets/characters/player_turnaround/player_cowgirl_%s_3d_topdown_v001.png" % direction,
			"res://assets/characters/player_animation/player_cowgirl_%s_gait_strip_v001.png" % direction,
			"player",
			direction
		)
		_write_combat_strip(
			"res://assets/characters/player_turnaround/player_cowgirl_%s_3d_topdown_v001.png" % direction,
			"res://assets/characters/player_animation/player_cowgirl_%s_saber_strip_v001.png" % direction,
			"player_saber",
			direction
		)
	for slug in ENEMY_SLUGS:
		for direction in ENEMY_DIRECTIONS:
			_write_gait_strip(
				"res://assets/enemies/turnaround/%s_%s_3d_topdown_v001.png" % [slug, direction],
				"res://assets/enemies/animation/%s_%s_gait_strip_v001.png" % [slug, direction],
				slug,
				direction
			)
			_write_combat_strip(
				"res://assets/enemies/turnaround/%s_%s_3d_topdown_v001.png" % [slug, direction],
				"res://assets/enemies/animation/%s_%s_weapon_strip_v001.png" % [slug, direction],
				slug,
				direction
			)
	quit()

func _write_gait_strip(source_path: String, output_path: String, motion_profile: String, direction: String) -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path(source_path))
	if image == null or image.is_empty():
		push_error("Could not load source image: %s" % source_path)
		return
	image.convert(Image.FORMAT_RGBA8)
	var crop := _get_alpha_crop(image)
	var frame_size := _get_output_frame_size(motion_profile)
	var strip := Image.create(frame_size.x * FRAME_COUNT, frame_size.y, false, Image.FORMAT_RGBA8)
	strip.fill(Color(0, 0, 0, 0))
	for frame_index in range(FRAME_COUNT):
		var full_frame := _make_gait_frame(image, crop, frame_index, motion_profile, direction)
		var frame := _fit_frame_to_gameplay_size(full_frame, frame_size)
		strip.blit_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(frame_index * frame_size.x, 0))
	var error := strip.save_png(ProjectSettings.globalize_path(output_path))
	if error != OK:
		push_error("Could not write gait strip: %s error=%d" % [output_path, error])

func _write_combat_strip(source_path: String, output_path: String, motion_profile: String, direction: String) -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path(source_path))
	if image == null or image.is_empty():
		push_error("Could not load source image: %s" % source_path)
		return
	image.convert(Image.FORMAT_RGBA8)
	var crop := _get_alpha_crop(image)
	var frame_size := _get_output_frame_size(motion_profile)
	var strip := Image.create(frame_size.x * FRAME_COUNT, frame_size.y, false, Image.FORMAT_RGBA8)
	strip.fill(Color(0, 0, 0, 0))
	for frame_index in range(FRAME_COUNT):
		var full_frame := _make_combat_frame(image, crop, frame_index, motion_profile, direction)
		var frame := _fit_frame_to_gameplay_size(full_frame, frame_size)
		strip.blit_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(frame_index * frame_size.x, 0))
	var error := strip.save_png(ProjectSettings.globalize_path(output_path))
	if error != OK:
		push_error("Could not write combat strip: %s error=%d" % [output_path, error])

func _get_alpha_crop(image: Image) -> Rect2i:
	var min_x := image.get_width()
	var min_y := image.get_height()
	var max_x := 0
	var max_y := 0
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a <= 0.02:
				continue
			min_x = mini(min_x, x)
			min_y = mini(min_y, y)
			max_x = maxi(max_x, x)
			max_y = maxi(max_y, y)
	if min_x > max_x or min_y > max_y:
		return Rect2i(Vector2i.ZERO, image.get_size())
	return Rect2i(Vector2i(min_x, min_y), Vector2i(max_x - min_x + 1, max_y - min_y + 1)).grow(8)

func _get_output_frame_size(motion_profile: String) -> Vector2i:
	if motion_profile.find("player") >= 0:
		return PLAYER_FRAME_SIZE
	if motion_profile.find("shotgun_brute") >= 0:
		return BRUTE_FRAME_SIZE
	return ENEMY_FRAME_SIZE

func _fit_frame_to_gameplay_size(source: Image, frame_size: Vector2i) -> Image:
	var crop := _get_alpha_crop(source).grow(10)
	crop.position.x = clampi(crop.position.x, 0, source.get_width() - 1)
	crop.position.y = clampi(crop.position.y, 0, source.get_height() - 1)
	crop.size.x = mini(crop.size.x, source.get_width() - crop.position.x)
	crop.size.y = mini(crop.size.y, source.get_height() - crop.position.y)
	var cropped := Image.create(crop.size.x, crop.size.y, false, Image.FORMAT_RGBA8)
	cropped.fill(Color(0, 0, 0, 0))
	cropped.blit_rect(source, crop, Vector2i.ZERO)
	var fit_scale := minf(float(frame_size.x - 10) / maxf(1.0, float(crop.size.x)), float(frame_size.y - 10) / maxf(1.0, float(crop.size.y)))
	var scaled_size := Vector2i(maxi(1, int(round(float(crop.size.x) * fit_scale))), maxi(1, int(round(float(crop.size.y) * fit_scale))))
	cropped.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_LANCZOS)
	var output := Image.create(frame_size.x, frame_size.y, false, Image.FORMAT_RGBA8)
	output.fill(Color(0, 0, 0, 0))
	var draw_position := Vector2i((frame_size.x - scaled_size.x) / 2, (frame_size.y - scaled_size.y) / 2)
	output.blit_rect(cropped, Rect2i(Vector2i.ZERO, scaled_size), draw_position)
	return output

func _make_gait_frame(source: Image, crop: Rect2i, frame_index: int, motion_profile: String, direction: String) -> Image:
	var phase := float(frame_index) / float(FRAME_COUNT)
	var wave := sin(phase * TAU)
	var plant := absf(wave)
	var lateral := cos(phase * TAU)
	var knife_rusher := motion_profile.find("knife_rusher") >= 0
	var hunter := motion_profile.find("hunter") >= 0
	var light_footed := knife_rusher or hunter
	var heavy := motion_profile.find("shotgun_brute") >= 0
	var rifleman := motion_profile.find("rifleman") >= 0
	var lift_scale := 1.12 if knife_rusher else 0.72 if hunter else 0.48 if heavy else 0.58 if rifleman else 0.78
	var squash := 0.032 if knife_rusher else 0.018 if hunter else 0.018 if heavy else 0.012 if rifleman else 0.02
	var width_push := 0.024 if knife_rusher else 0.012 if hunter else 0.014 if heavy else 0.006 if rifleman else 0.012
	var stride_width := 6.2 if knife_rusher else 3.6 if hunter else 2.2 if heavy else 2.6 if rifleman else 3.6
	var scale_x := 1.0 + plant * width_push
	var scale_y := 1.0 - plant * squash
	var offset_x := int(round(lateral * stride_width))
	var offset_y := int(round(plant * (4.0 if light_footed else 2.2 if heavy else 3.0) * lift_scale))
	var source_crop := Image.create(crop.size.x, crop.size.y, false, Image.FORMAT_RGBA8)
	source_crop.fill(Color(0, 0, 0, 0))
	source_crop.blit_rect(source, crop, Vector2i.ZERO)
	var scaled_size := Vector2i(maxi(1, int(round(float(crop.size.x) * scale_x))), maxi(1, int(round(float(crop.size.y) * scale_y))))
	source_crop.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_LANCZOS)
	var frame := Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
	frame.fill(Color(0, 0, 0, 0))
	var center := crop.position + crop.size / 2
	var draw_position := Vector2i(center.x - scaled_size.x / 2 + offset_x, center.y - scaled_size.y / 2 + offset_y)
	frame.blit_rect(source_crop, Rect2i(Vector2i.ZERO, scaled_size), draw_position)
	var body_offset := draw_position - crop.position
	_draw_baked_gait_limbs(frame, crop, frame_index, motion_profile, direction, body_offset)
	_draw_baked_weapon(frame, crop, frame_index, motion_profile, direction, body_offset, true)
	return frame

func _draw_baked_gait_limbs(frame: Image, crop: Rect2i, frame_index: int, motion_profile: String, direction: String, body_offset: Vector2i) -> void:
	var phase := float(frame_index) / float(FRAME_COUNT)
	var step := sin(phase * TAU)
	var counter_step := sin(phase * TAU + PI)
	var contact := absf(cos(phase * TAU))
	var vectors := _get_direction_vectors(direction)
	var facing := vectors["facing"] as Vector2
	var side := vectors["side"] as Vector2
	var center := Vector2(crop.position + crop.size / 2 + body_offset)
	var knife_rusher := motion_profile.find("knife_rusher") >= 0
	var hunter := motion_profile.find("hunter") >= 0
	var light_footed := knife_rusher or hunter
	var heavy := motion_profile.find("shotgun_brute") >= 0
	var rifleman := motion_profile.find("rifleman") >= 0
	var stride := 17.0 if knife_rusher else 12.5 if hunter else 7.5 if heavy else 9.5 if rifleman else 12.0
	var side_spread := maxf(9.0, float(crop.size.x) * (0.22 if heavy else 0.18 if rifleman else 0.12 if knife_rusher else 0.16 if hunter else 0.15))
	var foot_base := center + facing * float(crop.size.y) * 0.26
	var hip_base := center + facing * float(crop.size.y) * 0.1
	var shoulder_base := center - facing * float(crop.size.y) * 0.08
	var arm_swing_scale := 1.35 if knife_rusher else 0.64 if hunter else 0.38 if heavy else 0.22 if rifleman else 0.72
	var knee_bend := 0.42 if knife_rusher else 0.3 if hunter else 0.24 if heavy else 0.28 if rifleman else 0.34
	var boot_contact_length := 3.5 if knife_rusher else 5.5 if hunter else 7.0 if heavy else 6.0 if rifleman else 4.0
	var left_hip := hip_base - side * side_spread * 0.62
	var right_hip := hip_base + side * side_spread * 0.62
	var left_foot := foot_base - side * side_spread + facing * (step * stride)
	var right_foot := foot_base + side * side_spread + facing * (counter_step * stride)
	var left_knee := left_hip + facing * (12.0 + step * stride * knee_bend) - side * (2.0 + contact * 2.2)
	var right_knee := right_hip + facing * (12.0 + counter_step * stride * knee_bend) + side * (2.0 + (1.0 - contact) * 2.2)
	var left_hand := shoulder_base + side * float(crop.size.x) * 0.2 + facing * (counter_step * stride * 0.58 * arm_swing_scale)
	var right_hand := shoulder_base - side * float(crop.size.x) * 0.2 + facing * (step * stride * 0.58 * arm_swing_scale)
	if rifleman:
		left_hand = shoulder_base + side * float(crop.size.x) * 0.14 + facing * (5.0 + contact * 2.0)
		right_hand = shoulder_base - side * float(crop.size.x) * 0.18 + facing * (7.0 + (1.0 - contact) * 2.0)
	elif heavy:
		left_hand += side * 2.0 + facing * 3.0
		right_hand -= side * 2.0 - facing * 3.0
	elif knife_rusher:
		left_hand += facing * (5.0 + maxf(0.0, counter_step) * 7.0) - side * 2.0
		right_hand += facing * (8.0 + maxf(0.0, step) * 9.0) + side * 2.0
	elif hunter:
		left_hand += facing * 2.0 - side * 4.0
		right_hand += facing * 3.0 + side * 4.0
	var boot := Color(0.055, 0.028, 0.018, 0.95)
	var leather := Color(0.18, 0.1, 0.055, 0.9)
	var denim := Color(0.18, 0.32, 0.46, 0.85) if motion_profile.find("player") >= 0 else Color(0.16, 0.11, 0.075, 0.82)
	var brass := Color(0.86, 0.58, 0.2, 0.9)
	var leg_shadow := Color(0.028, 0.014, 0.008, 0.42)
	var boot_contact := Color(0.02, 0.01, 0.006, 0.58)
	var foot_radius := 5 if heavy else 4
	_draw_image_line(frame, left_foot + Vector2(2.0, 3.0), left_foot + facing * (9.0 + contact * boot_contact_length) + Vector2(2.0, 3.0), boot_contact, foot_radius + 2)
	_draw_image_line(frame, right_foot + Vector2(2.0, 3.0), right_foot + facing * (9.0 + (1.0 - contact) * boot_contact_length) + Vector2(2.0, 3.0), boot_contact, foot_radius + 2)
	_draw_image_line(frame, left_hip + Vector2(1.0, 2.0), left_knee + Vector2(1.0, 2.0), leg_shadow, 5 if heavy else 4)
	_draw_image_line(frame, right_hip + Vector2(1.0, 2.0), right_knee + Vector2(1.0, 2.0), leg_shadow, 5 if heavy else 4)
	_draw_image_line(frame, left_hip, left_knee, denim, 4 if heavy else 3)
	_draw_image_line(frame, right_hip, right_knee, denim, 4 if heavy else 3)
	_draw_image_line(frame, left_knee, left_foot, leather, 5 if heavy else 4)
	_draw_image_line(frame, right_knee, right_foot, leather, 5 if heavy else 4)
	_draw_image_line(frame, left_foot - facing * 5.0, left_foot + facing * (7.0 + contact * 3.0), boot, foot_radius)
	_draw_image_line(frame, right_foot - facing * 5.0, right_foot + facing * (7.0 + (1.0 - contact) * 3.0), boot, foot_radius)
	_draw_image_line(frame, left_foot - side * 3.0, left_foot + side * 5.0 + facing * 4.0, Color(0.9, 0.56, 0.18, 0.26 + contact * 0.16), 2)
	_draw_image_line(frame, right_foot + side * 3.0, right_foot - side * 5.0 + facing * 4.0, Color(0.9, 0.56, 0.18, 0.22 + (1.0 - contact) * 0.16), 2)
	_draw_image_line(frame, shoulder_base - side * float(crop.size.x) * 0.12, left_hand, denim, 4)
	_draw_image_line(frame, shoulder_base + side * float(crop.size.x) * 0.12, right_hand, leather, 4)
	_draw_image_disc(frame, Vector2i(roundi(left_hand.x), roundi(left_hand.y)), 3, brass)
	_draw_image_disc(frame, Vector2i(roundi(right_hand.x), roundi(right_hand.y)), 3, brass)

func _draw_baked_weapon(frame: Image, crop: Rect2i, frame_index: int, motion_profile: String, direction: String, body_offset: Vector2i, carried_pose: bool) -> void:
	var phase := float(frame_index) / float(FRAME_COUNT - 1)
	var draw := 0.26 + sin(float(frame_index) / float(FRAME_COUNT) * TAU) * 0.04 if carried_pose else smoothstep(0.12, 0.72, phase)
	var center := Vector2(crop.position + crop.size / 2 + body_offset)
	var vectors := _get_direction_vectors(direction)
	var facing := vectors["facing"] as Vector2
	var side := vectors["side"] as Vector2
	var hand := center - side * float(crop.size.x) * 0.13 - facing * float(crop.size.y) * 0.05 + facing * (draw * 18.0)
	var brass := Color(0.98, 0.72, 0.28, 0.95)
	var bone := Color(0.94, 0.88, 0.68, 0.95)
	var iron := Color(0.08, 0.048, 0.032, 0.92)
	var profile := "player_saber" if motion_profile == "player" else motion_profile
	var reach := _get_role_weapon_reach(profile, carried_pose)
	var weapon_width := _get_role_weapon_width(profile, carried_pose)
	var accent_width := maxi(3, int(round(float(weapon_width) * 0.48)))
	var support_hand := hand + side * float(crop.size.x) * 0.2 - facing * (4.0 if carried_pose else 0.0)
	if carried_pose and profile.find("player_saber") >= 0:
		hand = center - side * float(crop.size.x) * 0.12 + facing * (5.0 + draw * 12.0) - facing * float(crop.size.y) * 0.02
		support_hand = center + side * float(crop.size.x) * 0.12 + facing * (6.0 + draw * 6.0) - facing * float(crop.size.y) * 0.04
	elif carried_pose and profile.find("rifleman") >= 0:
		hand = center - side * float(crop.size.x) * 0.17 - facing * float(crop.size.y) * 0.03 + facing * (8.0 + draw * 12.0)
		support_hand = hand + facing * 24.0 - side * float(crop.size.x) * 0.08
	elif carried_pose and profile.find("shotgun_brute") >= 0:
		hand = center + side * float(crop.size.x) * 0.1 - facing * float(crop.size.y) * 0.02 + facing * (7.0 + draw * 10.0)
		support_hand = hand + facing * 18.0 - side * float(crop.size.x) * 0.14
	elif carried_pose and profile.find("knife_rusher") >= 0:
		hand = center - side * float(crop.size.x) * 0.08 - facing * float(crop.size.y) * 0.02 + facing * (13.0 + draw * 19.0)
		support_hand = center + side * float(crop.size.x) * 0.1 + facing * (7.0 + draw * 7.0)
	elif carried_pose and profile.find("hunter") >= 0:
		hand = center - side * float(crop.size.x) * 0.16 - facing * float(crop.size.y) * 0.01 + facing * (7.0 + draw * 12.0)
		support_hand = center + side * float(crop.size.x) * 0.15 - facing * 2.0
	if profile.find("player_saber") >= 0:
		var ready_tuck := 1.0 if carried_pose else 0.0
		var tip := hand + facing * ((42.0 + draw * 54.0) * reach) - side * ((10.0 + draw * 14.0 - ready_tuck * 5.0) * reach)
		var guard_hand := hand - facing * (7.0 - ready_tuck * 3.0) + side * (7.0 + ready_tuck * 3.0)
		var holster := center - side * float(crop.size.x) * 0.18 + facing * float(crop.size.y) * 0.18
		if carried_pose:
			_draw_image_line(frame, holster + Vector2(2.0, 3.0), hand + Vector2(2.0, 3.0), Color(0.035, 0.018, 0.01, 0.34), 6)
			_draw_image_line(frame, holster, hand, Color(0.18, 0.09, 0.045, 0.86), 4)
			_draw_image_disc(frame, Vector2i(roundi(holster.x), roundi(holster.y)), 4, Color(0.98, 0.72, 0.28, 0.5))
		_draw_image_line(frame, support_hand, guard_hand, Color(0.16, 0.09, 0.05, 0.74), 4)
		_draw_image_line(frame, hand + Vector2(2.0, 3.0), tip + Vector2(2.0, 3.0), Color(0.03, 0.014, 0.008, 0.45), weapon_width + 3)
		_draw_image_line(frame, hand, tip, bone, weapon_width)
		_draw_image_line(frame, hand + facing * 10.0, tip, Color(1.0, 0.96, 0.78, 0.68), maxi(2, weapon_width - 2))
		_draw_image_line(frame, hand - side * 9.0, hand + side * 9.0, brass, 3)
		if carried_pose:
			_draw_image_line(frame, support_hand - side * 6.0, support_hand + facing * 10.0 + side * 5.0, Color(brass.r, brass.g, brass.b, 0.42), 3)
			_draw_image_disc(frame, Vector2i(roundi(hand.x), roundi(hand.y)), 4, brass)
			_draw_image_disc(frame, Vector2i(roundi(guard_hand.x), roundi(guard_hand.y)), 3, Color(brass.r, brass.g, brass.b, 0.74))
		_draw_image_disc(frame, Vector2i(roundi(tip.x), roundi(tip.y)), 3, Color(1.0, 0.96, 0.78, 0.92))
	elif profile.find("rifleman") >= 0:
		var stock := hand - facing * 18.0 + side * 8.0
		var muzzle := hand + facing * ((70.0 + draw * 18.0) * reach) - side * 8.0
		_draw_image_line(frame, stock + Vector2(2.0, 3.0), muzzle + Vector2(2.0, 3.0), Color(0.02, 0.012, 0.008, 0.55), weapon_width + 3)
		_draw_image_line(frame, stock, muzzle, iron, weapon_width)
		_draw_image_line(frame, hand + facing * 5.0, muzzle, brass, accent_width)
		_draw_image_line(frame, support_hand, hand + facing * 26.0 - side * 3.0, Color(0.2, 0.11, 0.06, 0.92), 5)
		_draw_image_line(frame, stock, stock - facing * 12.0 + side * 4.0, Color(0.18, 0.09, 0.045, 0.9), 6)
		_draw_image_disc(frame, Vector2i(roundi((hand + facing * 18.0).x), roundi((hand + facing * 18.0).y)), 5, brass)
		_draw_image_disc(frame, Vector2i(roundi(muzzle.x), roundi(muzzle.y)), 4, Color(1.0, 0.82, 0.38, 0.95))
	elif profile.find("shotgun_brute") >= 0:
		var stock := hand - facing * 18.0 + side * 11.0
		var muzzle := hand + facing * ((62.0 + draw * 12.0) * reach) - side * 13.0
		_draw_image_line(frame, stock + Vector2(3.0, 4.0), muzzle + Vector2(3.0, 4.0), Color(0.02, 0.012, 0.008, 0.6), weapon_width + 4)
		_draw_image_line(frame, stock, muzzle, iron, weapon_width)
		_draw_image_line(frame, stock - side * 4.0, muzzle - side * 4.0, Color(0.025, 0.015, 0.01, 0.88), maxi(4, weapon_width - 4))
		_draw_image_line(frame, hand + facing * 4.0, muzzle, brass, accent_width)
		_draw_image_line(frame, support_hand, hand + facing * 23.0 - side * 5.0, Color(0.24, 0.13, 0.065, 0.92), 7)
		_draw_image_disc(frame, Vector2i(roundi((hand + facing * 15.0).x), roundi((hand + facing * 15.0).y)), 6, brass)
		_draw_image_disc(frame, Vector2i(roundi(muzzle.x), roundi(muzzle.y)), 6, Color(1.0, 0.74, 0.24, 0.95))
	elif profile.find("knife_rusher") >= 0:
		var tip := hand + facing * ((32.0 + draw * 34.0) * reach) - side * (3.0 + draw * 3.0)
		_draw_image_line(frame, hand + Vector2(1.0, 2.0), tip + Vector2(1.0, 2.0), Color(0.02, 0.012, 0.008, 0.5), weapon_width + 2)
		_draw_image_line(frame, hand, tip, bone, weapon_width)
		_draw_image_line(frame, hand + facing * 8.0, tip, Color(1.0, 0.95, 0.72, 0.62), maxi(2, weapon_width - 2))
		_draw_image_line(frame, hand + side * 8.0, hand + side * 8.0 + facing * 18.0, iron, 5)
		_draw_image_disc(frame, Vector2i(roundi(hand.x), roundi(hand.y)), 4, brass)
	elif profile.find("hunter") >= 0:
		var tip := hand + facing * ((48.0 + draw * 26.0) * reach) - side * (15.0 + draw * 4.0)
		_draw_image_line(frame, hand + Vector2(1.0, 2.0), tip + Vector2(1.0, 2.0), Color(0.02, 0.012, 0.008, 0.52), weapon_width + 2)
		_draw_image_line(frame, hand, tip, bone, weapon_width)
		_draw_image_line(frame, hand + facing * 8.0, tip, Color(1.0, 0.94, 0.72, 0.58), maxi(2, weapon_width - 2))
		_draw_image_line(frame, support_hand, support_hand + facing * 30.0 - side * 6.0, iron, 5)
		_draw_image_disc(frame, Vector2i(roundi(tip.x), roundi(tip.y)), 3, Color(0.98, 0.9, 0.66, 0.92))
	elif profile.find("duelist") >= 0:
		var tip := hand + facing * ((46.0 + draw * 36.0) * reach) - side * 13.0
		var off_hand := hand + side * 15.0 - facing * 5.0
		_draw_image_line(frame, support_hand, off_hand, Color(0.18, 0.1, 0.055, 0.78), 4)
		_draw_image_line(frame, hand + Vector2(2.0, 3.0), tip + Vector2(2.0, 3.0), Color(0.03, 0.014, 0.008, 0.42), weapon_width + 3)
		_draw_image_line(frame, hand, tip, bone, weapon_width)
		_draw_image_line(frame, hand + facing * 9.0, tip, Color(1.0, 0.94, 0.72, 0.6), maxi(2, weapon_width - 2))
		_draw_image_line(frame, hand - side * 10.0, hand + side * 10.0, brass, 4)
		_draw_image_disc(frame, Vector2i(roundi(hand.x), roundi(hand.y)), 4, brass)

func _get_role_weapon_reach(profile: String, carried_pose: bool) -> float:
	if not carried_pose:
		return 1.0
	if profile.find("rifleman") >= 0 or profile.find("shotgun_brute") >= 0:
		return 0.72
	if profile.find("hunter") >= 0 or profile.find("duelist") >= 0:
		return 0.68
	if profile.find("knife_rusher") >= 0:
		return 0.74
	return 0.58

func _get_role_weapon_width(profile: String, carried_pose: bool) -> int:
	if profile.find("shotgun_brute") >= 0:
		return 12 if carried_pose else 13
	if profile.find("rifleman") >= 0:
		return 8 if carried_pose else 9
	if profile.find("hunter") >= 0:
		return 6 if carried_pose else 7
	if profile.find("knife_rusher") >= 0:
		return 5 if carried_pose else 6
	return 5 if carried_pose else 6

func _get_direction_vectors(direction: String) -> Dictionary:
	var facing := Vector2.DOWN
	match direction:
		"back":
			facing = Vector2.UP
		"left":
			facing = Vector2.LEFT
		"right":
			facing = Vector2.RIGHT
		"top_left", "back_left":
			facing = Vector2(-0.72, -1.0).normalized()
		"top_right", "back_right":
			facing = Vector2(0.72, -1.0).normalized()
		"bottom_left", "forward_left":
			facing = Vector2(-0.72, 1.0).normalized()
		"bottom_right", "forward_right", "angled":
			facing = Vector2(0.72, 1.0).normalized()
		_:
			facing = Vector2.DOWN
	return {
		"facing": facing,
		"side": facing.orthogonal().normalized(),
	}

func _draw_image_line(image: Image, from_point: Vector2, to_point: Vector2, color: Color, width: int) -> void:
	var distance := maxf(1.0, from_point.distance_to(to_point))
	var steps := int(ceil(distance))
	for step_index in range(steps + 1):
		var t := float(step_index) / float(steps)
		var point := from_point.lerp(to_point, t)
		_draw_image_disc(image, Vector2i(roundi(point.x), roundi(point.y)), width, color)

func _draw_image_disc(image: Image, center: Vector2i, radius: int, color: Color) -> void:
	for y in range(center.y - radius, center.y + radius + 1):
		if y < 0 or y >= image.get_height():
			continue
		for x in range(center.x - radius, center.x + radius + 1):
			if x < 0 or x >= image.get_width():
				continue
			var offset := Vector2(float(x - center.x), float(y - center.y))
			if offset.length_squared() > float(radius * radius):
				continue
			var existing := image.get_pixel(x, y)
			var out := existing.blend(color)
			image.set_pixel(x, y, out)

func _make_combat_frame(source: Image, crop: Rect2i, frame_index: int, motion_profile: String, direction: String) -> Image:
	var phase := float(frame_index) / float(FRAME_COUNT - 1)
	var windup := smoothstep(0.0, 0.38, phase)
	var release := smoothstep(0.28, 0.68, phase)
	var recover := smoothstep(0.62, 1.0, phase)
	var blade_role := motion_profile.find("knife_rusher") >= 0 or motion_profile.find("hunter") >= 0 or motion_profile.find("duelist") >= 0 or motion_profile.find("player_saber") >= 0
	var heavy := motion_profile.find("shotgun_brute") >= 0
	var brace := windup * (1.0 - recover)
	var snap := release * (1.0 - recover)
	var scale_x := 1.0 + brace * (0.02 if heavy else 0.012) + snap * (0.012 if blade_role else 0.006)
	var scale_y := 1.0 - brace * (0.018 if heavy else 0.012)
	var offset_x := int(round((brace * -4.0 + snap * (9.0 if blade_role else 5.0)) * (0.65 if heavy else 1.0)))
	var offset_y := int(round(brace * 2.0 - snap * (4.0 if blade_role else 1.8)))
	var source_crop := Image.create(crop.size.x, crop.size.y, false, Image.FORMAT_RGBA8)
	source_crop.fill(Color(0, 0, 0, 0))
	source_crop.blit_rect(source, crop, Vector2i.ZERO)
	var scaled_size := Vector2i(maxi(1, int(round(float(crop.size.x) * scale_x))), maxi(1, int(round(float(crop.size.y) * scale_y))))
	source_crop.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_LANCZOS)
	var frame := Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
	frame.fill(Color(0, 0, 0, 0))
	var center := crop.position + crop.size / 2
	var draw_position := Vector2i(center.x - scaled_size.x / 2 + offset_x, center.y - scaled_size.y / 2 + offset_y)
	frame.blit_rect(source_crop, Rect2i(Vector2i.ZERO, scaled_size), draw_position)
	var body_offset := draw_position - crop.position
	_draw_baked_combat_limbs(frame, crop, frame_index, motion_profile, direction, body_offset)
	_draw_baked_weapon(frame, crop, frame_index, motion_profile, direction, body_offset, false)
	if motion_profile.find("player_saber") >= 0:
		_draw_player_saber_draw_anticipation(frame, crop, frame_index, direction, body_offset)
	return frame

func _draw_player_saber_draw_anticipation(frame: Image, crop: Rect2i, frame_index: int, direction: String, body_offset: Vector2i) -> void:
	var phase := float(frame_index) / float(FRAME_COUNT - 1)
	var windup := 1.0 - smoothstep(0.18, 0.48, phase)
	var release := smoothstep(0.32, 0.7, phase)
	var settle := smoothstep(0.68, 1.0, phase)
	var vectors := _get_direction_vectors(direction)
	var facing := vectors["facing"] as Vector2
	var side := vectors["side"] as Vector2
	var center := Vector2(crop.position + crop.size / 2 + body_offset)
	var hip := center + facing * float(crop.size.y) * 0.22 - side * float(crop.size.x) * 0.14
	var chest := center - facing * float(crop.size.y) * 0.04
	var guard_target := chest + facing * (18.0 + release * 8.0) - side * (8.0 + release * 4.0)
	var draw_hand := hip.lerp(guard_target, release)
	var off_hand := chest + side * (18.0 - settle * 6.0) - facing * (4.0 + windup * 7.0) + facing * (release * 6.0)
	var hilt := hip + facing * 4.0 - side * 5.0
	var mid_hilt := hip.lerp(guard_target, 0.48)
	var live_hilt := hilt.lerp(guard_target - facing * 3.0, release)
	var shadow := Color(0.035, 0.018, 0.01, 0.42)
	var denim := Color(0.19, 0.34, 0.5, 0.9)
	var leather := Color(0.18, 0.09, 0.045, 0.94)
	var brass := Color(0.98, 0.71, 0.25, 0.96)
	var bone := Color(0.95, 0.88, 0.66, 0.95)
	var path_alpha := 0.24 + (1.0 - settle) * 0.18
	_draw_image_line(frame, hip + Vector2(2.0, 3.0), draw_hand + Vector2(2.0, 3.0), shadow, 8)
	_draw_image_line(frame, hip, draw_hand, Color(denim.r, denim.g, denim.b, 0.68 + release * 0.18), 5)
	_draw_image_line(frame, chest + side * 4.0, off_hand, denim, 5)
	_draw_image_disc(frame, Vector2i(roundi(draw_hand.x), roundi(draw_hand.y)), 4, brass)
	_draw_image_disc(frame, Vector2i(roundi(off_hand.x), roundi(off_hand.y)), 4, brass)
	_draw_image_line(frame, hilt - facing * 12.0 - side * 3.0, hilt + facing * 18.0 + side * 2.0, Color(0.09, 0.045, 0.022, 0.68), 5)
	_draw_image_line(frame, hilt - side * 8.0, hilt + side * 7.0, brass, 4)
	_draw_image_line(frame, live_hilt - side * 8.0, live_hilt + side * 7.0, Color(brass.r, brass.g, brass.b, 0.68 + release * 0.22), 4)
	_draw_image_line(frame, hilt - facing * 7.0, hilt + facing * 10.0, leather, 5)
	_draw_image_disc(frame, Vector2i(roundi(hip.x), roundi(hip.y)), 3, Color(brass.r, brass.g, brass.b, path_alpha))
	_draw_image_disc(frame, Vector2i(roundi(mid_hilt.x), roundi(mid_hilt.y)), 3, Color(brass.r, brass.g, brass.b, path_alpha + release * 0.1))
	_draw_image_disc(frame, Vector2i(roundi(live_hilt.x), roundi(live_hilt.y)), 4, Color(brass.r, brass.g, brass.b, 0.34 + release * 0.32))
	if windup > 0.05:
		var ghost_tip := hilt + facing * (22.0 + windup * 18.0) - side * (9.0 + windup * 8.0)
		_draw_image_line(frame, hilt + Vector2(2.0, 3.0), ghost_tip + Vector2(2.0, 3.0), shadow, 5)
		_draw_image_line(frame, hilt, ghost_tip, Color(bone.r, bone.g, bone.b, 0.34 + windup * 0.25), 3)
	if release > 0.08:
		var draw_tip := live_hilt + facing * (26.0 + release * 52.0) - side * (7.0 + release * 13.0)
		_draw_image_line(frame, live_hilt + Vector2(2.0, 3.0), draw_tip + Vector2(2.0, 3.0), shadow, 5)
		_draw_image_line(frame, live_hilt, draw_tip, Color(bone.r, bone.g, bone.b, 0.4 + release * 0.42), 3)
		_draw_image_line(frame, live_hilt + facing * 9.0, draw_tip, Color(1.0, 0.96, 0.78, 0.28 + release * 0.28), 2)

func _draw_baked_combat_limbs(frame: Image, crop: Rect2i, frame_index: int, motion_profile: String, direction: String, body_offset: Vector2i) -> void:
	var phase := float(frame_index) / float(FRAME_COUNT - 1)
	var windup := smoothstep(0.0, 0.38, phase)
	var release := smoothstep(0.28, 0.68, phase)
	var recover := smoothstep(0.62, 1.0, phase)
	var commit := release * (1.0 - recover)
	var vectors := _get_direction_vectors(direction)
	var facing := vectors["facing"] as Vector2
	var side := vectors["side"] as Vector2
	var center := Vector2(crop.position + crop.size / 2 + body_offset)
	var heavy := motion_profile.find("shotgun_brute") >= 0
	var blade_role := motion_profile.find("knife_rusher") >= 0 or motion_profile.find("hunter") >= 0 or motion_profile.find("duelist") >= 0 or motion_profile.find("player_saber") >= 0
	var shoulder := center - facing * float(crop.size.y) * 0.06
	var hip := center + facing * float(crop.size.y) * 0.2
	var plant_width := float(crop.size.x) * (0.18 if heavy else 0.14)
	var lead_foot := hip + facing * (12.0 + commit * (18.0 if blade_role else 8.0)) - side * plant_width
	var rear_foot := hip - facing * (8.0 + windup * 8.0) + side * plant_width
	var lead_knee := hip + facing * (8.0 + commit * (10.0 if blade_role else 5.0)) - side * plant_width * 0.62
	var rear_knee := hip - facing * (2.0 + windup * 6.0) + side * plant_width * 0.56
	var lead_hand := shoulder + facing * (18.0 + commit * (25.0 if blade_role else 16.0)) - side * float(crop.size.x) * 0.12
	var support_hand := shoulder + facing * (9.0 + windup * 8.0) + side * float(crop.size.x) * 0.16
	var boot := Color(0.05, 0.026, 0.016, 0.95)
	var sleeve := Color(0.18, 0.31, 0.44, 0.9) if motion_profile.find("player") >= 0 else Color(0.18, 0.1, 0.06, 0.88)
	var glove := Color(0.82, 0.58, 0.25, 0.92)
	var leg_shadow := Color(0.025, 0.012, 0.007, 0.5)
	_draw_image_line(frame, rear_foot + Vector2(2.0, 3.0), rear_foot + facing * 12.0 + Vector2(2.0, 3.0), leg_shadow, 7 if heavy else 5)
	_draw_image_line(frame, lead_foot + Vector2(2.0, 3.0), lead_foot + facing * (12.0 + commit * 6.0) + Vector2(2.0, 3.0), leg_shadow, 7 if heavy else 5)
	_draw_image_line(frame, hip + side * plant_width * 0.22, rear_knee, sleeve.darkened(0.35), 5 if heavy else 4)
	_draw_image_line(frame, rear_knee, rear_foot, boot, 5 if heavy else 4)
	_draw_image_line(frame, hip - side * plant_width * 0.2, lead_knee, sleeve.darkened(0.25), 5 if heavy else 4)
	_draw_image_line(frame, lead_knee, lead_foot, boot, 5 if heavy else 4)
	_draw_image_line(frame, rear_foot - facing * 7.0, rear_foot + facing * 8.0, boot, 5 if heavy else 4)
	_draw_image_line(frame, lead_foot - facing * 7.0, lead_foot + facing * 10.0, boot, 5 if heavy else 4)
	_draw_image_line(frame, lead_foot - side * 4.0, lead_foot + side * 6.0 + facing * 4.0, Color(0.95, 0.6, 0.22, 0.32 + commit * 0.18), 2)
	_draw_image_line(frame, shoulder - side * float(crop.size.x) * 0.08, lead_hand, sleeve, 5 if heavy else 4)
	_draw_image_line(frame, shoulder + side * float(crop.size.x) * 0.1, support_hand, sleeve, 5 if heavy else 4)
	_draw_image_line(frame, lead_hand - facing * 8.0, support_hand + facing * 4.0, Color(0.08, 0.04, 0.022, 0.3 + windup * 0.22), 3)
	_draw_image_disc(frame, Vector2i(roundi(lead_hand.x), roundi(lead_hand.y)), 4, glove)
	_draw_image_disc(frame, Vector2i(roundi(support_hand.x), roundi(support_hand.y)), 4, glove)
