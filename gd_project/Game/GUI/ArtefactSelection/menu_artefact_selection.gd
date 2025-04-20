extends Control

@onready var UI_ARTEFACT_BUTTON = preload("res://Game/GUI/ArtefactSelection/ui_artefact.tscn")

signal artefact_selected

@onready var artefact_container = $CenterContainer/HBoxContainer

func initialize(artefacts: Array[Artefact]):
	for artefact in artefacts:
		var artefact_button = UI_ARTEFACT_BUTTON.instantiate()
		artefact_button.initialize(artefact)
		artefact_button.on_selected.connect(select_artefact.bind(artefact))
		artefact_container.add_child(artefact_button)

func initialize_bonus(current_artefacts: Array[Artefact], bonus=true):
	var all_artefacts
	if bonus:
		all_artefacts = ArtefactManager.bonuses.slice(0)
	else:
		all_artefacts = ArtefactManager.maluses.slice(0)

	for artefact in current_artefacts:
		all_artefacts.erase(artefact)
	all_artefacts.shuffle()
	initialize(all_artefacts.slice(0, 3))

func select_artefact(artefact: Artefact):
	artefact_selected.emit(artefact)


#only usefull for tests
func get_artefacts() -> Array[Artefact]:
	var artefacts: Array[Artefact] = []
	
	var vowel_booster = Artefact.new()
	vowel_booster.name = "Vowel Booster"
	vowel_booster.description = "If the letter is a vowel, add it as much points as consonant in the word"
	vowel_booster.trigger = Artefact.TriggerType.Letter
	vowel_booster.target = Artefact.TargetType.LetterAdd
	vowel_booster.value = ComputedValue.new(0, VariableContext.VariableType.ConsonantCount)
	vowel_booster.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.character.is_vowel
	artefacts.append(vowel_booster)
	
	var oddness_boost = Artefact.new()
	oddness_boost.name = "Love the oddness"
	oddness_boost.description = "+2 word mult if word contains odd number of letter"
	oddness_boost.is_malus = true
	oddness_boost.trigger = Artefact.TriggerType.Word
	oddness_boost.target = Artefact.TargetType.WordMult
	oddness_boost.value = ComputedValue.new(2)
	oddness_boost.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return vc.letter_count % 2 != 0
	artefacts.append(oddness_boost)
	
	var vowel_first = Artefact.new()
	vowel_first.name = "First letter is a vowel"
	vowel_first.description = "X2 on the first letter score if it's a vowel"
	vowel_first.trigger = Artefact.TriggerType.Letter
	vowel_first.target = Artefact.TargetType.LetterMult
	vowel_first.value = ComputedValue.new(2)
	vowel_first.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.previous_letter == null and cc.current_letter.character.is_vowel
	artefacts.append(vowel_first)

	return artefacts
