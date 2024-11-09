extends RigidBody3D

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			center_of_mass_mode = CENTER_OF_MASS_MODE_AUTO
			#center_of_mass = Vector3(0, child.mesh.get_aabb().size.y / 2, 0)
			#center_of_mass = Vector3(-10, 0, 0)
			return

func _on_lifetime_timer_timeout():
	queue_free()
