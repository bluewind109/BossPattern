extends Node2D
## State Machine using callable
## Source code from FireBelley: 
## https://gist.github.com/firebelley/96f2f82e3feaa2756fe647d8b9843174 
class_name CallableStateMachine

var state_dictionary: Dictionary[String, CallableState] = {}
var current_state: String

func add_states(state_name: String, callable_state: CallableState):
	state_dictionary[state_name] = callable_state

func set_initial_state(state_name: String):
	# print("set_initial_state: ", state_name)
	# var state_name = state_callable.get_method()
	if (state_dictionary.has(state_name)):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state found with name: ", state_name)

func update(delta: float):
	if (state_dictionary.has(current_state)):
		# print("update: ", current_state)
		var normal_state: CallableState = state_dictionary[current_state]
		var normal_callback: Callable = normal_state.normal
		normal_callback.call(delta)

func change_state(state_name: String):
	if (state_dictionary.has(state_name)):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state found with name: ", state_name)

func _set_state(state_name: String):
	if (current_state != ""):
		var leave_callable: Callable = state_dictionary[current_state].leave
		if (not leave_callable.is_null()):
			leave_callable.call()
		
	current_state = state_name
	var enter_callable: Callable = state_dictionary[current_state].enter
	if (not enter_callable.is_null()):
		enter_callable.call()

func is_in_state(state_name: String) -> bool:
	return current_state.contains(state_name)
