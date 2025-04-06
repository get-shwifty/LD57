extends Node2D
class_name Oxygen

signal on_oxygen_depleted

@export var START_OXYGEN: float = 5.1
@export var OXYGEN_CONSUMPTION_RATE: float = 1.0 / 60.0

var current_oxygen: float
var lost_all_oxygen: bool

func _ready():
	current_oxygen = START_OXYGEN
	lost_all_oxygen = false

func _physics_process(delta: float) -> void:
	if lost_all_oxygen:
		return
	var consumed_oxygen = OXYGEN_CONSUMPTION_RATE * delta
	current_oxygen -= consumed_oxygen
	if current_oxygen <= 0:
		on_oxygen_depleted.emit()
		lost_all_oxygen = true
	else:
		$Label.text = str(current_oxygen).pad_decimals(1)
