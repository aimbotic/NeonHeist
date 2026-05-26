class_name DustHud
extends CanvasLayer

signal play_requested
signal ability_loadout_changed(equipped_ids: Array[String])
signal gun_loadout_changed(gun_id: String)

class SkillIcon extends Control:
	var skill_id := ""
	var key_label := ""
	var cooldown_fraction := 0.0

	func _draw() -> void:
		var box := Rect2(Vector2.ZERO, size)
		draw_rect(box, Color(0.045, 0.024, 0.014, 0.94), true)
		draw_rect(box, Color(0.72, 0.46, 0.2, 0.88), false, 2.0)
		draw_circle(size * 0.5, 24.0, Color(0.12, 0.06, 0.025, 0.9))

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
			draw_rect(Rect2(Vector2(0.0, size.y - cover_height), Vector2(size.x, cover_height)), Color(0.02, 0.012, 0.009, 0.7), true)
			draw_line(Vector2(0.0, size.y - cover_height), Vector2(size.x, size.y - cover_height), Color(1.0, 0.82, 0.38, 0.78), 2.0)

	func set_state(id: String, key: String, fraction: float) -> void:
		skill_id = id
		key_label = key
		cooldown_fraction = clampf(fraction, 0.0, 1.0)
		queue_redraw()

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

class InfoCard extends PanelContainer:
	func configure(title: String, category: String, body: String, footer: String = "", accent: Color = Color(0.82, 0.46, 0.18)) -> void:
		var locked := category == "LOCKED"
		custom_minimum_size = Vector2(260.0, 190.0)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

		var panel := StyleBoxFlat.new()
		panel.bg_color = Color(0.46, 0.36, 0.24, 0.9) if locked else Color(0.94, 0.78, 0.48, 0.96)
		panel.border_color = Color(0.24, 0.2, 0.16, 1.0) if locked else Color(0.11, 0.052, 0.024, 1.0)
		panel.border_width_left = 4
		panel.border_width_top = 4
		panel.border_width_right = 4
		panel.border_width_bottom = 4
		panel.corner_radius_top_left = 8
		panel.corner_radius_top_right = 8
		panel.corner_radius_bottom_left = 8
		panel.corner_radius_bottom_right = 8
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
		title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		top_row.add_child(title_label)

		var category_label := Label.new()
		category_label.text = category
		category_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		category_label.custom_minimum_size = Vector2(56.0, 26.0)
		category_label.add_theme_font_size_override("font_size", 13)
		category_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018) if not locked else Color(0.13, 0.1, 0.075))
		category_label.add_theme_color_override("font_outline_color", accent.darkened(0.25))
		category_label.add_theme_constant_override("outline_size", 0)
		top_row.add_child(category_label)

		var art := ColorRect.new()
		art.color = Color(0.24, 0.2, 0.16, 0.95) if locked else accent
		art.custom_minimum_size = Vector2(236.0, 12.0)
		stack.add_child(art)

		var body_label := Label.new()
		body_label.text = body
		body_label.custom_minimum_size = Vector2(236.0, 94.0)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 18)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018) if not locked else Color(0.13, 0.1, 0.075))
		stack.add_child(body_label)

		if footer != "":
			var footer_label := Label.new()
			footer_label.text = footer
			footer_label.custom_minimum_size = Vector2(236.0, 24.0)
			footer_label.add_theme_font_size_override("font_size", 14)
			footer_label.add_theme_color_override("font_color", Color(0.24, 0.11, 0.045) if not locked else Color(0.16, 0.12, 0.08))
			footer_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			stack.add_child(footer_label)

var _root := Control.new()
var _menu_root := Control.new()
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
var _gun_buttons: Dictionary = {}
var _ability_buttons: Dictionary = {}
var _quest_labels: Dictionary = {}
var _gun_ids: Array[String] = ["revolver", "long_rifle", "sawed_off", "pepperbox", "golden_revolver"]
var _gun_names := {
	"revolver": "Revolver",
	"long_rifle": "Long Rifle",
	"sawed_off": "Sawed-Off",
	"pepperbox": "Pepperbox",
	"golden_revolver": "Golden Revolver",
}
var _gun_descriptions := {
	"revolver": "Balanced sidearm for every shot.",
	"long_rifle": "Longer range and higher damage.",
	"sawed_off": "Wide close-range blast style.",
	"pepperbox": "Fast cooldowns, lighter hits.",
	"golden_revolver": "Endgame damage and control.",
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
var _heart_label := Label.new()
var _alert_label := Label.new()
var _timer_label := Label.new()
var _wave_label := Label.new()
var _message_label := Label.new()
var _wave_banner := Label.new()
var _death_screen := ColorRect.new()
var _death_label := Label.new()
var _hit_flash := ColorRect.new()
var _duelist_overlay := Control.new()
var _duelist_card := ColorRect.new()
var _duelist_name := Label.new()
var _duelist_title := Label.new()
var _duelist_art := Label.new()
var _duelist_leaves: Array[ColorRect] = []
var _skill_icons: Array[SkillIcon] = []
var _elapsed := 0.0

func _ready() -> void:
	layer = 50
	add_child(_root)
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_create_menu()

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
	_create_skill_icons()

	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_message_label.add_theme_font_size_override("font_size", 34)
	_message_label.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))
	_message_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_message_label.offset_left = 0.0
	_message_label.offset_top = 22.0
	_message_label.offset_right = 0.0
	_message_label.offset_bottom = 120.0
	_message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_message_label)

	_death_screen.color = Color(0.05, 0.008, 0.006, 0.0)
	_death_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_death_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_death_screen)

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
	_wave_banner.position = Vector2(2000, 260)
	_wave_banner.size = Vector2(520, 92)
	_wave_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_wave_banner)

	_hit_flash.color = Color(0.9, 0.0, 0.0, 0.0)
	_hit_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hit_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_hit_flash)

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

	_duelist_card.color = Color(0.16, 0.075, 0.035, 0.98)
	_duelist_card.size = Vector2(260, 360)
	_duelist_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_overlay.add_child(_duelist_card)

	_duelist_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_title.add_theme_font_size_override("font_size", 24)
	_duelist_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.5))
	_duelist_title.text = "DUELIST"
	_duelist_title.size = Vector2(260, 40)
	_duelist_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_title)

	_duelist_art.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_art.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_duelist_art.add_theme_font_size_override("font_size", 30)
	_duelist_art.add_theme_color_override("font_color", Color(0.02, 0.01, 0.008))
	_duelist_art.text = "WANTED\n\n  O\n /|\\\n / \\"
	_duelist_art.position = Vector2(28, 66)
	_duelist_art.size = Vector2(204, 190)
	_duelist_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_art)

	_duelist_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_duelist_name.add_theme_font_size_override("font_size", 22)
	_duelist_name.add_theme_color_override("font_color", Color.WHITE)
	_duelist_name.size = Vector2(260, 62)
	_duelist_name.position = Vector2(0, 284)
	_duelist_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_duelist_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_duelist_card.add_child(_duelist_name)

func update_run(player, director, program_system, wave: int, enemies_remaining: int) -> void:
	_elapsed += get_process_delta_time()
	var health_fraction: float = clamp(player.health / player.max_health, 0.0, 1.0)
	_health_bar.size.x = 260.0 * health_fraction
	_health_bar.color = Color(0.72, 0.08, 0.04) if health_fraction < 0.34 else Color(0.72, 0.42, 0.18)
	_heart_label.text = _format_hearts(int(ceil(player.health)), int(player.max_health))

	_alert_label.text = "DANGER %d  %02d%%" % [director.alert_level, int(director.alert_meter * 100.0)]
	_timer_label.text = "TIME %02d:%02d" % [int(_elapsed / 60.0), int(_elapsed) % 60]
	_wave_label.text = "WAVE %d  ENEMIES %d" % [wave, enemies_remaining]
	_update_skill_icons(program_system)

func show_run_start(seed_value: int) -> void:
	_elapsed = 0.0
	_death_screen.color.a = 0.0
	_death_label.modulate.a = 1.0
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	_message_label.text = "DUST HEIST\nSEED %d" % seed_value
	var tween := create_tween()
	tween.tween_interval(1.15)
	tween.tween_property(_message_label, "modulate:a", 0.0, 0.35)
	tween.tween_callback(func() -> void:
		_message_label.text = ""
		_message_label.modulate.a = 1.0
	)

func show_run_complete(credits: int) -> void:
	_message_label.modulate.a = 1.0
	_message_label.text = "EXTRACTED\n+%d CREDITS\nPRESS ANY KEY" % credits

func show_unlock(text: String) -> void:
	_message_label.modulate.a = 1.0
	_message_label.text = text
	var tween := create_tween()
	tween.tween_interval(1.2)
	tween.tween_property(_message_label, "modulate:a", 0.0, 0.35)
	tween.tween_callback(func() -> void:
		_message_label.text = ""
		_message_label.modulate.a = 1.0
	)

func show_run_failed() -> void:
	_message_label.text = ""
	_death_screen.color.a = 0.0
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	var tween := create_tween()
	tween.tween_property(_death_screen, "color:a", 0.82, 0.65)
	tween.parallel().tween_method(
		func(alpha: float) -> void:
			_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, alpha)),
		0.0,
		1.0,
		0.85
	)

func show_main_menu() -> void:
	_menu_root.visible = true
	_menu_root.move_to_front()
	_set_gameplay_hud_visible(false)
	_layout_menu()
	_show_overview_cards()
	_death_screen.color.a = 0.0
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	_message_label.text = ""

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
	_menu_root.visible = false
	_set_gameplay_hud_visible(true)

func show_wave_banner(wave: int) -> void:
	_wave_banner.text = "WAVE %d" % wave
	_wave_banner.modulate.a = 1.0
	var viewport_size := get_viewport().get_visible_rect().size
	_wave_banner.position.x = viewport_size.x + 40.0
	_wave_banner.position.y = max(180.0, viewport_size.y * 0.28)

	var center_x := (viewport_size.x - _wave_banner.size.x) * 0.5
	var exit_x := -_wave_banner.size.x - 40.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(_wave_banner, "position:x", center_x, 0.42)
	tween.tween_interval(1.0)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(_wave_banner, "position:x", exit_x, 0.42)

func flash_hit() -> void:
	_hit_flash.color = Color(0.85, 0.0, 0.0, 0.22)
	var tween := create_tween()
	tween.tween_property(_hit_flash, "color:a", 0.0, 0.12)

func show_duelist_intro(name: String, accent: Color) -> void:
	_duelist_name.text = name
	_duelist_overlay.visible = true
	_duelist_overlay.modulate.a = 1.0
	var viewport_size := get_viewport().get_visible_rect().size
	_duelist_card.position = Vector2((viewport_size.x - _duelist_card.size.x) * 0.5, viewport_size.y + 40.0)
	_duelist_card.color = Color(accent.r * 0.35 + 0.08, accent.g * 0.25 + 0.035, accent.b * 0.2 + 0.025, 0.98)
	for i in range(_duelist_leaves.size()):
		var leaf := _duelist_leaves[i]
		leaf.position = Vector2(float((i * 137) % int(viewport_size.x + 180.0)) - 90.0, viewport_size.y * 0.18 + float(i) * 31.0)
		leaf.modulate.a = 1.0
	var center_y := (viewport_size.y - _duelist_card.size.y) * 0.5
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(_duelist_card, "position:y", center_y, 0.32)
	tween.tween_interval(1.05)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(_duelist_overlay, "modulate:a", 0.0, 0.28)
	tween.tween_callback(func() -> void:
		_duelist_overlay.visible = false
		_duelist_overlay.modulate.a = 1.0
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
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(label)

func _create_menu() -> void:
	_menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_menu_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_menu_root)

	var backdrop := ColorRect.new()
	backdrop.color = Color(0.06, 0.026, 0.012, 0.94)
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.add_child(backdrop)

	_menu_title.text = "DUST HEIST"
	_menu_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_menu_title.add_theme_font_size_override("font_size", 56)
	_menu_title.add_theme_color_override("font_color", Color(0.95, 0.78, 0.45))
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
	_create_quests_panel()

func _add_menu_button(text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(220, 44)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.78, 0.36))
	button.pressed.connect(callback)
	_menu_panel.add_child(button)

func _make_card_style(accent: Color, faded: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.94, 0.78, 0.48, 0.94) if not faded else Color(0.46, 0.36, 0.24, 0.86)
	style.border_color = accent.darkened(0.45)
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	return style

func _apply_button_card_style(button: Button, accent: Color, faded: bool = false) -> void:
	button.add_theme_stylebox_override("normal", _make_card_style(accent, faded))
	button.add_theme_stylebox_override("hover", _make_card_style(accent.lightened(0.15), faded))
	button.add_theme_stylebox_override("pressed", _make_card_style(accent.darkened(0.1), faded))
	button.add_theme_stylebox_override("disabled", _make_card_style(Color(0.24, 0.2, 0.16), true))
	button.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
	button.add_theme_color_override("font_hover_color", Color(0.08, 0.035, 0.018))
	button.add_theme_color_override("font_disabled_color", Color(0.24, 0.2, 0.16))

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
		var button := Button.new()
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

		var body_label := Label.new()
		body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		body_label.custom_minimum_size = Vector2(236, 56)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 16)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(body_label)

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
		var button := Button.new()
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

		var body_label := Label.new()
		body_label.text = ""
		body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		body_label.custom_minimum_size = Vector2(236, 56)
		body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body_label.add_theme_font_size_override("font_size", 16)
		body_label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		body_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack.add_child(body_label)

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
		{"title": "Dust Heist", "category": "RUN", "body": "Survive the courthouse ambush, clear outlaw waves, and earn credits before the dust buries you.", "footer": "Goal: stay alive", "accent": Color(0.78, 0.42, 0.18)},
		{"title": "Courtyard", "category": "MAP", "body": "Fight inside a sandy old-west arena ringed by storefronts, cover shadows, and incoming enemies.", "footer": "Stay moving", "accent": Color(0.58, 0.32, 0.14)},
		{"title": "One Hit", "category": "RULE", "body": "Health is precious. Dashes, parries, Dust Veil, and clean spacing decide whether a run survives.", "footer": "Mistakes hurt", "accent": Color(0.72, 0.08, 0.04)},
		{"title": "Credits", "category": "SAVE", "body": "Defeated enemies and cleared waves pay credits after a run ends. Quest progress is saved locally.", "footer": "Progress persists", "accent": Color(0.95, 0.68, 0.24)},
	])

func _show_sword_cards() -> void:
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
	_cards_scroll.visible = false
	_abilities_panel.visible = false
	_quests_panel.visible = false
	_guns_panel.visible = true
	_refresh_gun_buttons()

func _show_information_cards() -> void:
	_show_card_grid([
		{"title": "Move", "category": "INPUT", "body": "Use WASD or arrow keys to cross the courtyard and dodge enemy pressure.", "footer": "Keyboard", "accent": Color(0.62, 0.35, 0.16)},
		{"title": "Dash", "category": "INPUT", "body": "Press Space to burst through danger. Dashing adds heat, so spend it with intent.", "footer": "Space", "accent": Color(0.86, 0.58, 0.28)},
		{"title": "Slash", "category": "INPUT", "body": "Press J or left mouse to swing your sword. Use it for close kills and clutch parries.", "footer": "J / Mouse", "accent": Color(0.78, 0.45, 0.2)},
		{"title": "Abilities", "category": "INPUT", "body": "Press 1-4 to cast equipped ability cards. Open Abilities to change the loadout.", "footer": "Slots 1-4", "accent": Color(0.95, 0.78, 0.36)},
		{"title": "Knife Rusher", "category": "ENEMY", "body": "Closes distance quickly and forces you to move. Cut them before they box you in.", "footer": "Melee threat", "accent": Color(0.86, 0.38, 0.08)},
		{"title": "Rifleman", "category": "ENEMY", "body": "Controls long lanes with aimed shots. Break line pressure with movement or Deadeye.", "footer": "Range threat", "accent": Color(0.72, 0.38, 0.16)},
		{"title": "Shotgun Brute", "category": "ENEMY", "body": "Punishes corners and close mistakes. Keep space, dash wide, then strike.", "footer": "Heavy threat", "accent": Color(0.55, 0.18, 0.08)},
		{"title": "Duelist", "category": "BOSS", "body": "Appears every third wave with a wanted-card intro and a dangerous lunge pattern.", "footer": "Boss wave", "accent": Color(0.72, 0.08, 0.04)},
	])

func _show_abilities_screen() -> void:
	_cards_scroll.visible = false
	_guns_panel.visible = false
	_quests_panel.visible = false
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
		button.disabled = false
		_apply_button_card_style(button, Color(0.86, 0.58, 0.28), not unlocked)

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
		button.disabled = false
		_apply_button_card_style(button, Color(0.86, 0.58, 0.28), not unlocked)

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
		var card := PanelContainer.new()
		card.custom_minimum_size = Vector2(500, 96)
		card.add_theme_stylebox_override("panel", _make_card_style(Color(0.86, 0.58, 0.28)))
		_quests_panel.add_child(card)

		var label := Label.new()
		label.custom_minimum_size = Vector2(470, 74)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_font_size_override("font_size", 15)
		label.add_theme_color_override("font_color", Color(0.08, 0.035, 0.018))
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_quest_labels[i] = label
		card.add_child(label)
	_refresh_quest_panel()

func _show_quests_screen() -> void:
	_cards_scroll.visible = false
	_guns_panel.visible = false
	_abilities_panel.visible = false
	_quests_panel.visible = true
	_refresh_quest_panel()

func _refresh_quest_panel() -> void:
	for i in range(_quest_labels.size()):
		var label: Label = _quest_labels[i]
		if i >= _quest_data.size():
			label.text = ""
			continue
		var quest := _quest_data[i]
		var target := int(quest.get("target", 1))
		var progress := int(quest.get("progress", 0))
		var complete := bool(quest.get("complete", false))
		var status := "COMPLETE" if complete else "%d/%d" % [progress, target]
		label.text = "%s\n%s\n%s\nReward: %s" % [
			quest.get("name", "Quest"),
			status,
			quest.get("description", ""),
			quest.get("reward", ""),
		]
		label.modulate = Color(1.0, 0.86, 0.54, 1.0) if complete else Color(1.0, 1.0, 1.0, 1.0)

func _layout_menu() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var title_width := minf(viewport_size.x - 80.0, 900.0)
	_menu_title.position = Vector2((viewport_size.x - title_width) * 0.5, 58.0)
	_menu_title.size = Vector2(title_width, 88.0)

	var content_width := minf(viewport_size.x - 56.0, 880.0)
	var content_height := minf(520.0, viewport_size.y - 150.0)
	_menu_content.position = Vector2((viewport_size.x - content_width) * 0.5, maxf(130.0, viewport_size.y * 0.23))
	_menu_content.size = Vector2(content_width, content_height)
	_menu_panel.custom_minimum_size = Vector2(minf(220.0, content_width * 0.3), content_height)
	var right_width := maxf(280.0, content_width - _menu_panel.custom_minimum_size.x - 48.0)
	_cards_scroll.custom_minimum_size = Vector2(right_width, content_height)
	_guns_panel.custom_minimum_size = Vector2(right_width, content_height)
	_abilities_panel.custom_minimum_size = Vector2(right_width, content_height)
	_quests_panel.custom_minimum_size = Vector2(right_width, content_height)
	_cards_grid.columns = 1 if right_width < 520.0 else 2
	_guns_grid.columns = 1 if right_width < 520.0 else 2
	_abilities_grid.columns = 1 if right_width < 520.0 else 2

func _set_gameplay_hud_visible(visible_state: bool) -> void:
	_health_back.visible = visible_state
	_health_bar.visible = visible_state
	_heart_label.visible = visible_state
	_alert_label.visible = visible_state
	_timer_label.visible = visible_state
	_wave_label.visible = visible_state
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
