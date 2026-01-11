extends Area2D
class_name ComponentHurtbox

signal damaged(amount: float)

@onready var take_damage_timer: Timer = $%take_damage_timer

@export var enable_take_damage_cooldown: bool = false
@export var take_damage_cooldown: float =  0.5

# @export var component_health: ComponentHealth
@export var floating_text_scene: PackedScene

var collision_shape: CollisionShape2D = null
var can_take_damage: bool = true


func _ready() -> void:
	if (get_child_count() > 1):
		for child in get_children():
			if (child is CollisionShape2D):
				collision_shape = child
	if(enable_take_damage_cooldown): 
		take_damage_timer.wait_time = take_damage_cooldown
		take_damage_timer.timeout.connect(_on_take_damage_cooldown_finished)
	# assert(component_health, "No component_health:ComponentHealth specified in %s." % [str(get_path())])


func toggle_collision(val: bool):
	if (collision_shape == null): return
	collision_shape.disabled = !val


func take_damage(amount: float) -> void:
	print(get_parent().name, " take_damage ", amount)
	# if (component_health == null): return
	if (!can_take_damage): return

	if (enable_take_damage_cooldown and can_take_damage):
		take_damage_timer.start()
		can_take_damage = false

	# component_health.take_damage(amount)
	damaged.emit(amount)
	
	if (floating_text_scene == null): return
	var floating_text = floating_text_scene.instantiate() as FloatingText
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + Vector2.UP * 16

	var format_damage_string = "%0.2f"
	if (round(amount) == amount):
		format_damage_string = "%0.0f"
	floating_text.start(format_damage_string % amount)


func _on_take_damage_cooldown_finished():
	can_take_damage = true
