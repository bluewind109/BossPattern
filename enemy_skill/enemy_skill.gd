extends Node2D
class_name EnemySkill

@onready var cooldown_timer: Timer = $cooldown_timer

signal on_skill_casted

func _ready() -> void:
	pass

func cast():
	if (not can_cast()): return
	_start_timer()
	on_skill_casted.emit()

func cast_at(_target: Node2D):
	if (not can_cast()): return
	_start_timer()
	on_skill_casted.emit()

func can_cast() -> bool:
	return cooldown_timer.is_stopped()

func _start_timer():
	cooldown_timer.start()

func _on_cooldown_finished():
	# print("[EnemySkill] _on_cooldown_finished")
	pass
