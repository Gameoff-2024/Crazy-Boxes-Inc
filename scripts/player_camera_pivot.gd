extends Node3D

signal on_rotating_start
signal on_rotating_stop

@export var rotation_sens := 0.5

var rotating := false
var current_lock_rotation := Vector3.ZERO
var current_mouse_relative:= Vector2.ZERO

func _process(delta: float):
	# Handle rotation state
	if rotating:
		# Mouse movement
		if current_mouse_relative:
			rotate(Vector3.DOWN, deg_to_rad(current_mouse_relative.x * rotation_sens))
			rotate(Vector3.RIGHT, deg_to_rad(current_mouse_relative.y * rotation_sens))
			current_lock_rotation = global_rotation
		# Frozen camera position
		else:
			global_rotation = current_lock_rotation
			
	if current_mouse_relative:
		current_mouse_relative = Vector2.ZERO

func _input(event: InputEvent):
	# Enable / disable rotating
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !rotating and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			rotating = true
			current_lock_rotation = global_rotation
			on_rotating_start.emit()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			rotating = false
			on_rotating_stop.emit()
			
	if event is InputEventMouseMotion:
		current_mouse_relative = event.relative
