extends CanvasLayer

func _ready() -> void:
	$AnimatedSprite2D.play("Fontain")
	$SHOWPlayer.play("IDLE")
	MusicMenager.set_track(MusicMenager.MAIN_MENU_TRACK)
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn") # Replace with function body.
	MusicMenager.set_track(MusicMenager.BASE_LEVEL_TRACK)


func _on_button_2_pressed() -> void:
	get_tree().quit() # Replace with function body.
