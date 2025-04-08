extends Node2D

signal start_game()

func _ready() -> void:
	$Start_Button.call_deferred("grab_focus")
	for fish in $fish.get_children():
		if fish.get_class() == "CharacterBody2D":
			fish.set_letter("")

func _on_button_pressed() -> void:
	start_game.emit()


func _on_murene_play_on_captured() -> void:
	start_game.emit()
