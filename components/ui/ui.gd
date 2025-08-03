extends Control
class_name UI

@export var player: Player
@export var racetrack: Racetrack

func _ready() -> void:
	await get_parent().get_parent().ready
	racetrack.current_lap_updated.connect(update_lap_progress)
	racetrack.all_cars_destroyed.connect(fail_level_crash)
	racetrack.race_finished.connect(complete_level)
	player.inventory_repair_packs_updated.connect(update_inventory)
	player.player_died.connect(fail_level_kill)
	update_inventory(player.get_inventory_size())

func update_inventory(amount: int):
	%ToolboxLabel.text = str(amount)

func update_lap_progress(laps: int):
	var value = (float(laps) / float(racetrack.total_laps)) * 100
	_animate_progress(value)

var _tween_progress: Tween
func _animate_progress(value):
	_tween_progress = Global.animate(_tween_progress)
	_tween_progress.tween_property($ProgressBar, "value", value, 10)

func fail_level_kill():
	add_child(Global.get_game_over_screen_instance(GameOverScreen.GameOverType.LOSE_KILL))
	#Global.fail_level()

func fail_level_crash():
	add_child(Global.get_game_over_screen_instance(GameOverScreen.GameOverType.LOSE_CRASH))
	#Global.fail_level()

func complete_level():
	add_child(Global.get_game_over_screen_instance(GameOverScreen.GameOverType.WIN))
	#Global.complete_level(get_completion_cash())

# TODO REMOVE
func _debug_winbutton() -> void:
	add_child(Global.get_game_over_screen_instance(GameOverScreen.GameOverType.WIN))
