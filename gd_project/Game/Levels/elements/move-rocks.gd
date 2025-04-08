extends Node2D
var time = 0
var speeds = []
var directions = []
const INCREMENT = 0.05

func _ready():
	var children = get_children()
	for i in len(children):
		children[i].set_modulate(Color(1, 1, 1))
		speeds.append(randf_range(0.3, 0.5))
		directions.append(-0.4 if randf_range(0, 1) > 0.5 else 0.4)
		
func _process(delta):
	time += delta
	var children = get_children()
	for i in len(children):
		var child = children[i]
		var current: Color = child.modulate
		current.a = 0.5 + 0.5 * sin(i + 0.5 * time * speeds[i])
		child.set_modulate(current)
		child.position.x += directions[i] * INCREMENT * sin(time * speeds[i])
