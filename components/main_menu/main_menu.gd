extends Node2D

func _on_button_2_pressed() -> void:
	Global.load_game("res://components/pre-game/pre_game.tscn")


func _on_button_3_pressed() -> void:
	Global.save.cache = Global.save.template
	Global.save.save_file()
	$CanvasLayer/Control/Background/Content/Button3.text = "Save file reset\nReload browser window"
