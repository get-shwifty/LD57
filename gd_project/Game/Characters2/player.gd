extends CharacterBody2D
class_name Player

@export var MOVE_SPEED : float = 90

@onready var harpoon: Harpoon = $Harpoon
@onready var oxygen: Oxygen = $Oxygen

func _physics_process(_delta: float) -> void:
	var hinput = Input.get_axis("move_left", "move_right")
	var vinput = Input.get_axis("move_up", "move_down")
	var input = Vector2(hinput, vinput).normalized()
	var wanna_move = input.length() > 0
	
	if wanna_move:
		harpoon.rotation = input.angle()
	
	if Input.is_action_just_pressed("fire"):
		harpoon.fire()

	velocity = input * MOVE_SPEED
	move_and_slide()
