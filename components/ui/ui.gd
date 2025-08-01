extends Control
class_name UI

@export var player: Player
@export var racetrack: Racetrack

func _ready() -> void:
	player.inventory_repair_packs_updated.connect(update_inventory)
	player.holes_patched_updated.connect(update_score)
	racetrack.current_lap_updated.connect(update_lap_progress)

func update_inventory(amount: int):
	$Margin/Inventory/Label.text = "Repair Packs: " + str(amount)

func update_score(amount: int):
	$Margin/Inventory/Label2.text = "Score: " + str(amount)

func update_lap_progress(laps: int):
	var value = (float(laps) / float(racetrack.total_laps)) * 100
	_animate_progress(value)

var _tween_progress: Tween
func _animate_progress(value):
	_tween_progress = Global.animate(_tween_progress)
	_tween_progress.tween_property($ProgressBar, "value", value, 10)
