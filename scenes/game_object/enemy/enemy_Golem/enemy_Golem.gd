extends EnemyBase
class_name EnemyGolem

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var pulse_effect: PulseEffect = $pulse_effect

@onready var shockwave: ComponentShockwave = $attack_manager/shockwave

enum SPEED_STATE {idle, normal, wind_up, attack, recover, die}

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

func init_states():
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Attack": "Attack", # release shockwave on attack
		"Recover": "Recover",
		"Die": "Die",
	}

func init_speed_dict():
	speed_dict = {
		SPEED_STATE.idle: 75.0,
		SPEED_STATE.normal: 75.0,
		SPEED_STATE.wind_up: 150.0,
		SPEED_STATE.attack: 150.0,
		SPEED_STATE.recover: 150.0,
		SPEED_STATE.die: 150.0,
	}

func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name
	anim_ss.init_anim_data(
		{		
			"idle": {
				"anim_id": lib_name + "/" + "golem_idle",
			},
			"walk": {
				"anim_id": lib_name + "/" + "golem_walk",
			},
			"attack": {
				"anim_id": lib_name + "/" + "golem_attack",
			},
			"die": {
				"anim_id": lib_name + "/" + "golem_die",
			},
		}
	)

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
	anim_ss.play_anim("idle")
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.normal])
	component_velocity.set_direction(global_position.direction_to(player_ref.global_position))

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO and not component_velocity.direction):
		anim_ss.play_anim("idle")
	else:
		anim_ss.play_anim("walk")

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
		# follow the player
		component_velocity.set_direction(global_position.direction_to(player_ref.global_position))

	super.look_at_player()

	if (!attack_manager.can_attack()): return
	# attack_manager.attack()

	if (shockwave.is_in_attack_range(player_ref.global_position) and
		shockwave.can_cast()):
		attack_manager.set_next_skill(shockwave)
		set_state(STATE.WindUp)

func _on_leave_normal_state():
	return

func _on_enter_wind_up_state():
	anim_ss.play_anim("idle")
	attack_manager.start_delay(attack_manager.get_wind_up_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.wind_up])
	component_velocity.set_direction(Vector2.ZERO)
	pulse_effect.start_pulse(anim_ss)

func _on_wind_up_state(_delta: float):
	super.look_at_player()

func _on_leave_wind_up_state():
	pulse_effect.stop_pulse()

func _on_enter_attack_state():
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.attack])
	shockwave.cast_at(player_ref)
	anim_ss.play_anim("attack", false)

func _on_attack_state(_delta: float):
	super.look_at_player()

func _on_leave_attack_state():
	pass

func _on_enter_recover_state():
	anim_ss.play_anim("idle")
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.recover])
	component_velocity.set_direction(Vector2.ZERO)

func _on_recover_state(_delta: float):
	super.look_at_player()

func _on_leave_recover_state():
	pass

func _on_enter_die_state():
	_disable_collision()
	anim_ss.play_anim("die", false)
	component_velocity.set_max_speed(speed_dict[SPEED_STATE.die])
	component_velocity.set_direction(Vector2.ZERO)

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
	set_state(STATE.Die)
	super._on_die()

func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == anim_ss.get_anim_id("attack")):
		set_state(STATE.Recover)
	elif (_anim_name == anim_ss.get_anim_id("die")):
		queue_free()
