extends Node2D
class_name Racetrack

signal current_lap_updated

@export var car_amount: int = 4
@export var car_cash_bonus: int = 100
@export var minimum_completion_cash: int = 100
@export var total_laps: int = 8 # TEST amount

var race_started = false
var current_lap: int = 0:
	set(value):
		current_lap = value
		current_lap_updated.emit(value)

func _ready():
	for c in car_amount:
		var car = Global.get_car_instance()
		car.racetrack = self
		car.laps_completed_updated.connect(func(_x): _car_lap_completed(car))
		$CarsPath.add_child(car)
		car.progress_ratio = 0

func get_completion_cash() -> int:
	return minimum_completion_cash + get_car_cash_bonus()

func get_car_cash_bonus() -> int:
	var active_cars = []
	for car: Car in $CarsPath.get_children():
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
	if !race_started:
		return
	for car: Car in $CarsPath.get_children():
		car.update_behaviour()

func _on_hole_timer_timeout() -> void:
	if !race_started:
		return
	for car: Car in $CarsPath.get_children():
		car.spawn_hole_attempt()
