extends Control
class_name UILetter

signal on_letter_selected

var letter: Letter
@onready var points: Label = %Points

func initialize(letter_ : Letter):
	letter = letter_
	%Letter.text = letter.character.character
	%Points.text = str(letter.character.base_value)
	var texture_index = 0
	var fish_texture = 0
	match letter.fish_type:
		Letter.FishType.Medusa: #1
			texture_index = 1
			fish_texture = 1
		Letter.FishType.Crab: #0
			texture_index = 2
			fish_texture = 3
		Letter.FishType.Eel: #3
			texture_index = 3
			fish_texture = 2
		Letter.FishType.Clown: #2
			texture_index = 0
			fish_texture = 0
	
	print("TYPE")
	print(letter.fish_type)
	print(texture_index)
	print(fish_texture)
	$Button.texture_normal.set_region(Rect2(texture_index * 24, 0, 24, 27))
	$Button/PanelContainer/Fish.texture.set_region(Rect2(fish_texture * 10, 11, 10, 9))

func get_letter() -> Letter:
	return letter
	
func _on_button_pressed():
	on_letter_selected.emit()


func _on_button_mouse_entered() -> void:
	position.y -= 5


func _on_button_mouse_exited() -> void:
	position.y += 5 # Replace with function body.
	
