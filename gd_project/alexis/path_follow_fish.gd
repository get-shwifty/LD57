extends PathFollow2D

@export var MOVE_DURATION: float = 1.5
@export_exp_easing var MOVE_EASING 
@export var MOVE_SPEED: float = 100

var time_since_move_start: float = 0
var last_ease_value: float = 0

func _physics_process(delta: float) -> void:
	time_since_move_start += delta
	if time_since_move_start > MOVE_DURATION:
		time_since_move_start = 0
		last_ease_value = 0
	
	var normalized_time_since_move_start = time_since_move_start / MOVE_DURATION
	var ease_value = ease(normalized_time_since_move_start, MOVE_EASING)
	var coeff_ease = (ease_value - last_ease_value) / delta * MOVE_DURATION
	last_ease_value = ease_value
	progress += delta * MOVE_SPEED * coeff_ease
