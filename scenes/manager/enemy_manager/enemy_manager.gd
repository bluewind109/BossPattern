extends Node
class_name EnemyManager

const SPAWN_RADIUS: float = 375

@export var enemy_scene: PackedScene
@onready var spawn_timer: Timer = $%spawn_timer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timeout)	


func _on_spawn_timeout():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy_instance = enemy_scene.instantiate() as EnemyBase
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = spawn_position
