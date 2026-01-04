extends EnemyBase
class_name Enemy_Cube_Base

enum SPEED_STATE {idle, normal, wind_up, attack, recover, die}
enum ANIM_STATE{RESET = 0, idle, walk, attack, die}

var anim_dict: Dictionary[int, AnimationInfo] = {}

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var skill_head_slam: EnemySkill_HeadSlam = $attack_manager/enemy_skill_HeadSlam

@export var body_sprite: Sprite2D
@export var dissolve_shader: Material


func _ready() -> void:
	name = "enemy_Cube_Base"
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_cube_base_lib")
	bind_signals()
	add_states()


func init_states():
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Attack": "Attack",
		"Recover": "Recover",
		"Die": "Die",
	}


func init_speed_dict():
	speed_dict = {
		SPEED_STATE.idle: 0.0,
		SPEED_STATE.normal: 25.0,
		SPEED_STATE.wind_up: 0.0,
		SPEED_STATE.attack: 0.0,
		SPEED_STATE.recover: 0.0,
		SPEED_STATE.die: 0.0,
	}


func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name + "/"
	anim_dict = {
		ANIM_STATE.RESET: AnimationInfo.new(lib_name + "RESET", true),
		ANIM_STATE.walk: AnimationInfo.new(lib_name + "walk", true),
		ANIM_STATE.attack: AnimationInfo.new(lib_name + "attack_headslam", false),
		ANIM_STATE.die: AnimationInfo.new(lib_name + "die", false),
	}
	anim_ss.init_anim_data(anim_dict)


func bind_signals():
	anim_ss.anim_player.animation_finished.connect(_on_animation_finished)
	attack_manager.on_attack_finished.connect(_on_attack_finished)
	attack_manager.delay_timer.timeout.connect(_on_wind_up_finished)
	attack_manager.recover_timer.timeout.connect(_on_recover_finished)


func add_states():
	state_machine.add_states(STATE.Normal, CallableState.new(
		_on_normal_state,
		_on_enter_normal_state,
		_on_leave_normal_state
	))

	state_machine.add_states(STATE.WindUp, CallableState.new(
		_on_wind_up_state,
		_on_enter_wind_up_state,
		_on_leave_wind_up_state
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
	anim_ss.play_anim(ANIM_STATE.RESET)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO):
		anim_ss.play_anim(ANIM_STATE.RESET)
	else:
		anim_ss.play_anim(ANIM_STATE.walk)

	component_velocity.accelerate_to_player()
	component_velocity.move(self)

	var player = get_tree().get_first_node_in_group("Player")
	var is_in_attack_range = attack_manager.is_in_attack_range(player.global_position)
	if (is_in_attack_range):
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.idle])
		component_velocity.stop(self)
	else:
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])

	super.look_at_player()
	var can_attack = attack_manager.can_attack()
	if (!can_attack): return

	var is_in_cast_range = skill_head_slam.is_in_cast_range(player.global_position)
	var can_cast = skill_head_slam.can_cast()
	if (is_in_cast_range and can_cast):
		attack_manager.set_next_skill(skill_head_slam)
		set_state(STATE.WindUp)
		return


func _on_leave_normal_state():
	return


# WIND UP STATE
func _on_enter_wind_up_state():
	anim_ss.play_anim(ANIM_STATE.RESET)
	attack_manager.start_delay(attack_manager.get_wind_up_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.wind_up])
	# pulse_effect.start_pulse(anim_ss)

func _on_wind_up_state(_delta: float):
	super.look_at_player()

func _on_leave_wind_up_state():
	# pulse_effect.stop_pulse()
	pass


# ATTACK STATE
func _on_enter_attack_state():
	anim_ss.play_anim(ANIM_STATE.attack, false)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.attack])
	skill_head_slam.cast()

func _on_attack_state(_delta: float):
	super.look_at_player()

func _on_leave_attack_state():
	pass


# RECOVER STATE
func _on_enter_recover_state():
	anim_ss.play_anim(ANIM_STATE.RESET)
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.recover])

func _on_recover_state(_delta: float):
	super.look_at_player()

func _on_leave_recover_state():
	pass


# DIE STATE
func _on_enter_die_state():
	_disable_collision()
	anim_ss.play_anim(ANIM_STATE.die, false)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.die])

func _on_die_state(_delta: float):
	pass

func _on_leave_die_state():
	pass


func _play_dissolve_effect():
	if (body_sprite == null): return
	body_sprite.material = dissolve_shader
	body_sprite.material.resource_local_to_scene = true
	body_sprite.material.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(body_sprite.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_callback(queue_free)	


func _on_wind_up_finished():
	match attack_manager.next_skill.skill_type:
		EnemySkill.SKILL_TYPE.headslam:
			set_state(STATE.Attack)
		_:
			pass


func _on_attack_finished():
	# set_state(STATE.Recover)
	return
	

func _on_recover_finished():
	set_state(STATE.Normal)
	attack_manager.start_cooldown()


func _on_die():
	if (is_dead): return
	set_state(STATE.Die)
	super._on_die()


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == anim_dict[ANIM_STATE.attack]["name"]):
		set_state(STATE.Recover)
	elif (_anim_name == anim_dict[ANIM_STATE.die]["name"]):
		_play_dissolve_effect()
