extends Node2D
class_name Racetrack

@export var car_amount = 4
@export var total_laps = 8 # TEST amount

var race_started = false

func _ready():
	for c in car_amount:
		var car = Global.get_car_instance()
		car.racetrack = self
		car.laps_completed_updated.connect(func(_x): _car_lap_completed(car))
		$CarsPath.add_child(car)
		car.progress_ratio = 0

func add_hole(hole: Hole):
	$Holes.add_child(hole)

func _car_lap_completed(car: Car):
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
