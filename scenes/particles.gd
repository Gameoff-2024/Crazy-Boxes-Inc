extends Node3D

func emit():
	for child in get_children():
		child.emitting = true
