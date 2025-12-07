extends RefCounted
class_name CallableState

var normal: Callable
var enter: Callable
var leave: Callable

func _init(
	normal_state_callable: Callable,
	enter_state_callable: Callable,
	leave_state_callable: Callable
):
	normal = normal_state_callable
	enter = enter_state_callable
	leave = leave_state_callable
