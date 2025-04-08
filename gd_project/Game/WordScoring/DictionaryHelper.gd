class_name DictionaryHelper

enum Language
{
	English,
}

static var current_lang = "en"

var ENGLISH_DICT_FILEPATH = "res://Game/WordScoring/english_dict.txt"
var FRENCH_DICT_FILEPATH = "res://Game/WordScoring/french_dict.txt"

var words_en : Dictionary[String, bool] #bool as a value because we only care for the keys and to limit the dictionary size
var words_fr : Dictionary[String, bool] #bool as a value because we only care for the keys and to limit the dictionary size
var words:
	get():
		match DictionaryHelper.current_lang:
			"en":
				return words_en
			"fr":
				return words_fr

func _init(language : Language):
	load_file(words_en, ENGLISH_DICT_FILEPATH)
	load_file(words_fr, FRENCH_DICT_FILEPATH)

func load_file(words_to_fill, filePath : String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	while !file.eof_reached():
		var word = file.get_line()
		if word.length() <= 1:
			#avoid single letter words
			continue
		words_to_fill[word.to_lower()] = true
	print("Loaded " + str(words_to_fill.size()) + " words")
	
func is_word_valid(word : Array[Letter]) -> bool:
	var word_as_string : String;
	for letter in word:
		word_as_string += letter.character.character
	word_as_string = word_as_string.to_lower()
	
	return words.has(word_as_string)
