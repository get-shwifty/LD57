extends Node2D

func _ready():
	$AnimatedSprite2D.frame = randi_range(0, 4)
	$AnimatedSprite2D.speed_scale = randf_range(0.5, 0.8)
	$AnimatedSprite2D.play()
