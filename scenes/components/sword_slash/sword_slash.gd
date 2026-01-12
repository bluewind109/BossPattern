extends Node2D
class_name SwordSlash

@export var animation_player: AnimationPlayer
@export var hitbox: ComponentHitbox
@export var slash_sprite: Sprite2D


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	look_at(get_global_mouse_position())
	animation_player.play("slash")


func set_damage(amount: float):
	hitbox.set_damage(amount)


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == "slash"):
		queue_free()
