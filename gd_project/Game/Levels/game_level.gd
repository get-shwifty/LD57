extends Level

class_name GameLevel

@onready var MENU_WORD_COMPOSITION = preload("res://Game/GUI/menu_word_composition.tscn")

@onready var ui_container = $UIContainer;
@onready var room: LevelRoom = $Room
@onready var player: Player = room.get_node("Player")
@onready var word_composing_menu: MenuWordComposition = $UIContainer/MenuWordComposition

var score_objective : int

var current_word : Array[Letter] = []
var current_score : int = 0

func _ready():
	assert(player != null)
	room.on_captured.connect(fish_captured)
	
	word_composing_menu.on_word_confirmed.connect(confirm_word)
	
	

	current_word.append(Letter.new(Alphabet.get_character("H")))
	current_word.append(Letter.new(Alphabet.get_character("E")))
	current_word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Medusa, Letter.BonusType.LetterMult1))
	current_word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Eel, Letter.BonusType.WordMult1))
	current_word.append(Letter.new(Alphabet.get_character("O")))

	setup_level()

func setup_level():
	score_objective = 5
	word_composing_menu.set_letters(current_word)

	var letters = Alphabet.get_random_characters().map(func (c): return Letter.new(c))
	room.set_letters(letters)

func fish_captured(letter: Letter):
	current_word.append(letter)
	word_composing_menu.set_letters(current_word)
	
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
		current_word.erase(letter)
	word_composing_menu.process_score(breakdown, artefacts)
	await word_composing_menu.on_ui_finished
	word_composing_menu.set_letters(current_word)

func get_letter_pool():
	return current_word
	
func _process(delta):
	if Input.is_action_just_pressed("game_compose_word"):
		toggle_word_compose()

func get_score():
	return current_score

func toggle_word_compose():
	if word_composing_menu.is_composing_word:
		play_arcade()
	else:
		compose_word()

func compose_word():
	word_composing_menu.is_composing_word = true
	# TODO disable arcade

func play_arcade():
	word_composing_menu.is_composing_word = false
	word_composing_menu.set_letters(current_word)
	# TODO enable arcade

func get_artefacts() -> Array[Artefact]:
	var artefacts: Array[Artefact] = []
	
	var vowel_booster = Artefact.new()
	vowel_booster.name = "Vowel Booster"
	vowel_booster.trigger = Artefact.TriggerType.Letter
	vowel_booster.target = Artefact.TargetType.LetterAdd
	vowel_booster.value = ComputedValue.new(0, VariableContext.VariableType.ConsonantCount)
	vowel_booster.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.character.is_vowel
	#vowel_booster.conditions.append(Condition.new(null, CustomCondition.new(CustomCondition.TargetType.CurrentLetter, CustomCondition.LetterCondition.Vowel)))
	artefacts.append(vowel_booster)
	
	var oddness_boost = Artefact.new()
	oddness_boost.name = "Love the oddness"
	oddness_boost.trigger = Artefact.TriggerType.Word
	oddness_boost.target = Artefact.TargetType.WordMult
	oddness_boost.value = ComputedValue.new(2)
	oddness_boost.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return vc.letter_count % 2 != 0
	#oddness_boost.conditions.append(Condition.new(
			#Comparison.new(
				#ComputedValue.new(0, VariableContext.VariableType.LetterCount),
			#Comparison.Operator.Odd,
			#null)
		#, null))
	artefacts.append(oddness_boost)
	
	var vowel_first = Artefact.new()
	vowel_first.name = "First letter is a vowel"
	vowel_first.trigger = Artefact.TriggerType.Letter
	vowel_first.target = Artefact.TargetType.LetterMult
	vowel_first.value = ComputedValue.new(2)
	vowel_first.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.previous_letter == null and cc.current_letter.character.is_vowel
	artefacts.append(vowel_first)

	return artefacts
