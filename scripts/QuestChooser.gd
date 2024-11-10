extends Node3D

var quest_path = "res://scripts/resources/quests/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var quests_list = DirAccess.get_files_at(quest_path)
	var random = RandomNumberGenerator.new()
	var rand_index : int = random.randi() % quests_list.size()
	
	print(quests_list[rand_index])
	var quest : Quest = load(quest_path + quests_list[rand_index])
	
	print(quest.text)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
