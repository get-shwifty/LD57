extends Node2D

class_name Fish

@export var LETTERS : String = ""

signal on_captured;

var is_captured : bool = false;

func _ready():
	$Letters.text = get_letters()

func got_captured():
	if is_captured:
		return;
	$Letters.text = ""
	on_captured.emit();
	is_captured = true;

func get_letters() -> String:
	return LETTERS
