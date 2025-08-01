extends Node2D
class_name ComponentCharge

var charge_position: Vector2
var charge_direction: Vector2
@export var CHARGE_RANGE: float = 300.0
@export var CHARGE_DISTANCE: float = 400.0

@export var charge_cooldown_timer: Timer
var charge_cooldown_duration: float = 3.0
var can_charge: float = true

var target_pos: Vector2

signal is_charge_done

func _ready() -> void:
	charge_cooldown_timer.one_shot = true
	charge_cooldown_timer.timeout.connect(on_charge_cooldown_timer_time_out)

func update(speed: float) -> Vector2:
	if (is_charge_distance_reached() and can_charge):
		can_charge = false
		charge_cooldown_timer.start(charge_cooldown_duration)
		is_charge_done.emit()

	return charge_direction * speed

func charge(_target_pos: Vector2):
	if (not can_charge): return
	target_pos = _target_pos
	charge_position = global_position
	charge_direction = global_position.direction_to(target_pos)

func is_in_charge_range(_target_pos: Vector2) -> bool:
	target_pos = _target_pos
	var distance = target_pos.distance_to(global_position)
	return distance <= CHARGE_RANGE

func is_charge_distance_reached() -> bool:
	var distance = charge_position.distance_to(global_position)
	return distance >= CHARGE_DISTANCE

func on_charge_cooldown_timer_time_out():
	can_charge = true
