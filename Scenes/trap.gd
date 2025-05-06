extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Chage pos")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("Colliding")
	
	
