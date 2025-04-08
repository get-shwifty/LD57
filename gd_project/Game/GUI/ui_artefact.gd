extends Control
class_name UIArtefact

@onready var panel: Panel = $Panel

var artefact: Artefact

func initialize(artefact : Artefact):
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
			texture_x = 2
			texture_y = 1
		artefact.TargetType.WordMult:
			texture_x = 3
			texture_y = 1
		artefact.TargetType.LetterFishType:
			texture_x = 0
			texture_y = 2
	if artefact.is_malus:
		$Button.modulate = Color('b20044')
		texture_x += 2
	else:
		$Button.modulate = Color('00fdd0')
	$Button/TextureRect.texture.set_region(Rect2(texture_x * 10, texture_y * 10, 10, 10))
	%Nom.text = artefact.name
	%Description.text = artefact.description
	#$Button.scale.y = 0.3
	#$Button.scale.x = 0.6

func _on_button_mouse_entered():
	panel.show()

func hide_artefact_popup():
	panel.hide()
