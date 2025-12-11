extends EnemySkill
class_name ComponentShockwave

@export var ATTACK_RANGE: float = 100.0

var cooldown_duration: float = 7.5

var target_pos: Vector2
var can_attack: bool = false

func _ready() -> void:
	cooldown_timer.wait_time = cooldown_duration
	can_attack = true

func cast_at(_target: Node2D):
	super.cast_at(_target)
	var projectile_shockwave: ProjectileShockwave = ProjectileShockwave.new_projectile(
		global_position, 
		_target.global_position, 
		250, 
		75
	)
	get_tree().current_scene.add_child(projectile_shockwave)
	projectile_shockwave.activate()
	cooldown_timer.start()
	can_attack = false

func is_in_attack_range(_target_pos: Vector2) -> bool:
	target_pos = _target_pos
	var distance = target_pos.distance_to(global_position)
	return distance <= ATTACK_RANGE

func _on_cooldown_finished():
	can_attack = true
