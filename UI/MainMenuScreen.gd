extends Control


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/stages.tscn")
	#


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
