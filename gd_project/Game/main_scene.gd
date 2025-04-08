extends Node2D

@onready var MENU_LEVEL_FINISHED = preload("res://Game/GUI/menu_level_finished.tscn")
@onready var MENU_LEVEL_SELECTION = preload("res://GUI/Map.tscn")

@onready var LEVEL_TEST_DEFAULT = preload("res://Game/Levels/level_test.tscn")
@onready var game_over_scene = preload("res://GUI/game_over.tscn")
@onready var start_scene = preload("res://Game/Levels/splash.tscn")

@onready var menu_container = $CanvasLayer/MenuContainer

@onready var ROOMS_METADATA = {
	preload("res://Game/Levels/room_1.tscn"): RoomMetadata.new(1,10,1,0,5),
	preload("res://Game/Levels/room_2.tscn"): RoomMetadata.new(2,1,0,0,10),
	preload("res://Game/Levels/room_3.tscn"): RoomMetadata.new(3,2,0,1,10),
	preload("res://Game/Levels/room_4.tscn"): RoomMetadata.new(4,0,0,2,9),
	preload("res://Game/Levels/room_5.tscn"): RoomMetadata.new(5,2,4,0,5),
	preload("res://Game/Levels/room_6.tscn"): RoomMetadata.new(6,1,7,1,4),
	preload("res://Game/Levels/room_7.tscn"): RoomMetadata.new(7, 0, 0, 0, 0),
}

var current_level: Level
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

func setup_game():
	print("game setup")
	remove_child(game_start)
	map_menu = MENU_LEVEL_SELECTION.instantiate()
	menu_container.add_child(map_menu)
	map_menu.generate_new_map()
	map_menu.unlock_floor(0)
	map_menu.map_exited.connect(_on_map_exited)

	artefacts = []
	total_points = 0
	for starting_artefact in ArtefactRepository.starting:
		artefacts.append(starting_artefact)


func on_level_finished(points):
	if points == 0:
		game_over()
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
	clean()
	map_menu.show_map()
	#map_menu.camera_2d.enabled = true
	#map_menu.camera_2d.make_current()
	
func start_new_level(level_number : int):
	print("starting level " + str(level_number))
	var r = ROOMS_METADATA.keys()[level_number] #let's hope dictionary stay ordered (surprising but ...)
	var room = r.instantiate()
	current_level = LEVEL_TEST_DEFAULT.instantiate()
	current_level.room = room
	current_level.add_child(room)
	current_level.level_finished.connect(on_level_finished)
	add_child(current_level)
	current_level.setup_level(artefacts.slice(0))

func _on_map_exited(room: Room) -> void:
	map_menu.hide_map()
	map_menu.camera_2d.enabled = false
	map_menu.unlock_next_rooms()
	match room.type:
		Room.Type.LEVEL_1:
			start_new_level(1)
		Room.Type.LEVEL_2:
			start_new_level(2)
		Room.Type.LEVEL_3:
			start_new_level(3)
		Room.Type.LEVEL_4:
			start_new_level(4)
		Room.Type.LEVEL_5:
			start_new_level(5)
		Room.Type.LEVEL_6:
			start_new_level(6)
		Room.Type.LEVEL_7:
			start_new_level(7)
		Room.Type.SHOP:
			start_new_level(1)
		Room.Type.MINI_BOSS:
			start_new_level(1)
		Room.Type.BOSS:
			start_new_level(1)

func game_over() -> void:
	game_end = game_over_scene.instantiate()
	game_end.initialize(total_points)
	menu_container.add_child(game_end)
	
	game_end.replay.connect(restart_game)
	

func restart_game() -> void:
	clean()
	setup_game()

func clean():
	if game_end:
		game_end.queue_free()
		game_end = null
	if current_menu:
		current_menu.queue_free()
		current_menu = null
	if current_level:
		current_level.queue_free()
		current_level = null

class RoomMetadata:
	var room_index: int
	var clown_count: int
	var medusa_count: int
	var murena_count: int
	var crab_count: int

	func _init(idx: int, clown: int, medusa: int, murena: int, crab: int):
		self.room_index = idx
		self.clown_count = clown
		self.medusa_count = medusa
		self.murena_count = murena
		self.crab_count = crab
