extends AudioStreamPlayer2D

const level_music = preload("res://Music/game-music-loop-7-145285.mp3")
func _play_music(music : AudioStream, volume = 0.0):
	if stream == music:
		return 
	stream = music
	volume_db = volume
	
func play_music():
	_play_music(level_music)
	
