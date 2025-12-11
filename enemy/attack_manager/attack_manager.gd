extends Node2D
# Manage all attack patterns of a boss enemy
class_name AttackManager

@onready var cooldown_timer: Timer = $cooldown_timer

var next_skill: EnemySkill
var is_casting: bool = false
## global attack cooldown
var cooldown_duration: float = 5.0

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	cooldown_timer.wait_time = cooldown_duration
	is_casting = false

func attack():
	is_casting = true

func can_attack() -> bool:
	return cooldown_timer.is_stopped()

func set_next_skill(_skill: EnemySkill):
	next_skill = _skill
	_skill.on_skill_casted.connect(_on_skill_casted)

func _on_skill_casted():
	print("_on_skill_casted")
	if (next_skill.on_skill_casted.is_connected(_on_skill_casted)): 
		next_skill.on_skill_casted.disconnect(_on_skill_casted)
	cooldown_timer.start()

func set_cooldown_duration(val: float):
	cooldown_duration = val
	cooldown_timer.wait_time = cooldown_duration

func _on_cooldown_finished():
	print("[AttackManager] _on_cooldown_finished")
