extends Node3D

@export var label: String
@export var texture: Resource
@onready var text: Label3D = $Label
@onready var pic: MeshInstance3D = $Picture

func _ready() -> void:
	text.text = label
	
	if pic == null:
		pic.hide()
	else: 
		var material = pic.get_surface_override_material(0)
		if material is StandardMaterial3D:
			material.albedo_texture = texture
	
