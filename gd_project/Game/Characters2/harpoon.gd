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
@onready var bonus : Label = $Projectile/Bonus
@onready var projectileTouch: AudioStreamPlayer =$ProjectileTouch

enum { ARMED, FIRED, RETURNING }
var state = ARMED

var projectile_velocity: Vector2
var projectile_fired_time : float

func _ready() -> void:
	projectile.top_level = true
	reset_projectile()

func _physics_process(delta: float) -> void:
	if state == FIRED:
		if bonus:
			bonus.visible = true
			get_bonus_type()
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
				global_position.distance_to(projectile.global_position)
				var collider = collision.get_collider()
				if collider.has_method("capture_letter"):
					var bonus_type = get_bonus_type()
					collider.capture_letter(collision, bonus_type)
					projectileTouch.play()
				projectile_velocity = Vector2.ZERO
			projectile_fired_time = -PROJ_DEST_DURATION
		elif projectile_fired_time < 0:
			projectile_fired_time += delta
		else:
			reset_projectile()
	else:
		reset_projectile()

func get_bonus_type():
	var previous_mult = %Bonus.text
	var bonus_type: Letter.BonusType = Letter.BonusType.None
	var distance = global_position.distance_to(projectile.global_position)
	var text = ""
	if distance < 125:
		text = ""
	elif distance < 200:
		text = "letter x2"
		bonus_type = Letter.BonusType.LetterMult1
	elif distance < 275:
		text = "letter x3"
		bonus_type = Letter.BonusType.LetterMult2
	elif distance < 350:
		text = "word x2"
		bonus_type = Letter.BonusType.WordMult1
	else:
		text = "word x3"
		bonus_type = Letter.BonusType.WordMult2
	%Bonus.text = text
	if distance > 200:
		pass
	if previous_mult != text:
		%Bonus.scale = Vector2(1.5, 1.5)
		var tween = get_tree().create_tween()
		tween.tween_property(%Bonus, "scale", Vector2(1, 1), 0.25)
		#await tween.finished
	return bonus_type
		
func reset_projectile():
	if bonus:
		bonus.text = ""
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

func display_text(string):
	var feedback = Label.new()
	feedback.text = string
	feedback.set("theme_override_constants/outline_size", 2)
	feedback.set("theme_override_colors/font_outline", Color.BLACK)
	feedback.add_theme_font_override("font", load("res://assets/fonts/Square.ttf"))
	feedback.scale = Vector2(2, 1.7)
	feedback.position.y -= 5
	projectile.add_child(feedback)
	
	var tween_pos: Tween = get_tree().create_tween()
	tween_pos.tween_property(feedback, "position", feedback.position + Vector2(0, -5), 1)
	var tween_alpha: Tween = get_tree().create_tween()
	tween_alpha.tween_property(feedback, "self_modulate", Color(1,1,1,0.3), 1)
	var tween_scale: Tween = get_tree().create_tween()
	tween_scale.tween_property(feedback, "scale", Vector2(0.6, 0.5), 1)
	await tween_pos.finished
	await tween_alpha.finished
	await tween_scale.finished
	feedback.queue_free()
