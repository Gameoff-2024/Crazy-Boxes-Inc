extends VehicleBody3D

const BOX = preload("res://scenes/box.tscn")

const MOUSE_RAY_CAST_SIZE = 10
const BOX_SHOOT_FORCE_MULTIPLIER = 3.4
const BOX_MIN_TORQUE = 0
const BOX_MAX_TORQUE = 10

const STEER_SPEED = 1.5
const STEER_LIMIT = 0.4
const BRAKE_STRENGTH = 2.0

@export var engine_force_value := 80.0

@onready var shooter: Node3D = $Shooter
@onready var camera: Camera3D = $CameraPivot/Camera3D

var _quest_manager: QuestManager

var previous_speed := linear_velocity.length()
var _steer_target := 0.0
var _can_shoot := true

@onready var desired_engine_pitch: float = $EngineSound.pitch_scale

func _ready():
	_quest_manager = get_tree().get_first_node_in_group("quest_manager")


func _process(delta: float):
	if Input.is_action_just_pressed("shot") and _can_shoot:
		shoot_box()
		%ShootTimer.start()
		%ShotSound.play()
		_can_shoot = false
		
		
func _physics_process(delta: float):
	_steer_target = Input.get_axis(&"right", &"left")
	_steer_target *= STEER_LIMIT

	desired_engine_pitch = 0.05 + linear_velocity.length() / (engine_force_value * 0.5)
	$EngineSound.pitch_scale = lerpf($EngineSound.pitch_scale, desired_engine_pitch, 0.2)

	if Input.is_action_pressed(&"up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed := linear_velocity.length()
		
		lerp_camera_to_original_position(delta * speed)
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0.0

	if Input.is_action_pressed(&"down"):
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH

		# Apply analog brake factor for more subtle braking if not fully holding down the trigger.
		engine_force *= Input.get_action_strength(&"down")

	if engine_force != 0:
		$AnimationPlayer.play("move")

	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)

	previous_speed = linear_velocity.length()

func shoot_box():
	var box = BOX.instantiate()
	get_tree().root.add_child(box)
	box.global_position = shooter.global_position
	box.apply_central_impulse(calc_box_shot_force())
	box.apply_torque(get_rand_torque())
	
	# Register the box in the quest manager so it's able to listen for events
	_quest_manager.register_in_game_box(box)
	
func get_rand_torque() -> Vector3:
	return Vector3(
		randf_range(BOX_MIN_TORQUE, BOX_MAX_TORQUE),
		randf_range(BOX_MIN_TORQUE, BOX_MAX_TORQUE),
		randf_range(BOX_MIN_TORQUE, BOX_MAX_TORQUE),
	)
	
func calc_box_shot_force() -> Vector3:
	var segment_start = shooter.global_position
	var segment_end = calc_segment_end(segment_start)
	var plane_normal = MathUtils.calc_plane_normal(segment_start, segment_end, Vector3.DOWN)
	var shot_direction = MathUtils.calc_tangent_vector(segment_start, segment_end, plane_normal)
	var distance = (segment_end - segment_start).length()
	
	return shot_direction * (distance * BOX_SHOOT_FORCE_MULTIPLIER)
	
	
func calc_segment_end(real_start: Vector3) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * MOUSE_RAY_CAST_SIZE
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		return end
		
	return result.position
	
	
func _on_camera_pivot_rotation_start() -> void:
	_can_shoot = false


func _on_camera_pivot_rotation_stop() -> void:
	_can_shoot = true


func _on_quest_manager_disable_box_shooting() -> void:
	_can_shoot = false
	%ShootTimer.stop()
	%Skip.hide_boxes()
	$Particles.show()
	$Particles.emit()
	%WinSound.play()


func _on_quest_manager_enable_box_shooting() -> void:
	_can_shoot = true
	%Skip.show_boxes()


func _on_shoot_timer_timeout() -> void:
	_can_shoot = true


func lerp_camera_to_original_position(delta) -> void:
	$CameraPivot.transform = $CameraPivot.transform.interpolate_with($CameraPivotStart.transform, delta)
