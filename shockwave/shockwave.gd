extends Node2D
class_name ComponentShockwave

@export var ATTACK_RANGE: float = 100.0

@onready var shockwave_cooldown_timer: Timer = $shockwave_cooldown_timer
var shockwave_cooldown_duration: float = 7.5

var target_pos: Vector2
var can_attack: bool = false

func _ready() -> void:
	shockwave_cooldown_timer.one_shot = true
	shockwave_cooldown_timer.timeout.connect(_on_shockwave_cooldown_timer_time_out)
	can_attack = true

func attack(_target_pos: Vector2):
	if (not can_attack): return
	var projectile_shockwave: ProjectileShockwave = ProjectileShockwave.new_projectile(
		global_position, 
		_target_pos, 
		250, 
		75
	)
	get_tree().current_scene.add_child(projectile_shockwave)
	projectile_shockwave.activate()
	shockwave_cooldown_timer.start(shockwave_cooldown_duration)
	can_attack = false

func is_in_attack_range(_target_pos: Vector2) -> bool:
	target_pos = _target_pos
	var distance = target_pos.distance_to(global_position)
	return distance <= ATTACK_RANGE

func _on_shockwave_cooldown_timer_time_out():
	can_attack = true
