class_name Character

var frequency : int;
var base_value : int;
var character : String;
var is_vowel : bool;

func _init(character : String, frequency : int, base_value : int = 1, is_vowel :bool = false):
	self.frequency = frequency
	self.base_value = base_value
	self.character = character
	self.is_vowel = is_vowel

func is_consonant() -> bool:
	return !is_vowel;
