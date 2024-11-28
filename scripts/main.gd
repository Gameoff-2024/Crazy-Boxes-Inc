extends Node3D

var can_reset = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset") and can_reset:
		$Player.global_transform = $PlayerPosition.global_transform
		can_reset = false
		%ResetTimer.start()
	else:
		$UI.reset_time = %ResetTimer.time_left / %ResetTimer.wait_time


func _on_reset_timer_timeout() -> void:
	can_reset = true
