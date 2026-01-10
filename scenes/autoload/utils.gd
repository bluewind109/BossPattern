extends Node

func get_random_position_around(target_pos: Vector2, min_distance: float, max_distance: float) -> Vector2:
	var _angle = randf_range(0, TAU)
	# var _deg_angle = rad_to_deg(_angle)
	# print(_deg_angle)
	var _distance = randf_range(min_distance, max_distance)
	var direction_vector = Vector2.RIGHT.rotated(_angle)
	var offset = direction_vector * _distance
	var new_pos = target_pos + offset
	return new_pos

func get_final_cast_position(current_pos: Vector2, target_pos: Vector2, cast_range: float) -> Vector2:
	var result_pos: Vector2 = target_pos
	var _distance: float = current_pos.distance_to(result_pos)
	var _direction: Vector2 = current_pos.direction_to(result_pos)
	if (_distance > cast_range):
		result_pos = current_pos + _direction * cast_range
	return result_pos