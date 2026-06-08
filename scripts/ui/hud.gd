class_name DustHud
extends CanvasLayer

signal play_requested
signal ability_loadout_changed(equipped_ids: Array[String])
signal gun_loadout_changed(gun_id: String)
signal upgrade_purchase_requested(upgrade_id: String)

const LOADOUT_CARD_VISUAL_VERSION := "loadout_card_claim_ticket_depth_hardware_redraw_gate_v8"
const INFO_CARD_VISUAL_VERSION := "info_card_weathered_ledger_v3"
const QUEST_CARD_VISUAL_VERSION := "quest_card_bounty_stamp_v2"
const RESULT_CARD_VISUAL_VERSION := "result_card_side_receipt_detached_popout_light_wash_v6"
const UNLOCK_TOAST_VISUAL_VERSION := "unlock_toast_brass_claim_ticket_v1"
const MENU_NAV_BUTTON_VISUAL_VERSION := "menu_nav_bounty_receipt_badge_press_hardware_v10"
const MENU_BACKDROP_VISUAL_VERSION := "menu_backdrop_static_low_batch_v1"
const MAIN_MENU_MEMORY_MODE_VERSION := "main_menu_release_on_gameplay_v1"
const MAIN_MENU_MEMORY_LOG_VERSION := "main_menu_memory_release_probe_v1"
const MENU_RESPONSIVE_LAYOUT_VERSION := "menu_responsive_loadout_spacing_v1"
const DUELIST_INTRO_VISUAL_VERSION := "duelist_intro_wanted_poster_v1"
const LIVE_HUD_LEDGER_VISUAL_VERSION := "live_hud_ledger_marshal_badge_label_gate_v3"
const LIVE_HUD_LABEL_UPDATE_GATE_VERSION := "live_hud_label_text_change_gate_v1"

class SkillIcon extends Control:
	const VISUAL_VERSION := "skill_icon_brass_socket_cooldown_5step_v8"
	const REDRAW_BUDGET_VERSION := "skill_icon_cooldown_redraw_gate_20step_v2"
	const TACTILE_MARKER_COUNT := 18
	const COOLDOWN_REDRAW_STEP := 0.05
	var skill_id := ""
	var key_label := ""
	var cooldown_fraction := 0.0

	func _draw() -> void:
		var box := Rect2(Vector2.ZERO, size)
		var center := size * 0.5
		var ready := cooldown_fraction <= 0.0 and skill_id != ""
		var shadow_offset := Vector2(3.0, 4.0)
		draw_rect(Rect2(shadow_offset, size), Color(0.012, 0.006, 0.003, 0.36), true)
		draw_rect(box, Color(0.048, 0.023, 0.013, 0.96), true)
		draw_rect(Rect2(Vector2(3.0, 3.0), size - Vector2(6.0, 6.0)), Color(0.52, 0.29, 0.11, 0.42), false, 1.6)
		draw_rect(box.grow(-2.0), Color(0.17, 0.077, 0.034, 0.94), true)
		draw_rect(box.grow(-6.0), Color(0.055, 0.024, 0.014, 0.58), true)
		draw_rect(Rect2(Vector2(9.0, 9.0), size - Vector2(18.0, 18.0)), Color(0.025, 0.012, 0.007, 0.3), false, 1.0)
		draw_rect(box, Color(0.78, 0.48, 0.2, 0.96), false, 2.0)
		draw_rect(box.grow(-4.0), Color(1.0, 0.74, 0.3, 0.34 if ready else 0.18), false, 1.2)
		draw_line(Vector2(3.0, 3.0), Vector2(size.x - 4.0, 3.0), Color(1.0, 0.82, 0.38, 0.22 if ready else 0.12), 2.0)
		draw_line(Vector2(3.0, 3.0), Vector2(3.0, size.y - 4.0), Color(1.0, 0.82, 0.38, 0.18 if ready else 0.1), 1.6)
		draw_line(Vector2(size.x - 3.0, 5.0), Vector2(size.x - 3.0, size.y - 4.0), Color(0.015, 0.007, 0.004, 0.58), 2.0)
		draw_line(Vector2(6.0, 7.0), Vector2(size.x - 7.0, 7.0), Color(1.0, 0.76, 0.32, 0.44 if ready else 0.22), 1.8)
		draw_line(Vector2(6.0, size.y - 6.0), Vector2(size.x - 7.0, size.y - 6.0), Color(0.03, 0.014, 0.007, 0.68), 2.2)
		draw_line(Vector2(10.0, 3.0), Vector2(10.0, size.y - 4.0), Color(0.9, 0.54, 0.18, 0.28 if ready else 0.16), 1.0)
		draw_line(Vector2(size.x - 10.0, 3.0), Vector2(size.x - 10.0, size.y - 4.0), Color(0.9, 0.54, 0.18, 0.24 if ready else 0.14), 1.0)
		draw_rect(Rect2(Vector2(4.0, 4.0), Vector2(15.0, 15.0)), Color(0.11, 0.045, 0.017, 0.84), true)
		draw_rect(Rect2(Vector2(4.0, 4.0), Vector2(15.0, 15.0)), Color(0.96, 0.66, 0.24, 0.58), false, 1.0)
		if ready:
			draw_rect(Rect2(Vector2(10.0, 10.0), Vector2(size.x - 20.0, 5.0)), Color(0.96, 0.62, 0.18, 0.42), true)
			draw_line(Vector2(8.0, 11.0), Vector2(size.x - 8.0, 11.0), Color(1.0, 0.82, 0.34, 0.58), 1.4)
			draw_arc(center, 26.5, -0.85, PI + 0.55, 22, Color(1.0, 0.78, 0.28, 0.38), 2.2)
			draw_circle(Vector2(size.x - 12.0, 12.0), 2.8, Color(1.0, 0.86, 0.42, 0.54))
			draw_line(center + Vector2(-18.0, 23.0), center + Vector2(18.0, 22.0), Color(1.0, 0.74, 0.24, 0.34), 1.4)
			draw_circle(center + Vector2(20.0, 20.0), 2.0, Color(1.0, 0.88, 0.48, 0.46))
		else:
			for i in range(3):
				var notch_y := 17.0 + float(i) * 10.0
				draw_line(Vector2(size.x - 8.0, notch_y), Vector2(size.x - 15.0, notch_y + 5.0), Color(0.82, 0.44, 0.16, 0.22), 1.1)
		draw_circle(center, 23.0, Color(0.055, 0.025, 0.012, 0.9))
		draw_arc(center, 24.0, -0.72, PI + 0.48, 20, Color(0.82, 0.5, 0.2, 0.5 if ready else 0.34), 3.0)
		draw_arc(center, 17.0, PI * 0.12, PI * 0.92, 12, Color(1.0, 0.82, 0.38, 0.2 if ready else 0.1), 2.0)
		for tick in range(4):
			var tick_angle := -0.55 + float(tick) * 0.42
			var tick_origin := center + Vector2.RIGHT.rotated(tick_angle) * 25.0
			var tick_end := center + Vector2.RIGHT.rotated(tick_angle) * 29.0
			draw_line(tick_origin, tick_end, Color(0.96, 0.65, 0.24, 0.34 if ready else 0.18), 1.2)
		for rivet in [Vector2(7.0, 7.0), Vector2(size.x - 7.0, 7.0), Vector2(7.0, size.y - 7.0), Vector2(size.x - 7.0, size.y - 7.0)]:
			draw_circle(rivet, 2.5, Color(0.95, 0.66, 0.24, 0.86 if ready else 0.58))
			draw_circle(rivet + Vector2(0.8, 0.8), 1.1, Color(0.05, 0.022, 0.01, 0.55))

		match skill_id:
			"deadeye":
				_draw_deadeye_icon()
			"ricochet_shot":
				_draw_ricochet_icon()
			"dust_veil":
				_draw_dust_icon()
			"quickdraw":
				_draw_quickdraw_icon()
			"duelist_lunge":
				_draw_duelist_lunge_icon()
			"fan_hammer":
				_draw_fan_hammer_icon()
			"ghost_step":
				_draw_ghost_step_icon()

		draw_string(ThemeDB.fallback_font, Vector2(6.0, 16.0), key_label, HORIZONTAL_ALIGNMENT_LEFT, 16.0, 14, Color(1.0, 0.86, 0.5, 0.85))
		if cooldown_fraction > 0.0:
			var cover_height := size.y * cooldown_fraction
			draw_rect(Rect2(Vector2(0.0, size.y - cover_height), Vector2(size.x, cover_height)), Color(0.02, 0.012, 0.009, 0.76), true)
			draw_line(Vector2(0.0, size.y - cover_height), Vector2(size.x, size.y - cover_height), Color(1.0, 0.82, 0.38, 0.78), 2.0)
			draw_line(Vector2(5.0, size.y - cover_height + 4.0), Vector2(size.x - 5.0, size.y - cover_height + 4.0), Color(0.92, 0.5, 0.16, 0.28), 1.2)
			for i in range(3):
				var tick_x := lerpf(12.0, size.x - 12.0, float(i) / 2.0)
				draw_line(Vector2(tick_x, size.y - cover_height - 4.0), Vector2(tick_x, size.y - cover_height + 4.0), Color(1.0, 0.72, 0.28, 0.58), 1.4)
			_draw_cooldown_cylinder_marks(cover_height)

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_redraw_budget_version() -> String:
		return REDRAW_BUDGET_VERSION

	func get_cooldown_redraw_step() -> float:
		return COOLDOWN_REDRAW_STEP

	func get_cooldown_redraw_bucket_count() -> int:
		return int(ceil(1.0 / COOLDOWN_REDRAW_STEP))

	func get_tactile_marker_count() -> int:
		return TACTILE_MARKER_COUNT

	func set_state(id: String, key: String, fraction: float) -> void:
		var previous_ready := cooldown_fraction <= 0.0 and skill_id != ""
		var next_fraction := clampf(fraction, 0.0, 1.0)
		var next_snapped := snappedf(next_fraction, COOLDOWN_REDRAW_STEP)
		var next_ready := next_snapped <= 0.0 and id != ""
		var should_redraw := skill_id != id or key_label != key or previous_ready != next_ready or not is_equal_approx(cooldown_fraction, next_snapped)
		skill_id = id
		key_label = key
		cooldown_fraction = next_snapped
		if should_redraw:
			queue_redraw()

	func _draw_cooldown_cylinder_marks(cover_height: float) -> void:
		var y := size.y - cover_height + 9.0
		var alpha := clampf(cooldown_fraction, 0.18, 0.62)
		for i in range(2):
			var x := size.x - 17.0 + float(i) * 6.0
			draw_line(Vector2(x, y), Vector2(x, y + 8.0), Color(0.96, 0.62, 0.2, alpha), 2.0)

	func _draw_skill_socket_hardware(box: Rect2, ready: bool) -> void:
		var brass_alpha := 0.36 if ready else 0.18
		var brass := Color(1.0, 0.7, 0.24, brass_alpha)
		var dark := Color(0.022, 0.01, 0.005, 0.52)
		for side_index in range(2):
			var side_sign := -1.0 if side_index == 0 else 1.0
			var x := 4.0 if side_index == 0 else box.size.x - 14.0
			var rail := Rect2(Vector2(x, 18.0), Vector2(10.0, maxf(0.0, box.size.y - 36.0)))
			draw_rect(rail, Color(0.04, 0.016, 0.007, 0.46), true)
			draw_line(rail.position + Vector2(3.0, 3.0), rail.position + Vector2(3.0, rail.size.y - 3.0), brass, 1.1)
			draw_line(rail.position + Vector2(7.0, 5.0), rail.position + Vector2(7.0, rail.size.y - 5.0), dark, 1.0)
			for notch in range(3):
				var y := rail.position.y + 8.0 + float(notch) * maxf(7.0, (rail.size.y - 16.0) / 2.0)
				draw_line(Vector2(rail.position.x + 2.0, y), Vector2(rail.position.x + 8.0, y + 2.0 * side_sign), brass, 1.0)
		for shell in range(3):
			var shell_x := lerpf(22.0, box.size.x - 22.0, float(shell) / 2.0)
			draw_rect(Rect2(Vector2(shell_x - 3.0, box.size.y - 13.0), Vector2(6.0, 8.0)), Color(0.12, 0.046, 0.016, 0.42), true)
			draw_circle(Vector2(shell_x, box.size.y - 6.0), 2.0, brass)

	func _draw_skill_center_badge(center: Vector2, ready: bool) -> void:
		var alpha := 0.42 if ready else 0.22
		var dark := Color(0.02, 0.009, 0.004, 0.46)
		var brass := Color(1.0, 0.72, 0.28, alpha)
		var star := PackedVector2Array()
		for point in range(10):
			var radius := 8.0 if point % 2 == 0 else 4.0
			var angle := -PI * 0.5 + float(point) * TAU / 10.0
			star.append(center + Vector2(cos(angle), sin(angle)) * radius)
		draw_colored_polygon(star, dark)
		draw_polyline(star, brass, 1.1, true)
		draw_circle(center, 2.1, Color(1.0, 0.86, 0.46, alpha + 0.12))

	func _draw_deadeye_icon() -> void:
		var center := size * 0.5
		draw_arc(center, 18.0, 0.0, TAU, 32, Color(0.95, 0.9, 0.76), 2.0)
		draw_arc(center, 8.0, 0.0, TAU, 24, Color(0.95, 0.9, 0.76), 2.0)
		draw_line(center + Vector2(-24, 0), center + Vector2(24, 0), Color(0.95, 0.9, 0.76), 2.0)
		draw_line(center + Vector2(0, -24), center + Vector2(0, 24), Color(0.95, 0.9, 0.76), 2.0)
		draw_circle(center, 3.0, Color(0.72, 0.08, 0.04))

	func _draw_ricochet_icon() -> void:
		var wall_x := size.x * 0.66
		draw_line(Vector2(wall_x, 18.0), Vector2(wall_x, size.y - 14.0), Color(0.62, 0.36, 0.16), 5.0)
		draw_line(Vector2(18.0, size.y - 18.0), Vector2(wall_x - 4.0, size.y * 0.52), Color(1.0, 0.78, 0.35), 3.0)
		draw_line(Vector2(wall_x - 4.0, size.y * 0.52), Vector2(26.0, 18.0), Color(1.0, 0.78, 0.35), 3.0)
		draw_circle(Vector2(wall_x - 5.0, size.y * 0.52), 5.0, Color(0.9, 0.42, 0.12))

	func _draw_dust_icon() -> void:
		for i in range(4):
			var y := 22.0 + float(i) * 11.0
			var start := Vector2(15.0 + float(i % 2) * 5.0, y)
			var mid := Vector2(size.x * 0.48, y - 10.0)
			var end := Vector2(size.x - 14.0, y + 1.0)
			draw_polyline(PackedVector2Array([start, mid, end]), Color(0.94, 0.78, 0.48, 0.9), 3.0)
		draw_circle(Vector2(21.0, 50.0), 4.0, Color(0.72, 0.48, 0.22, 0.7))
		draw_circle(Vector2(38.0, 26.0), 3.0, Color(0.72, 0.48, 0.22, 0.65))

	func _draw_quickdraw_icon() -> void:
		var grip := Vector2(24.0, 46.0)
		var barrel := Vector2(size.x - 18.0, 28.0)
		draw_line(grip, barrel, Color(0.18, 0.08, 0.035), 8.0)
		draw_line(grip + Vector2(3.0, 7.0), grip + Vector2(-8.0, 20.0), Color(0.24, 0.11, 0.045), 7.0)
		draw_line(barrel - Vector2(16.0, -3.0), barrel + Vector2(9.0, -4.0), Color(0.82, 0.58, 0.28), 4.0)
		draw_arc(grip + Vector2(12.0, 0.0), 10.0, -0.2, PI * 1.25, 14, Color(0.78, 0.45, 0.2), 3.0)

	func _draw_duelist_lunge_icon() -> void:
		var center := size * 0.5
		draw_line(center + Vector2(-20.0, 16.0), center + Vector2(20.0, -16.0), Color(0.96, 0.16, 0.08), 5.0)
		draw_line(center + Vector2(-8.0, 18.0), center + Vector2(24.0, -14.0), Color(1.0, 0.84, 0.46), 2.0)
		draw_arc(center, 22.0, -0.9, 0.65, 22, Color(0.95, 0.1, 0.04, 0.78), 4.0)

	func _draw_fan_hammer_icon() -> void:
		var base := Vector2(23.0, 46.0)
		for i in range(4):
			var angle := -0.8 + float(i) * 0.34
			draw_line(base, base + Vector2.RIGHT.rotated(angle) * 36.0, Color(1.0, 0.62, 0.18), 3.0)
		draw_arc(base + Vector2(8.0, -6.0), 12.0, -0.2, PI * 1.2, 18, Color(0.78, 0.42, 0.16), 3.0)

	func _draw_ghost_step_icon() -> void:
		var center := size * 0.5
		draw_circle(center + Vector2(-8.0, 8.0), 11.0, Color(0.86, 0.76, 0.58, 0.55))
		draw_circle(center + Vector2(8.0, -4.0), 13.0, Color(0.94, 0.86, 0.68, 0.35))
		draw_polyline(PackedVector2Array([Vector2(14, 44), Vector2(28, 30), Vector2(42, 42), Vector2(52, 24)]), Color(1.0, 0.84, 0.52, 0.82), 3.0)

class LoadoutIcon extends Control:
	const VISUAL_VERSION := "loadout_icon_brass_socket_material_cues_v2"
	const REDRAW_GATE_VERSION := "loadout_icon_state_redraw_gate_v1"
	const TACTILE_MARKER_COUNT := 10
	var item_id := ""
	var item_type := "ability"
	var faded := false
	var equipped := false

	func set_state(id: String, type: String, is_faded: bool, is_equipped: bool) -> void:
		var should_redraw := item_id != id or item_type != type or faded != is_faded or equipped != is_equipped
		item_id = id
		item_type = type
		faded = is_faded
		equipped = is_equipped
		if should_redraw:
			queue_redraw()

	func get_redraw_gate_version() -> String:
		return REDRAW_GATE_VERSION

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_tactile_marker_count() -> int:
		return TACTILE_MARKER_COUNT

	func _draw() -> void:
		var frame := Rect2(Vector2.ZERO, size)
		var alpha := 0.46 if faded else 0.92
		var brass := Color(0.86, 0.52, 0.18, alpha)
		var bone := Color(0.94, 0.82, 0.56, alpha)
		var dark := Color(0.08, 0.034, 0.016, 0.9 if not faded else 0.56)
		var socket := frame.grow(-2.0)
		draw_rect(Rect2(Vector2(3.0, 4.0), size), Color(0.0, 0.0, 0.0, 0.2 if not faded else 0.1), true)
		draw_rect(frame, Color(0.12, 0.052, 0.024, 0.74 if not faded else 0.42), true)
		draw_rect(frame, brass.darkened(0.2), false, 2.0)
		draw_rect(socket.grow(-3.0), Color(0.035, 0.014, 0.006, 0.38 if not faded else 0.22), true)
		draw_rect(frame.grow(-4.0), Color(0.98, 0.68, 0.24, 0.18 if not faded else 0.08), false, 1.0)
		_draw_icon_socket_materials(frame, brass, bone, dark)
		if equipped:
			_draw_equipped_socket_badge(Vector2(size.x - 10.0, 10.0), brass)
		if item_type == "gun":
			_draw_gun_icon(item_id, brass, bone, dark)
		else:
			_draw_ability_icon(item_id, brass, bone, dark)
		_draw_icon_type_footer(frame, brass, bone, dark)

	func _draw_icon_socket_materials(frame: Rect2, brass: Color, bone: Color, dark: Color) -> void:
		var inner := frame.grow(-7.0)
		draw_line(inner.position + Vector2(3.0, 2.0), inner.position + Vector2(inner.size.x - 3.0, 1.0), Color(1.0, 0.8, 0.34, 0.16 if not faded else 0.07), 1.2)
		draw_line(inner.position + Vector2(3.0, inner.size.y - 1.0), inner.end - Vector2(3.0, 2.0), Color(0.0, 0.0, 0.0, 0.34 if not faded else 0.18), 1.8)
		for corner in [frame.position + Vector2(7.0, 7.0), frame.position + Vector2(frame.size.x - 7.0, frame.size.y - 7.0)]:
			draw_circle(corner, 2.4, dark)
			draw_circle(corner + Vector2(-0.6, -0.6), 1.2, brass.lightened(0.14))
		for notch in range(2):
			var x := frame.position.x + 17.0 + float(notch) * maxf(10.0, (frame.size.x - 34.0) / 2.0)
			draw_line(Vector2(x, frame.position.y + 5.0), Vector2(x + 6.0, frame.position.y + 5.0), Color(1.0, 0.76, 0.28, 0.12 if not faded else 0.05), 1.0)
			draw_line(Vector2(x, frame.end.y - 5.0), Vector2(x + 6.0, frame.end.y - 5.0), Color(0.018, 0.007, 0.003, 0.34), 1.0)
		var center := frame.get_center()
		draw_circle(center, minf(frame.size.x, frame.size.y) * 0.33, Color(0.02, 0.008, 0.004, 0.22 if not faded else 0.12))

	func _draw_equipped_socket_badge(center: Vector2, brass: Color) -> void:
		draw_circle(center + Vector2(1.0, 1.0), 6.5, Color(0.02, 0.008, 0.004, 0.5))
		draw_circle(center, 6.0, Color(0.95, 0.7, 0.24, 0.95))
		draw_circle(center, 3.0, Color(0.14, 0.06, 0.025, 0.9))
		draw_line(center + Vector2(-3.0, 0.0), center + Vector2(-0.5, 3.0), brass.lightened(0.28), 1.4)
		draw_line(center + Vector2(-0.5, 3.0), center + Vector2(4.0, -4.0), brass.lightened(0.28), 1.4)

	func _draw_icon_type_footer(frame: Rect2, brass: Color, bone: Color, dark: Color) -> void:
		var y := frame.end.y - 10.0
		var start_x := frame.position.x + 15.0
		var end_x := frame.end.x - 15.0
		draw_line(Vector2(start_x, y), Vector2(end_x, y), dark, 2.0)
		if item_type == "gun":
			for shell in range(2):
				var x := lerpf(start_x + 9.0, end_x - 9.0, float(shell))
				draw_rect(Rect2(Vector2(x - 2.0, y - 5.0), Vector2(4.0, 8.0)), Color(0.12, 0.046, 0.016, brass.a * 0.44), true)
				draw_circle(Vector2(x, y + 3.0), 1.4, brass)
		else:
			for mark in range(2):
				var x := lerpf(start_x + 7.0, end_x - 7.0, float(mark))
				draw_line(Vector2(x - 3.0, y - 3.0), Vector2(x + 3.0, y + 3.0), bone, 1.2)
				draw_line(Vector2(x + 3.0, y - 3.0), Vector2(x - 3.0, y + 3.0), brass, 1.0)

	func _draw_gun_icon(id: String, brass: Color, bone: Color, dark: Color) -> void:
		var center := size * 0.5
		match id:
			"long_rifle":
				draw_line(center + Vector2(-34.0, 7.0), center + Vector2(35.0, -12.0), dark, 8.0)
				draw_line(center + Vector2(-31.0, 4.0), center + Vector2(39.0, -15.0), brass, 3.0)
				draw_line(center + Vector2(-16.0, 10.0), center + Vector2(-2.0, 27.0), Color(0.26, 0.11, 0.045, brass.a), 6.0)
				draw_circle(center + Vector2(3.0, -1.0), 5.0, bone)
			"sawed_off":
				draw_line(center + Vector2(-25.0, -7.0), center + Vector2(24.0, -12.0), dark, 9.0)
				draw_line(center + Vector2(-25.0, 4.0), center + Vector2(24.0, -1.0), dark, 9.0)
				draw_line(center + Vector2(-24.0, -8.0), center + Vector2(26.0, -13.0), brass, 2.4)
				draw_line(center + Vector2(-24.0, 3.0), center + Vector2(26.0, -2.0), brass, 2.4)
				draw_line(center + Vector2(-16.0, 9.0), center + Vector2(-4.0, 25.0), Color(0.28, 0.12, 0.048, brass.a), 7.0)
			"pepperbox":
				for i in range(6):
					var angle := TAU * float(i) / 6.0
					draw_line(center, center + Vector2(cos(angle), sin(angle)) * 21.0, brass, 3.0)
				draw_circle(center, 15.0, dark)
				draw_circle(center, 6.0, bone)
				draw_line(center + Vector2(10.0, 9.0), center + Vector2(30.0, 24.0), dark, 6.0)
			"golden_revolver":
				_draw_revolver(center, Color(1.0, 0.72, 0.22, brass.a), bone, dark)
				draw_arc(center + Vector2(0.0, -1.0), 28.0, -0.8, 0.2, 18, bone, 2.0)
			_:
				_draw_revolver(center, brass, bone, dark)

	func _draw_revolver(center: Vector2, brass: Color, bone: Color, dark: Color) -> void:
		draw_line(center + Vector2(-21.0, 11.0), center + Vector2(30.0, -10.0), dark, 9.0)
		draw_line(center + Vector2(-17.0, 8.0), center + Vector2(32.0, -12.0), brass, 3.0)
		draw_arc(center + Vector2(-7.0, 3.0), 13.0, -0.2, PI * 1.22, 18, brass.darkened(0.08), 3.0)
		draw_circle(center + Vector2(-5.0, 1.0), 9.0, dark)
		draw_circle(center + Vector2(-5.0, 1.0), 4.0, bone)
		draw_line(center + Vector2(-14.0, 12.0), center + Vector2(-25.0, 29.0), Color(0.26, 0.11, 0.045, brass.a), 7.0)

	func _draw_ability_icon(id: String, brass: Color, bone: Color, dark: Color) -> void:
		var center := size * 0.5
		match id:
			"deadeye":
				draw_arc(center, 28.0, 0.0, TAU, 36, bone, 2.6)
				draw_arc(center, 14.0, 0.0, TAU, 28, brass, 2.6)
				draw_line(center + Vector2(-36.0, 0.0), center + Vector2(36.0, 0.0), bone, 2.0)
				draw_line(center + Vector2(0.0, -31.0), center + Vector2(0.0, 31.0), bone, 2.0)
				draw_circle(center, 4.0, Color(0.78, 0.08, 0.04, bone.a))
			"ricochet_shot":
				draw_line(center + Vector2(25.0, -30.0), center + Vector2(25.0, 29.0), dark, 8.0)
				draw_line(center + Vector2(-31.0, 24.0), center + Vector2(22.0, 3.0), brass, 4.0)
				draw_line(center + Vector2(22.0, 3.0), center + Vector2(-16.0, -26.0), bone, 3.0)
				draw_circle(center + Vector2(22.0, 3.0), 6.0, Color(0.92, 0.38, 0.08, brass.a))
			"dust_veil":
				for i in range(5):
					var y := center.y - 21.0 + float(i) * 10.0
					draw_polyline(PackedVector2Array([Vector2(12.0, y), Vector2(36.0, y - 10.0), Vector2(70.0, y + 2.0)]), brass if i % 2 == 0 else bone, 3.0)
				draw_circle(center + Vector2(-19.0, 17.0), 5.0, Color(0.62, 0.36, 0.16, brass.a * 0.8))
			"quickdraw":
				_draw_revolver(center + Vector2(-3.0, 1.0), brass, bone, dark)
				for i in range(3):
					draw_line(center + Vector2(16.0, -16.0 + i * 8.0), center + Vector2(38.0, -24.0 + i * 8.0), bone, 2.0)
			"duelist_lunge":
				draw_line(center + Vector2(-31.0, 25.0), center + Vector2(31.0, -24.0), Color(0.86, 0.1, 0.04, brass.a), 7.0)
				draw_line(center + Vector2(-16.0, 27.0), center + Vector2(34.0, -18.0), bone, 2.4)
				draw_arc(center, 29.0, -0.9, 0.64, 24, brass, 4.0)
			"fan_hammer":
				for i in range(5):
					var angle := -0.95 + float(i) * 0.34
					draw_line(center + Vector2(-16.0, 18.0), center + Vector2(-16.0, 18.0) + Vector2.RIGHT.rotated(angle) * 52.0, brass, 3.2)
				_draw_revolver(center + Vector2(-8.0, 8.0), brass, bone, dark)
			"ghost_step":
				draw_circle(center + Vector2(-14.0, 12.0), 15.0, Color(bone.r, bone.g, bone.b, bone.a * 0.45))
				draw_circle(center + Vector2(9.0, -7.0), 18.0, Color(bone.r, bone.g, bone.b, bone.a * 0.28))
				draw_polyline(PackedVector2Array([Vector2(16.0, 48.0), Vector2(34.0, 31.0), Vector2(48.0, 45.0), Vector2(67.0, 19.0)]), brass, 3.4)
			_:
				draw_circle(center, 22.0, dark)
				draw_circle(center, 8.0, brass)

class LoadoutCardButton extends Button:
	const VISUAL_VERSION := "loadout_card_claim_ticket_depth_hardware_redraw_gate_v8"
	const TACTILE_MARKER_COUNT := 40
	const REDRAW_GATE_VERSION := "loadout_card_state_redraw_gate_v1"
	var accent := Color(0.86, 0.58, 0.28)
	var faded := false
	var equipped := false

	func set_card_state(card_accent: Color, is_faded: bool, is_equipped: bool) -> void:
		var should_redraw := not is_equal_approx(accent.r, card_accent.r) or not is_equal_approx(accent.g, card_accent.g) or not is_equal_approx(accent.b, card_accent.b) or not is_equal_approx(accent.a, card_accent.a) or faded != is_faded or equipped != is_equipped
		accent = card_accent
		faded = is_faded
		equipped = is_equipped
		if should_redraw:
			queue_redraw()

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_tactile_marker_count() -> int:
		return TACTILE_MARKER_COUNT

	func get_redraw_gate_version() -> String:
		return REDRAW_GATE_VERSION

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func _draw() -> void:
		if size.x <= 8.0 or size.y <= 8.0:
			return
		var brass := accent
		var dark := Color(0.08, 0.031, 0.014, 0.72)
		var ink := Color(0.12, 0.048, 0.018, 0.48)
		var highlight := Color(1.0, 0.82, 0.42, 0.68)
		if faded:
			brass = Color(0.34, 0.27, 0.19, 0.72)
			highlight = Color(0.74, 0.58, 0.38, 0.34)
		draw_rect(Rect2(Vector2(5.0, 6.0), size - Vector2(2.0, 1.0)), Color(0.0, 0.0, 0.0, 0.16), true)
		draw_rect(Rect2(Vector2(9.0, 7.0), Vector2(size.x - 18.0, 4.0)), highlight, true)
		draw_rect(Rect2(Vector2(9.0, size.y - 11.0), Vector2(size.x - 18.0, 3.0)), dark, true)
		draw_rect(Rect2(Vector2(10.0, 12.0), Vector2(5.0, maxf(0.0, size.y - 24.0))), Color(0.04, 0.016, 0.007, 0.26), true)
		draw_rect(Rect2(Vector2(size.x - 15.0, 12.0), Vector2(5.0, maxf(0.0, size.y - 24.0))), Color(1.0, 0.67, 0.22, 0.11 if not faded else 0.055), true)
		_draw_claim_ticket_edges(brass, faded, equipped)
		_draw_loadout_card_depth_hardware(brass, faded, equipped)
		var badge_center := Vector2(30.0, 31.0)
		for point in range(6):
			var angle := -PI * 0.5 + float(point) * TAU / 6.0
			draw_line(badge_center, badge_center + Vector2(cos(angle), sin(angle)) * 16.0, Color(1.0, 0.68, 0.24, 0.18 if not faded else 0.08), 2.0)
		draw_circle(badge_center, 10.0, Color(0.06, 0.024, 0.01, 0.68 if not faded else 0.4))
		draw_circle(badge_center, 4.0, brass.lightened(0.16))
		var cartridge_rail := Rect2(Vector2(55.0, 15.0), Vector2(maxf(0.0, size.x - 112.0), 15.0))
		draw_rect(cartridge_rail, Color(0.045, 0.018, 0.007, 0.34 if not faded else 0.18), true)
		draw_line(cartridge_rail.position + Vector2(4.0, 3.0), cartridge_rail.position + Vector2(cartridge_rail.size.x - 4.0, 2.0), Color(1.0, 0.76, 0.3, 0.18 if not faded else 0.08), 1.4)
		for shell in range(5):
			var shell_x := cartridge_rail.position.x + 10.0 + float(shell) * 15.0
			if shell_x < cartridge_rail.end.x - 8.0:
				draw_rect(Rect2(Vector2(shell_x, cartridge_rail.position.y + 4.0), Vector2(7.0, 8.0)), Color(0.78, 0.43, 0.14, 0.3 if not faded else 0.12), true)
				draw_circle(Vector2(shell_x + 3.5, cartridge_rail.position.y + 11.0), 1.6, Color(1.0, 0.78, 0.32, 0.28 if not faded else 0.12))
		draw_line(Vector2(17.0, 30.0), Vector2(17.0, size.y - 30.0), Color(1.0, 0.72, 0.28, 0.16 if not faded else 0.07), 1.3)
		draw_line(Vector2(size.x - 17.0, 30.0), Vector2(size.x - 17.0, size.y - 30.0), Color(0.04, 0.016, 0.007, 0.2), 1.3)
		for corner in [
			Vector2(13.0, 13.0),
			Vector2(size.x - 13.0, 13.0),
			Vector2(13.0, size.y - 13.0),
			Vector2(size.x - 13.0, size.y - 13.0)
		]:
			draw_circle(corner, 4.0, Color(0.08, 0.034, 0.014, 0.76))
			draw_circle(corner + Vector2(-0.8, -0.8), 2.4, brass.lightened(0.12))
		for i in range(5):
			var x := 24.0 + float(i) * 18.0
			if x < size.x - 24.0:
				draw_line(Vector2(x, 18.0), Vector2(x + 8.0, 18.0), ink, 1.2)
		for primer in range(4):
			var px := 28.0 + float(primer) * 16.0
			if px < size.x - 28.0:
				draw_circle(Vector2(px, size.y - 18.0), 2.0, Color(1.0, 0.74, 0.28, 0.22 if not faded else 0.1))
		for tick in range(4):
			var y := 34.0 + float(tick) * maxf(12.0, (size.y - 68.0) / 3.0)
			draw_line(Vector2(9.0, y), Vector2(16.0, y + 2.0), brass.darkened(0.06), 1.2)
			draw_line(Vector2(size.x - 16.0, y + 2.0), Vector2(size.x - 9.0, y), brass.darkened(0.12), 1.2)
		_draw_loadout_bounty_seal(Vector2(size.x - 31.0, size.y - 38.0), brass, faded, equipped)
		if equipped:
			var plate := Rect2(Vector2(size.x - 58.0, 10.0), Vector2(43.0, 18.0))
			draw_rect(plate, Color(0.13, 0.052, 0.018, 0.74), true)
			draw_rect(plate, brass.lightened(0.2), false, 2.0)
			draw_line(plate.position + Vector2(8.0, 10.0), plate.position + Vector2(17.0, 15.0), highlight, 2.4)
			draw_line(plate.position + Vector2(17.0, 15.0), plate.position + Vector2(34.0, 4.0), highlight, 2.4)
			var equipped_stamp := Rect2(Vector2(size.x * 0.5 - 41.0, 34.0), Vector2(82.0, 20.0))
			draw_rect(Rect2(equipped_stamp.position + Vector2(3.0, 4.0), equipped_stamp.size), Color(0.018, 0.007, 0.003, 0.28), true)
			draw_rect(equipped_stamp, Color(0.11, 0.042, 0.016, 0.64), true)
			draw_rect(equipped_stamp, brass.lightened(0.12), false, 1.4)
			for mark in range(4):
				var mark_x := equipped_stamp.position.x + 13.0 + float(mark) * 18.0
				draw_line(Vector2(mark_x, equipped_stamp.position.y + 6.0), Vector2(mark_x + 8.0, equipped_stamp.end.y - 6.0), Color(1.0, 0.78, 0.32, 0.3), 1.1)
			var sash := Rect2(Vector2(18.0, size.y - 29.0), Vector2(maxf(0.0, size.x - 36.0), 13.0))
			draw_rect(sash, Color(0.055, 0.022, 0.009, 0.44), true)
			draw_line(sash.position + Vector2(8.0, 5.0), sash.end - Vector2(8.0, 7.0), Color(1.0, 0.78, 0.32, 0.38), 2.0)
			draw_line(Vector2(23.0, size.y - 33.0), Vector2(size.x - 23.0, size.y - 33.0), Color(1.0, 0.82, 0.42, 0.2), 1.4)
		elif faded:
			for i in range(6):
				var offset := float(i) * 28.0 - 20.0
				draw_line(Vector2(offset, size.y - 6.0), Vector2(offset + 54.0, 14.0), Color(0.12, 0.05, 0.022, 0.22), 2.0)
			draw_rect(Rect2(Vector2(22.0, size.y - 28.0), Vector2(maxf(0.0, size.x - 44.0), 12.0)), Color(0.08, 0.052, 0.032, 0.24), true)
		else:
			var ready_plate := Rect2(Vector2(size.x - 47.0, size.y - 28.0), Vector2(31.0, 13.0))
			draw_rect(ready_plate, Color(0.08, 0.034, 0.014, 0.34), true)
			draw_rect(ready_plate, Color(1.0, 0.7, 0.24, 0.2), false, 1.2)
			draw_circle(ready_plate.position + Vector2(8.0, 6.5), 2.0, Color(1.0, 0.82, 0.36, 0.5))
			draw_line(ready_plate.position + Vector2(16.0, 4.0), ready_plate.position + Vector2(25.0, 9.0), Color(1.0, 0.72, 0.24, 0.24), 1.2)
		var bottom_notch := Rect2(Vector2(size.x * 0.5 - 28.0, size.y - 13.0), Vector2(56.0, 7.0))
		draw_rect(bottom_notch, Color(0.04, 0.016, 0.007, 0.34), true)
		for nick in range(4):
			var nick_x := bottom_notch.position.x + 8.0 + float(nick) * 13.0
			draw_line(Vector2(nick_x, bottom_notch.position.y + 2.0), Vector2(nick_x + 7.0, bottom_notch.position.y + 2.0), Color(1.0, 0.7, 0.24, 0.2 if not faded else 0.08), 1.0)

	func _draw_loadout_card_depth_hardware(brass: Color, is_faded: bool, is_equipped: bool) -> void:
		var depth_alpha := 0.2 if not is_faded else 0.09
		var bright_alpha := 0.18 if not is_faded else 0.07
		if is_equipped:
			depth_alpha = 0.34
			bright_alpha = 0.32
		var dark := Color(0.018, 0.007, 0.003, 0.42 + depth_alpha * 0.35)
		var shine := Color(1.0, 0.78, 0.32, bright_alpha)
		var inner_frame := Rect2(Vector2(22.0, 25.0), Vector2(maxf(0.0, size.x - 44.0), maxf(0.0, size.y - 56.0)))
		draw_rect(Rect2(inner_frame.position + Vector2(3.0, 5.0), inner_frame.size), Color(0.0, 0.0, 0.0, 0.08 + depth_alpha * 0.16), false, 3.0)
		draw_rect(inner_frame, Color(0.04, 0.016, 0.007, 0.12 + depth_alpha * 0.18), false, 2.0)
		draw_line(inner_frame.position + Vector2(10.0, 7.0), inner_frame.end - Vector2(10.0, inner_frame.size.y - 10.0), shine, 1.5)
		draw_line(inner_frame.position + Vector2(8.0, inner_frame.size.y - 10.0), inner_frame.end - Vector2(8.0, 9.0), Color(0.0, 0.0, 0.0, 0.16 + depth_alpha * 0.16), 1.6)
		for corner in [
			inner_frame.position + Vector2(5.0, 5.0),
			Vector2(inner_frame.end.x - 5.0, inner_frame.position.y + 5.0),
			Vector2(inner_frame.position.x + 5.0, inner_frame.end.y - 5.0),
			inner_frame.end - Vector2(5.0, 5.0)
		]:
			draw_rect(Rect2(corner - Vector2(5.0, 5.0), Vector2(10.0, 10.0)), dark, true)
			draw_circle(corner + Vector2(-1.0, -1.0), 2.2, brass.lightened(0.18))
		for stitch in range(6):
			var t := float(stitch) / 5.0
			var left_y := lerpf(38.0, size.y - 40.0, t)
			draw_line(Vector2(23.0, left_y), Vector2(31.0, left_y + 2.0), shine, 1.0)
			draw_line(Vector2(size.x - 31.0, left_y + 2.0), Vector2(size.x - 23.0, left_y), Color(0.04, 0.016, 0.007, 0.22), 1.0)
		if is_equipped:
			var glow_plate := Rect2(Vector2(34.0, size.y - 52.0), Vector2(maxf(0.0, size.x - 68.0), 17.0))
			draw_rect(glow_plate, Color(1.0, 0.72, 0.24, 0.1), true)
			draw_line(glow_plate.position + Vector2(12.0, 5.0), glow_plate.end - Vector2(12.0, 8.0), Color(1.0, 0.88, 0.46, 0.36), 2.0)
		elif is_faded:
			for slash in range(3):
				var x := size.x - 68.0 + float(slash) * 15.0
				draw_line(Vector2(x, 36.0), Vector2(x + 28.0, 20.0), Color(0.02, 0.009, 0.004, 0.22), 1.5)

	func _draw_claim_ticket_edges(brass: Color, is_faded: bool, is_equipped: bool) -> void:
		var alpha := 0.16 if not is_faded else 0.06
		if is_equipped:
			alpha = 0.28
		var punch_color := Color(1.0, 0.74, 0.28, alpha)
		var shadow := Color(0.025, 0.01, 0.004, 0.36)
		for side_index in range(2):
			var y := 10.0 if side_index == 0 else size.y - 15.0
			for tooth in range(6):
				var x := 50.0 + float(tooth) * maxf(20.0, (size.x - 100.0) / 5.0)
				if x < size.x - 46.0:
					draw_rect(Rect2(Vector2(x, y), Vector2(8.0, 3.0)), shadow, true)
					draw_line(Vector2(x + 1.0, y + 1.0), Vector2(x + 7.0, y + 1.0), punch_color, 1.0)
		for punched in [Vector2(20.0, size.y * 0.5), Vector2(size.x - 20.0, size.y * 0.5)]:
			draw_circle(punched, 4.2, Color(0.02, 0.008, 0.004, 0.42))
			draw_arc(punched, 4.2, -0.4, PI * 1.15, 14, brass.lightened(0.08), 1.0)
		var ledger_rule_alpha := 0.08 if not is_faded else 0.035
		for rule in range(3):
			var y := 58.0 + float(rule) * maxf(17.0, (size.y - 100.0) / 2.0)
			draw_line(Vector2(48.0, y), Vector2(size.x - 48.0, y - 1.0), Color(1.0, 0.78, 0.34, ledger_rule_alpha), 1.0)

	func _draw_loadout_bounty_seal(center: Vector2, brass: Color, is_faded: bool, is_equipped: bool) -> void:
		var seal_alpha := 0.24 if not is_faded else 0.09
		if is_equipped:
			seal_alpha = 0.46
		var red_wax := Color(0.5, 0.05, 0.025, seal_alpha)
		draw_circle(center + Vector2(1.0, 2.0), 10.0, Color(0.02, 0.008, 0.004, 0.26))
		draw_circle(center, 8.0, red_wax)
		draw_arc(center, 8.2, -0.2, TAU - 0.2, 18, brass.lightened(0.18), seal_alpha * 1.2)
		if is_equipped:
			draw_line(center + Vector2(-5.0, 0.0), center + Vector2(-1.0, 5.0), Color(1.0, 0.82, 0.4, 0.58), 1.6)
			draw_line(center + Vector2(-1.0, 5.0), center + Vector2(6.0, -5.0), Color(1.0, 0.82, 0.4, 0.58), 1.6)
		else:
			draw_line(center + Vector2(-4.0, -2.0), center + Vector2(4.0, 2.0), Color(1.0, 0.78, 0.34, seal_alpha), 1.2)
			draw_line(center + Vector2(-4.0, 3.0), center + Vector2(4.0, -3.0), Color(1.0, 0.78, 0.34, seal_alpha * 0.8), 1.2)

class MenuNavButton extends Button:
	const VISUAL_VERSION := "menu_nav_bounty_receipt_badge_press_hardware_v10"
	const TACTILE_MARKER_COUNT := 46
	const REDRAW_GATE_VERSION := "menu_nav_state_redraw_gate_v1"
	var nav_id := ""
	var selected := false

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_tactile_marker_count() -> int:
		return TACTILE_MARKER_COUNT

	func get_redraw_gate_version() -> String:
		return REDRAW_GATE_VERSION

	func set_nav_state(id: String, is_selected: bool) -> void:
		var should_redraw := nav_id != id or selected != is_selected
		nav_id = id
		selected = is_selected
		if should_redraw:
			queue_redraw()

	func _draw() -> void:
		var rect := Rect2(Vector2.ZERO, size)
		if size.x <= 2.0 or size.y <= 2.0:
			return
		var hovered := is_hovered()
		var pressed := button_pressed or selected
		var press_offset := Vector2(0.0, 1.5) if button_pressed else Vector2.ZERO
		rect.position += press_offset
		var leather := Color(0.095, 0.036, 0.016, 0.96)
		if hovered:
			leather = Color(0.15, 0.062, 0.026, 0.98)
		if pressed:
			leather = Color(0.19, 0.078, 0.03, 0.99)
		var brass := Color(0.86, 0.52, 0.18, 0.78)
		if hovered:
			brass = Color(1.0, 0.66, 0.24, 0.9)
		if selected:
			brass = Color(1.0, 0.78, 0.34, 0.96)
		draw_rect(Rect2(Vector2(4.0, 5.0), size), Color(0.0, 0.0, 0.0, 0.34), true)
		if hovered or selected:
			draw_rect(Rect2(Vector2(2.0, 3.0), size + Vector2(2.0, 0.0)), Color(1.0, 0.55, 0.14, 0.055 if hovered else 0.08), true)
		if selected:
			draw_rect(Rect2(rect.position + Vector2(0.0, 4.0), Vector2(7.0, maxf(0.0, rect.size.y - 8.0))), Color(0.95, 0.58, 0.18, 0.52), true)
			draw_line(rect.position + Vector2(7.0, 7.0), rect.position + Vector2(7.0, rect.size.y - 7.0), Color(1.0, 0.82, 0.34, 0.74), 2.0)
		draw_rect(rect, Color(0.035, 0.014, 0.006, 0.98), true)
		draw_rect(rect.grow(-3.0), leather, true)
		var rail_alpha := 0.18 if selected else 0.1
		var rail_rect := Rect2(rect.position + Vector2(46.0, 9.0), Vector2(maxf(0.0, rect.size.x - 92.0), maxf(0.0, rect.size.y - 18.0)))
		draw_rect(rail_rect, Color(0.035, 0.014, 0.006, 0.32), true)
		draw_line(rail_rect.position + Vector2(0.0, 2.0), rail_rect.position + Vector2(rail_rect.size.x, 0.0), Color(1.0, 0.72, 0.24, rail_alpha), 2.0)
		draw_line(rail_rect.position + Vector2(0.0, rail_rect.size.y - 1.0), rail_rect.end - Vector2(0.0, 2.0), Color(0.015, 0.006, 0.003, 0.48), 2.0)
		for shell in range(3):
			var shell_x := rail_rect.position.x + 9.0 + float(shell) * 17.0
			if shell_x < rail_rect.end.x - 12.0:
				var shell_alpha := 0.18 if not selected else 0.32
				draw_rect(Rect2(Vector2(shell_x, rail_rect.position.y + 4.0), Vector2(10.0, rail_rect.size.y - 8.0)), Color(0.1, 0.043, 0.016, 0.42), true)
				draw_line(Vector2(shell_x + 2.0, rail_rect.position.y + 5.0), Vector2(shell_x + 2.0, rail_rect.end.y - 5.0), Color(1.0, 0.72, 0.28, shell_alpha), 1.4)
				draw_circle(Vector2(shell_x + 5.0, rail_rect.end.y - 7.0), 2.0, Color(1.0, 0.78, 0.3, shell_alpha + 0.08))
		for plank in range(3):
			var plank_y := rect.position.y + 13.0 + float(plank) * maxf(6.0, (rect.size.y - 26.0) / 2.0)
			draw_line(rect.position + Vector2(18.0, plank_y), rect.position + Vector2(rect.size.x - 18.0, plank_y - 1.0), Color(1.0, 0.68, 0.24, 0.08 if not selected else 0.13), 1.1)
		draw_rect(Rect2(rect.position + Vector2(7.0, 6.0), Vector2(maxf(0.0, rect.size.x - 14.0), 5.0)), Color(1.0, 0.62, 0.18, 0.1 if not selected else 0.18), true)
		draw_rect(Rect2(rect.position + Vector2(7.0, rect.size.y - 11.0), Vector2(maxf(0.0, rect.size.x - 14.0), 4.0)), Color(0.02, 0.008, 0.004, 0.28), true)
		draw_rect(rect, brass.darkened(0.12), false, 2.0)
		draw_rect(rect.grow(-5.0), Color(1.0, 0.75, 0.28, 0.2 if not selected else 0.36), false, 1.2)
		_draw_bounty_receipt_edge(rect, brass, selected, hovered)
		_draw_nav_endcap_hardware(rect, brass, selected, hovered)
		_draw_nav_press_hardware(rect, brass, pressed, hovered, selected)
		for notch in range(4):
			var notch_x := rect.position.x + 52.0 + float(notch) * maxf(20.0, (rect.size.x - 112.0) / 3.0)
			if notch_x < rect.end.x - 46.0:
				draw_line(Vector2(notch_x, rect.position.y + 5.0), Vector2(notch_x + 8.0, rect.position.y + 5.0), Color(0.04, 0.016, 0.007, 0.4), 1.4)
				draw_line(Vector2(notch_x, rect.end.y - 5.0), Vector2(notch_x + 8.0, rect.end.y - 5.0), Color(1.0, 0.72, 0.26, 0.16), 1.2)
		for primer in range(4):
			var primer_x := rect.position.x + 58.0 + float(primer) * maxf(18.0, (rect.size.x - 116.0) / 3.0)
			if primer_x < rect.end.x - 48.0:
				draw_circle(Vector2(primer_x, rect.position.y + rect.size.y - 8.0), 2.0, Color(1.0, 0.76, 0.28, 0.22 if selected else 0.12))
		draw_line(rect.position + Vector2(13.0, 8.0), rect.position + Vector2(size.x - 13.0, 7.0), Color(1.0, 0.72, 0.28, 0.32 if hovered or selected else 0.2), 1.5)
		draw_line(rect.position + Vector2(13.0, size.y - 8.0), rect.position + Vector2(size.x - 13.0, size.y - 7.0), Color(0.0, 0.0, 0.0, 0.4), 2.0)
		for tab in range(3):
			var tab_x := rect.position.x + 68.0 + float(tab) * maxf(26.0, (rect.size.x - 136.0) / 2.0)
			if tab_x < rect.end.x - 62.0:
				var tab_rect := Rect2(Vector2(tab_x, rect.position.y + 2.0), Vector2(12.0, 8.0))
				draw_rect(tab_rect, Color(0.08, 0.032, 0.012, 0.46), true)
				draw_rect(tab_rect.grow(-2.0), brass.darkened(0.05), true)
				draw_line(tab_rect.position + Vector2(2.0, 1.0), tab_rect.position + Vector2(10.0, 1.0), Color(1.0, 0.84, 0.42, 0.34), 1.0)
		if hovered or selected:
			draw_line(rect.position + Vector2(8.0, size.y * 0.5), rect.position + Vector2(20.0, size.y * 0.5), brass.lightened(0.16), 2.0)
			draw_line(rect.position + Vector2(size.x - 20.0, size.y * 0.5), rect.position + Vector2(size.x - 8.0, size.y * 0.5), brass.lightened(0.16), 2.0)
			for tick in range(3):
				var tick_y := rect.position.y + 14.0 + float(tick) * maxf(5.0, (size.y - 28.0) / 2.0)
				draw_line(Vector2(rect.position.x + 5.0, tick_y), Vector2(rect.position.x + 12.0, tick_y + 2.0), brass.lightened(0.08), 1.3)
				draw_line(Vector2(rect.end.x - 12.0, tick_y + 2.0), Vector2(rect.end.x - 5.0, tick_y), brass.lightened(0.08), 1.3)
		for rivet in [rect.position + Vector2(10.0, 10.0), rect.position + Vector2(size.x - 10.0, 10.0), rect.position + Vector2(10.0, size.y - 10.0), rect.position + Vector2(size.x - 10.0, size.y - 10.0)]:
			draw_circle(rivet, 2.6, Color(0.04, 0.018, 0.008, 0.7))
			draw_circle(rivet + Vector2(-0.7, -0.7), 1.5, brass)
		var icon_center := rect.position + Vector2(28.0, size.y * 0.5)
		draw_rect(Rect2(icon_center + Vector2(-17.0, -15.0), Vector2(34.0, 30.0)), Color(0.11, 0.045, 0.018, 0.34), true)
		draw_rect(Rect2(icon_center + Vector2(-14.0, -12.0), Vector2(28.0, 24.0)), Color(0.42, 0.25, 0.11, 0.18 if not selected else 0.28), false, 1.2)
		draw_rect(Rect2(icon_center + Vector2(-11.0, -9.0), Vector2(22.0, 18.0)), Color(1.0, 0.68, 0.22, 0.055 if not selected else 0.12), true)
		draw_circle(icon_center, 14.0, Color(0.045, 0.019, 0.008, 0.86))
		draw_arc(icon_center, 14.0, -0.75, PI + 0.45, 22, brass, 2.0)
		draw_arc(icon_center + Vector2(1.0, 1.0), 10.0, PI * 0.1, PI * 1.25, 18, Color(0.0, 0.0, 0.0, 0.32), 1.4)
		draw_line(icon_center + Vector2(-11.0, -11.0), icon_center + Vector2(10.0, -12.0), Color(1.0, 0.82, 0.38, 0.22 if not selected else 0.34), 1.2)
		draw_line(icon_center + Vector2(-12.0, 11.0), icon_center + Vector2(11.0, 10.0), Color(0.0, 0.0, 0.0, 0.38), 1.4)
		if hovered or selected:
			draw_arc(icon_center, 17.0, -0.55, PI + 0.35, 24, brass.lightened(0.2), 1.4)
			draw_circle(icon_center + Vector2(-5.0, -5.0), 2.0, Color(1.0, 0.88, 0.5, 0.42))
			_draw_nav_bounty_star(icon_center + Vector2(0.0, 15.0), brass, selected)
		_draw_nav_icon(icon_center, brass.lightened(0.12))
		if selected:
			var stamp := Rect2(rect.position + Vector2(size.x - 40.0, 9.0), Vector2(24.0, size.y - 18.0))
			draw_rect(stamp, Color(0.05, 0.019, 0.008, 0.5), true)
			draw_rect(stamp, Color(1.0, 0.72, 0.24, 0.36), false, 1.5)
			draw_line(stamp.position + Vector2(5.0, 5.0), stamp.end - Vector2(5.0, 5.0), Color(1.0, 0.74, 0.28, 0.22), 1.4)
			draw_line(stamp.position + Vector2(5.0, stamp.size.y - 5.0), stamp.position + Vector2(stamp.size.x - 5.0, 5.0), Color(1.0, 0.74, 0.28, 0.16), 1.2)
			draw_line(rect.position + Vector2(size.x - 33.0, size.y * 0.5), rect.position + Vector2(size.x - 15.0, size.y * 0.5), Color(1.0, 0.82, 0.36, 0.82), 3.0)
			draw_line(rect.position + Vector2(size.x - 22.0, size.y * 0.5 - 7.0), rect.position + Vector2(size.x - 15.0, size.y * 0.5), Color(1.0, 0.82, 0.36, 0.82), 3.0)
			draw_line(rect.position + Vector2(size.x - 22.0, size.y * 0.5 + 7.0), rect.position + Vector2(size.x - 15.0, size.y * 0.5), Color(1.0, 0.82, 0.36, 0.82), 3.0)
			_draw_selected_nav_badge(stamp.get_center(), brass)
		var font := ThemeDB.fallback_font
		if font != null:
			var label_color := Color(1.0, 0.9, 0.74, 0.98)
			if hovered:
				label_color = Color(1.0, 0.82, 0.38, 0.98)
			if selected:
				label_color = Color(1.0, 0.86, 0.46, 1.0)
			var label_rect := Rect2(rect.position + Vector2(51.0, 0.0), Vector2(maxf(0.0, size.x - 86.0), size.y))
			_draw_nav_label_backplate(label_rect, brass, selected, hovered)
			if selected:
				draw_line(label_rect.position + Vector2(12.0, size.y - 10.0), label_rect.position + Vector2(label_rect.size.x - 12.0, size.y - 10.0), Color(1.0, 0.74, 0.26, 0.46), 1.8)
			draw_string(font, label_rect.position + Vector2(1.0, size.y * 0.62 + 1.0), text, HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 16, Color(0.02, 0.009, 0.004, 0.92))
			draw_string(font, label_rect.position + Vector2(0.0, size.y * 0.62), text, HORIZONTAL_ALIGNMENT_CENTER, label_rect.size.x, 16, label_color)

	func _draw_bounty_receipt_edge(rect: Rect2, brass: Color, selected_state: bool, hovered_state: bool) -> void:
		var alpha := 0.18 if not selected_state else 0.32
		if hovered_state:
			alpha += 0.06
		var tooth_color := Color(1.0, 0.74, 0.28, alpha)
		var cut_shadow := Color(0.018, 0.007, 0.003, 0.46)
		for side_index in range(2):
			var y := rect.position.y + 3.0 if side_index == 0 else rect.end.y - 6.0
			for tooth in range(5):
				var x := rect.position.x + 66.0 + float(tooth) * maxf(18.0, (rect.size.x - 132.0) / 4.0)
				if x < rect.end.x - 54.0:
					draw_rect(Rect2(Vector2(x, y), Vector2(7.0, 3.0)), cut_shadow, true)
					draw_line(Vector2(x + 1.0, y + 1.0), Vector2(x + 6.0, y + 1.0), tooth_color, 1.0)
		var punch_left := rect.position + Vector2(42.0, rect.size.y * 0.5)
		var punch_right := rect.position + Vector2(rect.size.x - 42.0, rect.size.y * 0.5)
		for punch in [punch_left, punch_right]:
			draw_circle(punch, 4.0, Color(0.02, 0.008, 0.004, 0.5))
			draw_circle(punch + Vector2(-0.8, -0.6), 2.2, Color(0.52, 0.27, 0.1, 0.18 if not selected_state else 0.28))
			draw_arc(punch, 4.0, -0.2, PI * 1.18, 12, brass.lightened(0.14), 1.0)
		if selected_state:
			var stamp_center := rect.position + Vector2(rect.size.x - 28.0, rect.size.y - 14.0)
			draw_circle(stamp_center + Vector2(1.0, 1.0), 6.6, Color(0.03, 0.008, 0.004, 0.42))
			draw_arc(stamp_center, 6.2, -0.4, TAU - 0.4, 18, Color(0.9, 0.12, 0.07, 0.5), 1.4)
			draw_line(stamp_center + Vector2(-4.0, 0.0), stamp_center + Vector2(4.0, 0.0), Color(0.9, 0.12, 0.07, 0.44), 1.2)

	func _draw_nav_label_backplate(label_rect: Rect2, brass: Color, selected_state: bool, hovered_state: bool) -> void:
		var plate := Rect2(
			label_rect.position + Vector2(8.0, maxf(5.0, size.y * 0.2)),
			Vector2(maxf(0.0, label_rect.size.x - 16.0), maxf(8.0, size.y * 0.58))
		)
		var plate_alpha := 0.28 if not selected_state else 0.42
		if hovered_state:
			plate_alpha += 0.08
		draw_rect(plate, Color(0.035, 0.014, 0.006, plate_alpha), true)
		draw_line(plate.position + Vector2(4.0, 2.0), plate.position + Vector2(plate.size.x - 4.0, 2.0), Color(1.0, 0.72, 0.28, 0.12 if not selected_state else 0.24), 1.0)
		draw_line(plate.position + Vector2(4.0, plate.size.y - 2.0), plate.position + Vector2(plate.size.x - 4.0, plate.size.y - 2.0), Color(0.0, 0.0, 0.0, 0.34), 1.0)
		if selected_state:
			draw_rect(plate.grow(-3.0), Color(1.0, 0.74, 0.26, 0.08), true)
			draw_rect(plate.grow(-1.0), brass.darkened(0.08), false, 1.0)

	func _draw_nav_endcap_hardware(rect: Rect2, brass: Color, selected_state: bool, hovered_state: bool) -> void:
		var cap_alpha := 0.58 if selected_state else 0.34
		if hovered_state:
			cap_alpha += 0.12
		var cap_color := Color(0.9, 0.52, 0.18, cap_alpha)
		var shadow := Color(0.018, 0.007, 0.003, 0.62)
		for side_index in range(2):
			var side_sign := -1.0 if side_index == 0 else 1.0
			var cap_x := rect.position.x + 4.0 if side_index == 0 else rect.end.x - 22.0
			var cap := Rect2(Vector2(cap_x, rect.position.y + 8.0), Vector2(18.0, rect.size.y - 16.0))
			draw_rect(cap, shadow, true)
			draw_rect(cap.grow(-3.0), Color(0.13, 0.052, 0.02, 0.64), true)
			draw_line(cap.position + Vector2(3.0, 4.0), cap.position + Vector2(3.0, cap.size.y - 4.0), cap_color, 1.2)
			draw_line(cap.end - Vector2(4.0, cap.size.y - 4.0), cap.end - Vector2(4.0, 4.0), Color(1.0, 0.78, 0.32, cap_alpha * 0.72), 1.2)
			draw_line(cap.get_center() + Vector2(-5.0 * side_sign, -7.0), cap.get_center() + Vector2(5.0 * side_sign, -1.0), brass, 1.3)
			draw_line(cap.get_center() + Vector2(-5.0 * side_sign, 7.0), cap.get_center() + Vector2(5.0 * side_sign, 1.0), brass.darkened(0.08), 1.3)
			for rivet_y in [cap.position.y + 5.0, cap.end.y - 5.0]:
				draw_circle(Vector2(cap.get_center().x, rivet_y), 2.0, shadow)
				draw_circle(Vector2(cap.get_center().x - 0.5, rivet_y - 0.5), 1.1, cap_color)

	func _draw_nav_press_hardware(rect: Rect2, brass: Color, pressed_state: bool, hovered_state: bool, selected_state: bool) -> void:
		var alpha := 0.18
		if hovered_state:
			alpha = 0.25
		if selected_state:
			alpha = 0.34
		if pressed_state:
			alpha = 0.42
		var dark := Color(0.012, 0.005, 0.002, 0.34 + alpha * 0.25)
		var shine := Color(1.0, 0.76, 0.3, alpha)
		var inset := rect.grow(-8.0)
		draw_line(inset.position + Vector2(7.0, 3.0), inset.position + Vector2(inset.size.x - 7.0, 1.0), shine, 1.1)
		draw_line(inset.position + Vector2(6.0, inset.size.y - 2.0), inset.end - Vector2(6.0, 3.0), dark, 2.2 if pressed_state else 1.6)
		for hinge in range(2):
			var x := rect.position.x + 33.0 if hinge == 0 else rect.end.x - 33.0
			var y := rect.position.y + rect.size.y * 0.5
			draw_rect(Rect2(Vector2(x - 5.0, y - 9.0), Vector2(10.0, 18.0)), Color(0.04, 0.016, 0.007, 0.36), true)
			draw_line(Vector2(x - 2.0, y - 6.0), Vector2(x - 2.0, y + 6.0), shine, 1.0)
			draw_line(Vector2(x + 3.0, y - 5.0), Vector2(x + 3.0, y + 5.0), dark, 1.0)
			draw_circle(Vector2(x, y - 8.0), 1.7, brass.lightened(0.12))
			draw_circle(Vector2(x, y + 8.0), 1.7, brass.darkened(0.08))
		if pressed_state:
			draw_rect(rect.grow(-6.0), Color(0.0, 0.0, 0.0, 0.08), true)
			draw_line(rect.position + Vector2(18.0, rect.size.y - 13.0), rect.end - Vector2(18.0, 13.0), Color(1.0, 0.78, 0.32, 0.22), 2.0)

	func _draw_nav_bounty_star(center: Vector2, brass: Color, selected_state: bool) -> void:
		var alpha := 0.22 if not selected_state else 0.42
		var star := PackedVector2Array()
		for point in range(10):
			var radius := 5.5 if point % 2 == 0 else 2.7
			var angle := -PI * 0.5 + float(point) * TAU / 10.0
			star.append(center + Vector2(cos(angle), sin(angle)) * radius)
		draw_colored_polygon(star, Color(0.08, 0.03, 0.012, 0.42))
		draw_polyline(star, Color(1.0, 0.78, 0.32, alpha), 0.9, true)
		draw_circle(center, 1.7, brass.lightened(0.16))

	func _draw_selected_nav_badge(center: Vector2, brass: Color) -> void:
		var badge := PackedVector2Array()
		for point in range(10):
			var radius := 9.0 if point % 2 == 0 else 5.2
			var angle := -PI * 0.5 + float(point) * TAU / 10.0
			badge.append(center + Vector2(cos(angle), sin(angle)) * radius)
		draw_colored_polygon(badge, Color(0.1, 0.038, 0.014, 0.82))
		draw_polyline(badge, Color(1.0, 0.78, 0.32, 0.74), 1.3, true)
		draw_circle(center, 4.6, brass.lightened(0.18))
		draw_circle(center, 1.8, Color(0.04, 0.016, 0.007, 0.7))

	func _draw_nav_icon(center: Vector2, color: Color) -> void:
		var dark := Color(0.018, 0.008, 0.004, color.a * 0.62)
		var bone := Color(1.0, 0.9, 0.66, color.a * 0.74)
		match nav_id:
			"PLAY":
				draw_line(center + Vector2(-8.0, -8.0), center + Vector2(9.0, 0.0), dark, 5.0)
				draw_line(center + Vector2(9.0, 0.0), center + Vector2(-8.0, 8.0), dark, 5.0)
				draw_line(center + Vector2(-6.0, -7.0), center + Vector2(8.0, 0.0), color, 2.8)
				draw_line(center + Vector2(8.0, 0.0), center + Vector2(-6.0, 7.0), color, 2.8)
				draw_circle(center + Vector2(-10.0, 0.0), 2.4, bone)
			"SWORDS":
				draw_line(center + Vector2(-9.0, 8.0), center + Vector2(8.0, -9.0), dark, 5.0)
				draw_line(center + Vector2(9.0, 8.0), center + Vector2(-8.0, -9.0), dark, 4.0)
				draw_line(center + Vector2(-8.0, 7.0), center + Vector2(8.0, -9.0), bone, 2.2)
				draw_line(center + Vector2(8.0, 7.0), center + Vector2(-7.0, -8.0), color, 2.2)
				draw_line(center + Vector2(-2.0, 6.0), center + Vector2(-8.0, 1.0), color.darkened(0.2), 2.0)
			"GUNS":
				draw_line(center + Vector2(-11.0, 5.0), center + Vector2(11.0, -5.0), dark, 6.0)
				draw_line(center + Vector2(-9.0, 4.0), center + Vector2(11.0, -5.0), color, 2.8)
				draw_line(center + Vector2(-5.0, 6.0), center + Vector2(-11.0, 12.0), dark, 4.0)
				draw_arc(center + Vector2(-2.0, 1.0), 6.5, -0.3, PI * 1.1, 14, color.darkened(0.12), 2.0)
				draw_circle(center + Vector2(1.0, 0.0), 3.0, bone)
			"ABILITIES":
				draw_arc(center, 10.0, 0.0, TAU, 28, dark, 4.0)
				draw_arc(center, 9.0, 0.0, TAU, 28, color, 2.0)
				draw_line(center + Vector2(-12.0, 0.0), center + Vector2(12.0, 0.0), color, 2.0)
				draw_line(center + Vector2(0.0, -12.0), center + Vector2(0.0, 12.0), color, 2.0)
				draw_circle(center, 3.0, bone)
			"QUESTS":
				var poster := Rect2(center + Vector2(-9.0, -10.0), Vector2(18.0, 20.0))
				draw_rect(poster, dark, true)
				draw_rect(poster.grow(-2.0), Color(0.72, 0.47, 0.2, color.a * 0.34), true)
				draw_rect(poster.grow(-1.0), color.darkened(0.2), false, 1.5)
				draw_line(center + Vector2(-5.0, 0.0), center + Vector2(0.0, 5.0), bone, 2.0)
				draw_line(center + Vector2(0.0, 5.0), center + Vector2(7.0, -5.0), bone, 2.0)
			"INFORMATION":
				draw_line(center + Vector2(0.0, -10.0), center + Vector2(0.0, 10.0), dark, 5.0)
				draw_circle(center + Vector2(0.0, -7.0), 3.0, bone)
				draw_line(center + Vector2(0.0, -1.0), center + Vector2(0.0, 8.0), color, 3.0)
				draw_line(center + Vector2(-6.0, 10.0), center + Vector2(6.0, 10.0), color, 2.0)
			_:
				draw_circle(center, 6.0, color)

class MenuBackdrop extends Control:
	const VISUAL_VERSION := "menu_backdrop_static_low_batch_v1"
	const TOWN_SQUARE_CUE_COUNT := 32
	const TITLE_PLAQUE_MARKER_COUNT := 14

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_town_square_cue_count() -> int:
		return TOWN_SQUARE_CUE_COUNT

	func get_title_plaque_marker_count() -> int:
		return TITLE_PLAQUE_MARKER_COUNT

	func _draw() -> void:
		var viewport_rect := Rect2(Vector2.ZERO, size)
		draw_rect(viewport_rect, Color(0.045, 0.02, 0.011, 0.98), true)
		if size.x <= 1.0 or size.y <= 1.0:
			return

		var horizon_y := size.y * 0.38
		draw_rect(Rect2(Vector2(0.0, 0.0), Vector2(size.x, horizon_y)), Color(0.18, 0.075, 0.03, 0.82), true)
		draw_rect(Rect2(Vector2(0.0, horizon_y), Vector2(size.x, size.y - horizon_y)), Color(0.08, 0.034, 0.018, 0.96), true)

		for i in range(4):
			var t := float(i) / 8.0
			var y := horizon_y * t
			draw_rect(Rect2(Vector2(0.0, y), Vector2(size.x, horizon_y / 8.0 + 1.0)), Color(0.62, 0.31, 0.11, 0.06 + t * 0.035), true)

		var sun_center := Vector2(size.x * 0.5, size.y * 0.18)
		for ring in range(3):
			draw_circle(sun_center, 126.0 - ring * 32.0, Color(1.0, 0.58, 0.16, 0.02))
		for ray in range(5):
			var angle := -PI * 0.86 + float(ray) * PI * 1.72 / 4.0
			var end_point := sun_center + Vector2(cos(angle), sin(angle)) * maxf(size.x, size.y)
			draw_line(sun_center, end_point, Color(1.0, 0.62, 0.2, 0.04), 22.0)

		var street_y := horizon_y - 12.0
		var building_width := maxf(120.0, size.x / 5.6)
		for i in range(6):
			var x := float(i) * building_width - building_width * 0.22
			var height := 78.0 + float((i * 29) % 42)
			var front := Rect2(Vector2(x, street_y - height), Vector2(building_width * 0.88, height))
			var roof := Rect2(front.position - Vector2(4.0, 14.0), Vector2(front.size.x + 8.0, 18.0))
			draw_rect(Rect2(front.position + Vector2(8.0, 10.0), front.size), Color(0.0, 0.0, 0.0, 0.22), true)
			draw_rect(front, Color(0.07, 0.028, 0.014, 0.88), true)
			draw_rect(front.grow(-5.0), Color(0.18, 0.076, 0.034, 0.82), true)
			draw_rect(roof, Color(0.035, 0.014, 0.007, 0.86), true)
			draw_line(roof.position + Vector2(10.0, 5.0), roof.end - Vector2(10.0, 12.0), Color(0.9, 0.48, 0.15, 0.24), 2.0)
			var sign := Rect2(front.position + Vector2(14.0, 18.0), Vector2(maxf(42.0, front.size.x - 28.0), 16.0))
			draw_rect(sign, Color(0.09, 0.034, 0.014, 0.78), true)
			draw_rect(sign, Color(0.94, 0.52, 0.16, 0.26), false, 1.2)
			var window_y := front.position.y + 47.0
			for w in range(2):
				var window := Rect2(Vector2(front.position.x + 18.0 + float(w) * maxf(34.0, front.size.x * 0.46), window_y), Vector2(18.0, 24.0))
				draw_rect(window, Color(0.04, 0.018, 0.01, 0.84), true)
				draw_rect(window.grow(-3.0), Color(0.96, 0.62, 0.22, 0.19), true)
			if i % 3 == 0:
				draw_circle(front.get_center() + Vector2(0.0, -9.0), 8.0, Color(0.96, 0.58, 0.18, 0.22))
			elif i % 3 == 1:
				draw_line(Vector2(front.end.x - 18.0, front.position.y + 42.0), Vector2(front.end.x - 18.0, street_y - 8.0), Color(0.95, 0.8, 0.62, 0.34), 3.0)
			else:
				draw_rect(Rect2(Vector2(front.position.x + 20.0, street_y - 22.0), Vector2(36.0, 15.0)), Color(0.12, 0.05, 0.02, 0.58), true)
		draw_line(Vector2(0.0, street_y + 4.0), Vector2(size.x, street_y + 2.0), Color(0.98, 0.58, 0.18, 0.2), 4.0)
		draw_line(Vector2(0.0, street_y + 14.0), Vector2(size.x, street_y + 12.0), Color(0.0, 0.0, 0.0, 0.26), 3.0)

		var street_bottom := size.y - 124.0
		for lane in range(3):
			var t := float(lane) / 2.0
			var y := lerpf(street_y + 36.0, street_bottom - 18.0, t)
			draw_line(Vector2(size.x * 0.12, y), Vector2(size.x * 0.88, y + sin(float(lane)) * 14.0), Color(0.018, 0.008, 0.004, 0.2), 7.0)
			draw_line(Vector2(size.x * 0.14, y - 4.0), Vector2(size.x * 0.86, y + sin(float(lane)) * 14.0 - 4.0), Color(0.92, 0.58, 0.22, 0.08), 2.0)
		for post in range(5):
			var x := 30.0 + float(post) * maxf(108.0, size.x / 4.6)
			draw_line(Vector2(x, street_y - 10.0), Vector2(x, street_y + 38.0), Color(0.05, 0.02, 0.01, 0.72), 4.0)
			draw_circle(Vector2(x + 14.0, street_y - 20.0), 12.0, Color(1.0, 0.5, 0.12, 0.04))
			draw_circle(Vector2(x + 14.0, street_y - 20.0), 4.0, Color(1.0, 0.68, 0.22, 0.28))

		var board_y := size.y - 132.0
		for plank in range(5):
			var y := board_y + plank * 24.0
			draw_rect(Rect2(Vector2(0.0, y), Vector2(size.x, 15.0)), Color(0.12 + float(plank % 2) * 0.018, 0.056, 0.026, 0.88), true)
			draw_line(Vector2(0.0, y + 2.0), Vector2(size.x, y + 1.0), Color(0.86, 0.48, 0.2, 0.13), 2.0)
			draw_line(Vector2(0.0, y + 16.0), Vector2(size.x, y + 17.0), Color(0.018, 0.009, 0.005, 0.22), 2.0)

		var sign_rect := Rect2(Vector2(size.x * 0.5 - 315.0, 38.0), Vector2(630.0, 112.0))
		draw_rect(Rect2(sign_rect.position + Vector2(10.0, 12.0), sign_rect.size), Color(0.012, 0.006, 0.003, 0.42), true)
		draw_rect(sign_rect, Color(0.16, 0.064, 0.026, 0.62), true)
		draw_rect(sign_rect, Color(0.92, 0.55, 0.2, 0.32), false, 4.0)
		draw_line(sign_rect.position + Vector2(32.0, sign_rect.size.y - 20.0), sign_rect.end - Vector2(32.0, 20.0), Color(1.0, 0.68, 0.24, 0.26), 3.0)
		_draw_title_hanging_sign_details(sign_rect)

		for i in range(16):
			var x := float((i * 97) % int(maxf(size.x, 2.0)))
			var y := float((i * 53) % int(maxf(size.y, 2.0)))
			var radius := 1.0 + float(i % 3)
			draw_circle(Vector2(x, y), radius, Color(0.94, 0.62, 0.28, 0.07))

		var edge_color := Color(0.0, 0.0, 0.0, 0.16)
		for edge in range(4):
			var alpha := 0.018 + float(edge) * 0.018
			edge_color.a = alpha
			draw_rect(Rect2(Vector2(edge * 6.0, edge * 5.0), size - Vector2(edge * 12.0, edge * 10.0)), edge_color, false, 10.0)
		return

	func _draw_title_hanging_sign_details(sign_rect: Rect2) -> void:
		var brass := Color(1.0, 0.66, 0.22, 0.44)
		var bright := Color(1.0, 0.82, 0.38, 0.5)
		var dark := Color(0.03, 0.012, 0.005, 0.72)
		for side in [-1.0, 1.0]:
			var anchor := sign_rect.position + Vector2(sign_rect.size.x * (0.19 if side < 0.0 else 0.81), 4.0)
			draw_line(anchor + Vector2(-8.0 * side, -42.0), anchor, dark, 5.0)
			draw_line(anchor + Vector2(-8.0 * side, -42.0), anchor, brass, 1.5)
			for link in range(4):
				var link_center := anchor + Vector2(-8.0 * side, -34.0 + float(link) * 10.0)
				draw_arc(link_center, 4.5, 0.0, TAU, 14, bright, 1.2)
		for corner in [
			sign_rect.position + Vector2(18.0, 18.0),
			sign_rect.position + Vector2(sign_rect.size.x - 18.0, 18.0),
			sign_rect.position + Vector2(18.0, sign_rect.size.y - 18.0),
			sign_rect.position + Vector2(sign_rect.size.x - 18.0, sign_rect.size.y - 18.0)
		]:
			draw_circle(corner, 6.0, dark)
			draw_circle(corner + Vector2(-1.2, -1.2), 3.2, brass)
		for stripe in range(4):
			var y := sign_rect.position.y + 24.0 + float(stripe) * 18.0
			draw_line(Vector2(sign_rect.position.x + 44.0, y), Vector2(sign_rect.end.x - 44.0, y - 2.0), Color(1.0, 0.74, 0.28, 0.08), 1.2)
		var left_plate := PackedVector2Array([
			sign_rect.position + Vector2(0.0, 0.0),
			sign_rect.position + Vector2(42.0, 0.0),
			sign_rect.position + Vector2(24.0, sign_rect.size.y),
			sign_rect.position + Vector2(0.0, sign_rect.size.y),
		])
		var right_plate := PackedVector2Array([
			sign_rect.position + Vector2(sign_rect.size.x - 42.0, 0.0),
			sign_rect.position + Vector2(sign_rect.size.x, 0.0),
			sign_rect.position + Vector2(sign_rect.size.x, sign_rect.size.y),
			sign_rect.position + Vector2(sign_rect.size.x - 24.0, sign_rect.size.y),
		])
		draw_colored_polygon(left_plate, Color(0.055, 0.022, 0.01, 0.34))
		draw_colored_polygon(right_plate, Color(0.055, 0.022, 0.01, 0.34))
		draw_polyline(left_plate, brass, 1.6)
		draw_polyline(right_plate, brass, 1.6)
		for side in [-1.0, 1.0]:
			var star_center := sign_rect.get_center() + Vector2(side * (sign_rect.size.x * 0.405), -1.0)
			_draw_title_marshal_star(star_center, 15.0, brass, bright, dark)
		var center_plate := Rect2(sign_rect.get_center() + Vector2(-46.0, sign_rect.size.y * 0.25 - 8.0), Vector2(92.0, 13.0))
		draw_rect(center_plate, Color(0.04, 0.016, 0.007, 0.42), true)
		draw_rect(center_plate.grow(-2.0), Color(1.0, 0.66, 0.22, 0.12), true)
		draw_line(center_plate.position + Vector2(8.0, 2.0), center_plate.end - Vector2(8.0, 3.0), bright, 1.1)
		for notch in range(5):
			var notch_x := center_plate.position.x + 12.0 + float(notch) * 17.0
			draw_line(Vector2(notch_x, center_plate.position.y + 3.0), Vector2(notch_x + 6.0, center_plate.position.y + 3.0), dark, 1.0)
		for glint in range(3):
			var glint_x := sign_rect.position.x + sign_rect.size.x * (0.31 + float(glint) * 0.19)
			draw_line(Vector2(glint_x, sign_rect.position.y + 15.0), Vector2(glint_x + 34.0, sign_rect.position.y + 8.0), Color(1.0, 0.86, 0.42, 0.18), 1.4)
		for notch in range(8):
			var t := float(notch) / 7.0
			var notch_x := lerpf(sign_rect.position.x + 74.0, sign_rect.end.x - 74.0, t)
			draw_line(Vector2(notch_x, sign_rect.end.y - 18.0), Vector2(notch_x + 7.0, sign_rect.end.y - 13.0), Color(0.04, 0.016, 0.006, 0.42), 1.1)
			if notch % 2 == 0:
				draw_circle(Vector2(notch_x + 4.0, sign_rect.position.y + 18.0), 2.2, Color(1.0, 0.75, 0.28, 0.26))

	func _draw_title_marshal_star(center: Vector2, radius: float, brass: Color, bright: Color, dark: Color) -> void:
		var star := PackedVector2Array()
		for point in range(10):
			var r := radius if point % 2 == 0 else radius * 0.46
			var angle := -PI * 0.5 + float(point) * TAU / 10.0
			star.append(center + Vector2(cos(angle), sin(angle)) * r)
		draw_colored_polygon(star, Color(0.055, 0.022, 0.01, 0.54))
		draw_polyline(star, brass, 1.5, true)
		draw_circle(center, radius * 0.35, Color(0.96, 0.6, 0.18, 0.22))
		draw_circle(center, radius * 0.16, bright)
		draw_circle(center + Vector2(1.0, 1.0), radius * 0.09, dark)

	func _draw_menu_showdown_foreground_cues(horizon_y: float) -> void:
		var street_y := horizon_y - 12.0
		var bottom_y := size.y - 132.0
		var dust := Color(0.92, 0.58, 0.22, 0.13)
		var dark := Color(0.02, 0.009, 0.004, 0.3)
		for track in range(5):
			var y := lerpf(street_y + 38.0, bottom_y - 18.0, float(track) / 4.0)
			var x_offset := sin(float(track) * 1.7) * 36.0
			draw_polyline(PackedVector2Array([
				Vector2(size.x * 0.04 + x_offset, y + 12.0),
				Vector2(size.x * 0.28 + x_offset * 0.35, y - 6.0),
				Vector2(size.x * 0.56 - x_offset * 0.22, y + 8.0),
				Vector2(size.x * 0.92 - x_offset, y - 3.0),
			]), dark, 3.0)
			draw_polyline(PackedVector2Array([
				Vector2(size.x * 0.05 + x_offset, y + 7.0),
				Vector2(size.x * 0.3 + x_offset * 0.35, y - 10.0),
				Vector2(size.x * 0.57 - x_offset * 0.22, y + 4.0),
				Vector2(size.x * 0.93 - x_offset, y - 8.0),
			]), dust, 1.2)
		for spur in range(10):
			var x := size.x * (0.1 + float(spur) * 0.082)
			var y := lerpf(street_y + 44.0, bottom_y - 28.0, float((spur * 7) % 10) / 9.0)
			draw_line(Vector2(x - 7.0, y), Vector2(x + 7.0, y + 3.0), Color(0.04, 0.017, 0.007, 0.2), 1.5)
			draw_circle(Vector2(x + 10.0, y + 3.0), 1.8, Color(0.95, 0.62, 0.22, 0.12))
		var rail_y := bottom_y - 34.0
		for rail in range(2):
			var y := rail_y + float(rail) * 16.0
			draw_line(Vector2(0.0, y), Vector2(size.x, y - 5.0), Color(0.055, 0.022, 0.01, 0.26), 5.0)
			draw_line(Vector2(0.0, y - 2.0), Vector2(size.x, y - 7.0), Color(0.82, 0.42, 0.14, 0.11), 1.5)
		for post in range(8):
			var x := float(post) * maxf(86.0, size.x / 7.0) + 22.0
			draw_line(Vector2(x, rail_y - 22.0), Vector2(x + 5.0, bottom_y + 10.0), Color(0.035, 0.014, 0.006, 0.34), 4.0)
			draw_line(Vector2(x - 8.0, rail_y - 8.0), Vector2(x + 18.0, rail_y - 12.0), Color(0.78, 0.39, 0.13, 0.18), 2.0)

	func _draw_menu_street_life_cues(horizon_y: float) -> void:
		var street_y := horizon_y - 12.0
		var bottom_y := size.y - 132.0
		var dark := Color(0.016, 0.007, 0.004, 0.5)
		var brass := Color(0.96, 0.55, 0.18, 0.22)
		var leather := Color(0.08, 0.032, 0.014, 0.42)
		_draw_menu_stagecoach_silhouette(Vector2(size.x * 0.52, bottom_y - 28.0), 0.82)
		for side in [-1.0, 1.0]:
			var rack_x: float = size.x * (0.5 + side * 0.22)
			draw_line(Vector2(rack_x - 28.0, bottom_y - 28.0), Vector2(rack_x + 26.0, bottom_y - 31.0), dark, 5.0)
			for loop in range(3):
				var center := Vector2(rack_x - 16.0 + float(loop) * 18.0, bottom_y - 39.0)
				draw_arc(center, 8.0, -0.15, TAU - 0.15, 16, brass, 1.4)
		var wanted_board := Rect2(Vector2(size.x * 0.12, street_y + 18.0), Vector2(78.0, 52.0))
		draw_rect(Rect2(wanted_board.position + Vector2(4.0, 6.0), wanted_board.size), Color(0.0, 0.0, 0.0, 0.18), true)
		draw_rect(wanted_board, leather, true)
		draw_rect(wanted_board.grow(-5.0), Color(0.64, 0.42, 0.18, 0.24), true)
		for row in range(3):
			var y := wanted_board.position.y + 13.0 + float(row) * 11.0
			draw_line(Vector2(wanted_board.position.x + 10.0, y), Vector2(wanted_board.end.x - 10.0, y - 1.0), Color(0.04, 0.016, 0.006, 0.2), 1.2)
		draw_arc(wanted_board.get_center() + Vector2(20.0, 7.0), 12.0, -0.2, TAU - 0.2, 18, Color(0.74, 0.08, 0.035, 0.2), 2.0)
		var trough := Rect2(Vector2(size.x * 0.76, street_y + 62.0), Vector2(92.0, 24.0))
		draw_rect(Rect2(trough.position + Vector2(8.0, 8.0), trough.size), Color(0.0, 0.0, 0.0, 0.14), true)
		draw_rect(trough, Color(0.075, 0.03, 0.014, 0.66), true)
		draw_line(trough.position + Vector2(8.0, 6.0), trough.end - Vector2(8.0, 18.0), brass, 2.0)
		for bottle in range(4):
			var x: float = size.x * 0.04 + float(bottle) * 15.0
			draw_rect(Rect2(Vector2(x, bottom_y - 58.0 + float(bottle % 2) * 4.0), Vector2(5.0, 14.0)), Color(0.88, 0.62, 0.28, 0.22), true)
			draw_circle(Vector2(x + 2.5, bottom_y - 60.0 + float(bottle % 2) * 4.0), 2.0, Color(1.0, 0.82, 0.4, 0.2))

	func _draw_menu_stagecoach_silhouette(position: Vector2, scale: float) -> void:
		var dark := Color(0.015, 0.007, 0.004, 0.48)
		var brass := Color(0.92, 0.46, 0.14, 0.18)
		var body := Rect2(position + Vector2(-72.0, -38.0) * scale, Vector2(144.0, 42.0) * scale)
		draw_line(position + Vector2(-92.0, 15.0) * scale, position + Vector2(106.0, 2.0) * scale, Color(0.0, 0.0, 0.0, 0.16), 13.0 * scale)
		draw_rect(Rect2(body.position + Vector2(8.0, 9.0) * scale, body.size), Color(0.0, 0.0, 0.0, 0.16), true)
		draw_rect(body, dark, true)
		var roof := PackedVector2Array([
			body.position + Vector2(10.0, 2.0) * scale,
			body.position + Vector2(42.0, -20.0) * scale,
			body.position + Vector2(body.size.x - 34.0, -18.0) * scale,
			body.position + Vector2(body.size.x - 6.0, 4.0) * scale,
		])
		draw_colored_polygon(roof, dark.darkened(0.12))
		draw_polyline(roof, brass, 1.4 * scale, true)
		for door in range(3):
			var x := body.position.x + (28.0 + float(door) * 34.0) * scale
			draw_rect(Rect2(Vector2(x, body.position.y + 9.0 * scale), Vector2(20.0, 20.0) * scale), Color(0.96, 0.58, 0.18, 0.08), false, 1.2 * scale)
		for side in [-1.0, 1.0]:
			var wheel := position + Vector2(side * 48.0, 10.0) * scale
			draw_arc(wheel, 18.0 * scale, 0.0, TAU, 24, dark.darkened(0.2), 5.0 * scale)
			draw_arc(wheel, 10.0 * scale, 0.0, TAU, 18, brass, 1.3 * scale)
			draw_line(wheel - Vector2(13.0, 0.0) * scale, wheel + Vector2(13.0, 0.0) * scale, brass, 1.0 * scale)
			draw_line(wheel - Vector2(0.0, 13.0) * scale, wheel + Vector2(0.0, 13.0) * scale, brass, 1.0 * scale)

	func _draw_menu_town_square_silhouette(horizon_y: float) -> void:
		var street_y := horizon_y - 12.0
		var far_shadow := Color(0.055, 0.024, 0.014, 0.82)
		var wood := Color(0.19, 0.084, 0.038, 0.88)
		var brass := Color(0.96, 0.58, 0.18, 0.42)
		var glass := Color(0.84, 0.58, 0.28, 0.22)
		var building_width := maxf(88.0, size.x / 7.2)
		for i in range(7):
			var x := float(i) * building_width - building_width * 0.18
			var height := 86.0 + float((i * 23) % 48)
			var front := Rect2(Vector2(x, street_y - height), Vector2(building_width * 0.86, height))
			_draw_menu_roof_profile(front, i)
			draw_rect(Rect2(front.position + Vector2(8.0, 10.0), front.size), Color(0.0, 0.0, 0.0, 0.24), true)
			draw_rect(front, far_shadow, true)
			draw_rect(front.grow(-4.0), wood.darkened(0.06 + float(i % 2) * 0.04), true)
			draw_line(front.position + Vector2(8.0, 13.0), front.end - Vector2(8.0, height - 14.0), brass, 2.0)
			var sign := Rect2(front.position + Vector2(12.0, 18.0), Vector2(maxf(38.0, front.size.x - 24.0), 18.0))
			draw_rect(sign, Color(0.1, 0.038, 0.016, 0.74), true)
			draw_rect(sign, brass, false, 1.4)
			var window_y := front.position.y + 45.0
			for w in range(2):
				var window := Rect2(Vector2(front.position.x + 16.0 + float(w) * maxf(26.0, front.size.x * 0.42), window_y), Vector2(18.0, 26.0))
				draw_rect(window, Color(0.04, 0.018, 0.01, 0.82), true)
				draw_rect(window.grow(-3.0), glass, true)
				draw_line(window.position + Vector2(0.0, window.size.y * 0.5), window.end - Vector2(0.0, window.size.y * 0.5), brass.darkened(0.2), 1.0)
			var door := Rect2(Vector2(front.get_center().x - 12.0, street_y - 38.0), Vector2(24.0, 38.0))
			draw_rect(door, Color(0.05, 0.018, 0.008, 0.9), true)
			draw_line(door.position + Vector2(4.0, 0.0), door.position + Vector2(4.0, door.size.y), Color(0.78, 0.42, 0.14, 0.2), 1.0)
			_draw_menu_business_cue(front, i, street_y)
		draw_line(Vector2(0.0, street_y + 4.0), Vector2(size.x, street_y + 2.0), Color(0.98, 0.58, 0.18, 0.22), 4.0)
		draw_line(Vector2(0.0, street_y + 12.0), Vector2(size.x, street_y + 11.0), Color(0.0, 0.0, 0.0, 0.3), 3.0)
		for i in range(6):
			var x := 44.0 + float(i) * maxf(80.0, size.x / 5.8)
			draw_line(Vector2(x, street_y - 12.0), Vector2(x, street_y + 38.0), Color(0.05, 0.02, 0.01, 0.86), 4.0)
			draw_line(Vector2(x - 28.0, street_y + 10.0), Vector2(x + 34.0, street_y + 6.0), Color(0.74, 0.4, 0.14, 0.32), 3.0)
			_draw_menu_lantern_glow(Vector2(x + 18.0, street_y - 24.0), 1.0 + float(i % 2) * 0.12)
			draw_line(Vector2(x, street_y - 12.0), Vector2(x + 18.0, street_y - 24.0), Color(0.08, 0.032, 0.014, 0.86), 2.0)

	func _draw_menu_street_depth_dressing(horizon_y: float) -> void:
		var street_y := horizon_y - 12.0
		var street_bottom := size.y - 124.0
		var depth_shadow := Color(0.018, 0.008, 0.004, 0.22)
		var dust_highlight := Color(0.92, 0.58, 0.22, 0.095)
		for lane in range(5):
			var t := float(lane) / 4.0
			var start_y := lerpf(street_y + 30.0, street_bottom - 14.0, t)
			var bow := sin(float(lane) * 1.7) * 20.0
			draw_line(Vector2(size.x * 0.18, start_y), Vector2(size.x * 0.84, start_y + bow), depth_shadow, 8.0)
			draw_line(Vector2(size.x * 0.2, start_y - 5.0), Vector2(size.x * 0.82, start_y + bow - 5.0), dust_highlight, 2.0)
		for i in range(18):
			var x := float((i * 113) % int(maxf(size.x, 2.0)))
			var y := lerpf(street_y + 22.0, street_bottom - 20.0, float((i * 7) % 19) / 18.0)
			var shadow := Rect2(Vector2(x, y) + Vector2(5.0, 5.0), Vector2(34.0 + float(i % 4) * 9.0, 5.0 + float(i % 3)))
			var plank := Rect2(Vector2(x, y), shadow.size)
			draw_rect(shadow, Color(0.0, 0.0, 0.0, 0.13), true)
			draw_rect(plank, Color(0.22, 0.1, 0.04, 0.11), true)
			draw_rect(plank, Color(0.86, 0.46, 0.16, 0.08), false, 1.0)
		for i in range(12):
			var x := lerpf(size.x * 0.08, size.x * 0.92, float(i) / 11.0)
			var y := street_y + 34.0 + sin(float(i) * 1.4) * 18.0
			draw_line(Vector2(x - 16.0, y + 18.0), Vector2(x + 38.0, y + 35.0), Color(0.0, 0.0, 0.0, 0.14), 6.0)
			draw_line(Vector2(x - 8.0, y), Vector2(x + 12.0, y + 10.0), Color(0.09, 0.036, 0.014, 0.34), 3.0)
		_draw_menu_wagon_silhouette(Vector2(size.x * 0.09, street_bottom - 36.0), 0.9)
		_draw_menu_wagon_silhouette(Vector2(size.x * 0.89, street_y + 82.0), 0.72)
		_draw_menu_horse_tether(Vector2(size.x * 0.73, street_y + 62.0), 0.72)
		_draw_menu_horse_tether(Vector2(size.x * 0.28, street_y + 74.0), 0.58)

	func _draw_menu_lantern_glow(center: Vector2, scale: float = 1.0) -> void:
		draw_circle(center, 19.0 * scale, Color(1.0, 0.48, 0.1, 0.055))
		draw_circle(center, 10.0 * scale, Color(1.0, 0.64, 0.18, 0.12))
		draw_rect(Rect2(center + Vector2(-4.0, -6.0) * scale, Vector2(8.0, 12.0) * scale), Color(0.12, 0.04, 0.012, 0.72), false, 1.4)
		draw_circle(center, 3.6 * scale, Color(1.0, 0.72, 0.24, 0.42))

	func _draw_menu_wagon_silhouette(position: Vector2, scale: float) -> void:
		var dark := Color(0.018, 0.008, 0.004, 0.64)
		var trim := Color(0.72, 0.36, 0.12, 0.2)
		var bed := Rect2(position + Vector2(-44.0, -20.0) * scale, Vector2(88.0, 28.0) * scale)
		draw_rect(Rect2(bed.position + Vector2(8.0, 10.0) * scale, bed.size), Color(0.0, 0.0, 0.0, 0.16), true)
		draw_rect(bed, dark, true)
		draw_line(bed.position + Vector2(8.0, 8.0) * scale, bed.end - Vector2(8.0, 18.0) * scale, trim, 2.0 * scale)
		for side in [-1.0, 1.0]:
			var wheel := position + Vector2(side * 28.0, 12.0) * scale
			draw_arc(wheel, 15.0 * scale, 0.0, TAU, 24, Color(0.0, 0.0, 0.0, 0.58), 4.0 * scale)
			draw_arc(wheel, 9.0 * scale, 0.0, TAU, 20, trim, 1.4 * scale)
			draw_line(wheel - Vector2(11.0, 0.0) * scale, wheel + Vector2(11.0, 0.0) * scale, trim, 1.0 * scale)
			draw_line(wheel - Vector2(0.0, 11.0) * scale, wheel + Vector2(0.0, 11.0) * scale, trim, 1.0 * scale)

	func _draw_menu_horse_tether(position: Vector2, scale: float) -> void:
		var dark := Color(0.016, 0.007, 0.004, 0.58)
		var brass := Color(0.92, 0.5, 0.16, 0.18)
		draw_line(position + Vector2(-32.0, 24.0) * scale, position + Vector2(42.0, 30.0) * scale, Color(0.0, 0.0, 0.0, 0.15), 7.0 * scale)
		draw_rect(Rect2(position + Vector2(-22.0, -16.0) * scale, Vector2(44.0, 22.0) * scale), dark, true)
		draw_circle(position + Vector2(27.0, -18.0) * scale, 9.0 * scale, dark)
		draw_line(position + Vector2(-14.0, 4.0) * scale, position + Vector2(-22.0, 27.0) * scale, dark, 5.0 * scale)
		draw_line(position + Vector2(13.0, 4.0) * scale, position + Vector2(22.0, 27.0) * scale, dark, 5.0 * scale)
		draw_line(position + Vector2(34.0, -15.0) * scale, position + Vector2(58.0, -28.0) * scale, brass, 1.5 * scale)

	func _draw_menu_roof_profile(front: Rect2, index: int) -> void:
		var roof_shadow := Color(0.025, 0.01, 0.005, 0.78)
		var roof_wood := Color(0.16, 0.062, 0.026, 0.94)
		var brass := Color(0.9, 0.5, 0.16, 0.28)
		match index % 5:
			0:
				var parapet := Rect2(front.position - Vector2(5.0, 18.0), Vector2(front.size.x + 10.0, 22.0))
				draw_rect(parapet, roof_shadow, true)
				draw_rect(parapet.grow(-3.0), roof_wood, true)
				draw_line(parapet.position + Vector2(8.0, 5.0), parapet.end - Vector2(8.0, 16.0), brass, 2.0)
			1:
				var awning := PackedVector2Array([
					front.position + Vector2(-6.0, 5.0),
					front.position + Vector2(front.size.x + 6.0, 5.0),
					front.position + Vector2(front.size.x - 4.0, 23.0),
					front.position + Vector2(4.0, 23.0),
				])
				draw_colored_polygon(awning, Color(0.1, 0.038, 0.016, 0.9))
				draw_polyline(awning, brass, 2.0)
			2:
				var peak := PackedVector2Array([
					front.position + Vector2(-4.0, 8.0),
					front.position + Vector2(front.size.x * 0.5, -18.0),
					front.position + Vector2(front.size.x + 4.0, 8.0),
				])
				draw_colored_polygon(peak, roof_shadow)
				draw_polyline(peak, brass, 2.0)
			3:
				var rail_y := front.position.y - 8.0
				draw_line(Vector2(front.position.x - 3.0, rail_y), Vector2(front.end.x + 3.0, rail_y), roof_shadow, 8.0)
				for post in range(4):
					var x := lerpf(front.position.x + 8.0, front.end.x - 8.0, float(post) / 3.0)
					draw_line(Vector2(x, rail_y - 9.0), Vector2(x, rail_y + 7.0), roof_wood, 4.0)
			_:
				var lip := Rect2(front.position - Vector2(3.0, 10.0), Vector2(front.size.x + 6.0, 13.0))
				draw_rect(lip, roof_shadow, true)
				for tick in range(5):
					var x := lip.position.x + 8.0 + float(tick) * maxf(10.0, (lip.size.x - 16.0) / 4.0)
					draw_line(Vector2(x, lip.position.y + 2.0), Vector2(x + 5.0, lip.end.y - 2.0), brass, 1.2)

	func _draw_menu_business_cue(front: Rect2, index: int, street_y: float) -> void:
		var brass := Color(0.98, 0.62, 0.2, 0.46)
		var dark := Color(0.035, 0.014, 0.007, 0.72)
		var red := Color(0.74, 0.08, 0.035, 0.35)
		var glass := Color(0.98, 0.72, 0.28, 0.28)
		var center := front.get_center()
		match index:
			0:
				var shelf_y := front.position.y + 61.0
				draw_line(Vector2(front.position.x + 18.0, shelf_y), Vector2(front.end.x - 18.0, shelf_y), dark, 4.0)
				for bottle in range(5):
					var x := lerpf(front.position.x + 22.0, front.end.x - 24.0, float(bottle) / 4.0)
					draw_rect(Rect2(Vector2(x - 2.0, shelf_y - 12.0), Vector2(4.0, 10.0)), glass, true)
					draw_circle(Vector2(x, shelf_y - 14.0), 2.0, glass.lightened(0.2))
			1:
				var pole_x := front.end.x - 15.0
				draw_line(Vector2(pole_x, front.position.y + 42.0), Vector2(pole_x, street_y - 9.0), Color(0.95, 0.8, 0.62, 0.42), 4.0)
				for stripe in range(5):
					var y := front.position.y + 45.0 + float(stripe) * 10.0
					draw_line(Vector2(pole_x - 5.0, y), Vector2(pole_x + 5.0, y + 7.0), red, 2.0)
			2:
				var badge := center + Vector2(0.0, -10.0)
				for point in range(6):
					var angle := -PI * 0.5 + float(point) * TAU / 6.0
					draw_line(badge, badge + Vector2(cos(angle), sin(angle)) * 16.0, brass, 3.0)
				draw_circle(badge, 6.0, Color(0.12, 0.045, 0.018, 0.74))
			3:
				for column: float in [-1.0, 1.0]:
					var x: float = center.x + column * front.size.x * 0.28
					draw_rect(Rect2(Vector2(x - 4.0, front.position.y + 39.0), Vector2(8.0, street_y - front.position.y - 43.0)), dark, true)
					draw_line(Vector2(x - 5.0, front.position.y + 43.0), Vector2(x + 5.0, street_y - 12.0), brass, 1.4)
			4:
				for crate in range(3):
					var crate_rect := Rect2(Vector2(front.position.x + 18.0 + crate * 17.0, street_y - 21.0 - float(crate % 2) * 8.0), Vector2(14.0, 14.0))
					draw_rect(crate_rect, Color(0.13, 0.055, 0.024, 0.72), true)
					draw_rect(crate_rect, brass.darkened(0.24), false, 1.0)
					draw_line(crate_rect.position, crate_rect.end, Color(0.92, 0.5, 0.16, 0.18), 1.0)
			5:
				var jail_bar := Rect2(Vector2(center.x - 24.0, front.position.y + 45.0), Vector2(48.0, 31.0))
				draw_rect(jail_bar, dark, false, 2.0)
				for bar in range(4):
					var x := jail_bar.position.x + 9.0 + float(bar) * 10.0
					draw_line(Vector2(x, jail_bar.position.y + 2.0), Vector2(x, jail_bar.end.y - 2.0), Color(0.86, 0.5, 0.18, 0.32), 1.6)
			_:
				var water := Rect2(Vector2(center.x - 20.0, street_y - 21.0), Vector2(40.0, 15.0))
				draw_rect(water, Color(0.08, 0.032, 0.015, 0.78), true)
				draw_arc(water.get_center(), 18.0, 0.0, PI, 18, brass, 2.0)
		var shadow_start := Vector2(front.position.x + 12.0, street_y + 10.0)
		draw_line(shadow_start, shadow_start + Vector2(72.0, 22.0), Color(0.012, 0.006, 0.003, 0.16), 7.0)

class HudLedgerFrame extends Control:
	const CONTRAST_MARKER_COUNT := 42

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return LIVE_HUD_LEDGER_VISUAL_VERSION

	func get_contrast_marker_count() -> int:
		return CONTRAST_MARKER_COUNT

	func _draw() -> void:
		var panel := Rect2(Vector2.ZERO, size)
		if size.x <= 8.0 or size.y <= 8.0:
			return
		draw_rect(Rect2(Vector2(5.0, 7.0), size - Vector2(2.0, 0.0)), Color(0.0, 0.0, 0.0, 0.32), true)
		draw_rect(panel, Color(0.035, 0.014, 0.008, 0.82), true)
		draw_rect(panel.grow(-4.0), Color(0.13, 0.055, 0.026, 0.68), true)
		draw_rect(panel.grow(-9.0), Color(0.055, 0.024, 0.014, 0.58), true)
		draw_rect(panel, Color(0.82, 0.48, 0.18, 0.82), false, 3.0)
		draw_rect(panel.grow(-7.0), Color(1.0, 0.68, 0.26, 0.28), false, 1.0)
		draw_rect(Rect2(Vector2(14.0, 12.0), Vector2(maxf(0.0, size.x - 28.0), 32.0)), Color(0.018, 0.008, 0.004, 0.5), true)
		draw_rect(Rect2(Vector2(18.0, 16.0), Vector2(maxf(0.0, size.x - 36.0), 24.0)), Color(0.95, 0.56, 0.17, 0.12), false, 1.2)
		for plank in range(5):
			var plank_y := 50.0 + float(plank) * 43.0
			if plank_y < size.y - 28.0:
				draw_line(Vector2(18.0, plank_y), Vector2(size.x - 18.0, plank_y - 2.0), Color(1.0, 0.66, 0.22, 0.06), 1.2)
				draw_line(Vector2(24.0, plank_y + 13.0), Vector2(size.x - 32.0, plank_y + 12.0), Color(0.02, 0.009, 0.004, 0.16), 1.1)

		var rail := Rect2(Vector2(10.0, 8.0), Vector2(maxf(0.0, size.x - 20.0), 10.0))
		draw_rect(rail, Color(0.78, 0.42, 0.13, 0.32), true)
		draw_line(rail.position + Vector2(6.0, 2.0), rail.end - Vector2(6.0, 6.0), Color(1.0, 0.74, 0.3, 0.5), 1.5)
		draw_line(Vector2(12.0, size.y - 12.0), Vector2(size.x - 12.0, size.y - 12.0), Color(0.02, 0.008, 0.004, 0.44), 2.0)

		var health_slot := Rect2(Vector2(16.0, 16.0), Vector2(maxf(0.0, size.x - 32.0), 24.0))
		draw_rect(Rect2(health_slot.position + Vector2(4.0, 5.0), health_slot.size), Color(0.0, 0.0, 0.0, 0.26), true)
		draw_rect(health_slot, Color(0.02, 0.011, 0.006, 0.78), true)
		draw_rect(health_slot, Color(0.92, 0.55, 0.18, 0.72), false, 2.0)
		draw_line(health_slot.position + Vector2(7.0, 5.0), health_slot.end - Vector2(7.0, 18.0), Color(1.0, 0.72, 0.28, 0.35), 1.5)
		for chamber in range(6):
			var x := health_slot.position.x + 20.0 + float(chamber) * maxf(1.0, (health_slot.size.x - 40.0) / 5.0)
			draw_circle(Vector2(x, health_slot.position.y + 12.0), 3.4, Color(1.0, 0.72, 0.28, 0.2))
			draw_circle(Vector2(x + 0.8, health_slot.position.y + 12.8), 1.6, Color(0.0, 0.0, 0.0, 0.22))
		for row in [
			Rect2(Vector2(20.0, 74.0), Vector2(size.x - 40.0, 20.0)),
			Rect2(Vector2(20.0, 100.0), Vector2(size.x - 40.0, 20.0)),
			Rect2(Vector2(20.0, 126.0), Vector2(size.x - 40.0, 42.0)),
			Rect2(Vector2(20.0, 210.0), Vector2(size.x - 40.0, 34.0)),
			Rect2(Vector2(20.0, 260.0), Vector2(size.x - 40.0, 22.0)),
		]:
			draw_rect(row, Color(0.026, 0.012, 0.006, 0.34), true)
			draw_rect(row, Color(0.92, 0.5, 0.16, 0.16), false, 1.0)
			draw_line(row.position + Vector2(8.0, 3.0), row.position + Vector2(row.size.x - 9.0, 2.0), Color(1.0, 0.72, 0.28, 0.12), 1.0)

		for i in range(8):
			var x := 22.0 + float(i) * maxf(1.0, (size.x - 44.0) / 7.0)
			draw_circle(Vector2(x, 54.0), 3.0, Color(0.95, 0.68, 0.26, 0.46))
			draw_line(Vector2(x - 5.0, 61.0), Vector2(x + 7.0, 65.0), Color(0.2, 0.08, 0.032, 0.42), 2.0)
			draw_line(Vector2(x, 20.0), Vector2(x, 36.0), Color(0.88, 0.4, 0.14, 0.22), 1.0)
		for tick in range(6):
			var tick_x := 34.0 + float(tick) * 23.0
			draw_line(Vector2(tick_x, 273.0), Vector2(tick_x + 10.0, 273.0), Color(1.0, 0.76, 0.32, 0.2), 1.2)

		for rule_y in [90.0, 176.0, 244.0]:
			draw_rect(Rect2(Vector2(14.0, rule_y - 5.0), Vector2(maxf(0.0, size.x - 28.0), 10.0)), Color(0.02, 0.009, 0.004, 0.24), true)
			draw_line(Vector2(18.0, rule_y), Vector2(size.x - 18.0, rule_y), Color(1.0, 0.64, 0.22, 0.34), 2.0)
			draw_line(Vector2(30.0, rule_y + 5.0), Vector2(size.x - 30.0, rule_y + 5.0), Color(0.02, 0.01, 0.005, 0.3), 2.0)
			draw_circle(Vector2(22.0, rule_y), 2.4, Color(0.96, 0.62, 0.22, 0.55))
			draw_circle(Vector2(size.x - 22.0, rule_y), 2.4, Color(0.96, 0.62, 0.22, 0.55))

		var corner_color := Color(0.96, 0.62, 0.22, 0.6)
		for corner in [Vector2(14.0, 14.0), Vector2(size.x - 14.0, 14.0), Vector2(14.0, size.y - 14.0), Vector2(size.x - 14.0, size.y - 14.0)]:
			draw_circle(corner, 3.0, corner_color)
			draw_circle(corner + Vector2(1.0, 1.0), 1.2, Color(0.06, 0.02, 0.008, 0.62))

		for i in range(5):
			var y := 116.0 + float(i) * 26.0
			if y < size.y - 30.0:
				draw_line(Vector2(18.0, y), Vector2(48.0, y + 6.0), Color(0.95, 0.52, 0.16, 0.16), 1.4)
				draw_line(Vector2(size.x - 48.0, y + 6.0), Vector2(size.x - 18.0, y), Color(0.95, 0.52, 0.16, 0.16), 1.4)
		for slash in range(4):
			var start := Vector2(size.x - 96.0 + float(slash) * 15.0, 26.0 + float(slash % 2) * 5.0)
			draw_line(start, start + Vector2(34.0, -8.0), Color(1.0, 0.78, 0.34, 0.1), 1.1)
		var badge_center := Vector2(size.x - 42.0, 30.0)
		for point in range(6):
			var angle := -PI * 0.5 + float(point) * TAU / 6.0
			draw_line(badge_center, badge_center + Vector2(cos(angle), sin(angle)) * 15.0, Color(1.0, 0.68, 0.24, 0.28), 2.4)
		draw_circle(badge_center, 5.0, Color(0.04, 0.016, 0.006, 0.52))

class ResultCardFrame extends Control:
	const DETAIL_MARKER_COUNT := 62

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return RESULT_CARD_VISUAL_VERSION

	func get_detail_marker_count() -> int:
		return DETAIL_MARKER_COUNT

	func _draw() -> void:
		var card := Rect2(Vector2.ZERO, size)
		if size.x <= 2.0 or size.y <= 2.0:
			return
		var inner := card.grow(-14.0)
		var ledger := inner.grow(-16.0)
		var paper := ledger.grow(-14.0)

		draw_rect(Rect2(Vector2(10.0, 12.0), size - Vector2(2.0, 2.0)), Color(0.0, 0.0, 0.0, 0.38), true)
		draw_rect(Rect2(Vector2(4.0, 6.0), size - Vector2(10.0, 10.0)), Color(1.0, 0.58, 0.16, 0.055), true)
		draw_line(Vector2(20.0, size.y + 6.0), Vector2(size.x + 18.0, size.y - 18.0), Color(0.025, 0.01, 0.004, 0.18), 18.0)
		draw_rect(card, Color(0.035, 0.015, 0.008, 0.96), true)
		draw_rect(card.grow(-4.0), Color(0.16, 0.068, 0.028, 0.94), true)
		for side_x in [8.0, size.x - 12.0]:
			draw_line(Vector2(side_x, 18.0), Vector2(side_x, size.y - 18.0), Color(0.04, 0.016, 0.006, 0.62), 5.0)
			draw_line(Vector2(side_x + 2.0, 28.0), Vector2(side_x + 2.0, size.y - 30.0), Color(1.0, 0.68, 0.24, 0.12), 1.4)
		draw_rect(inner, Color(0.82, 0.55, 0.28, 0.94), true)
		draw_rect(inner.grow(-5.0), Color(0.98, 0.7, 0.28, 0.16), false, 1.4)
		draw_rect(ledger, Color(0.062, 0.026, 0.013, 0.98), true)
		draw_rect(paper, Color(0.105, 0.046, 0.021, 0.96), true)
		draw_rect(Rect2(paper.position + Vector2(0.0, 44.0), Vector2(paper.size.x, 6.0)), Color(0.96, 0.58, 0.18, 0.24), true)
		draw_rect(Rect2(paper.position + Vector2(0.0, paper.size.y - 48.0), Vector2(paper.size.x, 5.0)), Color(0.74, 0.36, 0.12, 0.28), true)
		for stain in range(7):
			var t := float(stain) / 6.0
			var stain_pos := paper.position + Vector2(26.0 + t * maxf(0.0, paper.size.x - 52.0), 72.0 + float((stain * 31) % int(maxf(82.0, paper.size.y - 132.0))))
			draw_circle(stain_pos, 2.0 + float(stain % 3), Color(0.45, 0.2, 0.07, 0.08))

		for i in range(10):
			var t := float(i) / 9.0
			var y := paper.position.y + 18.0 + t * maxf(0.0, paper.size.y - 36.0)
			draw_line(Vector2(paper.position.x + 18.0, y), Vector2(paper.end.x - 18.0, y + sin(t * TAU) * 2.0), Color(1.0, 0.66, 0.24, 0.08), 1.4)
		for column in [paper.position.x + paper.size.x * 0.33, paper.position.x + paper.size.x * 0.66]:
			draw_line(Vector2(column, paper.position.y + 58.0), Vector2(column, paper.end.y - 62.0), Color(0.72, 0.34, 0.12, 0.12), 1.2)

		draw_rect(card, Color(0.96, 0.62, 0.2, 0.64), false, 4.0)
		draw_rect(card.grow(-8.0), Color(0.04, 0.016, 0.006, 0.75), false, 3.0)
		draw_rect(ledger, Color(1.0, 0.72, 0.28, 0.32), false, 2.0)
		draw_rect(paper, Color(0.0, 0.0, 0.0, 0.28), false, 2.0)
		for tooth in range(14):
			var t := float(tooth) / 13.0
			var y := lerpf(paper.position.y + 16.0, paper.end.y - 16.0, t)
			draw_line(Vector2(paper.position.x + 8.0, y), Vector2(paper.position.x + 20.0, y + 3.0), Color(0.98, 0.62, 0.2, 0.16), 1.1)
			draw_line(Vector2(paper.end.x - 20.0, y + 3.0), Vector2(paper.end.x - 8.0, y), Color(0.98, 0.62, 0.2, 0.16), 1.1)

		var top_band := Rect2(Vector2(card.position.x + 34.0, card.position.y + 24.0), Vector2(maxf(0.0, card.size.x - 68.0), 32.0))
		var bottom_band := Rect2(Vector2(card.position.x + 34.0, card.end.y - 54.0), Vector2(maxf(0.0, card.size.x - 68.0), 28.0))
		draw_rect(top_band, Color(0.11, 0.045, 0.018, 0.78), true)
		draw_rect(bottom_band, Color(0.11, 0.045, 0.018, 0.64), true)
		draw_line(top_band.position + Vector2(12.0, 8.0), top_band.end - Vector2(12.0, 22.0), Color(1.0, 0.72, 0.28, 0.42), 2.0)
		draw_line(bottom_band.position + Vector2(12.0, 8.0), bottom_band.end - Vector2(12.0, 18.0), Color(0.94, 0.56, 0.18, 0.34), 2.0)
		for cartridge in range(7):
			var x := lerpf(top_band.position.x + 22.0, top_band.end.x - 22.0, float(cartridge) / 6.0)
			var shell := Rect2(Vector2(x - 3.5, top_band.position.y + 8.0), Vector2(7.0, 16.0))
			draw_rect(shell, Color(0.82, 0.45, 0.14, 0.38), true)
			draw_rect(Rect2(shell.position, Vector2(shell.size.x, 3.0)), Color(1.0, 0.76, 0.28, 0.36), true)
		var action_rail := Rect2(Vector2(paper.position.x + 22.0, paper.end.y - 74.0), Vector2(maxf(90.0, paper.size.x - 44.0), 22.0))
		draw_rect(Rect2(action_rail.position + Vector2(3.0, 5.0), action_rail.size), Color(0.012, 0.006, 0.003, 0.32), true)
		draw_rect(action_rail, Color(0.09, 0.035, 0.014, 0.88), true)
		draw_rect(action_rail, Color(1.0, 0.67, 0.24, 0.4), false, 1.4)
		for notch in range(6):
			var x := action_rail.position.x + 12.0 + float(notch) * (action_rail.size.x - 24.0) / 5.0
			draw_line(Vector2(x, action_rail.position.y + 5.0), Vector2(x + 8.0, action_rail.end.y - 5.0), Color(0.95, 0.52, 0.16, 0.22), 1.0)
		_draw_detached_popout_hardware(card, paper)

		var corner_points := [
			Vector2(22.0, 22.0),
			Vector2(size.x - 22.0, 22.0),
			Vector2(22.0, size.y - 22.0),
			Vector2(size.x - 22.0, size.y - 22.0),
		]
		for corner in corner_points:
			draw_circle(corner, 6.0, Color(0.96, 0.68, 0.26, 0.92))
			draw_circle(corner + Vector2(1.4, 1.4), 2.6, Color(0.04, 0.018, 0.008, 0.58))
			draw_circle(corner - Vector2(1.8, 1.8), 1.3, Color(1.0, 0.86, 0.46, 0.48))

		var stamp_center := Vector2(card.end.x - 78.0, card.position.y + 84.0)
		draw_arc(stamp_center, 34.0, 0.0, TAU, 42, Color(0.92, 0.18, 0.08, 0.22), 4.0)
		draw_arc(stamp_center, 24.0, 0.0, TAU, 34, Color(0.92, 0.18, 0.08, 0.16), 2.0)
		draw_line(stamp_center + Vector2(-23.0, -3.0), stamp_center + Vector2(23.0, 5.0), Color(0.92, 0.18, 0.08, 0.18), 2.0)
		draw_line(stamp_center + Vector2(-15.0, 10.0), stamp_center + Vector2(17.0, 16.0), Color(0.92, 0.18, 0.08, 0.14), 1.4)
		var warrant_center := Vector2(paper.position.x + 54.0, paper.position.y + 58.0)
		for point in range(6):
			var angle := -PI * 0.5 + float(point) * TAU / 6.0
			draw_line(warrant_center, warrant_center + Vector2(cos(angle), sin(angle)) * 16.0, Color(1.0, 0.68, 0.24, 0.2), 2.2)
		draw_circle(warrant_center, 5.0, Color(0.04, 0.016, 0.006, 0.48))
		var popout_tab := PackedVector2Array([
			Vector2(-14.0, size.y * 0.34),
			Vector2(10.0, size.y * 0.29),
			Vector2(10.0, size.y * 0.43),
			Vector2(-14.0, size.y * 0.39),
		])
		draw_colored_polygon(popout_tab, Color(0.12, 0.048, 0.018, 0.94))
		draw_polyline(PackedVector2Array([popout_tab[0], popout_tab[1], popout_tab[2], popout_tab[3], popout_tab[0]]), Color(1.0, 0.66, 0.24, 0.36), 2.0)
		var right_shadow_tab := PackedVector2Array([
			Vector2(size.x - 8.0, size.y * 0.58),
			Vector2(size.x + 18.0, size.y * 0.54),
			Vector2(size.x + 18.0, size.y * 0.67),
			Vector2(size.x - 8.0, size.y * 0.64),
		])
		draw_colored_polygon(right_shadow_tab, Color(0.018, 0.007, 0.003, 0.34))
		for stitch in range(6):
			var y := lerpf(size.y * 0.34 + 6.0, size.y * 0.39 - 4.0, float(stitch) / 5.0)
			draw_line(Vector2(-4.0, y), Vector2(6.0, y + 1.5), Color(1.0, 0.74, 0.28, 0.28), 1.1)
		for chip in range(8):
			var t := float(chip) / 7.0
			var chip_pos := Vector2(lerpf(36.0, size.x - 36.0, t), size.y - 16.0 + sin(float(chip) * 1.7) * 2.0)
			draw_line(chip_pos, chip_pos + Vector2(7.0, -2.0), Color(0.95, 0.6, 0.2, 0.22), 1.1)
		var tab := Rect2(Vector2(card.position.x - 10.0, card.position.y + 66.0), Vector2(18.0, maxf(90.0, card.size.y - 132.0)))
		draw_rect(tab, Color(0.09, 0.036, 0.014, 0.96), true)
		draw_rect(tab, Color(0.92, 0.56, 0.18, 0.48), false, 2.0)
		for i in range(4):
			var rivet_y := tab.position.y + 18.0 + float(i) * maxf(18.0, (tab.size.y - 36.0) / 3.0)
			draw_circle(Vector2(tab.get_center().x, rivet_y), 3.0, Color(0.96, 0.66, 0.24, 0.82))
			draw_circle(Vector2(tab.get_center().x + 1.0, rivet_y + 1.0), 1.3, Color(0.02, 0.009, 0.004, 0.62))
		var powder_smear := paper.position + Vector2(paper.size.x * 0.5, paper.size.y - 88.0)
		for puff in range(5):
			draw_circle(powder_smear + Vector2(float(puff - 2) * 13.0, float((puff * 7) % 11) - 5.0), 4.0 + float(puff % 2), Color(0.02, 0.009, 0.004, 0.1))

	func _draw_detached_popout_hardware(card: Rect2, paper: Rect2) -> void:
		var seam := Rect2(Vector2(card.position.x - 22.0, card.position.y + 96.0), Vector2(12.0, maxf(72.0, card.size.y - 192.0)))
		draw_rect(seam, Color(0.028, 0.011, 0.004, 0.42), true)
		draw_line(seam.position + Vector2(6.0, 8.0), seam.position + Vector2(6.0, seam.size.y - 8.0), Color(1.0, 0.66, 0.22, 0.28), 2.0)
		for loop_index in range(5):
			var y := lerpf(seam.position.y + 18.0, seam.end.y - 18.0, float(loop_index) / 4.0)
			draw_arc(Vector2(seam.position.x + 7.0, y), 7.0, PI * 0.58, PI * 1.42, 10, Color(0.96, 0.56, 0.18, 0.34), 1.4)
			draw_circle(Vector2(seam.position.x + 8.0, y), 2.2, Color(0.04, 0.016, 0.006, 0.6))
		var folded_corner := PackedVector2Array([
			paper.end - Vector2(62.0, 0.0),
			paper.end - Vector2(0.0, 0.0),
			paper.end - Vector2(0.0, 62.0),
		])
		draw_colored_polygon(folded_corner, Color(0.16, 0.068, 0.028, 0.72))
		draw_line(paper.end - Vector2(60.0, 2.0), paper.end - Vector2(2.0, 60.0), Color(1.0, 0.74, 0.28, 0.28), 1.6)
		for staple in range(3):
			var y := paper.position.y + 112.0 + float(staple) * maxf(48.0, (paper.size.y - 224.0) / 2.0)
			draw_line(Vector2(paper.position.x + 30.0, y), Vector2(paper.position.x + 52.0, y + 3.0), Color(0.04, 0.016, 0.006, 0.34), 3.0)
			draw_line(Vector2(paper.position.x + 31.0, y - 1.0), Vector2(paper.position.x + 51.0, y + 2.0), Color(1.0, 0.72, 0.28, 0.22), 1.1)
		var audit_plate := Rect2(Vector2(paper.position.x + paper.size.x * 0.5 - 72.0, paper.position.y + 76.0), Vector2(144.0, 18.0))
		draw_rect(Rect2(audit_plate.position + Vector2(2.0, 3.0), audit_plate.size), Color(0.018, 0.007, 0.003, 0.28), true)
		draw_rect(audit_plate, Color(0.09, 0.034, 0.013, 0.56), true)
		draw_rect(audit_plate, Color(1.0, 0.68, 0.22, 0.24), false, 1.2)
		for tick in range(6):
			var x := audit_plate.position.x + 12.0 + float(tick) * (audit_plate.size.x - 24.0) / 5.0
			draw_line(Vector2(x, audit_plate.position.y + 5.0), Vector2(x + 7.0, audit_plate.end.y - 5.0), Color(1.0, 0.75, 0.3, 0.22), 1.0)

class UnlockToastFrame extends Control:
	const DETAIL_MARKER_COUNT := 24

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return UNLOCK_TOAST_VISUAL_VERSION

	func get_detail_marker_count() -> int:
		return DETAIL_MARKER_COUNT

	func _draw() -> void:
		var ticket := Rect2(Vector2.ZERO, size)
		if size.x <= 4.0 or size.y <= 4.0:
			return
		var inner := ticket.grow(-8.0)
		var plate := inner.grow(-10.0)
		draw_rect(Rect2(Vector2(8.0, 9.0), size - Vector2(2.0, 0.0)), Color(0.0, 0.0, 0.0, 0.34), true)
		draw_rect(ticket, Color(0.035, 0.014, 0.007, 0.94), true)
		draw_rect(inner, Color(0.18, 0.075, 0.028, 0.92), true)
		draw_rect(plate, Color(0.095, 0.037, 0.016, 0.96), true)
		draw_rect(ticket, Color(0.96, 0.62, 0.2, 0.76), false, 3.0)
		draw_rect(inner, Color(1.0, 0.72, 0.28, 0.28), false, 1.4)
		var top_rule := Rect2(Vector2(28.0, 16.0), Vector2(maxf(0.0, size.x - 56.0), 9.0))
		var bottom_rule := Rect2(Vector2(28.0, size.y - 25.0), Vector2(maxf(0.0, size.x - 56.0), 7.0))
		draw_rect(top_rule, Color(0.92, 0.5, 0.16, 0.32), true)
		draw_rect(bottom_rule, Color(0.74, 0.36, 0.12, 0.3), true)
		for notch in range(10):
			var x := lerpf(34.0, size.x - 34.0, float(notch) / 9.0)
			draw_line(Vector2(x, 15.0), Vector2(x + 8.0, 24.0), Color(1.0, 0.75, 0.28, 0.26), 1.1)
			draw_line(Vector2(x, size.y - 25.0), Vector2(x + 8.0, size.y - 18.0), Color(0.08, 0.03, 0.012, 0.34), 1.0)
		for corner in [Vector2(18.0, 18.0), Vector2(size.x - 18.0, 18.0), Vector2(18.0, size.y - 18.0), Vector2(size.x - 18.0, size.y - 18.0)]:
			draw_circle(corner, 4.4, Color(0.96, 0.66, 0.24, 0.88))
			draw_circle(corner + Vector2(1.2, 1.2), 1.7, Color(0.035, 0.014, 0.006, 0.62))
		var badge := Vector2(52.0, size.y * 0.5)
		for point in range(6):
			var angle := -PI * 0.5 + float(point) * TAU / 6.0
			draw_line(badge, badge + Vector2(cos(angle), sin(angle)) * 18.0, Color(1.0, 0.68, 0.24, 0.28), 2.2)
		draw_circle(badge, 5.0, Color(0.035, 0.014, 0.006, 0.58))
		for spark in range(5):
			var x := size.x - 72.0 + float(spark) * 11.0
			draw_line(Vector2(x, 39.0 + float(spark % 2) * 6.0), Vector2(x + 18.0, 31.0 + float(spark % 2) * 5.0), Color(1.0, 0.78, 0.34, 0.22), 1.3)

class DuelistIntroCard extends Control:
	var _accent := Color(0.72, 0.08, 0.04)

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func get_visual_version() -> String:
		return DUELIST_INTRO_VISUAL_VERSION

	func set_accent(accent: Color) -> void:
		_accent = accent
		queue_redraw()

	func _draw() -> void:
		var card := Rect2(Vector2.ZERO, size)
		if size.x <= 2.0 or size.y <= 2.0:
			return
		var leather := Color(0.075, 0.03, 0.014, 0.98)
		var dark := Color(0.028, 0.012, 0.006, 0.96)
		var brass := Color(1.0, 0.68, 0.22, 0.64)
		var paper := Color(0.86, 0.66, 0.34, 0.98)
		var paper_shadow := Color(0.46, 0.27, 0.12, 0.36)
		var accent_glow := Color(_accent.r, _accent.g, _accent.b, 0.56)

		draw_rect(Rect2(Vector2(8.0, 12.0), size), Color(0.0, 0.0, 0.0, 0.34), true)
		draw_rect(card, dark, true)
		draw_rect(card.grow(-4.0), leather, true)
		draw_rect(card, brass.darkened(0.18), false, 4.0)
		draw_rect(card.grow(-8.0), brass, false, 1.5)

		var poster := card.grow(-22.0)
		draw_rect(Rect2(poster.position + Vector2(4.0, 6.0), poster.size), Color(0.0, 0.0, 0.0, 0.24), true)
		draw_rect(poster, paper_shadow, true)
		draw_rect(poster.grow(-5.0), paper, true)
		for i in range(9):
			var t := float(i) / 8.0
			var y := poster.position.y + 20.0 + t * maxf(0.0, poster.size.y - 40.0)
			draw_line(Vector2(poster.position.x + 12.0, y), Vector2(poster.end.x - 12.0, y + sin(t * TAU) * 2.0), Color(0.32, 0.14, 0.05, 0.09), 1.2)
		draw_rect(poster.grow(-5.0), Color(0.12, 0.048, 0.018, 0.34), false, 2.0)
		draw_rect(Rect2(poster.position + Vector2(0.0, 44.0), Vector2(poster.size.x, 12.0)), accent_glow, true)
		draw_rect(Rect2(poster.position + Vector2(0.0, poster.size.y - 72.0), Vector2(poster.size.x, 9.0)), Color(_accent.r, _accent.g, _accent.b, 0.42), true)

		for pin in [
			poster.position + Vector2(12.0, 12.0),
			poster.position + Vector2(poster.size.x - 12.0, 12.0),
			poster.position + Vector2(12.0, poster.size.y - 12.0),
			poster.position + Vector2(poster.size.x - 12.0, poster.size.y - 12.0),
		]:
			draw_circle(pin + Vector2(1.5, 1.5), 4.5, Color(0.04, 0.018, 0.008, 0.52))
			draw_circle(pin, 4.0, brass)
			draw_circle(pin + Vector2(-1.2, -1.2), 1.6, Color(1.0, 0.86, 0.42, 0.62))

		var portrait := Rect2(Vector2(poster.position.x + 34.0, poster.position.y + 78.0), Vector2(poster.size.x - 68.0, 142.0))
		draw_rect(portrait, Color(0.17, 0.07, 0.028, 0.23), true)
		draw_rect(portrait, Color(0.12, 0.045, 0.018, 0.54), false, 2.0)
		var center := portrait.get_center() + Vector2(0.0, 5.0)
		draw_circle(center + Vector2(0.0, 42.0), 40.0, Color(0.16, 0.065, 0.026, 0.14))
		draw_arc(center + Vector2(0.0, -24.0), 30.0, PI * 1.04, PI * 1.96, 28, dark, 8.0)
		draw_line(center + Vector2(-31.0, -23.0), center + Vector2(31.0, -23.0), dark, 9.0)
		draw_circle(center + Vector2(0.0, -10.0), 17.0, dark)
		draw_line(center + Vector2(0.0, 7.0), center + Vector2(0.0, 52.0), dark, 10.0)
		draw_line(center + Vector2(-35.0, 16.0), center + Vector2(35.0, 16.0), dark, 9.0)
		draw_line(center + Vector2(19.0, 18.0), center + Vector2(56.0, -18.0), accent_glow.lightened(0.25), 4.0)
		draw_line(center + Vector2(54.0, -18.0), center + Vector2(66.0, -28.0), Color(1.0, 0.82, 0.38, 0.7), 3.0)
		draw_line(center + Vector2(-19.0, 18.0), center + Vector2(-46.0, 42.0), dark, 5.0)
		draw_line(center + Vector2(0.0, 52.0), center + Vector2(-22.0, 88.0), dark, 8.0)
		draw_line(center + Vector2(0.0, 52.0), center + Vector2(24.0, 88.0), dark, 8.0)
		draw_arc(center, 76.0, -0.78, 0.68, 30, Color(1.0, 0.72, 0.24, 0.22), 4.0)

class InfoCard extends PanelContainer:
	const VISUAL_VERSION := "info_card_weathered_ledger_v3"
	const DETAIL_MARKER_COUNT := 18
	var _accent := Color(0.82, 0.46, 0.18)
	var _locked := false
	var _category := ""

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func get_detail_marker_count() -> int:
		return DETAIL_MARKER_COUNT

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func configure(title: String, category: String, body: String, footer: String = "", accent: Color = Color(0.82, 0.46, 0.18)) -> void:
		var locked := category == "LOCKED"
		_accent = accent
		_locked = locked
		_category = category
		custom_minimum_size = Vector2(260.0, 190.0)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

		var panel := StyleBoxFlat.new()
		panel.bg_color = Color(0.0, 0.0, 0.0, 0.0)
		panel.border_color = Color(0.0, 0.0, 0.0, 0.0)
		panel.border_width_left = 5
		panel.border_width_top = 4
		panel.border_width_right = 5
		panel.border_width_bottom = 6
		panel.corner_radius_top_left = 8
		panel.corner_radius_top_right = 8
		panel.corner_radius_bottom_left = 8
		panel.corner_radius_bottom_right = 8
		panel.shadow_color = Color(0.025, 0.011, 0.004, 0.42)
		panel.shadow_size = 4
		panel.shadow_offset = Vector2(2.0, 3.0)
		panel.expand_margin_left = 1.0
		panel.expand_margin_top = 1.0
		panel.expand_margin_right = 1.0
		panel.expand_margin_bottom = 2.0
		add_theme_stylebox_override("panel", panel)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_top", 10)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_bottom", 10)
		add_child(margin)

		var stack := VBoxContainer.new()
		stack.add_theme_constant_override("separation", 5)
		margin.add_child(stack)

		var top_row := HBoxContainer.new()
		top_row.add_theme_constant_override("separation", 8)
		stack.add_child(top_row)

		var title_label := Label.new()
		title_label.text = title
		title_label.custom_minimum_size = Vector2(166.0, 30.0)
		title_label.add_theme_font_size_override("font_size", 23)
		title_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018) if not locked else Color(0.13, 0.1, 0.075))
		title_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.84, 0.48, 0.2) if not locked else Color(0.05, 0.035, 0.02, 0.18))
		title_label.add_theme_constant_override("shadow_offset_x", 1)
		title_label.add_theme_constant_override("shadow_offset_y", 1)
		title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		top_row.add_child(title_label)

		var category_label := Label.new()
		category_label.text = category
		category_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		category_label.custom_minimum_size = Vector2(56.0, 26.0)
		category_label.add_theme_font_size_override("font_size", 13)
		category_label.add_theme_color_override("font_color", Color(0.18, 0.065, 0.025) if not locked else Color(0.13, 0.1, 0.075))
		category_label.add_theme_color_override("font_outline_color", accent.darkened(0.25))
		category_label.add_theme_constant_override("outline_size", 0)
		category_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.32, 0.28))
		category_label.add_theme_constant_override("shadow_offset_y", 1)
		top_row.add_child(category_label)

		var art := ColorRect.new()
		art.color = Color(0.22, 0.17, 0.12, 0.95) if locked else accent.lightened(0.06)
		art.custom_minimum_size = Vector2(236.0, 13.0)
		stack.add_child(art)

		var brass_rule := ColorRect.new()
		brass_rule.color = Color(1.0, 0.75, 0.28, 0.24) if not locked else Color(0.12, 0.09, 0.06, 0.34)
		brass_rule.custom_minimum_size = Vector2(236.0, 2.0)
		stack.add_child(brass_rule)

		var body_label := Label.new()
		body_label.text = body
		body_label.custom_minimum_size = Vector2(236.0, 94.0)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 18)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018) if not locked else Color(0.13, 0.1, 0.075))
		body_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.82, 0.48, 0.16) if not locked else Color(0.04, 0.03, 0.02, 0.14))
		body_label.add_theme_constant_override("shadow_offset_y", 1)
		stack.add_child(body_label)

		if footer != "":
			var footer_label := Label.new()
			footer_label.text = footer
			footer_label.custom_minimum_size = Vector2(236.0, 24.0)
			footer_label.add_theme_font_size_override("font_size", 14)
			footer_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045) if not locked else Color(0.16, 0.12, 0.08))
			footer_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.3, 0.18))
			footer_label.add_theme_constant_override("shadow_offset_y", 1)
			footer_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			stack.add_child(footer_label)

	func _draw() -> void:
		var card := Rect2(Vector2.ZERO, size)
		if size.x <= 2.0 or size.y <= 2.0:
			return
		var paper_color := Color(0.48, 0.39, 0.25, 0.94) if _locked else Color(0.9, 0.7, 0.38, 0.98)
		var leather := Color(0.11, 0.046, 0.022, 0.96)
		var brass := Color(1.0, 0.68, 0.24, 0.62)
		var ink := Color(0.075, 0.032, 0.015, 0.72)
		draw_rect(Rect2(Vector2(4.0, 5.0), size), Color(0.0, 0.0, 0.0, 0.28), true)
		draw_rect(card, leather, true)
		draw_rect(card.grow(-4.0), _accent.darkened(0.38), true)
		draw_rect(card.grow(-8.0), paper_color, true)
		draw_rect(Rect2(Vector2(10.0, 12.0), Vector2(maxf(0.0, size.x - 20.0), 7.0)), Color(1.0, 0.62, 0.18, 0.1), true)
		draw_rect(Rect2(Vector2(10.0, size.y - 19.0), Vector2(maxf(0.0, size.x - 20.0), 7.0)), Color(0.08, 0.03, 0.012, 0.16), true)
		draw_rect(card, Color(0.06, 0.024, 0.01, 0.9), false, 2.0)
		draw_rect(card.grow(-5.0), brass, false, 1.4)
		draw_rect(card.grow(-11.0), Color(0.18, 0.07, 0.025, 0.2), false, 1.0)
		var header := Rect2(Vector2(10.0, 10.0), Vector2(maxf(0.0, size.x - 20.0), 34.0))
		draw_rect(header, Color(0.16, 0.065, 0.027, 0.28), true)
		draw_rect(Rect2(header.position + Vector2(6.0, 5.0), Vector2(maxf(0.0, header.size.x - 12.0), 6.0)), Color(1.0, 0.82, 0.44, 0.11), true)
		draw_line(header.position + Vector2(8.0, header.size.y - 6.0), header.end - Vector2(8.0, 6.0), brass, 2.0)
		var rule_y := 61.0
		draw_line(Vector2(12.0, rule_y), Vector2(size.x - 12.0, rule_y), ink, 2.0)
		draw_line(Vector2(14.0, rule_y + 4.0), Vector2(size.x - 14.0, rule_y + 3.0), Color(1.0, 0.82, 0.44, 0.18), 1.2)
		for tick in range(5):
			var x := 22.0 + float(tick) * maxf(1.0, (size.x - 44.0) / 4.0)
			draw_line(Vector2(x - 5.0, rule_y - 5.0), Vector2(x + 5.0, rule_y - 2.0), brass.darkened(0.05), 1.1)
		for i in range(8):
			var y := 76.0 + float(i) * 12.0
			if y > size.y - 34.0:
				break
			var wobble := sin(float(i) * 1.7 + size.x * 0.01) * 2.0
			draw_line(Vector2(18.0, y), Vector2(size.x - 18.0, y + wobble), Color(0.2, 0.09, 0.035, 0.055), 1.0)
		for side in [18.0, size.x - 18.0]:
			draw_line(Vector2(side, 48.0), Vector2(side, size.y - 24.0), Color(0.16, 0.064, 0.024, 0.11), 1.2)
			for y in [54.0, 88.0, 122.0]:
				if y < size.y - 28.0:
					draw_circle(Vector2(side, y), 1.7, Color(0.08, 0.032, 0.012, 0.24))
		for rivet in [Vector2(9.0, 9.0), Vector2(size.x - 9.0, 9.0), Vector2(9.0, size.y - 9.0), Vector2(size.x - 9.0, size.y - 9.0)]:
			draw_circle(rivet, 3.1, Color(0.06, 0.024, 0.011, 0.55))
			draw_circle(rivet + Vector2(-0.8, -0.8), 1.8, brass)
		var stamp_center := Vector2(size.x - 42.0, size.y - 34.0)
		var stamp_color := Color(0.72, 0.08, 0.04, 0.19) if _locked else Color(_accent.r, _accent.g, _accent.b, 0.18)
		draw_arc(stamp_center, 24.0, -0.35, TAU - 0.35, 34, stamp_color, 3.0)
		draw_arc(stamp_center, 15.0, 0.0, TAU, 28, stamp_color, 1.8)
		if _category != "":
			draw_line(stamp_center + Vector2(-13.0, 0.0), stamp_center + Vector2(13.0, 0.0), stamp_color.lightened(0.1), 2.0)

class QuestCard extends PanelContainer:
	const VISUAL_VERSION := "quest_card_bounty_stamp_v2"
	var _name_label := Label.new()
	var _status_label := Label.new()
	var _description_label := Label.new()
	var _reward_label := Label.new()
	var _progress_bar := ProgressBar.new()
	var _complete := false

	func _init() -> void:
		custom_minimum_size = Vector2(500.0, 104.0)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_theme_stylebox_override("panel", _make_quest_panel_style(false))

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_bottom", 8)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(margin)

		var stack := VBoxContainer.new()
		stack.add_theme_constant_override("separation", 4)
		stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.add_child(stack)

		var top_row := HBoxContainer.new()
		top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(top_row)

		_name_label.custom_minimum_size = Vector2(330.0, 24.0)
		_name_label.add_theme_font_size_override("font_size", 18)
		_name_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		_name_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.34, 0.2))
		_name_label.add_theme_constant_override("shadow_offset_y", 1)
		_name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(_name_label)

		_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_status_label.custom_minimum_size = Vector2(138.0, 24.0)
		_status_label.add_theme_font_size_override("font_size", 13)
		_status_label.add_theme_color_override("font_color", Color(0.18, 0.065, 0.025))
		_status_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.76, 0.32, 0.22))
		_status_label.add_theme_constant_override("shadow_offset_y", 1)
		_status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		_status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(_status_label)

		_progress_bar.custom_minimum_size = Vector2(470.0, 12.0)
		_progress_bar.show_percentage = false
		_progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_progress_bar.add_theme_stylebox_override("background", _make_quest_bar_style(Color(0.16, 0.07, 0.03, 0.78)))
		_progress_bar.add_theme_stylebox_override("fill", _make_quest_bar_style(Color(0.94, 0.58, 0.16, 0.95)))
		stack.add_child(_progress_bar)

		_description_label.custom_minimum_size = Vector2(470.0, 34.0)
		_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_description_label.add_theme_font_size_override("font_size", 14)
		_description_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		_description_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.82, 0.48, 0.14))
		_description_label.add_theme_constant_override("shadow_offset_y", 1)
		_description_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(_description_label)

		_reward_label.custom_minimum_size = Vector2(470.0, 18.0)
		_reward_label.add_theme_font_size_override("font_size", 13)
		_reward_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045))
		_reward_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.3, 0.18))
		_reward_label.add_theme_constant_override("shadow_offset_y", 1)
		_reward_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		_reward_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(_reward_label)

	func configure(quest: Dictionary) -> void:
		var target := maxi(1, int(quest.get("target", 1)))
		var progress := clampi(int(quest.get("progress", 0)), 0, target)
		var complete := bool(quest.get("complete", false))
		_complete = complete
		var shown_progress := target if complete else progress
		_name_label.text = str(quest.get("name", "QUEST"))
		_status_label.text = "COMPLETE" if complete else "%d/%d" % [progress, target]
		_description_label.text = str(quest.get("description", ""))
		_reward_label.text = "REWARD STAMP: %s" % str(quest.get("reward", ""))
		_progress_bar.max_value = float(target)
		_progress_bar.value = float(shown_progress)
		add_theme_stylebox_override("panel", _make_quest_panel_style(complete))
		var fill_color := Color(0.58, 0.72, 0.34, 0.96) if complete else Color(0.94, 0.58, 0.16, 0.95)
		_progress_bar.add_theme_stylebox_override("fill", _make_quest_bar_style(fill_color))
		_status_label.add_theme_color_override("font_color", Color(0.24, 0.38, 0.1) if complete else Color(0.18, 0.065, 0.025))
		modulate = Color(1.0, 0.92, 0.66, 1.0) if complete else Color.WHITE
		queue_redraw()

	func get_visual_version() -> String:
		return VISUAL_VERSION

	func _make_quest_panel_style(complete: bool) -> StyleBoxFlat:
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
		style.border_color = Color(0.0, 0.0, 0.0, 0.0)
		style.border_width_left = 5
		style.border_width_top = 4
		style.border_width_right = 5
		style.border_width_bottom = 6
		style.corner_radius_top_left = 8
		style.corner_radius_top_right = 8
		style.corner_radius_bottom_left = 8
		style.corner_radius_bottom_right = 8
		style.shadow_color = Color(0.025, 0.011, 0.004, 0.42)
		style.shadow_size = 4
		style.shadow_offset = Vector2(2.0, 3.0)
		return style

	func _make_quest_bar_style(color: Color) -> StyleBoxFlat:
		var style := StyleBoxFlat.new()
		style.bg_color = color
		style.corner_radius_top_left = 3
		style.corner_radius_top_right = 3
		style.corner_radius_bottom_left = 3
		style.corner_radius_bottom_right = 3
		return style

	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()

	func _draw() -> void:
		var card := Rect2(Vector2.ZERO, size)
		if size.x <= 2.0 or size.y <= 2.0:
			return
		var paper := Color(0.76, 0.66, 0.34, 0.97) if _complete else Color(0.88, 0.68, 0.36, 0.97)
		var brass := Color(0.9, 0.57, 0.18, 0.68)
		var leather := Color(0.11, 0.045, 0.02, 0.96)
		draw_rect(Rect2(Vector2(4.0, 5.0), size), Color(0.0, 0.0, 0.0, 0.26), true)
		draw_rect(card, leather, true)
		draw_rect(card.grow(-4.0), Color(0.28, 0.13, 0.055, 0.94), true)
		draw_rect(card.grow(-8.0), paper, true)
		draw_rect(card, Color(0.06, 0.024, 0.01, 0.92), false, 2.0)
		draw_rect(card.grow(-5.0), brass, false, 1.4)
		var title_band := Rect2(Vector2(12.0, 9.0), Vector2(maxf(0.0, size.x - 24.0), 26.0))
		draw_rect(title_band, Color(0.15, 0.06, 0.024, 0.24), true)
		draw_line(title_band.position + Vector2(8.0, title_band.size.y - 5.0), title_band.end - Vector2(8.0, 5.0), brass, 1.8)
		var progress_well := Rect2(Vector2(14.0, 37.0), Vector2(maxf(0.0, size.x - 28.0), 18.0))
		draw_rect(progress_well, Color(0.065, 0.026, 0.012, 0.68), true)
		draw_rect(progress_well, Color(1.0, 0.72, 0.28, 0.22), false, 1.2)
		for i in range(5):
			var y := 64.0 + float(i) * 10.0
			if y > size.y - 16.0:
				break
			draw_line(Vector2(18.0, y), Vector2(size.x - 18.0, y + sin(float(i) * 1.4) * 1.4), Color(0.2, 0.09, 0.035, 0.06), 1.0)
		for rivet in [Vector2(10.0, 10.0), Vector2(size.x - 10.0, 10.0), Vector2(10.0, size.y - 10.0), Vector2(size.x - 10.0, size.y - 10.0)]:
			draw_circle(rivet, 3.0, Color(0.05, 0.02, 0.009, 0.58))
			draw_circle(rivet + Vector2(-0.8, -0.8), 1.7, brass)
		var stamp_center := Vector2(size.x - 62.0, size.y - 34.0)
		var stamp_color := Color(0.34, 0.5, 0.13, 0.28) if _complete else Color(0.72, 0.08, 0.04, 0.16)
		draw_arc(stamp_center, 24.0, -0.2, TAU - 0.2, 34, stamp_color, 3.0)
		draw_line(stamp_center + Vector2(-15.0, -2.0), stamp_center + Vector2(15.0, 2.0), stamp_color.lightened(0.08), 2.0)

var _root := Control.new()
var _menu_root := Control.new()
var _menu_backdrop := MenuBackdrop.new()
var _menu_title := Label.new()
var _menu_panel := VBoxContainer.new()
var _menu_content := HBoxContainer.new()
var _cards_scroll := ScrollContainer.new()
var _cards_grid := GridContainer.new()
var _guns_panel := VBoxContainer.new()
var _guns_grid := GridContainer.new()
var _abilities_panel := VBoxContainer.new()
var _abilities_grid := GridContainer.new()
var _quests_panel := VBoxContainer.new()
var _upgrades_panel := VBoxContainer.new()
var _upgrades_scroll := ScrollContainer.new()
var _upgrades_grid := GridContainer.new()
var _gun_buttons: Dictionary = {}
var _ability_buttons: Dictionary = {}
var _upgrade_buttons: Dictionary = {}
var _gun_icons: Dictionary = {}
var _ability_icons: Dictionary = {}
var _quest_labels: Dictionary = {}
var _quest_cards: Array[QuestCard] = []
var _upgrade_data: Array[Dictionary] = []
var _upgrade_tokens := 0
var _menu_buttons: Array[Button] = []
var _menu_loaded := false
var _menu_memory_log_enabled := false
var _active_menu_button_id := ""
var _last_menu_content_width := 0.0
var _last_menu_nav_width := 0.0
var _last_menu_right_width := 0.0
var _last_menu_column_count := 2
const INFORMATION_CARDS := [
	{"title": "Move", "category": "INPUT", "body": "Use WASD or arrow keys to cross the courtyard and dodge enemy pressure.", "footer": "Keyboard", "accent": Color(0.62, 0.35, 0.16)},
	{"title": "Dash", "category": "INPUT", "body": "Press Space to burst through danger. Dashing adds heat, so spend it with intent.", "footer": "Space", "accent": Color(0.86, 0.58, 0.28)},
	{"title": "Slash", "category": "INPUT", "body": "Press J or left mouse to swing your sword. Use it for close kills and clutch parries.", "footer": "J / Mouse", "accent": Color(0.78, 0.45, 0.2)},
	{"title": "Abilities", "category": "INPUT", "body": "Press 1-4 to cast equipped ability cards. Open Abilities to change the loadout.", "footer": "Slots 1-4", "accent": Color(0.95, 0.78, 0.36)},
	{"title": "Cylinder", "category": "GUN", "body": "Gun abilities spend rounds from your equipped weapon. Empty cylinders reload automatically, so time your shots.", "footer": "Ammo loop", "accent": Color(0.86, 0.58, 0.28)},
	{"title": "Reload Rhythm", "category": "GUN", "body": "Empty cylinder starts auto reload. When the brass glint flashes and CYLINDER READY returns, draw again.", "footer": "Glint means ready", "accent": Color(1.0, 0.72, 0.24)},
	{"title": "Knife Rusher", "category": "ENEMY", "body": "Closes distance quickly and forces you to move. Cut them before they box you in.", "footer": "Melee threat", "accent": Color(0.86, 0.38, 0.08)},
	{"title": "Rifleman", "category": "ENEMY", "body": "Controls long lanes with aimed shots. Break line pressure with movement or Deadeye.", "footer": "Range threat", "accent": Color(0.72, 0.38, 0.16)},
	{"title": "Shotgun Brute", "category": "ENEMY", "body": "Punishes corners and close mistakes. Keep space, dash wide, then strike.", "footer": "Heavy threat", "accent": Color(0.55, 0.18, 0.08)},
	{"title": "Hunter", "category": "ENEMY", "body": "Lean duster that paints an amber lunge lane before rushing. Sidestep the line, then punish.", "footer": "Late-wave pressure", "accent": Color(0.82, 0.22, 0.08)},
	{"title": "Duelist", "category": "BOSS", "body": "Appears every third wave with a wanted-card intro and a dangerous lunge pattern.", "footer": "Boss wave", "accent": Color(0.72, 0.08, 0.04)},
	{"title": "Read The Tells", "category": "SKILL", "body": "Boot dust means a duelist dash is loading. Shell smoke means a brute just fired and is open.", "footer": "Watch feet and smoke", "accent": Color(0.86, 0.58, 0.28)},
	{"title": "Style Ranks", "category": "STYLE", "body": "C 2600, B 5200, A 8500, S 12500. Keep chains alive, hit LAST SECOND, and earn mastery rewards for final grade.", "footer": "Chain + mastery", "accent": Color(1.0, 0.72, 0.24)},
	{"title": "Upgrade Tokens", "category": "PROGRESS", "body": "Quests and rival boss defeats pay tokens. Spend them in Upgrades for permanent hearts, speed, blades, guns, abilities, and rewards.", "footer": "Permanent power", "accent": Color(0.58, 0.72, 0.34)},
	{"title": "Reverend Ash", "category": "SET-PIECE", "body": "Dust Chapel's judge sends brutes down dark aisles. Cross the brass chevrons, do not retreat with them.", "footer": "Wave 5 lanes", "accent": Color(0.58, 0.16, 0.08)},
	{"title": "Gold Rush", "category": "STYLE", "body": "Brass rails link paired powder kegs. Slash or shoot one, bait outlaws into the lane, and chain pairs for POWDER KEG style.", "footer": "Wave 8 mastery", "accent": Color(1.0, 0.64, 0.18)},
	{"title": "Red Canyon", "category": "STYLE", "body": "Calm pockets cut through the sandstorm. Hold one as a Hunter lunges to earn CANYON POCKET style.", "footer": "Wave 7 mastery", "accent": Color(0.78, 0.52, 0.18)},
	{"title": "June Blackglass", "category": "BOSS", "body": "High-society heir who turns wave 9 into a glass kill box. Hold dash, break red lanes, then parry.", "footer": "Wave 9 rival", "accent": Color(0.82, 0.16, 0.26)},
	{"title": "Last High Noon", "category": "STYLE", "body": "The east exit lane glows before extraction. Hold it under pressure to earn EXIT LANE style.", "footer": "Wave 10 mastery", "accent": Color(1.0, 0.66, 0.18)},
]
var _gun_ids: Array[String] = ["revolver", "long_rifle", "sawed_off", "pepperbox", "golden_revolver"]
var _gun_names := {
	"revolver": "Revolver",
	"long_rifle": "Long Rifle",
	"sawed_off": "Sawed-Off",
	"pepperbox": "Pepperbox",
	"golden_revolver": "Golden Revolver",
}
var _gun_descriptions := {
	"revolver": "Six steady rounds, balanced reload.",
	"long_rifle": "Four heavy rounds, long reload.",
	"sawed_off": "Two wide blasts, quick reload.",
	"pepperbox": "Eight light rounds, fast fire.",
	"golden_revolver": "Six gold rounds, swift reload.",
}
var _gun_unlocks := {
	"revolver": "Starter gun",
	"long_rifle": "Unlock: kill 40 enemies",
	"sawed_off": "Unlock: reach wave 8",
	"pepperbox": "Unlock: defeat 5 duelists",
	"golden_revolver": "Unlock: kill 400 enemies",
}
var _unlocked_guns: Array[String] = ["revolver"]
var _equipped_gun := "revolver"
var _ability_ids: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw", "duelist_lunge", "fan_hammer", "ghost_step"]
var _ability_names := {
	"deadeye": "Deadeye",
	"ricochet_shot": "Ricochet Shot",
	"dust_veil": "Dust Veil",
	"quickdraw": "Quickdraw",
	"duelist_lunge": "Duelist Lunge",
	"fan_hammer": "Fan Hammer",
	"ghost_step": "Ghost Step",
}
var _ability_descriptions := {
	"deadeye": "A calm long-range shot.",
	"ricochet_shot": "A bullet that bounces.",
	"dust_veil": "A short sand-cloak escape.",
	"quickdraw": "A fast revolver shot.",
	"duelist_lunge": "A sharp sword dash.",
	"fan_hammer": "Rapid close-range fire.",
	"ghost_step": "A longer dust sidestep.",
}
var _unlocked_abilities: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
var _equipped_abilities: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
var _quest_data: Array[Dictionary] = []
var _health_bar := ColorRect.new()
var _health_back := ColorRect.new()
var _hud_ledger_frame := HudLedgerFrame.new()
var _live_hud_label_change_count := 0
var _heart_label := Label.new()
var _alert_label := Label.new()
var _timer_label := Label.new()
var _wave_label := Label.new()
var _style_label := Label.new()
var _ammo_label := Label.new()
var _style_pop_back := ColorRect.new()
var _style_pop_rule := ColorRect.new()
var _style_pop := Label.new()
var _style_pop_tween: Tween = null
var _message_label := Label.new()
var _unlock_toast_frame := UnlockToastFrame.new()
var _unlock_tween: Tween = null
var _objective_panel := PanelContainer.new()
var _objective_title := Label.new()
var _objective_goal := Label.new()
var _objective_tip := Label.new()
var _objective_progress_back := ColorRect.new()
var _objective_progress_fill := ColorRect.new()
var _payday_feedback_timer := 0.0
var _payday_feedback_goal := ""
var _payday_feedback_tip := ""
var _payday_feedback_count := 0
var _wave_clear_feedback_timer := 0.0
var _wave_clear_feedback_goal := ""
var _wave_clear_feedback_tip := ""
var _wave_clear_feedback_count := 0
var _training_panel := PanelContainer.new()
var _training_title := Label.new()
var _training_body := Label.new()
var _training_footer := Label.new()
var _training_complete_tween: Tween = null
var _training_completion_count := 0
var _rookie_panel := PanelContainer.new()
var _rookie_title := Label.new()
var _rookie_body := Label.new()
var _wave_banner := Label.new()
var _wave_banner_tween: Tween = null
var _death_screen := ColorRect.new()
var _result_card := ResultCardFrame.new()
var _result_card_glow := ColorRect.new()
var _result_divider_top := ColorRect.new()
var _result_divider_mid := ColorRect.new()
var _result_divider_bottom := ColorRect.new()
var _death_label := Label.new()
var _death_tween: Tween = null
var _hit_flash := ColorRect.new()
var _danger_flash := ColorRect.new()
var _danger_label := Label.new()
var _danger_warning_tween: Tween = null
var _hunter_lunge_warning_count := 0
var _black_sash_lunge_warning_count := 0
var _mercy_vale_lunge_warning_count := 0
var _june_blackglass_lunge_warning_count := 0
var _duelist_overlay := Control.new()
var _duelist_card := DuelistIntroCard.new()
var _duelist_name := Label.new()
var _duelist_title := Label.new()
var _duelist_art := Label.new()
var _duelist_line := Label.new()
var _duelist_leaves: Array[ColorRect] = []
var _duelist_intro_tween: Tween = null
var _skill_icons: Array[SkillIcon] = []
var _elapsed := 0.0

func _ready() -> void:
	layer = 50
	add_child(_root)
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_create_menu()

	_hud_ledger_frame.position = Vector2(18.0, 18.0)
	_hud_ledger_frame.size = Vector2(430.0, 288.0)
	_hud_ledger_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_hud_ledger_frame)

	_health_back.color = Color(0.035, 0.022, 0.016, 0.92)
	_health_back.position = Vector2(28, 28)
	_health_back.size = Vector2(260, 16)
	_root.add_child(_health_back)

	_health_bar.color = Color(0.72, 0.42, 0.18, 0.95)
	_health_bar.position = _health_back.position
	_health_bar.size = _health_back.size
	_root.add_child(_health_bar)
	_configure_label(_heart_label, Vector2(28, 50), 22)
	_heart_label.add_theme_color_override("font_color", Color(0.94, 0.16, 0.08))

	_configure_label(_alert_label, Vector2(28, 78), 18)
	_configure_label(_timer_label, Vector2(28, 104), 18)
	_configure_label(_wave_label, Vector2(28, 130), 18)
	_configure_label(_style_label, Vector2(28, 214), 20)
	_style_label.add_theme_color_override("font_color", Color(1.0, 0.76, 0.32))
	_configure_label(_ammo_label, Vector2(28, 266), 18)
	_ammo_label.add_theme_color_override("font_color", Color(0.95, 0.82, 0.52))
	_create_skill_icons()

	_style_pop_back.visible = true
	_style_pop_back.color = Color(0.055, 0.026, 0.014, 0.0)
	_style_pop_back.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_style_pop_back.offset_left = -438.0
	_style_pop_back.offset_top = 204.0
	_style_pop_back.offset_right = -22.0
	_style_pop_back.offset_bottom = 298.0
	_style_pop_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_style_pop_back)

	_style_pop_rule.visible = true
	_style_pop_rule.color = Color(1.0, 0.64, 0.18, 0.0)
	_style_pop_rule.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_style_pop_rule.offset_left = -408.0
	_style_pop_rule.offset_top = 254.0
	_style_pop_rule.offset_right = -28.0
	_style_pop_rule.offset_bottom = 258.0
	_style_pop_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_style_pop_rule)

	_style_pop.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_style_pop.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_style_pop.add_theme_font_size_override("font_size", 24)
	_style_pop.add_theme_color_override("font_color", Color(1.0, 0.82, 0.38, 0.0))
	_style_pop.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_style_pop.offset_left = -420.0
	_style_pop.offset_top = 214.0
	_style_pop.offset_right = -28.0
	_style_pop.offset_bottom = 270.0
	_style_pop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_style_pop)

	_unlock_toast_frame.visible = false
	_unlock_toast_frame.modulate.a = 1.0
	_unlock_toast_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_unlock_toast_frame)

	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_message_label.add_theme_font_size_override("font_size", 34)
	_message_label.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))
	_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_message_label.offset_left = 0.0
	_message_label.offset_top = 22.0
	_message_label.offset_right = 0.0
	_message_label.offset_bottom = 318.0
	_message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_message_label)
	_layout_message_label_default()
	_create_objective_tracker()
	_create_training_tracker()
	_create_rookie_primer()

	_death_screen.color = Color(0.05, 0.008, 0.006, 0.0)
	_death_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_death_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_death_screen)

	_result_card.visible = false
	_result_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_result_card)

	_result_card_glow.visible = false
	_result_card_glow.color = Color(1.0, 0.58, 0.16, 0.0)
	_result_card_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_result_card_glow)

	for divider in [_result_divider_top, _result_divider_mid, _result_divider_bottom]:
		divider.visible = false
		divider.color = Color(1.0, 0.68, 0.22, 0.88)
		divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(divider)

	_death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_death_label.add_theme_font_size_override("font_size", 72)
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	_death_label.text = "YOU DIED"
	_death_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_death_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_death_label)

	_wave_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_wave_banner.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_wave_banner.add_theme_font_size_override("font_size", 52)
	_wave_banner.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))
	_wave_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_wave_banner.position = Vector2(2000, 260)
	_wave_banner.size = Vector2(520, 92)
	_wave_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_wave_banner)

	_hit_flash.color = Color(0.9, 0.0, 0.0, 0.0)
	_hit_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hit_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_hit_flash)

	_danger_flash.color = Color(1.0, 0.42, 0.04, 0.0)
	_danger_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_danger_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_danger_flash)

	_danger_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_danger_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_danger_label.add_theme_font_size_override("font_size", 26)
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.26, 0.0))
	_danger_label.text = ""
	_danger_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_danger_label.offset_left = 0.0
	_danger_label.offset_top = 148.0
	_danger_label.offset_right = 0.0
	_danger_label.offset_bottom = 190.0
	_danger_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_danger_label)

	_duelist_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_duelist_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_overlay.visible = false
	_root.add_child(_duelist_overlay)

	var backdrop := ColorRect.new()
	backdrop.color = Color(0.04, 0.018, 0.012, 0.76)
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_overlay.add_child(backdrop)

	for i in range(18):
		var leaf := ColorRect.new()
		leaf.color = Color(0.8, 0.56, 0.26, 0.24)
		leaf.size = Vector2(72.0, 3.0)
		leaf.rotation = -0.18
		leaf.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_duelist_leaves.append(leaf)
		_duelist_overlay.add_child(leaf)

	_duelist_card.size = Vector2(260, 392)
	_duelist_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_overlay.add_child(_duelist_card)

	_duelist_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_title.add_theme_font_size_override("font_size", 24)
	_duelist_title.add_theme_color_override("font_color", Color(0.18, 0.065, 0.024))
	_duelist_title.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.34, 0.24))
	_duelist_title.add_theme_constant_override("shadow_offset_y", 1)
	_duelist_title.text = "DUELIST"
	_duelist_title.position = Vector2(22, 29)
	_duelist_title.size = Vector2(216, 40)
	_duelist_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_title)

	_duelist_art.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_art.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_duelist_art.add_theme_font_size_override("font_size", 20)
	_duelist_art.add_theme_color_override("font_color", Color(0.16, 0.055, 0.018, 0.88))
	_duelist_art.text = "WANTED"
	_duelist_art.position = Vector2(28, 75)
	_duelist_art.size = Vector2(204, 34)
	_duelist_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_art)

	_duelist_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_name.add_theme_font_size_override("font_size", 23)
	_duelist_name.add_theme_color_override("font_color", Color(0.13, 0.042, 0.016))
	_duelist_name.add_theme_color_override("font_shadow_color", Color(1.0, 0.74, 0.28, 0.2))
	_duelist_name.add_theme_constant_override("shadow_offset_y", 1)
	_duelist_name.size = Vector2(216, 58)
	_duelist_name.position = Vector2(22, 257)
	_duelist_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_duelist_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_name)

	_duelist_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_line.add_theme_font_size_override("font_size", 14)
	_duelist_line.add_theme_color_override("font_color", Color(0.24, 0.09, 0.035))
	_duelist_line.size = Vector2(218, 48)
	_duelist_line.position = Vector2(21, 324)
	_duelist_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_duelist_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_line)

func update_run(player, director, program_system, wave: int, enemies_remaining: int, max_wave: int = 0, level_title: String = "", level_notice: String = "", style_score: int = 0, combo_count: int = 0, combo_fraction: float = 0.0, style_rank: String = "D", ammo_summary: Dictionary = {}, wave_active: bool = true, wave_break_remaining: float = 0.0, payday_pending: int = 0) -> void:
	var frame_delta := get_process_delta_time()
	_elapsed += frame_delta
	_payday_feedback_timer = maxf(0.0, _payday_feedback_timer - frame_delta)
	_wave_clear_feedback_timer = maxf(0.0, _wave_clear_feedback_timer - frame_delta)
	var health_fraction: float = clamp(player.health / player.max_health, 0.0, 1.0)
	_health_bar.size.x = 260.0 * health_fraction
	_health_bar.color = Color(0.72, 0.08, 0.04) if health_fraction < 0.34 else Color(0.72, 0.42, 0.18)
	_set_live_hud_label_text(_heart_label, _format_hearts(int(ceil(player.health)), int(player.max_health)))

	_set_live_hud_label_text(_alert_label, "DANGER %d  %02d%%" % [director.alert_level, int(director.alert_meter * 100.0)])
	_set_live_hud_label_text(_timer_label, "TIME %02d:%02d" % [int(_elapsed / 60.0), int(_elapsed) % 60])
	var wave_text := "WAVE %d/%d" % [wave, max_wave] if max_wave > 0 else "WAVE %d" % wave
	var next_wave_label := "%s  ENEMIES %d" % [wave_text, enemies_remaining]
	if level_title != "":
		next_wave_label += "\n%s" % level_title.to_upper()
	if level_notice != "":
		next_wave_label += " - %s" % level_notice.to_upper()
	_set_live_hud_label_text(_wave_label, next_wave_label)
	var next_style_label := "RANK %s  SCORE %d" % [style_rank, style_score]
	var chain_fraction := clampf(combo_fraction, 0.0, 1.0)
	if combo_count > 0:
		var chain_percent := int(round(chain_fraction * 100.0))
		next_style_label += "\nCOMBO x%d  CHAIN %02d%%" % [combo_count, chain_percent]
		var pulse := 0.5 + sin(_elapsed * 12.0) * 0.5
		var warning_heat := 1.0 - chain_fraction
		_style_label.add_theme_color_override("font_color", Color(1.0, 0.68 + pulse * 0.12, 0.26 - warning_heat * 0.08, 0.98))
	else:
		_style_label.add_theme_color_override("font_color", Color(1.0, 0.76, 0.32))
	_set_live_hud_label_text(_style_label, next_style_label)
	_update_ammo_label(ammo_summary)
	_update_objective_tracker(wave, max_wave, enemies_remaining, level_title, level_notice, wave_active, wave_break_remaining, payday_pending)
	_update_skill_icons(program_system)

func _set_live_hud_label_text(label: Label, text: String) -> void:
	if label.text == text:
		return
	label.text = text
	_live_hud_label_change_count += 1

func _create_training_tracker() -> void:
	_training_panel.visible = false
	_training_panel.custom_minimum_size = Vector2(310.0, 150.0)
	_training_panel.add_theme_stylebox_override("panel", _make_card_style(Color(0.49, 0.64, 0.32)))
	_training_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_training_panel.offset_left = -342.0
	_training_panel.offset_top = 376.0
	_training_panel.offset_right = -28.0
	_training_panel.offset_bottom = 530.0
	_training_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_training_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_training_panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 6)
	stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(stack)

	_training_title.text = "TRAINING LEDGER"
	_training_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_training_title.add_theme_font_size_override("font_size", 20)
	_training_title.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_training_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_training_title)

	_training_body.add_theme_font_size_override("font_size", 15)
	_training_body.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_training_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_training_body.custom_minimum_size = Vector2(282.0, 72.0)
	_training_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_training_body)

	_training_footer.add_theme_font_size_override("font_size", 14)
	_training_footer.add_theme_color_override("font_color", Color(0.2, 0.09, 0.035))
	_training_footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_training_footer.custom_minimum_size = Vector2(282.0, 28.0)
	_training_footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_training_footer)

func update_training_tracker(steps: Dictionary, current_tip: String, active: bool) -> void:
	if _training_complete_tween != null and _training_complete_tween.is_valid():
		_training_complete_tween.kill()
	_training_complete_tween = null
	_training_title.text = "TRAINING LEDGER"
	_training_panel.add_theme_stylebox_override("panel", _make_card_style(Color(0.49, 0.64, 0.32)))
	_training_panel.visible = active
	if not active:
		return
	_training_body.text = _format_training_steps(steps)
	_training_footer.text = current_tip

func show_training_complete_feedback(steps: Dictionary) -> void:
	_training_completion_count += 1
	if _training_complete_tween != null and _training_complete_tween.is_valid():
		_training_complete_tween.kill()
	_training_panel.add_theme_stylebox_override("panel", _make_card_style(Color(0.58, 0.48, 0.22)))
	_training_panel.visible = true
	_training_title.text = "BASICS READY"
	_training_body.text = _format_training_steps(steps)
	_training_footer.text = "CLEAR TEN LEVELS\nPAYDAY SATCHELS OPTIONAL +CREDITS +ROUNDS"
	_training_complete_tween = create_tween()
	_training_complete_tween.tween_interval(1.35)
	_training_complete_tween.tween_callback(func() -> void:
		_training_panel.visible = false
	)

func get_training_tracker_text() -> String:
	return "%s\n%s\n%s" % [_training_title.text, _training_body.text, _training_footer.text]

func get_training_completion_count() -> int:
	return _training_completion_count

func _format_training_steps(steps: Dictionary) -> String:
	var step_lines: Array[String] = []
	step_lines.append("%s MOVE  WASD / ARROWS" % _training_mark(bool(steps.get("move", false))))
	step_lines.append("%s DASH  SPACE" % _training_mark(bool(steps.get("dash", false))))
	step_lines.append("%s SLASH  J / MOUSE" % _training_mark(bool(steps.get("slash", false))))
	step_lines.append("%s CAST  1-4" % _training_mark(bool(steps.get("cast", false))))
	return "\n".join(step_lines)

func _training_mark(done: bool) -> String:
	return "DONE" if done else "TODO"

func _create_objective_tracker() -> void:
	_objective_panel.visible = false
	_objective_panel.custom_minimum_size = Vector2(310.0, 138.0)
	_objective_panel.add_theme_stylebox_override("panel", _make_card_style(Color(0.86, 0.58, 0.28)))
	_objective_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_objective_panel.offset_left = -342.0
	_objective_panel.offset_top = 220.0
	_objective_panel.offset_right = -28.0
	_objective_panel.offset_bottom = 362.0
	_objective_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_objective_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_objective_panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 6)
	stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(stack)

	_objective_title.text = "RUN LEDGER"
	_objective_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_objective_title.add_theme_font_size_override("font_size", 20)
	_objective_title.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_objective_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_objective_title)

	_objective_progress_back.color = Color(0.12, 0.055, 0.025, 0.9)
	_objective_progress_back.custom_minimum_size = Vector2(282.0, 9.0)
	_objective_progress_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_objective_progress_back)
	_objective_progress_fill.color = Color(0.86, 0.22, 0.08, 0.92)
	_objective_progress_fill.position = Vector2.ZERO
	_objective_progress_fill.size = Vector2.ZERO
	_objective_progress_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_objective_progress_back.add_child(_objective_progress_fill)

	_objective_goal.add_theme_font_size_override("font_size", 15)
	_objective_goal.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_objective_goal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_objective_goal.custom_minimum_size = Vector2(282.0, 42.0)
	_objective_goal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_objective_goal)

	_objective_tip.add_theme_font_size_override("font_size", 15)
	_objective_tip.add_theme_color_override("font_color", Color(0.24, 0.075, 0.035))
	_objective_tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_objective_tip.custom_minimum_size = Vector2(282.0, 34.0)
	_objective_tip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_objective_tip)

func _update_objective_tracker(wave: int, max_wave: int, enemies_remaining: int, level_title: String, level_notice: String, wave_active: bool, wave_break_remaining: float, payday_pending: int) -> void:
	var max_value := maxi(max_wave, 1)
	var progress := clampf(float(maxi(wave, 0)) / float(max_value), 0.0, 1.0)
	_objective_progress_fill.size = Vector2(282.0 * progress, 9.0)
	_objective_progress_fill.color = Color(0.86, 0.22, 0.08, 0.92)
	var shown_wave := clampi(maxi(wave, 1), 1, max_value)
	var title_text := level_title.to_upper() if level_title != "" else "COURTHOUSE APPROACH"
	var notice_text := level_notice.to_upper() if level_notice != "" else "OPEN COURTYARD"
	if _payday_feedback_timer > 0.0:
		_objective_title.text = "PAYDAY BANKED"
		_objective_goal.text = _payday_feedback_goal
		_objective_tip.text = _payday_feedback_tip
		_objective_progress_fill.color = Color(0.34, 0.56, 0.18, 0.95)
	elif _wave_clear_feedback_timer > 0.0:
		_objective_title.text = "LEVEL CLEARED"
		_objective_goal.text = _wave_clear_feedback_goal
		_objective_tip.text = _wave_clear_feedback_tip
		_objective_progress_fill.color = Color(0.86, 0.58, 0.18, 0.95)
	elif wave_active and max_wave > 0 and shown_wave >= max_value:
		_objective_title.text = "FINAL EXTRACTION"
		_objective_goal.text = "LAST HIGH NOON\nCLEAR %d TO RIDE OUT\nEAST EXIT TRAIL MARKED" % enemies_remaining
		_objective_tip.text = _get_objective_tip(wave, max_wave, enemies_remaining, level_notice, wave_active, wave_break_remaining, payday_pending)
		_objective_progress_fill.color = Color(1.0, 0.66, 0.18, 0.96)
	elif wave_active:
		_objective_title.text = "RUN LEDGER"
		_objective_goal.text = "EXTRACT: LEVEL %d/%d\n%s\n%s" % [shown_wave, max_value, title_text, notice_text]
		_objective_tip.text = _get_objective_tip(wave, max_wave, enemies_remaining, level_notice, wave_active, wave_break_remaining, payday_pending)
	else:
		_objective_title.text = "NEXT LEVEL"
		_objective_goal.text = "READY UP: LEVEL %d/%d\n%s\n%s" % [shown_wave, max_value, title_text, notice_text]
		_objective_tip.text = _get_objective_tip(wave, max_wave, enemies_remaining, level_notice, wave_active, wave_break_remaining, payday_pending)

func _get_objective_tip(wave: int, max_wave: int, enemies_remaining: int, level_notice: String, wave_active: bool, wave_break_remaining: float, payday_pending: int) -> String:
	var notice := level_notice.to_lower()
	if wave_active and notice.find("powder") >= 0:
		return "BANK VAULT  BAIT OUTLAWS INTO LANES, THEN CHAIN PAIRS"
	if wave_active and notice.find("rail") >= 0:
		return "RAIL YARD  DASH ACROSS LANES, USE DUST FOR SPACING"
	if wave_active and notice.find("chapel") >= 0:
		return "DUST CHAPEL  ASH'S BRUTES HOLD AISLES, DASH ACROSS LANES"
	if wave_active and notice.find("fast-draw") >= 0:
		return "MERCY VALE  WAIT FOR DRAW LINE, DASH SIDE, THEN PARRY"
	if wave_active and notice.find("high-society") >= 0:
		return "KILL BOX  HOLD DASH, PARRY JUNE, BREAK CROSS-PRESSURE"
	if wave_active and notice.find("last high noon") >= 0:
		return "LAST HIGH NOON  HOLD EXIT LANE FOR STYLE, DASH HUNTERS, EXTRACT"
	if wave_active and notice.find("duelist") >= 0:
		return "DUEL GROUND  HOLD SASH MARK WHEN BOOT DUST RISES"
	if payday_pending > 0:
		return "PAYDAY SATCHEL DOWN  SCOOP IT UP FOR CREDITS + ROUNDS"
	if wave <= 0 or not wave_active:
		return "NEXT IN %.1fs  RELOAD NOW  SPACE DASH  J SLASH  1-4 GUNS" % maxf(0.0, wave_break_remaining)
	if enemies_remaining <= 0:
		return "HOLD STEADY  THE NEXT PRESSURE SPIKE IS COMING"
	if max_wave > 0 and wave >= max_wave:
		return "FINAL STAND  CLEAR EVERY OUTLAW AND EXTRACT"
	if wave == 1:
		return "FIRST DRAW  SLASH ONE RUSHER, DASH WIDE, THEN TRY A GUN"
	if wave % 3 == 0:
		return "DUELIST WAVE  WATCH THE DRAW, PARRY THE LUNGE"
	if notice.find("keg") >= 0:
		return "USE POWDER KEGS  RED RINGS MEAN MOVE"
	if notice.find("sandstorm") >= 0:
		return "RED CANYON  HOLD CALM POCKETS FOR STYLE, DODGE HUNTERS"
	if notice.find("crossfire") >= 0:
		return "CROSSFIRE  BAIT RIFLES INTO COVER, SPLINTER FOR STYLE"
	if notice.find("brute") >= 0:
		return "BRUTES  KEEP SPACE, DASH OUT, THEN PUNISH"
	return "CLEAR %d OUTLAWS  SAVE DASH FOR BAD ANGLES" % enemies_remaining

func get_objective_tip_text() -> String:
	return _objective_tip.text

func get_message_text() -> String:
	return _message_label.text

func get_unlock_toast_visual_version() -> String:
	if _unlock_toast_frame != null and is_instance_valid(_unlock_toast_frame) and _unlock_toast_frame.has_method("get_visual_version"):
		return str(_unlock_toast_frame.get_visual_version())
	return ""

func get_unlock_toast_detail_marker_count() -> int:
	if _unlock_toast_frame != null and is_instance_valid(_unlock_toast_frame) and _unlock_toast_frame.has_method("get_detail_marker_count"):
		return int(_unlock_toast_frame.get_detail_marker_count())
	return 0

func get_unlock_toast_visible() -> bool:
	return _unlock_toast_frame != null and is_instance_valid(_unlock_toast_frame) and _unlock_toast_frame.visible

func get_unlock_toast_text() -> String:
	return _message_label.text

func get_style_pop_text() -> String:
	return _style_pop.text

func get_style_pop_frame_alpha() -> float:
	return _style_pop_back.color.a

func get_style_label_text() -> String:
	return _style_label.text

func get_payday_feedback_count() -> int:
	return _payday_feedback_count

func get_payday_feedback_text() -> String:
	return "%s\n%s\n%s" % [_objective_title.text, _objective_goal.text, _objective_tip.text]

func get_wave_clear_feedback_count() -> int:
	return _wave_clear_feedback_count

func get_wave_clear_feedback_text() -> String:
	return "%s\n%s\n%s" % [_objective_title.text, _objective_goal.text, _objective_tip.text]

func get_objective_tracker_text() -> String:
	return "%s\n%s\n%s" % [_objective_title.text, _objective_goal.text, _objective_tip.text]

func clear_objective_feedback() -> void:
	_payday_feedback_timer = 0.0
	_wave_clear_feedback_timer = 0.0

func get_hunter_lunge_warning_count() -> int:
	return _hunter_lunge_warning_count

func get_black_sash_lunge_warning_count() -> int:
	return _black_sash_lunge_warning_count

func get_mercy_vale_lunge_warning_count() -> int:
	return _mercy_vale_lunge_warning_count

func get_june_blackglass_lunge_warning_count() -> int:
	return _june_blackglass_lunge_warning_count

func get_death_text() -> String:
	return _death_label.text

func get_result_divider_count() -> int:
	var visible_dividers := 0
	for divider in [_result_divider_top, _result_divider_mid, _result_divider_bottom]:
		if divider.visible:
			visible_dividers += 1
	return visible_dividers

func get_result_card_visible() -> bool:
	return _result_card.visible

func get_result_card_visual_version() -> String:
	return _result_card.get_visual_version()

func get_result_card_detail_marker_count() -> int:
	if _result_card != null and is_instance_valid(_result_card) and _result_card.has_method("get_detail_marker_count"):
		return int(_result_card.get_detail_marker_count())
	return 0

func get_result_backdrop_dim_alpha() -> float:
	return _death_screen.color.a

func get_result_duplicate_banner_hidden() -> bool:
	return _result_card.visible and _message_label.text != "" and _message_label.modulate.a <= 0.01

func get_result_label_inset_in_card() -> bool:
	if not _result_card.visible or not _death_label.visible:
		return false
	var viewport_size := get_viewport().get_visible_rect().size
	return (
		_death_label.size.x <= _result_card.size.x - 72.0
		and _death_label.size.y <= _result_card.size.y - 72.0
		and _death_label.size.x < viewport_size.x * 0.62
		and _death_label.size.y < viewport_size.y * 0.82
	)

func get_result_geometry_debug() -> String:
	var viewport_size := get_viewport().get_visible_rect().size
	return "card_pos=%s card_size=%s label_pos=%s label_size=%s viewport=%s" % [
		_result_card.position,
		_result_card.size,
		_death_label.position,
		_death_label.size,
		viewport_size,
	]

func get_result_card_side_popout() -> bool:
	if not _result_card.visible:
		return false
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size.x < 760.0:
		return true
	return _result_card.position.x + _result_card.size.x * 0.5 > viewport_size.x * 0.56

func get_duelist_intro_visual_version() -> String:
	return _duelist_card.get_visual_version()

func get_duelist_intro_visible() -> bool:
	return _duelist_overlay.visible

func get_information_card_text() -> String:
	var lines: Array[String] = []
	for card in INFORMATION_CARDS:
		lines.append("%s %s %s %s" % [
			str(card.get("title", "")),
			str(card.get("category", "")),
			str(card.get("body", "")),
			str(card.get("footer", "")),
		])
	return "\n".join(lines)

func get_info_card_visual_version() -> String:
	return INFO_CARD_VISUAL_VERSION

func get_visible_info_card_count() -> int:
	var count := 0
	for child in _cards_grid.get_children():
		if child is InfoCard:
			count += 1
	return count

func get_info_card_detail_marker_count() -> int:
	var count := 0
	for child in _cards_grid.get_children():
		if child is InfoCard and child.has_method("get_detail_marker_count"):
			count += int(child.get_detail_marker_count())
	return count

func get_quest_card_visual_version() -> String:
	return QUEST_CARD_VISUAL_VERSION

func get_quest_card_count() -> int:
	return _quest_cards.size()

func get_upgrade_card_count() -> int:
	return _upgrade_data.size()

func get_upgrade_token_count() -> int:
	return _upgrade_tokens

func get_owned_upgrade_count() -> int:
	var count := 0
	for upgrade in _upgrade_data:
		if bool(upgrade.get("owned", false)):
			count += 1
	return count

func get_main_menu_button_style_count() -> int:
	var styled_count := 0
	for button in _menu_buttons:
		if button != null and is_instance_valid(button) and button.has_theme_stylebox_override("normal") and button.has_theme_stylebox_override("hover") and button.has_theme_stylebox_override("pressed"):
			styled_count += 1
	return styled_count

func get_main_menu_nav_button_visual_version() -> String:
	if _menu_buttons.is_empty():
		return ""
	var button := _menu_buttons[0]
	if button != null and is_instance_valid(button) and button.has_method("get_visual_version"):
		return str(button.get_visual_version())
	return ""

func get_main_menu_nav_redraw_gate_version() -> String:
	if _menu_buttons.is_empty():
		return ""
	var button := _menu_buttons[0]
	if button != null and is_instance_valid(button) and button.has_method("get_redraw_gate_version"):
		return str(button.get_redraw_gate_version())
	return ""

func get_main_menu_nav_tactile_marker_count() -> int:
	var marker_count := 0
	for button in _menu_buttons:
		if button != null and is_instance_valid(button) and button.has_method("get_tactile_marker_count"):
			marker_count += int(button.get_tactile_marker_count())
	return marker_count

func get_main_menu_selected_nav_count() -> int:
	var selected_count := 0
	for button in _menu_buttons:
		if button is MenuNavButton and bool(button.selected):
			selected_count += 1
	return selected_count

func get_main_menu_backdrop_class_name() -> String:
	return "MenuBackdrop" if _menu_backdrop != null and is_instance_valid(_menu_backdrop) and _menu_backdrop is MenuBackdrop else ""

func get_main_menu_backdrop_visual_version() -> String:
	if _menu_backdrop != null and is_instance_valid(_menu_backdrop) and _menu_backdrop.has_method("get_visual_version"):
		return str(_menu_backdrop.get_visual_version())
	return ""

func get_main_menu_memory_mode_version() -> String:
	return MAIN_MENU_MEMORY_MODE_VERSION

func get_main_menu_memory_log_version() -> String:
	return MAIN_MENU_MEMORY_LOG_VERSION

func get_main_menu_loaded() -> bool:
	return _menu_loaded and _menu_root != null and is_instance_valid(_menu_root) and _menu_root.is_inside_tree()

func get_main_menu_town_square_cue_count() -> int:
	if _menu_backdrop != null and is_instance_valid(_menu_backdrop) and _menu_backdrop.has_method("get_town_square_cue_count"):
		return int(_menu_backdrop.get_town_square_cue_count())
	return 0

func get_main_menu_title_plaque_marker_count() -> int:
	if _menu_backdrop != null and is_instance_valid(_menu_backdrop) and _menu_backdrop.has_method("get_title_plaque_marker_count"):
		return int(_menu_backdrop.get_title_plaque_marker_count())
	return 0

func get_main_menu_responsive_layout_version() -> String:
	return MENU_RESPONSIVE_LAYOUT_VERSION

func get_main_menu_responsive_widths_valid() -> bool:
	return _last_menu_content_width > 0.0 and _last_menu_nav_width > 0.0 and _last_menu_right_width > 0.0 and _last_menu_nav_width + _last_menu_right_width <= _last_menu_content_width - 16.0

func get_main_menu_loadout_column_count() -> int:
	return _last_menu_column_count

func get_loadout_icon_count() -> int:
	var count := 0
	for icon in _gun_icons.values():
		if icon is LoadoutIcon:
			count += 1
	for icon in _ability_icons.values():
		if icon is LoadoutIcon:
			count += 1
	return count

func get_loadout_icon_visual_version() -> String:
	for icon in _gun_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_visual_version"):
			return str(icon.get_visual_version())
	for icon in _ability_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_visual_version"):
			return str(icon.get_visual_version())
	return ""

func get_loadout_icon_tactile_marker_count() -> int:
	var marker_count := 0
	for icon in _gun_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_tactile_marker_count"):
			marker_count += int(icon.get_tactile_marker_count())
	for icon in _ability_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_tactile_marker_count"):
			marker_count += int(icon.get_tactile_marker_count())
	return marker_count

func get_loadout_card_visual_version() -> String:
	return LOADOUT_CARD_VISUAL_VERSION

func get_loadout_card_button_visual_count() -> int:
	var visual_count := 0
	for gun_id in _gun_ids:
		if _gun_buttons.has(gun_id):
			var button: Button = _gun_buttons[gun_id]
			if button != null and is_instance_valid(button) and button.has_method("get_visual_version") and str(button.get_visual_version()) == LOADOUT_CARD_VISUAL_VERSION:
				visual_count += 1
	for ability_id in _ability_ids:
		if _ability_buttons.has(ability_id):
			var button: Button = _ability_buttons[ability_id]
			if button != null and is_instance_valid(button) and button.has_method("get_visual_version") and str(button.get_visual_version()) == LOADOUT_CARD_VISUAL_VERSION:
				visual_count += 1
	return visual_count

func get_loadout_card_button_tactile_marker_count() -> int:
	var marker_count := 0
	for gun_id in _gun_ids:
		if _gun_buttons.has(gun_id):
			var button: Button = _gun_buttons[gun_id]
			if button != null and is_instance_valid(button) and button.has_method("get_tactile_marker_count"):
				marker_count += int(button.get_tactile_marker_count())
	for ability_id in _ability_ids:
		if _ability_buttons.has(ability_id):
			var button: Button = _ability_buttons[ability_id]
			if button != null and is_instance_valid(button) and button.has_method("get_tactile_marker_count"):
				marker_count += int(button.get_tactile_marker_count())
	return marker_count

func get_loadout_card_button_redraw_gate_version() -> String:
	for gun_id in _gun_ids:
		if _gun_buttons.has(gun_id):
			var button: Button = _gun_buttons[gun_id]
			if button != null and is_instance_valid(button) and button.has_method("get_redraw_gate_version"):
				return str(button.get_redraw_gate_version())
	for ability_id in _ability_ids:
		if _ability_buttons.has(ability_id):
			var button: Button = _ability_buttons[ability_id]
			if button != null and is_instance_valid(button) and button.has_method("get_redraw_gate_version"):
				return str(button.get_redraw_gate_version())
	return ""

func get_loadout_icon_redraw_gate_version() -> String:
	for icon in _gun_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_redraw_gate_version"):
			return str(icon.get_redraw_gate_version())
	for icon in _ability_icons.values():
		if icon is LoadoutIcon and icon.has_method("get_redraw_gate_version"):
			return str(icon.get_redraw_gate_version())
	return ""

func get_loadout_card_style_count() -> int:
	var styled_count := 0
	for gun_id in _gun_ids:
		if _gun_buttons.has(gun_id):
			var button: Button = _gun_buttons[gun_id]
			if _button_has_complete_card_style(button):
				styled_count += 1
	for ability_id in _ability_ids:
		if _ability_buttons.has(ability_id):
			var button: Button = _ability_buttons[ability_id]
			if _button_has_complete_card_style(button):
				styled_count += 1
	return styled_count

func get_loadout_card_tactile_style_count() -> int:
	var tactile_count := 0
	for gun_id in _gun_ids:
		if _gun_buttons.has(gun_id):
			var button: Button = _gun_buttons[gun_id]
			if _button_has_tactile_card_style(button):
				tactile_count += 1
	for ability_id in _ability_ids:
		if _ability_buttons.has(ability_id):
			var button: Button = _ability_buttons[ability_id]
			if _button_has_tactile_card_style(button):
				tactile_count += 1
	return tactile_count

func get_skill_icon_visual_version() -> String:
	for icon in _skill_icons:
		if icon != null and is_instance_valid(icon) and icon.has_method("get_visual_version"):
			return str(icon.get_visual_version())
	return ""

func get_skill_icon_redraw_budget_version() -> String:
	for icon in _skill_icons:
		if icon != null and is_instance_valid(icon) and icon.has_method("get_redraw_budget_version"):
			return str(icon.get_redraw_budget_version())
	return ""

func get_skill_icon_cooldown_redraw_step() -> float:
	for icon in _skill_icons:
		if icon != null and is_instance_valid(icon) and icon.has_method("get_cooldown_redraw_step"):
			return float(icon.get_cooldown_redraw_step())
	return 0.0

func get_skill_icon_cooldown_redraw_bucket_count() -> int:
	for icon in _skill_icons:
		if icon != null and is_instance_valid(icon) and icon.has_method("get_cooldown_redraw_bucket_count"):
			return int(icon.get_cooldown_redraw_bucket_count())
	return 0

func get_skill_icon_tactile_marker_count() -> int:
	var marker_count := 0
	for icon in _skill_icons:
		if icon != null and is_instance_valid(icon) and icon.has_method("get_tactile_marker_count"):
			marker_count += int(icon.get_tactile_marker_count())
	return marker_count

func get_skill_icon_count() -> int:
	return _skill_icons.size()

func get_live_hud_frame_visible() -> bool:
	return _hud_ledger_frame.visible

func get_live_hud_frame_class_name() -> String:
	return "HudLedgerFrame" if _hud_ledger_frame != null and is_instance_valid(_hud_ledger_frame) and _hud_ledger_frame is HudLedgerFrame else ""

func get_live_hud_ledger_visual_version() -> String:
	if _hud_ledger_frame != null and is_instance_valid(_hud_ledger_frame) and _hud_ledger_frame.has_method("get_visual_version"):
		return str(_hud_ledger_frame.get_visual_version())
	return ""

func get_live_hud_label_update_gate_version() -> String:
	return LIVE_HUD_LABEL_UPDATE_GATE_VERSION

func get_live_hud_label_gate_count() -> int:
	return 6

func get_live_hud_label_change_count() -> int:
	return _live_hud_label_change_count

func get_live_hud_ledger_contrast_marker_count() -> int:
	if _hud_ledger_frame != null and is_instance_valid(_hud_ledger_frame) and _hud_ledger_frame.has_method("get_contrast_marker_count"):
		return int(_hud_ledger_frame.get_contrast_marker_count())
	return 0

func _button_has_complete_card_style(button: Button) -> bool:
	return button != null and is_instance_valid(button) and button.has_theme_stylebox_override("normal") and button.has_theme_stylebox_override("hover") and button.has_theme_stylebox_override("pressed") and button.has_theme_stylebox_override("disabled")

func _button_has_tactile_card_style(button: Button) -> bool:
	return _button_has_complete_card_style(button) and button.has_theme_stylebox_override("focus") and button.has_theme_color_override("font_pressed_color") and button.has_theme_color_override("font_shadow_color")

func clear_result_overlay_for_staged_run() -> void:
	_clear_result_overlay()

func hide_transient_overlays() -> void:
	if _duelist_intro_tween != null and is_instance_valid(_duelist_intro_tween):
		_duelist_intro_tween.kill()
	_duelist_intro_tween = null
	_duelist_overlay.visible = false
	_duelist_overlay.modulate.a = 1.0
	if _danger_warning_tween != null and is_instance_valid(_danger_warning_tween):
		_danger_warning_tween.kill()
	_danger_warning_tween = null
	_danger_flash.color.a = 0.0
	_danger_label.text = ""
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.26, 0.0))
	_payday_feedback_timer = 0.0
	_wave_clear_feedback_timer = 0.0
	_clear_unlock_toast(true)

func _create_rookie_primer() -> void:
	_rookie_panel.visible = false
	_rookie_panel.custom_minimum_size = Vector2(310.0, 172.0)
	_rookie_panel.add_theme_stylebox_override("panel", _make_card_style(Color(0.9, 0.56, 0.22)))
	_rookie_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_rookie_panel.offset_left = -342.0
	_rookie_panel.offset_top = 28.0
	_rookie_panel.offset_right = -28.0
	_rookie_panel.offset_bottom = 206.0
	_rookie_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_rookie_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rookie_panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 7)
	stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(stack)

	_rookie_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_rookie_title.add_theme_font_size_override("font_size", 24)
	_rookie_title.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_rookie_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_rookie_title)

	var rule := ColorRect.new()
	rule.color = Color(0.72, 0.32, 0.1, 0.92)
	rule.custom_minimum_size = Vector2(282.0, 6.0)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(rule)

	_rookie_body.add_theme_font_size_override("font_size", 17)
	_rookie_body.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	_rookie_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_rookie_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_rookie_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(_rookie_body)

func _update_ammo_label(ammo_summary: Dictionary) -> void:
	if ammo_summary.is_empty():
		_set_live_hud_label_text(_ammo_label, "")
		return
	var state := _get_ammo_label_state(ammo_summary)
	_ammo_label.add_theme_color_override("font_color", state["color"])
	_set_live_hud_label_text(_ammo_label, str(state["text"]))

func _get_ammo_label_state(ammo_summary: Dictionary) -> Dictionary:
	var ammo := int(ammo_summary.get("ammo", 0))
	var capacity := int(ammo_summary.get("capacity", 0))
	var reloading := bool(ammo_summary.get("reloading", false))
	var low_rounds := ammo <= maxi(1, int(ceil(float(capacity) * 0.34)))
	var bullets := ""
	for i in range(capacity):
		bullets += "|" if i < ammo else "."
	var state := {
		"text": "CYLINDER READY [%s]  %d/%d" % [bullets, ammo, capacity],
		"color": Color(0.95, 0.82, 0.52),
	}
	if low_rounds and not reloading:
		state["text"] = "CYLINDER LOW [%s]  %d/%d" % [bullets, ammo, capacity]
		state["color"] = Color(1.0, 0.58, 0.18)
	if reloading:
		var reload := float(ammo_summary.get("reload", 0.0))
		var reload_duration := maxf(0.01, float(ammo_summary.get("reload_duration", 1.0)))
		var reload_percent := int((1.0 - reload / reload_duration) * 100.0)
		state["text"] = "CYLINDER RELOAD %02d%% [%s] AUTO" % [reload_percent, bullets]
		state["color"] = Color(1.0, 0.36, 0.14)
	return state

func get_ammo_text() -> String:
	return _ammo_label.text

func get_ammo_preview_text(ammo_summary: Dictionary) -> String:
	if ammo_summary.is_empty():
		return ""
	return str(_get_ammo_label_state(ammo_summary).get("text", ""))

func show_run_start(seed_value: int) -> void:
	_elapsed = 0.0
	_clear_result_overlay()
	_layout_message_label_default()
	var intro_text := "DUST HEIST\nSEED %d" % seed_value
	_message_label.text = intro_text
	_message_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_interval(1.15)
	tween.tween_method(func(alpha: float) -> void:
		if _message_label.text == intro_text:
			_message_label.modulate.a = alpha
	, 1.0, 0.0, 0.35)
	tween.tween_callback(func() -> void:
		if _message_label.text == intro_text:
			_message_label.text = ""
			_message_label.modulate.a = 1.0
	)

func show_rookie_primer() -> void:
	_rookie_panel.visible = true
	_rookie_panel.modulate.a = 1.0
	_rookie_title.text = "FIRST DRAW"
	_rookie_body.text = "MOVE  WASD / ARROWS\nDASH  SPACE\nSLASH  J / MOUSE\nCAST  1-4\nWATCH CYLINDER FOR RELOADS"
	var tween := create_tween()
	tween.tween_interval(4.2)
	tween.tween_property(_rookie_panel, "modulate:a", 0.0, 0.45)
	tween.tween_callback(func() -> void:
		_rookie_panel.visible = false
		_rookie_panel.modulate.a = 1.0
	)

func show_run_complete(credits: int, grade_text: String = "") -> void:
	hide_transient_overlays()
	_layout_message_label_default()
	_set_gameplay_hud_visible(false)
	if _wave_banner_tween != null and is_instance_valid(_wave_banner_tween):
		_wave_banner_tween.kill()
	_wave_banner_tween = null
	_wave_banner.text = ""
	_death_screen.color = Color(0.05, 0.025, 0.01, 0.24)
	_death_screen.z_index = 100
	_death_label.z_index = 101
	_layout_result_popout()
	_death_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_death_label.add_theme_font_size_override("font_size", 18)
	_death_label.add_theme_color_override("font_color", Color(0.98, 0.84, 0.54, 1.0))
	_death_label.text = "EXTRACTED"
	_message_label.modulate.a = 0.0
	_message_label.add_theme_font_size_override("font_size", 26)
	_message_label.text = "EXTRACTED"
	if grade_text != "":
		_death_label.text += "\n%s" % grade_text
		_message_label.text += "\n%s" % grade_text
	else:
		_death_label.text += "\nBANKED +%d CREDITS" % credits
		_message_label.text += "\nBANKED +%d CREDITS" % credits
	_death_label.text += "\nPRESS ANY KEY"
	_message_label.text += "\nPRESS ANY KEY"
	_death_screen.move_to_front()
	_result_card.move_to_front()
	_result_card_glow.move_to_front()
	_result_divider_top.move_to_front()
	_result_divider_mid.move_to_front()
	_result_divider_bottom.move_to_front()
	_death_label.move_to_front()

func _layout_result_popout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	_death_label.visible = true
	_death_label.modulate.a = 1.0
	_death_label.anchor_left = 0.0
	_death_label.anchor_top = 0.0
	_death_label.anchor_right = 0.0
	_death_label.anchor_bottom = 0.0
	_death_label.offset_left = 0.0
	_death_label.offset_top = 0.0
	_death_label.offset_right = 0.0
	_death_label.offset_bottom = 0.0
	var card_width: float = minf(590.0, maxf(360.0, viewport_size.x * 0.44))
	var card_height: float = minf(650.0, maxf(360.0, viewport_size.y - 96.0))
	if viewport_size.x < 760.0:
		card_width = minf(viewport_size.x - 42.0, card_width)
		card_height = minf(viewport_size.y - 72.0, card_height)
	var card_position := Vector2(viewport_size.x - card_width - 54.0, (viewport_size.y - card_height) * 0.5)
	if viewport_size.x < 760.0:
		card_position = (viewport_size - Vector2(card_width, card_height)) * 0.5
	_result_card.visible = true
	_result_card.z_index = 100
	_result_card.position = card_position
	_result_card.size = Vector2(card_width, card_height)
	var label_padding := Vector2(52.0, 50.0)
	_death_label.position = card_position + label_padding
	_death_label.size = Vector2(card_width, card_height) - label_padding * 2.0
	_death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_layout_result_flare(_result_card.position, _result_card.size)

func _layout_result_flare(card_position: Vector2, card_size: Vector2) -> void:
	_result_card_glow.visible = true
	_result_card_glow.z_index = 99
	_result_card_glow.position = card_position + Vector2(10.0, 10.0)
	_result_card_glow.size = card_size - Vector2(20.0, 20.0)
	_result_card_glow.color = Color(1.0, 0.58, 0.16, 0.034)
	_result_divider_top.visible = true
	_result_divider_top.z_index = 101
	_result_divider_top.position = card_position + Vector2(52.0, 62.0)
	_result_divider_top.size = Vector2(maxf(80.0, card_size.x - 104.0), 5.0)
	_result_divider_top.color = Color(1.0, 0.68, 0.22, 0.88)
	_result_divider_mid.visible = true
	_result_divider_mid.z_index = 101
	_result_divider_mid.position = card_position + Vector2(76.0, card_size.y * 0.56)
	_result_divider_mid.size = Vector2(maxf(80.0, card_size.x - 152.0), 3.0)
	_result_divider_mid.color = Color(0.92, 0.54, 0.16, 0.56)
	_result_divider_bottom.visible = true
	_result_divider_bottom.z_index = 101
	_result_divider_bottom.position = card_position + Vector2(52.0, card_size.y - 68.0)
	_result_divider_bottom.size = _result_divider_top.size
	_result_divider_bottom.color = Color(0.78, 0.42, 0.14, 0.78)
	var tween := create_tween()
	tween.set_loops(3)
	tween.tween_property(_result_card_glow, "color:a", 0.052, 0.32)
	tween.tween_property(_result_card_glow, "color:a", 0.034, 0.42)

func _set_result_flare_visible(visible_state: bool) -> void:
	_result_card.visible = visible_state
	_result_card_glow.visible = visible_state
	_result_divider_top.visible = visible_state
	_result_divider_mid.visible = visible_state
	_result_divider_bottom.visible = visible_state

func _clear_result_overlay() -> void:
	if _death_tween != null and is_instance_valid(_death_tween):
		_death_tween.kill()
	_death_tween = null
	_clear_unlock_toast(true)
	_death_screen.color.a = 0.0
	_set_result_flare_visible(false)
	_death_label.visible = false
	_death_label.modulate.a = 1.0
	_death_label.text = ""
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	_message_label.text = ""
	_message_label.modulate.a = 1.0
	_layout_message_label_default()

func _layout_message_label_default() -> void:
	_message_label.z_index = 0
	_message_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_message_label.offset_left = 0.0
	_message_label.offset_top = 22.0
	_message_label.offset_right = 0.0
	_message_label.offset_bottom = 318.0
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_message_label.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))

func _reset_menu_node_references() -> void:
	_menu_root = Control.new()
	_menu_backdrop = MenuBackdrop.new()
	_menu_title = Label.new()
	_menu_panel = VBoxContainer.new()
	_menu_content = HBoxContainer.new()
	_cards_scroll = ScrollContainer.new()
	_cards_grid = GridContainer.new()
	_guns_panel = VBoxContainer.new()
	_guns_grid = GridContainer.new()
	_abilities_panel = VBoxContainer.new()
	_abilities_grid = GridContainer.new()
	_quests_panel = VBoxContainer.new()
	_upgrades_panel = VBoxContainer.new()
	_upgrades_scroll = ScrollContainer.new()
	_upgrades_grid = GridContainer.new()
	_gun_buttons.clear()
	_ability_buttons.clear()
	_upgrade_buttons.clear()
	_gun_icons.clear()
	_ability_icons.clear()
	_quest_labels.clear()
	_quest_cards.clear()
	_menu_buttons.clear()
	_active_menu_button_id = ""

func _clear_menu_node_references() -> void:
	_menu_root = null
	_menu_backdrop = null
	_menu_title = null
	_menu_panel = null
	_menu_content = null
	_cards_scroll = null
	_cards_grid = null
	_guns_panel = null
	_guns_grid = null
	_abilities_panel = null
	_abilities_grid = null
	_quests_panel = null
	_upgrades_panel = null
	_upgrades_scroll = null
	_upgrades_grid = null
	_gun_buttons.clear()
	_ability_buttons.clear()
	_upgrade_buttons.clear()
	_gun_icons.clear()
	_ability_icons.clear()
	_quest_labels.clear()
	_quest_cards.clear()
	_menu_buttons.clear()
	_active_menu_button_id = ""

func set_main_menu_memory_log_enabled(enabled: bool) -> void:
	_menu_memory_log_enabled = enabled

func _count_node_tree(node: Node) -> int:
	if node == null or not is_instance_valid(node):
		return 0
	var count := 1
	for child in node.get_children():
		count += _count_node_tree(child)
	return count

func _get_menu_node_count() -> int:
	if not get_main_menu_loaded():
		return 0
	return _count_node_tree(_menu_root)

func _bytes_to_mb(value: float) -> float:
	return value / 1048576.0

func _format_main_menu_memory_snapshot(label: String) -> String:
	var static_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.MEMORY_STATIC)))
	var static_max_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)))
	var texture_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)))
	var buffer_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_BUFFER_MEM_USED)))
	var video_mb := _bytes_to_mb(float(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)))
	var object_count := int(Performance.get_monitor(Performance.OBJECT_COUNT))
	var resource_count := int(Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT))
	var node_count := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var orphan_node_count := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	return (
		"label=%s version=%s menu_loaded=%s menu_visible=%s menu_nodes=%d nav_buttons=%d gun_buttons=%d ability_buttons=%d quest_cards=%d "
		+ "objects=%d resources=%d nodes=%d orphan_nodes=%d static_mb=%.1f static_max_mb=%.1f texture_mb=%.1f buffer_mb=%.1f video_mb=%.1f"
	) % [
		label,
		MAIN_MENU_MEMORY_LOG_VERSION,
		str(get_main_menu_loaded()),
		str(_menu_root != null and is_instance_valid(_menu_root) and _menu_root.visible),
		_get_menu_node_count(),
		_menu_buttons.size(),
		_gun_buttons.size(),
		_ability_buttons.size(),
		_quest_cards.size(),
		object_count,
		resource_count,
		node_count,
		orphan_node_count,
		static_mb,
		static_max_mb,
		texture_mb,
		buffer_mb,
		video_mb,
	]

func _print_main_menu_memory_snapshot(label: String) -> void:
	if not _menu_memory_log_enabled:
		return
	print("DUST_MEMORY_LOG: %s" % _format_main_menu_memory_snapshot(label))

func _ensure_menu_loaded() -> void:
	if get_main_menu_loaded():
		return
	if _menu_root != null and is_instance_valid(_menu_root):
		_menu_root.queue_free()
	_reset_menu_node_references()
	_create_menu()

func _release_main_menu() -> void:
	if not _menu_loaded:
		return
	if _menu_root != null and is_instance_valid(_menu_root) and _menu_root.visible:
		return
	_print_main_menu_memory_snapshot("menu_release_before")
	if _menu_root != null and is_instance_valid(_menu_root):
		if _menu_root.get_parent() == _root:
			_root.remove_child(_menu_root)
		_menu_root.free()
	_clear_menu_node_references()
	_menu_loaded = false
	_print_main_menu_memory_snapshot("menu_release_after")

func _layout_unlock_toast() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var toast_width: float = minf(620.0, maxf(320.0, viewport_size.x - 80.0))
	var toast_height := 118.0
	if viewport_size.y < 520.0:
		toast_height = 104.0
	_unlock_toast_frame.position = Vector2((viewport_size.x - toast_width) * 0.5, 28.0)
	_unlock_toast_frame.size = Vector2(toast_width, toast_height)
	_unlock_toast_frame.z_index = 88
	_message_label.z_index = 89
	_message_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_message_label.offset_left = 32.0
	_message_label.offset_top = _unlock_toast_frame.position.y + 28.0
	_message_label.offset_right = -32.0
	_message_label.offset_bottom = _unlock_toast_frame.position.y + toast_height - 18.0
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _clear_unlock_toast(clear_text: bool = false) -> void:
	if _unlock_tween != null and is_instance_valid(_unlock_tween):
		_unlock_tween.kill()
	_unlock_tween = null
	_unlock_toast_frame.visible = false
	_unlock_toast_frame.modulate.a = 1.0
	if clear_text:
		_message_label.text = ""
		_message_label.modulate.a = 1.0
	_layout_message_label_default()

func show_unlock(text: String) -> void:
	_clear_unlock_toast(false)
	_layout_unlock_toast()
	_unlock_toast_frame.visible = true
	_unlock_toast_frame.modulate.a = 1.0
	_unlock_toast_frame.queue_redraw()
	_unlock_toast_frame.move_to_front()
	_message_label.move_to_front()
	_message_label.modulate.a = 1.0
	_message_label.add_theme_font_size_override("font_size", 30)
	_message_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.46, 1.0))
	_message_label.text = text
	var tween := create_tween()
	_unlock_tween = tween
	tween.tween_interval(1.25)
	tween.tween_property(_message_label, "modulate:a", 0.0, 0.35)
	tween.parallel().tween_property(_unlock_toast_frame, "modulate:a", 0.0, 0.35)
	tween.tween_callback(func() -> void:
		_clear_unlock_toast(true)
	)

func show_run_failed(grade_text: String = "") -> void:
	_clear_unlock_toast(true)
	_layout_message_label_default()
	_message_label.text = ""
	_death_screen.color = Color(0.05, 0.025, 0.01, 0.24)
	_death_screen.z_index = 100
	_death_label.z_index = 101
	_layout_result_popout()
	_death_label.text = "YOU DIED" if grade_text == "" else "YOU DIED\n%s" % grade_text
	_death_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_death_label.add_theme_font_size_override("font_size", 34 if grade_text == "" else 18)
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	if _death_tween != null and is_instance_valid(_death_tween):
		_death_tween.kill()
	var tween := create_tween()
	_death_tween = tween
	tween.tween_method(
		func(alpha: float) -> void:
			_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, alpha)),
		0.0,
		1.0,
		0.85
	)
	tween.tween_callback(func() -> void:
		_death_tween = null
	)
	_death_screen.move_to_front()
	_result_card.move_to_front()
	_result_card_glow.move_to_front()
	_result_divider_top.move_to_front()
	_result_divider_mid.move_to_front()
	_result_divider_bottom.move_to_front()
	_death_label.move_to_front()

func show_main_menu() -> void:
	_ensure_menu_loaded()
	_clear_result_overlay()
	_menu_root.visible = true
	_menu_root.move_to_front()
	_set_gameplay_hud_visible(false)
	_rookie_panel.visible = false
	_objective_panel.visible = false
	_training_panel.visible = false
	_layout_menu()
	_show_overview_cards()
	_set_active_menu_button("")
	_print_main_menu_memory_snapshot("menu_show_loaded")

func show_information_menu_for_qa() -> void:
	show_main_menu()
	_show_information_cards()
	_cards_scroll.scroll_vertical = 0

func scroll_information_menu_to_late_cards_for_qa() -> void:
	var scrollbar := _cards_scroll.get_v_scroll_bar()
	if scrollbar != null:
		scrollbar.value = scrollbar.max_value
	_cards_scroll.scroll_vertical = 100000

func set_ability_loadout_data(unlocked_ids: Array[String], equipped_ids: Array[String]) -> void:
	_unlocked_abilities = unlocked_ids.duplicate()
	_equipped_abilities = equipped_ids.duplicate()
	_refresh_ability_buttons()

func set_gun_loadout_data(unlocked_ids: Array[String], equipped_id: String) -> void:
	_unlocked_guns = unlocked_ids.duplicate()
	_equipped_gun = equipped_id
	_refresh_gun_buttons()

func set_quest_data(quests: Array[Dictionary]) -> void:
	_quest_data = quests.duplicate(true)
	_refresh_quest_panel()

func hide_main_menu() -> void:
	if get_main_menu_loaded():
		_print_main_menu_memory_snapshot("menu_hide_before")
		_menu_root.visible = false
		_print_main_menu_memory_snapshot("menu_hide_hidden")
	_set_gameplay_hud_visible(true)
	call_deferred("_release_main_menu")

func show_wave_banner(wave: int, level_title: String = "", max_wave: int = 0) -> void:
	if _wave_banner_tween != null and is_instance_valid(_wave_banner_tween):
		_wave_banner_tween.kill()
	var wave_text := "WAVE %d/%d" % [wave, max_wave] if max_wave > 0 else "WAVE %d" % wave
	_wave_banner.text = wave_text if level_title == "" else "%s\n%s" % [wave_text, level_title.to_upper()]
	_wave_banner.modulate.a = 0.0
	var viewport_size := get_viewport().get_visible_rect().size
	var banner_width: float = minf(760.0, maxf(360.0, viewport_size.x - 128.0))
	_wave_banner.size = Vector2(banner_width, 126.0)
	var title_length := level_title.length()
	var font_size := 48
	if title_length >= 18:
		font_size = 40
	elif title_length >= 14:
		font_size = 44
	_wave_banner.add_theme_font_size_override("font_size", font_size)
	var center_x := (viewport_size.x - _wave_banner.size.x) * 0.5
	var center_y := maxf(174.0, viewport_size.y * 0.28)
	_wave_banner.position = Vector2(center_x, center_y + 8.0)
	var tween := create_tween()
	_wave_banner_tween = tween
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(_wave_banner, "modulate:a", 0.72, 0.24)
	tween.parallel().tween_property(_wave_banner, "position:y", center_y, 0.24)
	tween.tween_interval(1.0)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(_wave_banner, "modulate:a", 0.0, 0.36)
	tween.tween_callback(func() -> void:
		_wave_banner_tween = null
	)

func flash_hit() -> void:
	_hit_flash.color = Color(0.85, 0.0, 0.0, 0.22)
	var tween := create_tween()
	tween.tween_property(_hit_flash, "color:a", 0.0, 0.12)

func show_hunter_lunge_warning() -> void:
	_hunter_lunge_warning_count += 1
	if _danger_warning_tween != null and is_instance_valid(_danger_warning_tween):
		_danger_warning_tween.kill()
	_danger_flash.color = Color(1.0, 0.38, 0.03, 0.11)
	_danger_label.text = "HUNTER LUNGE"
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.26, 0.92))
	var tween := create_tween()
	_danger_warning_tween = tween
	tween.tween_interval(0.16)
	tween.parallel().tween_property(_danger_flash, "color:a", 0.0, 0.18)
	tween.parallel().tween_method(
		func(alpha: float) -> void:
			_danger_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.26, alpha)),
		0.92,
		0.0,
		0.18
	)
	tween.tween_callback(func() -> void:
		_danger_label.text = ""
		_danger_warning_tween = null
	)

func show_black_sash_lunge_warning() -> void:
	_black_sash_lunge_warning_count += 1
	if _danger_warning_tween != null and is_instance_valid(_danger_warning_tween):
		_danger_warning_tween.kill()
	_danger_flash.color = Color(0.72, 0.04, 0.018, 0.14)
	_danger_label.text = "BLACK SASH DRAW"
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.46, 0.26, 0.94))
	var tween := create_tween()
	_danger_warning_tween = tween
	tween.tween_interval(0.18)
	tween.parallel().tween_property(_danger_flash, "color:a", 0.0, 0.22)
	tween.parallel().tween_method(
		func(alpha: float) -> void:
			_danger_label.add_theme_color_override("font_color", Color(1.0, 0.46, 0.26, alpha)),
		0.94,
		0.0,
		0.22
	)
	tween.tween_callback(func() -> void:
		_danger_label.text = ""
		_danger_warning_tween = null
	)

func show_mercy_vale_lunge_warning() -> void:
	_mercy_vale_lunge_warning_count += 1
	if _danger_warning_tween != null and is_instance_valid(_danger_warning_tween):
		_danger_warning_tween.kill()
	_danger_flash.color = Color(1.0, 0.58, 0.12, 0.12)
	_danger_label.text = "MERCY FAST-DRAW"
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.32, 0.94))
	var tween := create_tween()
	_danger_warning_tween = tween
	tween.tween_interval(0.12)
	tween.parallel().tween_property(_danger_flash, "color:a", 0.0, 0.18)
	tween.parallel().tween_method(
		func(alpha: float) -> void:
			_danger_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.32, alpha)),
		0.94,
		0.0,
		0.18
	)
	tween.tween_callback(func() -> void:
		_danger_label.text = ""
		_danger_warning_tween = null
	)

func show_june_blackglass_lunge_warning() -> void:
	_june_blackglass_lunge_warning_count += 1
	if _danger_warning_tween != null and is_instance_valid(_danger_warning_tween):
		_danger_warning_tween.kill()
	_danger_flash.color = Color(0.86, 0.02, 0.055, 0.16)
	_danger_label.text = "BLACKGLASS SNAP"
	_danger_label.add_theme_color_override("font_color", Color(1.0, 0.36, 0.28, 0.95))
	var tween := create_tween()
	_danger_warning_tween = tween
	tween.tween_interval(0.14)
	tween.parallel().tween_property(_danger_flash, "color:a", 0.0, 0.2)
	tween.parallel().tween_method(
		func(alpha: float) -> void:
			_danger_label.add_theme_color_override("font_color", Color(1.0, 0.36, 0.28, alpha)),
		0.95,
		0.0,
		0.2
	)
	tween.tween_callback(func() -> void:
		_danger_label.text = ""
		_danger_warning_tween = null
	)

func show_payday_collected_feedback(credits: int, rounds: int) -> void:
	_payday_feedback_count += 1
	_payday_feedback_timer = 1.25
	_payday_feedback_goal = "SATCHEL SECURED\n+%d CREDITS  +%d ROUNDS" % [credits, rounds]
	_payday_feedback_tip = "BANKED FOR EXTRACTION  KEEP MOVING"
	_objective_title.text = "PAYDAY BANKED"
	_objective_goal.text = _payday_feedback_goal
	_objective_tip.text = _payday_feedback_tip
	_objective_progress_fill.color = Color(0.34, 0.56, 0.18, 0.95)

func show_wave_clear_feedback(wave: int, level_title: String, next_wave: int, max_wave: int) -> void:
	_wave_clear_feedback_count += 1
	_payday_feedback_timer = 0.0
	_wave_clear_feedback_timer = 0.95
	if wave == max_wave - 1:
		_wave_clear_feedback_goal = "LEVEL %d CLEARED\nJUNE DOWN  LAST HIGH NOON NEXT" % wave
		_wave_clear_feedback_tip = "SAVE DASH FOR HUNTERS  CLEAR THEN EXTRACT"
	else:
		_wave_clear_feedback_goal = "LEVEL %d CLEARED\n%s" % [wave, level_title.to_upper()]
		_wave_clear_feedback_tip = "PAYDAY DROPPED  NEXT LEVEL %d/%d" % [next_wave, max_wave]
	_objective_title.text = "LEVEL CLEARED"
	_objective_goal.text = _wave_clear_feedback_goal
	_objective_tip.text = _wave_clear_feedback_tip
	_objective_progress_fill.color = Color(0.86, 0.58, 0.18, 0.95)

func show_style_pop(text: String, rank: String, combo_count: int) -> void:
	if _style_pop_tween != null and is_instance_valid(_style_pop_tween):
		_style_pop_tween.kill()
	var rank_up := text.find("RANK UP") >= 0
	_style_pop.text = "%s\nRANK %s" % [text, rank]
	if combo_count > 1:
		_style_pop.text += "  x%d" % combo_count
	_style_pop.add_theme_font_size_override("font_size", 28 if rank_up else 24)
	_style_pop_back.color = Color(0.055, 0.026, 0.014, 0.74 if rank_up else 0.58)
	_style_pop_rule.color = Color(1.0, 0.64, 0.18, 0.92 if rank_up else 0.74)
	_style_pop.add_theme_color_override("font_color", Color(1.0, 0.88 if rank_up else 0.82, 0.46 if rank_up else 0.38, 0.98))
	var tween := create_tween()
	_style_pop_tween = tween
	tween.tween_interval(0.58 if rank_up else 0.45)
	tween.parallel().tween_property(_style_pop_rule, "offset_left", -430.0, 0.12).from(-382.0)
	tween.tween_method(
		func(alpha: float) -> void:
			_style_pop.add_theme_color_override("font_color", Color(1.0, 0.88 if rank_up else 0.82, 0.46 if rank_up else 0.38, alpha))
			_style_pop_back.color.a = alpha * (0.74 if rank_up else 0.58)
			_style_pop_rule.color.a = alpha * (0.92 if rank_up else 0.74),
		0.98,
		0.0,
		0.42 if rank_up else 0.35
	)
	tween.tween_callback(
		func() -> void:
			_style_pop_tween = null
	)

func show_duelist_intro(name: String, accent: Color, title: String = "DUELIST", line: String = "") -> void:
	if _duelist_intro_tween != null and is_instance_valid(_duelist_intro_tween):
		_duelist_intro_tween.kill()
	_duelist_name.text = name
	_duelist_title.text = title
	_duelist_line.text = line
	_duelist_overlay.visible = true
	_duelist_overlay.modulate.a = 1.0
	var viewport_size := get_viewport().get_visible_rect().size
	_duelist_card.position = Vector2((viewport_size.x - _duelist_card.size.x) * 0.5, viewport_size.y + 40.0)
	_duelist_card.set_accent(accent)
	for i in range(_duelist_leaves.size()):
		var leaf := _duelist_leaves[i]
		leaf.position = Vector2(float((i * 137) % int(viewport_size.x + 180.0)) - 90.0, viewport_size.y * 0.18 + float(i) * 31.0)
		leaf.modulate.a = 1.0
	var center_y := (viewport_size.y - _duelist_card.size.y) * 0.5
	var tween := create_tween()
	_duelist_intro_tween = tween
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(_duelist_card, "position:y", center_y, 0.32)
	tween.tween_interval(1.05)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(_duelist_overlay, "modulate:a", 0.0, 0.28)
	tween.tween_callback(func() -> void:
		_duelist_overlay.visible = false
		_duelist_overlay.modulate.a = 1.0
		_duelist_intro_tween = null
	)
	for i in range(18):
		var leaf := _duelist_leaves[i]
		var drift := 90.0 + float((i * 19) % 80)
		tween.parallel().tween_property(leaf, "position:x", leaf.position.x + drift, 1.2)

func _configure_label(label: Label, position: Vector2, font_size: int) -> void:
	label.position = position
	label.size = Vector2(560, 24)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_shadow_color", Color(0.018, 0.008, 0.004, 0.92))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_outline_color", Color(0.04, 0.016, 0.008, 0.78))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(label)

func _create_menu() -> void:
	if get_main_menu_loaded():
		return
	_menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_menu_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_menu_root)

	_menu_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_menu_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.add_child(_menu_backdrop)

	_menu_title.text = "DUST HEIST"
	_menu_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_menu_title.add_theme_font_size_override("font_size", 56)
	_menu_title.add_theme_color_override("font_color", Color(0.95, 0.78, 0.45))
	_menu_title.add_theme_color_override("font_shadow_color", Color(0.04, 0.016, 0.006, 0.86))
	_menu_title.add_theme_constant_override("shadow_offset_x", 4)
	_menu_title.add_theme_constant_override("shadow_offset_y", 5)
	_menu_title.add_theme_constant_override("outline_size", 2)
	_menu_title.add_theme_color_override("font_outline_color", Color(0.16, 0.064, 0.026, 0.92))
	_menu_title.position = Vector2.ZERO
	_menu_title.size = Vector2(900.0, 86.0)
	_menu_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.add_child(_menu_title)

	_menu_content.position = Vector2.ZERO
	_menu_content.size = Vector2(720.0, 244.0)
	_menu_content.add_theme_constant_override("separation", 48)
	_menu_root.add_child(_menu_content)

	_menu_panel.custom_minimum_size = Vector2(220, 244)
	_menu_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_menu_panel)

	_add_menu_button("PLAY", func() -> void:
		hide_main_menu()
		play_requested.emit()
	)
	_add_menu_button("SWORDS", func() -> void:
		_show_sword_cards()
	)
	_add_menu_button("GUNS", func() -> void:
		_show_guns_screen()
	)
	_add_menu_button("ABILITIES", func() -> void:
		_show_abilities_screen()
	)
	_add_menu_button("UPGRADES", func() -> void:
		_show_upgrades_screen()
	)
	_add_menu_button("QUESTS", func() -> void:
		_show_quests_screen()
	)
	_add_menu_button("INFORMATION", func() -> void:
		_show_information_cards()
	)

	_cards_scroll.custom_minimum_size = Vector2(560, 360)
	_cards_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_cards_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_menu_content.add_child(_cards_scroll)

	_cards_grid.columns = 2
	_cards_grid.add_theme_constant_override("h_separation", 14)
	_cards_grid.add_theme_constant_override("v_separation", 14)
	_cards_scroll.add_child(_cards_grid)
	_create_guns_panel()
	_create_abilities_panel()
	_create_upgrades_panel()
	_create_quests_panel()
	_menu_loaded = true

func _add_menu_button(text: String, callback: Callable) -> void:
	var button := MenuNavButton.new()
	button.text = text
	button.custom_minimum_size = Vector2(220, 44)
	button.add_theme_font_size_override("font_size", 18)
	button.flat = false
	button.focus_mode = Control.FOCUS_NONE
	button.set_nav_state(text, false)
	_apply_main_menu_button_style(button)
	button.pressed.connect(func() -> void:
		_set_active_menu_button(text)
		callback.call()
	)
	_menu_buttons.append(button)
	_menu_panel.add_child(button)

func _set_active_menu_button(id: String) -> void:
	_active_menu_button_id = id
	for button in _menu_buttons:
		if button is MenuNavButton:
			button.set_nav_state(str(button.text), str(button.text) == _active_menu_button_id)

func _apply_main_menu_button_style(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _make_menu_button_style(Color(0.52, 0.28, 0.12), 0))
	button.add_theme_stylebox_override("hover", _make_menu_button_style(Color(0.86, 0.54, 0.2), 1))
	button.add_theme_stylebox_override("pressed", _make_menu_button_style(Color(0.36, 0.16, 0.065), 2))
	button.add_theme_stylebox_override("disabled", _make_menu_button_style(Color(0.24, 0.2, 0.16), 3))
	button.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.78, 0.36))
	button.add_theme_color_override("font_pressed_color", Color(0.98, 0.74, 0.42))
	button.add_theme_color_override("font_disabled_color", Color(0.38, 0.31, 0.22))
	button.add_theme_color_override("font_shadow_color", Color(0.02, 0.009, 0.004, 0.9))
	button.add_theme_constant_override("shadow_offset_x", 1)
	button.add_theme_constant_override("shadow_offset_y", 2)

func _make_menu_button_style(accent: Color, state: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.056, 0.026, 0.95)
	if state == 1:
		style.bg_color = Color(0.19, 0.084, 0.035, 0.98)
	elif state == 2:
		style.bg_color = Color(0.07, 0.028, 0.014, 0.98)
	elif state == 3:
		style.bg_color = Color(0.12, 0.1, 0.078, 0.72)
	style.border_color = accent
	style.border_width_left = 4
	style.border_width_top = 3
	style.border_width_right = 4
	style.border_width_bottom = 3
	if state == 1:
		style.border_width_top = 4
		style.border_width_bottom = 4
	elif state == 2:
		style.border_width_top = 2
		style.border_width_bottom = 5
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.shadow_color = Color(0.018, 0.008, 0.003, 0.62 if state != 2 else 0.36)
	style.shadow_size = 4 if state != 2 else 2
	style.shadow_offset = Vector2(2.0, 4.0 if state != 2 else 1.0)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _make_card_style(accent: Color, faded: bool = false, equipped: bool = false, state: int = 0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	var parchment := Color(0.88, 0.68, 0.36, 0.96)
	if equipped:
		parchment = Color(0.98, 0.72, 0.32, 0.98)
	elif faded:
		parchment = Color(0.45, 0.34, 0.23, 0.86)
	if state == 1:
		parchment = parchment.lightened(0.08)
	elif state == 2:
		parchment = parchment.darkened(0.14)
	style.bg_color = parchment
	style.border_color = Color(0.18, 0.078, 0.032, 0.96) if not equipped else accent.lightened(0.12)
	if state == 1:
		style.border_color = accent.lightened(0.2)
	elif state == 2:
		style.border_color = accent.darkened(0.18)
	style.border_width_left = 5
	style.border_width_top = 4
	style.border_width_right = 5
	style.border_width_bottom = 6
	if state == 1:
		style.border_width_top = 5
		style.border_width_bottom = 7
	elif state == 2:
		style.border_width_top = 3
		style.border_width_bottom = 8
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_color = Color(0.025, 0.011, 0.004, 0.56 if state != 2 else 0.32)
	style.shadow_size = 5 if state == 1 else 4
	style.shadow_offset = Vector2(2.0, 4.0 if state != 2 else 1.0)
	style.expand_margin_left = 1.0
	style.expand_margin_top = 1.0
	style.expand_margin_right = 1.0
	style.expand_margin_bottom = 2.0
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	return style

func _apply_button_card_style(button: Button, accent: Color, faded: bool = false, equipped: bool = false) -> void:
	button.add_theme_stylebox_override("normal", _make_card_style(accent, faded, equipped, 0))
	button.add_theme_stylebox_override("hover", _make_card_style(accent.lightened(0.15), faded, equipped, 1))
	button.add_theme_stylebox_override("pressed", _make_card_style(accent.darkened(0.1), faded, equipped, 2))
	button.add_theme_stylebox_override("disabled", _make_card_style(Color(0.24, 0.2, 0.16), true, false, 0))
	button.add_theme_stylebox_override("focus", _make_card_style(accent.lightened(0.22), faded, equipped, 1))
	button.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	button.add_theme_color_override("font_hover_color", Color(0.08, 0.035, 0.018))
	button.add_theme_color_override("font_pressed_color", Color(0.12, 0.05, 0.02))
	button.add_theme_color_override("font_disabled_color", Color(0.24, 0.2, 0.16))
	button.add_theme_color_override("font_focus_color", Color(0.08, 0.035, 0.018))
	button.add_theme_color_override("font_shadow_color", Color(1.0, 0.78, 0.34, 0.22))
	button.add_theme_constant_override("shadow_offset_y", 1)
	if button is LoadoutCardButton:
		(button as LoadoutCardButton).set_card_state(accent, faded, equipped)

func _create_guns_panel() -> void:
	_guns_panel.visible = false
	_guns_panel.custom_minimum_size = Vector2(520, 360)
	_guns_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_guns_panel)

	var title := Label.new()
	title.text = "GUN CARDS  CLICK TO EQUIP"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(534, 30)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_guns_panel.add_child(title)

	_guns_grid.columns = 2
	_guns_grid.add_theme_constant_override("h_separation", 14)
	_guns_grid.add_theme_constant_override("v_separation", 14)
	_guns_panel.add_child(_guns_grid)

	for gun_id in _gun_ids:
		var button := LoadoutCardButton.new()
		button.flat = false
		button.custom_minimum_size = Vector2(260, 150)
		button.pressed.connect(func() -> void:
			_equip_gun(gun_id)
		)
		_gun_buttons[gun_id] = button
		_guns_grid.add_child(button)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_bottom", 8)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(margin)

		var stack := VBoxContainer.new()
		stack.custom_minimum_size = Vector2(236, 132)
		stack.add_theme_constant_override("separation", 5)
		stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.add_child(stack)

		var top_row := HBoxContainer.new()
		top_row.custom_minimum_size = Vector2(236, 30)
		top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(top_row)

		var name_label := Label.new()
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.custom_minimum_size = Vector2(160, 30)
		name_label.add_theme_font_size_override("font_size", 19)
		name_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(name_label)

		var status_label := Label.new()
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		status_label.custom_minimum_size = Vector2(76, 30)
		status_label.add_theme_font_size_override("font_size", 12)
		status_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(status_label)

		var accent_bar := ColorRect.new()
		accent_bar.color = Color(0.86, 0.46, 0.18)
		accent_bar.custom_minimum_size = Vector2(236, 7)
		accent_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(accent_bar)

		var body_row := HBoxContainer.new()
		body_row.custom_minimum_size = Vector2(236, 56)
		body_row.add_theme_constant_override("separation", 8)
		body_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(body_row)

		var loadout_icon := LoadoutIcon.new()
		loadout_icon.custom_minimum_size = Vector2(72, 56)
		loadout_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_gun_icons[gun_id] = loadout_icon
		body_row.add_child(loadout_icon)

		var body_label := Label.new()
		body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		body_label.custom_minimum_size = Vector2(156, 56)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 14)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		body_row.add_child(body_label)

		var footer_label := Label.new()
		footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		footer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		footer_label.custom_minimum_size = Vector2(236, 24)
		footer_label.add_theme_font_size_override("font_size", 13)
		footer_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045))
		footer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(footer_label)

		_gun_buttons["%s_name" % gun_id] = name_label
		_gun_buttons["%s_status" % gun_id] = status_label
		_gun_buttons["%s_body" % gun_id] = body_label
		_gun_buttons["%s_footer" % gun_id] = footer_label
	_refresh_gun_buttons()

func _create_abilities_panel() -> void:
	_abilities_panel.visible = false
	_abilities_panel.custom_minimum_size = Vector2(520, 360)
	_abilities_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_abilities_panel)

	var title := Label.new()
	title.text = "ABILITY CARDS  CLICK TO EQUIP"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(534, 30)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_abilities_panel.add_child(title)

	_abilities_grid.columns = 2
	_abilities_grid.add_theme_constant_override("h_separation", 14)
	_abilities_grid.add_theme_constant_override("v_separation", 14)
	_abilities_panel.add_child(_abilities_grid)

	for ability_id in _ability_ids:
		var button := LoadoutCardButton.new()
		button.flat = false
		button.custom_minimum_size = Vector2(260, 150)
		_apply_button_card_style(button, Color(0.86, 0.58, 0.28))
		button.pressed.connect(func() -> void:
			_toggle_ability(ability_id)
		)
		_ability_buttons[ability_id] = button
		_abilities_grid.add_child(button)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_bottom", 8)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(margin)

		var stack := VBoxContainer.new()
		stack.custom_minimum_size = Vector2(236, 132)
		stack.add_theme_constant_override("separation", 5)
		stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.add_child(stack)

		var top_row := HBoxContainer.new()
		top_row.custom_minimum_size = Vector2(236, 30)
		top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(top_row)

		var name_label := Label.new()
		name_label.text = ""
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.custom_minimum_size = Vector2(160, 30)
		name_label.add_theme_font_size_override("font_size", 19)
		name_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(name_label)

		var status_label := Label.new()
		status_label.text = ""
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		status_label.custom_minimum_size = Vector2(76, 30)
		status_label.add_theme_font_size_override("font_size", 12)
		status_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_row.add_child(status_label)

		var accent_bar := ColorRect.new()
		accent_bar.color = Color(0.86, 0.46, 0.18)
		accent_bar.custom_minimum_size = Vector2(236, 7)
		accent_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(accent_bar)

		var body_row := HBoxContainer.new()
		body_row.custom_minimum_size = Vector2(236, 56)
		body_row.add_theme_constant_override("separation", 8)
		body_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(body_row)

		var loadout_icon := LoadoutIcon.new()
		loadout_icon.custom_minimum_size = Vector2(72, 56)
		loadout_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ability_icons[ability_id] = loadout_icon
		body_row.add_child(loadout_icon)

		var body_label := Label.new()
		body_label.text = ""
		body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		body_label.custom_minimum_size = Vector2(156, 56)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 14)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		body_row.add_child(body_label)

		var footer_label := Label.new()
		footer_label.text = ""
		footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		footer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		footer_label.custom_minimum_size = Vector2(236, 24)
		footer_label.add_theme_font_size_override("font_size", 13)
		footer_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045))
		footer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(footer_label)

		_ability_buttons[ability_id] = button
		_ability_buttons["%s_name" % ability_id] = name_label
		_ability_buttons["%s_status" % ability_id] = status_label
		_ability_buttons["%s_body" % ability_id] = body_label
		_ability_buttons["%s_footer" % ability_id] = footer_label
	_refresh_ability_buttons()

func _show_card_grid(cards: Array) -> void:
	_guns_panel.visible = false
	_abilities_panel.visible = false
	_quests_panel.visible = false
	_upgrades_panel.visible = false
	_cards_scroll.visible = true
	for child in _cards_grid.get_children():
		_cards_grid.remove_child(child)
		child.queue_free()
	for card_data in cards:
		var card := InfoCard.new()
		card.configure(
			str(card_data.get("title", "")),
			str(card_data.get("category", "")),
			str(card_data.get("body", "")),
			str(card_data.get("footer", "")),
			card_data.get("accent", Color(0.82, 0.46, 0.18))
		)
		_cards_grid.add_child(card)

func _show_overview_cards() -> void:
	_show_card_grid([
		{"title": "Dust Heist", "category": "RUN", "body": "Survive the courthouse ambush, clear outlaw waves, and bank credits after the dust settles.", "footer": "Goal: stay alive", "accent": Color(0.78, 0.42, 0.18)},
		{"title": "Courtyard", "category": "RULES", "body": "Fight through a sandy western arena where movement, parries, Dust Veil, and clean spacing decide each run.", "footer": "Progress persists", "accent": Color(0.95, 0.68, 0.24)},
	])

func _show_sword_cards() -> void:
	_set_active_menu_button("SWORDS")
	_show_card_grid([
		{"title": "Saber", "category": "OWNED", "body": "Quick, reliable close-range slash. Use it to cut rushers, punish riflemen, and parry danger.", "footer": "Starter blade", "accent": Color(0.72, 0.46, 0.2)},
		{"title": "Black Sash", "category": "LOCKED", "body": "Sharper boss-pressure blade with a faster parry window.", "footer": "Unlock: defeat 1 duelist", "accent": Color(0.18, 0.08, 0.04)},
		{"title": "Grave Saber", "category": "LOCKED", "body": "Longer, heavier blade for clearing packed outlaw waves.", "footer": "Unlock: kill 100 enemies", "accent": Color(0.42, 0.38, 0.32)},
		{"title": "Sandstorm", "category": "LOCKED", "body": "Wide sweeping saber made for surviving crowded late waves.", "footer": "Unlock: reach wave 10", "accent": Color(0.78, 0.58, 0.3)},
		{"title": "Red Canyon", "category": "LOCKED", "body": "Heavy duelist blade with punishing single-strike damage.", "footer": "Unlock: defeat 8 duelists", "accent": Color(0.66, 0.16, 0.08)},
		{"title": "Sunrise", "category": "LOCKED", "body": "Endgame saber with long reach, wide arc, and generous parry timing.", "footer": "Unlock: kill 250 enemies", "accent": Color(1.0, 0.72, 0.2)},
		{"title": "Parry Timing", "category": "MOVE", "body": "Slash at the right moment to turn danger into space. Parries cool the fight down and keep you alive.", "footer": "Close-range skill", "accent": Color(0.95, 0.82, 0.34)},
	])

func _show_guns_screen() -> void:
	_set_active_menu_button("GUNS")
	_cards_scroll.visible = false
	_abilities_panel.visible = false
	_quests_panel.visible = false
	_upgrades_panel.visible = false
	_guns_panel.visible = true
	_refresh_gun_buttons()

func _show_information_cards() -> void:
	_set_active_menu_button("INFORMATION")
	_show_card_grid(INFORMATION_CARDS)

func _show_abilities_screen() -> void:
	_set_active_menu_button("ABILITIES")
	_cards_scroll.visible = false
	_guns_panel.visible = false
	_quests_panel.visible = false
	_upgrades_panel.visible = false
	_abilities_panel.visible = true
	_refresh_ability_buttons()

func _equip_gun(gun_id: String) -> void:
	if not _unlocked_guns.has(gun_id):
		return
	_equipped_gun = gun_id
	_refresh_gun_buttons()
	gun_loadout_changed.emit(gun_id)

func _refresh_gun_buttons() -> void:
	for gun_id in _gun_ids:
		if not _gun_buttons.has(gun_id):
			continue
		var button: Button = _gun_buttons[gun_id]
		var name_label: Label = _gun_buttons["%s_name" % gun_id]
		var status_label: Label = _gun_buttons["%s_status" % gun_id]
		var body_label: Label = _gun_buttons["%s_body" % gun_id]
		var footer_label: Label = _gun_buttons["%s_footer" % gun_id]
		var unlocked := _unlocked_guns.has(gun_id)
		var equipped := _equipped_gun == gun_id
		name_label.text = _gun_names[gun_id]
		status_label.text = "EQUIPPED" if equipped else ("READY" if unlocked else "LOCKED")
		body_label.text = _gun_descriptions[gun_id]
		footer_label.text = "Equipped gun" if equipped else ("Click to equip" if unlocked else _gun_unlocks[gun_id])
		var label_modulate := Color(1.0, 1.0, 1.0, 1.0) if unlocked else Color(0.78, 0.68, 0.56, 0.95)
		name_label.modulate = label_modulate
		status_label.modulate = label_modulate
		body_label.modulate = label_modulate
		footer_label.modulate = label_modulate
		if _gun_icons.has(gun_id):
			var icon: LoadoutIcon = _gun_icons[gun_id]
			icon.set_state(gun_id, "gun", not unlocked, equipped)
		button.disabled = false
		_apply_button_card_style(button, Color(0.86, 0.58, 0.28), not unlocked, equipped)

func _toggle_ability(ability_id: String) -> void:
	if not _unlocked_abilities.has(ability_id):
		return
	if _equipped_abilities.has(ability_id):
		if _equipped_abilities.size() <= 1:
			return
		_equipped_abilities.erase(ability_id)
	else:
		if _equipped_abilities.size() >= 4:
			_equipped_abilities.pop_front()
		_equipped_abilities.append(ability_id)
	_refresh_ability_buttons()
	ability_loadout_changed.emit(_equipped_abilities.duplicate())

func _refresh_ability_buttons() -> void:
	for ability_id in _ability_ids:
		if not _ability_buttons.has(ability_id):
			continue
		var button: Button = _ability_buttons[ability_id]
		var name_label: Label = _ability_buttons["%s_name" % ability_id]
		var status_label: Label = _ability_buttons["%s_status" % ability_id]
		var body_label: Label = _ability_buttons["%s_body" % ability_id]
		var footer_label: Label = _ability_buttons["%s_footer" % ability_id]
		var unlocked := _unlocked_abilities.has(ability_id)
		var equipped_index := _equipped_abilities.find(ability_id)
		var key_label := str(equipped_index + 1) if equipped_index >= 0 else ""
		var status := "SLOT %s" % key_label if equipped_index >= 0 else "READY"
		var footer := "Click to equip"
		if not unlocked:
			status = "LOCKED"
			footer = "Earn from quests"
		elif equipped_index >= 0:
			footer = "Equipped to key %s" % key_label
		name_label.text = _ability_names[ability_id]
		status_label.text = status
		body_label.text = _ability_descriptions[ability_id]
		footer_label.text = footer
		var label_modulate := Color(1.0, 1.0, 1.0, 1.0) if unlocked else Color(0.78, 0.68, 0.56, 0.95)
		name_label.modulate = label_modulate
		status_label.modulate = label_modulate
		body_label.modulate = label_modulate
		footer_label.modulate = label_modulate
		if _ability_icons.has(ability_id):
			var icon: LoadoutIcon = _ability_icons[ability_id]
			icon.set_state(ability_id, "ability", not unlocked, equipped_index >= 0)
		button.disabled = false
		_apply_button_card_style(button, Color(0.86, 0.58, 0.28), not unlocked, equipped_index >= 0)

func _create_upgrades_panel() -> void:
	_upgrades_panel.visible = false
	_upgrades_panel.custom_minimum_size = Vector2(520, 360)
	_upgrades_panel.add_theme_constant_override("separation", 10)
	_menu_content.add_child(_upgrades_panel)

	var title := Label.new()
	title.text = "PERMANENT UPGRADES"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(534, 30)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_upgrades_panel.add_child(title)
	_upgrade_buttons["title"] = title

	var token_label := Label.new()
	token_label.text = "TOKENS 0"
	token_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	token_label.custom_minimum_size = Vector2(534, 24)
	token_label.add_theme_font_size_override("font_size", 18)
	token_label.add_theme_color_override("font_color", Color(0.96, 0.86, 0.58))
	token_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_upgrades_panel.add_child(token_label)
	_upgrade_buttons["tokens"] = token_label

	_upgrades_scroll.custom_minimum_size = Vector2(520, 300)
	_upgrades_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_upgrades_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_upgrades_panel.add_child(_upgrades_scroll)

	_upgrades_grid.columns = 2
	_upgrades_grid.add_theme_constant_override("h_separation", 12)
	_upgrades_grid.add_theme_constant_override("v_separation", 12)
	_upgrades_scroll.add_child(_upgrades_grid)
	_refresh_upgrade_panel()

func _show_upgrades_screen() -> void:
	_set_active_menu_button("UPGRADES")
	_cards_scroll.visible = false
	_guns_panel.visible = false
	_abilities_panel.visible = false
	_quests_panel.visible = false
	_upgrades_panel.visible = true
	_refresh_upgrade_panel()

func set_upgrade_data(upgrades: Array[Dictionary], token_count: int) -> void:
	_upgrade_data = upgrades.duplicate(true)
	_upgrade_tokens = token_count
	_refresh_upgrade_panel()

func _refresh_upgrade_panel() -> void:
	if _upgrades_grid == null or not is_instance_valid(_upgrades_grid):
		return
	if _upgrade_buttons.has("tokens"):
		var token_label: Label = _upgrade_buttons["tokens"]
		token_label.text = "TOKENS %d  QUESTS AND RIVAL BOSSES PAY THESE OUT" % _upgrade_tokens
	for child in _upgrades_grid.get_children():
		_upgrades_grid.remove_child(child)
		child.queue_free()
	for upgrade in _upgrade_data:
		var upgrade_id := str(upgrade.get("id", ""))
		var owned := bool(upgrade.get("owned", false))
		var cost := int(upgrade.get("cost", 1))
		var can_buy := not owned and _upgrade_tokens >= cost
		var button := LoadoutCardButton.new()
		button.flat = false
		button.custom_minimum_size = Vector2(260, 132)
		button.disabled = owned
		_apply_button_card_style(button, Color(0.92, 0.62, 0.22), false, owned)
		button.pressed.connect(func() -> void:
			upgrade_purchase_requested.emit(upgrade_id)
		)
		_upgrades_grid.add_child(button)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_bottom", 8)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(margin)

		var stack := VBoxContainer.new()
		stack.add_theme_constant_override("separation", 5)
		stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.add_child(stack)

		var name_label := Label.new()
		name_label.text = str(upgrade.get("name", "UPGRADE")).to_upper()
		name_label.custom_minimum_size = Vector2(236, 24)
		name_label.add_theme_font_size_override("font_size", 17)
		name_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(name_label)

		var category_label := Label.new()
		category_label.text = "%s  %s" % [str(upgrade.get("category", "PASSIVE")), "OWNED" if owned else ("BUY %d TOKEN%s" % [cost, "" if cost == 1 else "S"])]
		category_label.custom_minimum_size = Vector2(236, 22)
		category_label.add_theme_font_size_override("font_size", 13)
		category_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045))
		category_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(category_label)

		var accent_bar := ColorRect.new()
		accent_bar.color = Color(0.38, 0.58, 0.18, 0.95) if owned else (Color(0.95, 0.64, 0.18, 0.95) if can_buy else Color(0.48, 0.28, 0.14, 0.82))
		accent_bar.custom_minimum_size = Vector2(236, 7)
		accent_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(accent_bar)

		var body_label := Label.new()
		body_label.text = str(upgrade.get("description", "Permanent character benefit."))
		body_label.custom_minimum_size = Vector2(236, 44)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 14)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(body_label)

		var footer_label := Label.new()
		footer_label.text = "Permanent" if owned else ("Click to buy" if can_buy else "Earn tokens from quests and bosses")
		footer_label.custom_minimum_size = Vector2(236, 20)
		footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		footer_label.add_theme_font_size_override("font_size", 12)
		footer_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045))
		footer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(footer_label)

func _create_quests_panel() -> void:
	_quests_panel.visible = false
	_quests_panel.custom_minimum_size = Vector2(440, 308)
	_quests_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_quests_panel)

	var title := Label.new()
	title.text = "QUESTS"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_quests_panel.add_child(title)

	for i in range(4):
		var card := QuestCard.new()
		_quest_cards.append(card)
		_quests_panel.add_child(card)
	_refresh_quest_panel()

func _show_quests_screen() -> void:
	_set_active_menu_button("QUESTS")
	_cards_scroll.visible = false
	_guns_panel.visible = false
	_abilities_panel.visible = false
	_upgrades_panel.visible = false
	_quests_panel.visible = true
	_refresh_quest_panel()

func _refresh_quest_panel() -> void:
	for i in range(_quest_cards.size()):
		var card := _quest_cards[i]
		if i >= _quest_data.size():
			card.visible = false
			continue
		card.visible = true
		var quest := _quest_data[i]
		card.configure(quest)

func _layout_menu() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var title_width := minf(viewport_size.x - 80.0, 900.0)
	var compact := viewport_size.x < 760.0
	_menu_title.add_theme_font_size_override("font_size", 46 if compact else 56)
	_menu_title.position = Vector2((viewport_size.x - title_width) * 0.5, 42.0 if compact else 58.0)
	_menu_title.size = Vector2(title_width, 88.0)

	var side_margin := 34.0 if compact else 56.0
	var content_width := minf(viewport_size.x - side_margin, 880.0)
	var content_height := minf(520.0, viewport_size.y - (126.0 if compact else 150.0))
	var content_y := maxf(112.0 if compact else 130.0, viewport_size.y * (0.2 if compact else 0.23))
	_menu_content.position = Vector2((viewport_size.x - content_width) * 0.5, content_y)
	_menu_content.size = Vector2(content_width, content_height)
	var separation := 24.0 if compact else 48.0
	_menu_content.add_theme_constant_override("separation", int(separation))
	var nav_width := clampf(content_width * (0.29 if compact else 0.3), 168.0 if compact else 200.0, 220.0)
	var right_width := maxf(260.0, content_width - nav_width - separation)
	if right_width + nav_width + separation > content_width:
		nav_width = maxf(148.0, content_width - separation - right_width)
	_menu_panel.custom_minimum_size = Vector2(nav_width, content_height)
	for button in _menu_buttons:
		if button != null and is_instance_valid(button):
			button.custom_minimum_size = Vector2(nav_width, 42.0 if compact else 44.0)
			button.add_theme_font_size_override("font_size", 16 if compact else 18)
	_cards_scroll.custom_minimum_size = Vector2(right_width, content_height)
	_guns_panel.custom_minimum_size = Vector2(right_width, content_height)
	_abilities_panel.custom_minimum_size = Vector2(right_width, content_height)
	_quests_panel.custom_minimum_size = Vector2(right_width, content_height)
	_upgrades_panel.custom_minimum_size = Vector2(right_width, content_height)
	_upgrades_scroll.custom_minimum_size = Vector2(right_width, maxf(220.0, content_height - 64.0))
	var columns := 1 if right_width < 520.0 else 2
	_cards_grid.columns = columns
	_guns_grid.columns = columns
	_abilities_grid.columns = columns
	_upgrades_grid.columns = columns
	var grid_gap := 10 if compact or columns == 1 else 14
	_cards_grid.add_theme_constant_override("h_separation", grid_gap)
	_cards_grid.add_theme_constant_override("v_separation", grid_gap)
	_guns_grid.add_theme_constant_override("h_separation", grid_gap)
	_guns_grid.add_theme_constant_override("v_separation", grid_gap)
	_abilities_grid.add_theme_constant_override("h_separation", grid_gap)
	_abilities_grid.add_theme_constant_override("v_separation", grid_gap)
	_upgrades_grid.add_theme_constant_override("h_separation", grid_gap)
	_upgrades_grid.add_theme_constant_override("v_separation", grid_gap)
	_last_menu_content_width = content_width
	_last_menu_nav_width = nav_width
	_last_menu_right_width = right_width
	_last_menu_column_count = columns

func _set_gameplay_hud_visible(visible_state: bool) -> void:
	_hud_ledger_frame.visible = visible_state
	_health_back.visible = visible_state
	_health_bar.visible = visible_state
	_heart_label.visible = visible_state
	_alert_label.visible = visible_state
	_timer_label.visible = visible_state
	_wave_label.visible = visible_state
	_style_label.visible = visible_state
	_ammo_label.visible = visible_state
	_style_pop_back.visible = visible_state
	_style_pop_rule.visible = visible_state
	_style_pop.visible = visible_state
	_objective_panel.visible = visible_state
	for icon in _skill_icons:
		icon.visible = visible_state

func _create_skill_icons() -> void:
	var ids := ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
	for i in range(ids.size()):
		var icon := SkillIcon.new()
		icon.position = Vector2(28.0 + i * 66.0, 164.0)
		icon.size = Vector2(54.0, 54.0)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_state(ids[i], str(i + 1), 0.0)
		_skill_icons.append(icon)
		_root.add_child(icon)

func _format_hearts(current: int, maximum: int) -> String:
	var text := ""
	for i in range(maximum):
		text += "♥" if i < current else "♡"
	return text

func _update_skill_icons(program_system) -> void:
	var summary: Array[Dictionary] = program_system.get_equipped_summary()
	for i in range(_skill_icons.size()):
		var icon := _skill_icons[i]
		if i >= summary.size():
			icon.set_state("", "", 0.0)
			continue
		var skill: Dictionary = summary[i]
		var max_cooldown: float = skill.get("max_cooldown", 1.0)
		var cooldown: float = skill.get("cooldown", 0.0)
		var fraction := 0.0 if max_cooldown <= 0.0 else cooldown / max_cooldown
		icon.set_state(skill["id"], str(i + 1), fraction)
