extends Level
class_name GameLevel

signal level_finished(points)

@onready var MENU_WORD_COMPOSITION = preload("res://Game/GUI/menu_word_composition.tscn")

var room: LevelRoom
@onready var ui_container = $UIContainer;
@onready var player: Player = room.get_node("Player")
@onready var word_composing_menu: MenuWordComposition = $UIContainer/MenuWordComposition
@onready var score: Score = $UIContainer/ScoreUI
@onready var restart_button = $UIContainer/ScoreUI/MenuButton
var letters_pool : Array[Letter] = []
var waiting_for_ui = false
var artefacts : Array[Artefact]
var fish_captured_count : int
var harpoon_fired_count : int

func _ready():
	assert(player != null)
	room.on_captured.connect(fish_captured)
	word_composing_menu.on_word_confirmed.connect(confirm_word)
	player.oxygen.on_oxygen_depleted.connect(on_oxygen_depleted)
	player.on_harpoon_fired.connect(on_harpoon_fired)


func setup_level(objective, artefacts : Array[Artefact]):
	score.objective = objective
	word_composing_menu.set_letters(letters_pool)
	self.artefacts = artefacts
	word_composing_menu.artefacts = artefacts
	word_composing_menu.setup_artefacts_grid()

	var letters = Alphabet.get_random_characters().map(func(c): return Letter.new(c))

	room.set_letters(letters)


func fish_captured(bonus_type: Letter.BonusType, letter: Letter):
	$UIContainer/Inputs.show()
	letter.bonus_type = bonus_type
	letters_pool.append(letter)
	word_composing_menu.set_letters(letters_pool)
	fish_captured_count += 1
	
func on_oxygen_depleted():
	print("oxygen depleted")
	neutralize_ui()
	level_finished.emit(0)

func on_harpoon_fired():
	harpoon_fired_count += 1
	
func neutralize_ui():
	score.hide()
	word_composing_menu.hide()

func confirm_word(word: Array[Letter]):
	var variable_context: VariableContext = VariableContext.new()
	variable_context.remaining_oxygen = player.oxygen.current_oxygen
	variable_context.harpoon_fired_count = harpoon_fired_count
	variable_context.fish_captured_count = fish_captured_count
	for letter in word:
		letters_pool.erase(letter)
	var breakdown = ScoreCalculator.compute_score(word, artefacts, variable_context, letters_pool)

	waiting_for_ui = true
	player.oxygen.paused = true
	word_composing_menu.disable_mouse_inputs()
	word_composing_menu.process_score(breakdown)

	await word_composing_menu.on_ui_finished

	waiting_for_ui = false
	score.current += breakdown.final_score
	
	if score.current > score.objective:
		await get_tree().create_timer(1.5).timeout
		neutralize_ui()
		level_finished.emit(score.current)
	else:
		player.oxygen.paused = false
		word_composing_menu.set_letters(letters_pool)
		compose_word()
		word_composing_menu.enable_mouse_inputs()

func _process(delta):
	score.oxygen = player.oxygen.current_oxygen
	if waiting_for_ui:
		return

	if Input.is_action_just_pressed("game_compose_word"):
		toggle_word_compose()

func toggle_word_compose():
	if word_composing_menu.is_composing_word:
		play_arcade()
	else:
		compose_word()

func compose_word():
	word_composing_menu.is_composing_word = true
	player.enabled = false
	$UIContainer/Inputs/GuessAWord.hide()
	$UIContainer/Inputs/GoBack.show()

func play_arcade():
	word_composing_menu.is_composing_word = false
	word_composing_menu.set_letters(letters_pool)
	player.enabled = true
	$UIContainer/Inputs/GuessAWord.show()
	$UIContainer/Inputs/GoBack.hide()
