extends Node

# Jumlah stage
const STAGE_COUNT := 5
# Path file save
const SAVE_PATH := "user://stage_progress.save"

# Progress: true jika stage sudah terbuka
var progress := [true, false, false, false, false]

func _ready():
	load_progress()

func unlock_stage(stage_idx: int):
	if stage_idx >= 0 and stage_idx < STAGE_COUNT:
		progress[stage_idx] = true
		save_progress()

func is_stage_unlocked(stage_idx: int) -> bool:
	if stage_idx >= 0 and stage_idx < STAGE_COUNT:
		return progress[stage_idx]
	return false

func save_progress():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(progress)
		file.close()

func load_progress():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			progress = file.get_var()
			file.close() 
