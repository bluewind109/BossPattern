extends Node2D
class_name PulseEffect

@export var pulse_duration: float = 0.45

var target_obj: Node2D

var pulse_tween: Tween
func start_pulse(_target: Node2D):
	target_obj = _target
	pulse_tween = create_tween()
	pulse_tween.tween_property(target_obj, "modulate:v", 3, pulse_duration)
	pulse_tween.tween_property(target_obj, "modulate:v", 1, pulse_duration)
	pulse_tween.set_loops(-1)

func stop_pulse():
	if(pulse_tween): pulse_tween.kill()
	if (target_obj): target_obj.modulate.v = 1
