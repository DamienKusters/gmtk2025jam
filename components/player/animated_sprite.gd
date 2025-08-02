extends AnimatedSprite2D
class_name AnimatedPlayer

enum Direction {UP,DOWN,LEFT,RIGHT}

@export var moving = false
@export var direction: Direction

func _process(_delta: float) -> void:
	var animation_string: String
	flip_h = direction == Direction.LEFT
	
	match direction:
		Direction.UP:
			animation_string = &"walk_up"
		Direction.DOWN:
			animation_string = &"walk_down"
		_:
			animation_string = &"walk_sideways"
	
	play(animation_string)
	if moving == false:
		set_frame_and_progress(0, 0)
