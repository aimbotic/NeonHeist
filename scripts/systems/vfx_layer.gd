class_name VfxLayer
extends Node2D

var _pulses: Array[Dictionary] = []
var _beams: Array[Dictionary] = []
var _blood_stains: Array[Dictionary] = []
const MAX_BLOOD_STAINS := 15
const BLOOD_TEXTURE_PATHS := [
	"res://assets/vfx/blood_realistic_splat_01.png",
	"res://assets/vfx/blood_realistic_splat_02.png",
	"res://assets/vfx/blood_realistic_splat_03.png",
]

var _blood_textures: Array[Texture2D] = []

func _ready() -> void:
	for path in BLOOD_TEXTURE_PATHS:
		var texture := load(path) as Texture2D
		if texture == null:
			push_warning("Could not load blood texture: %s" % path)
		else:
			_blood_textures.append(texture)

func _process(delta: float) -> void:
	for pulse in _pulses:
		pulse["age"] += delta
	for beam_data in _beams:
		beam_data["age"] += delta
	_pulses = _pulses.filter(func(pulse: Dictionary) -> bool: return pulse["age"] < pulse["life"])
	_beams = _beams.filter(func(beam_data: Dictionary) -> bool: return beam_data["age"] < beam_data["life"])
	queue_redraw()

func _draw() -> void:
	for stain in _blood_stains:
		var origin: Vector2 = stain["origin"]
		var color: Color = stain["color"]
		var radius: float = stain["radius"]
		var texture: Texture2D = stain.get("texture", null)
		if texture != null:
			var size: Vector2 = texture.get_size() * stain["scale"]
			draw_set_transform(origin, stain["rotation"], Vector2(1.0, stain["squash"]))
			draw_texture_rect(texture, Rect2(-size * 0.5, size), false, Color(0.9, 0.74, 0.62, 0.92))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		draw_circle(origin, radius * 0.42, color.darkened(0.18))
		draw_arc(origin, radius * 0.92, 0.0, TAU, 32, Color(0.36, 0.055, 0.018, 0.22), 3.0)
		for drop in stain["drops"]:
			var drop_origin: Vector2 = origin + drop["offset"]
			draw_circle(drop_origin, drop["radius"], color.darkened(drop["darken"]))
			draw_circle(drop_origin + Vector2(-drop["radius"] * 0.26, -drop["radius"] * 0.3), drop["radius"] * 0.28, Color(0.58, 0.02, 0.01, 0.18))

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

func blood_spill(origin: Vector2, amount: int = 9) -> void:
	var drops: Array[Dictionary] = []
	for i in range(amount):
		drops.append({
			"offset": Vector2.RIGHT.rotated(randf() * TAU) * randf_range(8.0, 46.0),
			"radius": randf_range(3.0, 13.0),
			"darken": randf_range(0.05, 0.38),
		})
	_blood_stains.append({
		"origin": origin,
		"radius": randf_range(16.0, 30.0),
		"color": Color(0.36, 0.004, 0.002, 0.78),
		"texture": _blood_textures.pick_random() if not _blood_textures.is_empty() else null,
		"rotation": randf() * TAU,
		"scale": randf_range(0.38, 0.58),
		"squash": randf_range(0.72, 1.08),
		"drops": drops,
	})
	while _blood_stains.size() > MAX_BLOOD_STAINS:
		_blood_stains.pop_front()

func clear_blood_stains() -> void:
	_blood_stains.clear()
	queue_redraw()

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

func skill_flash(origin: Vector2, color: Color) -> void:
	shockwave(origin, color)
	burst(origin, color, 8)

func program_flash(origin: Vector2, color: Color) -> void:
	skill_flash(origin, color)

func beam(from: Vector2, to: Vector2, color: Color) -> void:
	_beams.append({
		"from": from,
		"to": to,
		"life": 0.18,
		"age": 0.0,
		"color": color,
	})
