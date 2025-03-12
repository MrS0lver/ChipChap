extends CanvasLayer

func _ready() -> void:
	$AnimatedSprite2D.play("Fontain")
	$SHOWPlayer.play("IDLE")
	$AudioStreamPlayer2D.play()
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn") # Replace with function body.


func _on_button_2_pressed() -> void:
	get_tree().quit() # Replace with function body.
