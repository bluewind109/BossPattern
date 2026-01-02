extends Node
class_name AbilityController_Axe

@export var axe_ability_scene: PackedScene
@onready var timer: Timer = $timer

@export var damage: float = 5.0
@export var max_range: float = 50.0
@export var offset: float = 16.0

var base_wait_time: float
var reduction_rate: float = .1


func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(_on_ability_timer_finished)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgraded)


func _on_ability_timer_finished():
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if (player == null): return

	# var enemies = get_tree().get_nodes_in_group("Enemy")
	# # only enemies inside max range
	# enemies = enemies.filter(func(enemy: Node2D): 
	# 	return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2.0)
	# )
	# if (enemies.size() == 0): return

	# # closest enemy inside max range
	# enemies.sort_custom(func(a: Node2D, b: Node2D): 
	# 	var distance_a = a.global_position.distance_squared_to(player.global_position)
	# 	var distance_b = b.global_position.distance_squared_to(player.global_position)
	# 	return distance_a < distance_b
	# )

	var axe_instance = axe_ability_scene.instantiate() as Ability_Axe
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if (foreground_layer == null): return
	foreground_layer.add_child(axe_instance)

	#axe_instance.hitbox.set_damage.call_deferred(damage)
	axe_instance.global_position = player.global_position


func _on_ability_upgraded(upgrade: Res_AbilityUpgrade, current_upgrades: Dictionary):
	if (upgrade.id != "sword_rate"): return

	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * reduction_rate
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start()
	print(timer.wait_time)
