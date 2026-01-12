extends Node2D
class_name SwordAttack

@onready var animation_player: AnimationPlayer = $animation_player
@onready var sword_sprite: Sprite2D = $%sword_sprite

@export var sword_slash_scene: PackedScene
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

var can_slash: bool = true
var current_look_dir: String = "left"

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	if (current_look_dir == "left" and get_global_mouse_position().x > global_position.x):
		scale.x = 1
		current_look_dir = "right"
	elif (current_look_dir == "right" and get_global_mouse_position().x < global_position.x):
		scale.x = -1
		current_look_dir = "left"

	if (Input.is_action_just_pressed("attack") and can_slash):
		animation_player.speed_scale =\
		animation_player.get_animation("slash").length /  slash_time
		animation_player.play("slash")
		can_slash = false
		spawn_slash()


func spawn_slash() -> void:
	var sword_slash = sword_slash_scene.instantiate() as SwordSlash

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(sword_slash)
	sword_slash.animation_player.speed_scale =\
	sword_slash.animation_player.get_animation("slash").length /  slash_time
	
	if (get_global_mouse_position().x > global_position.x):
		sword_slash.slash_sprite.flip_v = false
	else:
		sword_slash.slash_sprite.flip_v = true
		
	sword_slash.global_position = global_position
	sword_slash.set_damage(weapon_damage)


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == "slash"):
		animation_player.speed_scale =\
		animation_player.get_animation("sword_return").length /  sword_return_time
		animation_player.play("sword_return")
	else:
		can_slash = true
