class_name ProgramSystem
extends Node

var available_programs := {
	"emp_blast": {"name": "EMP Blast", "cooldown": 2.8},
	"chain_lightning": {"name": "Chain Lightning", "cooldown": 4.5},
	"virus_pulse": {"name": "Virus Pulse", "cooldown": 5.0},
	"firewall": {"name": "Firewall", "cooldown": 8.0},
	"cloak": {"name": "Cloak", "cooldown": 10.0},
	"mirror_shield": {"name": "Mirror Shield", "cooldown": 9.0},
	"teleport": {"name": "Teleport", "cooldown": 6.0},
	"time_slow": {"name": "Time Slow", "cooldown": 7.5},
	"path_reveal": {"name": "Path Reveal", "cooldown": 3.0},
	"chain_node": {"name": "Chain Node", "cooldown": 6.0},
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
		"emp_blast": true,
		"chain_lightning": true,
		"time_slow": true,
	}
	cooldowns.clear()

func can_cast(program_id: String) -> bool:
	return unlocked.has(program_id) and cooldowns.get(program_id, 0.0) <= 0.0

func cast(program_id: String, origin: Vector2, enemies: Array[Node2D]) -> Dictionary:
	var data: Dictionary = available_programs.get(program_id, {})
	cooldowns[program_id] = data.get("cooldown", 3.0)

	match program_id:
		"emp_blast":
			return _area_program(origin, enemies, 230.0, 45.0, 0.18, Color(0.2, 1.0, 1.0), 0.0)
		"chain_lightning":
			return _area_program(origin, enemies, 390.0, 34.0, 0.28, Color(1.0, 0.18, 0.82), 260.0)
		"time_slow":
			for enemy in enemies:
				if is_instance_valid(enemy) and origin.distance_to(enemy.global_position) <= 460.0:
					enemy.apply_slow(2.4)
			return _area_program(origin, enemies, 220.0, 14.0, 0.1, Color(0.55, 0.38, 1.0), 0.0)
		_:
			return _area_program(origin, enemies, 180.0, 24.0, 0.14, Color(1.0, 0.48, 0.08), 0.0)

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

func _area_program(origin: Vector2, enemies: Array[Node2D], radius: float, damage: float, heat: float, color: Color, chain_radius: float) -> Dictionary:
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
	}
