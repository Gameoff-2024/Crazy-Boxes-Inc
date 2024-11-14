extends RigidBody3D

class_name Box

signal box_quest_object_touched(box: Box, quest_id: int)

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
	var quest_id = body.owner.get_meta("quest_id", -1)
	
	if quest_id >= 0:
		box_quest_object_touched.emit(self, quest_id)
 
