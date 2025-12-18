extends EnemySkill
class_name Charge

var charge_position: Vector2
var charge_direction: Vector2
@export var CHARGE_RANGE: float = 200.0
@export var CHARGE_DISTANCE: float = 300.0

@export var cooldown_duration: float = 3.0
var is_charging: float = false

var target_pos: Vector2

func _ready() -> void:
	skill_type = SKILL_TYPE.charge
	cooldown_timer.wait_time = cooldown_duration
	super._ready()

func update(speed: float) -> Vector2:
	if (is_charge_distance_reached() and is_charging):
		is_charging = false
		cooldown_timer.start()
		on_skill_finished.emit()

	return charge_direction * speed

func cast_at(_target: Node2D):
	super.cast_at(_target)
	if (is_charging): return
	is_charging = true
	target_pos = _target.global_position
	charge_position = global_position
	charge_direction = global_position.direction_to(target_pos)

func is_in_charge_range(_target_pos: Vector2) -> bool:
	target_pos = _target_pos
	var distance = target_pos.distance_to(global_position)
	return distance <= CHARGE_RANGE

func is_charge_distance_reached() -> bool:
	var distance = charge_position.distance_to(global_position)
	return distance >= CHARGE_DISTANCE
