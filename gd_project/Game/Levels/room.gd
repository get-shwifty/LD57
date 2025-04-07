extends Node
class_name LevelRoom

@export var width: int = 320 * 2
@export var height: int = 180 * 2

signal on_captured(letter)

func _ready():
	var cam: Camera2D = $Player/Harpoon/Projectile/Camera2D
	cam.limit_right = width
	cam.limit_bottom = height

func set_letters(letters):
	for child in get_children():
		if child.has_signal("on_captured"):
			var letter: Letter = letters.pop_front()
			child.set_letter(letter.character.character)
			child.on_captured.connect(on_captured.emit.bind(letter))
