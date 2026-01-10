extends Node
class_name EnemyManager

const SPAWN_RADIUS: float = 50

@export var enemy_cube_base_scene: PackedScene
@export var enemy_cube_wizard_scene: PackedScene
@export var enemy_bat_scene: PackedScene
@export var game_time_manager: GameTimeManager

@onready var spawn_timer: Timer = $%spawn_timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var number_to_spawn: int = 5


func _ready() -> void:
	enemy_table.add_item(enemy_cube_base_scene, 10)
	base_spawn_time = spawn_timer.wait_time
	game_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
	spawn_timer.timeout.connect(_on_spawn_timeout)	


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

func _on_spawn_timeout():
	spawn_timer.start()
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return

	for i in number_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy_instance = enemy_scene.instantiate() as EnemyBase
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		if (entities_layer == null): return
		entities_layer.add_child(enemy_instance)
		enemy_instance.global_position = get_spawn_position()


func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	# print("_on_arena_difficulty_increased: ", time_off)
	spawn_timer.wait_time = max(base_spawn_time - time_off, 0.1)

	#if (arena_difficulty == 3):
		#enemy_table.add_item(enemy_bat_scene, 10)
	if (arena_difficulty == 6):
		enemy_table.add_item(enemy_cube_wizard_scene, 15)

	if ((arena_difficulty % 6) == 0):
		number_to_spawn += 1
