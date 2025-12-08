extends CharacterBody2D
class_name EnemyBase

var player_ref: CharacterBody2D

var STATE: Dictionary[String, String] = {}
var speed_dict: Dictionary[String, float] = {}

@onready var state_machine: CallableStateMachine = $callable_state_machine
@onready var component_health: ComponentHealth = $health
@onready var component_hitbox: ComponentHitbox = $component_Hitbox
@onready var component_hurtbox: ComponentHurtbox = $component_Hurtbox
@onready var component_velocity: ComponentVelocity = $velocity
@onready var component_steer: ComponentSteer = $steering
@onready var component_look: ComponentLook = $look
@onready var attack_manager: AttackManager = $attack_manager

var is_spawning: bool = false

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	if (component_velocity): component_velocity.owner_node = self 
	if (component_health): component_health.died.connect(_on_die)

func _disable_collision():
	if (component_hitbox):
		component_hitbox.monitoring = false
		component_hitbox.monitorable = false
	if (component_hurtbox):
		component_hurtbox.monitoring = false
		component_hurtbox.monitorable = false

func _on_die():
	pass
