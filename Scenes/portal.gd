extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	print("SomeThing is Inside!")
	$PortalOpen.play("Open") # Replace with function body.


func _on_collision_polygon_2d_child_entered_tree(node: Node) -> void:
	get_tree().quit() # Replace with function body.
