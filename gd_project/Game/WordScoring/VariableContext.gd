class_name VariableContext

enum VariableType
{
	None,
	LetterCount,
	VowelCount,
	ConsonantCount,
	FishTypeCount,
	BonusLetterCount,
	RemainingOxygen,
	GrappleCount,
}

var letter_count : int
var vowel_count : int
var consonant_count : int
var fish_type_count : int
var bonus_letter_count : int
var remaining_oxygen : int
var grapple_count : int

func get_variable(variable : VariableType) -> int:
	match variable:
		VariableType.LetterCount:
			return letter_count
		VariableType.VowelCount:
			return vowel_count
		VariableType.ConsonantCount:
			return consonant_count
		VariableType.FishTypeCount:
			return fish_type_count
		VariableType.BonusLetterCount:
			return bonus_letter_count
		VariableType.RemainingOxygen:
			return remaining_oxygen
		VariableType.GrappleCount:
			return grapple_count

	printerr("missing variable")
	return 0

func reset():
	reset_word_dependant_context()
	remaining_oxygen = 0
	grapple_count = 0

func reset_word_dependant_context():
	letter_count = 0
	vowel_count = 0
	consonant_count = 0
	fish_type_count = 0
	bonus_letter_count = 0

func _to_string():
	var format = "%d letters, %d vowels, %d consonants, %d bonuses, %d fishTypes, %d oxygen, %d grapple"
	var formated_string = format % [letter_count, vowel_count, consonant_count, bonus_letter_count, fish_type_count, remaining_oxygen, grapple_count]
	return formated_string
