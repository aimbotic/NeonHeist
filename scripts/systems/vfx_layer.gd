class_name VfxLayer
extends Node2D

var _pulses: Array[Dictionary] = []
var _beams: Array[Dictionary] = []

func _process(delta: float) -> void:
	for pulse in _pulses:
		pulse["age"] += delta
	for beam_data in _beams:
		beam_data["age"] += delta
	_pulses = _pulses.filter(func(pulse: Dictionary) -> bool: return pulse["age"] < pulse["life"])
	_beams = _beams.filter(func(beam_data: Dictionary) -> bool: return beam_data["age"] < beam_data["life"])
	queue_redraw()

func _draw() -> void:
	for pulse in _pulses:
		var t: float = pulse["age"] / pulse["life"]
		var color: Color = pulse["color"]
		color.a *= 1.0 - t
		draw_arc(pulse["origin"], lerpf(8.0, pulse["radius"], t), 0.0, TAU, 42, color, pulse["width"])

	for beam_data in _beams:
		var t: float = beam_data["age"] / beam_data["life"]
		var color: Color = beam_data["color"]
		color.a *= 1.0 - t
		draw_line(beam_data["from"], beam_data["to"], color, lerpf(8.0, 1.0, t))

func burst(origin: Vector2, color: Color, count: int) -> void:
	for i in range(count):
		_pulses.append({
			"origin": origin + Vector2.RIGHT.rotated(randf() * TAU) * randf_range(4.0, 32.0),
			"radius": randf_range(28.0, 96.0),
			"life": randf_range(0.18, 0.42),
			"age": 0.0,
			"color": color,
			"width": randf_range(1.0, 3.0),
		})

func shockwave(origin: Vector2, color: Color) -> void:
	_pulses.append({
		"origin": origin,
		"radius": 260.0,
		"life": 0.52,
		"age": 0.0,
		"color": color,
		"width": 7.0,
	})

func trail_pop(origin: Vector2, color: Color) -> void:
	_pulses.append({
		"origin": origin,
		"radius": 110.0,
		"life": 0.24,
		"age": 0.0,
		"color": color,
		"width": 4.0,
	})

func program_flash(origin: Vector2, color: Color) -> void:
	shockwave(origin, color)
	burst(origin, color, 8)

func beam(from: Vector2, to: Vector2, color: Color) -> void:
	_beams.append({
		"from": from,
		"to": to,
		"life": 0.18,
		"age": 0.0,
		"color": color,
	})
