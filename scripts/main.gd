extends Node3D

signal new_quest

func _ready() -> void:
	emit_signal("new_quest")
