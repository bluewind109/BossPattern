extends Node

func get_random_position_around(target: Node2D, min_distance: float, max_distance: float) -> Vector2:
	var _angle = randf_range(0, TAU)
	# var _deg_angle = rad_to_deg(_angle)
	# print(_deg_angle)
	var _distance = randf_range(min_distance, max_distance)
	var direction_vector = Vector2.RIGHT.rotated(_angle)
	var offset = direction_vector * _distance
	var new_pos = target.global_position + offset
	return new_pos