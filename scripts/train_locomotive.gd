extends Node3D

var parent: PathFollow3D

func _ready() -> void:
	parent = get_parent()

func _process(delta: float) -> void:
	parent.progress_ratio = parent.progress_ratio + (0.035 * delta)
	
	if parent.progress_ratio > 1:
		parent.progress_ratio = 0
