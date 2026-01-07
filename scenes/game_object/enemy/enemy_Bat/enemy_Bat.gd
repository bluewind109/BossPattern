extends EnemyBase
class_name Enemy_Bat

enum SPEED_STATE {idle, normal, wind_up, attack, recover, die}
enum ANIM_STATE{RESET = 0, idle, walk, attack, die}
enum STATE {Normal, WindUp, Attack, Recover, Die}

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var pulse_effect: PulseEffect = $pulse_effect

@onready var skill_charge: EnemySkill_Charge = $attack_manager/charge


func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_bat_anim_lib")
	bind_signals()
	add_states()
	super.init_component_look(anim_ss)


func init_speed_dict():
	speed_dict = {
		SPEED_STATE.idle: 0.0,
		SPEED_STATE.normal: 40.0,
		SPEED_STATE.wind_up: 0.0,
		SPEED_STATE.attack: 350.0,
		SPEED_STATE.recover: 0.0,
		SPEED_STATE.die: 0.0,
	}


func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name + "/"
	anim_dict = {
		ANIM_STATE.RESET: AnimationInfo.new(lib_name + "RESET", true),
		ANIM_STATE.idle: AnimationInfo.new(lib_name + "fly_idle", true),
		ANIM_STATE.walk: AnimationInfo.new(lib_name + "fly_chase", true),
		ANIM_STATE.attack: AnimationInfo.new(lib_name + "fly_chase", false),
	}
	anim_ss.init_anim_data(anim_dict)


func bind_signals():
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
		_on_charge_state,
		_on_enter_charge_state,
		_on_leave_charge_state
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


func _on_enter_normal_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])
	

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO):
		anim_ss.play_anim(ANIM_STATE.idle)
	else:
		# TODO add anim for following player
		anim_ss.play_anim(ANIM_STATE.walk)

	if (attack_manager.is_in_attack_range(player_ref.global_position)):
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.idle])
		component_velocity.stop(self)
	else:
		# follow the player
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])

	super.look_at_player()

	if (!attack_manager.can_attack()): return
	# attack_manager.attack()

	if (skill_charge.is_in_charge_range(player_ref.global_position) and skill_charge.can_cast()):
		attack_manager.set_next_skill(skill_charge)
		set_state(STATE.WindUp)
		return


func _on_leave_normal_state():
	pass


func _on_enter_wind_up_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	attack_manager.start_delay(attack_manager.get_wind_up_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.wind_up])
	pulse_effect.start_pulse(anim_ss)


func _on_wind_up_state(_delta: float):
	super.look_at_player()


func _on_leave_wind_up_state():
	pulse_effect.stop_pulse()


func _on_enter_charge_state():
	anim_ss.play_anim(ANIM_STATE.attack)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.attack])
	skill_charge.cast_at(player_ref)


func _on_charge_state(_delta: float):
	velocity = skill_charge.update(component_velocity.max_speed)


func _on_leave_charge_state():
	pass


# RECOVER STATE
func _on_enter_recover_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.recover])


func _on_recover_state(_delta: float):
	super.look_at_player()


func _on_leave_recover_state():
	pass


# DIE STATE
func _on_enter_die_state():
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.die])
	_disable_collision()
	# TODO add die animation for BAT
	queue_free()


func _on_die_state(_delta: float):
	pass


func _on_leave_die_state():
	pass


func _on_wind_up_finished():
	# print("[EnemyBat] _on_wind_up_finished", typeof(attack_manager.next_skill))
	match attack_manager.next_skill.skill_type:
		EnemySkill.SKILL_TYPE.charge:
			set_state(STATE.Attack)
		_:
			pass


func _on_attack_finished():
	set_state(STATE.Recover)


func _on_recover_finished():
	set_state(STATE.Normal)
	attack_manager.start_cooldown()
	# _on_die()


func _on_die():
	if (is_dead): return
	set_state(STATE.Die)
	super._on_die()


func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == anim_dict[ANIM_STATE.die]["name"]):
		queue_free()
