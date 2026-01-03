extends EnemySkill
class_name EnemySkill_PoisonExplosion

@export var explo_prefab: PackedScene

@export var explo_range: Vector2 = Vector2(5, 125)
@export var explosion_delay_duration: float = 1.5
@export var explosion_count: int = 6


func _ready() -> void:
	skill_type = SKILL_TYPE.poison_explosion_attack
	cooldown_timer.wait_time = cooldown_duration
	super._ready()


func cast_at(target: Node2D):
	super.cast_at(target)
	if (not explo_prefab): return

	var result_pos: Vector2 = Utils.get_final_cast_position(
		global_position, 
		target.global_position, 
		cast_range
	)

	for i in explosion_count:
		var explo_pos: Vector2 = Vector2.ZERO
		
		if (i == 0): # guaranteed to always have 1 attack at target's position
			explo_pos = target.global_position
		else:
			explo_pos = Utils.get_random_position_around(result_pos, explo_range.x, explo_range.y)
		var explo_instance = explo_prefab.instantiate() as Explosion
		SignalManager.on_explosion_created.emit(explo_instance)
		explo_instance.init.call_deferred(explo_pos, explosion_delay_duration)
		explo_instance.activate_explosion.call_deferred()
	on_skill_finished.emit()
