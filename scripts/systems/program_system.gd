class_name ProgramSystem
extends Node

var available_programs := {
	"deadeye": {"name": "Deadeye", "cooldown": 7.5},
	"ricochet_shot": {"name": "Ricochet Shot", "cooldown": 4.5},
	"dust_veil": {"name": "Dust Veil", "cooldown": 8.0},
	"quickdraw": {"name": "Quickdraw", "cooldown": 5.5},
}

var unlocked := {}
var cooldowns := {}
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func _physics_process(delta: float) -> void:
	for program_id in cooldowns.keys():
		cooldowns[program_id] = max(0.0, cooldowns[program_id] - delta)

func reset() -> void:
	unlocked = {
		"deadeye": true,
		"ricochet_shot": true,
		"dust_veil": true,
		"quickdraw": true,
	}
	cooldowns.clear()

func can_cast(program_id: String) -> bool:
	return unlocked.has(program_id) and cooldowns.get(program_id, 0.0) <= 0.0

func cast(program_id: String, origin: Vector2, direction: Vector2, enemies: Array[Node2D]) -> Dictionary:
	var data: Dictionary = available_programs.get(program_id, {})
	cooldowns[program_id] = data.get("cooldown", 3.0)
	var aim := direction.normalized()

	match program_id:
		"deadeye":
			return _skillshot_program(origin, aim, enemies, 760.0, 26.0, 70.0, 0.16, Color(0.9, 0.68, 0.32), "deadeye")
		"ricochet_shot":
			return _area_program(origin, enemies, 410.0, 38.0, 0.22, Color(0.95, 0.36, 0.1), 300.0, "ricochet")
		"dust_veil":
			return _area_program(origin, enemies, 210.0, 8.0, 0.06, Color(0.78, 0.58, 0.34), 0.0, "veil", 1.25)
		"quickdraw":
			return _skillshot_program(origin, aim, enemies, 420.0, 34.0, 60.0, 0.18, Color(1.0, 0.86, 0.46), "quickdraw")
		_:
			return _area_program(origin, enemies, 180.0, 24.0, 0.14, Color(1.0, 0.48, 0.08), 0.0, "")

func award_random_program() -> String:
	var locked: Array[String] = []
	for program_id in available_programs.keys():
		if not unlocked.has(program_id):
			locked.append(program_id)

	if locked.is_empty():
		return ""

	var pick := locked[_rng.randi_range(0, locked.size() - 1)]
	unlocked[pick] = true
	return pick

func get_equipped_summary() -> Array[Dictionary]:
	var summary: Array[Dictionary] = []
	for program_id in unlocked.keys():
		var data: Dictionary = available_programs[program_id]
		summary.append({
			"id": program_id,
			"name": data["name"],
			"cooldown": cooldowns.get(program_id, 0.0),
			"max_cooldown": data["cooldown"],
		})
	return summary

func _area_program(origin: Vector2, enemies: Array[Node2D], radius: float, damage: float, heat: float, color: Color, chain_radius: float, effect: String, veil_duration: float = 0.0) -> Dictionary:
	var hit_enemies: Array[Node2D] = []
	for enemy in enemies:
		if is_instance_valid(enemy) and origin.distance_to(enemy.global_position) <= radius:
			hit_enemies.append(enemy)

	return {
		"hit_enemies": hit_enemies,
		"damage": damage,
		"heat": heat,
		"color": color,
		"chain_radius": chain_radius,
		"effect": effect,
		"veil_duration": veil_duration,
		"shot_from": origin,
		"shot_to": origin,
	}

func _skillshot_program(origin: Vector2, direction: Vector2, enemies: Array[Node2D], shot_range: float, width: float, damage: float, heat: float, color: Color, effect: String) -> Dictionary:
	var hit_enemies: Array[Node2D] = []
	var shot_to := origin + direction * shot_range
	var best_distance := INF
	var best_enemy: Node2D = null
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var to_enemy: Vector2 = enemy.global_position - origin
		var forward_distance := to_enemy.dot(direction)
		if forward_distance < 0.0 or forward_distance > shot_range:
			continue
		var closest := origin + direction * forward_distance
		if enemy.global_position.distance_to(closest) > width:
			continue
		if forward_distance < best_distance:
			best_distance = forward_distance
			best_enemy = enemy

	if best_enemy != null:
		hit_enemies.append(best_enemy)
		shot_to = origin + direction * best_distance

	return {
		"hit_enemies": hit_enemies,
		"damage": damage,
		"heat": heat,
		"color": color,
		"chain_radius": 0.0,
		"effect": effect,
		"veil_duration": 0.0,
		"shot_from": origin,
		"shot_to": shot_to,
	}
