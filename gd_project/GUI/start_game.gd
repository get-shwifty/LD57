extends CanvasLayer

signal start_game

func _ready() -> void:
	$Button.call_deferred("grab_focus")


func _on_button_pressed() -> void:
	emit_signal("start_game")
