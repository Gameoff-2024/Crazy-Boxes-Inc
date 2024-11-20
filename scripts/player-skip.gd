extends Node3D

func hide_boxes():
	for child in get_children():
		if child.name != "skip":
			child.hide()
		
		
func show_boxes():
	for child in get_children():
		if child.name != "skip":
			child.show()
