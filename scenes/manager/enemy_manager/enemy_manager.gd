extends Node
class_name EnemyManager

const SPAWN_RADIUS: float = 150

@export var is_disabled: bool = false
@export var spawn_config: SpawnConfig
@export var enemy_config: EnemyConfig
@export var game_time_manager: GameTimeManager
@onready var spawn_timer: Timer = $%spawn_timer
@onready var tracking_timer: Timer = $%tracking_timer

var base_spawn_time = 0
var enemy_table = EnemyWeightedTable.new()
var number_to_spawn: int = 1
var current_difficulty: int = 0

var enemy_killed: int = 0
var boss_killed: int = 0

func _ready() -> void:
	# var enemy_weight = EnemyWeight.new(EnemyDefine.ENEMY_ID.BASE, 10)
	# enemy_table.add_item(enemy_weight)
	update_spawn_pool_by_difficulty(current_difficulty)

	base_spawn_time = spawn_timer.wait_time
	game_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
	spawn_timer.timeout.connect(_on_spawn_timeout)	
	tracking_timer.timeout.connect(_on_tracking_timeout)

	GameEvents.enemy_killed.connect(_on_enemy_killed)
	GameEvents.boss_killed.connect(_on_boss_killed)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return Vector2.ZERO
	
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = Vector2.ZERO
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		# create a raycast between player and enemy's spawn position
		var query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			player.global_position, 
			spawn_position + additional_check_offset,
			1 << 0
		)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		if (result.is_empty()): # no collision between 2 points
			break
		else: # there is a collision
			# rotate 90 degrees
			random_direction = random_direction.rotated(deg_to_rad(90))
	return spawn_position


func update_spawn_pool_by_difficulty(_diff: int):
	var arr_new_spawns: Array[Res_SpawnData] = spawn_config.get_items_by_difficulty(_diff)
	if (arr_new_spawns.is_empty()): return
	for spawn in arr_new_spawns:
		var _spawn_id = spawn.enemy_id
		var _weight = spawn.weight
		var enemy_weight = EnemyWeight.new(_spawn_id, _weight)
		enemy_table.add_item(enemy_weight)


func send_update_enemy_killed():
	if (enemy_killed <= 0): return
	MetaProgression.update_enemy_killed(enemy_killed)
	enemy_killed = 0


func send_update_boss_killed():
	if (boss_killed <= 0): return
	MetaProgression.update_boss_killed(boss_killed)
	boss_killed = 0

func _on_spawn_timeout():
	if (is_disabled): return
	spawn_timer.start()
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return

	for i in number_to_spawn:
		var enemy_id: EnemyDefine.ENEMY_ID = enemy_table.pick_item()
		if enemy_config.enemies.has(enemy_id):
			var enemy_instance = enemy_config.enemies[enemy_id].enemy_scene.instantiate() as EnemyBase
			var entities_layer = get_tree().get_first_node_in_group("entities_layer")
			if (entities_layer == null): return
			entities_layer.add_child(enemy_instance)
			enemy_instance.global_position = get_spawn_position()
			enemy_instance.apply_stat(enemy_config.enemies[enemy_id])


func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	# print("_on_arena_difficulty_increased: ", time_off)
	spawn_timer.wait_time = max(base_spawn_time - time_off, 0.1)

	if ((arena_difficulty % 6) == 0):
		number_to_spawn += 1

	if (arena_difficulty == current_difficulty): return
	current_difficulty = arena_difficulty
	update_spawn_pool_by_difficulty(current_difficulty)


func _on_enemy_killed(new_value: int):
	enemy_killed += new_value


func _on_boss_killed(new_value: int):
	boss_killed += new_value


func _on_tracking_timeout():
	send_update_enemy_killed()
	send_update_boss_killed()
