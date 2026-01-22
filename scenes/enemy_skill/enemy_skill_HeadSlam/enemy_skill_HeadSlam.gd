extends EnemySkill
class_name EnemySkill_HeadSlam

@export var hitbox_collision_shape: CollisionShape2D
@export var follow_node: Node2D
@export var pivot: Marker2D


func _ready() -> void:
	skill_type = SKILL_TYPE.head_slam
	cooldown_timer.wait_time = cooldown_duration
	super._ready()


func _process(delta: float) -> void:
	if (hitbox_collision_shape == null): return
	if (follow_node == null): return
	hitbox_collision_shape.global_position = follow_node.global_position


func cast_at(_target: Node2D):
	super.cast_at(_target)
	pivot.look_at(_target.global_position)


func on_skill_casted():
	super.on_skill_casted()
	pivot.rotation_degrees = 0
