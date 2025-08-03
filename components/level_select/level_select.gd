extends Node2D

var level_id_to_racetrack = {
	# Tutorial
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	# Loop
	6: 2,
	7: 2,
	8: 2,
	9: 2,
	10: 2,
	# Big map
	11: 1,
	12: 1,
	13: 1,
	14: 1,
	15: 1,
}

# haha im done
@onready var medals = [
	$CanvasLayer/Content/VBoxContainer/Control/TextureButton/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control/TextureButton2/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control/TextureButton3/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control/TextureButton4/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control/TextureButton5/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control2/TextureButton/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control2/TextureButton2/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control2/TextureButton3/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control2/TextureButton4/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control2/TextureButton5/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control3/TextureButton/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control3/TextureButton2/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control3/TextureButton3/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control3/TextureButton4/TextureRect,
	$CanvasLayer/Content/VBoxContainer/Control3/TextureButton5/TextureRect,
]

func _ready():
	print(Global.save.get_unlocked_levels())
	var i = 1
	for medal in medals:
		medal.visible = Global.save.has_unlocked_level(i)
		i += 1

func level_select_button_pressed(level_id: int):
	Global.selected_racetrack = level_id_to_racetrack[level_id]
	Global.selected_difficulty = floor(fposmod(level_id - 1, 5) * 1.8) # exponential difficulty
	Global.selected_level = level_id # dumb and cringe
	print("Racetrack: " + str(Global.selected_racetrack))
	print("Difficulty: " + str(Global.selected_difficulty))
	Global.load_game("res://components/pre-game/pre_game.tscn")

func _on_button_pressed() -> void:
	Global.load_game("res://components/main_menu/main_menu.tscn")
