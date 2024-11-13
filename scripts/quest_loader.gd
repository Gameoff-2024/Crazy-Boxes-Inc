class_name QuestLoader

@export var quest_path = "res://scripts/resources/quests/"

func choose_random_quest() -> Quest:
	var quests_list = DirAccess.get_files_at(quest_path)
	
	var quest_index = RandomUtil.get_random_number(quests_list.size())

	return load(quest_path + quests_list[quest_index])
