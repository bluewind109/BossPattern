extends Resource
class_name EnemyConfig

@export var enemies: Dictionary[EnemyDefine.ENEMY_ID, Res_EnemyData]


func get_enemy_res_by_id(_id: EnemyDefine.ENEMY_ID) -> Res_EnemyData:
	if (!enemies.has(_id)): return null
	return enemies[_id]
