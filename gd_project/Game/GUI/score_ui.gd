extends Control
class_name Score

var objective:
	set(value):
		objective = value
		$VBoxContainer/HBoxContainer/Label2.text = str(value)

var current:
	set(value):
		current = value
		$VBoxContainer/HBoxContainer2/Label2.text = str(value)

var oxygen:
	set(value):
		$VBoxContainer/HBoxContainer3/Label2.text = str(value).pad_decimals(1)

func _ready():
	current = 0
