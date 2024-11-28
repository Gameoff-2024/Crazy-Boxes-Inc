extends CharacterBody3D

var movement_speed: float = .2

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var navigation_region: NavigationRegion3D

var destination: Vector3

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	

	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	destination = NavigationServer3D.map_get_random_point(navigation_region.get_navigation_map(), 1, false)
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(destination)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	look_at(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		print("Done")
		destination = NavigationServer3D.map_get_random_point(navigation_region.get_navigation_map(), 1, false)
		set_movement_target(destination)

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	look_at(to_local(next_path_position))
	move_and_slide()
