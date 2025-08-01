extends Node2D

func _ready():
	for coord in Global.restocking_coords:
		var i = Global.get_restocking_point_instance()
		i.global_position = coord
		$RestockingPoints.add_child(i)
