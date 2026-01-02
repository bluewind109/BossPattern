extends Node
class_name EnemyManager

const SPAWN_RADIUS: float = 375

@export var enemy_scene: PackedScene
@export var game_time_manager: GameTimeManager

@onready var spawn_timer: Timer = $%spawn_timer

var base_spawn_time = 0


func _ready() -> void:
	base_spawn_time = spawn_timer.wait_time
	game_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
	spawn_timer.timeout.connect(_on_spawn_timeout)	


func _on_spawn_timeout():
	spawn_timer.start()
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy_instance = enemy_scene.instantiate() as EnemyBase
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = spawn_position


func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	print("_on_arena_difficulty_increased: ", time_off)
	spawn_timer.wait_time = max(base_spawn_time - time_off, 0.1)
