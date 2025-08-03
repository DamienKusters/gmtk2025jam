extends Area2D
class_name Hole

@export var hole_size = 0

func _ready():
	_render_hole(hole_size)
	$CPUParticles2D.restart()
	$Sprite2D.flip_h = randf_range(0, 1) > .5 # 50 percent of the time, the hole is flipped

func hole_is_max_size() -> bool:
	return hole_size == Global.get_hole_textures().size() -1

func damage_hole():
	hole_size = clampi(hole_size + 1, -1, Global.get_hole_textures().size() -1)
	_render_hole(hole_size)
	$CPUParticles2D.amount = 3
	$CPUParticles2D.restart()
	
func repair_hole():
	hole_size = clampi(hole_size - 1, -1, Global.get_hole_textures().size() -1)
	_render_hole(hole_size)

func _render_hole(size: int):
	$Sprite2D.texture = Global.get_hole_textures()[size]
	#TODO hacky:
	if size < 0:
		call_deferred("queue_free")
