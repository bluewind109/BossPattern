extends EnemyBase
class_name Enemy_Cube_Base

enum SPEED_STATE {idle, normal, attack, recover, die}

@onready var animation_player: AnimationPlayer = $animation_player
@export var body_sprite: Sprite2D
@export var face_decor_sprite: Sprite2D
@export var dissolve_shader: Material

@export var normal_decor_texture: Texture2D
@export var die_decor_texture: Texture2D


func _ready() -> void:
	name = "enemy_Cube_Base"
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_cube_base_lib")
	bind_signals()
	add_states()
	# super.init_component_look(anim_ss)
	body_sprite.material = dissolve_shader
	body_sprite.material.resource_local_to_scene = true
	body_sprite.material.set_shader_parameter("progress", 0.0)

	face_decor_sprite.texture = normal_decor_texture


func init_states():
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"Attack": "Attack",
		"Recover": "Recover",
		"Die": "Die",
	}


func init_speed_dict():
	speed_dict = {
		SPEED_STATE.idle: 25.0,
		SPEED_STATE.normal: 25.0,
		SPEED_STATE.attack: 25.0,
		SPEED_STATE.recover: 25.0,
		SPEED_STATE.die: 25.0,
	}


func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name + "/"
	# anim_ss.init_anim_data(
	# 	{		
	# 		"idle": {
	# 			"anim_id": lib_name + "wake",
	# 		},
	# 		"walk": {
	# 			"anim_id": lib_name + "walk",
	# 		},
	# 	}
	# )


func add_states():
	state_machine.add_states(STATE.Normal, CallableState.new(
		_on_normal_state,
		_on_enter_normal_state,
		_on_leave_normal_state
	))

	state_machine.add_states(STATE.Attack, CallableState.new(
		_on_attack_state,
		_on_enter_attack_state,
		_on_leave_attack_state
	))

	state_machine.add_states(STATE.Recover, CallableState.new(
		_on_recover_state,
		_on_enter_recover_state,
		_on_leave_recover_state
	))

	state_machine.add_states(STATE.Die, CallableState.new(
		_on_die_state,
		_on_enter_die_state,
		_on_leave_die_state
	))

	state_machine.set_initial_state(STATE.Normal)


func _physics_process(delta: float) -> void:
	state_machine.update(delta)


# NORMAL STATE
func _on_enter_normal_state():
	animation_player.play("RESET")
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])
	component_velocity.set_direction(global_position.direction_to(player_ref.global_position))

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO and not component_velocity.direction):
		animation_player.play("RESET")
	else:
		animation_player.play("walk")

	var target_pos: Vector2 = player_ref.global_position
	velocity = component_steer.steer(
		velocity,
		global_position,
		target_pos,
		component_velocity.max_speed,
		mass
	)

	if (attack_manager.is_in_attack_range(player_ref.global_position)):
		component_velocity.set_direction(Vector2.ZERO)
	else:
		component_velocity.set_direction(global_position.direction_to(player_ref.global_position))

	super.look_at_player()
	# if (!attack_manager.can_attack()): return

	# if (melee_attack.is_in_cast_range(player_ref.global_position) and melee_attack.can_cast()):
	# 	attack_manager.set_next_skill(melee_attack)
	# 	set_state(STATE.WindUp)
	# 	return


func _on_leave_normal_state():
	return


# ATTACK STATE
func _on_enter_attack_state():
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.attack])
	# melee_attack.cast_at(player_ref)

func _on_attack_state(_delta: float):
	super.look_at_player()

func _on_leave_attack_state():
	pass


# RECOVER STATE
func _on_enter_recover_state():
	animation_player.play("RESET")
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.recover])
	component_velocity.set_direction(Vector2.ZERO)

func _on_recover_state(_delta: float):
	super.look_at_player()

func _on_leave_recover_state():
	pass


# DIE STATE
func _on_enter_die_state():
	_disable_collision()
	face_decor_sprite.texture = die_decor_texture
	animation_player.play("RESET")
	# anim_ss.play_anim("die", false)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.die])
	component_velocity.set_direction(Vector2.ZERO)
	_play_dissolve_effect()

func _on_die_state(_delta: float):
	pass

func _on_leave_die_state():
	pass


func _play_dissolve_effect():
	body_sprite.material.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(body_sprite.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_callback(queue_free)	

func _on_attack_finished():
	set_state(STATE.Recover)
	

func _on_recover_finished():
	set_state(STATE.Normal)
	attack_manager.start_cooldown()


func _on_die():
	if (is_dead): return
	set_state(STATE.Die)
	super._on_die()

# func _on_animation_finished(_anim_name: StringName):
	# if (_anim_name == anim_ss.get_anim_id("attack")):
	# 	set_state(STATE.Recover)
	# elif (_anim_name == anim_ss.get_anim_id("die")):
	# 	super._on_die()
