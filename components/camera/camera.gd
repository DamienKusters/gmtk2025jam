extends Camera2D

@export var player: Player

func _process(_delta: float) -> void:
	position = player.position
