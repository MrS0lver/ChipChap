extends CanvasLayer


func _ready() -> void:
	$AnimationPlayer.play("Fade_to_Black")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
