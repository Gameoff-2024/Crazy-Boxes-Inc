class_name QuestLoader

static var quest_path = "res://resources/quests/"

var quests_list: Array[Quest]
var shuffled = false

func _init():
	for res in Array(DirAccess.get_files_at(quest_path)):
		quests_list.append(load(quest_path + res))
		
	quests_list.shuffle()
	

static func get_total_quests() -> int:
	return Array(DirAccess.get_files_at(quest_path)).size()


func choose_random_quest() -> Quest:
	if quests_list.is_empty():
		return null
		
	return quests_list.pop_back()
	
	
func choose_quest(id: int) -> Quest:
	return quests_list.filter(func(quest): return quest.id == id)[0]
	
