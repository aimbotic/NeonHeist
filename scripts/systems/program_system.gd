class_name ProgramSystem
extends Node

var available_programs := {
	"deadeye": {"name": "Deadeye", "cooldown": 7.5},
	"ricochet_shot": {"name": "Ricochet Shot", "cooldown": 4.5},
	"dust_veil": {"name": "Dust Veil", "cooldown": 8.0},
	"quickdraw": {"name": "Quickdraw", "cooldown": 5.5},
	"duelist_lunge": {"name": "Duelist Lunge", "cooldown": 6.0},
	"fan_hammer": {"name": "Fan Hammer", "cooldown": 6.5},
	"ghost_step": {"name": "Ghost Step", "cooldown": 9.0},
}

var gun_profiles := {
	"revolver": {"damage": 1.0, "range": 1.0, "width": 1.0, "cooldown": 1.0, "radius": 1.0, "chain": 1.0},
	"long_rifle": {"damage": 1.18, "range": 1.25, "width": 0.85, "cooldown": 1.08, "radius": 0.95, "chain": 1.0},
	"sawed_off": {"damage": 1.12, "range": 0.78, "width": 1.45, "cooldown": 0.95, "radius": 1.18, "chain": 0.85},
	"pepperbox": {"damage": 0.9, "range": 0.94, "width": 1.1, "cooldown": 0.72, "radius": 1.0, "chain": 1.0},
	"golden_revolver": {"damage": 1.25, "range": 1.12, "width": 1.12, "cooldown": 0.86, "radius": 1.08, "chain": 1.2},
}

var unlocked := {}
var equipped: Array[String] = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]
var equipped_gun := "revolver"
var cooldowns := {}
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func _physics_process(delta: float) -> void:
	for program_id in cooldowns.keys():
		cooldowns[program_id] = max(0.0, cooldowns[program_id] - delta)

func reset() -> void:
	cooldowns.clear()

func can_cast(program_id: String) -> bool:
	return equipped.has(program_id) and unlocked.has(program_id) and cooldowns.get(program_id, 0.0) <= 0.0

func cast(program_id: String, origin: Vector2, direction: Vector2, enemies: Array[Node2D]) -> Dictionary:
	var data: Dictionary = available_programs.get(program_id, {})
	var profile := _gun_profile()
	var cooldown_scale: float = profile.get("cooldown", 1.0) if _is_gun_program(program_id) else 1.0
	cooldowns[program_id] = data.get("cooldown", 3.0) * cooldown_scale
	var aim := direction.normalized()

	match program_id:
		"deadeye":
			return _skillshot_program(origin, aim, enemies, 760.0 * profile.get("range", 1.0), 26.0 * profile.get("width", 1.0), 70.0 * profile.get("damage", 1.0), 0.16, Color(0.9, 0.68, 0.32), "deadeye")
		"ricochet_shot":
			return _area_program(origin, enemies, 410.0 * profile.get("radius", 1.0), 38.0 * profile.get("damage", 1.0), 0.22, Color(0.95, 0.36, 0.1), 300.0 * profile.get("chain", 1.0), "ricochet")
		"dust_veil":
			return _area_program(origin, enemies, 210.0, 8.0, 0.06, Color(0.78, 0.58, 0.34), 0.0, "veil", 1.25)
		"quickdraw":
			return _skillshot_program(origin, aim, enemies, 420.0 * profile.get("range", 1.0), 34.0 * profile.get("width", 1.0), 60.0 * profile.get("damage", 1.0), 0.18, Color(1.0, 0.86, 0.46), "quickdraw")
		"duelist_lunge":
			return _skillshot_program(origin, aim, enemies, 500.0, 38.0, 72.0, 0.2, Color(0.95, 0.12, 0.04), "duelist_lunge")
		"fan_hammer":
			return _area_program(origin, enemies, 290.0 * profile.get("radius", 1.0), 52.0 * profile.get("damage", 1.0), 0.24, Color(1.0, 0.42, 0.12), 0.0, "fan_hammer")
		"ghost_step":
			return _area_program(origin, enemies, 230.0, 18.0, 0.08, Color(0.86, 0.76, 0.58), 0.0, "veil", 1.85)
		_:
			return _area_program(origin, enemies, 180.0, 24.0, 0.14, Color(1.0, 0.48, 0.08), 0.0, "")

func unlock_starter_loadout() -> void:
	for program_id in ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]:
		unlocked[program_id] = true
	equipped = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]

func load_progress(unlocked_ids: Array, equipped_ids: Array) -> void:
	unlocked.clear()
	for program_id in unlocked_ids:
		if available_programs.has(str(program_id)):
			unlocked[str(program_id)] = true
	set_equipped(_to_string_array(equipped_ids))
	if equipped.is_empty():
		equipped = ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"]

func award_boss_reward() -> String:
	var boss_rewards := ["duelist_lunge"]
	for program_id in boss_rewards:
		if not unlocked.has(program_id):
			unlocked[program_id] = true
			return program_id
	return ""

func unlock_program(program_id: String) -> bool:
	if not available_programs.has(program_id) or unlocked.has(program_id):
		return false
	unlocked[program_id] = true
	return true

func set_equipped(new_equipped: Array[String]) -> void:
	var next: Array[String] = []
	for program_id in new_equipped:
		if unlocked.has(program_id) and available_programs.has(program_id) and not next.has(program_id):
			next.append(program_id)
		if next.size() >= 4:
			break
	equipped = next

func set_equipped_gun(gun_id: String) -> void:
	if gun_profiles.has(gun_id):
		equipped_gun = gun_id

func get_equipped_id(slot: int) -> String:
	if slot < 0 or slot >= equipped.size():
		return ""
	return equipped[slot]

func get_program_name(program_id: String) -> String:
	return available_programs.get(program_id, {}).get("name", "")

func get_unlocked_ids() -> Array[String]:
	var ids: Array[String] = []
	for program_id in available_programs.keys():
		if unlocked.has(program_id):
			ids.append(program_id)
	return ids

func _to_string_array(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(str(value))
	return result

func get_equipped_summary() -> Array[Dictionary]:
	var summary: Array[Dictionary] = []
	for program_id in equipped:
		if not unlocked.has(program_id):
			continue
		var data: Dictionary = available_programs[program_id]
		summary.append({
			"id": program_id,
			"name": data["name"],
			"cooldown": cooldowns.get(program_id, 0.0),
			"max_cooldown": data["cooldown"],
		})
	return summary

func _is_gun_program(program_id: String) -> bool:
	return ["deadeye", "ricochet_shot", "quickdraw", "fan_hammer"].has(program_id)

func _gun_profile() -> Dictionary:
	return gun_profiles.get(equipped_gun, gun_profiles["revolver"])

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
