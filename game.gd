extends Node2D

@export var ui: UI

func _ready():
	for coord in Global.restocking_coords:
		var i = Global.get_restocking_point_instance()
		i.global_position = coord
		$RestockingPoints.add_child(i)
	
	var i = Global.get_selected_racetrack_instance()
	i.player = $Player
	ui.racetrack = i
	$RacetrackRoot.add_child(i)
