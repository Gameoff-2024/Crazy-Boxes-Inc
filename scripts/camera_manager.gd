extends Node3D

var player_camera: Camera3D
var package_camera: Camera3D

func _ready() -> void:
	var cameras = get_tree().get_nodes_in_group("camera")
	for camera in cameras:
		if (camera.name == "PackageCamera"):
			package_camera = camera
		else:
			player_camera = camera
	
	player_camera.make_current()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
		if (player_camera.current):
			%QuestDisplayer.active()
			package_camera.make_current()
		else:
			player_camera.make_current()
			%QuestDisplayer.inactive()
			
