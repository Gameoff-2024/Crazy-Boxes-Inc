extends Camera3D

var pivot: Node3D

func _ready() -> void:
	pivot = get_parent()
	
func _process(delta: float):
	look_at(pivot.global_position)
