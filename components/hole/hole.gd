extends Area2D
class_name Hole

var hole_size = 0

func _ready():
	_render_hole(hole_size)
	$CPUParticles2D.restart()

func damage_hole():
	hole_size += 1
	_render_hole(hole_size)
	
func repair_hole():
	hole_size -= 1
	_render_hole(hole_size)

func _render_hole(size: int):
	$Sprite2D.texture = Global.get_hole_textures()[clamp(size, 0, Global.get_hole_textures().size() -1)]
	#TODO hacky:
	if size < 0:
		call_deferred("queue_free")
