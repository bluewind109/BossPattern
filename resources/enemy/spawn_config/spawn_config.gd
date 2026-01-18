extends Resource
class_name SpawnConfig

@export var guideline: Array[Res_SpawnData]


func get_items_by_difficulty(difficulty: int) -> Array[Res_SpawnData]:
	var filtered_arr: Array[Res_SpawnData] = guideline.duplicate()
	filtered_arr = filtered_arr.filter(func(data: Res_SpawnData):
		return 	data.difficulty_level == difficulty
	)
	return filtered_arr
