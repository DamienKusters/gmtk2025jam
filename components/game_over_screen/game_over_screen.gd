extends Control
class_name GameOverScreen

enum GameOverType {WIN,LOSE_CRASH,LOSE_KILL}

# NOTE PARENT MUST BE UI!!!
@onready var ui: UI = get_parent()

@export var game_over_type: GameOverType = GameOverType.LOSE_KILL

var texture_mapping = {
	GameOverType.WIN: preload("res://components/game_over_screen/Win_screen.png"),
	GameOverType.LOSE_CRASH: preload("res://components/game_over_screen/Lose_screen_crash.png"),
	GameOverType.LOSE_KILL: preload("res://components/game_over_screen/Loose_screen_hit_copy.png"),
}

var sound_mapping = {
	GameOverType.WIN: "win",
	GameOverType.LOSE_CRASH: "lose_crash",
	GameOverType.LOSE_KILL: "lose_kill",
}

func _ready():
	Global.game_over_screen_appeared.emit()
	$Control/TextureRect.texture = texture_mapping[game_over_type]
	$AnimationPlayer.play("scale")
	Global.sfx.play_sfx(sound_mapping[game_over_type])
	%ExpectedWins.visible = false
	%LapsSurvived.visible = false
	if game_over_type == GameOverType.WIN:
		update_expected_wins()
	else:
		update_amount_of_laps_survived()

func update_amount_of_laps_survived():
	%LapsSurvived.visible = true
	%LapsSurvived/LapsSurvived.text = str(ui.racetrack.current_lap) + " / " + str(ui.racetrack.total_laps)

func update_expected_wins():
	%ExpectedWins.visible = true
	%ExpectedWins/ExpectedCashLabel.text = str(ui.racetrack.get_completion_cash()) + " cash"
	%ExpectedWins/SalaryLabel.text = "+" + str(ui.racetrack.minimum_completion_cash) + " salary"
	%ExpectedWins/HolesFixedBonusLabel.text = "+" + str(ui.player.holes_patched * ui.racetrack.hole_patch_bonus) +  " repair bonus"
	%ExpectedWins/CarsCrashedBonusLabel.text = "+" + str(ui.racetrack.get_car_cash_bonus()) + " active cars bonus"

func _on_retry_button_pressed() -> void:
	if game_over_type == GameOverType.WIN:
		Global.complete_level(ui.racetrack.get_completion_cash())
	else:
		Global.fail_level()
