extends Resource
class_name AchievementData

@export var id: AchievementDefine.ACHIEVEMENT_ID
@export var name: String
@export var is_done: bool = false


func set_done():
	is_done =  true
