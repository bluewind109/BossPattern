extends Node2D
class_name EnemySkill

enum SKILL_TYPE 
{
	charge,
	poison_explosion_attack,
	shockwave,
}

@onready var cooldown_timer: Timer = $cooldown_timer
@export var delay_duration: float = 0.0
@export var recover_duration: float = 0.0

var skill_type: SKILL_TYPE

var on_skill_ready_callback: Callable

signal on_skill_casted
signal on_skill_finished

func _ready() -> void:
	assert(skill_type != null)

func cast():
	if (not can_cast()): return
	_start_cooldown()
	on_skill_casted.emit()

func cast_at(_target: Node2D):
	if (not can_cast()): return
	_start_cooldown()
	on_skill_casted.emit()

func can_cast() -> bool:
	return cooldown_timer.is_stopped()

func _start_cooldown():
	cooldown_timer.start()

func _on_skill_finished():
	on_skill_finished.emit()

func _on_cooldown_finished():
	# print("[EnemySkill] _on_cooldown_finished")
	pass
