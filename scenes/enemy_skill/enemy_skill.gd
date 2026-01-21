extends Node2D
class_name EnemySkill

enum SKILL_TYPE 
{
	head_slam = 0,
	melee = 1,
	charge = 2,
	lightning_strike = 3,
	poison_explosion_attack =4,
	shockwave = 5,
	shield_slam = 6,
	magic_ball = 7,
}

signal on_skill_finished

@onready var cooldown_timer: Timer = $cooldown_timer

@export var cooldown_duration: float = 3.0
@export var delay_duration: float = 1.0
@export var recover_duration: float = 2.0

@export var cast_range: float = 25.0

var skill_type: SKILL_TYPE
var on_skill_ready_callback: Callable


func _ready() -> void:
	assert(skill_type != null)


func cast():
	if (not can_cast()): return
	_start_cooldown()


func cast_at(_target: Node2D):
	if (not can_cast()): return
	_start_cooldown()


func can_cast() -> bool:
	return cooldown_timer.is_stopped()


func is_in_cast_range(_target_pos: Vector2) -> bool:
	var distance = _target_pos.distance_to(get_owner_position())
	return distance <= cast_range


func get_owner_position() -> Vector2:
	var owner_node = owner as Node2D
	if (owner_node == null): return Vector2.ZERO
	return owner_node.global_position


func _start_cooldown():
	cooldown_timer.start()


func on_skill_casted():
	pass


func _on_skill_finished():
	on_skill_finished.emit()


func _on_cooldown_finished():
	# print("[EnemySkill] _on_cooldown_finished")
	pass
