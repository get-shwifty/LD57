extends CharacterBody2D
class_name Jelly

signal on_captured()

@export var MOVE_DURATION: float = 5.0
@export_exp_easing var MOVE_EASING = 0.37
@export var MOVE_SPEED: float = 35
@export var MAX_MOVE_SPEED: float = 60
@export var path_to_follow: Path2D
@export var forward: bool = true

var path_follow: PathFollow2D
var time_since_move_start: float = 0
var last_ease_value: float = 0

func _ready():
	assert(path_to_follow != null)
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	path_follow.rotates = false
	path_follow.v_offset = -6
	path_to_follow.add_child(path_follow)
	path_follow.progress = path_to_follow.curve.get_closest_offset(path_to_follow.to_local(global_position))
	position = Vector2.ZERO
	call_deferred("reparent", path_follow, false)

	time_since_move_start = randf() * MOVE_DURATION

func _process(_delta: float) -> void:
	$LetterCtn.global_rotation = 0
	$Visual.scale.y = -1 if velocity.x < 0 else 1

func _physics_process(delta: float) -> void:
	time_since_move_start += delta
	if time_since_move_start > MOVE_DURATION:
		time_since_move_start = 0
		last_ease_value = 0

	if forward:
		if path_follow.progress_ratio >= 1.0:
			forward = not forward
	else:
		if path_follow.progress_ratio <= 0.0:
			forward = not forward

	var normalized_time_since_move_start = time_since_move_start / MOVE_DURATION
	var ease_value = ease(normalized_time_since_move_start, MOVE_EASING)
	var coeff_ease = (ease_value - last_ease_value) / delta * MOVE_DURATION
	last_ease_value = ease_value

	var x = min(MOVE_SPEED * coeff_ease, MAX_MOVE_SPEED) * delta
	if forward:
		path_follow.progress += x
	else:
		path_follow.progress -= x

func set_letter(c: String):
	$LetterCtn/Label.text = c

func capture_letter(_collision: KinematicCollision2D):
	on_captured.emit()
	queue_free()
