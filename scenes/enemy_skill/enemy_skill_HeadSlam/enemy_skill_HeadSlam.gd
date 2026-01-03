extends EnemySkill
class_name EnemySkill_HeadSlam

@export var cast_range: float = 25.0
@export var hitbox_collision_shape: CollisionShape2D
@export var follow_node: Node2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if (hitbox_collision_shape == null): return
	if (follow_node == null): return
	hitbox_collision_shape.global_position = follow_node.global_position

func cast():
	super.cast()


func is_in_cast_range(_target_pos: Vector2) -> bool:
	var owner_node = owner as Node2D
	var distance = _target_pos.distance_to(owner_node.global_position)
	return distance <= cast_range
