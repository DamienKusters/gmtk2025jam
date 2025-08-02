extends Control
class_name PreGamePopup

func _ready():
	visible = false

func show_message(message: String):
	visible = true
	$Label.text = message

func _on_button_pressed() -> void:
	visible = false
