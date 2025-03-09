extends PathFollow2D

var speed = 90


func _process(delta: float) -> void:
	progress += delta * speed
