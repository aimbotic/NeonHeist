class_name SaveSystem
extends Node

const SAVE_PATH := "user://dust_heist_save.json"

var data := {
	"credits": 0,
	"runs": 0,
	"unlocks": ["ghost"],
	"quest_progress": {},
	"quest_completed": [],
	"unlocked_abilities": ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"],
	"equipped_abilities": ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"],
	"unlocked_blades": ["saber"],
	"equipped_blade": "saber",
	"unlocked_guns": ["revolver"],
	"equipped_gun": "revolver",
	"upgrade_tokens": 0,
	"purchased_upgrades": [],
	"boss_token_claimed": [],
}

func _ready() -> void:
	load_game()

func add_credits(amount: int) -> void:
	data["credits"] += amount
	data["runs"] += 1
	save_game()

func add_upgrade_tokens(amount: int) -> int:
	_ensure_defaults()
	data["upgrade_tokens"] = maxi(0, int(data.get("upgrade_tokens", 0)) + amount)
	save_game()
	return int(data["upgrade_tokens"])

func spend_upgrade_tokens(amount: int) -> bool:
	_ensure_defaults()
	var cost := maxi(0, amount)
	if int(data.get("upgrade_tokens", 0)) < cost:
		return false
	data["upgrade_tokens"] = int(data.get("upgrade_tokens", 0)) - cost
	save_game()
	return true

func purchase_upgrade(upgrade_id: String, cost: int) -> bool:
	_ensure_defaults()
	var purchased: Array = data["purchased_upgrades"]
	if purchased.has(upgrade_id):
		return false
	if not spend_upgrade_tokens(cost):
		return false
	purchased.append(upgrade_id)
	data["purchased_upgrades"] = purchased
	save_game()
	return true

func claim_boss_token(boss_id: String) -> bool:
	_ensure_defaults()
	var claimed: Array = data["boss_token_claimed"]
	if claimed.has(boss_id):
		return false
	claimed.append(boss_id)
	data["boss_token_claimed"] = claimed
	save_game()
	return true

func add_quest_progress(quest_id: String, amount: int, target: int) -> int:
	_ensure_defaults()
	var progress: Dictionary = data["quest_progress"]
	progress[quest_id] = mini(int(progress.get(quest_id, 0)) + amount, target)
	data["quest_progress"] = progress
	save_game()
	return int(progress[quest_id])

func set_quest_progress(quest_id: String, value: int, target: int) -> int:
	_ensure_defaults()
	var progress: Dictionary = data["quest_progress"]
	progress[quest_id] = mini(maxi(value, int(progress.get(quest_id, 0))), target)
	data["quest_progress"] = progress
	save_game()
	return int(progress[quest_id])

func complete_quest(quest_id: String) -> void:
	_ensure_defaults()
	var completed: Array = data["quest_completed"]
	if not completed.has(quest_id):
		completed.append(quest_id)
		data["quest_completed"] = completed
		save_game()

func unlock_ability(program_id: String) -> void:
	_ensure_defaults()
	var unlocked: Array = data["unlocked_abilities"]
	if not unlocked.has(program_id):
		unlocked.append(program_id)
	data["unlocked_abilities"] = unlocked
	save_game()

func unlock_blade(blade_id: String) -> void:
	_ensure_defaults()
	var unlocked: Array = data["unlocked_blades"]
	if not unlocked.has(blade_id):
		unlocked.append(blade_id)
	data["unlocked_blades"] = unlocked
	save_game()

func unlock_gun(gun_id: String) -> void:
	_ensure_defaults()
	var unlocked: Array = data["unlocked_guns"]
	if not unlocked.has(gun_id):
		unlocked.append(gun_id)
	data["unlocked_guns"] = unlocked
	save_game()

func set_equipped_abilities(equipped_ids: Array[String]) -> void:
	data["equipped_abilities"] = equipped_ids.duplicate()
	save_game()

func set_equipped_blade(blade_id: String) -> void:
	data["equipped_blade"] = blade_id
	save_game()

func set_equipped_gun(gun_id: String) -> void:
	data["equipped_gun"] = gun_id
	save_game()

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		data = parsed
	_ensure_defaults()

func _ensure_defaults() -> void:
	var defaults := {
		"credits": 0,
		"runs": 0,
		"unlocks": ["ghost"],
		"quest_progress": {},
		"quest_completed": [],
		"unlocked_abilities": ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"],
		"equipped_abilities": ["deadeye", "ricochet_shot", "dust_veil", "quickdraw"],
		"unlocked_blades": ["saber"],
		"equipped_blade": "saber",
		"unlocked_guns": ["revolver"],
		"equipped_gun": "revolver",
		"upgrade_tokens": 0,
		"purchased_upgrades": [],
		"boss_token_claimed": [],
	}
	for key in defaults.keys():
		if not data.has(key):
			data[key] = defaults[key]
