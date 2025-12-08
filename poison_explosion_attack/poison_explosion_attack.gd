extends EnemySkill
class_name PoisonExplosionAttack

var explo_prefab:= preload("res://explosion/explosion.tscn")


var explosion_count: int = 6
var attack_cooldown_duration: float = 4.0
var delay_duration: float = 2.0

func _ready() -> void:
	cooldown_timer.wait_time = attack_cooldown_duration

var explo_range: Vector2 = Vector2(50, 100)
func cast_at(target: Node2D):
	super.cast_at(target)
	for i in explosion_count:
		var result_pos = Utils.get_random_position_around(target, explo_range.x, explo_range.y)
		var explo_instance = explo_prefab.new() as Explosion
		explo_instance.global_position = result_pos
		get_tree().current_scene.add_child(explo_instance)

func _on_cooldown_finished():
	super._on_cooldown_finished()
	print("[PoisonExplosionAttack] _on_cooldown_finished")

