extends Node2D

func _ready() -> void:
	$CollisionShape2D/AnimationPlayer.play("Chage pos")
	$"Moving Animated".play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Colliding")
	
	
