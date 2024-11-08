extends Node3D

@export var rotation_sens := 0.01

var rotating := false

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			rotating = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			rotating = false
	
	if event is InputEventMouseMotion and rotating:
		rotate(Vector3.UP, deg_to_rad(event.screen_velocity.x * rotation_sens))
		rotate(Vector3.LEFT, deg_to_rad(event.screen_velocity.y * rotation_sens))
		
