extends EnemyBase
class_name EnemySwampAbomination

@export var component_anim_ss: ComponentAnimSpriteSheet
@export var component_charge: ComponentCharge

@export var wind_up_timer: Timer
var wind_up_duration: float = 1.0

@export var recover_timer: Timer
var recover_duration: float = 3.0

func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_swamp_animation_lib")
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
		STATE.Idle: 150.0,
		STATE.Normal: 75.0,
		STATE.WindUp: 150.0,
		STATE.Attack: 150.0,
		STATE.Recover: 150.0,
		STATE.Die: 150.0,
	}

func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name
	component_anim_ss.init_anim_data(
		{		
			"idle": {
				"anim_id": lib_name + "/" + "idle",
			},
			"walk": {
				"anim_id": lib_name + "/" + "walk",
			},
			"attack1": {
				"anim_id": lib_name + "/" + "attack1",
			},
			"attack2": {
				"anim_id": lib_name + "/" + "attack2",
			},
			"attack3": {
				"anim_id": lib_name + "/" + "attack3",
			},
			"attack4": {
				"anim_id": lib_name + "/" + "attack4",
			},
			"special": {
				"anim_id": lib_name + "/" + "special",
			},
			"die": {
				"anim_id": lib_name + "/" + "death",
			},
		}
	)

func bind_signals():
	wind_up_timer.one_shot = true
	wind_up_timer.timeout.connect(_on_wind_up_timer_time_out)

	recover_timer.one_shot = true
	recover_timer.timeout.connect(_on_recover_timer_time_out)

	component_anim_ss.anim_player.animation_finished.connect(_on_animation_finished)

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
	component_anim_ss.play_anim("idle")
	component_velocity.max_speed = speed_dict.Normal

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO and not component_velocity.direction):
		component_anim_ss.play_anim("idle")
	else:
		component_anim_ss.play_anim("walk")

func _on_leave_normal_state():
	pass

func _on_enter_wind_up_state():
	component_anim_ss.play_anim("special")
	wind_up_timer.start(wind_up_duration)
	component_velocity.max_speed = speed_dict.WindUp
	component_velocity.direction = Vector2.ZERO

func _on_wind_up_state(_delta: float):
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func _on_leave_wind_up_state():
	return

func _on_enter_attack_state():
	# component_velocity.max_speed = speed_dict.Attack
	# component_anim_ss.play_anim("attack1", false)
	pass

func _on_attack_state(_delta: float):
	pass

func _on_leave_attack_state():
	pass

func _on_enter_recover_state():
	component_anim_ss.play_anim("idle")
	recover_timer.start(recover_duration)
	component_velocity.max_speed = speed_dict.Recover
	component_velocity.direction = Vector2.ZERO

func _on_recover_state(_delta: float):
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func _on_leave_recover_state():
	pass

func _on_enter_die_state():
	_disable_collision()
	component_anim_ss.play_anim("die", false)
	component_velocity.max_speed = speed_dict.Die
	component_velocity.direction = Vector2.ZERO

func _on_die_state(_delta: float):
	pass

func _on_leave_die_state():
	pass

func _on_wind_up_timer_time_out():
	state_machine.change_state(STATE.Attack)

func _on_recover_timer_time_out():
	state_machine.change_state(STATE.Normal)

func _on_animation_finished(_anim_name: StringName):
	pass
