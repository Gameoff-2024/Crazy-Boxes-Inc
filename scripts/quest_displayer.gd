extends Node3D

@onready var packageMesh: MeshInstance3D = $PackagePivot/Package/PackageMesh
@onready var basePath: String = "PackagePivot/Package"

func set_quest(quest: Quest) -> void:
	if quest.color:
		var material = packageMesh.mesh.surface_get_material(0)
		if material is StandardMaterial3D:
			material.albedo_color = quest.color
	
	for element: Element in quest.elements:
		var side = Element.PackageSide.keys()[element.side]
		var pic: MeshInstance3D = get_node(NodePath(basePath + "/" + side + "/Picture"))
		var textLabel: Label3D = get_node(NodePath(basePath + "/" + side + "/TextLabel"))
		var decal1: Decal = get_node(NodePath(basePath + "/" + side + "/Decal1"))
		var decal2: Decal = get_node(NodePath(basePath + "/" + side + "/Decal2"))
		
		if element.picture:
			pic.show()
			var material = pic.get_surface_override_material(0)
			if material is StandardMaterial3D:
				material.albedo_texture = element.picture
		else:
			pic.hide()
			
		if element.textLabel:
			textLabel.text = element.textLabel
			textLabel.show()
		else:
			textLabel.hide()
			
		if element.decal1:
			decal1.show()
			decal1.texture_albedo = element.decal1
		else:
			decal1.hide()
			
		if element.decal2:
			decal2.show()
			decal2.texture_albedo = element.decal2
		else:
			decal2.hide()
			
