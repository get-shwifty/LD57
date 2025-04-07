class_name ScoreCalculator

static func compute_score(word : Array[Letter], artefacts : Array[Artefact], var_context : VariableContext) -> ScoreBreakdown:
	var breakdown = ScoreBreakdown.new()
	
	var_context.reset_word_dependant_context()
	fill_word_dependent_context(word, var_context)
	
	var cond_context = ConditionContext.new()
	cond_context.is_word_palindrom = is_palidrom(word)
	cond_context.first_letter = word[0]
	cond_context.last_letter = word[-1]
	cond_context.word = word
	
	print("variable context is " + var_context.to_string())
	
	breakdown.fill_initial_values(word)
	breakdown.word = word
	breakdown.var_context = var_context
	breakdown.cond_context = cond_context
	
	for index_letter in word.size():
		var current_letter : Letter = word[index_letter]
		
		cond_context.reset_letter_dependant_context()
		cond_context.current_letter = word[index_letter]
		cond_context.previous_letter = word[index_letter-1] if index_letter > 0 else null
		cond_context.next_letter = word[index_letter+1] if index_letter < word.size()-1 else null
		
		var applicable_artifacts = get_applicable_artefacts(true, artefacts, var_context, cond_context)
		
		breakdown.current_letter_score = current_letter.character.base_value
		
		for a in applicable_artifacts:
			if a.artefact.target == Artefact.TargetType.LetterAdd:
				breakdown.register_operation(true, a, index_letter)
		
		for a in applicable_artifacts:
			if a.artefact.target == Artefact.TargetType.LetterMult:
				breakdown.register_operation(true, a, index_letter)
				
		if current_letter.bonus_type == Letter.BonusType.LetterMult1 || current_letter.bonus_type == Letter.BonusType.LetterMult2:
				breakdown.register_operation(true, null, index_letter)
		
		for a in applicable_artifacts:
			if a.artefact.target == Artefact.TargetType.WordAdd:
				breakdown.register_operation(true, a, index_letter)
		
		for a in applicable_artifacts:
			if a.artefact.target == Artefact.TargetType.WordMult:
				breakdown.register_operation(true, a, index_letter)
		
		if current_letter.bonus_type == Letter.BonusType.WordMult1 || current_letter.bonus_type == Letter.BonusType.WordMult2:
				breakdown.register_operation(true, null, index_letter, true)
	
	cond_context.reset_letter_dependant_context()
	var applicable_artifacts = get_applicable_artefacts(false, artefacts, var_context, cond_context)
	
	for a in applicable_artifacts:
		if a.artefact.target == Artefact.TargetType.WordAdd:
			breakdown.register_operation(false, a)
		
	for a in applicable_artifacts:
		if a.artefact.target == Artefact.TargetType.WordMult:
			breakdown.register_operation(false, a)
	
	breakdown.finish_breakdown()
	
	return breakdown

static func is_palidrom(word : Array[Letter]) -> bool:
	for index in range(0, word.size()/2):
		var left_letter = word[index].character.character
		var right_letter = word[-index-1].character.character
		if left_letter != right_letter:
			return false
	return true

static func get_applicable_artefacts(is_evaluating_letter : bool, artefacts : Array[Artefact], var_context : VariableContext, cond_context : ConditionContext) -> Array[ApplicableArtefact]:
	var applicable_artefacts : Array[ApplicableArtefact] = []
	var artefact_idx = 0
	for a in artefacts:
		if (a.trigger == Artefact.TriggerType.Letter) != is_evaluating_letter:
			artefact_idx += 1
			continue

		if !a.are_conditions_valid(var_context, cond_context):
			artefact_idx += 1
			continue
		
		applicable_artefacts.append(ApplicableArtefact.new(a, artefact_idx))
		artefact_idx += 1
		
	return applicable_artefacts

class ApplicableArtefact:
	var artefact : Artefact
	var artefact_idx : int
	
	func _init(artefact : Artefact, idx : int):
		self.artefact = artefact
		self.artefact_idx = idx

class ScoreBreakdown:
	var initial_word_add : int
	var initial_word_mult : int
	var operations : Array[ScoreOperation]
	var final_score : float
	
	#those are working context and should not used outside the score calculator
	var word : Array[Letter]
	var var_context : VariableContext
	var cond_context : ConditionContext
	var current_letter_score : int
	var current_word_add : float
	var current_word_mult : float
	
	func fill_initial_values(word : Array[Letter]):
		initial_word_add = 0
		initial_word_mult = 1
		for letter in word:
			var letter_add = letter.character.base_value
			initial_word_add += letter_add
		current_word_add = initial_word_add
		current_word_mult = initial_word_mult
	
	func register_operation(is_operating_on_letter : bool, artefact : ApplicableArtefact, letter_index : int = -1, evaluate_letter_word_mult : bool = false ):
		var artefact_idx = artefact.artefact_idx if artefact != null else -1
		var operation = ScoreOperation.new(letter_index, artefact_idx)
		
		if is_operating_on_letter:
			if artefact == null:
				if evaluate_letter_word_mult:
					if word[letter_index].bonus_type == Letter.BonusType.LetterMult1:
						operation.letter_mult_delta += 2
					elif word[letter_index].bonus_type == Letter.BonusType.LetterMult2:
						operation.letter_mult_delta += 3
				else:
					if word[letter_index].bonus_type == Letter.BonusType.WordMult1:
						operation.word_mult_delta += 2
					elif word[letter_index].bonus_type == Letter.BonusType.WordMult2:
						operation.word_mult_delta += 3
			else:
				match artefact.artefact.target:
					Artefact.TargetType.LetterAdd:
						operation.letter_add_delta = artefact.artefact.value.get_value(var_context)
					Artefact.TargetType.LetterMult:
						operation.letter_mult_delta = artefact.artefact.value.get_value(var_context)
					Artefact.TargetType.WordMult:
						operation.word_mult_delta = artefact.artefact.value.get_value(var_context)
					Artefact.TargetType.WordAdd:
						operation.word_add_delta = artefact.artefact.value.get_value(var_context)
		else:
			match artefact.artefact.target:
				Artefact.TargetType.LetterAdd || Artefact.TargetType.LetterMult:
					printerr("invalid target type")
				Artefact.TargetType.WordMult:
					operation.word_mult_delta = artefact.artefact.value.get_value(var_context)
				Artefact.TargetType.WordAdd:
					operation.word_add_delta = artefact.artefact.value.get_value(var_context)
		
		var current_letter_old_score = current_letter_score
		if operation.letter_add_delta != 0:
			current_letter_score += operation.letter_add_delta
		if operation.letter_mult_delta != 0:
			current_letter_score *= operation.letter_mult_delta
			
		var letter_score_delta = current_letter_score - current_letter_old_score
		if letter_score_delta != 0:
			current_word_add += letter_score_delta
		
		if operation.word_add_delta != 0:
			current_word_add += operation.word_add_delta
		if operation.word_mult_delta != 0:
			current_word_mult += operation.word_mult_delta
			
		operation.new_letter_score = current_letter_score
		operation.new_word_add = current_word_add
		operation.new_word_mult = current_word_mult
		
		operations.append(operation)
	
	func finish_breakdown():
		final_score = current_word_add * current_word_mult
		word = []
		var_context = null
		cond_context = null
		current_letter_score = 0
		current_word_add = 0
		current_word_mult = 0
		
class ScoreOperation:
	var letter_add_delta: float
	var letter_mult_delta: float
	
	var word_add_delta : float
	var word_mult_delta : float
	
	var new_letter_score : int
	var new_word_add : float
	var new_word_mult : float
	
	# empty if the word is targeted
	var evaluated_letter_idx : int
	
	#empty if it comes from the evaluated letter
	var origin_artefact_idx : int
	
	func _init(evaluated_letter_idx : int, origin_artefact_idx : int):
		self.evaluated_letter_idx = evaluated_letter_idx
		self.origin_artefact_idx = origin_artefact_idx

static func fill_word_dependent_context(word : Array[Letter], context : VariableContext):
	var fishes_in_word : Dictionary[Letter.FishType, bool]
	for letter in word:
		context.letter_count += 1
		if letter.character.is_vowel:
			context.vowel_count += 1
		if letter.character.is_consonant():
			context.consonant_count += 1
		if letter.bonus_type != Letter.BonusType.None:
			context.bonus_letter_count += 1
		fishes_in_word[letter.fish_type] = true;
	context.fish_type_count = fishes_in_word.size()
