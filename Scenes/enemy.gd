extends AnimatableBody2D

func _physics_process(delta: float) -> void:
	$Animation.play("Idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Animation.flip_h = true # Replace with function body.
	print("yes")



func _on_area_2d_body_exited(body: Node2D) -> void:
	# Replace with function body.
	$Animation.flip_h = false # 
