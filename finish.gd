extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var game_over_screen = load("res://UI/GameOverScreen.tscn").instantiate()
		get_tree().current_scene.add_child(game_over_screen)
		game_over_screen.set_title(true)
