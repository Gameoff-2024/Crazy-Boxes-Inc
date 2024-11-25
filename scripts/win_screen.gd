extends Control

func _ready() -> void:
	$VBoxContainer/TimeLabel.text = "Time: " + GameState.time
