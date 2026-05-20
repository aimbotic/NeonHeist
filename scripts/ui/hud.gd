class_name NeonHud
extends CanvasLayer

var _root := Control.new()
var _health_bar := ColorRect.new()
var _health_back := ColorRect.new()
var _alert_label := Label.new()
var _timer_label := Label.new()
var _wave_label := Label.new()
var _program_label := Label.new()
var _message_label := Label.new()
var _wave_banner := Label.new()
var _hit_flash := ColorRect.new()
var _duelist_overlay := Control.new()
var _duelist_card := ColorRect.new()
var _duelist_name := Label.new()
var _duelist_title := Label.new()
var _duelist_art := Label.new()
var _duelist_leaves: Array[ColorRect] = []
var _elapsed := 0.0

func _ready() -> void:
	layer = 50
	add_child(_root)
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE

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
	_configure_label(_program_label, Vector2(28, 142), 15)

	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_message_label.add_theme_font_size_override("font_size", 34)
	_message_label.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))
	_message_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_message_label)

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

	_alert_label.text = "ALERT %d  %02d%%" % [director.alert_level, int(director.alert_meter * 100.0)]
	_timer_label.text = "TIME %02d:%02d" % [int(_elapsed / 60.0), int(_elapsed) % 60]
	_wave_label.text = "WAVE %d  ENEMIES %d" % [wave, enemies_remaining]
	_program_label.text = _format_programs(program_system)

func show_run_start(seed_value: int) -> void:
	_elapsed = 0.0
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

func show_run_failed() -> void:
	_message_label.modulate.a = 1.0
	_message_label.text = "GHOST LOST\nPRESS ANY KEY"

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

func _format_programs(program_system) -> String:
	var parts: Array[String] = []
	for program in program_system.get_equipped_summary():
		var label: String = program["name"]
		if program["cooldown"] > 0.0:
			label += " %.1f" % program["cooldown"]
		parts.append(label)
	var text := "ABILITIES  "
	for i in range(parts.size()):
		if i > 0:
			text += "  |  "
		text += parts[i]
	return text
