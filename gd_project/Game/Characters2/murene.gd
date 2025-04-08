extends CharacterBody2D
class_name Murene

signal on_captured()

@export var MOVE_DURATION: float = 2.5
@export_exp_easing var MOVE_EASING = 0.250
@export var MOVE_SPEED: float = 100
@export var MAX_MOVE_SPEED: float = 300
@export var path_to_follow: Path2D
@export var forward: bool = true

var path_follow: PathFollow2D
var time_since_move_start: float = 0
var last_ease_value: float = 0
var moving = true
var player_nearby = false

func _ready():
	assert(path_to_follow != null)
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	path_to_follow.add_child(path_follow)
	path_follow.progress = path_to_follow.curve.get_closest_offset(path_to_follow.to_local(global_position))
	position = Vector2.ZERO
	call_deferred("reparent", path_follow, false)

func _process(_delta: float) -> void:
	$Visual.scale.x = 1 if forward else -1

func _physics_process(delta: float) -> void:
	if not moving:
		if player_nearby:
			moving = true
			time_since_move_start = 0
		else:
			return

	time_since_move_start += delta

	if forward:
		if path_follow.progress_ratio >= 1.0:
			forward = not forward
			moving = false
	else:
		if path_follow.progress_ratio <= 0.0:
			forward = not forward
			moving = false

	var normalized_time_since_move_start = min(time_since_move_start / MOVE_DURATION, 1.0)
	var ease_value = ease(normalized_time_since_move_start, MOVE_EASING)
	var coeff_ease = (ease_value - last_ease_value) / delta * MOVE_DURATION
	last_ease_value = ease_value

	var x = clamp(MOVE_SPEED * coeff_ease, MOVE_SPEED, MAX_MOVE_SPEED) * delta
	path_follow.progress += x * (1 if forward else -1)

func set_letter(c: String):
	$LetterCtn/Label.text = c

func capture_letter(_collision: KinematicCollision2D):
	on_captured.emit()
	queue_free()


func _on_detect_player_body_entered(body: Node2D) -> void:
	player_nearby = true

func _on_detect_player_body_exited(body: Node2D) -> void:
	player_nearby = false
