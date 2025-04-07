extends Control

signal on_letter_selected

func initialize(letter : String, points: int, texture: int):
	%Letter.text = letter
	%Points.text = str(points)
	$Button.texture_normal.set_region(Rect2(texture * 24, 0, 24, 27))


func get_letter() -> String:
	return %Letter.text
	
func _on_button_pressed():
	on_letter_selected.emit()


func _on_button_mouse_entered() -> void:
	position.y -= 5


func _on_button_mouse_exited() -> void:
	position.y += 5 # Replace with function body.
