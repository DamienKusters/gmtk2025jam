extends Node

signal cash_updated
signal player_upgrades_updated

var hole_instance: PackedScene = preload("res://components/hole/hole.tscn")
var car_instance: PackedScene = preload("res://components/car/car.tscn")

var hole_textures = [
	preload("res://components/hole/small.png"),
	preload("res://components/hole/medium.png"),
	preload("res://components/hole/big.png"),
	preload("res://components/hole/large.png"),
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

func get_hole_textures() -> Array:
	return hole_textures

func animate(tween: Tween):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	return tween

func complete_level():
	call_deferred("_reset_deferred")

func fail_level():
	load_game("res://components/pre-game/pre_game.tscn")

func load_game(scene: String = "res://game.tscn"):
	call_deferred("_load_game", scene)

func _reset_deferred():
	get_tree().reload_current_scene()
	
func _load_game(scene):
	get_tree().change_scene_to_file(scene)
