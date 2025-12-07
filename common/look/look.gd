extends Node2D
class_name ComponentLook

@export var origin_sprite: Sprite2D
@export var is_base_sprite_looking_left: bool = true

func _ready() -> void:
	pass

func look(target_pos: Vector2):
	if (is_base_sprite_looking_left):
		if (global_position.x < target_pos.x):
			origin_sprite.flip_h = true
		else:
			origin_sprite.flip_h = false
	else:
		if (global_position.x > target_pos.x):
			origin_sprite.flip_h = true
		else:
			origin_sprite.flip_h = false



	
