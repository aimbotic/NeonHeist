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
var hacked_nodes := {}
var run_complete := false
var extraction_open := false
var loot_collected := 0

func _ready() -> void:
	_configure_input()
	RenderingServer.set_default_clear_color(Color(0.33, 0.19, 0.08, 1.0))

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
	_update_extraction()
	hud.update_run(player, director, program_system, loot_collected, extraction_open)

func _draw() -> void:
	if vault_data.is_empty():
		return

	_draw_arcade_desert_backdrop()

	for corridor in vault_data["corridors"]:
		draw_line(corridor["from"], corridor["to"], Color(0.74, 0.43, 0.16, 0.52), 84.0)
		draw_line(corridor["from"], corridor["to"], Color(0.95, 0.68, 0.28, 0.38), 48.0)
		draw_line(corridor["from"], corridor["to"], Color(0.2, 0.95, 1.0, 0.22), 8.0)

	for room in vault_data["rooms"]:
		var rect: Rect2 = room["rect"]
		draw_rect(rect, Color(0.56, 0.31, 0.12, 0.94), true)
		draw_rect(rect.grow(-10.0), Color(0.76, 0.47, 0.19, 0.52), false, 2.0)
		draw_rect(rect, Color(1.0, 0.63, 0.18, 0.48), false, 4.0)
		draw_rect(rect.grow(-18.0), Color(0.1, 0.92, 1.0, 0.16), false, 2.0)

	for hazard in vault_data["hazards"]:
		draw_circle(hazard, 22.0, Color(1.0, 0.38, 0.05, 0.38))
		draw_arc(hazard, 34.0, 0.0, TAU, 28, Color(1.0, 0.48, 0.08, 0.85), 3.0)

	for node_position in vault_data["hack_nodes"]:
		var hacked := hacked_nodes.has(node_position)
		var color := Color(0.2, 1.0, 0.95, 0.95) if not hacked else Color(0.4, 1.0, 0.35, 0.8)
		draw_circle(node_position, 28.0, Color(color.r, color.g, color.b, 0.18))
		draw_rect(Rect2(node_position - Vector2(15, 15), Vector2(30, 30)), color, false, 4.0)

	var extraction_color := Color(0.2, 1.0, 0.45, 0.95) if extraction_open else Color(1.0, 0.25, 0.15, 0.8)
	draw_circle(vault_data["extraction"], 58.0, Color(extraction_color.r, extraction_color.g, extraction_color.b, 0.18))
	draw_arc(vault_data["extraction"], 72.0, 0.0, TAU, 48, extraction_color, 5.0)

func _draw_arcade_desert_backdrop() -> void:
	var bounds := _get_vault_bounds().grow(520.0)
	draw_rect(bounds, Color(0.35, 0.2, 0.08, 1.0), true)

	var horizon_y := bounds.position.y + bounds.size.y * 0.22
	draw_rect(Rect2(bounds.position, Vector2(bounds.size.x, bounds.size.y * 0.24)), Color(0.12, 0.045, 0.08, 1.0), true)
	draw_line(Vector2(bounds.position.x, horizon_y), Vector2(bounds.end.x, horizon_y), Color(1.0, 0.38, 0.16, 0.48), 4.0)

	for i in range(7):
		var t := float(i) / 6.0
		var y := lerpf(horizon_y + 50.0, bounds.end.y - 80.0, t)
		var alpha := lerpf(0.2, 0.06, t)
		draw_line(Vector2(bounds.position.x, y), Vector2(bounds.end.x, y), Color(1.0, 0.74, 0.28, alpha), 2.0)

	for i in range(12):
		var x := bounds.position.x + i * 220.0
		draw_line(Vector2(x, horizon_y), Vector2(x - 260.0, bounds.end.y), Color(1.0, 0.45, 0.18, 0.08), 2.0)
		draw_line(Vector2(x, horizon_y), Vector2(x + 260.0, bounds.end.y), Color(1.0, 0.45, 0.18, 0.08), 2.0)

	for i in range(9):
		var dune_y := bounds.position.y + bounds.size.y * (0.36 + i * 0.055)
		var start := Vector2(bounds.position.x - 80.0, dune_y)
		var end := Vector2(bounds.end.x + 80.0, dune_y + sin(i * 1.7) * 52.0)
		draw_line(start, end, Color(0.8, 0.48, 0.18, 0.18), 10.0)

	for i in range(10):
		var mesa_x := bounds.position.x + 160.0 + i * 310.0
		var mesa_w := 90.0 + float((i * 37) % 70)
		var mesa_h := 55.0 + float((i * 23) % 80)
		var mesa_rect := Rect2(Vector2(mesa_x, horizon_y - mesa_h), Vector2(mesa_w, mesa_h))
		draw_rect(mesa_rect, Color(0.21, 0.095, 0.06, 0.78), true)
		draw_rect(mesa_rect, Color(0.8, 0.38, 0.16, 0.36), false, 2.0)

func _get_vault_bounds() -> Rect2:
	var bounds := Rect2(vault_data["spawn"], Vector2.ZERO)
	for room in vault_data["rooms"]:
		bounds = bounds.merge(room["rect"])
	for corridor in vault_data["corridors"]:
		bounds = bounds.expand(corridor["from"])
		bounds = bounds.expand(corridor["to"])
	return bounds

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
			KEY_E:
				_try_hack()
			KEY_1:
				_cast_program("emp_blast")
			KEY_2:
				_cast_program("chain_lightning")
			KEY_3:
				_cast_program("time_slow")

func _start_run() -> void:
	run_complete = false
	extraction_open = false
	loot_collected = 0
	hacked_nodes.clear()
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
	player.set_maze_geometry(vault_data["rooms"], vault_data["corridors"])
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

	_spawn_enemies()
	hud.show_run_start(vault_data["seed"])
	vfx_layer.burst(vault_data["spawn"], Color(0.2, 1.0, 1.0), 36)
	queue_redraw()

func _spawn_enemies() -> void:
	var spawn_points: Array = vault_data["enemy_spawns"]
	for i in range(spawn_points.size()):
		var enemy: Node2D
		if i % 7 == 0:
			enemy = TurretScene.new()
		elif i % 3 == 0:
			enemy = HunterScene.new()
		else:
			enemy = DroneScene.new()
		enemy.position = spawn_points[i]
		enemy_root.add_child(enemy)
		enemy.setup(player, director, vfx_layer)
		enemies.append(enemy)

func _update_camera(delta: float) -> void:
	if camera == null:
		return
	var speed_factor: float = clamp(player.velocity.length() / player.max_speed, 0.0, 1.0)
	var target_zoom: float = 0.92 - speed_factor * 0.08 - director.alert_level * 0.025
	camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), delta * 3.0)
	camera.rotation = lerpf(camera.rotation, player.velocity.x * 0.000035, delta * 4.0)

func _try_hack() -> void:
	var closest := Vector2.ZERO
	var closest_distance := 99999.0
	for node_position in vault_data["hack_nodes"]:
		if hacked_nodes.has(node_position):
			continue
		var distance: float = player.global_position.distance_to(node_position)
		if distance < closest_distance:
			closest = node_position
			closest_distance = distance

	if closest_distance <= 96.0:
		hacked_nodes[closest] = true
		loot_collected += 1
		director.add_heat(-0.2)
		program_system.award_random_program()
		vfx_layer.shockwave(closest, Color(0.25, 1.0, 0.85))
		if hacked_nodes.size() >= 3:
			extraction_open = true
		queue_redraw()
	else:
		director.add_heat(0.22)
		vfx_layer.burst(player.global_position, Color(1.0, 0.1, 0.25), 18)

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
	for hazard in vault_data["hazards"]:
		if origin.distance_to(hazard) <= radius:
			vfx_layer.shockwave(hazard, Color(1.0, 0.4, 0.08))
			for enemy in enemies:
				if is_instance_valid(enemy) and enemy.global_position.distance_to(hazard) <= 145.0:
					enemy.take_damage(damage)
			director.add_heat(0.08)

func _update_extraction() -> void:
	if not extraction_open:
		return

	if player.global_position.distance_to(vault_data["extraction"]) <= 92.0:
		run_complete = true
		var credits := loot_collected * 35 + hacked_nodes.size() * 20
		save_system.add_credits(credits)
		hud.show_run_complete(credits)
		vfx_layer.shockwave(vault_data["extraction"], Color(0.25, 1.0, 0.45))

func _on_player_dash() -> void:
	director.add_heat(0.03)
	vfx_layer.trail_pop(player.global_position, Color(0.25, 0.95, 1.0))

func _on_player_weapon_slashed(origin: Vector2, direction: Vector2, slash_range: float, arc: float, damage: float) -> void:
	director.add_heat(0.025)
	vfx_layer.trail_pop(origin + direction * 62.0, Color(1.0, 0.18, 0.82))

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
	vfx_layer.burst(player.global_position, Color(1.0, 0.12, 0.4), 24)

func _on_player_down() -> void:
	run_complete = true
	hud.show_run_failed()
	vfx_layer.shockwave(player.global_position, Color(1.0, 0.08, 0.18))

func _on_alert_changed(level: int, meter: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.set_alert_level(level)

func _on_lockdown_started() -> void:
	extraction_open = true
	queue_redraw()

func _configure_input() -> void:
	var mappings := {
		"dash": KEY_SPACE,
		"attack": KEY_J,
		"hack": KEY_E,
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
