extends Control

var total = 1

var time_start = 0
var time_now = 0

var reset_time = 0

func _ready():
	GameState.score_updated.connect(_on_score_updated)
	total = QuestLoader.get_total_quests()
	%ScoreLabel.text = "0" + '/' + str(total)
	time_start = Time.get_unix_time_from_system()
	
	
func _on_score_updated(old_score: int, new_score: int):
	%ScoreLabel.text = str(new_score)  + '/' + str(total)


func _process(delta: float) -> void:
	time_now = Time.get_unix_time_from_system()
	var time_elapsed = time_now - time_start
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var time_string = "%02d:%02d" % [minutes, seconds]
	%TimeLabel.text = time_string
	GameState.time = time_string
	%ResetProgressBar.value = 100 - (reset_time * 100)


func _on_camera_manager_ui_disabled() -> void:
	hide()


func _on_camera_manager_ui_enabled() -> void:
	show()
