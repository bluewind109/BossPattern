extends Node
class_name StageManager

@export var stage_config: StageConfig

var total_waves: int = 0
var wave_index: int = 0

var enemy_spawned: int = 0
var enemy_killed: int = 0

func _ready() -> void:
	GameEvents.enemy_killed.connect(_on_enemy_killed)

func start_stage() -> void:
	if (stage_config == null):
		print("Error: StageConfig is not assigned.")
		return

	total_waves = stage_config.wave_list.size()
	wave_index = 0
	enemy_spawned = 0
	enemy_killed = 0
	load_wave()

func load_wave() -> void:
	var wave_data: WaveData = stage_config.get_wave_data(wave_index)
	if (wave_data == null):
		print("Error: Wave data not found for index: ", wave_index)
		return

	var spawn_data_list: Array[SpawnData] = wave_data.spawn_data
	for spawn_data in spawn_data_list:
		GameEvents.spawn_enemy.emit(spawn_data.enemy_data, spawn_data.spawn_position)
		enemy_spawned += 1

func is_all_enemies_killed() -> bool:
	return enemy_spawned > 0 and enemy_spawned == enemy_killed

func _on_enemy_killed(number: int = 1):
	enemy_killed += number
	if (is_all_enemies_killed()):
		_on_wave_cleared()

func _on_wave_cleared():
	wave_index += 1
	if (wave_index < total_waves):
		load_wave()
	elif (wave_index == total_waves):
		# TODO show stage clear UI
		print("Stage cleared!")
		# GameEvents.emit_game_paused(true)
