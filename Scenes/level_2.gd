extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$PortalOpen.pla
	$Node2D/MOver.play("MOVE")






func _on_end_body_entered(body: Node2D) -> void:
	print("Done") # Replace with function body.
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")
