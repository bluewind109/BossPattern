extends Weapon
class_name BowAttack

@export var arrow_scene: PackedScene
@export var start_pos: Vector2 = Vector2.ZERO
@export var arrow_spawn: Node2D

@onready var pivot: Marker2D = $pivot
@onready var animation_player: AnimationPlayer = $animation_player

@export var original_scale: float =  1.0
@export var attack_time: float = 1.0
@export var return_time: float = 1.0
@export var arrow_speed: float = 300.0

var arrow_sprite: Texture2D
var can_attack: bool = true
var current_look_dir: String = "left"

@export var bow_idle_sprite: Texture2D
var bow_attack_sprites: Array[Texture2D] = []

const ATTACK_ANIM = "attack"
const RETURN_ANIM = "return"


func _ready() -> void:
	position = start_pos
	animation_player.animation_finished.connect(_on_animation_finished)
	scale = Vector2(original_scale, original_scale)


func init(weapon_data: Res_WeaponData, weapon_level: int):
	super.init(weapon_data, weapon_level)
	weapon_sprite.texture = bow_idle_sprite

	var arrow_search_string: String = "arrow"+ "_0" + str(weapon_level)
	arrow_sprite = weapon_data.search_icon(arrow_search_string)

	var weapon_search_string: String = weapon_data.name.to_lower() + "_0" + str(weapon_level)
	for i in 3:
		var bow_attack_search_string: String = weapon_search_string + "_attack_0" + str(i + 1)
		print("bow_attack_search_string: ", bow_attack_search_string)
		var result_icon: Texture2D = weapon_data.search_icon(bow_attack_search_string)
		if (result_icon != null): bow_attack_sprites.append(result_icon)


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
		animation_player.speed_scale = attack_time
		# animation_player.get_animation(ATTACK_ANIM).length /  attack_time
		animation_player.play(ATTACK_ANIM)
		can_attack = false
		start_attack()


func update_bow_texture(val: int):
	print("update_bow_texture: ", val)
	if (val == -1): 
		weapon_sprite.texture = bow_idle_sprite
		return
	weapon_sprite.texture = bow_attack_sprites[val]


func spawn_arrow() -> void:
	if (arrow_scene == null): return
	var arrow = arrow_scene.instantiate() as Arrow
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if (entities_layer == null): return
	entities_layer.add_child(arrow)
	if (arrow_sprite != null):
		arrow.sprite.texture = arrow_sprite

	if (arrow_spawn == null): 
		arrow.global_position = global_position
	else:
		arrow.global_position = arrow_spawn.global_position
	
	if (get_global_mouse_position().x > global_position.x):
		arrow.pivot.scale = Vector2(1, 1)
		arrow.rotation = pivot.rotation
	else:
		arrow.pivot.scale = Vector2(-1, -1)
		arrow.rotation = pivot.rotation * -1

	var _direction = (get_global_mouse_position() - global_position).normalized()
	arrow.init(_direction, weapon_damage, arrow_speed)


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == ATTACK_ANIM):
		animation_player.speed_scale = return_time
		# animation_player.get_animation(RETURN_ANIM).length /  return_time
		animation_player.play(RETURN_ANIM)
		stop_attack()
	else:
		can_attack = true
