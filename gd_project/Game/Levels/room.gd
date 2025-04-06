extends Node
class_name LevelRoom

signal on_captured(letter)

func set_letters(letters):
	for child in get_children():
		if child is Fish:
			# TODO set letter
			child.on_captured.connect(on_captured.emit)
