extends Node3D

@onready var camera_pivot: Node3D = $CameraPivot

var mouse_sens = 1000

#func _input(event):
	#if event is InputEventMouseMotion:
		#camera_pivot.rotation.y -= event.relative.x / mouse_sens
		#camera_pivot.rotation.x -= event.relative.y / mouse_sens
		#camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(90))
