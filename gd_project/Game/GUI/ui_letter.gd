extends Control
class_name UILetter

signal on_letter_selected
var letter: Letter

# variables for the drag
var timer := 0.0
var is_holded := false
const HOLD_TIMER := 0.2

@onready var pos0 = position.y
@onready var points: Label = %Points
@onready var container = get_parent()
@onready var root = container.owner

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		var mouse_pos = get_viewport().get_mouse_position()
		if not event.is_pressed():
			if is_holded:

				#reparent(container)

				for i in range(len(container.get_children())):
					var letter = container.get_child(i)
					if letter.global_position.x > global_position.x:
						reparent(container)
						container.move_child(self, i)
						break
				reparent(container)
				is_holded = false
				timer = 0
			
func _process(delta: float) -> void:
	if is_holded:
		timer += delta
		if timer > HOLD_TIMER:
			var viewport = get_viewport()
			if get_parent() == container:
				reparent(root)
			global_position = viewport.get_mouse_position()

	
func initialize(letter_ : Letter):
	letter = letter_
	%Letter.text = letter.character.character
	%Points.text = str(letter.character.base_value)
	update_type(letter.fish_type)
	update_bonus(letter.bonus_type)

func update_type(type: Letter.FishType):
	var texture_index = 0
	var fish_texture = 0
	match type:
		Letter.FishType.Medusa:
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
	
	$Button.texture_normal.set_region(Rect2(texture_index * 24, 0, 24, 27))
	$Button/PanelContainer/Fish.texture.set_region(Rect2(fish_texture * 10, 11, 10, 9))

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
		$Button/Cadre.texture.set_region(Rect2(texture_index * 27, 0, 27, 31))
		$Button/Cadre.visible = true
	else:
		$Button/Cadre.visible = false
	
	
func get_letter() -> Letter:
	return letter
	
func _on_button_pressed():
	on_letter_selected.emit()


func _on_button_mouse_entered() -> void:
	position.y -= 3


func _on_button_mouse_exited() -> void:
	position.y += 5 # Replace with function body.
	


func _on_button_button_down() -> void:
	is_holded = true


func _on_button_button_up() -> void:
	if timer < HOLD_TIMER:
		on_letter_selected.emit()
	
