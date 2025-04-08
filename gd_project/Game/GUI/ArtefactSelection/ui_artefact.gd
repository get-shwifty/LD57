extends CenterContainer

signal on_selected

func initialize(artefact : Artefact):
	if !artefact.is_malus:
		$ButtonMalus.hide()
		$ButtonBonus.show()
	else :
		$ButtonMalus.show()
		$ButtonBonus.hide()
	
	$HBoxContainer/Title.text = artefact.name
	$HBoxContainer/Description.text = artefact.description
	add_icon(artefact)


func _on_button_bonus_pressed():
	on_selected.emit()


func _on_button_malus_pressed():
	on_selected.emit()

func _on_mouse_entered():
	position.y -= 5

func _on_mouse_exited():
	position.y += 5

func add_icon(artefact : Artefact):
	var texture_x = 0
	var texture_y = 0
	#
	match artefact.target:
		artefact.TargetType.LetterAdd:
			texture_x = 0
			texture_y = 0
		artefact.TargetType.LetterMult:
			texture_x = 1
			texture_y = 0
		artefact.TargetType.WordAdd:
			texture_x = 0
			texture_y = 1
		artefact.TargetType.WordMult:
			texture_x = 1
			texture_y = 1
		artefact.TargetType.LetterFishType:
			texture_x = 0
			texture_y = 2

	%Icon.texture.set_region(Rect2(texture_x * 10, texture_y * 10, 10, 10))
