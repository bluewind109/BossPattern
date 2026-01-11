extends CharacterBody2D
class_name EnemyBase

var player_ref: CharacterBody2D

var anim_dict: Dictionary[int, AnimationInfo] = {}
var speed_dict: Dictionary[int, float] = {}

@onready var state_machine: CallableStateMachine = $callable_state_machine
@onready var component_health: ComponentHealth = $health
@onready var component_hitbox: ComponentHitbox = $hitbox
@onready var component_hurtbox: ComponentHurtbox = $hurtbox
@onready var component_velocity: ComponentVelocity = $velocity
@onready var component_look: ComponentLook = $look
@onready var attack_manager: AttackManager = $attack_manager
@onready var hit_audio_player: RandomAudioPlayer2D = $hit_random_audio_player_2d

@export var mass: float = 20

var is_spawning: bool = false
var is_dead: bool = false


func _ready() -> void:
	component_hurtbox.damaged.connect(_on_damaged)
	is_spawning = true
	is_dead = false
	player_ref = get_tree().get_first_node_in_group("Player")
	if (component_health): 
		component_health.died.connect(_on_die)
		component_health.init.call_deferred(component_health.max_health)


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
	component_look.visual_node = _target


func look_at_player():
	if (not component_look): return
	# if (not player_ref): return
	var target_pos: Vector2 = get_player_position()
	if (target_pos == null): return
	component_look.look(target_pos)


func set_state(state_id: int):
	if (is_dead): return
	state_machine.change_state(state_id)


func get_player_position():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	if (player_node == null): return null
	return player_node.global_position


func get_direction_to_player() -> Vector2:
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	if (player_node == null): return Vector2.ZERO
	return (player_node.global_position - global_position).normalized()


func get_anim_name(_anim_state: int) -> String:
	return anim_dict[_anim_state]["name"]


func _on_damaged(amount: float):
	if (hit_audio_player != null):
		hit_audio_player.play_random()
	component_health.take_damage(amount)
	if (amount > 0):
		FloatingTextManager.spawn_damage_text_at(global_position + Vector2.UP * 16, amount)


func _on_die():
	is_dead = true
