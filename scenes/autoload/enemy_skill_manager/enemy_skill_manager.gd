extends Node

@export var skills: Dictionary[EnemySkillDefine.SKILL_ID, Res_EnemySkillData]


func get_skill_by_id(id: EnemySkillDefine.SKILL_ID) -> Res_EnemySkillData:
	if (!skills.has(id)): return null
	return skills[id]
