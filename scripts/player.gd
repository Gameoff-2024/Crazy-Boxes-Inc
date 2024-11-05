extends VehicleBody3D

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 20)
	engine_force = Input.get_axis("down", "up") * ENGINE_POWER 
