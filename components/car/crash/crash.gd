extends AnimatedSprite2D

func _on_animation_looped() -> void:
	call_deferred("queue_free")
