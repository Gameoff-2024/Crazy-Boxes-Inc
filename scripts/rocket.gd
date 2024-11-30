extends RigidBody3D

@onready var rocket_particles: CPUParticles3D = $RocketParticles
@onready var launch_timer: Timer = $LaunchTimer

@export var close_to_land_height := 50
@export var max_velocity := Vector3(0, 20, 0)
@export var max_hegiht := 150

var flying := false
var falling := false
var close_to_land := false

func _ready() -> void:
	_reset_start_launch_timer()

func _process(delta: float) -> void:
	if _ready_to_launch():
		rocket_particles.emitting = true
		flying = true
		
	if _top_limit_reached():
		rocket_particles.emitting = false
		flying = false
		falling = true
		
	if _close_to_land():
		close_to_land = true
		
		if falling:
			rocket_particles.emitting = true
	else:
		close_to_land = false
		
	if _landed():
		_reset_rocket()
		
	rocket_particles.lifetime = clamp(lerp(0.015, 0.3, position.y / close_to_land_height), 0.015, 0.3)
		
func _ready_to_launch() -> bool:
	return launch_timer.is_stopped() and !flying and !falling
		
func _top_limit_reached() -> bool:
	return flying and position.y >= max_hegiht
	
func _close_to_land() -> bool:
	return position.y <= close_to_land_height

func _landed() -> bool:
	return falling and position.y <= 2
	
func _physics_process(delta: float) -> void:
	if flying:
		add_constant_central_force(Vector3.UP * 100)
	elif falling:
		if close_to_land:
			constant_force = Vector3.ZERO
			linear_velocity = Vector3.ZERO
			position.y = lerp(position.y, 2.0, delta)
		else:
			constant_force = Vector3.ZERO
		
	if !is_zero_approx(linear_velocity.y):
		if linear_velocity.y > max_velocity.y:
			linear_velocity.y = max_velocity.y
			
	if !flying and !falling:
		linear_velocity = Vector3.ZERO
	
func _reset_start_launch_timer():
	launch_timer.start()
	
func _reset_rocket():
	falling = false
	flying = false
	rocket_particles.emitting = false
	_reset_start_launch_timer()
