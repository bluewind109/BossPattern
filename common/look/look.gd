extends Node2D
class_name ComponentLook

@export var is_base_sprite_looking_left: bool = true
var owner_node: Node2D

func _ready() -> void:
	pass

func look(target_pos: Vector2):
	if (is_base_sprite_looking_left):
		if (global_position.x < target_pos.x):
			flip_direction(true)
		else:
			flip_direction(false)
	else:
		if (global_position.x > target_pos.x):
			flip_direction(true)
		else:
			flip_direction(false)

func flip_direction(is_flipped: bool):
	if (!owner_node): return
	if (is_flipped):
		owner_node.scale.x = -1
	else:
		owner_node.scale.x = 1



	
