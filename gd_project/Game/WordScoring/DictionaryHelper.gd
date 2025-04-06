class_name DictionaryHelper

enum Language
{
	English,
}

var ENGLISH_DICT_FILEPATH = "res://Game/WordScoring/english_dict.txt"

var words : Dictionary[String, bool] #bool as a value because we only care for the keys and to limit the dictionary size

func _init(language : Language):
	if language == Language.English:
		load_file(ENGLISH_DICT_FILEPATH)
	else:
		printerr("invalid language")

func load_file(filePath : String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	while !file.eof_reached():
		words[file.get_line()] = true
	print("Loaded " + str(words.size()) + " words")
	
func is_word_valid(word : Array[Letter]) -> bool:
	var word_as_string : String;
	for letter in word:
		word_as_string += letter.character.character
	word_as_string = word_as_string.to_lower()
	
	return words.has(word_as_string)
