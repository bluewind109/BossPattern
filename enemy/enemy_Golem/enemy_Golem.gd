extends EnemyBase
class_name EnemyGolem

@export var component_anim_ss: ComponentAnimSpriteSheet
@export var component_shockwave: ComponentShockwave

@export var wind_up_timer: Timer
var wind_up_duration: float = 1.0

@export var recover_timer: Timer
var recover_duration: float = 3.0

func _ready() -> void:
	super._ready()
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Attack": "Attack", # release shockwave on attack
		"Recover": "Recover",
		"Die": "Die",
	}

	speed_dict = {
		STATE.Idle: 150.0,
		STATE.Normal: 75.0,
		STATE.WindUp: 150.0,
		STATE.Attack: 150.0,
		STATE.Recover: 150.0,
		STATE.Die: 150.0,
	}

	var lib_name = "enemy_golem_anim_lib"
	component_anim_ss.init_anim_data(
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

	component_anim_ss.anim_player.animation_finished.connect(_on_animation_finished)

	wind_up_timer.one_shot = true
	wind_up_timer.timeout.connect(_on_wind_up_timer_time_out)

	recover_timer.one_shot = true
	recover_timer.timeout.connect(_on_recover_timer_time_out)

	# test die state
	# var die_timer = Timer.new()
	# die_timer.one_shot = true
	# die_timer.timeout.connect(_on_die)
	# get_tree().current_scene.add_child.call_deferred(die_timer)
	# die_timer.start.call_deferred(10.0)

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

	var target_pos: Vector2 = player_ref.global_position
	if (component_shockwave.is_in_attack_range(player_ref.global_position)):
		component_velocity.direction = Vector2.ZERO
	else:
		# follow the player
		var mass: float = 20.0
		velocity = component_steer.steer(
			velocity,
			global_position,
			target_pos,
			component_velocity.max_speed,
			mass
		)
		component_velocity.direction = global_position.direction_to(player_ref.global_position)

	component_look.look(target_pos)

	if (component_shockwave.is_in_attack_range(player_ref.global_position) and
		component_shockwave.can_attack):
		state_machine.change_state(STATE.WindUp)

func _on_leave_normal_state():
	return

func _on_enter_wind_up_state():
	component_anim_ss.play_anim("idle")
	wind_up_timer.start(wind_up_duration)
	component_velocity.max_speed = speed_dict.WindUp
	component_velocity.direction = Vector2.ZERO

func _on_wind_up_state(_delta: float):
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func _on_leave_wind_up_state():
	return

func _on_enter_attack_state():
	component_velocity.max_speed = speed_dict.Attack
	component_anim_ss.play_anim("attack", false)

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
	if (_anim_name == component_anim_ss.get_anim_id("attack")):
		state_machine.change_state(STATE.Recover)
	elif (_anim_name == component_anim_ss.get_anim_id("die")):
		queue_free()

func _on_release_shockwave():
	component_shockwave.attack(player_ref.global_position)

func _on_die():
	state_machine.change_state(STATE.Die)
