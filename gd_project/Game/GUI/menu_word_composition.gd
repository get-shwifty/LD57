extends Control

## Dict de la forme : Lettre: [points, texture]
const LETTER_POOL: Array[Array] = [
		["L", 1, 0],
		["O", 5, 1],
		["V", 1, 2],
		["E", 1, 3],
		["U", 1, 0],
		["P", 5, 1],
		["A", 1, 2],
		["B", 1, 3],
		["C", 1, 0],
		["D", 5, 1],
		["F", 1, 2],
		["G", 1, 3],
		["H", 1, 0],
		["O", 5, 1],
		["V", 1, 2],
		["E", 1, 3]
]

@onready var UI_LETTER = preload("res://Game/GUI/ui_letter.tscn")

@onready var pool_container = $CenterContainer/VBoxContainer/PoolContainer
@onready var word_container = $CenterContainer/VBoxContainer/WordContainer
@onready var grid_container = $CenterContainer/VBoxContainer/GridContainer

@onready var multi: int = 10
@onready var score: int = 0

signal on_word_confirmed
signal on_menu_closed

func _ready():
	initialize()
	
func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		confirm_word()
	if Input.is_action_just_pressed("ui_cancel"):
		close_menu()

func initialize():
	setup_letter_pool(LETTER_POOL)

func setup_letter_pool(letters : Array[Array]):
	for l in letters:
		var letter = UI_LETTER.instantiate()
		letter.initialize(l[0], l[1], l[2])
		letter.on_letter_selected.connect(on_letter_selected.bind(letter))
		grid_container.add_child(letter)

func on_letter_selected(letter : Control):
	if grid_container.get_children().has(letter):
		grid_container.remove_child(letter)
		word_container.add_child(letter)
		#calc_score(letter[1])
	elif word_container.get_children().has(letter):
		word_container.remove_child(letter)
		grid_container.add_child(letter)

func close_menu():
	on_menu_closed.emit()

func confirm_word():
	if word_container.get_child_count() <= 0:
		return
	
	var word = ""
	for l in word_container.get_children():
		word += l.get_letter()	
		
	for child in word_container.get_children():
		child.queue_free()
	
	on_word_confirmed.emit(word)
	
	if pool_container.get_child_count() <= 0:
		on_menu_closed.emit()

func calc_score(letter_points: int) -> int:
	score += letter_points
	return 1
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
