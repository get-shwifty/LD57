class_name Letter

enum FishType
{
	Crab,
	Medusa,
	Clown,
	Eel,
}

enum BonusType
{
	None,
	LetterMult1,
	LetterMult2,
	WordMult1,
	WordMult2,
}

var character : Character
var fish_type : FishType
var bonus_type : BonusType

func _init(character : Character, fish_type : FishType = FishType.Clown, bonus_type : BonusType = BonusType.None):
	self.character = character
	self.fish_type = fish_type
	self.bonus_type = bonus_type
