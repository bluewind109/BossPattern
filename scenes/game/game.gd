extends Node2D
class_name GameManager

@onready var explosion_container: Node2D = $explosion_container

func _ready() -> void:
	SignalManager.on_explosion_created.connect(_on_explosion_created)

func _on_explosion_created(target: Explosion):
	explosion_container.add_child(target)
