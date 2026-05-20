class_name DustHud
extends CanvasLayer

signal play_requested
signal ability_loadout_changed(equipped_ids: Array[String])

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

var _root := Control.new()
var _menu_root := Control.new()
var _menu_title := Label.new()
var _menu_panel := VBoxContainer.new()
var _menu_detail := Label.new()
var _menu_content := HBoxContainer.new()
var _abilities_panel := VBoxContainer.new()
var _quests_panel := VBoxContainer.new()
var _abilities_icons: Array[SkillIcon] = []
var _ability_rows: Dictionary = {}
var _ability_buttons: Dictionary = {}
var _quest_labels: Dictionary = {}
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
	"deadeye": "Long-range crosshair shot for picking off riflemen.",
	"ricochet_shot": "Bouncing bullet that punishes packed enemies.",
	"dust_veil": "Wind and sand burst that buys breathing room.",
	"quickdraw": "Fast revolver skillshot for a clean opening strike.",
	"duelist_lunge": "Boss quickdraw dash stolen from defeated duelists.",
	"fan_hammer": "Rapid revolver fan-fire earned from impossible wave work.",
	"ghost_step": "A dust-cloak sidestep for surviving ugly odds.",
}
var _unlocked_abilities: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
var _equipped_abilities: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
var _quest_data: Array[Dictionary] = []
var _health_bar := ColorRect.new()
var _health_back := ColorRect.new()
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

	_configure_label(_alert_label, Vector2(28, 56), 18)
	_configure_label(_timer_label, Vector2(28, 82), 18)
	_configure_label(_wave_label, Vector2(28, 108), 18)
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
	_show_menu_detail("Choose your loadout, then enter the courtyard.")
	_death_screen.color.a = 0.0
	_death_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.64, 0.0))
	_message_label.text = ""

func set_ability_loadout_data(unlocked_ids: Array[String], equipped_ids: Array[String]) -> void:
	_unlocked_abilities = unlocked_ids.duplicate()
	_equipped_abilities = equipped_ids.duplicate()
	_refresh_ability_buttons()

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
	_menu_title.add_theme_font_size_override("font_size", 68)
	_menu_title.add_theme_color_override("font_color", Color(0.95, 0.78, 0.45))
	_menu_title.position = Vector2.ZERO
	_menu_title.size = Vector2(900.0, 86.0)
	_menu_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.add_child(_menu_title)

	_menu_content.position = Vector2.ZERO
	_menu_content.size = Vector2(720.0, 244.0)
	_menu_content.add_theme_constant_override("separation", 48)
	_menu_root.add_child(_menu_content)

	_menu_panel.custom_minimum_size = Vector2(270, 244)
	_menu_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_menu_panel)

	_add_menu_button("PLAY", func() -> void:
		hide_main_menu()
		play_requested.emit()
	)
	_add_menu_button("SELECT BLADE", func() -> void:
		_show_menu_detail("Blade: Saber\nBoss reward: Black Sash Saber from defeated duelists.")
	)
	_add_menu_button("SELECT GUN", func() -> void:
		_show_menu_detail("Gun: Revolver\nQuickdraw skillshot, Deadeye long shot, Ricochet round.")
	)
	_add_menu_button("ABILITIES", func() -> void:
		_show_abilities_screen()
	)
	_add_menu_button("QUESTS", func() -> void:
		_show_quests_screen()
	)
	_add_menu_button("SETTINGS", func() -> void:
		_show_menu_detail("Settings\nWASD moves, J or mouse slashes, 1-4 uses skills.")
	)

	_menu_detail.custom_minimum_size = Vector2(400, 308)
	_menu_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_menu_detail.add_theme_font_size_override("font_size", 24)
	_menu_detail.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_menu_detail.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
	_menu_detail.text = "Choose your loadout, then enter the courtyard."
	_menu_detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_content.add_child(_menu_detail)
	_create_abilities_panel()
	_create_quests_panel()

func _add_menu_button(text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(270, 52)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.78, 0.36))
	button.pressed.connect(callback)
	_menu_panel.add_child(button)

func _create_abilities_panel() -> void:
	_abilities_panel.visible = false
	_abilities_panel.custom_minimum_size = Vector2(440, 308)
	_abilities_panel.add_theme_constant_override("separation", 12)
	_menu_content.add_child(_abilities_panel)

	var title := Label.new()
	title.text = "ABILITIES"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_abilities_panel.add_child(title)

	for ability_id in _ability_ids:
		var button := Button.new()
		button.flat = true
		button.custom_minimum_size = Vector2(420, 58)
		button.pressed.connect(func() -> void:
			_toggle_ability(ability_id)
		)
		_ability_buttons[ability_id] = button
		_abilities_panel.add_child(button)

		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(420, 58)
		row.add_theme_constant_override("separation", 14)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(row)

		var icon := SkillIcon.new()
		icon.custom_minimum_size = Vector2(54, 54)
		icon.size = Vector2(54, 54)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_state(ability_id, "", 0.0)
		_abilities_icons.append(icon)
		row.add_child(icon)

		var copy := Label.new()
		copy.text = ""
		copy.custom_minimum_size = Vector2(330, 54)
		copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		copy.add_theme_font_size_override("font_size", 16)
		copy.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
		copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(copy)
		_ability_rows[ability_id] = {"icon": icon, "label": copy}
	_refresh_ability_buttons()

func _show_menu_detail(text: String) -> void:
	_abilities_panel.visible = false
	_quests_panel.visible = false
	_menu_detail.visible = true
	_menu_detail.text = text

func _show_abilities_screen() -> void:
	_menu_detail.visible = false
	_quests_panel.visible = false
	_abilities_panel.visible = true
	_refresh_ability_buttons()

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
		if not _ability_rows.has(ability_id):
			continue
		var row: Dictionary = _ability_rows[ability_id]
		var icon: SkillIcon = row["icon"]
		var label: Label = row["label"]
		var button: Button = _ability_buttons[ability_id]
		var unlocked := _unlocked_abilities.has(ability_id)
		var equipped_index := _equipped_abilities.find(ability_id)
		var key_label := str(equipped_index + 1) if equipped_index >= 0 else ""
		var prefix := "[%s] " % key_label if equipped_index >= 0 else ""
		var lock_text := "" if unlocked else "LOCKED - Complete quests or defeat bosses"
		label.text = "%s%s\n%s%s" % [
			prefix,
			_ability_names[ability_id],
			_ability_descriptions[ability_id],
			"\n" + lock_text if not unlocked else "",
		]
		label.modulate = Color(1.0, 1.0, 1.0, 1.0) if unlocked else Color(0.55, 0.48, 0.42, 0.82)
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0) if unlocked else Color(0.4, 0.36, 0.32, 0.72)
		icon.set_state(ability_id, key_label, 0.0)
		button.disabled = not unlocked

func _create_quests_panel() -> void:
	_quests_panel.visible = false
	_quests_panel.custom_minimum_size = Vector2(440, 308)
	_quests_panel.add_theme_constant_override("separation", 10)
	_menu_content.add_child(_quests_panel)

	var title := Label.new()
	title.text = "QUESTS"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.36))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_quests_panel.add_child(title)

	for i in range(4):
		var label := Label.new()
		label.custom_minimum_size = Vector2(430, 58)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_font_size_override("font_size", 15)
		label.add_theme_color_override("font_color", Color(0.98, 0.9, 0.76))
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_quest_labels[i] = label
		_quests_panel.add_child(label)
	_refresh_quest_panel()

func _show_quests_screen() -> void:
	_menu_detail.visible = false
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
		label.text = "%s  %s\n%s\nReward: %s" % [
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

	var content_width := minf(viewport_size.x - 96.0, 800.0)
	var content_height := 384.0
	_menu_content.position = Vector2((viewport_size.x - content_width) * 0.5, maxf(190.0, viewport_size.y * 0.34))
	_menu_content.size = Vector2(content_width, content_height)
	_menu_panel.custom_minimum_size = Vector2(minf(270.0, content_width * 0.42), content_height)
	_menu_detail.custom_minimum_size = Vector2(maxf(280.0, content_width - _menu_panel.custom_minimum_size.x - 48.0), content_height)
	_abilities_panel.custom_minimum_size = _menu_detail.custom_minimum_size
	_quests_panel.custom_minimum_size = _menu_detail.custom_minimum_size

func _set_gameplay_hud_visible(visible_state: bool) -> void:
	_health_back.visible = visible_state
	_health_bar.visible = visible_state
	_alert_label.visible = visible_state
	_timer_label.visible = visible_state
	_wave_label.visible = visible_state
	for icon in _skill_icons:
		icon.visible = visible_state

func _create_skill_icons() -> void:
	var ids := ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
	for i in range(ids.size()):
		var icon := SkillIcon.new()
		icon.position = Vector2(28.0 + i * 66.0, 142.0)
		icon.size = Vector2(54.0, 54.0)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_state(ids[i], str(i + 1), 0.0)
		_skill_icons.append(icon)
		_root.add_child(icon)

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
