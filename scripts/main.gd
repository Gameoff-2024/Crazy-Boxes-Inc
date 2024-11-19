extends Node3D

signal new_quest

func _ready() -> void:
	if !OS.is_debug_build():
		emit_signal("new_quest")
