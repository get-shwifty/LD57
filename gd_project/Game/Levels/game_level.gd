extends Level

class_name GameLevel

var fishes : Array[Fish] = []
var player : Player;

var current_word : String = ""
var current_score : int = 0

func _ready():
	var test = get_children()
	for child in get_children():
		if child is Fish:
			fishes.append(child)
			child.on_captured.connect(fish_captured.bind(child))
			check_remaining_fishes()
		if child is Player:
			player = child
			child.on_oxygen_depleted.connect(oxygen_depleted)

func setup_level():
	pass

func fish_captured(fish : Fish):
	print("captured " + fish.get_letters())
	current_word += fish.get_letters()

func check_remaining_fishes():
	for fish in fishes:
		if !fish.is_captured:
			return
	print("all fishes captured")
	finish_level()
	
func oxygen_depleted():
	print("oxygen depleted")
	finish_level()

func finish_level():
	print("level finished")
	if !current_word.is_empty():
		confirm_current_word()
	on_level_finished.emit()
	
func confirm_current_word():
	print("confirmed word " + current_word)
	current_score += get_word_score(current_word)
	current_word = ""	
	
func _process(delta):
	if Input.is_action_just_pressed("game_confirm_word"):
		confirm_current_word()

func get_word_score(word : String) -> int:
	return word.length()

func get_score():
	return current_score;
