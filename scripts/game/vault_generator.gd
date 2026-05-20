class_name VaultGenerator
extends RefCounted

const ROOM_SIZE := Vector2(360.0, 240.0)
const ROOM_GAP := Vector2(520.0, 360.0)

var _rng := RandomNumberGenerator.new()

func generate(seed_value: int, biome_id: String = "financial_mainframe") -> Dictionary:
	_rng.seed = seed_value
	var rooms: Array[Dictionary] = []
	var occupied := {}
	var cursor := Vector2i.ZERO
	var target_count := 14

	for i in range(target_count):
		if not occupied.has(cursor):
			occupied[cursor] = true
			rooms.append(_make_room(cursor, i))

		var direction := _pick_direction(i)
		cursor += direction

		if occupied.has(cursor) and _rng.randf() < 0.55:
			cursor += _pick_direction(i + 3)

	var corridors := _connect_rooms(rooms)
	var spawn: Vector2 = rooms[0]["center"]
	var extraction: Vector2 = rooms[rooms.size() - 1]["center"]
	var hack_nodes := _pick_room_points(rooms, 5, 88.0)
	var hazards := _pick_room_points(rooms, 9, 120.0)
	var enemy_spawns := _pick_room_points(rooms, 12, 96.0)

	return {
		"seed": seed_value,
		"biome": biome_id,
		"rooms": rooms,
		"corridors": corridors,
		"spawn": spawn,
		"extraction": extraction,
		"hack_nodes": hack_nodes,
		"hazards": hazards,
		"enemy_spawns": enemy_spawns,
	}

func _make_room(grid: Vector2i, index: int) -> Dictionary:
	var center := Vector2(grid) * ROOM_GAP
	var size := ROOM_SIZE + Vector2(_rng.randi_range(-56, 96), _rng.randi_range(-36, 64))
	return {
		"id": index,
		"grid": grid,
		"center": center,
		"rect": Rect2(center - size * 0.5, size),
	}

func _pick_direction(salt: int) -> Vector2i:
	var directions: Array[Vector2i] = [
		Vector2i.RIGHT,
		Vector2i.LEFT,
		Vector2i.DOWN,
		Vector2i.UP,
	]
	var weighted_index := _rng.randi_range(0, directions.size() - 1)
	if salt % 4 == 0:
		weighted_index = 0
	elif salt % 5 == 0:
		weighted_index = 2
	return directions[weighted_index]

func _connect_rooms(rooms: Array[Dictionary]) -> Array[Dictionary]:
	var corridors: Array[Dictionary] = []
	for i in range(rooms.size() - 1):
		var from_room := rooms[i]
		var to_room := rooms[i + 1]
		corridors.append({
			"from": from_room["center"],
			"to": to_room["center"],
		})
	return corridors

func _pick_room_points(rooms: Array[Dictionary], count: int, margin: float) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var candidates := rooms.duplicate()
	for i in range(candidates.size() - 1, 0, -1):
		var swap_index := _rng.randi_range(0, i)
		var temp = candidates[i]
		candidates[i] = candidates[swap_index]
		candidates[swap_index] = temp

	for room in candidates:
		if points.size() >= count:
			break
		if room["id"] == 0:
			continue

		var rect: Rect2 = room["rect"].grow(-margin)
		if rect.size.x <= 20.0 or rect.size.y <= 20.0:
			continue

		points.append(Vector2(
			_rng.randf_range(rect.position.x, rect.position.x + rect.size.x),
			_rng.randf_range(rect.position.y, rect.position.y + rect.size.y)
		))

	return points
