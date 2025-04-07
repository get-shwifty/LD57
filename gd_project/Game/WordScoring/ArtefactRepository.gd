class_name ArtefactRepository

static var starting = generate_starting()
static var bonuses = generate_bonuses()
static var maluses = generate_maluses()

static func generate_bonuses() -> Array[Artefact]:
	var artefacts : Array[Artefact] = []
	var artefact : Artefact = null
	
	artefact = Artefact.new()
	artefact.name = "Oddly specific"
	artefact.description = "+50 points if word has an odd letter count"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = ComputedValue.new(50)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return vc.letter_count % 2 != 0
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Left friend" # find a better word
	artefact.description = "+10 if previous letter is a similar fish"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterAdd
	artefact.value = ComputedValue.new(10)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.previous_letter != null && cc.previous_letter.fish_type == cc.current_letter.fish_type
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Local Diversity"
	artefact.description = "x4 if not surrounded by similar fishes"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterMult
	artefact.value = ComputedValue.new(4)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var is_previous_similar = (cc.previous_letter != null && cc.previous_letter.fish_type == cc.current_letter.fish_type)
		var is_next_similar = (cc.next_letter != null && cc.next_letter.fish_type == cc.current_letter.fish_type)
		return is_previous_similar && is_next_similar;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Global Diversity"
	artefact.description = "+6 word mult if at least 3 types of fishes"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(6)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var fishes_in_word : Dictionary[Letter.FishType, bool]
		for letter in cc.word:
			fishes_in_word[letter.fish_type] = true;
		return fishes_in_word.size() > 3
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Crab together strong"
	artefact.description = "+20 word mult if only crabs"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(20)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		for letter in cc.word:
			if letter.fish_type != Letter.FishType.Crab:
				return false
		return true
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "One man clown"
	artefact.description = "+200 word points if only one clown"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = ComputedValue.new(200)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var crab_count = 0
		for letter in cc.word:
			if letter.fish_type == Letter.FishType.Crab:
				crab_count += 1
		return crab_count == 1
	artefacts.append(artefact)

	artefact = Artefact.new()
	artefact.name = "Bling Bling"
	artefact.description = "+2 word mult per bonus letter"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(2)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.bonus_type != Letter.BonusType.None
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Release the Skraken"
	artefact.description = "x10 if letter is the only medusa in a 7 letter word"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(2)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		if cc.current_letter.fish_type != Letter.FishType.Medusa:
			return false
			
		if vc.letter_count != 7:
			return false
			
		var medusa_count = 0
		for letter in cc.word:
			if letter.fish_type == Letter.FishType.Medusa:
				medusa_count += 1
		return medusa_count == 1
	artefacts.append(artefact)

	artefact = Artefact.new()
	artefact.name = "We're even"
	artefact.description = "+2 mult if word has an even letter count"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(2)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return vc.letter_count % 2 == 0
	artefacts.append(artefact)

	artefact = Artefact.new()
	artefact.name = "Choir vocals"
	artefact.description = "+100 if first and last letters are vowels"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = ComputedValue.new(100)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.first_letter.character.is_vowel && cc.last_letter.character.is_vowel
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Expletive sounds"
	artefact.description = "x4 if letter is consonant and surrounded by consonant"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterMult
	artefact.value = ComputedValue.new(4)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var previous_consonant = cc.previous_letter != null && cc.previous_letter.character.is_consonant()
		var next_consonant = cc.next_letter != null && cc.next_letter.character.is_consonant()
		return cc.current_letter.character.is_consonant() && previous_consonant && next_consonant 
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Vocalization"
	artefact.description = "+5 if letter is a vowel and a clown"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterAdd
	artefact.value = ComputedValue.new(5)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.fish_type == Letter.FishType.Clown && cc.current_letter.character.is_vowel;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Yeeeeeeeeha"
	artefact.description = "+5 per E if there are more E than A in the word"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterAdd
	artefact.value = ComputedValue.new(5)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		if cc.current_letter.character.character != "E":
			return false
		
		var delta
		for letter in cc.word:
			if letter.character.character == "E":
				delta += 1
			elif letter.character.character == "A":
				delta -+ 1
		return delta > 0
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Jellymorphism"
	artefact.description = "If letter is a medusa, transforms into previous fish"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterFishType
	artefact.value = func(vc: VariableContext, cc: ConditionContext):
		return cc.previous_letter.fish_type
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.fish_type == Letter.FishType.Medusa && cc.previous_letter != null
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Enjellyfication"
	artefact.description = "Transform into medusa if previous fish is a medusa"
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterFishType
	artefact.value = Letter.FishType.Medusa
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.previous_letter != null && cc.previous_letter.fish_type == Letter.FishType.Medusa 
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "The more the merrier"
	artefact.description = "+4 mult if there is more clownfish in the word than in the letter pool"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = 4
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var clowns_in_word = 0
		for l in cc.word:
			if l.fish_type == Letter.FishType.Clown:
				clowns_in_word += 1
		var clowns_in_pool = 0
		for l in cc.letter_pool:
			if l.fish_type == Letter.FishType.Clown:
				clowns_in_pool += 1
		return clowns_in_word > clowns_in_pool
	artefacts.append(artefact)
	
	return artefacts

static func generate_maluses() -> Array[Artefact]:
	var artefacts : Array[Artefact] = []
	var artefact : Artefact = null
	
	
	artefact = Artefact.new()
	artefact.name = "Crabastrophic"
	artefact.description = "-100 points if word contains a crab"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = ComputedValue.new(100)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		for letter in cc.word:
			if letter.fish_type == Letter.FishType.Crab:
				return true
		return false
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "No fun allowed"
	artefact.description = "-4 word mult per clown fish"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(-4)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.current_letter.fish_type == Letter.FishType.Clown
	artefacts.append(artefact)

	artefact = Artefact.new()
	artefact.name = "Preadtory behaviour"
	artefact.description = "x0.5 if fish nearby are different"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterMult
	artefact.value = ComputedValue.new(0.50)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var is_previous_different = (cc.previous_letter != null && cc.previous_letter.fish_type != cc.current_letter.fish_type)
		var is_next_different = (cc.next_letter != null && cc.next_letter.fish_type != cc.current_letter.fish_type)
		return is_previous_different || is_next_different;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Electric danger"
	artefact.description = "-10 if medusa nearby"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Letter
	artefact.target = Artefact.TargetType.LetterMult
	artefact.value = ComputedValue.new(-10)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		var is_previous_medusa = (cc.previous_letter != null && cc.previous_letter.fish_type == Letter.FishType.Medusa)
		var is_next_medusa = (cc.next_letter != null && cc.next_letter.fish_type != Letter.FishType.Medusa)
		return is_previous_medusa || is_next_medusa;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Cheat ban"
	artefact.description = "-4 mult if word contains bonus letter"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(-4)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		for letter in cc.word:
			if letter.bonus_type != Letter.BonusType.None:
				return true
		return false
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Against all odds"
	artefact.description = "-100 if word has an odd letter count"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = ComputedValue.new(-100)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return vc.letter_count % 2 != 0;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Buffer overflow"
	artefact.description = "-10 points per letter remaining in the pool"
	artefact.is_malus = true
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = func(vc: VariableContext, cc: ConditionContext):
		return cc.letter_pool.size() * -10;
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return cc.letter_pool.size() > 0;
	artefacts.append(artefact)
	
	return artefacts

static func generate_starting() -> Array[Artefact]:
	var artefacts : Array[Artefact] = []
	var artefact : Artefact = null
	
	artefact = Artefact.new()
	artefact.name = "Under pressure"
	artefact.description = "Add remaining oxygen to world mult"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordMult
	artefact.value = ComputedValue.new(0, VariableContext.VariableType.RemainingOxygen)
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return true;
	artefacts.append(artefact)
	
	artefact = Artefact.new()
	artefact.name = "Size matters"
	artefact.description = "Add letter count squared to word points"
	artefact.trigger = Artefact.TriggerType.Word
	artefact.target = Artefact.TargetType.WordAdd
	artefact.value = func(vc: VariableContext, cc: ConditionContext):
		return pow(cc.letter_pool.size(), 2) 
	artefact.condition = func(vc: VariableContext, cc: ConditionContext) -> bool:
		return true;
	artefacts.append(artefact)
	
	return artefacts
	
static func get_artefact(name : String):
	for a in bonuses:
		if a.name == name:
			return a;
	for a in maluses:
		if a.name == name:
			return a;
	for a in starting:
		if a.name == name:
			return a;
