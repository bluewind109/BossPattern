extends Node
class_name VialDrop

@export var exp_vial: PackedScene
@export var health_component: ComponentHealth


func _ready() -> void:
	health_component.died.connect(_on_died)


func _on_died():
	if (exp_vial == null): return
	if (not owner is Node2D): return

	var vial_instance = exp_vial.instantiate() as ExperienceVial
	var spawn_pos = (owner as Node2D).global_position
	vial_instance.global_position = spawn_pos
	owner.get_parent().add_child.call_deferred(vial_instance)
