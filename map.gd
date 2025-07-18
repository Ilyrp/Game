extends Node

var selected_map: String = "Map1"  # Default map
var stars_per_stage: Dictionary = {
	"Map1": 0,  # Stage 1
	"Map2": 0,  # Stage 2
	"Map3": 0,  # Stage 3
	"Map4": 0,  # Stage 4
	"Map5": 0   # Stage 5
}

# Fungsi untuk cek apakah stage ke-unlock
func is_stage_unlocked(stage_name: String) -> bool:
	# Stage 1 selalu unlock
	if stage_name == "Map1":
		return true
	
	# Cek stage sebelumnya
	var stage_number = int(stage_name.replace("Map", ""))
	var prev_stage = "Map" + str(stage_number - 1)
	return stars_per_stage.get(prev_stage, 0) > 0
	
# Fungsi untuk simpan bintang setelah stage selesai
func set_stars_for_stage(stage_name: String, stars: int) -> void:
# Hanya update jika lebih besar dari nilai sebelumnya
	if stars > stars_per_stage.get(stage_name, 0):
		stars_per_stage[stage_name] = clamp(stars, 0, 3)
		save_progress()

func save_progress():
# Simpan progress ke file
	var save_data = {
		"stars_per_stage": stars_per_stage
	}
	var file = FileAccess.open("user://game_save.dat", FileAccess.WRITE)
	file.store_var(save_data)

func load_progress():
# Load progress dari file
	if FileAccess.file_exists("user://game_save.dat"):
		var file = FileAccess.open("user://game_save.dat", FileAccess.READ)
		var save_data = file.get_var()
		if save_data is Dictionary and save_data.has("stars_per_stage"):
			stars_per_stage = save_data["stars_per_stage"]
