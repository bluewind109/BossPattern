@tool
extends Resource
class_name AchievementConfig

@export var achievements: Array[AchievementData] = []

@export_tool_button("Generate achievements")
var generate_achievements_button: Callable = generate_achievements

const path: String = "res://resources/achievement/achievement_data/"


func get_achievement_by_id(_id: AchievementDefine.ACHIEVEMENT_ID) -> AchievementData:
	for achievement: AchievementData in achievements:
		if (achievement.id == _id):
			return achievement
	return null


func generate_achievements():
	print("generate_achievements")
	achievements = []
	var dir: DirAccess = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.contains(".tres"):
				var full_path: String = path.path_join(file_name)
				var loaded_resource: Resource = ResourceLoader.load(full_path)
				if (loaded_resource):
					achievements.append(loaded_resource)
			file_name = dir.get_next()
	else:
		print("Error generate achievements")
