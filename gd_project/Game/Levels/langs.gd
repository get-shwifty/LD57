extends Control

func _on_button_en_pressed() -> void:
	$ButtonEN.button_pressed = true
	$ButtonFR.button_pressed = false
	DictionaryHelper.current_lang = "en"

func _on_button_fr_pressed() -> void:
	$ButtonEN.button_pressed = false
	$ButtonFR.button_pressed = true
	DictionaryHelper.current_lang = "fr"
