extends EnemySkill
class_name EnemySkill_MeleeAttack

@export var explo_prefab: PackedScene
@export var explo_range: Vector2 = Vector2(25, 50)


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
