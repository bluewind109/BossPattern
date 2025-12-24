extends EnemySkill
class_name EnemySkill_PoisonExplosion

var explo_prefab:= preload("res://explosion/explosion_PoisonBomb/explosion_PoisonBomb.tscn")

@export var CAST_RANGE: float = 300.0

var explosion_count: int = 6
@export var cooldown_duration: float = 4.0

func _ready() -> void:
	skill_type = SKILL_TYPE.poison_explosion_attack
	cooldown_timer.wait_time = cooldown_duration
	super._ready()

var explo_range: Vector2 = Vector2(50, 100)
func cast_at(target: Node2D):
	super.cast_at(target)
	for i in explosion_count:
		var result_pos = Utils.get_random_position_around(target, explo_range.x, explo_range.y)
		var explo_instance = explo_prefab.instantiate() as Explosion
		# get_tree().current_scene.add_child(explo_instance)
		SignalManager.on_explosion_created.emit(explo_instance)
		explo_instance.init.call_deferred(result_pos, delay_duration)
		explo_instance.activate_explosion.call_deferred()
	on_skill_finished.emit()

func is_in_cast_range(_target_pos: Vector2) -> bool:
	var distance = _target_pos.distance_to(global_position)
	return distance <= CAST_RANGE
