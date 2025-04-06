extends Node2D

@export var MOVE_SPEED : float = 500
@export var START_OXYGEN : float = 1
@export var OXYGEN_CONSUMPTION_RATE : float = 1

signal on_oxygen_depleted;

var current_oxygen :float;
var lost_all_oxygen : bool

func _ready():
	current_oxygen = START_OXYGEN
	lost_all_oxygen = false;

func _process(delta: float) -> void:
	process_movement(delta)
	process_capture(delta)
	process_oxygen_consumption(delta)

func process_oxygen_consumption(delta : float) -> void :
	if lost_all_oxygen:
		return
	var consumed_oxygen = OXYGEN_CONSUMPTION_RATE * delta;
	current_oxygen -= consumed_oxygen;
	$Oxygen.text = str(current_oxygen).pad_decimals(1);
	if current_oxygen <= 0:
		on_oxygen_depleted.emit()
		lost_all_oxygen = true
	

func process_capture(delta: float) -> void:
	if Input.is_action_just_pressed("game_capture"):
		capture_nearby_fish()
	
func process_movement(delta: float) -> void:
	var movement_vector : Vector2 = Vector2.ZERO;
	if Input.is_action_pressed("move_up"):
		movement_vector.y += -1;
	if Input.is_action_pressed("move_down"):
		movement_vector.y += 1;
	if Input.is_action_pressed("move_left"):
		movement_vector.x += -1;
	if Input.is_action_pressed("move_right"):
		movement_vector.x += 1;
	
	movement_vector *= MOVE_SPEED;
	movement_vector *= delta;
	
	position += movement_vector;
	
	
func capture_nearby_fish():
	var fishes = $Area2D.get_overlapping_areas()
	for f in fishes:
		var fish : Fish = f.get_parent();
		fish.got_captured()
		
