extends Level

class_name GameLevel

@onready var MENU_WORD_COMPOSITION = preload("res://Game/GUI/menu_word_composition.tscn")

@onready var ui_container = $UIContainer;

var fishes : Array[Fish] = []
var player : Player;

var word_composing_menu : Control;

var score_objective : int

var current_letters : String = ""
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
	setup_level()

func setup_level():
	score_objective = 5;

func fish_captured(fish : Fish):
	print("captured " + fish.get_letters())
	current_letters += fish.get_letters()

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
	on_level_finished.emit()
	
func confirm_word(word : String):
	print("confirmed word " + word)
	current_score += get_word_score(word)
	for letter in word:
		var idx = current_letters.find(letter)
		current_letters = current_letters.erase(idx)
	
	if current_score >= score_objective:
		finish_level()

func get_letter_pool():
	return current_letters
	
func _process(delta):
	if !is_composing_word() && Input.is_action_just_pressed("game_compose_word"):
		start_word_compose()

func get_word_score(word : String) -> int:
	return word.length()

func get_score():
	return current_score;

func is_composing_word() -> bool:
	return word_composing_menu != null

func start_word_compose():
	word_composing_menu = MENU_WORD_COMPOSITION.instantiate()
	ui_container.add_child(word_composing_menu)
	word_composing_menu.on_word_confirmed.connect(confirm_word)
	word_composing_menu.on_menu_closed.connect(close_word_compose)
	word_composing_menu.initialize(self)

func close_word_compose():
	word_composing_menu.queue_free()
	word_composing_menu = null
	
