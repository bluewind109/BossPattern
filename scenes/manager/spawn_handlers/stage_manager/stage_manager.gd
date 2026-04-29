extends Node
class_name StageManager

@export var stage_config: StageConfig
@onready var enemy_manager: EnemyManager = $%enemy_manager

var total_waves: int = 0
var wave_index: int = 0

signal on_stage_cleared

func _ready() -> void:
	enemy_manager.on_all_enemies_killed.connect(_on_wave_cleared)

func start_stage() -> void:
	if (stage_config == null):
		print("Error: StageConfig is not assigned.")
		return

	total_waves = stage_config.wave_list.size()
	wave_index = 0
	start_new_wave()

func start_new_wave() -> void:
	enemy_manager.reset()

	var wave_data: WaveData = stage_config.get_wave_data(wave_index)
	if (wave_data == null):
		print("Error: Wave data not found for index: ", wave_index)
		return

	var spawn_data_list: Array[SpawnData] = wave_data.spawn_data
	for spawn_data: SpawnData in spawn_data_list:
		enemy_manager.spawn(spawn_data.enemy_id, spawn_data.spawn_position)

func _on_wave_cleared():
	wave_index += 1
	if (wave_index < total_waves):
		start_new_wave()
		return
	elif (wave_index == total_waves):
		# show stage clear UI
		print("Stage cleared!")
		on_stage_cleared.emit()
