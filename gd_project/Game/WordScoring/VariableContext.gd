class_name VariableContext

enum VariableType
{
	None,
	LetterCount,
	VowelCount,
	ConsonantCount,
	RemainingOxygen,
	GrappleCount,
}

var letter_count : int
var vowel_count : int
var consonant_count : int
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

func _to_string():
	var format = "%d letters, %d vowels, %d consonants, %d oxygen, %d grapple"
	var formated_string = format % [letter_count, vowel_count, consonant_count, remaining_oxygen, grapple_count]
	return formated_string
