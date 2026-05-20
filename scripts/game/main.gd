extends Node2D

const PlayerScene := preload("res://scripts/player/player.gd")
const DroneScene := preload("res://scripts/enemies/drone.gd")
const HunterScene := preload("res://scripts/enemies/hunter.gd")
const TurretScene := preload("res://scripts/enemies/turret.gd")
const DirectorScene := preload("res://scripts/game/game_director.gd")
const ProgramSystemScene := preload("res://scripts/systems/program_system.gd")
const SaveSystemScene := preload("res://scripts/systems/save_system.gd")
const VfxLayerScene := preload("res://scripts/systems/vfx_layer.gd")
const HudScene := preload("res://scripts/ui/hud.gd")
const VaultGeneratorScene := preload("res://scripts/game/vault_generator.gd")

var vault_data: Dictionary
var player
var director
var program_system
var save_system
var vfx_layer
var hud
var camera: Camera2D
var enemy_root := Node2D.new()
var enemies: Array[Node2D] = []
var run_complete := false
var current_wave := 0
var wave_in_progress := false
var wave_break_timer := 0.0
var enemies_defeated := 0

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

	vfx_layer = VfxLayerScene.new()
	add_child(vfx_layer)

	hud = HudScene.new()
	add_child(hud)

	add_child(enemy_root)
	_start_run()

func _physics_process(delta: float) -> void:
	if run_complete:
		return

	var heat: float = max(0.0, 1.0 - player.health / player.max_health)
	director.tick(delta, heat)
	_update_camera(delta)
	_update_wave(delta)
	hud.update_run(player, director, program_system, current_wave, _living_enemy_count())

func _draw() -> void:
	if vault_data.is_empty():
		return

	_draw_dark_western_backdrop()

	var arena: Rect2 = vault_data["arena"]
	draw_rect(arena, Color(0.38, 0.22, 0.105, 0.96), true)
	draw_rect(arena.grow(-14.0), Color(0.64, 0.39, 0.17, 0.2), false, 3.0)
	draw_rect(arena, Color(0.55, 0.29, 0.12, 0.58), false, 6.0)
	draw_rect(arena.grow(-42.0), Color(0.86, 0.62, 0.33, 0.12), false, 2.0)

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

func _draw_sand_detail(arena: Rect2) -> void:
	for i in range(16):
		var y := lerpf(arena.position.y + 90.0, arena.end.y - 90.0, float(i) / 15.0)
		var wave := sin(i * 1.8) * 34.0
		var color := Color(0.76, 0.5, 0.24, 0.16) if i % 2 == 0 else Color(0.2, 0.1, 0.045, 0.18)
		draw_line(Vector2(arena.position.x + 70.0, y), Vector2(arena.end.x - 70.0, y + wave), color, 7.0)

	for i in range(72):
		var x := arena.position.x + float((i * 173) % int(arena.size.x - 160.0)) + 80.0
		var y := arena.position.y + float((i * 97) % int(arena.size.y - 160.0)) + 80.0
		var radius := 2.0 + float((i * 11) % 5)
		var tint := Color(0.12, 0.07, 0.035, 0.32) if i % 3 == 0 else Color(0.82, 0.58, 0.3, 0.18)
		draw_circle(Vector2(x, y), radius, tint)

	for i in range(18):
		var x := arena.position.x + float((i * 251) % int(arena.size.x - 220.0)) + 110.0
		var y := arena.position.y + float((i * 149) % int(arena.size.y - 220.0)) + 110.0
		var length := 30.0 + float((i * 17) % 54)
		var angle := -0.2 + sin(i * 2.1) * 0.35
		var start := Vector2(x, y)
		var end := start + Vector2.RIGHT.rotated(angle) * length
		draw_line(start, end, Color(0.16, 0.08, 0.035, 0.24), 3.0)
		draw_line(start + Vector2(0, 5), end + Vector2(0, 5), Color(0.84, 0.58, 0.3, 0.12), 2.0)

	for i in range(10):
		var x := arena.position.x + float((i * 337) % int(arena.size.x - 260.0)) + 130.0
		var y := arena.position.y + float((i * 211) % int(arena.size.y - 260.0)) + 130.0
		var rock := Rect2(Vector2(x, y), Vector2(18.0 + (i % 4) * 7.0, 8.0 + (i % 3) * 5.0))
		draw_rect(rock, Color(0.13, 0.07, 0.04, 0.42), true)
		draw_rect(rock, Color(0.54, 0.31, 0.16, 0.28), false, 1.5)

func _get_vault_bounds() -> Rect2:
	return vault_data["arena"]

func _unhandled_input(event: InputEvent) -> void:
	if run_complete:
		if event is InputEventKey and event.pressed:
			_start_run()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_SPACE:
				player.try_dash()
			KEY_J:
				player.try_weapon_attack()
			KEY_1:
				_cast_program("emp_blast")
			KEY_2:
				_cast_program("chain_lightning")
			KEY_3:
				_cast_program("time_slow")

func _start_run() -> void:
	run_complete = false
	current_wave = 0
	wave_in_progress = false
	wave_break_timer = 0.0
	enemies_defeated = 0
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

	player = PlayerScene.new()
	add_child(player)
	player.position = vault_data["spawn"]
	player.set_arena_bounds(vault_data["arena"])
	player.dash_used.connect(_on_player_dash)
	player.weapon_slashed.connect(_on_player_weapon_slashed)
	player.player_damaged.connect(_on_player_damaged)
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
		program_system.award_random_program()
		director.add_heat(-0.35)

	if not wave_in_progress and wave_break_timer > 0.0:
		wave_break_timer = max(0.0, wave_break_timer - delta)
		if wave_break_timer <= 0.0:
			_start_next_wave()

func _start_next_wave() -> void:
	current_wave += 1
	wave_in_progress = true
	hud.show_wave_banner(current_wave)
	_spawn_wave(current_wave)
	director.add_heat(0.1 + current_wave * 0.025)

func _spawn_wave(wave: int) -> void:
	var total: int = 4 + wave * 2
	var hunter_count: int = int(mini(wave / 2, 5))
	var turret_count: int = int(mini(maxi(0, wave - 2) / 3, 4))
	var drone_count: int = maxi(1, total - hunter_count - turret_count)

	for i in range(drone_count):
		_spawn_enemy(DroneScene, i, drone_count + hunter_count + turret_count)
	for i in range(hunter_count):
		_spawn_enemy(HunterScene, drone_count + i, drone_count + hunter_count + turret_count)
	for i in range(turret_count):
		_spawn_enemy(TurretScene, drone_count + hunter_count + i, drone_count + hunter_count + turret_count)

func _spawn_enemy(enemy_script, index: int, total: int) -> void:
	var enemy: Node2D = enemy_script.new()
	var spawn_position := _get_wave_spawn_position(index, total)
	enemy.position = spawn_position
	enemy_root.add_child(enemy)
	enemy.setup(player, director, vfx_layer)
	enemy.destroyed.connect(_on_enemy_destroyed)
	enemy.set_alert_level(int(min(4, current_wave / 2)))
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

	var result: Dictionary = program_system.cast(program_id, player.global_position, enemies)
	director.add_heat(result["heat"])
	vfx_layer.program_flash(player.global_position, result["color"])

	for enemy in result["hit_enemies"]:
		if is_instance_valid(enemy):
			enemy.take_damage(result["damage"])

	if result["chain_radius"] > 0.0:
		_trigger_chain_reaction(player.global_position, result["chain_radius"], result["damage"] * 0.7)

func _trigger_chain_reaction(origin: Vector2, radius: float, damage: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(origin) <= radius:
			enemy.take_damage(damage)
	director.add_heat(0.08)

func _on_player_dash() -> void:
	director.add_heat(0.03)
	vfx_layer.trail_pop(player.global_position, Color(0.68, 0.36, 0.16))

func _on_player_weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float) -> void:
	director.add_heat(0.025)
	vfx_layer.trail_pop(origin + direction * 62.0, Color(0.86, 0.58, 0.28))

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		var to_enemy: Vector2 = enemy.global_position - origin
		if to_enemy.length() > slash_range:
			continue
		if abs(direction.angle_to(to_enemy.normalized())) > arc * 0.5:
			continue

		enemy.take_damage(damage)

func _on_player_damaged(amount: float) -> void:
	director.add_heat(0.18)
	camera.offset = Vector2(randf_range(-10.0, 10.0), randf_range(-8.0, 8.0))
	var tween := create_tween()
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.16)
	vfx_layer.burst(player.global_position, Color(0.72, 0.08, 0.04), 24)

func _on_player_down() -> void:
	run_complete = true
	save_system.add_credits(enemies_defeated * 5 + max(0, current_wave - 1) * 35)
	hud.show_run_failed()
	vfx_layer.shockwave(player.global_position, Color(0.72, 0.08, 0.04))

func _on_enemy_destroyed(enemy) -> void:
	enemies_defeated += 1
	enemies = enemies.filter(func(other: Node2D) -> bool: return is_instance_valid(other) and other != enemy)

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
