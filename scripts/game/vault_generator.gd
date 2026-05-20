class_name VaultGenerator
extends RefCounted

const ARENA_SIZE := Vector2(2200.0, 1400.0)

var _rng := RandomNumberGenerator.new()

func generate(seed_value: int, biome_id: String = "dust_arena") -> Dictionary:
	_rng.seed = seed_value
	var arena := Rect2(-ARENA_SIZE * 0.5, ARENA_SIZE)
	var spawn := arena.get_center() + Vector2(-ARENA_SIZE.x * 0.32, 0.0)
	var extraction := arena.get_center() + Vector2(ARENA_SIZE.x * 0.36, 0.0)
	var hack_nodes := _pick_arena_points(arena, 5, 190.0, [spawn, extraction], 260.0)
	var hazards := _pick_arena_points(arena, 10, 130.0, [spawn, extraction], 170.0)
	var enemy_spawns := _pick_arena_points(arena, 15, 120.0, [spawn], 260.0)

	return {
		"seed": seed_value,
		"biome": biome_id,
		"arena": arena,
		"rooms": [{"id": 0, "grid": Vector2i.ZERO, "center": arena.get_center(), "rect": arena}],
		"corridors": [],
		"spawn": spawn,
		"extraction": extraction,
		"hack_nodes": hack_nodes,
		"hazards": hazards,
		"enemy_spawns": enemy_spawns,
	}

func _pick_arena_points(arena: Rect2, count: int, margin: float, avoid_points: Array, avoid_radius: float) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var usable := arena.grow(-margin)
	var attempts := 0
	while points.size() < count and attempts < count * 80:
		attempts += 1
		var candidate := Vector2(
			_rng.randf_range(usable.position.x, usable.end.x),
			_rng.randf_range(usable.position.y, usable.end.y)
		)
		if _too_close(candidate, avoid_points, avoid_radius):
			continue
		if _too_close(candidate, points, 160.0):
			continue
		points.append(candidate)

	return points

func _too_close(candidate: Vector2, points: Array, distance: float) -> bool:
	for point in points:
		if candidate.distance_to(point) < distance:
			return true
	return false
