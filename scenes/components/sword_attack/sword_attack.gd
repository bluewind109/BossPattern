extends Node2D
class_name SwordAttack

@onready var pivot: Marker2D = $pivot
@onready var animation_player: AnimationPlayer = $animation_player
@onready var sword_sprite: Sprite2D = $%sword_sprite

@export var sword_slash_scene: PackedScene
@export var attack_time: float = 0.2
@export var return_time: float = 0.5
@export var weapon_damage: float = 1.0

var can_attack: bool = true
var current_look_dir: String = "left"

const ATTACK_ANIM = "slash"
const RETURN_ANIM = "sword_return"


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	pivot.look_at(mouse_pos)

	if (current_look_dir == "left" and get_global_mouse_position().x > global_position.x):
		scale.x = 1
		current_look_dir = "right"
	elif (current_look_dir == "right" and get_global_mouse_position().x < global_position.x):
		scale.x = -1
		current_look_dir = "left"

	if (Input.is_action_just_pressed("attack") and can_attack):
		animation_player.speed_scale =\
		animation_player.get_animation(ATTACK_ANIM).length /  attack_time
		animation_player.play(ATTACK_ANIM)
		can_attack = false


func spawn_slash() -> void:
	if (sword_slash_scene == null): return
	var sword_slash = sword_slash_scene.instantiate() as SwordSlash

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(sword_slash)
	sword_slash.animation_player.speed_scale =\
	sword_slash.animation_player.get_animation(ATTACK_ANIM).length /  attack_time
	
	if (get_global_mouse_position().x > global_position.x):
		sword_slash.slash_sprite.flip_v = false
	else:
		sword_slash.slash_sprite.flip_v = true
		
	sword_slash.global_position = global_position
	sword_slash.look_at(get_global_mouse_position())
	sword_slash.set_damage(weapon_damage)
	sword_slash.play_slash_anim()


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == ATTACK_ANIM):
		animation_player.speed_scale =\
		animation_player.get_animation(RETURN_ANIM).length /  return_time
		animation_player.play(RETURN_ANIM)
	else:
		can_attack = true
