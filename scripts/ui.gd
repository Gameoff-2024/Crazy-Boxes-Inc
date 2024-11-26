extends Control

var total = 9

var time_start = 0
var time_now = 0

func _ready():
	GameState.score_updated.connect(_on_score_updated)
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
	
	manage_music_icons()


func _on_camera_manager_ui_disabled() -> void:
	hide()


func _on_camera_manager_ui_enabled() -> void:
	show()
	

func manage_music_icons() -> void:
	if AudioServer.is_bus_mute(0):
		%MusicOff.show()
		%MusicOn.hide()
	else:
		%MusicOff.hide()
		%MusicOn.show()
