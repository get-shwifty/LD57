class_name Room
extends Resource

enum Type {NOT_ASSIGNED, CLASSIC, BOSS, MINI_BOSS, SHOP}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false

# Surcharge de la fonction pour déboguer de la map générée
func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
