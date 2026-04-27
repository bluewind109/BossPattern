extends Node
class_name EnemyManager

@export var enemy_config: EnemyConfig

func _ready() -> void:
	GameEvents.spawn_enemy.connect(spawn)

func spawn(enemy_id: EnemyDefine.ENEMY_ID, spawn_position: Vector2) -> void:
	if (enemy_config == null):
		print("Error: EnemyConfig is not assigned.")
		return

	var enemy_data: Res_EnemyData = enemy_config.get_enemy_res_by_id(enemy_id)
	if (enemy_data == null):
		print("Error: Enemy data not found for ID: ", enemy_id)
		return
	
	var enemy_instance: Node2D = enemy_data.enemy_scene.instantiate() as Node2D
	enemy_instance.global_position = spawn_position
	add_child(enemy_instance)
