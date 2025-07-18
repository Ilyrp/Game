extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Load and show the game over screen with victory state
		var game_over_screen = load("res://UI/GameOverScreen.tscn").instantiate()
		game_over_screen.set_title(true)  # true means victory
		get_tree().current_scene.add_child(game_over_screen)
		get_tree().paused = true
