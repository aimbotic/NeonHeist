extends Node2D

const PlayerScene := preload("res://scripts/player/player.gd")
const DroneScene := preload("res://scripts/enemies/drone.gd")
const HunterScene := preload("res://scripts/enemies/hunter.gd")
const TurretScene := preload("res://scripts/enemies/turret.gd")
const ShotgunBruteScene := preload("res://scripts/enemies/shotgun_brute.gd")
const DuelistScene := preload("res://scripts/enemies/duelist.gd")
const DirectorScene := preload("res://scripts/game/game_director.gd")
const ProgramSystemScene := preload("res://scripts/systems/program_system.gd")
const SaveSystemScene := preload("res://scripts/systems/save_system.gd")
const VfxLayerScene := preload("res://scripts/systems/vfx_layer.gd")
const HudScene := preload("res://scripts/ui/hud.gd")
const VaultGeneratorScene := preload("res://scripts/game/vault_generator.gd")

class StaticBackdropCache extends Node2D:
	var owner_main: Node2D

	func _draw() -> void:
		if owner_main == null or owner_main.vault_data.is_empty():
			return
		owner_main._draw_dark_western_backdrop()

const QUEST_DEFINITIONS := [
	{
		"id": "blood_noon",
		"name": "BLOOD NOON",
		"description": "Reach wave 6 in a single run.",
		"type": "wave",
		"target": 6,
		"reward_type": "ability",
		"reward_id": "fan_hammer",
		"reward": "Fan Hammer ability",
	},
	{
		"id": "three_black_sashes",
		"name": "THREE BLACK SASHES",
		"description": "Defeat 3 duelist bosses across runs.",
		"type": "boss",
		"target": 3,
		"reward_type": "ability",
		"reward_id": "ghost_step",
		"reward": "Ghost Step ability",
	},
	{
		"id": "graveyard_shift",
		"name": "GRAVEYARD SHIFT",
		"description": "Kill 100 enemies across runs.",
		"type": "kill",
		"target": 100,
		"reward_type": "blade",
		"reward_id": "grave_saber",
		"reward": "Grave Saber weapon",
	},
]

var vault_data: Dictionary
var player
var director
var program_system
var save_system
var vfx_layer
var hud
var camera: Camera2D
var backdrop_cache := StaticBackdropCache.new()
var enemy_root := Node2D.new()
var enemies: Array[Node2D] = []
var run_complete := false
var current_wave := 0
var wave_in_progress := false
var wave_break_timer := 0.0
var enemies_defeated := 0
var duelists_defeated := 0
var menu_open := true
var unlocked_blades: Array[String] = ["saber"]
var equipped_blade := "saber"

func _ready() -> void:
	_configure_input()
	RenderingServer.set_default_clear_color(Color(0.025, 0.018, 0.014, 1.0))

	save_system = SaveSystemScene.new()
	add_child(save_system)

	director = DirectorScene.new()
	add_child(director)
	director.alert_changed.connect(_on_alert_changed)
	director.lockdown_started.connect(_on_lockdown_started)

	program_system = ProgramSystemScene.new()
	add_child(program_system)
	program_system.unlock_starter_loadout()
	program_system.load_progress(save_system.data["unlocked_abilities"], save_system.data["equipped_abilities"])
	unlocked_blades = _to_string_array(save_system.data["unlocked_blades"])
	equipped_blade = str(save_system.data["equipped_blade"])

	vfx_layer = VfxLayerScene.new()
	add_child(vfx_layer)

	backdrop_cache.owner_main = self
	backdrop_cache.z_index = -100
	add_child(backdrop_cache)

	hud = HudScene.new()
	add_child(hud)
	hud.play_requested.connect(_on_menu_play_requested)
	hud.ability_loadout_changed.connect(_on_ability_loadout_changed)
	hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
	_refresh_quest_screen()

	add_child(enemy_root)
	hud.show_main_menu()

func _physics_process(delta: float) -> void:
	if menu_open or run_complete:
		return

	var heat: float = max(0.0, 1.0 - player.health / player.max_health)
	director.tick(delta, heat)
	_update_camera(delta)
	_update_wave(delta)
	hud.update_run(player, director, program_system, current_wave, _living_enemy_count())

func _draw() -> void:
	if vault_data.is_empty():
		return

	var arena: Rect2 = vault_data["arena"]
	draw_rect(arena, Color(0.78, 0.55, 0.24, 0.98), true)
	draw_rect(arena.grow(-14.0), Color(1.0, 0.78, 0.36, 0.22), false, 3.0)
	draw_rect(arena, Color(0.43, 0.24, 0.1, 0.72), false, 8.0)
	draw_rect(arena.grow(-42.0), Color(1.0, 0.86, 0.48, 0.2), false, 2.0)

	_draw_sand_detail(arena)

func _draw_dark_western_backdrop() -> void:
	var bounds := _get_vault_bounds().grow(520.0)
	draw_rect(bounds, Color(0.028, 0.019, 0.014, 1.0), true)

	var horizon_y := bounds.position.y + bounds.size.y * 0.22
	draw_rect(Rect2(bounds.position, Vector2(bounds.size.x, bounds.size.y * 0.24)), Color(0.008, 0.006, 0.006, 1.0), true)
	draw_line(Vector2(bounds.position.x, horizon_y), Vector2(bounds.end.x, horizon_y), Color(0.62, 0.28, 0.12, 0.42), 4.0)

	for i in range(7):
		var t := float(i) / 6.0
		var y := lerpf(horizon_y + 50.0, bounds.end.y - 80.0, t)
		var alpha := lerpf(0.12, 0.035, t)
		draw_line(Vector2(bounds.position.x, y), Vector2(bounds.end.x, y), Color(0.62, 0.34, 0.16, alpha), 2.0)

	for i in range(12):
		var x := bounds.position.x + i * 220.0
		draw_line(Vector2(x, horizon_y), Vector2(x - 260.0, bounds.end.y), Color(0.52, 0.25, 0.1, 0.055), 2.0)
		draw_line(Vector2(x, horizon_y), Vector2(x + 260.0, bounds.end.y), Color(0.52, 0.25, 0.1, 0.055), 2.0)

	for i in range(9):
		var dune_y := bounds.position.y + bounds.size.y * (0.36 + i * 0.055)
		var start := Vector2(bounds.position.x - 80.0, dune_y)
		var end := Vector2(bounds.end.x + 80.0, dune_y + sin(i * 1.7) * 52.0)
		draw_line(start, end, Color(0.33, 0.18, 0.08, 0.16), 10.0)

	for i in range(10):
		var mesa_x := bounds.position.x + 160.0 + i * 310.0
		var mesa_w := 90.0 + float((i * 37) % 70)
		var mesa_h := 55.0 + float((i * 23) % 80)
		var mesa_rect := Rect2(Vector2(mesa_x, horizon_y - mesa_h), Vector2(mesa_w, mesa_h))
		draw_rect(mesa_rect, Color(0.055, 0.03, 0.022, 0.9), true)
		draw_rect(mesa_rect, Color(0.48, 0.22, 0.09, 0.28), false, 2.0)

	_draw_old_west_perimeter(bounds, _get_vault_bounds())

func _draw_old_west_perimeter(bounds: Rect2, arena: Rect2) -> void:
	var street_color := Color(0.34, 0.19, 0.08, 0.56)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 260.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.end.y + 30.0), Vector2(bounds.size.x, 230.0)), street_color, true)
	draw_rect(Rect2(Vector2(bounds.position.x, arena.position.y - 30.0), Vector2(arena.position.x - bounds.position.x - 30.0, arena.size.y + 60.0)), street_color, true)
	draw_rect(Rect2(Vector2(arena.end.x + 30.0, arena.position.y - 30.0), Vector2(bounds.end.x - arena.end.x - 30.0, arena.size.y + 60.0)), street_color, true)

	var courtyard_shadow := arena.grow(34.0)
	draw_rect(courtyard_shadow, Color(0.08, 0.035, 0.018, 0.28), false, 16.0)

	var top_y := arena.position.y - 248.0
	var bottom_y := arena.end.y + 58.0
	var left_x := arena.position.x - 266.0
	var right_x := arena.end.x + 34.0

	for i in range(7):
		var x := arena.position.x - 130.0 + i * 310.0
		var w := 286.0 + float((i * 37) % 42)
		var h := 190.0 + float((i * 19) % 28)
		_draw_saloon_front(Vector2(x, top_y + float((i % 2) * 10)), Vector2(w, h), i)
		_draw_saloon_front(Vector2(x + 24.0, bottom_y + float(((i + 1) % 2) * 10)), Vector2(w - 18.0, h + 10.0), i + 9)

	for i in range(4):
		var y := arena.position.y - 24.0 + i * 330.0
		_draw_side_storefront(Vector2(left_x, y), Vector2(236.0, 286.0), -1.0, i)
		_draw_side_storefront(Vector2(right_x, y + 18.0), Vector2(236.0, 270.0), 1.0, i + 5)

	for i in range(26):
		var angle := TAU * float(i) / 26.0
		var radius := Vector2(arena.size.x * 0.62, arena.size.y * 0.62)
		var center := arena.get_center()
		var pos := center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
		if arena.grow(72.0).has_point(pos):
			continue
		_draw_western_prop(pos, i)

func _draw_saloon_front(position: Vector2, size: Vector2, index: int) -> void:
	var body := Rect2(position, size)
	var roof_height := 34.0
	var porch_height := 26.0
	var plank_color := Color(0.16 + float(index % 3) * 0.025, 0.075, 0.032, 0.96)
	var trim_color := Color(0.55, 0.31, 0.15, 0.82)
	var shadow_color := Color(0.035, 0.018, 0.012, 0.96)

	draw_rect(body, plank_color, true)
	draw_rect(Rect2(position + Vector2(-8.0, -roof_height), Vector2(size.x + 16.0, roof_height)), Color(0.075, 0.035, 0.02, 0.98), true)
	draw_rect(body, Color(0.48, 0.25, 0.1, 0.72), false, 3.0)

	for plank in range(6):
		var x := position.x + 22.0 + plank * (size.x - 44.0) / 5.0
		draw_line(Vector2(x, position.y), Vector2(x, position.y + size.y), Color(0.08, 0.035, 0.018, 0.42), 2.0)

	var sign_rect := Rect2(position + Vector2(size.x * 0.26, 18.0), Vector2(size.x * 0.48, 32.0))
	draw_rect(sign_rect, Color(0.28, 0.12, 0.05, 0.98), true)
	draw_rect(sign_rect, trim_color, false, 2.0)
	_draw_saloon_sign_marks(sign_rect, trim_color)

	var door := Rect2(position + Vector2(size.x * 0.42, size.y * 0.47), Vector2(size.x * 0.16, size.y * 0.46))
	draw_rect(door, shadow_color, true)
	draw_line(door.position + Vector2(door.size.x * 0.5, 8.0), door.position + Vector2(door.size.x * 0.5, door.size.y - 4.0), trim_color, 2.0)
	draw_circle(door.position + Vector2(door.size.x * 0.38, door.size.y * 0.52), 2.0, trim_color)
	draw_circle(door.position + Vector2(door.size.x * 0.62, door.size.y * 0.52), 2.0, trim_color)

	for side_index in range(2):
		var wx := position.x + size.x * (0.17 if side_index == 0 else 0.73)
		var window := Rect2(Vector2(wx, position.y + size.y * 0.48), Vector2(size.x * 0.15, size.y * 0.2))
		draw_rect(window, Color(0.02, 0.012, 0.009, 0.96), true)
		draw_rect(window, trim_color, false, 2.0)
		draw_line(window.position + Vector2(0.0, window.size.y * 0.5), window.position + Vector2(window.size.x, window.size.y * 0.5), Color(0.82, 0.55, 0.24, 0.35), 2.0)
		draw_line(window.position + Vector2(window.size.x * 0.5, 0.0), window.position + Vector2(window.size.x * 0.5, window.size.y), Color(0.82, 0.55, 0.24, 0.35), 2.0)

	var porch := Rect2(position + Vector2(-16.0, size.y - porch_height), Vector2(size.x + 32.0, porch_height))
	draw_rect(porch, Color(0.11, 0.052, 0.024, 0.95), true)
	for post in range(4):
		var px := porch.position.x + 20.0 + post * (porch.size.x - 40.0) / 3.0
		draw_line(Vector2(px, porch.position.y), Vector2(px, position.y + size.y + 18.0), trim_color, 5.0)
	draw_line(porch.position, porch.position + Vector2(porch.size.x, 0.0), Color(0.76, 0.45, 0.2, 0.5), 3.0)

func _draw_side_storefront(position: Vector2, size: Vector2, direction: float, index: int) -> void:
	var body := Rect2(position, size)
	var front_x := position.x if direction < 0.0 else position.x + size.x
	var fade_x := position.x + size.x if direction < 0.0 else position.x
	draw_rect(body, Color(0.11, 0.052, 0.026, 0.94), true)
	draw_rect(body, Color(0.42, 0.22, 0.1, 0.68), false, 3.0)
	draw_line(Vector2(front_x, position.y - 18.0), Vector2(front_x, position.y + size.y + 16.0), Color(0.62, 0.35, 0.16, 0.78), 7.0)
	draw_line(Vector2(fade_x, position.y), Vector2(fade_x, position.y + size.y), Color(0.02, 0.012, 0.009, 0.5), 14.0)
	for floor_index in range(3):
		var y := position.y + 42.0 + floor_index * 58.0
		draw_line(Vector2(position.x + 14.0, y), Vector2(position.x + size.x - 14.0, y + sin(index + floor_index) * 5.0), Color(0.58, 0.32, 0.14, 0.42), 4.0)
	var hanging_sign := Rect2(Vector2(front_x - direction * 72.0 - 36.0, position.y + 36.0), Vector2(72.0, 34.0))
	draw_line(Vector2(front_x, position.y + 30.0), hanging_sign.position + Vector2(36.0, 0.0), Color(0.42, 0.22, 0.1, 0.88), 3.0)
	draw_rect(hanging_sign, Color(0.23, 0.1, 0.042, 0.98), true)
	draw_rect(hanging_sign, Color(0.75, 0.45, 0.2, 0.72), false, 2.0)
	_draw_saloon_sign_marks(hanging_sign, Color(0.75, 0.45, 0.2, 0.62))

func _draw_saloon_sign_marks(sign_rect: Rect2, color: Color) -> void:
	var y := sign_rect.position.y + sign_rect.size.y * 0.55
	for i in range(5):
		var x := sign_rect.position.x + 12.0 + i * (sign_rect.size.x - 24.0) / 4.0
		draw_line(Vector2(x - 5.0, y), Vector2(x + 5.0, y), color, 3.0)
		draw_line(Vector2(x, y - 7.0), Vector2(x, y + 7.0), color, 2.0)

func _draw_western_prop(position: Vector2, index: int) -> void:
	match index % 5:
		0:
			draw_rect(Rect2(position + Vector2(-12.0, -12.0), Vector2(24.0, 24.0)), Color(0.12, 0.06, 0.03, 0.92), true)
			draw_rect(Rect2(position + Vector2(-12.0, -12.0), Vector2(24.0, 24.0)), Color(0.58, 0.32, 0.14, 0.54), false, 2.0)
			draw_line(position + Vector2(-15.0, 0.0), position + Vector2(15.0, 0.0), Color(0.04, 0.02, 0.01, 0.76), 3.0)
		1:
			draw_circle(position, 18.0, Color(0.11, 0.052, 0.024, 0.9))
			draw_circle(position, 12.0, Color(0.055, 0.026, 0.014, 0.96))
			draw_line(position + Vector2(-18.0, -2.0), position + Vector2(18.0, 2.0), Color(0.72, 0.42, 0.18, 0.5), 3.0)
		2:
			draw_line(position + Vector2(0.0, -24.0), position + Vector2(0.0, 28.0), Color(0.18, 0.08, 0.035, 0.94), 5.0)
			draw_circle(position + Vector2(0.0, -30.0), 8.0, Color(0.82, 0.42, 0.16, 0.36))
			draw_circle(position + Vector2(0.0, -30.0), 4.0, Color(1.0, 0.74, 0.32, 0.48))
		3:
			var hitch := Rect2(position + Vector2(-30.0, -8.0), Vector2(60.0, 10.0))
			draw_rect(hitch, Color(0.12, 0.055, 0.024, 0.94), true)
			draw_line(position + Vector2(-24.0, -8.0), position + Vector2(-24.0, 18.0), Color(0.2, 0.1, 0.045, 0.9), 4.0)
			draw_line(position + Vector2(24.0, -8.0), position + Vector2(24.0, 18.0), Color(0.2, 0.1, 0.045, 0.9), 4.0)
		_:
			draw_line(position + Vector2(-22.0, -10.0), position + Vector2(22.0, 12.0), Color(0.09, 0.04, 0.018, 0.9), 5.0)
			draw_line(position + Vector2(-18.0, 12.0), position + Vector2(18.0, -10.0), Color(0.09, 0.04, 0.018, 0.9), 5.0)
			draw_circle(position + Vector2(-24.0, 14.0), 6.0, Color(0.04, 0.02, 0.01, 0.9))
			draw_circle(position + Vector2(24.0, 14.0), 6.0, Color(0.04, 0.02, 0.01, 0.9))

func _draw_sand_detail(arena: Rect2) -> void:
	for i in range(16):
		var y := lerpf(arena.position.y + 90.0, arena.end.y - 90.0, float(i) / 15.0)
		var wave := sin(i * 1.8) * 34.0
		var color := Color(1.0, 0.78, 0.38, 0.22) if i % 2 == 0 else Color(0.46, 0.27, 0.11, 0.16)
		draw_line(Vector2(arena.position.x + 70.0, y), Vector2(arena.end.x - 70.0, y + wave), color, 7.0)

	for i in range(72):
		var x := arena.position.x + float((i * 173) % int(arena.size.x - 160.0)) + 80.0
		var y := arena.position.y + float((i * 97) % int(arena.size.y - 160.0)) + 80.0
		var radius := 2.0 + float((i * 11) % 5)
		var tint := Color(0.38, 0.22, 0.09, 0.22) if i % 3 == 0 else Color(1.0, 0.84, 0.48, 0.26)
		draw_circle(Vector2(x, y), radius, tint)

	for i in range(18):
		var x := arena.position.x + float((i * 251) % int(arena.size.x - 220.0)) + 110.0
		var y := arena.position.y + float((i * 149) % int(arena.size.y - 220.0)) + 110.0
		var length := 30.0 + float((i * 17) % 54)
		var angle := -0.2 + sin(i * 2.1) * 0.35
		var start := Vector2(x, y)
		var end := start + Vector2.RIGHT.rotated(angle) * length
		draw_line(start, end, Color(0.38, 0.2, 0.075, 0.22), 3.0)
		draw_line(start + Vector2(0, 5), end + Vector2(0, 5), Color(1.0, 0.82, 0.42, 0.18), 2.0)

	for i in range(10):
		var x := arena.position.x + float((i * 337) % int(arena.size.x - 260.0)) + 130.0
		var y := arena.position.y + float((i * 211) % int(arena.size.y - 260.0)) + 130.0
		var rock := Rect2(Vector2(x, y), Vector2(18.0 + (i % 4) * 7.0, 8.0 + (i % 3) * 5.0))
		draw_rect(rock, Color(0.13, 0.07, 0.04, 0.42), true)
		draw_rect(rock, Color(0.54, 0.31, 0.16, 0.28), false, 1.5)

func _get_vault_bounds() -> Rect2:
	return vault_data["arena"]

func _unhandled_input(event: InputEvent) -> void:
	if menu_open:
		return
	if run_complete:
		if event is InputEventKey and event.pressed:
			menu_open = true
			hud.show_main_menu()
			_clear_run_entities()
			queue_redraw()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_SPACE:
				player.try_dash()
			KEY_J:
				player.try_weapon_attack()
			KEY_1:
				_cast_equipped_program(0)
			KEY_2:
				_cast_equipped_program(1)
			KEY_3:
				_cast_equipped_program(2)
			KEY_4:
				_cast_equipped_program(3)

func _clear_run_entities() -> void:
	for child in enemy_root.get_children():
		child.queue_free()
	enemies.clear()
	if player != null:
		player.queue_free()
		player = null

func _on_menu_play_requested() -> void:
	menu_open = false
	_start_run()

func _start_run() -> void:
	run_complete = false
	current_wave = 0
	wave_in_progress = false
	wave_break_timer = 0.0
	enemies_defeated = 0
	duelists_defeated = 0
	director.reset()
	program_system.reset()

	for child in enemy_root.get_children():
		child.queue_free()
	enemies.clear()

	if player != null:
		player.queue_free()

	var generator: RefCounted = VaultGeneratorScene.new()
	var seed_value := int(Time.get_unix_time_from_system()) + randi()
	vault_data = generator.generate(seed_value)
	backdrop_cache.queue_redraw()

	player = PlayerScene.new()
	add_child(player)
	player.position = vault_data["spawn"]
	player.set_arena_bounds(vault_data["arena"])
	player.apply_weapon_profile(equipped_blade)
	player.dash_used.connect(_on_player_dash)
	player.weapon_slashed.connect(_on_player_weapon_slashed)
	player.player_damaged.connect(_on_player_damaged)
	player.player_parried.connect(_on_player_parried)
	player.player_down.connect(_on_player_down)

	camera = Camera2D.new()
	camera.zoom = Vector2(0.9, 0.9)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	player.add_child(camera)
	camera.make_current()

	hud.show_run_start(vault_data["seed"])
	vfx_layer.burst(vault_data["spawn"], Color(0.72, 0.38, 0.16), 36)
	_start_next_wave()
	queue_redraw()

func _update_wave(delta: float) -> void:
	enemies = enemies.filter(func(enemy: Node2D) -> bool: return is_instance_valid(enemy))
	if wave_in_progress and enemies.is_empty():
		wave_in_progress = false
		wave_break_timer = 1.15
		director.add_heat(-0.35)

	if not wave_in_progress and wave_break_timer > 0.0:
		wave_break_timer = max(0.0, wave_break_timer - delta)
		if wave_break_timer <= 0.0:
			_start_next_wave()

func _start_next_wave() -> void:
	current_wave += 1
	wave_in_progress = true
	hud.show_wave_banner(current_wave)
	_record_wave_progress(current_wave)
	_spawn_wave(current_wave)
	director.add_heat(0.1 + current_wave * 0.025)

func _spawn_wave(wave: int) -> void:
	var total: int = 4 + wave * 2
	var duelist_count: int = 1 if wave % 3 == 0 else 0
	if duelist_count > 0:
		hud.show_duelist_intro("BLACK SASH DUELIST", Color(0.72, 0.08, 0.04))
		_spawn_enemy(DuelistScene, 0, 1)
		return

	var post_boss_pressure: int = maxi(0, wave - 3) + duelists_defeated * 2
	var brute_count: int = int(mini(maxi(0, wave - 2 + post_boss_pressure) / 2, 7))
	var rifleman_count: int = int(mini(maxi(1, wave + post_boss_pressure) / 2, 8))
	var knife_count: int = maxi(1, total - brute_count - rifleman_count - duelist_count)
	var spawn_total: int = knife_count + rifleman_count + brute_count + duelist_count
	var index := 0

	for i in range(knife_count):
		_spawn_enemy(DroneScene, index, spawn_total)
		index += 1
	for i in range(rifleman_count):
		_spawn_enemy(TurretScene, index, spawn_total)
		index += 1
	for i in range(brute_count):
		_spawn_enemy(ShotgunBruteScene, index, spawn_total)
		index += 1
	for i in range(duelist_count):
		_spawn_enemy(DuelistScene, index, spawn_total)
		index += 1

func _spawn_enemy(enemy_script, index: int, total: int) -> void:
	var enemy: Node2D = enemy_script.new()
	var spawn_position := _get_wave_spawn_position(index, total)
	enemy.position = spawn_position
	enemy_root.add_child(enemy)
	enemy.setup(player, director, vfx_layer)
	enemy.destroyed.connect(_on_enemy_destroyed)
	enemy.set_alert_level(int(min(4, current_wave / 2 + duelists_defeated)))
	if enemy_script == DuelistScene:
		enemy.set_meta("boss", true)
	enemies.append(enemy)

func _get_wave_spawn_position(index: int, total: int) -> Vector2:
	var arena: Rect2 = vault_data["arena"].grow(-90.0)
	var angle: float = TAU * float(index) / maxf(1.0, float(total)) + randf_range(-0.22, 0.22)
	var center: Vector2 = arena.get_center()
	var radius := Vector2(arena.size.x * 0.5, arena.size.y * 0.5)
	var edge_point: Vector2 = center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
	return edge_point.clamp(arena.position, arena.end)

func _update_camera(delta: float) -> void:
	if camera == null:
		return
	var speed_factor: float = clamp(player.velocity.length() / player.max_speed, 0.0, 1.0)
	var target_zoom: float = 0.92 - speed_factor * 0.08 - director.alert_level * 0.025
	camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), delta * 3.0)
	camera.rotation = lerpf(camera.rotation, player.velocity.x * 0.000035, delta * 4.0)

func _cast_program(program_id: String) -> void:
	if not program_system.can_cast(program_id):
		return

	var result: Dictionary = program_system.cast(program_id, player.global_position, _get_mouse_aim_direction(), enemies)
	director.add_heat(result["heat"])
	vfx_layer.skill_flash(player.global_position, result["color"])
	if result.get("shot_from", Vector2.ZERO) != result.get("shot_to", Vector2.ZERO):
		vfx_layer.beam(result["shot_from"], result["shot_to"], result["color"])
	if result.get("effect", "") == "veil":
		player.apply_dust_veil(result.get("veil_duration", 1.0))
	if result.get("effect", "") == "quickdraw":
		player.force_quickdraw()
	if result.get("effect", "") == "duelist_lunge":
		player.force_lunge()
		player.force_quickdraw()

	var hit_count := 0
	for enemy in result["hit_enemies"]:
		if is_instance_valid(enemy):
			enemy.take_damage(result["damage"])
			hit_count += 1

	if result["chain_radius"] > 0.0:
		_trigger_chain_reaction(player.global_position, result["chain_radius"], result["damage"] * 0.7)
		hit_count += 1
	if hit_count > 0:
		hud.flash_hit()

func _trigger_chain_reaction(origin: Vector2, radius: float, damage: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(origin) <= radius:
			enemy.take_damage(damage)
			hud.flash_hit()
	director.add_heat(0.08)

func _on_player_dash() -> void:
	director.add_heat(0.03)
	vfx_layer.trail_pop(player.global_position, Color(0.68, 0.36, 0.16))

func _on_player_weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float) -> void:
	director.add_heat(0.025)
	vfx_layer.trail_pop(origin + direction * 62.0, Color(0.86, 0.58, 0.28))
	var hit_count := 0

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		if _sword_sweep_hits_enemy(origin, direction, slash_range, arc, enemy.global_position):
			enemy.take_damage(damage)
			hit_count += 1
	if hit_count > 0:
		hud.flash_hit()

func _sword_sweep_hits_enemy(origin: Vector2, direction: Vector2, slash_range: float, arc: float, enemy_position: Vector2) -> bool:
	var enemy_radius := 34.0
	var blade_base := 31.0
	var blade_tip := slash_range + 18.0
	var blade_width := 28.0
	var base_angle := direction.angle()
	var samples := 17
	for i in range(samples):
		var t := 0.0 if samples <= 1 else float(i) / float(samples - 1)
		var slash_direction := Vector2.RIGHT.rotated(lerpf(base_angle - arc * 0.5, base_angle + arc * 0.5, t))
		var segment_start := origin + slash_direction * blade_base
		var segment_end := origin + slash_direction * blade_tip
		if _distance_to_segment(enemy_position, segment_start, segment_end) <= enemy_radius + blade_width:
			return true
	return false

func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)
	var t := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * t)

func _on_player_damaged(amount: float) -> void:
	director.add_heat(0.18)
	camera.offset = Vector2(randf_range(-10.0, 10.0), randf_range(-8.0, 8.0))
	var tween := create_tween()
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.16)
	vfx_layer.burst(player.global_position, Color(0.72, 0.08, 0.04), 24)

func _on_player_parried() -> void:
	director.add_heat(-0.08)
	camera.offset = Vector2(randf_range(-6.0, 6.0), randf_range(-5.0, 5.0))
	var tween := create_tween()
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.1)
	vfx_layer.shockwave(player.global_position, Color(1.0, 0.9, 0.5))
	vfx_layer.burst(player.global_position, Color(1.0, 0.82, 0.34), 12)

func _on_player_down() -> void:
	run_complete = true
	save_system.add_credits(enemies_defeated * 5 + max(0, current_wave - 1) * 35)
	hud.show_run_failed()
	vfx_layer.shockwave(player.global_position, Color(0.72, 0.08, 0.04))

func _on_enemy_destroyed(enemy) -> void:
	enemies_defeated += 1
	_record_quest_progress("kill", 1)
	if enemy.has_meta("boss"):
		duelists_defeated += 1
		_record_quest_progress("boss", 1)
		var reward: String = program_system.award_boss_reward()
		var blade_unlocked := false
		if not unlocked_blades.has("black_sash_saber"):
			unlocked_blades.append("black_sash_saber")
			equipped_blade = "black_sash_saber"
			save_system.unlock_blade("black_sash_saber")
			save_system.set_equipped_blade(equipped_blade)
			blade_unlocked = true
			if player != null:
				player.apply_weapon_profile(equipped_blade)
		if reward != "":
			save_system.unlock_ability(reward)
			hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
		if reward != "" and blade_unlocked:
			hud.show_unlock("BLACK SASH SABER + %s UNLOCKED" % program_system.get_program_name(reward).to_upper())
		elif reward != "":
			hud.show_unlock("%s UNLOCKED" % program_system.get_program_name(reward).to_upper())
		elif blade_unlocked:
			hud.show_unlock("BLACK SASH SABER UNLOCKED")
	enemies = enemies.filter(func(other: Node2D) -> bool: return is_instance_valid(other) and other != enemy)

func _cast_equipped_program(slot: int) -> void:
	var program_id: String = program_system.get_equipped_id(slot)
	if program_id == "":
		return
	_cast_program(program_id)

func _get_mouse_aim_direction() -> Vector2:
	var aim: Vector2 = player.global_position.direction_to(get_global_mouse_position())
	if aim.length_squared() <= 0.001:
		return player.get_aim_direction()
	return aim

func _on_ability_loadout_changed(equipped_ids: Array[String]) -> void:
	program_system.set_equipped(equipped_ids)
	save_system.set_equipped_abilities(program_system.equipped)
	hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)

func _record_wave_progress(wave: int) -> void:
	for quest in QUEST_DEFINITIONS:
		if quest["type"] == "wave":
			var progress: int = save_system.set_quest_progress(quest["id"], wave, quest["target"])
			_try_complete_quest(quest, progress)
	_refresh_quest_screen()

func _record_quest_progress(type: String, amount: int) -> void:
	for quest in QUEST_DEFINITIONS:
		if quest["type"] != type:
			continue
		var progress: int = save_system.add_quest_progress(quest["id"], amount, quest["target"])
		_try_complete_quest(quest, progress)
	_refresh_quest_screen()

func _try_complete_quest(quest: Dictionary, progress: int) -> void:
	var completed: Array = save_system.data["quest_completed"]
	if completed.has(quest["id"]) or progress < int(quest["target"]):
		return
	save_system.complete_quest(quest["id"])
	var reward_id: String = quest["reward_id"]
	var reward_name: String = quest["reward"]
	if quest["reward_type"] == "ability":
		if program_system.unlock_program(reward_id):
			save_system.unlock_ability(reward_id)
			hud.set_ability_loadout_data(program_system.get_unlocked_ids(), program_system.equipped)
	elif quest["reward_type"] == "blade":
		if not unlocked_blades.has(reward_id):
			unlocked_blades.append(reward_id)
			equipped_blade = reward_id
			save_system.unlock_blade(reward_id)
			save_system.set_equipped_blade(equipped_blade)
			if player != null:
				player.apply_weapon_profile(equipped_blade)
	hud.show_unlock("%s COMPLETE - %s UNLOCKED" % [str(quest["name"]), reward_name.to_upper()])

func _refresh_quest_screen() -> void:
	var quests: Array[Dictionary] = []
	var progress_data: Dictionary = save_system.data.get("quest_progress", {})
	var completed: Array = save_system.data.get("quest_completed", [])
	for quest in QUEST_DEFINITIONS:
		var entry: Dictionary = quest.duplicate()
		entry["progress"] = int(progress_data.get(quest["id"], 0))
		entry["complete"] = completed.has(quest["id"])
		quests.append(entry)
	hud.set_quest_data(quests)

func _to_string_array(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(str(value))
	return result

func _living_enemy_count() -> int:
	var count := 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			count += 1
	return count

func _on_alert_changed(level: int, meter: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.set_alert_level(level)

func _on_lockdown_started() -> void:
	queue_redraw()

func _configure_input() -> void:
	var mappings := {
		"dash": KEY_SPACE,
		"attack": KEY_J,
		"program_1": KEY_1,
		"program_2": KEY_2,
		"program_3": KEY_3,
		"program_4": KEY_4,
		"ui_left": KEY_A,
		"ui_right": KEY_D,
		"ui_up": KEY_W,
		"ui_down": KEY_S,
	}
	for action in mappings.keys():
		_add_key_mapping(action, mappings[action])

func _add_key_mapping(action: String, keycode: int) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == keycode:
			return
	var input := InputEventKey.new()
	input.physical_keycode = keycode
	InputMap.action_add_event(action, input)
