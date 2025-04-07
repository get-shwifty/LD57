extends Node2D

@onready var MENU_LEVEL_FINISHED = preload("res://Game/GUI/menu_level_finished.tscn")
@onready var MENU_LEVEL_SELECTION = preload("res://GUI/Map.tscn")

@onready var LEVEL_TEST_DEFAULT = preload("res://Game/Levels/level_test.tscn")

@onready var menu_container = $CanvasLayer/MenuContainer

var current_level : Level
var current_menu;
var map_menu: Map;

#func _ready():
	#setup_game()
	#for child in get_children():
		#if child is Level:
			#print("detected level override")
			#current_level = child;
			#current_level.on_level_finished.connect(on_level_finished)
			#return


func setup_game():
	print("classic game setup")
	map_menu = MENU_LEVEL_SELECTION.instantiate()
	menu_container.add_child(map_menu)
	map_menu.generate_new_map()
	map_menu.unlock_floor(0)
	map_menu.map_exited.connect(_on_map_exited)
	print(map_menu.camera_2d.is_current())
 
func _on_start_button_pressed() -> void:
	$StartButton.queue_free()
	setup_game()


func on_level_finished():
	print("main game detected level finished")
	current_menu = MENU_LEVEL_FINISHED.instantiate();
	current_menu.initialize(current_level)
	current_menu.on_menu_closed.connect(on_score_menu_closed)
	menu_container.add_child(current_menu)

func on_score_menu_closed():
	current_menu.queue_free()
	current_level.queue_free()
	map_menu.show_map()
	#map_menu.camera_2d.enabled = true
	#map_menu.camera_2d.make_current()
	
func start_new_level():
	current_level = LEVEL_TEST_DEFAULT.instantiate()
	current_level.on_level_finished.connect(on_level_finished)
	add_child(current_level)
	

func _on_map_exited(room: Room) -> void:
	map_menu.hide_map()
	map_menu.camera_2d.enabled = false
	map_menu.unlock_next_rooms()
	match room.type:
		Room.Type.CLASSIC:
			start_new_level()
		Room.Type.SHOP:
			start_new_level()
		Room.Type.MINI_BOSS:
			start_new_level()
		Room.Type.BOSS:
			start_new_level()
