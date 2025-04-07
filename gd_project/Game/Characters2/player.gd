extends CharacterBody2D
class_name Player

@export var MOVE_SPEED : float = 90

@onready var harpoon: Harpoon = $Harpoon
@onready var oxygen: Oxygen = $Oxygen
@onready var harpoonFire: AudioStreamPlayer =$Harpoon/HarpoonFire
@onready var moveSound: AudioStreamPlayer =$Move
@onready var breath: AudioStreamPlayer = $Breath

var sound_bank := [
	preload("res://assets/sounds/bruitages/player/SON-RESPIRATION-1.mp3"),
	preload("res://assets/sounds/bruitages/player/SON-RESPIRATION-2.mp3"),
	preload("res://assets/sounds/bruitages/player/SON-RESPIRATION-3.mp3"),
	preload("res://assets/sounds/bruitages/player/SON-RESPIRATION-4.mp3")
]
var timer := 0.0
var interval := 17
var time_since_last_sound := 0.0
var movement_sound_cooldown := 15

func _ready():
	randomize()

func _process(delta: float) -> void:
	
	_play_random_breath_sound(delta)
	
	if velocity.x != 0:
		var scale_x = -1 if velocity.x < 0 else 1
		$Visual.scale.x = scale_x
		$CollisionShape2DL.disabled = scale_x > 0
		$CollisionShape2DR.disabled = not $CollisionShape2DL.disabled
		
	time_since_last_sound += delta
	if velocity.length() > 0.1:  # ou juste "velocity != Vector2.ZERO"
		if time_since_last_sound >= movement_sound_cooldown:
			moveSound.play()
			time_since_last_sound = 0.0

func _physics_process(_delta: float) -> void:
	var hinput = Input.get_axis("move_left", "move_right")
	var vinput = Input.get_axis("move_up", "move_down")
	var input = Vector2(hinput, vinput).normalized()
	var wanna_move = input.length() > 0
	
	if wanna_move:
		harpoon.rotation = input.angle()
	
	if Input.is_action_just_pressed("fire"):
		harpoon.fire()
		harpoonFire.play()
	
	velocity = input * MOVE_SPEED
	move_and_slide()

func _play_random_breath_sound(delta: float) -> void:
	timer += delta
	if timer >= interval:
		timer = 0
		var random_index = randi() % sound_bank.size()
		breath.stream = sound_bank[random_index]
		breath.pitch_scale = randf_range(0.68, 0.8)
		breath.volume_db = -17
		print("Joue le son:", breath.stream)
		breath.play()
