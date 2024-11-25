extends Node3D

var player_camera: Camera3D
var quest_camera: Camera3D

var mouse_cursor = load("res://assets/ui/crosshair002.png")

func _ready() -> void:
	var cameras = get_tree().get_nodes_in_group("camera")
	for camera in cameras:
		if (camera.name == "QuestCamera"):
			quest_camera = camera
		else:
			player_camera = camera
	player_camera_make_active()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
		if player_camera.current:
			quest_camera_make_active()
		else:
			player_camera_make_active()
			
	if Input.is_action_just_pressed("ui_cancel") and quest_camera.current:
		player_camera_make_active()
		

func quest_camera_make_active():
	%QuestManager.active()
	quest_camera.make_current()
	player_camera.get_parent().active = false
	Input.set_custom_mouse_cursor(null)
	
	
func player_camera_make_active():
	player_camera.make_current()
	player_camera.get_parent().active = true
	%QuestManager.inactive()
	Input.set_custom_mouse_cursor(mouse_cursor, 0, Vector2(32, 32))
