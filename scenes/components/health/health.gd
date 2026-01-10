@icon("./icon.png")
extends Node2D
# Note: Make a child class if you want to display health bar, etc.
class_name ComponentHealth

signal died
signal health_changed(amount: float)
signal health_decreased(amount: float)
signal max_health_changed(amount: float)

var health: float = 10.0:
	set(val):
		health = clampf(val, 0, max_health)
		health_changed.emit(health)

@export var max_health: float = 10.0:
	set(val):
		max_health = val
		max_health_changed.emit(max_health)


func init(_max_health: float):
	max_health = _max_health
	health = _max_health


func take_damage(amount: float):
	if (is_dead()): return
	health = clampf(health - amount, 0, max_health)
	if (amount > 0): health_decreased.emit(amount)
	if (health <= 0): died.emit()


func heal(heal_amount: float):
	print("heal: ", heal_amount)
	take_damage(heal_amount * -1)


func is_dead() -> bool:
	return health <= 0
