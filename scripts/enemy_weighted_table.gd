class_name EnemyWeightedTable

var pool: Array[EnemyWeight] = []
var weight_sum: int = 0


func add_item(item: EnemyWeight):
	pool.append(item)
	weight_sum += item.weight


func remove_item(enemy_to_remove: EnemyDefine.ENEMY_ID):
	pool = pool.filter(func(enemy: EnemyWeight):
		return enemy.id != enemy_to_remove
	)
	weight_sum = 0
	for item in pool:
		weight_sum += item.weight


func pick_item(exclude: Array[EnemyDefine.ENEMY_ID] = []) -> EnemyDefine.ENEMY_ID:
	var filtered_pool: Array[EnemyWeight] = pool.duplicate()
	var filtered_weight_sum = weight_sum
	if (exclude.size() > 0):
		filtered_pool = []
		for item in pool:
			if (item.id in exclude): # skip exclude item
				continue
			filtered_pool.append(item)
			filtered_weight_sum += item.weight

	var chosen_weight: int = randi_range(1, filtered_weight_sum)
	var iteration_sum: int = 0
	for item in filtered_pool:
		iteration_sum += item.weight
		if chosen_weight <= iteration_sum:
			return item.id
	
	print("pick_item: return default")
	return EnemyDefine.ENEMY_ID.BASE
