extends Node3D

@export var texture_border: Resource
@export var texture_house: Resource
@export var trigger_distance: float = 10

var player: Node3D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	var house: ShaderMaterial = %Mesh.get_surface_override_material(2)
	var border: ShaderMaterial  = %Mesh.get_surface_override_material(3)
	
	var distance = global_position.distance_to(player.global_position)
	house.set_shader_parameter("active", distance < trigger_distance)
	border.set_shader_parameter("active", distance < trigger_distance)
