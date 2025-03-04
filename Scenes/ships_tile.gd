extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(1,0) * 20 * delta

func _on_area_body_entered(body: Node2D) -> void:
	print("Entered!")# Replace with function body.
	if body.name == "Player":
		print("Yes")
		add_child(body)



func _on_area_body_exited(body: Node2D) -> void:
	print("Exited!")
