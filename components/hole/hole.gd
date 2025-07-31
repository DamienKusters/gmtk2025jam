extends Area2D
class_name Hole

@onready var game: Game = get_tree().get_current_scene()

var hole_size = 0

func _ready():
	_render_hole(hole_size)

func damage_hole():
	hole_size += 1
	_render_hole(hole_size)
	
func repair_hole():
	hole_size -= 1
	_render_hole(hole_size)

func _render_hole(size: int):
	$Sprite2D.texture = game.get_hole_textures()[clamp(size, 0, game.get_hole_textures().size() -1)]
