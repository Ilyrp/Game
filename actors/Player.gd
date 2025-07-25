extends CharacterBody2D
class_name Player


signal player_health_changed(new_health)
signal died


@export var speed: int = 1000 # Default : 250


@onready var collision_shape = $CollisionShape2D
@onready var team = $Team
@onready var weapon_manager = $WeaponManager
@onready var health_stat = $Health
@onready var camera_transform = $CameraTransform


func _ready() -> void:
	weapon_manager.initialize(team.team)
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	var movement_direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1

	movement_direction = movement_direction.normalized()
	set_velocity(movement_direction * speed)
	move_and_slide()

	look_at(get_global_mouse_position())


func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path


func get_team() -> int:
	return team.team


func handle_hit():
	health_stat.health -= 20
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		die()
		var game_over_screen = load("res://UI/GameOverScreen.tscn").instantiate()
		
		get_tree().current_scene.add_child(game_over_screen)
		game_over_screen.set_title(false)
		


func die():
	emit_signal("died")
	queue_free()

func heal(amount: int):
	health_stat.health += amount
	health_stat.health = min(health_stat.health, health_stat.max_health)
	emit_signal("player_health_changed", health_stat.health)
