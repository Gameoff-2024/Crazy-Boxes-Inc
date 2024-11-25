extends Node3D

signal new_quest

var can_reset = true

func _ready() -> void:
	if !OS.is_debug_build():
		emit_signal("new_quest")
		
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset") and can_reset:
		$Player.global_transform = $PlayerPosition.global_transform
		can_reset = false
		%ResetTimer.start()


func _on_reset_timer_timeout() -> void:
	can_reset = true
