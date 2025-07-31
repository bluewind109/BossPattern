extends CharacterBody2D
class_name EnemyBase

var player_ref: CharacterBody2D

var STATE: Dictionary[String, String] = {}

@export var state_machine: CallableStateMachine

@export var component_health: ComponentHealth

var is_spawning: bool = false

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	return
