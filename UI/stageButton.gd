extends TextureButton

@export var map_name: String = "Map1"  # Nama map, diisi di editor

@onready var label = $Label  # Referensi ke node Label di tombol
@onready var star_container = $stageStar

func _ready() -> void:
	# Disable tombol kalau stage belum ke-unlock
	disabled = not Map.is_stage_unlocked(map_name)
	update_star_display()
	
func update_star_display():
	var star_count = Map.stars_per_stage.get(map_name, 0)
# Hapus semua bintang yang ada sebelumnya
	for child in star_container.get_children():
		child.queue_free()
# Tambahkan bintang sesuai jumlah
	for i in range(3):
		var star = TextureRect.new()
		star.texture = load("res://assets/kenney_topdowntanksredux/PNG/ui/shot.png") if i < star_count else load("res://UI/star_empty.png")
		star.custom_minimum_size = Vector2(32, 32)  # Ukuran minimal
		star.size_flags_stretch_ratio = 1.0  # Untuk distribusi ruang yang merata
		star.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star_container.add_child(star)

func _on_pressed() -> void:
	Map.selected_map = map_name  # Simpen nama map ke singleton
	get_tree().change_scene_to_file("res://Main.tscn")  # Pindah ke Main scene


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenuScreen.tscn")
