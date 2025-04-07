extends Node2D
var time = 0
var alphas: Array[float] = []
var speeds = []
var directions = []
const INCREMENT = 0.05

func _ready():
	var children = get_children()
	for i in len(children):
		var alpha = randf_range(0, 1)
		children[i].set_modulate(Color(1, 1, 1, alpha))
		alphas.append(alpha)
		speeds.append(randf_range(0.3, 0.6))
		directions.append(-1 if randf_range(0, 1) > 0.5 else 1)
	print(alphas)
		
func _process(delta):
	time += delta
	var children = get_children()
	for i in len(children):
		var child = children[i]
		var current: Color = child.modulate
		current.a = 0.5 + 0.5 * sin(alphas[i] + 2 * time * speeds[i])
		child.set_modulate(current)
		child.position.x += directions[i] * INCREMENT * sin(time * speeds[i])
