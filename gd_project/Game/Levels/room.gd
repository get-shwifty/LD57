extends Node
class_name LevelRoom

signal on_captured(letter)

func set_letters(letters):
	for child in get_children():
		if child.has_signal("on_captured"):
			var letter: Letter = letters.pop_front()
			child.set_letter(letter.character.character)
			child.on_captured.connect(on_captured.emit.bind(letter))
