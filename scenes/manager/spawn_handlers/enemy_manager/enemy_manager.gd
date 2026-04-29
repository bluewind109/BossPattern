extends Node
class_name EnemyManager

@export var enemy_config: EnemyConfig

@onready var tracking_timer: Timer = $%tracking_timer

var enemy_spawned: int = 0
var enemy_killed: int = 0
var boss_killed: int = 0

signal on_all_enemies_killed

func _ready() -> void:
	GameEvents.spawn_enemy.connect(spawn)

func reset():
	enemy_spawned = 0
	enemy_killed = 0
	boss_killed = 0

func spawn(enemy_id: EnemyDefine.ENEMY_ID, spawn_position: Vector2) -> void:
	if (enemy_config == null):
		print("Error: EnemyConfig is not assigned.")
		return

	var enemy_data: Res_EnemyData = enemy_config.get_enemy_res_by_id(enemy_id)
	if (enemy_data == null):
		print("Error: Enemy data not found for ID: ", enemy_id)
		return
	
	enemy_spawned += 1
	var enemy_instance = enemy_config.enemies[enemy_id].enemy_scene.instantiate() as EnemyBase
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child.call_deferred(enemy_instance)

	enemy_instance.killed.connect.call_deferred(_on_enemy_killed)
	enemy_instance.set_deferred("global_position", spawn_position)
	enemy_instance.apply_stat.call_deferred(enemy_config.enemies[enemy_id])

func is_all_enemies_killed() -> bool:
	return enemy_spawned > 0 and enemy_spawned == enemy_killed

func _on_enemy_killed(is_boss: bool):
	enemy_killed += 1
	if (is_boss):
		print("Boss killed!")
		boss_killed += 1

	if (enemy_killed >= enemy_spawned):
		print("All enemies killed!")
		on_all_enemies_killed.emit()
