extends EnemyBase
class_name EnemyBat

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var charge: Charge = $attack_manager/charge
@onready var pulse_effect: PulseEffect = $pulse_effect

enum SPEED_STATE {idle, normal, attack, wind_up, charge, recover, die}

func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_bat_anim_lib")
	bind_signals()
	add_states()
	super.init_component_look(anim_ss)

func init_states():
	STATE = {
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Charge": "Charge",
		"Recover": "Recover",
	}

func init_speed_dict():
	speed_dict = {
		SPEED_STATE.normal: 75.0,
		SPEED_STATE.wind_up: 150.0,
		SPEED_STATE.charge: 350.0,
		SPEED_STATE.recover: 150.0,
	}

func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name
	anim_ss.init_anim_data(
		{		
			"idle": {
				"anim_id": lib_name + "/" + "fly_idle",
			},
			"chase": {
				"anim_id": lib_name + "/" + "fly_chase",
			},
		}
	)

func bind_signals():
	attack_manager.delay_cb = _on_wind_up_finished
	attack_manager.on_attack_finished.connect(_on_attack_finished)
	attack_manager.recover_cb = _on_recover_finished

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

	state_machine.add_states(STATE.Charge, CallableState.new(
		_on_charge_state,
		_on_enter_charge_state,
		_on_leave_charge_state
	))

	state_machine.add_states(STATE.Recover, CallableState.new(
		_on_recover_state,
		_on_enter_recover_state,
		_on_leave_recover_state
	))

	state_machine.set_initial_state(STATE.Normal)

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _on_enter_normal_state():
	anim_ss.play_anim("idle")
	component_velocity.max_speed = speed_dict[SPEED_STATE.normal]
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	
func _on_normal_state(_delta: float):
	# follow the player
	var target_pos: Vector2 = player_ref.global_position
	velocity = component_steer.steer(
		velocity,
		global_position,
		target_pos,
		component_velocity.max_speed,
		mass
	)

	if (attack_manager.is_in_attack_range(player_ref.global_position)):
		component_velocity.direction = Vector2.ZERO
	else:
		component_velocity.direction = global_position.direction_to(player_ref.global_position)

	super.look_at_player()

	if (!attack_manager.can_attack()): return
	# attack_manager.attack()

	if (charge.is_in_charge_range(player_ref.global_position) and charge.can_cast()):
		attack_manager.set_next_skill(charge)
		state_machine.change_state(STATE.WindUp)
		return

func _on_leave_normal_state():
	pass

func _on_enter_wind_up_state():
	anim_ss.play_anim("idle")
	attack_manager.start_delay(attack_manager.get_wind_up_duration())
	component_velocity.max_speed = speed_dict[SPEED_STATE.wind_up]
	component_velocity.direction = Vector2.ZERO
	pulse_effect.start_pulse(anim_ss)

func _on_wind_up_state(_delta: float):
	super.look_at_player()

func _on_leave_wind_up_state():
	pulse_effect.stop_pulse()

func _on_enter_charge_state():
	anim_ss.play_anim("chase")
	component_velocity.max_speed = speed_dict[SPEED_STATE.charge]
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	charge.cast_at(player_ref)

func _on_charge_state(_delta: float):
	velocity = charge.update(component_velocity.max_speed)

func _on_leave_charge_state():
	pass

# RECOVER STATE
func _on_enter_recover_state():
	anim_ss.play_anim("idle")
	attack_manager.start_recover(attack_manager.get_recover_duration())
	component_velocity.max_speed = speed_dict[SPEED_STATE.recover]
	component_velocity.direction = Vector2.ZERO

func _on_recover_state(_delta: float):
	super.look_at_player()

func _on_leave_recover_state():
	pass

func _on_wind_up_finished():
	print("[EnemyBat] _on_wind_up_finished", typeof(attack_manager.next_skill))
	match attack_manager.next_skill.skill_type:
		EnemySkill.SKILL_TYPE.charge:
			state_machine.change_state(STATE.Charge)
		_:
			pass

func _on_attack_finished():
	state_machine.change_state(STATE.Recover)

func _on_recover_finished():
	state_machine.change_state(STATE.Normal)
