extends Area2D
class_name ComponentHurtbox

@export var component_health: ComponentHealth

signal damaged(amount: float)

func _ready() -> void:
	assert(component_health, "No component_health:ComponentHealth specified in %s." % [str(get_path())])

func take_damage(amount: float) -> void:
	print(get_parent().name, " take_damage ", amount)
	if (not component_health): return
	component_health.take_damage(amount)
	damaged.emit(amount)
