extends EnemyBase
class_name EnemyMage

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var poison_explosion_skill: PoisonExplosionAttack = $attack_manager/poison_explosion_attack
@onready var pulse_effect: PulseEffect = $pulse_effect

enum RANGE {lightning_strike}
var range_dict: Dictionary[int, Vector2] = {
	RANGE.lightning_strike: Vector2(300, 350),
}

enum SPEED_STATE{idle, normal, wind_up, poison_explosion_attack, recover, die}

func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_mage_lib")
	bind_signals()
	add_states()
	super.init_component_look(anim_ss)

func init_states():
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"WindUp": "WindUp",
		"PoisonExplosionAttack": "PoisonExplosionAttack",
		"Recover": "Recover",
		"Die": "Die",
	}

func init_speed_dict():	
	speed_dict = {
		SPEED_STATE.idle: 75.0,
		SPEED_STATE.normal: 75.0,
		SPEED_STATE.wind_up: 75.0,
		SPEED_STATE.poison_explosion_attack: 75.0,
		SPEED_STATE.recover: 75.0,
		SPEED_STATE.die: 75.0,
	}

func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name
	anim_ss.init_anim_data(
		{
			"idle": {
				"anim_id": lib_name + "/" + "idle",
			},
			"move": {
				"anim_id": lib_name + "/" + "move",
			},
			"summon": {
				"anim_id": lib_name + "/" + "summon",
			},
			"die": {
				"anim_id": lib_name + "/" + "die",
			},
		}
	)

func bind_signals():
	attack_manager.on_attack_finished.connect(_on_attack_finished)
	attack_manager.delay_cb = _on_wind_up_finished
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

	state_machine.add_states(STATE.PoisonExplosionAttack, CallableState.new(
		_on_pea_state,
		_on_enter_pea_state,
		_on_leave_pea_state
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
	anim_ss.play_anim("idle")
	component_velocity.max_speed = speed_dict[SPEED_STATE.normal]
	component_velocity.direction = global_position.direction_to(player_ref.global_position)

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO and not component_velocity.direction):
		anim_ss.play_anim("idle")
	else:
		anim_ss.play_anim("move")

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

	if (
		poison_explosion_skill.is_in_cast_range(player_ref.global_position) and 
		poison_explosion_skill.can_cast()
	):
		attack_manager.set_next_skill(poison_explosion_skill)
		state_machine.change_state(STATE.WindUp)
		return

func _on_leave_normal_state():
	pass

# WIND UP STATE
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

# POISON EXPLOSION ATTACK STATE
func _on_enter_pea_state():
	anim_ss.play_anim("summon", false)
	component_velocity.max_speed = speed_dict[SPEED_STATE.poison_explosion_attack]
	component_velocity.direction = Vector2.ZERO
	poison_explosion_skill.cast_at(player_ref)

func _on_pea_state(_delta: float):
	super.look_at_player()

func _on_leave_pea_state():
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

# DIE STATE
func _on_enter_die_state():
	_disable_collision()
	anim_ss.play_anim("die", false)
	component_velocity.max_speed = speed_dict[SPEED_STATE.die]
	component_velocity.direction = Vector2.ZERO

func _on_die_state(_delta: float):
	pass

func _on_leave_die_state():
	pass

#FUNCTIONS
func _on_wind_up_finished():
	match attack_manager.next_skill.skill_type:
		EnemySkill.SKILL_TYPE.poison_explosion_attack:
			state_machine.change_state(STATE.PoisonExplosionAttack)
		_:
			pass

func _on_attack_finished():
	state_machine.change_state(STATE.Recover)

func _on_recover_finished():
	state_machine.change_state(STATE.Normal)
	# _on_die()

func _on_die():
	super._on_die()
	state_machine.change_state(STATE.Die)

func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == anim_ss.get_anim_id("die")):
		queue_free()