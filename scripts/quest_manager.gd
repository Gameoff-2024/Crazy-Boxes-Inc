extends Node3D

class_name QuestManager

signal show_quest_indicator
signal disable_box_shooting
signal enable_box_shooting

@export var rotation_sensibility := 1
@export var panning_sensibility := .1
@export var zoom_sensibility := .1
@export var active_quest_id : int = -1
@export var quest_indicator: Node3D

@onready var quest_displayer = $QuestDisplayer
@onready var no_quest_displayer = %NoQuestDisplayer
@onready var package_pivot = $QuestDisplayer/PackagePivot

var rotating := false
var zooming := false
var panning := false

var current_mouse_relative := Vector2.ZERO
var current_mouse_velocity := Vector2.ZERO
var current_mouse_zoom_relative := Vector2.ZERO

var starting_rotation := Vector3.ZERO
var starting_position := Vector3.ZERO

var min_zoom = -1
var max_zoom = 0

var quest_loader = QuestLoader.new()

var active_quest: Quest


func _ready() -> void:
	starting_rotation = package_pivot.rotation
	starting_position = package_pivot.position
	inactive()
	
	# To debug a specific quest. Works only in debug builds or when run in the editor!
	if OS.is_debug_build() and active_quest_id >= 0:
		active_quest = quest_loader.choose_quest(active_quest_id)
		set_quest(active_quest)
		active()
		

func _process(delta: float):
	if !quest_displayer.visible:
		return
		
	if rotating:
		if current_mouse_relative:
			package_pivot.rotate(Vector3.FORWARD, deg_to_rad(current_mouse_relative.normalized().x * rotation_sensibility))
			package_pivot.rotate(Vector3.RIGHT, deg_to_rad(current_mouse_relative.normalized().y * rotation_sensibility))

	if zooming:
		if current_mouse_relative:
			package_pivot.position.z = clamp(package_pivot.position.z + current_mouse_zoom_relative.y, min_zoom, max_zoom)
		
	if panning:
		if current_mouse_relative:
			package_pivot.position.y = package_pivot.position.y - (current_mouse_relative.normalized().y * panning_sensibility)
			package_pivot.position.x = package_pivot.position.x + (current_mouse_relative.normalized().x * panning_sensibility)
		
	if current_mouse_relative:
		current_mouse_relative = Vector2.ZERO


func _input(event: InputEvent):
	if !quest_displayer.visible:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !rotating and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				rotating = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				rotating = false
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !panning and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				panning = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				panning = false
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			package_pivot.position.z = clamp(package_pivot.position.z + zoom_sensibility, min_zoom, max_zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			package_pivot.position.z = clamp(package_pivot.position.z - zoom_sensibility, min_zoom, max_zoom)
			
	if event is InputEventMouseMotion:
		current_mouse_relative = event.relative
		
	if event is InputEventPanGesture:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		current_mouse_zoom_relative = event.delta
		zooming = true
		
	if event is not InputEventPanGesture:
		zooming = false

func active():
	$QuestDisplayer.show()
	starting_rotation = package_pivot.rotation
	starting_position = package_pivot.position
	
	
func inactive():
	$QuestDisplayer.hide()
	package_pivot.rotation = starting_rotation
	package_pivot.position = starting_position
	

func set_quest(quest: Quest):
	$QuestDisplayer.set_quest(quest)


func _on_main_new_quest() -> void:
	choose_new_quest()
	
	
func register_in_game_box(box: Box):
	box.box_quest_object_touched.connect(_on_box_quest_object_touched)


func _on_box_quest_object_touched(box: Box, quest_id: int):
	if active_quest and quest_id == active_quest.id:
		active_quest = null
		GameState.score_add_one()
		box.queue_free()
		emit_signal("show_quest_indicator")
		emit_signal("disable_box_shooting")
		$QuestDisplayer.inactive()
		no_quest_displayer.show()


func choose_new_quest():
	active_quest = quest_loader.choose_random_quest()
	if active_quest:
		set_quest(active_quest)
		emit_signal("enable_box_shooting")
	

func _on_quest_indicator_indicator_triggered() -> void:
	choose_new_quest()
	$QuestDisplayer.active()
	no_quest_displayer.hide()
