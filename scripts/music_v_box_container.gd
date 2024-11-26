extends MarginContainer

func _ready() -> void:
	GameState.audio_switched.connect(_on_audio_switched)
	

func _process(delta: float) -> void:
	if AudioServer.is_bus_mute(0):
		%MusicOff.show()
		%MusicOn.hide()
	else:
		%MusicOff.hide()
		%MusicOn.show()
		
		
func _on_audio_switched(b: bool):
	pass
