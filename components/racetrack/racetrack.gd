extends Node2D
class_name Racetrack

signal current_lap_updated
signal all_cars_destroyed
signal race_finished

@export var car_amount: int = 4
@export var car_cash_bonus: int = 100
@export var car_difficulty: int = 0 # TODO currently this is controlled in the _ready function!!!!
@export var hole_patch_bonus: int = 10
@export var minimum_completion_cash: int = 100
@export var total_laps: int = 8 # TEST amount
@export var demo = false # true if nothing should happen

@export var player: Player # Required to add the amount of fixed holes :(

var race_started = false
var current_lap: int = 0:
	set(value):
		current_lap = value
		current_lap_updated.emit(value)

func _ready():
	Global.game_over_screen_appeared.connect(_stop_all_cars)
	$Background/Sprite2D3.visible = false # not needed anymore because we now have a help menu
	if demo:
		$CarTimer.stop()
		$HoleTimer.stop()
		$Background/Sprite2D3.visible = false
	#car_difficulty = Global.calculate_difficulty_based_on_upgrade_count() # old system
	car_difficulty = Global.selected_difficulty
	print("Difficulty: " + str(car_difficulty))
	for c in car_amount:
		var car = Global.get_car_instance()
		car.racetrack = self
		car.texture = Global.car_textures[fposmod(c, Global.car_textures.size())]
		car.laps_completed_updated.connect(func(_x): _car_lap_completed(car))
		$CarsPath.add_child(car)
		car.progress_ratio = 0

func get_completion_cash() -> int:
	var hole_value = player.holes_patched * hole_patch_bonus
	return minimum_completion_cash + get_car_cash_bonus() + hole_value

func get_car_cash_bonus() -> int:
	var active_cars = []
	for car: Car in $CarsPath.get_children():
		if car.crashed == false:
			active_cars.append(car)
	return active_cars.size() * car_cash_bonus

func add_hole(hole: Hole):
	$Holes.add_child(hole)

func _car_lap_completed(car: Car):
	if car.laps_completed > current_lap:
		current_lap = car.laps_completed
	if car.laps_completed >= total_laps:
		race_started = false
		print("Car wins")
		print(car)
		for c: Car in $CarsPath.get_children():
			c.update_behaviour(true)

var _first_tick = true
func _on_car_timer_timeout() -> void:
	if _first_tick:
		race_started = true
		_first_tick = false
	if current_lap == total_laps:
		race_finished.emit()
	if !race_started:
		return
	for car: Car in $CarsPath.get_children():
		car.update_behaviour()
	if $CarsPath.get_children().size() == 0:
		all_cars_destroyed.emit()

func _on_hole_timer_timeout() -> void:
	if !race_started:
		return
	for car: Car in $CarsPath.get_children():
		car.spawn_hole_attempt()

func _stop_all_cars():
	for car: Car in $CarsPath.get_children():
		car.update_behaviour(true)
	$CarTimer.stop()
	$HoleTimer.stop()
