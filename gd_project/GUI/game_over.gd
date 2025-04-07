extends CanvasLayer

signal replay()

func initialize(points: float) -> void:
	$Score.text = "Total points: " + str(points)
	$AnimatedSprite2D.play()


func _on_button_pressed() -> void:
	replay.emit()
