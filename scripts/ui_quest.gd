extends Control


func _on_camera_manager_ui_quest_disabled() -> void:
	hide()


func _on_camera_manager_ui_quest_enabled() -> void:
	show()
