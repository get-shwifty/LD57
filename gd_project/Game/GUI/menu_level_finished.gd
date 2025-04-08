extends Control

signal on_menu_closed;

func _ready():
	$MenuArtefactSelection.artefact_selected.connect(on_menu_closed.emit)

func initialize(total_points, artefacts, bonus=true) -> void:
	$Score.text = "Total points: " + str(total_points)
	$MenuArtefactSelection.initialize_bonus(artefacts, bonus)
