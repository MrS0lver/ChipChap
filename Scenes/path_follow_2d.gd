extends PathFollow2D

var speed = 180


func _process(delta: float) -> void:
	progress += delta * speed
