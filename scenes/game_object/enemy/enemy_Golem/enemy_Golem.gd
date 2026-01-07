extends EnemyBase
class_name EnemyGolem

enum SPEED_STATE {idle, normal, wind_up, attack, recover, die}
enum ANIM_STATE{RESET = 0, idle, walk, attack, die}
enum STATE {Normal, WindUp, Attack, Recover, Die}


@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var pulse_effect: PulseEffect = $pulse_effect

@onready var skill_shockwave: ComponentShockwave = $attack_manager/shockwave


func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_golem_anim_lib")
	bind_signals()
	add_states()
	super.init_component_look(anim_ss)

	# test die state
	# var die_timer = Timer.new()
	# die_timer.one_shot = true
	# die_timer.timeout.connect(_on_die)
	# get_tree().current_scene.add_child.call_deferred(die_timer)
	# die_timer.start.call_deferred(10.0)


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
		ANIM_STATE.idle: AnimationInfo.new(lib_name + "golem_idle", true),
		ANIM_STATE.walk: AnimationInfo.new(lib_name + "golem_walk", true),
		ANIM_STATE.attack: AnimationInfo.new(lib_name + "golem_attack", false),
		ANIM_STATE.die: AnimationInfo.new(lib_name + "golem_die", false),
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


func _on_enter_normal_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])


func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO):
		anim_ss.play_anim(ANIM_STATE.idle)
	else:
		anim_ss.play_anim(ANIM_STATE.walk)

	component_velocity.accelerate_to_player()
	component_velocity.move(self)

	if (attack_manager.is_in_attack_range(player_ref.global_position)):
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.idle])
		component_velocity.stop(self)
	else:
		# follow the player
		component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])

	super.look_at_player()
	if (!attack_manager.can_attack()): return

	if (skill_shockwave.is_in_attack_range(player_ref.global_position) and
		skill_shockwave.can_cast()):
		attack_manager.set_next_skill(skill_shockwave)
		set_state(STATE.WindUp)


func _on_leave_normal_state():
	return


func _on_enter_wind_up_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	attack_manager.start_delay(attack_manager.get_wind_up_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.wind_up])
	pulse_effect.start_pulse(anim_ss)


func _on_wind_up_state(_delta: float):
	super.look_at_player()


func _on_leave_wind_up_state():
	pulse_effect.stop_pulse()


func _on_enter_attack_state():
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.attack])
	skill_shockwave.cast_at(player_ref)
	anim_ss.play_anim(ANIM_STATE.attack, false)


func _on_attack_state(_delta: float):
	super.look_at_player()


func _on_leave_attack_state():
	pass


func _on_enter_recover_state():
	anim_ss.play_anim(ANIM_STATE.idle)
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.recover])


func _on_recover_state(_delta: float):
	super.look_at_player()


func _on_leave_recover_state():
	pass


func _on_enter_die_state():
	_disable_collision()
	anim_ss.play_anim(ANIM_STATE.die, false)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.die])


func _on_die_state(_delta: float):
	pass


func _on_leave_die_state():
	pass


func _on_wind_up_finished():
	match attack_manager.next_skill.skill_type:
		EnemySkill.SKILL_TYPE.shockwave:
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
	if (_anim_name == anim_dict[ANIM_STATE.attack]["name"]):
		set_state(STATE.Recover)
	elif (_anim_name == anim_dict[ANIM_STATE.die]["name"]):
		queue_free()
