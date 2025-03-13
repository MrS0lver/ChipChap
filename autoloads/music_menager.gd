extends AudioStreamPlayer

@export var tracks: Dictionary[GameTrack, AudioStream]

enum GameTrack {
	MainMenuTrack,
	BaseLevelTrack
}

const MAIN_MENU_TRACK: = GameTrack.MainMenuTrack
const BASE_LEVEL_TRACK: = GameTrack.BaseLevelTrack



func _ready() -> void:
	finished.connect(_on_finished)

func set_track(track: GameTrack):
	stop()
	stream = tracks.get(track)
	play()

func _on_finished(): 
	play()
