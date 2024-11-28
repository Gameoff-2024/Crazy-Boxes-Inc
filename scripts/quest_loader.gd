class_name QuestLoader

static var quest_path = "res://resources/quests/"

var quests_list: Array
var shuffled = false

func _init():
	quests_list = Array(DirAccess.get_files_at(quest_path))
	quests_list.shuffle()
	

static func get_total_quests() -> int:
	return Array(DirAccess.get_files_at(quest_path)).size()

func choose_random_quest() -> Quest:
	if quests_list.is_empty():
		return null
		
	return load(quest_path + quests_list.pop_back())
	
	
func choose_quest(index: int) -> Quest:
	quests_list = Array(DirAccess.get_files_at(quest_path))
	return load(quest_path + quests_list[index])
	
