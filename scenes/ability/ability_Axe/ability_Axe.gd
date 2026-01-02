extends Node2D
class_name Ability_Axe

const MAX_RADIUS: float = 75

@onready var hitbox: ComponentHitbox = $hitbox

var base_rotation: Vector2 = Vector2.RIGHT


func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

	var tween = create_tween()
	tween.tween_method(_tween_rotate_axe, 0.0, 2.0, 2)
	tween.tween_callback(func(): queue_free())


func _tween_rotate_axe(_rotation: float):
	var percent = _rotation / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(_rotation * TAU)
	
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if (player == null): return
	
	global_position = player.global_position + (current_direction * current_radius)
