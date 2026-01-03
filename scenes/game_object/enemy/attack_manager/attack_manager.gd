extends Node
# Manage all attack patterns of a boss enemy
class_name AttackManager

@onready var cooldown_timer: Timer = $cooldown_timer
@onready var delay_timer: Timer = $delay_timer
@onready var recover_timer: Timer = $recover_timer

@export var ATTACK_RANGE: float = 150.0

var next_skill: EnemySkill
var is_casting: bool = false
## global attack cooldown
@export var cooldown_duration: float = 2.5

signal on_attack_finished

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	cooldown_timer.wait_time = cooldown_duration
	is_casting = false

func attack():
	is_casting = true

func can_attack() -> bool:
	return cooldown_timer.is_stopped()

func is_in_attack_range(_target_pos: Vector2) -> bool:
	var distance = _target_pos.distance_to(get_parent().global_position)
	return distance <= ATTACK_RANGE

func set_next_skill(_skill: EnemySkill):
	if (next_skill and next_skill.on_skill_finished.is_connected(_on_skill_finished)): 
		next_skill.on_skill_finished.disconnect(_on_skill_finished)
	next_skill = _skill
	is_casting = next_skill != null

	if (next_skill):
		next_skill.on_skill_finished.connect(_on_skill_finished)

func get_wind_up_duration() -> float:
	if (not next_skill): return 0
	return next_skill.delay_duration

func get_recover_duration() -> float:
	if (not next_skill): return 0
	return next_skill.recover_duration

func _on_skill_ready():
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
	# print("[AttackManager] _on_cooldown_finished")
	pass
