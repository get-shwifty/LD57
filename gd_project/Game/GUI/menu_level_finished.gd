extends Control

signal on_menu_closed;

func initialize(total_points) -> void:
	$Score.text = "Total points: " + str(total_points)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		on_menu_closed.emit()
