extends Node
class_name Barrier

signal destroyed
signal health_changed(amount: float)
signal health_decreased(amount: float)
signal max_health_changed(amount: float)

var health: float = 5.0:
	set(val):
		health = clampf(val, 0, max_health)
		health_changed.emit(health)

var max_health: float = 5.0:
	set(val):
		max_health = val
		max_health_changed.emit(max_health)

var absorb_ratio: float = 0.5 # take less damage if lower than 1.0


func init(_max_health: float):
	max_health = _max_health
	health = _max_health


func take_damage(amount: float):
	if (is_destroyed()): return
	health = clampf(health - amount, 0, max_health)
	if (amount > 0): health_decreased.emit(amount)
	if (health <= 0): destroyed.emit()


func is_destroyed() -> bool:
	return health <= 0
