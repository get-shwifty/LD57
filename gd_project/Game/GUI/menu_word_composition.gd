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

@onready var word_container = $CenterContainer/VBoxContainer/WordContainer
@onready var grid_container = $CenterContainer/VBoxContainer/GridContainer
@onready var sound_click_on_letter: AudioStreamPlayer = $SoundClickOnLetter
@onready var lettersScoring: AudioStreamPlayer = $LettersScoring
@onready var victory: AudioStreamPlayer = $SoundJackpooooot

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




signal on_word_confirmed
signal on_menu_closed
signal on_ui_finished

static var dico: DictionaryHelper = DictionaryHelper.new(DictionaryHelper.Language.English)

func _ready():
	pass
	#initialize()
	
func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		confirm_word()
	if Input.is_action_just_pressed("ui_cancel"):
		close_menu()

func initialize(word: Array[Letter]):
	#var word: Array[Letter] = [];
	#word.append(Letter.new(Alphabet.get_character("H")))
	#word.append(Letter.new(Alphabet.get_character("E")))
	#word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Medusa, Letter.BonusType.LetterMult1))
	#word.append(Letter.new(Alphabet.get_character("L"), Letter.FishType.Eel, Letter.BonusType.WordMult1))
	#word.append(Letter.new(Alphabet.get_character("O")))
	setup_letter_pool(word)

func setup_letter_pool(letters : Array[Letter]):
	for l in letters:
		var letter_ui = UI_LETTER.instantiate()
		letter_ui.initialize(l)
		letter_ui.on_letter_selected.connect(on_letter_selected.bind(letter_ui))
		grid_container.add_child(letter_ui)

func on_letter_selected(letter : Control):
	sound_click_on_letter.play()
	if grid_container.get_children().has(letter):
		grid_container.remove_child(letter)
		word_container.add_child(letter)
	elif word_container.get_children().has(letter):
		word_container.remove_child(letter)
		grid_container.add_child(letter)
	var word = get_word()
	if(len(word) and dico.is_word_valid(word)):
		$CenterContainer/VBoxContainer/Submit.disabled = false
	else:
		$CenterContainer/VBoxContainer/Submit.disabled = true
	update_score()

func close_menu():
	on_menu_closed.emit()

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
			var letter_ui: UILetter = word_container.get_children()[action.evaluated_letter_idx]
			letter_ui.points.text = str(action.new_letter_score)
			_play_bubble_sound()
			letter_ui.position.y -= 5
			$CenterContainer/VBoxContainer/Score/Points.text = str(action.new_word_add)
		await get_tree().create_timer(0.7).timeout
		print("doing operation")
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
