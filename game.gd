extends Node2D
class_name Game

signal complete_level
signal fail_level

var hole_instance: PackedScene = preload("res://components/hole/hole.tscn")

var hole_textures = [
	preload("res://components/hole/small.png"),
	preload("res://components/hole/medium.png"),
	preload("res://components/hole/big.png"),
	preload("res://components/hole/large.png"),
]

func get_hole_instance() -> Hole:
	return hole_instance.instantiate()
	
func get_hole_textures() -> Array:
	return hole_textures

func add_hole(hole: Hole):
	$Racetrack.add_child(hole)

func _ready():
	fail_level.connect(reset)

func reset():
	call_deferred("_reset_deferred")

func _reset_deferred():
	get_tree().reload_current_scene()

func _on_hole_tick_timeout() -> void:
	for car: Car in $Racetrack/CarsPath.get_children():
		car.spawn_hole_attempt()
