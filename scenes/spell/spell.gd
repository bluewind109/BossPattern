extends Node
class_name Spell

@onready var cooldown_timer: Timer = $cooldown_timer

@export var cooldown_duration: float = 3.0
@export var cast_range: float = 100.0


func _ready() -> void:
	cooldown_timer.wait_time = cooldown_duration


func cast():
	if (not can_cast()): return
	_start_cooldown()


func cast_at(_target: Node2D):
	if (not can_cast()): return
	_start_cooldown()


func can_cast() -> bool:
	return cooldown_timer.is_stopped()


func _start_cooldown():
	cooldown_timer.start()


func _on_cooldown_finished():
	# print("[EnemySkill] _on_cooldown_finished")
	pass
