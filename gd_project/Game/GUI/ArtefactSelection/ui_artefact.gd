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


func _on_button_bonus_pressed():
	on_selected.emit()


func _on_button_malus_pressed():
	on_selected.emit()
