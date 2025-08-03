extends Node2D

@export var ui: UI

func _ready():
	Global.music.play_music("pitstop")
	for coord in Global.restocking_coords:
		var x = Global.get_restocking_point_instance()
		x.global_position = coord
		$RestockingPoints.add_child(x)
	
	var i = Global.get_selected_racetrack_instance()
	i.player = $Player
	ui.racetrack = i
	$RacetrackRoot.add_child(i)
