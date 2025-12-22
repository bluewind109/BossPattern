extends CharacterBody2D
class_name EnemyBase

var player_ref: CharacterBody2D

var STATE: Dictionary[String, String] = {}
var speed_dict: Dictionary[int, float] = {}

@onready var state_machine: CallableStateMachine = $callable_state_machine
@onready var component_health: ComponentHealth = $health
@onready var component_hitbox: ComponentHitbox = $component_Hitbox
@onready var component_hurtbox: ComponentHurtbox = $component_Hurtbox
@onready var component_velocity: ComponentVelocity = $velocity
@onready var component_steer: ComponentSteer = $steering
@onready var component_look: ComponentLook = $look
@onready var attack_manager: AttackManager = $attack_manager

@export var mass: float = 20

var is_spawning: bool = false

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	if (component_velocity): component_velocity.owner_node = self 
	if (component_health): component_health.died.connect(_on_die)

func init_states():
	pass

func init_speed_dict():
	pass

func init_anim_dict(_lib_name: String):
	pass

func bind_signals():
	pass

func add_states():
	pass

func _disable_collision():
	if (component_hitbox):
		component_hitbox.monitoring = false
		component_hitbox.monitorable = false
	if (component_hurtbox):
		component_hurtbox.monitoring = false
		component_hurtbox.monitorable = false

func init_component_look(_target: Node2D):
	if (not component_look): return
	component_look.owner_node = _target

func look_at_player():
	if (not component_look): return
	if (not player_ref): return
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func _on_die():
	pass
