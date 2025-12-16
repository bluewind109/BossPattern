extends Node2D
# Manage all attack patterns of a boss enemy
class_name AttackManager

@onready var cooldown_timer: Timer = $cooldown_timer
@onready var delay_timer: Timer = $delay_timer
@onready var recover_timer: Timer = $recover_timer

var next_skill: EnemySkill
var is_casting: bool = false
## global attack cooldown
var cooldown_duration: float = 5.0

var delay_cb: Callable
var recover_cb: Callable

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
	if (next_skill and next_skill.on_skill_casted.is_connected(_on_skill_casted)): 
		next_skill.on_skill_casted.disconnect(_on_skill_casted)
	if (next_skill and next_skill.on_skill_finished.is_connected(_on_skill_finished)): 
		next_skill.on_skill_finished.disconnect(_on_skill_finished)
	next_skill = _skill
	is_casting = next_skill != null

	if (next_skill):
		next_skill.on_skill_casted.connect(_on_skill_casted)
		next_skill.on_skill_finished.connect(_on_skill_finished)

func get_wind_up_duration() -> float:
	if (not next_skill): return 0
	return next_skill.delay_duration

func get_recover_duration() -> float:
	if (not next_skill): return 0
	return next_skill.recover_duration

func _on_skill_ready():
	pass

func _on_skill_casted():
	pass

func _on_skill_finished():
	on_attack_finished.emit()

func set_cooldown_duration(val: float):
	cooldown_duration = val
	cooldown_timer.wait_time = cooldown_duration

func start_delay(_delay: float):
	delay_timer.start(_delay)

func start_recover(_recover: float):
	recover_timer.start(_recover)

func start_cooldown():
	cooldown_timer.start()

func _on_cooldown_finished():
	print("[AttackManager] _on_cooldown_finished")

func _on_delay_finished():
	if (delay_cb): delay_cb.call()

func _on_recover_finished():
	if (recover_cb): recover_cb.call()
	start_cooldown()
