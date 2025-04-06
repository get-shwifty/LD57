extends PathFollow2D

func _physics_process(delta: float) -> void:
	progress += delta * 50
