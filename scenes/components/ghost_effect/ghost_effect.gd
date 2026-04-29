@icon("./icon.png")
extends Node2D
class_name GhostEffect

@onready var duration_timer: Timer = $duration_timer
@export var effect_interval: float = 0.025
@export var effect_duration: float = 0.3

var sprite_2d: Node2D

func _ready() -> void:
	return

func start_effect() -> void:
	duration_timer.start(effect_interval)

func stop_effect() -> void:
	duration_timer.stop()

func tween_ghost_effect() -> void:
	if (sprite_2d == null): return
	# print("[component_GhostEffect] tween_ghost_effect")
	var ghost_effect_sprite = sprite_2d.duplicate() as Node2D

	var offset: Vector2 = Vector2.ZERO
	ghost_effect_sprite.modulate = Color8(255, 255, 255, 32)
	ghost_effect_sprite.global_position = sprite_2d.global_position + offset
	ghost_effect_sprite.scale = sprite_2d.scale

	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(
		ghost_effect_sprite, 
		"modulate", 
		Color8(1, 1, 1, 0), 
		effect_duration
	)
	tween_fade.tween_callback(ghost_effect_sprite.queue_free)
	get_tree().current_scene.add_child(ghost_effect_sprite)
	
func _on_ghost_timer_timeout() -> void:
	tween_ghost_effect()
