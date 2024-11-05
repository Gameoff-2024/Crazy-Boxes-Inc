@tool
extends EditorScenePostImport

func _post_import(scene):
	var mesh_instance: MeshInstance3D = scene.get_child(0).get_child(0)
	mesh_instance.position = Vector3(0.0, 0.0, 0.0)
	mesh_instance.scale = Vector3(5.5, 5.5, 5.5)
	return scene
