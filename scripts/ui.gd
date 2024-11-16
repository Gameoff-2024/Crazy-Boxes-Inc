extends Control

@onready var score_label: Label = $MarginContainer/HBoxContainer/BoxContainer/ScoreLabel

func _ready():
	GameState.score_updated.connect(_on_score_updated)
	score_label.text = "0"
	
func _on_score_updated(old_score: int, new_score: int):
	score_label.text = str(new_score)
