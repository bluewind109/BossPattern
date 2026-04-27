extends Resource
class_name StageConfig

@export var stage_id: int = 0
@export var wave_list: Array[WaveData] = []

func get_wave_data(index: int) -> WaveData:
	if (index < 0 or index >= wave_list.size()):
		return null
	return wave_list[index]
