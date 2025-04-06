extends Control

signal on_letter_selected

func initialize(letter : String):
	$Button.text = letter


func get_letter() -> String:
	return $Button.text
	
func _on_button_pressed():
	on_letter_selected.emit()
