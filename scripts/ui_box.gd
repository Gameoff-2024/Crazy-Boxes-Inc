extends Node3D

const ROTATION_SPEED_RADIANS := deg_to_rad(25)

@onready var box_small: MeshInstance3D = $"box-small"

func _process(delta: float) -> void:
	box_small.rotate_y(ROTATION_SPEED_RADIANS * delta)
