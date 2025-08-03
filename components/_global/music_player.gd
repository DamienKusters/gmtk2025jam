extends AudioStreamPlayer
class_name MusicPlayer

var music = {
	'garage': preload("res://components/_global/Garage.mp3"),
	'pitstop': preload("res://components/_global/LETS GO Pitstop!.mp3"),
}

func play_music(key: String):
	stream = music[key]
	play()
