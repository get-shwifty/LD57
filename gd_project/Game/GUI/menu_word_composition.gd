extends Control
class_name MenuWordComposition

@onready var UI_LETTER = preload("res://Game/GUI/ui_letter.tscn")
@onready var UI_ARTEFACT = preload("res://Game/GUI/ui_artefact.tscn")

@onready var center_container = $CenterContainer
@onready var center_container2 = $CenterContainer2
@onready var artefacts_container = $Artefacts
@onready var vbox_container = $CenterContainer/VBoxContainer
@onready var word_container = %WordContainer
@onready var grid_container = %GridContainer
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
var just_confirmed = false

@onready var multi: int = 10
@onready var score: int = 0
@onready var tween_time: float = 0.5

var is_composing_word: bool = false:
	set(value):
		is_composing_word = value
		update_view()
var can_submit = false:
	set(value):
		can_submit = value
		%Submit.disabled = not value

signal on_word_confirmed(word)
signal on_ui_finished

static var dico: DictionaryHelper = DictionaryHelper.new(DictionaryHelper.Language.English)

func _ready():
	var children = grid_container.get_children()
	for child in children:
		child.free()
	update_view()
	
func _process(delta: float):
	if Input.is_action_just_pressed("submit"):
		confirm_word()

func set_letters(word: Array[Letter]):
	setup_letter_pool(word)

func update_view():
	center_container.visible = is_composing_word
	%Submit.visible = is_composing_word
	#%Multiplicateur.text = str(1)
	if is_composing_word:
		enable_mouse_inputs()
		grid_container.reparent(vbox_container)
		grid_container.columns = 8
	else:
		disable_mouse_inputs()
		grid_container.reparent(center_container2)
		grid_container.columns = 16

func disable_mouse_inputs():
	$MouseBlock.show()
	
func enable_mouse_inputs():
	$MouseBlock.hide()

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
	if just_confirmed:
		%Multiplicateur.text = "1"
		%Total.text = "..."
		just_confirmed = false
	sound_click_on_letter.play()
	if grid_container.get_children().has(letter):
		letter.reparent(word_container)
	elif word_container.get_children().has(letter):
		letter.reparent(grid_container)
	var word = get_word()
	if (len(word) and dico.is_word_valid(word)):
		can_submit = true
	else:
		can_submit = false
		
	update_score()

func get_word():
	if word_container.get_child_count() <= 0:
		return []
	
	var word: Array[Letter]
	for l in word_container.get_children():
		word.append(l.get_letter())
		
	return word
		
func confirm_word():
	if can_submit:
		can_submit = false
		var word = get_word()
		on_word_confirmed.emit(word)

func update_score():
	var word = get_word()
	var score = 0
	for letter in word:
		score += letter.character.base_value
	$CenterContainer/VBoxContainer/PanelContainer/Score/Points.text = str(score)
	#$CenterContainer/VBoxContainer/PanelContainer/Score/Total.text = str(score)
	#bump_ui($CenterContainer/VBoxContainer/PanelContainer/Score/Points)
	#bump_ui($CenterContainer/VBoxContainer/PanelContainer/Score/Total)
	
	
func process_score(score: ScoreCalculator.ScoreBreakdown):
	tween_time = 0.4
	
	for action in score.operations:
		
		var source = resolve_source(action)
		var target = resolve_target(action)
		
		await bump_ui(source)
		if target is UILetter:
			if action.new_letter_score != int(target.points.text):
				var operator = "x" if action.letter_mult_delta != 0 else "+"
				var value = action.letter_mult_delta if action.letter_mult_delta != 0 else action.letter_add_delta
				var color = Color('#da6175') if (operator == "x" && value < 1) || (operator == "+" && value < 0) else Color('24b8a0')
				display_text(target.points, operator + str(value), color)
				target.points.text = str(action.new_letter_score)
			elif action.letter_fish_type_delta:
				target.update_type(action.letter_fish_type_delta)
			if action.letter_bonus_type_delta:
				target.update_bonus(action.letter_bonus_type_delta)
			await bump_ui(target)
			if action.new_letter_score != int(target.points.text):
				var points = $CenterContainer/VBoxContainer/PanelContainer/Score/Points
				points.text = str(action.new_word_add)
				await bump_ui(points)
		else:
			if target == %Points:
				var operator = "+" if action.word_add_delta > 0 else "-"
				var color = Color('#da6175') if operator == "-" else Color('24b8a0')
				display_text(target, operator + str(action.word_add_delta), color)
				target.text = str(action.new_word_add)
			elif target == %Multiplicateur:
				var operator = "+" if action.new_word_mult > 0 else "-"
				var color = Color('#da6175') if operator == "-" else Color('24b8a0')
				display_text(target, operator + str(action.new_word_mult), color)
				target.text = str(action.new_word_mult)
			await bump_ui(target)
		await get_tree().create_timer(tween_time).timeout
	await display_total(score)
	on_ui_finished.emit()
	just_confirmed = true
	enable_mouse_inputs()
	
func display_text(target, string, color : Color):
	var feedback = Label.new()
	feedback.text = string
	feedback.set("theme_override_colors/font_color", color)
	feedback.add_theme_font_override("font", load("res://assets/fonts/Square.ttf"))
	feedback.scale = Vector2(0.5, 0.5)
	target.add_child(feedback)
	
	var tween_pos: Tween = get_tree().create_tween()
	tween_pos.tween_property(feedback, "position", feedback.position + Vector2(0, -5), 1)
	var tween_alpha: Tween = get_tree().create_tween()
	tween_alpha.tween_property(feedback, "self_modulate", Color(1,1,1,0), 1)
	await tween_pos.finished
	await tween_alpha.finished
	feedback.queue_free()
	
func display_total(score: ScoreCalculator.ScoreBreakdown):
	var total = $CenterContainer/VBoxContainer/PanelContainer/Score/Total
	var increment = 4
	var temp = 0
	while temp < score.final_score:
		total.text = str(temp)
		await bump_ui(total)
		if temp + increment > score.final_score:
			temp = score.final_score
			total.text = str(temp)
			await bump_ui(total)
		temp += increment
		increment += 1
	victory.play()


		
func bump_ui(target: Control):
	target.position.y -= 5
	var tween_source: Tween = get_tree().create_tween()
	tween_source.tween_property(target, "position", target.position + Vector2(0, 5), tween_time)
	_play_bubble_sound()
	await tween_source.finished
	if tween_time > 0.2:
		tween_time -= 0.025

func resolve_source(action: ScoreCalculator.ScoreOperation):
	if action.origin_artefact_idx == -1:
		return word_container.get_children()[action.evaluated_letter_idx]
	else:
		return artefacts_container.get_children()[action.origin_artefact_idx]

func resolve_target(action: ScoreCalculator.ScoreOperation):
	if action.letter_add_delta != 0 or action.letter_mult_delta or action.letter_fish_type_delta or action.letter_bonus_type_delta:
		return word_container.get_children()[action.evaluated_letter_idx]
	elif action.word_add_delta != 0:
		return $CenterContainer/VBoxContainer/PanelContainer/Score/Points
	elif action.word_mult_delta != 0:
		return $CenterContainer/VBoxContainer/PanelContainer/Score/Multiplicateur
	
func _play_bubble_sound():
	lettersScoring.volume_db = +3
	lettersScoring.stream = sound_bank[sound_index]
	lettersScoring.play()
	sound_index += 1
	if sound_index >= sound_bank.size():
		sound_index = 0
