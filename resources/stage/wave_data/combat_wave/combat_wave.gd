extends WaveData
class_name CombatWave

@export var spawn_data: Array[SpawnData] = []

func get_spawn_data(index: int) -> SpawnData:
	if (index < 0 or index >= spawn_data.size()):
		return null
	return spawn_data[index]
