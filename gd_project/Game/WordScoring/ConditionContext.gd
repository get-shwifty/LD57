class_name ConditionContext

var first_letter : Letter
var last_letter : Letter
var previous_letter : Letter
var current_letter : Letter
var next_letter : Letter

var is_word_palindrom : bool

func reset():
	reset_letter_dependant_context()
	is_word_palindrom = false;
	first_letter = null
	last_letter = null

func reset_letter_dependant_context():
	previous_letter = null
	current_letter = null
	next_letter = null
