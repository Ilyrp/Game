extends Node2D


const PlayerScene = preload("res://actors/Player.tscn")
const EnemyScene = preload("res://actors/Enemy.tscn")
const ItemScene = preload("res://actors/Item.tscn")
const GameOverScreen = preload("res://UI/GameOverScreen.tscn")
const PauseScreen = preload("res://UI/PauseScreen.tscn")

const MAP_SCENE_PATH = "res://map/%s.tscn"

@onready var bullet_manager = $BulletManager
@onready var camera = $Camera2D
@onready var gui = $GUI
@onready var map = null
@onready var player = null

func _ready() -> void:
	randomize()
	GlobalSignals.connect("bullet_fired", Callable(bullet_manager, "handle_bullet_spawned"))
	render_map() # Initialize the default map
	spawn_player()
	spawn_enemy()
	spawn_items()

func render_map(map_name: String = "Map4"):
	# Remove the existing map if there is one
	if map != null:
		map.queue_free()
	
	# Load and instantiate the requested map
	var map_scene = load(MAP_SCENE_PATH % map_name)
	if map_scene == null:
		push_error("Failed to load map: %s" % map_name)
		return
	
	map = map_scene.instantiate()
	add_child(map)
	
	# Make sure the map is behind other game elements
	move_child(map, 0)

func spawn_player():
	player = PlayerScene.instantiate()
	add_child(player)
	if map and map.has_node("PlayerSpawn/Player"):
		player.global_position = map.get_node("PlayerSpawn/Player").global_position
	player.set_camera_transform(camera.get_path())
	player.connect("died", Callable(self, "spawn_player"))
	gui.set_player(player)

func spawn_enemy():
	if map and map.has_node("EnemySpawn"):
		var spawn_points = map.get_node("EnemySpawn").get_children()
		for spawn_point in spawn_points:
			var enemy = EnemyScene.instantiate()
			add_child(enemy)
			enemy.global_position = spawn_point.global_position
			
			# Set navigation map for enemy's AI
			var nav_map = get_world_2d().get_navigation_map()
			var ai = enemy.get_node("AI")
			if ai and ai.has_node("NavigationAgent2D"):
				ai.get_node("NavigationAgent2D").set_navigation_map(nav_map)
	else:
		var enemy = EnemyScene.instantiate()
		add_child(enemy)
		enemy.global_position = Vector2(100, 100)

func spawn_items():
	if map and map.has_node("ItemSpawn"):
		# Get all spawn point groups (like Bandage, Ammo, etc)
		var spawn_groups = map.get_node("ItemSpawn").get_children()
		
		for group in spawn_groups:
			# Get all individual spawn points in this group
			var spawn_points = group.get_children()
			print("Found %d %s spawn points" % [spawn_points.size(), group.name])
			
			for spawn_point in spawn_points:
				print("Spawning %s at position: %s" % [group.name, spawn_point.global_position])
				var item = ItemScene.instantiate()
				
				# Configure item based on spawn group
				match group.name:
					"Bandage":
						item.set("item_type", 0)  # 0 = HEALTH enum value
						item.set("value", 20)  # Healing amount
				
				add_child(item)
				item.global_position = spawn_point.global_position
				print("%s spawned successfully" % group.name)
	else:
		print("No ItemSpawn node found in map")

func handle_player_win():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_lost():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instantiate()
		add_child(pause_menu)
