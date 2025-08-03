extends Control

signal _selected_screen_updated

@onready var screens = [ %Story1, %Story2, %Story3, %Story4, %Story5, %Story6, %Story7 ]

var selected_screen = 0:
	set(value):
		var clamped = clampi(value, 0, screens.size() - 1)
		selected_screen = clamped
		_selected_screen_updated.emit(clamped)

func _ready():
	_selected_screen_updated.connect(_update_screen)
	_update_screen(0)

func _update_screen(screen: int):
	for s in screens:
		s.visible = false
	screens[screen].visible = true

func _on_button_pressed() -> void:
	selected_screen -= 1

func _on_button_2_pressed() -> void:
	selected_screen += 1
	pass # Replace with function body.
