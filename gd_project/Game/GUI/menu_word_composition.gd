extends Control
class_name MenuWordComposition

## Dict de la forme : Lettre: [points, texture]
#const LETTER_POOL: Array[Array] = [
		#["L", 1, 0],
		#["O", 5, 1],
		#["V", 1, 2],
		#["E", 1, 3],
		#["U", 1, 0],
		#["P", 5, 1],
		#["A", 1, 2],
		#["B", 1, 3],
		#["C", 1, 0],
		#["D", 5, 1],
		#["F", 1, 2],
		#["G", 1, 3],
		#["H", 1, 0],
		#["O", 5, 1],
		#["V", 1, 2],
		#["E", 1, 3]
#]


@onready var UI_LETTER = preload("res://Game/GUI/ui_letter.tscn")
@onready var UI_ARTEFACT = preload("res://Game/GUI/ui_artefact.tscn")

@onready var center_container = $CenterContainer
@onready var center_container2 = $CenterContainer2
@onready var artefacts_container = $Artefacts
@onready var vbox_container = $CenterContainer/VBoxContainer
@onready var word_container = %WordContainer
@onready var grid_container = %GridContainer
@onready var submit_container = %Submit
@onready var hbox_container = %HBoxContainer
@onready var score_container = %Score
@onready var sound_click_on_letter: AudioStreamPlayer = $SoundClickOnLetter
@onready var lettersScoring: AudioStreamPlayer = $LettersScoring
@onready var victory: AudioStreamPlayer = $SoundJackpooooot

var artefacts: Array[Artefact]

var sound_bank := [
	preload("res://assets/sounds/bruitages/wordComposition/bubble-score-1.ogg"),
	preload("res://assets/sounds/bruitages/wordComposition/bubble-score-2.ogg"),
	preload("res://assets/sounds/bruitages/wordComposition/bubble-score-3.ogg"),
	preload("res://assets/sounds/bruitages/wordComposition/bubble-score-4.ogg"),
	preload("res://assets/sounds/bruitages/wordComposition/bubble-score-5.ogg")
]
var sound_index := 0

@onready var multi: int = 10
@onready var score: int = 0

var is_composing_word: bool = false:
	set(value):
		is_composing_word = value
		update_view()

signal on_word_confirmed
signal on_ui_finished

static var dico: DictionaryHelper = DictionaryHelper.new(DictionaryHelper.Language.English)

func _ready():
	update_view()
	
func _process(delta: float):
	if Input.is_action_just_pressed("submit"):
		confirm_word()

func set_letters(word: Array[Letter]):
	setup_letter_pool(word)

func update_view():
	grid_container.reparent(vbox_container if is_composing_word else center_container2)
	center_container.visible = is_composing_word

func setup_artefacts_grid():
	for art in artefacts:
		var artefact_ui = UI_ARTEFACT.instantiate()
		artefact_ui.initialize(art)
		artefacts_container.add_child(artefact_ui)

func setup_letter_pool(letters: Array[Letter]):
	for child in grid_container.get_children():
		child.queue_free()
	for child in word_container.get_children():
		child.queue_free()

	for l in letters:
		var letter_ui = UI_LETTER.instantiate()
		letter_ui.initialize(l)
		letter_ui.on_letter_selected.connect(on_letter_selected.bind(letter_ui))
		grid_container.add_child(letter_ui)

func on_letter_selected(letter: Control):
	sound_click_on_letter.play()
	if grid_container.get_children().has(letter):
		letter.reparent(word_container)
	elif word_container.get_children().has(letter):
		letter.reparent(grid_container)
	var word = get_word()
	if (len(word) and dico.is_word_valid(word)):
		$CenterContainer/VBoxContainer/Submit.disabled = false
	else:
		$CenterContainer/VBoxContainer/Submit.disabled = true
	update_score()

func get_word():
	if word_container.get_child_count() <= 0:
		return []
	
	var word: Array[Letter]
	for l in word_container.get_children():
		word.append(l.get_letter())
		
	return word
		
func confirm_word():
	var word = get_word()
		
	#for child in word_container.get_children():
		#child.queue_free()
	
	on_word_confirmed.emit(word)
	
	#if grid_container.get_child_count() <= 0:
		#on_menu_closed.emit()

func update_score():
	var word = get_word()
	var score = 0
	for letter in word:
		score += letter.character.base_value
	$CenterContainer/VBoxContainer/Score/Points.text = str(score)
	
	
func process_score(score: ScoreCalculator.ScoreBreakdown):
	for action in score.operations:
		if action.letter_add_delta:
			var tween_letter: Tween = get_tree().create_tween()
			var letter_ui: UILetter = word_container.get_children()[action.evaluated_letter_idx]
			letter_ui.points.text = str(action.new_letter_score)
			_play_bubble_sound()
			letter_ui.position.y -= 5.0
			tween_letter.tween_property(letter_ui, "position", letter_ui.position + Vector2(0, 5), 0.25)
			$CenterContainer/VBoxContainer/Score/Points.text = str(action.new_word_add)
		await get_tree().create_timer(0.7).timeout
		print("doing operation")
	
		if action.origin_artefact_idx:
			var tween_artefact: Tween = get_tree().create_tween()
			var artefact_ui: UIArtefact = artefacts_container.get_children()[action.origin_artefact_idx]
			artefact_ui.position.y -= 5.0
			tween_artefact.tween_property(artefact_ui, "position", artefact_ui.position + Vector2(0, 5), 0.25)
			
	$CenterContainer/VBoxContainer/Score/Total.text = str(score.final_score)
	victory.play()
	on_ui_finished.emit()
	

func _play_bubble_sound():
	lettersScoring.volume_db = +3
	lettersScoring.stream = sound_bank[sound_index]
	lettersScoring.play()
	sound_index += 1
	if sound_index >= sound_bank.size():
		sound_index = 0
