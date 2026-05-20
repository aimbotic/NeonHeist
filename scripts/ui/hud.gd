class_name NeonHud
extends CanvasLayer

var _root := Control.new()
var _health_bar := ColorRect.new()
var _health_back := ColorRect.new()
var _alert_label := Label.new()
var _timer_label := Label.new()
var _loot_label := Label.new()
var _program_label := Label.new()
var _message_label := Label.new()
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
	_configure_label(_loot_label, Vector2(28, 108), 18)
	_configure_label(_program_label, Vector2(28, 142), 15)

	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_message_label.add_theme_font_size_override("font_size", 34)
	_message_label.add_theme_color_override("font_color", Color(0.86, 0.62, 0.36))
	_message_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_message_label)

func update_run(player, director, program_system, loot: int, extraction_open: bool) -> void:
	_elapsed += get_process_delta_time()
	var health_fraction: float = clamp(player.health / player.max_health, 0.0, 1.0)
	_health_bar.size.x = 260.0 * health_fraction
	_health_bar.color = Color(0.72, 0.08, 0.04) if health_fraction < 0.34 else Color(0.72, 0.42, 0.18)

	_alert_label.text = "ALERT %d  %02d%%" % [director.alert_level, int(director.alert_meter * 100.0)]
	_timer_label.text = "TIME %02d:%02d" % [int(_elapsed / 60.0), int(_elapsed) % 60]
	_loot_label.text = "DATA %d/3  EXIT %s" % [loot, "OPEN" if extraction_open else "LOCKED"]
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

func _configure_label(label: Label, position: Vector2, font_size: int) -> void:
	label.position = position
	label.size = Vector2(560, 24)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.82, 0.57, 0.32))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(label)

func _format_programs(program_system) -> String:
	var parts: Array[String] = []
	for program in program_system.get_equipped_summary():
		var label: String = program["name"]
		if program["cooldown"] > 0.0:
			label += " %.1f" % program["cooldown"]
		parts.append(label)
	var text := "RELICS  "
	for i in range(parts.size()):
		if i > 0:
			text += "  |  "
		text += parts[i]
	return text
