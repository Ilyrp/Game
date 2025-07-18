extends Node2D
class_name Weapon

signal weapon_ammo_changed(new_ammo_count)
signal weapon_out_of_ammo

@export var bullet_scene: PackedScene  
@export var max_ammo: int = 10
@export var semi_auto: bool = true

var team: int = -1
var current_ammo: int = max_ammo: set = set_current_ammo

@onready var end_of_gun = $EndOfGun
@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $MuzzleFlash

func _ready() -> void:
	muzzle_flash.hide()
	current_ammo = max_ammo

	if bullet_scene == null:
		print("WARNING: Bullet scene not assigned! Loading default bullet.tscn...")
		bullet_scene = load("res://weapons/Bullet.tscn")
		
		

func initialize(newTeam: int):
	self.team = newTeam

func start_reload():
	animation_player.play("reload")
	$GunReload.play()

func _stop_reload():
	current_ammo = max_ammo
	emit_signal("weapon_ammo_changed", current_ammo)

func set_current_ammo(new_ammo: int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")

		emit_signal("weapon_ammo_changed", current_ammo)

func shoot():
	if current_ammo > 0 and attack_cooldown.is_stopped():
		if bullet_scene == null:
			print("ERROR: Bullet scene could not be loaded!")
			return

		var bullet_instance = bullet_scene.instantiate()
		var direction = (end_of_gun.global_position - global_position).normalized()
		bullet_instance.position = end_of_gun.global_position

		get_tree().current_scene.add_child(bullet_instance)

		GlobalSignals.emit_signal("bullet_fired", bullet_instance, team, end_of_gun.global_position, direction)

		attack_cooldown.start()
		animation_player.play("muzzle_flash")

		set_current_ammo(current_ammo - 1)
		$GunVoice.play()
	elif current_ammo == 0:
		$GunEmpty.play()
		
