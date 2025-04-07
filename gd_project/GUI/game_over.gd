extends CanvasLayer

@onready var total_points: float = 0.0
signal replay()

func initialize(points: float) -> void:
	$Score.text = "Total points: " + str(total_points)
	$AnimatedSprite2D.play()


func _on_button_pressed() -> void:
	replay.emit()
