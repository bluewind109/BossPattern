extends Resource
class_name AchievementConfig

@export var achievements: Array[AchievementData] = []


func get_achievement_by_id(_id: AchievementDefine.ACHIEVEMENT_ID) -> AchievementData:
	for achievement: AchievementData in achievements:
		if (achievement.id == _id):
			return achievement
	return null