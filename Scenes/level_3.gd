extends Node2D


func _on_trap_body_entered(_body: Node2D) -> void:
	$Player.position = position
