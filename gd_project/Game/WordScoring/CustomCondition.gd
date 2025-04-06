class_name CustomCondition

enum TargetType
{
	Word,
	FirstLetter,
	LastLetter,
	NextLetter,
	CurrentLetter,
	PreviousLetter,
}

enum LetterCondition
{
	None,
	Vowel,
	Consonant,
	SameFish,
	DifferentFish,
	SpecificFish,
	HasBonus,
	NoBonus,
}

enum WordCondition
{
	None,
	Palindrom
}

var target : TargetType
var letter_condition : LetterCondition
var word_condition : WordCondition

#specific stuff
var specificFish : Letter.FishType = Letter.FishType.Clown

func _init(target : TargetType, letter_cond : LetterCondition, word_cond : WordCondition = WordCondition.None):
	self.target = target
	self.letter_condition = letter_cond
	self.word_condition = word_cond

func get_result(context : ConditionContext) -> bool:
	if target == TargetType.Word:
		return get_word_condition_result(context)
	
	var target_letter = null
	match target:
		TargetType.PreviousLetter:
			target_letter = context.previous_letter
		TargetType.NextLetter:
			target_letter = context.next_letter
		TargetType.FirstLetter:
			target_letter = context.first_letter
		TargetType.CurrentLetter:
			target_letter = context.current_letter	
		TargetType.LastLetter:
			target_letter = context.last_letter	
	
	if target_letter == null:
		printerr("null target letter")
		return false
	
	return get_letter_condition_result(target_letter, context.current_letter)

func get_word_condition_result(context : ConditionContext) -> bool:
	match word_condition:
		WordCondition.None:
			printerr("word condition error")
			return false
		WordCondition.Palindrom:
			return context.is_word_palindrom
	printerr("missing case in word condition result")
	return false


func get_letter_condition_result(target_letter : Letter, current_letter : Letter) -> bool:
	match letter_condition:
		LetterCondition.None:
			printerr("letter condition is none")
			return false
		LetterCondition.Vowel:
			return target_letter.character.is_vowel
		LetterCondition.Consonant:
			return target_letter.character.is_consonant()
		LetterCondition.HasBonus:
			return target_letter.bonus_type != Letter.BonusType.None;
		LetterCondition.NoBonus:
			return target_letter.bonus_type == Letter.BonusType.None;
		LetterCondition.SpecificFish:
			return target_letter.fish_type == specificFish
		LetterCondition.SameFish:
			return target_letter.fish_type == current_letter.fish_type
		LetterCondition.DifferentFish:
			return target_letter.fish_type != current_letter.fish_type
	printerr("missing case in letter condition result")
	return false
