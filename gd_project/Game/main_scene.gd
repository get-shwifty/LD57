extends Node2D

@onready var MENU_LEVEL_FINISHED = preload("res://Game/GUI/menu_level_finished.tscn")
@onready var MENU_LEVEL_SELECTION = preload("res://GUI/Map.tscn")

@onready var LEVEL_TEST_DEFAULT = preload("res://Game/Levels/level_test.tscn")

@onready var menu_container = $CanvasLayer/MenuContainer

var current_level: Level
var current_menu;
var map_menu: Map;

func _ready():
	setup_game()
	test_scoring()
	
	for child in get_children():
		if child is Level:
			print("detected level override")
			current_level = child;
			current_level.on_level_finished.connect(on_level_finished)
			return


func setup_game():
	print("classic game setup")
	map_menu = MENU_LEVEL_SELECTION.instantiate()
	menu_container.add_child(map_menu)
	# code à lancer après avoir cliqué sur le bouton "PLAY"
	map_menu.generate_new_map()
	map_menu.unlock_floor(0)
	map_menu.map_exited.connect(_on_map_exited)
	map_menu.hide_map()
	#print(map_menu.camera_2d.is_current()) 
 
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
	
func test_scoring():
	var context: VariableContext = VariableContext.new()
	context.reset()
	context.grapple_count = 2
	context.remaining_oxygen = 3
	
	var artefacts: Array[Artefact] = setup_artifacts();
	
	var word: Array[Letter] = [];
	word.append(Letter.new(Alphabet.get_character("H")))
	word.append(Letter.new(Alphabet.get_character("E")))
	word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Medusa, Letter.BonusType.LetterMult1))
	word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Eel, Letter.BonusType.WordMult1))
	word.append(Letter.new(Alphabet.get_character("O")))
	
	var dict = DictionaryHelper.new(DictionaryHelper.Language.English)
	
	if dict.is_word_valid(word):
		print("word is valid")
	else:
		print("word is invalid")
	var score = ScoreCalculator.compute_score(word, artefacts, context)
	var word_string = ""
	for l in word:
		word_string += l.character.character
	print("Word \"" + word_string + "\" scored " + str(score.final_score))

func setup_artifacts() -> Array[Artefact]:
	var artefacts: Array[Artefact] = []
	
	var vowel_booster = Artefact.new()
	vowel_booster.name = "Vowel Booster"
	vowel_booster.trigger = Artefact.TriggerType.Letter
	vowel_booster.target = Artefact.TargetType.LetterAdd
	vowel_booster.value = ComputedValue.new(0, VariableContext.VariableType.ConsonantCount)
	vowel_booster.conditions.append(Condition.new(null, CustomCondition.new(CustomCondition.TargetType.CurrentLetter, CustomCondition.LetterCondition.Vowel)))
	artefacts.append(vowel_booster)
	
	var oddness_boost = Artefact.new()
	oddness_boost.name = "Love the oddness"
	vowel_booster.trigger = Artefact.TriggerType.Word
	oddness_boost.target = Artefact.TargetType.WordMult
	oddness_boost.value = ComputedValue.new(2)
	oddness_boost.conditions.append(Condition.new(
		Comparison.new(
			ComputedValue.new(0, VariableContext.VariableType.LetterCount),
			Comparison.Operator.Odd,
			null)
		, null))
	artefacts.append(oddness_boost)
	
	return artefacts
