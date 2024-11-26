extends Node3D

var active = false

signal indicator_triggered

func _ready() -> void:
	hide()
	active = false
	%Area3D.monitoring = active


func _on_quest_manager_show_quest_indicator() -> void:
	active = true
	%Area3D.monitoring = active
	show()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" and active:
		hide()
		active = false
		%Area3D.monitoring = active
		emit_signal("indicator_triggered")
		$AudioStreamPlayer3D.play()
