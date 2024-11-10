extends Node3D

@export var rotation_sensibility := 1
@export var panning_sensibility := .1
@export var zoom_sensibility := .1
@onready var package_pivot = $PackagePivot

var rotating := false
var zooming := false
var panning := false

var current_mouse_relative := Vector2.ZERO
var current_mouse_velocity := Vector2.ZERO
var current_mouse_zoom_relative := Vector2.ZERO

var starting_rotation := Vector3.ZERO
var starting_position := Vector3.ZERO

var min_zoom = -1
var max_zoom = .3

func _ready() -> void:
	starting_rotation = package_pivot.rotation
	starting_position = package_pivot.position

func _process(delta: float):
	if !visible:
		return
		
	if rotating:
		if current_mouse_relative:
			package_pivot.rotate(Vector3.FORWARD, deg_to_rad(current_mouse_relative.normalized().y * rotation_sensibility))
			package_pivot.rotate(Vector3.RIGHT, deg_to_rad(current_mouse_relative.normalized().x * rotation_sensibility))

	if zooming:
		if current_mouse_relative:
			package_pivot.position.y = clamp(package_pivot.position.y + current_mouse_zoom_relative.y, min_zoom, max_zoom)
		
	if panning:
		if current_mouse_relative:
			package_pivot.position.z = package_pivot.position.z - (current_mouse_relative.normalized().x * panning_sensibility)
			package_pivot.position.x = package_pivot.position.x + (current_mouse_relative.normalized().y * panning_sensibility)
		
	if current_mouse_relative:
		current_mouse_relative = Vector2.ZERO


func _input(event: InputEvent):
	if !visible:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !rotating and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				rotating = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				rotating = false
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !panning and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				panning = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				panning = false
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			package_pivot.position.y = clamp(package_pivot.position.y + zoom_sensibility, min_zoom, max_zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			package_pivot.position.y = clamp(package_pivot.position.y - zoom_sensibility, min_zoom, max_zoom)
			
	if event is InputEventMouseMotion:
		current_mouse_relative = event.relative
		
	if event is InputEventPanGesture:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		current_mouse_zoom_relative = event.delta
		zooming = true
		
	if event is not InputEventPanGesture:
		zooming = false

func active():
	self.show()
	starting_rotation = package_pivot.rotation
	starting_position = package_pivot.position
	
	
func inactive():
	self.hide()
	package_pivot.rotation = starting_rotation
	package_pivot.position = starting_position
		
		
