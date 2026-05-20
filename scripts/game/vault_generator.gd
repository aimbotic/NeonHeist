class_name VaultGenerator
extends RefCounted

const ARENA_SIZE := Vector2(2200.0, 1400.0)

var _rng := RandomNumberGenerator.new()

func generate(seed_value: int, biome_id: String = "dust_arena") -> Dictionary:
	_rng.seed = seed_value
	var arena := Rect2(-ARENA_SIZE * 0.5, ARENA_SIZE)
	var spawn := arena.get_center()

	return {
		"seed": seed_value,
		"biome": biome_id,
		"arena": arena,
		"rooms": [{"id": 0, "grid": Vector2i.ZERO, "center": arena.get_center(), "rect": arena}],
		"corridors": [],
		"spawn": spawn,
	}
