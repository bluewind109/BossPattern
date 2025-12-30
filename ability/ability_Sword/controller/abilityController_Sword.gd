extends Node
class_name AbilityController_Sword

@export var sword_prefab: PackedScene
@onready var timer: Timer = $timer


func _ready() -> void:
	timer.timeout.connect(_on_ability_timer_finished)


func _on_ability_timer_finished():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	if (player_node == null): return

	var sword_instance = sword_prefab.instantiate() as Ability_Sword
	player_node.get_parent().add_child(sword_instance)
	sword_instance.global_position = player_node.global_position
