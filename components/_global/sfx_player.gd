# Code copied and modified from Rapid Survival

extends Node
class_name Sfx

var sfx = {
	'restock': preload("res://components/_global/restock.wav"),
	'pop': preload("res://components/_global/pop.wav"),
	'fix_road': preload("res://components/_global/fix_road.wav"),
	'car_destroyed': preload("res://components/_global/car_destroyed.wav"),
	"win": preload("res://components/game_over_screen/win.mp3"),
	"lose_crash": preload("res://components/game_over_screen/crashed.mp3"),
	"lose_kill": preload("res://components/game_over_screen/runover.mp3"),
}

func play_sfx(sfx_key: String):
	if !sfx.has(sfx_key):
		print_debug('[Sfx] ' + str(sfx_key) + ' does not exist')
		return
	randomize()
	var s = AudioStreamPlayer.new()
	s.stream = sfx[sfx_key]
	s.volume_db = -5
	s.pitch_scale = randf_range(.9, 1.1)
	s.bus = 'Sfx'
	s.mix_target = AudioStreamPlayer.MIX_TARGET_SURROUND
	s.finished.connect(func(): s.queue_free())
	s.autoplay = true
	add_child(s)
