extends TextureRect

func inactive():
	self_modulate.a = 0
	
func active():
	self_modulate.a = 1
