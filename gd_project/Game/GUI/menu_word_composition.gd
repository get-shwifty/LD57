extends Control

@onready var UI_LETTER = preload("res://Game/GUI/ui_letter.tscn")

@onready var pool_container = $CenterContainer/VBoxContainer/PoolContainer
@onready var word_container = $CenterContainer/VBoxContainer/WordContainer

signal on_word_confirmed
signal on_menu_closed

func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		confirm_word()
	if Input.is_action_just_pressed("ui_cancel"):
		close_menu()

func initialize(level : GameLevel):
	setup_letter_pool(level.get_letter_pool())

func setup_letter_pool(letters : String):
	for l in letters:
		var letter = UI_LETTER.instantiate()
		letter.initialize(l)
		letter.on_letter_selected.connect(on_letter_selected.bind(letter))
		pool_container.add_child(letter)

func on_letter_selected(letter : Control):
	if pool_container.get_children().has(letter):
		pool_container.remove_child(letter)
		word_container.add_child(letter)
	elif word_container.get_children().has(letter):
		word_container.remove_child(letter)
		pool_container.add_child(letter)

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
	
