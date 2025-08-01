extends Node

@onready var save: Save = $Save
@onready var sfx: Sfx = $SfxPlayer

signal cash_updated
signal player_upgrades_updated
signal update_ui_expected_earnings
signal game_over_screen_appeared

var hole_instance: PackedScene = preload("res://components/hole/hole.tscn")
var car_instance: PackedScene = preload("res://components/car/car.tscn")
var car_explosion_instance: PackedScene = preload("res://components/car/crash/crash.tscn")
var pin_instance: PackedScene = preload("res://components/pre-game/pin/pin.tscn")
var game_over_screen_instance: PackedScene = preload("res://components/game_over_screen/game_over_screen.tscn")
var restocking_point_instance: PackedScene = preload("res://components/restocking_point/restocking_point.tscn")
var restocking_coords = []# Read by Game

# Level select
var selected_racetrack: int = 1 # big one = 1
var selected_difficulty: int = 0

var racetracks = [
	preload("res://components/racetrack/variants/tutorial/racetrack_tutorial.tscn"),
	preload("res://components/racetrack/racetrack.tscn")
]

var hole_textures = [
	preload("res://components/hole/small.png"),
	preload("res://components/hole/medium.png"),
	preload("res://components/hole/big.png"),
	preload("res://components/hole/large.png"),
]

var car_textures = [
	preload("res://components/car/race_car_1.png"),
	preload("res://components/car/race_car_2.png"),
	preload("res://components/car/race_car_3.png"),
	preload("res://components/car/race_car_4.png"),
]

# Save file
var cash: int = 25:
	set(value):
		cash = value
		cash_updated.emit(value)
var player_upgrades = {
	"speed": 0,
	"repair": 0,
	"inventory": 0,
}:
	set(value):
		player_upgrades = value
		player_upgrades_updated.emit(value)

# Used to reset progress after a fail 
var _previous_cash
var _previous_player_upgrades

func get_hole_instance() -> Hole:
	return hole_instance.instantiate()

func get_car_instance() -> Car:
	return car_instance.instantiate()

func get_car_explosion_instance():
	return car_explosion_instance.instantiate()
	
func get_pin_instance():
	return pin_instance.instantiate()

func get_restocking_point_instance():
	return restocking_point_instance.instantiate()

func get_selected_racetrack_instance():
	return racetracks[selected_racetrack].instantiate()

func get_game_over_screen_instance(type: GameOverScreen.GameOverType):
	var i = game_over_screen_instance.instantiate()
	i.game_over_type = type
	return i

func get_hole_textures() -> Array:
	return hole_textures

func calculate_difficulty_based_on_upgrade_count() -> int:
	var total_upgrades = 0
	for key in player_upgrades.values():
		total_upgrades += key
	#every 3 upgrades 1 difficulty
	return floor(total_upgrades / 3)

func animate(tween: Tween):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	return tween

func _ready():
	save.load_file()
	_previous_player_upgrades = {
		"speed": int(save.get_float("speed")),
		"repair": int(save.get_float("repair")),
		"inventory": int(save.get_float("inventory")),
	}
	_previous_cash = int(save.get_float("cash"))
	
	# First load
	player_upgrades = _previous_player_upgrades.duplicate()
	cash = _previous_cash

func complete_level(cash_reward: int):
	_previous_player_upgrades = player_upgrades.duplicate()
	_previous_cash = cash + cash_reward
	cash = _previous_cash # set cash
	_save_save_file()
	load_game("res://components/pre-game/pre_game.tscn")

func fail_level():
	load_game("res://components/pre-game/pre_game.tscn")
	player_upgrades = _previous_player_upgrades.duplicate()
	cash = _previous_cash
	#_save_save_file() # Level failed, no saving needed

func load_game(scene: String = "res://game.tscn"):
	call_deferred("_load_game", scene)

func _reset_deferred():
	get_tree().reload_current_scene()
	
func _load_game(scene):
	get_tree().change_scene_to_file(scene)

func _load_save_file():
	pass

func _save_save_file():
	save.set_float("cash", cash)
	save.set_float("speed", _previous_player_upgrades.speed)
	save.set_float("repair", _previous_player_upgrades.repair)
	save.set_float("inventory", _previous_player_upgrades.inventory)
	save.save_file()
