@icon("./icon.png")
extends Node
class_name ComponentFourWaysControl

const PLAYER_INPUT: Dictionary[String, String] = {
	"UP": "up",
	"DOWN": "down",
	"LEFT": "left",
	"RIGHT": "right",
}

var input_action_up: InputEventAction
var input_action_down: InputEventAction
var input_action_left: InputEventAction
var input_action_right: InputEventAction

var max_speed: float = 100.0


func _ready() -> void:
	if (null == input_action_up):
		reset_action_up()

	if (null == input_action_down):
		reset_action_down()

	if (null == input_action_left):
		reset_action_left()

	if (null == input_action_right):
		reset_action_right()


func set_max_speed(amount: float):
	max_speed = max(0, amount)


func _process(_delta: float) -> void:
	var direction = get_movement_direction()
	var owner_node= owner as CharacterBody2D
	if (owner_node == null): return
	owner_node.velocity = max_speed * direction
	owner_node.move_and_slide()


func get_movement_direction() -> Vector2:
	var movement_direction: Vector2 = Vector2.ZERO
	movement_direction = Input.get_vector(
		input_action_left.action, 
		input_action_right.action,
		input_action_up.action,
		input_action_down.action
	)
	return movement_direction


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
