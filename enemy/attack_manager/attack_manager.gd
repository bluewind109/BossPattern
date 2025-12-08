extends Node2D
# Manage all attack patterns of a boss enemy
class_name AttackManager

@onready var cooldown_timer: Timer = $cooldown_timer

## global attack cooldown
var cooldown_duration: float = 2.0

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_finished)

func attack():
	cooldown_timer.start()
	pass

func can_attack() -> bool:
	return cooldown_timer.is_stopped()

func set_cooldown_duration(val: float):
	cooldown_duration = val

func _on_cooldown_finished():
	pass
