class_name Alphabet

static var english_characters : Array[Character] = [
	Character.new("A", 9, 1, true),
	Character.new("B", 2, 3),
	Character.new("C", 2, 3),
	Character.new("D", 4, 2),
	Character.new("E", 12, 1, true),
	Character.new("F", 2, 4),
	Character.new("G", 3, 2),
	Character.new("H", 2, 4),
	Character.new("I", 9, 1, true),
	Character.new("J", 1, 8),
	Character.new("K", 1, 5),
	Character.new("L", 4),
	Character.new("M", 2, 3),
	Character.new("N", 6),
	Character.new("O", 8, 1, true),
	Character.new("P", 2, 3),
	Character.new("Q", 1, 10),
	Character.new("R", 6),
	Character.new("S", 4),
	Character.new("T", 6),
	Character.new("U", 4, 1, true),
	Character.new("V", 2, 4),
	Character.new("W", 2, 4),
	Character.new("X", 1, 8),
	Character.new("Y", 2, 4, true),
	Character.new("Z", 1, 10),
];

static var french_characters : Array[Character] = [
	Character.new("A", 9, 1, true),
	Character.new("B", 2, 3),
	Character.new("C", 2, 3),
	Character.new("D", 3, 2),
	Character.new("E", 15, 1, true),
	Character.new("F", 2, 4),
	Character.new("G", 2, 2),
	Character.new("H", 2, 4),
	Character.new("I", 8, 1, true),
	Character.new("J", 1, 8),
	Character.new("K", 1, 10),
	Character.new("L", 5, 1),
	Character.new("M", 3, 2),
	Character.new("N", 6, 1),
	Character.new("O", 6, 1, true),
	Character.new("P", 2, 3),
	Character.new("Q", 1, 8),
	Character.new("R", 6, 1),
	Character.new("S", 6, 1),
	Character.new("T", 6, 1),
	Character.new("U", 6, 1, true),
	Character.new("V", 2, 4),
	Character.new("W", 1, 10),
	Character.new("X", 1, 10),
	Character.new("Y", 1, 10, true),
	Character.new("Z", 1, 10),
];

static func get_all_characters():
	match DictionaryHelper.current_lang:
		"en":
			return english_characters
		"fr":
			return french_characters
	
static func get_character(character : String) -> Character:
	for c in get_all_characters():
		if c.character == character.to_upper():
			return c
	
	#log error
	return null

static func get_random_characters(n: int = 16):
	var all_letters = []
	for c: Character in get_all_characters():
		for i in range(c.frequency):
			all_letters.append(c)
	all_letters.shuffle()
	return all_letters.slice(0, n)
