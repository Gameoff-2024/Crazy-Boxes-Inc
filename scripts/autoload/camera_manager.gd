extends Node3D

var player_camera: Camera3D
var package_camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cameras = get_tree().get_nodes_in_group("camera")
	for camera in cameras:
		if (camera.name == "PackageCamera"):
			package_camera = camera
		else:
			player_camera = camera
	
	player_camera.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
		if (player_camera.current):
			%Package.visible = true
			package_camera.make_current()
		else:
			player_camera.make_current()
			%Package.visible = false
