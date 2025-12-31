extends EnemySkill
class_name EnemySkill_MeleeAttack

@export var cast_range: float = 25.0
@export var explo_range: Vector2 = Vector2(25, 50)
@export var cooldown_duration: float = 3.0

func _ready() -> void:
	skill_type = SKILL_TYPE.melee
	cooldown_timer.wait_time = cooldown_duration
	super._ready()

func cast_at(target: Node2D):
	super.cast_at(target)
	var result_pos: Vector2 = Utils.get_final_cast_position(
		global_position, 
		target.global_position, 
		cast_range
	)
	var explo_instance = explo_prefab.instantiate() as Explosion
	SignalManager.on_explosion_created.emit(explo_instance)
	explo_instance.init.call_deferred(result_pos, delay_duration)
	explo_instance.look.call_deferred(target)
	explo_instance.activate_explosion.call_deferred()

func is_in_cast_range(_target_pos: Vector2) -> bool:
	var distance = _target_pos.distance_to(global_position)
	return distance <= cast_range
