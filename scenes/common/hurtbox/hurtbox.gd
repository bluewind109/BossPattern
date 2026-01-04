extends Area2D
class_name ComponentHurtbox

@export var component_health: ComponentHealth
@export var floating_text_scene: PackedScene

signal damaged(amount: float)

func _ready() -> void:
	assert(component_health, "No component_health:ComponentHealth specified in %s." % [str(get_path())])

func take_damage(amount: float) -> void:
	print(get_parent().name, " take_damage ", amount)
	if (component_health == null): return
	component_health.take_damage(amount)
	damaged.emit(amount)
	
	if (floating_text_scene == null): return
	var floating_text = floating_text_scene.instantiate() as FloatingText
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + Vector2.UP * 16
	floating_text.start(str(amount))
