extends Node2D
class_name SpearAttack

@export var start_pos: Vector2 = Vector2.ZERO

@onready var pivot: Marker2D = $pivot
@onready var hitbox: ComponentHitbox = $%hitbox
@onready var animation_player: AnimationPlayer = $animation_player
@onready var weapon_sprite: Sprite2D = $%weapon_sprite

@export var original_scale: float =  1.0
@export var attack_time: float = 0.2
@export var return_time: float = 0.5
@export var weapon_damage: float = 1.0

var can_attack: bool = true
var current_look_dir: String = "left"

const ATTACK_ANIM = "attack"
const RETURN_ANIM = "return"


func _ready() -> void:
	position = start_pos
	animation_player.animation_finished.connect(_on_animation_finished)
	hitbox.set_damage(weapon_damage)
	scale = Vector2(original_scale, original_scale)


func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	pivot.look_at(mouse_pos)

	if (current_look_dir == "left" and get_global_mouse_position().x > global_position.x):
		scale.x = original_scale
		current_look_dir = "right"
	elif (current_look_dir == "right" and get_global_mouse_position().x < global_position.x):
		scale.x = original_scale * -1
		current_look_dir = "left"

	if (Input.is_action_just_pressed("attack") and can_attack):
		animation_player.speed_scale =\
		animation_player.get_animation(ATTACK_ANIM).length /  attack_time
		animation_player.play(ATTACK_ANIM)
		can_attack = false


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == ATTACK_ANIM):
		animation_player.speed_scale =\
		animation_player.get_animation(RETURN_ANIM).length /  return_time
		animation_player.play(RETURN_ANIM)
	else:
		can_attack = true
