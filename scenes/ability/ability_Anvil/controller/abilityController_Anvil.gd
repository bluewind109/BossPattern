extends Node
class_name AbilityController_Anvil

@export var anvil_ability_scene: PackedScene
@onready var timer: Timer = $timer

const BASE_RANGE: float = 100


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return Vector2.ZERO
	
	var direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	# create a raycast between player and enemy's spawn position
	var query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		player.global_position, 
		spawn_position,
		1 << 0
	)
	var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	if (!result.is_empty()): # no collision between 2 points
		spawn_position = result["position"]
		
	var ability_anvil = anvil_ability_scene.instantiate() as Ability_Anvil
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if (foreground_layer == null): return
	foreground_layer.add_child(ability_anvil)
	ability_anvil.global_position = spawn_position
	print(spawn_position)
