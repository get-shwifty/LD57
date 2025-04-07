extends Level

class_name GameLevel

@onready var MENU_WORD_COMPOSITION = preload("res://Game/GUI/menu_word_composition.tscn")

@onready var ui_container = $UIContainer;
@onready var room: LevelRoom = $Room
@onready var player: Player = $Player

var word_composing_menu : MenuWordComposition

var score_objective : int

var current_letters : Array[Letter] = []
var current_score : int = 0

func _ready():
	room.on_captured.connect(fish_captured)
	player.oxygen.on_oxygen_depleted.connect(oxygen_depleted)
	
	var letters = Alphabet.get_random_characters().map(func (c): return Letter.new(c))
	room.set_letters(letters)

	setup_level()

func setup_level():
	score_objective = 5

func fish_captured(letter: Letter):
	current_letters.append(letter)
	prints("captured", letter.character.character)

#func check_remaining_fishes():
	#for fish in fishes:
		#if !fish.is_captured:
			#return
	#print("all fishes captured")
	#finish_level()
	
func oxygen_depleted():
	print("oxygen depleted")
	finish_level()

func finish_level():
	print("level finished")
	on_level_finished.emit()
	
func confirm_word(word: Array[Letter]):
	var variable_contexte: VariableContext = VariableContext.new()
	var artefacts = get_artefacts()
	var breakdown = ScoreCalculator.compute_score(word, artefacts, variable_contexte)

	for letter in word:
		current_letters.erase(letter)
	
	word_composing_menu.process_score(breakdown)


	#if current_score >= score_objective:
		#finish_level()

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
	word_composing_menu.initialize(current_letters)

func close_word_compose():
	word_composing_menu.queue_free()
	word_composing_menu = null
	
func get_artefacts() -> Array[Artefact]:
	var artefact1 = Artefact.new()
	artefact1.name = "First letter is a voyel"
	artefact1.target = Artefact.TargetType.LetterMult
	artefact1.trigger = Artefact.TriggerType.Letter
	artefact1.value = ComputedValue.new(2)
	artefact1.condition = func(variable_context : VariableContext, condition_context : ConditionContext) -> bool:
		return condition_context.previous_letter != null and \
			condition_context.current_letter.character.is_vowel
	
	#vowel_booster.conditions.append(Condition.new(null, CustomCondition.new(CustomCondition.TargetType.CurrentLetter, CustomCondition.LetterCondition.Vowel)))
	
	return [artefact1]
