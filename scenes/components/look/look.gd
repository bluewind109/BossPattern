extends Node2D
class_name ComponentLook

@export var is_disabled: bool = false
# @export var use_rotation: bool = false
@export var is_base_sprite_looking_left: bool = true
@export var visual_node: Node2D
# @export var pivot: Marker2D

var target_pos: Vector2

func _ready() -> void:
	pass

func look(_target_pos: Vector2):
	if (is_disabled): return
	target_pos = _target_pos
	var direction = (target_pos - get_owner_position()).normalized()
	flip_direction(direction.x > 0) if is_base_sprite_looking_left else flip_direction(direction.x < 0)


func flip_direction(is_flipped: bool):
	if (!visual_node): return
	visual_node.scale.x = -1 if is_flipped else 1

	# if (use_rotation && pivot != null):
		# pivot.look_at(target_pos)
		# pivot.scale.y = -1 if is_flipped else 1
		# return


func get_owner_position() -> Vector2:
	var owner_node = owner as Node2D
	if (owner_node == null): return Vector2.ZERO
	return owner_node.global_position

	
