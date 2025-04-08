class_name MapRoom
extends Node2D

signal selected(room: Room)

const SCALE := Vector2(1, 1)
const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.CLASSIC: [0, SCALE],
	Room.Type.MINI_BOSS: [4, SCALE],
	Room.Type.BOSS: [2, SCALE],
	Room.Type.SHOP: [1, SCALE],
}

@onready var icon: AnimatedSprite2D = $RoomVisuals/AnimatedSprite2D
@onready var line_2d: Line2D = $RoomVisuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room

func set_available(new_value: bool) -> void:
	available = new_value
	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")

func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	
	icon.frame = ICONS[room.type][0]
	icon.scale = ICONS[room.type][1]

func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_map_room_selected() -> void:
	if not available :
		return
	
	room.selected = true
	animation_player.play("select")
	selected.emit(room)


func _on_button_mouse_entered() -> void:
	pass
	#Popups.ItemPopup()
	

func _on_button_mouse_exited() -> void:
	pass
	#Popups.HideItemPopup()
