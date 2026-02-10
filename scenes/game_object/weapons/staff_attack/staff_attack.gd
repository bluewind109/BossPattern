extends Weapon
class_name StaffAttack

@export var magic_projectile_scene: PackedScene
@export var start_pos: Vector2 = Vector2.ZERO
@export var projectile_spawn: Node2D

@onready var pivot: Marker2D = $pivot
@onready var animation_player: AnimationPlayer = $animation_player
@onready var spells_node: Node = $%spells

@export var original_scale: float =  1.0
@export var attack_time: float = 0.2
@export var return_time: float = 0.5
@export var projectile_speed: float = 300.0

var can_attack: bool = true
var current_look_dir: String = "left"

const ATTACK_1_ANIM = "attack_1"
const RETURN_1_ANIM = "return_1"
const ATTACK_2_ANIM = "attack_2"
const RETURN_2_ANIM = "return_2"


func _ready() -> void:
	position = start_pos
	animation_player.animation_finished.connect(_on_animation_finished)
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
		shoot_projectile()
	if (Input.is_action_just_pressed("alt_attack") and can_attack):
		cast_spell()


func shoot_projectile() -> void:
	animation_player.speed_scale = attack_time * get_attack_speed()
	# animation_player.get_animation(ATTACK_1_ANIM).length /  attack_time
	animation_player.play(ATTACK_1_ANIM)
	can_attack = false
	start_attack()


func spawn_projectile() -> void:
	if (magic_projectile_scene == null): return
	var magic_projectile = magic_projectile_scene.instantiate() as MagicProjectile
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(magic_projectile)
	if (projectile_spawn == null): 
		magic_projectile.global_position = global_position
	else:
		magic_projectile.global_position = projectile_spawn.global_position

	if (get_global_mouse_position().x > global_position.x):
		magic_projectile.pivot.scale = Vector2(1, 1)
		magic_projectile.rotation = pivot.rotation
	else:
		magic_projectile.pivot.scale = Vector2(-1, -1)
		magic_projectile.rotation = pivot.rotation * -1

	var _direction = (get_global_mouse_position() - global_position).normalized()
	magic_projectile.init(_direction, weapon_damage, projectile_speed)


func cast_spell() -> void:
	animation_player.speed_scale = attack_time * get_attack_speed()
	# animation_player.get_animation(ATTACK_2_ANIM).length /  attack_time
	animation_player.play(ATTACK_2_ANIM)
	can_attack = false	
	start_attack()


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == ATTACK_1_ANIM):
		animation_player.speed_scale = return_time * get_attack_speed()
		# animation_player.get_animation(RETURN_1_ANIM).length /  return_time
		animation_player.play(RETURN_1_ANIM)
		stop_attack()
	elif (_anim_name == ATTACK_2_ANIM):
		animation_player.speed_scale = return_time * get_attack_speed()
		# animation_player.get_animation(RETURN_2_ANIM).length /  return_time
		animation_player.play(RETURN_2_ANIM)
		stop_attack()
	else:
		can_attack = true
