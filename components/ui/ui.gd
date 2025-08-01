extends Control
class_name UI

@export var player: Player
@export var racetrack: Racetrack

func _ready() -> void:
	racetrack.current_lap_updated.connect(update_lap_progress)
	player.inventory_repair_packs_updated.connect(update_inventory)
	player.holes_patched_updated.connect(func(_x): update_expected_wins())
	Global.update_ui_expected_earnings.connect(update_expected_wins)
	$ExpectedWins.visible = false

func update_inventory(amount: int):
	$Margin/Inventory/Label.text = "Repair Packs: " + str(amount)

func update_lap_progress(laps: int):
	var value = (float(laps) / float(racetrack.total_laps)) * 100
	_animate_progress(value)

func update_expected_wins():
	$ExpectedWins.visible = true
	$ExpectedWins/ExpectedCashLabel.text = str(racetrack.get_completion_cash()) + " cash"
	$ExpectedWins/SalaryLabel.text = "+" + str(racetrack.minimum_completion_cash) + " salary"
	$ExpectedWins/HolesFixedBonusLabel.text = "+" + str(player.holes_patched * racetrack.hole_patch_bonus) +  " holes fixed"
	$ExpectedWins/CarsCrashedBonusLabel.text = "+" + str(racetrack.get_car_cash_bonus()) + " active cars"

var _tween_progress: Tween
func _animate_progress(value):
	_tween_progress = Global.animate(_tween_progress)
	_tween_progress.tween_property($ProgressBar, "value", value, 10)

# TODO REMOVE

func _debug_winbutton() -> void:
	Global.complete_level(100)

func _temp_deletesave() -> void:
	Global.save.cache = Global.save.template
	Global.save.save_file()
