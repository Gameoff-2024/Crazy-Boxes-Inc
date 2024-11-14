class_name QuestLoader

@export var quest_path = "res://scripts/resources/quests/"

var quests_list: Array

func _init():
	quests_list = Array(DirAccess.get_files_at(quest_path))
	quests_list.shuffle()
	

func choose_random_quest() -> Quest:
	if quests_list.is_empty():
		print("WIN")
		return null
		
	return load(quest_path + quests_list.pop_back())
	
