extends Weapon
class_name SwordAttack

@export var start_pos: Vector2 = Vector2.ZERO
@onready var pivot: Marker2D = $pivot
@onready var animation_player: AnimationPlayer = $animation_player
@onready var weapon_sprite: Sprite2D = $%weapon_sprite
@onready var hitbox: ComponentHitbox = $%hitbox

@export var sword_slash_scene: PackedScene
@export var original_scale: float =  1.0
@export var attack_time: float = 0.2
@export var return_time: float = 0.5

var can_attack: bool = true
var current_look_dir: String = "left"

const ATTACK_1_ANIM = "slash_1"
const ATTACK_2_ANIM = "slash_2"
const ATTACK_3_ANIM = "slash_3"
const RETURN_ANIM = "sword_return"


func _ready() -> void:
	position = start_pos
	animation_player.animation_finished.connect(_on_animation_finished)
	scale = Vector2(original_scale, original_scale)


func init(weapon_data: Res_WeaponData, weapon_level: int):
	if (weapon_data == null): return
	if (weapon_level == 0): weapon_level = 1
	var search_string: String = weapon_data.name.to_lower() + "_0" + str(weapon_level)
	var result_icon: Texture2D = weapon_data.search_icon(search_string)
	if (result_icon != null): weapon_sprite.texture = result_icon
	var final_damage = weapon_data.get_scaled_damage(weapon_level)
	set_weapon_damage(final_damage)


func set_weapon_damage(val: float):
	super.set_weapon_damage(val)
	print("weapon damage: ", val)
	hitbox.set_damage(val)


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
		animation_player.get_animation(ATTACK_1_ANIM).length /  attack_time
		animation_player.play(ATTACK_1_ANIM)
		can_attack = false


func spawn_slash() -> void:
	return
	if (sword_slash_scene == null): return
	var sword_slash = sword_slash_scene.instantiate() as SwordSlash

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(sword_slash)
	sword_slash.animation_player.speed_scale =\
	sword_slash.animation_player.get_animation(ATTACK_1_ANIM).length /  attack_time
	
	if (get_global_mouse_position().x > global_position.x):
		sword_slash.slash_sprite.flip_v = false
	else:
		sword_slash.slash_sprite.flip_v = true
		
	sword_slash.global_position = global_position
	sword_slash.look_at(get_global_mouse_position())
	sword_slash.set_damage(weapon_damage)
	sword_slash.play_slash_anim()


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == ATTACK_1_ANIM):
		animation_player.speed_scale =\
		animation_player.get_animation(RETURN_ANIM).length /  return_time
		animation_player.play(RETURN_ANIM)
	else:
		can_attack = true
