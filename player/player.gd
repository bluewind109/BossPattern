extends CharacterBody2D
class_name Player

@export var component_health: ComponentHealth

var max_health: float = 100.0

func _ready() -> void:
	var health = max_health
	component_health.init.call_deferred(max_health, health)
