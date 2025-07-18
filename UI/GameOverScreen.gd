extends CanvasLayer


@onready var title = $PanelContainer/MarginContainer/Rows/Title
@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	get_tree().paused
	animation_player.play("fade")


func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.GREEN
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.RED


func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenuScreen.tscn")
