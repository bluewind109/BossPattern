extends Node

@export var config: AchievementConfig


func is_achievement_done(_id: AchievementDefine.ACHIEVEMENT_ID) -> bool:
	if (config == null): return false
	var achievement: AchievementData = config.get_achievement_by_id(_id)
	if (achievement ==  null): return false

	if (!achievement.is_done):
		match achievement.id:
			AchievementDefine.ACHIEVEMENT_ID.HUNDRED_ENEMIES_SLAIN:
				achievement.is_done = MetaProgression.get_enemy_killed() >= 100
			AchievementDefine.ACHIEVEMENT_ID.TEN_BOSSES_SLAIN:
				achievement.is_done = MetaProgression.get_boss_killed() >= 10
			_:
				pass

	return achievement.is_done