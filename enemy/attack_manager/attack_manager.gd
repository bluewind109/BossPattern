extends Node2D
# Manage all attack patterns of a boss enemy
class_name AttackManager

@onready var cooldown_timer: Timer = $cooldown_timer
@onready var delay_timer: Timer = $delay_timer

var next_skill: EnemySkill
var is_casting: bool = false
## global attack cooldown
var cooldown_duration: float = 5.0

signal on_attack_finished

func _ready() -> void:
	delay_timer.timeout.connect(_on_delay_finished)
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
	_skill.on_skill_finished.connect(_on_skill_finished)

func cast_next_skill():
	pass

func get_wind_up_duration() -> float:
	if (not next_skill): return 0
	return next_skill.delay_duration

func _on_skill_casted():
	# print("_on_skill_casted")
	if (next_skill.on_skill_casted.is_connected(_on_skill_casted)): 
		next_skill.on_skill_casted.disconnect(_on_skill_casted)
	# start_cooldown()

func _on_skill_finished():
	if (next_skill.on_skill_finished.is_connected(_on_skill_finished)): 
		next_skill.on_skill_finished.disconnect(_on_skill_finished)
	on_attack_finished.emit()

func set_cooldown_duration(val: float):
	cooldown_duration = val
	cooldown_timer.wait_time = cooldown_duration

func start_delay():
	delay_timer.start()

func start_cooldown():
	cooldown_timer.start()

func _on_cooldown_finished():
	print("[AttackManager] _on_cooldown_finished")

func _on_delay_finished():
	cast_next_skill()
	start_cooldown()
