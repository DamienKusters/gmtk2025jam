extends Node

func _ready():
	var i = Global.get_selected_racetrack_instance()
	i.demo = true
	i.car_amount = 0
	$RacetrackSlot.add_child(i)
