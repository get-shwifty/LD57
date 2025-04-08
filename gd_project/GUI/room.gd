class_name Room
extends Resource

enum Type
{
	NOT_ASSIGNED,
	LEVEL, 
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	LEVEL_6,
	LEVEL_7,
	BOSS,
	MINI_BOSS,
	SHOP
}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false

# Surcharge de la fonction pour déboguer de la map générée
func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
