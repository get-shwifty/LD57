extends CharacterBody2D
class_name Fish1

signal on_captured(letter)

@export var MOVE_DURATION: float = 2.5
@export_exp_easing var MOVE_EASING = 0.6
@export var MOVE_SPEED: float = 35
@export var MAX_MOVE_SPEED: float = 60
@export var FOLLOWING_DISTANCE: float = 40.0
@export var path_to_follow: Path2D

var curve: Curve2D
var time_since_move_start: float = 0
var last_ease_value: float = 0
@onready var point_following = $Marker2D

func _ready():
	point_following.position.x = FOLLOWING_DISTANCE
	assert(path_to_follow != null)
	curve = path_to_follow.curve
	
	time_since_move_start = randf() * MOVE_DURATION

func get_target():
	return path_to_follow.to_global(
		curve.get_closest_point(
			path_to_follow.to_local(point_following.global_position)))

func _process(_delta: float) -> void:
	$LetterCtn.global_rotation = 0
	$Visual.scale.y = -1 if velocity.x < 0 else 1

func _physics_process(delta: float) -> void:
	time_since_move_start += delta
	if time_since_move_start > MOVE_DURATION:
		time_since_move_start = 0
		last_ease_value = 0

	var normalized_time_since_move_start = time_since_move_start / MOVE_DURATION
	var ease_value = ease(normalized_time_since_move_start, MOVE_EASING)
	var coeff_ease = (ease_value - last_ease_value) / delta * MOVE_DURATION
	last_ease_value = ease_value

	var target = get_target()
	var direction = (target - global_position).normalized()

	velocity = direction * min(MOVE_SPEED * coeff_ease, MAX_MOVE_SPEED)
	move_and_slide()
	look_at(target)

func capture_letter(_collision: KinematicCollision2D):
	on_captured.emit("P")
