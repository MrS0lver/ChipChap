extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../TRANS".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	print("SomeThing is Inside!")
	$PortalOpen.play("Open") # Replace with function body.
	$MoutOpen.play()
	await $PortalOpen.animation_finished
	$"../TRANS".visible = true


func _on_portal_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://Scenes/transition.tscn")


func _on_body_exited(body: Node2D) -> void:
	$"../TRANS".visible = false
	$PortalOpen.play("Close")
	 # Replace with function body.
	#await $PortalOpen.animation_finished
	$MoutClose.play()
