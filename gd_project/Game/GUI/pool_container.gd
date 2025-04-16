extends GridContainer

var temps = 0

func _process(delta):
	#pass
	temps += delta
	var incr = 0
	for letter in get_children():
		letter.position.y += sin(10 * temps + incr) * 0.05
		incr += 2
