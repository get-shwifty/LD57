extends Node2D

@onready var MENU_LEVEL_FINISHED = preload("res://Game/GUI/menu_level_finished.tscn")
@onready var MENU_LEVEL_SELECTION = preload("res://GUI/Map.tscn")

@onready var LEVEL_TEST_DEFAULT = preload("res://Game/Levels/level_test.tscn")
@onready var game_over_scene = preload("res://GUI/game_over.tscn")
@onready var start_scene = preload("res://Game/Levels/splash.tscn")

@onready var menu_container = $CanvasLayer/MenuContainer

var current_level : Level
var current_menu
var map_menu: Map
var game_end
var game_start

var total_points: float = 0
var artefacts: Array[Artefact]

func _ready():
	game_start = start_scene.instantiate()
	add_child(game_start)

	game_start.start_game.connect(setup_game)
	print("YOOO")

func setup_game():
	print("game setup")
	remove_child(game_start)
	map_menu = MENU_LEVEL_SELECTION.instantiate()
	menu_container.add_child(map_menu)
	map_menu.generate_new_map()
	map_menu.unlock_floor(0)
	map_menu.map_exited.connect(_on_map_exited)
	
	for starting_artefact in ArtefactRepository.starting:
		artefacts.append(starting_artefact)



func on_level_finished(points):
	if points == 0:
		# TODO game over
		get_tree().quit()
	else:
		total_points += points
		
		print("main game detected level finished")
		current_menu = MENU_LEVEL_FINISHED.instantiate()
		current_menu.on_menu_closed.connect(on_score_menu_closed)
		menu_container.add_child(current_menu)
		current_menu.initialize(total_points, artefacts)

func on_score_menu_closed(new_artefact):
	if new_artefact != null:
		artefacts.append(new_artefact)
	current_menu.queue_free()
	current_level.queue_free()
	map_menu.show_map()
	#map_menu.camera_2d.enabled = true
	#map_menu.camera_2d.make_current()
	
func start_new_level():
	current_level = LEVEL_TEST_DEFAULT.instantiate()
	current_level.level_finished.connect(on_level_finished)
	add_child(current_level)
	current_level.setup_level(artefacts.slice(0))
	

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

func game_over() -> void:
	game_end = game_over_scene.instantiate()
	game_end.initialize(total_points)
	menu_container.add_child(game_end)
	
	game_end.replay.connect(restart_game)
	

func restart_game() -> void:
	menu_container.remove_child(game_end)
	setup_game()
