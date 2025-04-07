extends Control
class_name UILetter

signal on_letter_selected

var letter: Letter
@onready var points: Label = %Points

func initialize(letter_ : Letter):
	letter = letter_
	%Letter.text = letter.character.character
	%Points.text = str(letter.character.base_value)
	update_type(letter.fish_type)
	update_bonus(letter.bonus_type)

func update_type(type: Letter.FishType):
	var texture_index = 0
	match type:
		Letter.FishType.Medusa:
			texture_index = 1
		Letter.FishType.Crab:
			texture_index = 2
		Letter.FishType.Eel:
			texture_index = 3
		Letter.FishType.Clown:
			texture_index = 0
	$Button.texture_normal.set_region(Rect2(texture_index * 24, 0, 24, 27))

func update_bonus(bonus: Letter.BonusType):
	var texture_index = 0
	match bonus:
		Letter.BonusType.None:
			texture_index = -1
		Letter.BonusType.LetterMult1:
			texture_index = 0
		Letter.BonusType.LetterMult2:
			texture_index = 2
		Letter.BonusType.WordMult1:
			texture_index = 1
		Letter.BonusType.WordMult2:
			texture_index = 3
	if texture_index != -1:
		$Cadre.texture.set_region(Rect2(texture_index * 27, 0, 27, 31))
		$Cadre.visible = true
	else:
		$Cadre.visible = false
	
	
func get_letter() -> Letter:
	return letter
	
func _on_button_pressed():
	on_letter_selected.emit()


func _on_button_mouse_entered() -> void:
	position.y -= 5


func _on_button_mouse_exited() -> void:
	position.y += 5 # Replace with function body.
	
