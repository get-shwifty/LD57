extends Control

signal on_menu_closed;

func initialize(finished_level : GameLevel) -> void:
	$Score.text = str(finished_level.get_score())
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		on_menu_closed.emit()
