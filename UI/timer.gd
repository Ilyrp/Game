extends HBoxContainer

var time: float = 0.0
var minute: int = 0
var second: int = 0
var msec: int = 0

# Preload references to ensure they exist
@onready var minute_label: Label = $Minute
@onready var second_label: Label = $Second
@onready var msec_label: Label = $Msec

func _ready() -> void:
	# Initialize labels to prevent null reference
	update_display(0, 0, 0)

func _process(delta: float) -> void:
	time += delta
	minute = int(time / 60)
	second = int(fmod(time, 60))
	msec = int(fmod(time, 1) * 1000)  # Using 1000 for proper milliseconds
	update_display(minute, second, msec)
	
func update_display(min_val: int, sec_val: int, ms_val: int) -> void:
	if minute_label:
		minute_label.text = "%02d:" % min_val
	if second_label:
		second_label.text = "%02d." % sec_val  # Using dot as separator
	if msec_label:
		msec_label.text = "%03d" % ms_val

func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minute, second, msec]
