extends CanvasLayer


@onready var title = $PanelContainer/MarginContainer/Rows/Title
@onready var animation_player = $AnimationPlayer
@onready var star_container = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/starContainer
@onready var kill_count_label = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/killCountLabel

var stars_earned = 0

func _ready() -> void:
	get_tree().paused = true
	animation_player.play("fade")

func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.GREEN
		var main = get_tree().current_scene
		if main and main.has_method("get_enemy_counts"):
			var counts = main.get_enemy_counts()
			kill_count_label.text = "Enemies Killed: %d/%d" % [counts.killed, counts.total]
			stars_earned = calculate_stars(counts.killed, counts.total)
			update_star_display(stars_earned)
			# Simpan progress
			Map.set_stars_for_stage(Map.selected_map, stars_earned)
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.RED
		kill_count_label.text = "Try Again!"
		star_container.visible = false
		
func calculate_stars(killed: int, total: int) -> int:
	if total == 0:
		return 0 
	var kill_ratio = float(killed) / float(total)
	if killed == total:
		return 3
	elif kill_ratio >= 0.7:
		return 2
	elif killed > 0:
		return 1
	else:
		return 0
		
func update_star_display(stars: int):
	# Hapus semua bintang yang ada
	for child in star_container.get_children():
		child.queue_free()
	
	# Tambahkan bintang sesuai jumlah
	for i in range(3):
		var star = TextureRect.new()
		star.texture = load("res://UI/star_filled.png") if i < stars else load("res://UI/star_empty.png")
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star.size = Vector2(32, 32)
		star_container.add_child(star)

func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://Main.tscn")
	get_tree().reload_current_scene()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenuScreen.tscn")
