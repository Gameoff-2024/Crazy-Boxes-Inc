extends RigidBody3D

class_name Box

signal box_quest_object_collided(box: Box)

func _ready():
	contact_monitor = true
	for child in get_children():
		if child is MeshInstance3D:
			center_of_mass_mode = CENTER_OF_MASS_MODE_AUTO
			#center_of_mass = Vector3(0, child.mesh.get_aabb().size.y / 2, 0)
			#center_of_mass = Vector3(-10, 0, 0)
			return

func _on_lifetime_timer_timeout():
	queue_free()

func _on_body_entered(body: Node) -> void:
	box_quest_object_collided.emit(self)
 
