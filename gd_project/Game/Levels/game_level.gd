extends Level
class_name GameLevel

signal level_finished(points)

@onready var MENU_WORD_COMPOSITION = preload("res://Game/GUI/menu_word_composition.tscn")

var room: LevelRoom
@onready var ui_container = $UIContainer;
@onready var player: Player = room.get_node("Player")
@onready var word_composing_menu: MenuWordComposition = $UIContainer/MenuWordComposition
@onready var score: Score = $UIContainer/ScoreUI

var letters_pool : Array[Letter] = []
var waiting_for_ui = false
var artefacts : Array[Artefact]

func _ready():
	assert(player != null)
	room.on_captured.connect(fish_captured)
	word_composing_menu.on_word_confirmed.connect(confirm_word)
	player.oxygen.on_oxygen_depleted.connect(on_oxygen_depleted)


func setup_level(objective, artefacts : Array[Artefact]):
	score.objective = objective
	word_composing_menu.set_letters(letters_pool)
	self.artefacts = artefacts
	word_composing_menu.artefacts = artefacts
	word_composing_menu.setup_artefacts_grid()

	var letters = Alphabet.get_random_characters().map(func(c): return Letter.new(c))
	for letter: Letter in letters:
		var r = randf()
		if r < 0.05:
			letter.bonus_type = Letter.BonusType.LetterMult2
		elif r < 0.15:
			letter.bonus_type = Letter.BonusType.LetterMult1

	room.set_letters(letters)


func fish_captured(letter: Letter):
	letters_pool.append(letter)
	word_composing_menu.set_letters(letters_pool)
	
func on_oxygen_depleted():
	print("oxygen depleted")
	neutralize_ui()
	level_finished.emit(0)

func neutralize_ui():
	score.hide()
	word_composing_menu.hide()

func confirm_word(word: Array[Letter]):
	var variable_context: VariableContext = VariableContext.new()
	variable_context.remaining_oxygen = player.oxygen.current_oxygen
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
		await get_tree().create_timer(2.0).timeout
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

func play_arcade():
	word_composing_menu.is_composing_word = false
	word_composing_menu.set_letters(letters_pool)
	player.enabled = true
