extends Node
class_name AbilityController_Sword

@export var max_range: float = 50.0
@export var sword_prefab: PackedScene

@onready var timer: Timer = $timer


func _ready() -> void:
	timer.timeout.connect(_on_ability_timer_finished)


func _on_ability_timer_finished():
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if (player == null): return

	var enemies = get_tree().get_nodes_in_group("Enemy")

	# only enemies inside max range
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2.0)
	)
	if (enemies.size() == 0): return

	# closest enemy inside max range
	enemies.sort_custom(func(a: Node2D, b: Node2D): 
		var distance_a = a.global_position.distance_squared_to(player.global_position)
		var distance_b = b.global_position.distance_squared_to(player.global_position)
		return distance_a < distance_b
	)

	var sword_instance = sword_prefab.instantiate() as Ability_Sword
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position 
