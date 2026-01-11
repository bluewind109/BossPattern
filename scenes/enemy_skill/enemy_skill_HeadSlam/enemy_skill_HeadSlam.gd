extends EnemySkill
class_name EnemySkill_HeadSlam

@export var hitbox_collision_shape: CollisionShape2D
@export var follow_node: Node2D


func _ready() -> void:
	skill_type = SKILL_TYPE.head_slam
	cooldown_timer.wait_time = cooldown_duration
	super._ready()


func _process(delta: float) -> void:
	if (hitbox_collision_shape == null): return
	if (follow_node == null): return
	hitbox_collision_shape.global_position = follow_node.global_position


func cast():
	super.cast()
