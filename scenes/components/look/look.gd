extends Node2D
class_name ComponentLook

@export var is_base_sprite_looking_left: bool = true
@export var visual_node: Node2D

func _ready() -> void:
	pass

func look(target_pos: Vector2):
	if (is_base_sprite_looking_left):
		if (get_owner_position().x < target_pos.x):
			flip_direction(true)
		else:
			flip_direction(false)
	else:
		if (get_owner_position().x > target_pos.x):
			flip_direction(true)
		else:
			flip_direction(false)

func flip_direction(is_flipped: bool):
	if (!visual_node): return
	if (is_flipped):
		visual_node.scale.x = -1
	else:
		visual_node.scale.x = 1


func get_owner_position() -> Vector2:
	var owner_node = owner as Node2D
	if (owner_node == null): return Vector2.ZERO
	return owner_node.global_position

	
