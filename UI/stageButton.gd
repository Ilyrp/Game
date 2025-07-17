extends TextureButton

@export var map_name: String = "Map1"  # Nama map, diisi di editor

@onready var label = $Label  # Referensi ke node Label di tombol

func _ready() -> void:
	# Disable tombol kalau stage belum ke-unlock
	disabled = not Map.is_stage_unlocked(map_name)
	
	# Update label dengan jumlah bintang
	var stars = Map.stars_per_stage.get(map_name, 0)
	#label.text = "%s\n%s ★" % [map_name.replace("Map", ""), stars]

func _on_pressed() -> void:
	Map.selected_map = map_name  # Simpen nama map ke singleton
	get_tree().change_scene_to_file("res://Main.tscn")  # Pindah ke Main scene
