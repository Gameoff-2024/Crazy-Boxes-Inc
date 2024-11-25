extends Node

signal score_updated(old_score: int, new_score: int)

var score := 0

var time = ""


func score_add_one():
	var new_score = score + 1
	score_updated.emit(score, new_score)
	score = new_score
	
