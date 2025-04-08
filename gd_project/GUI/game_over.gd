extends CanvasLayer

signal replay()

func initialize(points: float, reason="") -> void:
	$Score.text = "Total points: " + str(points)
	$AnimatedSprite2D.play()
	$Reason.text = reason


func _on_button_pressed() -> void:
	replay.emit()
