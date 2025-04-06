class_name MapRoom
extends Area2D

signal selected(room: Room)

const SCALE := Vector2(0.1, 0.1)
const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.CLASSIC: [preload("res://GUI/icon.svg"), SCALE],
	Room.Type.MINI_BOSS: [preload("res://GUI/icon_boss.jpg"), SCALE],
	Room.Type.BOSS: [preload("res://GUI/icon_boss.jpg"), SCALE],
	Room.Type.SHOP: [preload("res://GUI/icon_shop.jpg"), SCALE],
}

@onready var sprite_2d: Sprite2D = $RoomVisuals/Sprite2D
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
	
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]

func show_selected() -> void:
	line_2d.modulate = Color.PALE_GREEN

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	room.selected = true
	animation_player.play("select")

func _on_map_room_selected() -> void:
	selected.emit(room)
