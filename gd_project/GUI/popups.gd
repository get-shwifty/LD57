extends Control

## Index dans le dictionnaire: nb de poissons
const LEVEL_FISHES := {
	0: 6,
	1: 3,
	2: 2,
	3: 4
}

@onready var popup: Panel = %ItemPopup

func ItemPopup():
	for fishes in popup.get_child(0).get_children():
		if fishes.get_child_count() > 0:
			var label = fishes.get_node("NbFish")
			label.set_text(str(LEVEL_FISHES[fishes.get_index()-1]))
	popup.show()

func HideItemPopup():
	popup.hide()
