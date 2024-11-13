extends Node3D

@export var label: String
@onready var text: Label3D = $Text

func _ready() -> void:
	text.text = label
	
