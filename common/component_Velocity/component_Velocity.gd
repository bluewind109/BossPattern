extends Node2D
class_name ComponentVelocity

const DECELERATION_TARGET: Vector2 = Vector2.ZERO

var owner_node: CharacterBody2D

@export var acceleration_coefficient: float = 1.0
@export var deceleration_coefficient: float = 1.0

@export var max_speed: float = 150.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if (owner_node == null): return

	if (direction):
		_accelerate()
	else:
		if (owner_node.velocity):
			_decelerate()
	owner_node.move_and_slide()

func _accelerate():
	var acceleration_rate: float = max_speed * acceleration_coefficient
	var speed: Vector2 = direction.normalized() * max_speed
	owner_node.velocity = owner_node.velocity.move_toward(speed, acceleration_rate)

func _decelerate():
	var deceleration_rate: float = max_speed * deceleration_coefficient
	owner_node.velocity = owner_node.velocity.move_toward(DECELERATION_TARGET, deceleration_rate)
