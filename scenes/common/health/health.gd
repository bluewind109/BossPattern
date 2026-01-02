@icon("./icon.png")
extends Node2D
# Note: Make a child class if you want to display health bar, etc.
class_name ComponentHealth

signal died
signal on_health_changed(amount: float)
signal on_max_health_changed(amount: float)

var health: float = 10.0:
	set(val):
		health = clampf(val, 0, max_health)

@export var max_health: float = 10.0:
	set(val):
		max_health = val
		on_max_health_changed.emit(max_health)


func init(_max_health: float, _health: float):
	max_health = _max_health
	health = _health


func take_damage(amount: float):
	if (is_dead()): return
	health = max(health - amount, 0)
	on_health_changed.emit(health)
	if (health <= 0): died.emit()


func is_dead() -> bool:
	return health <= 0
