extends Node3D

@export var rotation_sens := 0.5
@onready var package_pivot = $PackagePivot

var rotating := false
var panning := false
var wheel := false
var current_lock_rotation := Vector3.ZERO
var current_mouse_relative:= Vector2.ZERO

var min_zoom = 0.5
var max_zoom = 2
var zoom_level = 1
var zoom_factor = 0.1

func _process(delta: float):
	if !visible:
		return
		
	if rotating:
		if current_mouse_relative:
			package_pivot.rotate(Vector3.FORWARD, deg_to_rad(-current_mouse_relative.y * rotation_sens))
			package_pivot.rotate(Vector3.RIGHT, deg_to_rad(current_mouse_relative.x * rotation_sens))
			current_lock_rotation = global_rotation
		# Frozen camera position
		else:
			global_rotation = current_lock_rotation
			
	if panning:
		package_pivot.position.y = clamp(package_pivot.position.y + current_mouse_relative.y, -1, 0)
	
			
	if current_mouse_relative:
		current_mouse_relative = Vector2.ZERO


func _input(event: InputEvent):
	if !get_parent().visible:
		return
		
	# Enable / disable rotating
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !rotating and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				rotating = true
				current_lock_rotation = global_rotation
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				rotating = false
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or \
			event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if !panning and event.pressed:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					panning = true
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					panning = false
			
	if event is InputEventMouseMotion:
		current_mouse_relative = event.relative
		
	if event is InputEventPanGesture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		current_mouse_relative = event.delta
		panning = true
		
	if event is not InputEventPanGesture:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		panning = false
		
	
