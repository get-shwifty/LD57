extends Node2D
class_name Harpoon

@export var GRAVITY : float = 142
@export_category("Projectile")
@export var PROJ_START_SPEED: float = 300
@export var PROJ_END_SPEED: float = 200
@export_exp_easing("attenuation") var PROJ_EASE = 3.5
@export var PROJ_EASE_DURATION = 0.2
@export var PROJ_DEST_DURATION = 0.4

@onready var projectile_start: Node2D = $ProjectileStart
@onready var projectile: CharacterBody2D = $Projectile

enum { ARMED, FIRED, RETURNING }
var state = ARMED

var projectile_velocity: Vector2
var projectile_fired_time : float

func _ready() -> void:
	projectile.top_level = true
	reset_projectile()

func _physics_process(delta: float) -> void:
	if state == FIRED:
		if projectile_velocity.length() > 0:
			# speed
			var speed = PROJ_END_SPEED
			if projectile_fired_time < PROJ_EASE_DURATION:
				var t = ease(projectile_fired_time / PROJ_EASE_DURATION, PROJ_EASE)
				speed = lerp(PROJ_START_SPEED, PROJ_END_SPEED, t)
			projectile_velocity = projectile_velocity.limit_length(speed)
			
			projectile_velocity.y += GRAVITY * delta
			projectile.rotation = projectile_velocity.angle()
			
			var collision = projectile.move_and_collide(projectile_velocity * delta)
			if collision:
				var collider = collision.get_collider()
				if collider.has_method("capture_letter"):
					collider.capture_letter(collision)
				projectile_velocity = Vector2.ZERO
			projectile_fired_time = -PROJ_DEST_DURATION
		elif projectile_fired_time < 0:
			projectile_fired_time += delta
		else:
			reset_projectile()
	else:
		reset_projectile()

func reset_projectile():
	projectile.position = to_global(projectile_start.position)
	projectile.rotation = rotation
	state = ARMED

func fire():
	if state == FIRED:
		reset_projectile()
	else:
		state = FIRED
		var delta = to_global(projectile_start.position) - global_position
		projectile_velocity = delta * PROJ_START_SPEED
		projectile_fired_time = 0.0
