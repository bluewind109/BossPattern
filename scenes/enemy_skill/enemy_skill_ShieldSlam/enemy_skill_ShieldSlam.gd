extends EnemySkill
class_name EnemySkill_ShieldSlam

@export var hitbox_collision_shape: CollisionShape2D
@export var follow_node: Node2D

var is_casting: bool = false
var base_position: Vector2


func _ready() -> void:
	skill_type = SKILL_TYPE.shield_slam
	cooldown_timer.wait_time = cooldown_duration
	if (hitbox_collision_shape != null): 
		base_position = hitbox_collision_shape.position
		
	super._ready()


func _process(delta: float) -> void:
	if (!is_casting): return
	if (hitbox_collision_shape == null): return
	if (follow_node == null): return
	hitbox_collision_shape.global_position = follow_node.global_position


func cast():
	super.cast()
	is_casting = true


func reset_collision_shape():
	hitbox_collision_shape.position = base_position
