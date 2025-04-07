extends Control
class_name UIArtefact

@onready var panel: Panel = $Panel

var artefact: Artefact

func initialize(artefact : Artefact):
	var texture_index = 0
	
	match artefact.TargetType:
		artefact.TargetType.LetterAdd:
			texture_index = 0
		artefact.TargetType.LetterMult:
			texture_index = 1
		artefact.TargetType.WordAdd:
			texture_index = 2
		artefact.TargetType.WordMult:
			texture_index = 3
	$Button.texture_normal.set_region(Rect2(texture_index * 24, 0, 24, 27))
	$Panel/Label.set_text("DESCRIPTION")

func _on_button_mouse_entered():
	panel.show()

func hide_artefact_popup():
	panel.hide()
