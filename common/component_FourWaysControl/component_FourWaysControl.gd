@icon("./icon.png")
extends BaseControlComponent
class_name ComponentFourWaysControl

@export var input_action_up: InputEventAction
@export var input_action_down: InputEventAction
@export var input_action_left: InputEventAction
@export var input_action_right: InputEventAction

func _ready() -> void:
	if (null == input_action_up):
		reset_action_up()

	if (null == input_action_down):
		reset_action_down()

	if (null == input_action_left):
		reset_action_left()

	if (null == input_action_right):
		reset_action_right()

func _process(_delta: float) -> void:
	if (component_velocity == null): return
	component_velocity.direction = Input.get_vector(
		input_action_left.action, 
		input_action_right.action,
		input_action_up.action,
		input_action_down.action
	)

func reset_action_up():
	input_action_up = InputEventAction.new()
	input_action_up.action = PLAYER_INPUT.UP

func reset_action_down():
	input_action_down = InputEventAction.new()
	input_action_down.action = PLAYER_INPUT.DOWN

func reset_action_left():
	input_action_left = InputEventAction.new()
	input_action_left.action = PLAYER_INPUT.LEFT

func reset_action_right():
	input_action_right = InputEventAction.new()
	input_action_right.action = PLAYER_INPUT.RIGHT
