extends Node2D
class_name ComponentCharge

var charge_position: Vector2
var charge_direction: Vector2
@export var CHARGE_RANGE: float = 300.0
@export var CHARGE_DISTANCE: float = 400.0

@onready var charge_cooldown_timer: Timer = $charge_cooldown_timer
@export var charge_cooldown_duration: float = 3.0
var is_charging: float = false

var target_pos: Vector2

signal on_charge_finished

func _ready() -> void:
	charge_cooldown_timer.one_shot = true
	charge_cooldown_timer.timeout.connect(on_charge_cooldown_timer_time_out)

func update(speed: float) -> Vector2:
	if (is_charge_distance_reached() and is_charging):
		is_charging = false
		charge_cooldown_timer.start(charge_cooldown_duration)
		on_charge_finished.emit()

	return charge_direction * speed

func charge(_target_pos: Vector2):
	if (not is_charging): return
	if (charge_cooldown_timer.time_left > 0): return
	target_pos = _target_pos
	charge_position = global_position
	charge_direction = global_position.direction_to(target_pos)

func is_in_charge_range(_target_pos: Vector2) -> bool:
	target_pos = _target_pos
	var distance = target_pos.distance_to(global_position)
	return distance <= CHARGE_RANGE

func can_cast() -> bool:
	return charge_cooldown_timer.is_stopped()

func is_charge_distance_reached() -> bool:
	var distance = charge_position.distance_to(global_position)
	return distance >= CHARGE_DISTANCE

func on_charge_cooldown_timer_time_out():
	pass
