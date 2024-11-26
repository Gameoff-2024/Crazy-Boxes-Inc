extends Control

func _process(delta: float) -> void:
	manage_music_icons()


func manage_music_icons() -> void:
	if AudioServer.is_bus_mute(0):
		%MusicOff.show()
		%MusicOn.hide()
	else:
		%MusicOff.hide()
		%MusicOn.show()
