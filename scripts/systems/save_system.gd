class_name SaveSystem
extends Node

const SAVE_PATH := "user://neon_heist_save.json"

var data := {
	"credits": 0,
	"runs": 0,
	"unlocks": ["ghost"],
}

func _ready() -> void:
	load_game()

func add_credits(amount: int) -> void:
	data["credits"] += amount
	data["runs"] += 1
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
