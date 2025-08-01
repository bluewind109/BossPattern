extends Node2D
class_name ComponentSteer

var debug_enabled: bool = false
var debug: Dictionary = {}

func steer(
	velocity: Vector2,
	global_pos: Vector2,
	target_pos: Vector2,
	max_speed: float = 200.0,
	mass: float = 20.0, # speed of the steering force
) -> Vector2:
	var desired_velocity = target_pos - global_pos
	var scaled_dv = desired_velocity.normalized() * max_speed

	var _steer: Vector2 = (scaled_dv - velocity) / mass

	if (debug_enabled):
		update_debug({
			"velocity": velocity,
			"scaled_dv": scaled_dv,
			"_steer": _steer
		})

	return velocity + _steer

func _process(_delta: float) -> void:
	queue_redraw()

func update_debug(dict: Dictionary):
	for key in dict:
		debug[key] = dict[key]

func _draw():
	return
	# if (debug_enabled == false): return
	# if (debug.size() == 0): return

	# draw_line(position, debug["velocity"], Color.BLACK, 4.0)
	# draw_line(position, debug["scaled_dv"], Color.BLUE, 4.0)
	# draw_line(debug["velocity"], debug["scaled_dv"], Color.RED, 4.0)
	# draw_circle(debug["velocity"], 3.0, Color.BLACK)
