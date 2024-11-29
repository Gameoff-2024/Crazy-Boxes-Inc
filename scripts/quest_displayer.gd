extends Node3D

@onready var packageMesh: MeshInstance3D = $PackagePivot/Package/PackageMesh
@onready var packagePivot: Node3D = $PackagePivot
@onready var basePath: String = "PackagePivot/Package"

func set_quest(quest: Quest) -> void:
	reset_quest()
	
	if quest.color.a != 0:
		var package_material = packageMesh.mesh.surface_get_material(0)
		if package_material is StandardMaterial3D:
			package_material.albedo_color = quest.color
		
	if quest.material and quest.material is ShaderMaterial:
		quest.material.set_shader_parameter("active", true)
		packageMesh.set_surface_override_material(0, quest.material)
	else:
		packageMesh.set_surface_override_material(0, null)
	
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
			var material = pic.get_surface_override_material(0)
			if material is StandardMaterial3D:
				material.albedo_texture = null
			
		if element.textLabel:
			textLabel.text = element.textLabel
			textLabel.show()
		else:
			textLabel.hide()
			textLabel.text = ""
			
		if element.decal1:
			decal1.show()
			decal1.texture_albedo = element.decal1
		else:
			decal1.hide()
			decal1.texture_albedo = null
			
		if element.decal2:
			decal2.show()
			decal2.texture_albedo = element.decal2
		else:
			decal2.hide()
			decal2.texture_albedo = null
			
func reset_quest():
	for side in Element.PackageSide.keys():
		var pic: MeshInstance3D = get_node(NodePath(basePath + "/" + side + "/Picture"))
		var textLabel: Label3D = get_node(NodePath(basePath + "/" + side + "/TextLabel"))
		var decal1: Decal = get_node(NodePath(basePath + "/" + side + "/Decal1"))
		var decal2: Decal = get_node(NodePath(basePath + "/" + side + "/Decal2"))
		
		pic.hide()
		var material = pic.get_surface_override_material(0)
		if material is StandardMaterial3D:
			material.albedo_texture = null
			
		textLabel.hide()
		textLabel.text = ""
			
		decal1.hide()
		decal1.texture_albedo = null
			
		decal2.hide()
		decal2.texture_albedo = null
		

func active():
	packagePivot.show()
	
	
func inactive():
	packagePivot.hide()
			
