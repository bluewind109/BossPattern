extends Node
## State Machine using callable
## Source code from FireBelley: 
## https://gist.github.com/firebelley/96f2f82e3feaa2756fe647d8b9843174 
class_name CallableStateMachine

var state_dictionary: Dictionary[int, CallableState] = {}
var current_state: int

func add_states(state_id: int, callable_state: CallableState):
	state_dictionary[state_id] = callable_state

func set_initial_state(state_id: int):
	# print("set_initial_state: ", state_name)
	# var state_name = state_callable.get_method()
	if (state_dictionary.has(state_id)):
		_set_state.call_deferred(state_id)
	else:
		push_warning("No state found with id: ", state_id)

func update(delta: float):
	if (state_dictionary.has(current_state)):
		# print("update: ", current_state)
		var normal_state: CallableState = state_dictionary[current_state]
		var normal_callback: Callable = normal_state.normal
		normal_callback.call(delta)

func change_state(state_id: int):
	if (state_dictionary.has(state_id)):
		_set_state.call_deferred(state_id)
	else:
		push_warning("No state found with id: ", state_id)

func _set_state(state_id: int):
	if (current_state != -1):
		var leave_callable: Callable = state_dictionary[current_state].leave
		if (not leave_callable.is_null()):
			leave_callable.call()
		
	current_state = state_id
	var enter_callable: Callable = state_dictionary[current_state].enter
	if (not enter_callable.is_null()):
		enter_callable.call()

func is_in_state(state_id: int) -> bool:
	return current_state == state_id
