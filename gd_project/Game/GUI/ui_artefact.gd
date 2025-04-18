extends Control
class_name UIArtefact

@onready var panel: Panel = $Panel

var timer := 0.0
var is_holded := false
const HOLD_TIMER := 0.2


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
			texture_x = 0
			texture_y = 1
		artefact.TargetType.WordMult:
			texture_x = 1
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
			
			
func _process(delta):
	if is_holded:
		timer += delta
		if timer > HOLD_TIMER:
			global_position = get_global_mouse_position()
			#if get_index() - 1 >= 0 and get_index() + 1 <= len(container.get_children()) - 1:
			var next_child = null if get_index() == len(get_parent().get_children()) - 1 else get_parent().get_child(get_index() + 1)
			var previous_child = null if get_index() == 0 else get_parent().get_child(get_index() - 1)
			if next_child and next_child.global_position.y < global_position.y:
				get_parent().move_child(self, get_index() + 1)
			if previous_child and previous_child.global_position.y > global_position.y:
				get_parent().move_child(self, get_index() - 1)
				
func _on_button_mouse_entered():
	panel.show()

func hide_artefact_popup():
	panel.hide()

func _on_button_button_down() -> void:
	is_holded = true

func _on_button_button_up() -> void:
	if is_holded:
		if timer > HOLD_TIMER:
			get_parent().queue_sort()
		is_holded = false
		timer = 0
