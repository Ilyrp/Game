extends CanvasLayer


@onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar
@onready var current_ammo = $MarginContainer/Rows/TopRow/AmmoSection/CurrentAmmo
@onready var max_ammo = $MarginContainer/Rows/TopRow/AmmoSection/MaxAmmo
@onready var kill_count = $"MarginContainer/Rows/TopRow/killSection/killcount"
@onready var enemynode = $"MarginContainer/Rows/TopRow/killSection/enemynode"


var player: Player


func set_player(new_player: Player):
	self.player = new_player

	set_new_health_value(new_player.health_stat.health)
	print(new_player.health_stat.health)
	new_player.connect("player_health_changed", Callable(self, "set_new_health_value"))

	set_weapon(new_player.weapon_manager.get_current_weapon())
	new_player.weapon_manager.connect("weapon_changed", Callable(self, "set_weapon"))


func set_weapon(weapon: Weapon):
	set_current_ammo(weapon.current_ammo)
	set_max_ammo(weapon.max_ammo)
	if not weapon.is_connected("weapon_ammo_changed", Callable(self, "set_current_ammo")):
		weapon.connect("weapon_ammo_changed", Callable(self, "set_current_ammo"))


func set_new_health_value(new_health: int):
	var original_color = Color("#5c1c1c")
	var highlight_color = Color("#ff7e7e")

	print("New Health:", new_health)
	print("Current ProgressBar Value:", health_bar.value)

	var tween = create_tween()
	tween.tween_property(health_bar, "value", new_health, 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

	var bar_style = health_bar.get("theme_override_styles/fg")
	if bar_style:
		tween.tween_property(bar_style, "bg_color", highlight_color, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(bar_style, "bg_color", original_color, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).set_delay(0.2)


func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)


func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)
	
func _process(delta):
	var main = get_parent()
	if main and main.has_method("get_enemy_counts"):
		var counts = main.get_enemy_counts()
		kill_count.text = str(counts.killed)
		enemynode.text = str(counts.total)
	
	
	
