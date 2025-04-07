extends Control
class_name UILetter

signal on_letter_selected

var letter: Letter;
@onready var points: Label = %Points;

func initialize(letter_ : Letter):
	letter = letter_
	%Letter.text = letter.character.character
	%Points.text = str(letter.character.base_value)
	var texture_index = 0
	match letter.fish_type:
		Letter.FishType.Medusa:
			texture_index = 1
		Letter.FishType.Crab:
			texture_index = 2
		Letter.FishType.Eel:
			texture_index = 3
		Letter.FishType.Clown:
			texture_index = 0
			
	$Button.texture_normal.set_region(Rect2(texture_index * 24, 0, 24, 27))


func get_letter() -> Letter:
	return letter
	
func _on_button_pressed():
	on_letter_selected.emit()


func _on_button_mouse_entered() -> void:
	position.y -= 5


func _on_button_mouse_exited() -> void:
	position.y += 5 # Replace with function body.
