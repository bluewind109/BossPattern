extends EnemySkill
class_name EnemySkill_MagicBall

@export var enemy_projectile_scene: PackedScene
@export var projectile_damage: float = 10.0
@export var spawn_node: Node2D


func _ready() -> void:
	skill_type = SKILL_TYPE.magic_ball
	cooldown_timer.wait_time = cooldown_duration
	super._ready()


func cast_at(_target: Node2D):
	if (_target == null): return
	super.cast_at(_target)
	if (enemy_projectile_scene == null): return

	var enemy_projectile = enemy_projectile_scene.instantiate() as EnemyProjectile
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(enemy_projectile)
	enemy_projectile.global_position = spawn_node.global_position
	var _direction: Vector2 = (_target.global_position - spawn_node.global_position).normalized()
	enemy_projectile.init(_direction, projectile_damage)
