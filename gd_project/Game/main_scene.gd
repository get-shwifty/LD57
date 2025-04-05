extends Node2D

@onready var MENU_LEVEL_FINISHED = preload("res://Game/GUI/menu_level_finished.tscn")

@onready var LEVEL_TEST_DEFAULT = preload("res://Game/Levels/level_test.tscn")

@onready var menu_container = $CanvasLayer/MenuContainer

var current_level : Level
var current_menu;

func _ready():
	for child in get_children():
		if child is Level:
			print("detected level override")
			current_level = child;
			current_level.on_level_finished.connect(on_level_finished)
			return
	setup_game()

func setup_game():
	print("classic game setup")

func on_level_finished():
	print("main game detected level finished")
	current_menu = MENU_LEVEL_FINISHED.instantiate();
	current_menu.initialize(current_level)
	current_menu.on_menu_closed.connect(on_score_menu_closed)
	menu_container.add_child(current_menu)

func on_score_menu_closed():
	current_menu.queue_free()
	current_level.queue_free()
	
	current_level = LEVEL_TEST_DEFAULT.instantiate()
	current_level.on_level_finished.connect(on_level_finished)
	add_child(current_level)
