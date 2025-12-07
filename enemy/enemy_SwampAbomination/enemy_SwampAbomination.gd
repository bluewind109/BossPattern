extends EnemyBase
class_name EnemySwampAbomination

@export var mass: float = 20.0

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var charge_handler: ComponentCharge = $charge
@onready var pulse_effect: PulseEffect = $pulse_effect

@onready var wind_up_timer: Timer = $wind_up_timer
var wind_up_duration: float = 2.0

@onready var recover_timer: Timer = $recover_timer
var recover_duration: float = 3.0

@export var debug_circle:= preload("res://debug/debug_circle.tscn")

var range_dict: Dictionary[String, float] = {
	"bite": 50,
	"charge": 250,
	"lightning_strike": 350,
}

func _ready() -> void:
	super._ready()
	init_states()
	init_speed_dict()
	init_anim_dict("enemy_swamp_abomination_lib")
	bind_signals()
	add_states()

	charge_handler.charge_cooldown_duration = 5.0
	if (component_look): component_look.owner_node = anim_ss

func init_states():
	STATE = {
		"Idle": "Idle",
		"Normal": "Normal",
		"Attack": "Attack",
		"WindUp": "WindUp",
		"Charge": "Charge",
		"Recover": "Recover",
		"Die": "Die",
	}

func init_speed_dict():
	speed_dict = {
		STATE.Idle: 150.0,
		STATE.Normal: 75.0,
		STATE.WindUp: 150.0,
		STATE.Attack: 150.0,
		STATE.Charge: 350.0,
		STATE.Recover: 150.0,
		STATE.Die: 150.0,
	}

func init_anim_dict(_lib_name: String):
	var lib_name = _lib_name
	anim_ss.init_anim_data(
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

	anim_ss.anim_player.animation_finished.connect(_on_animation_finished)
	charge_handler.on_charge_finished.connect(_on_charge_finished)

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
	component_velocity.max_speed = speed_dict.Normal

func _on_normal_state(_delta: float):
	if (velocity == Vector2.ZERO and not component_velocity.direction):
		anim_ss.play_anim("idle")
	else:
		anim_ss.play_anim("attack3")

	# follow the player
	var target_pos: Vector2 = player_ref.global_position
	velocity = component_steer.steer(
		velocity,
		global_position,
		target_pos,
		component_velocity.max_speed,
		mass
	)
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	component_look.look(target_pos)

	# do ranged area attack
	if (charge_handler.is_on_cooldown()):
		state_machine.change_state(STATE.Attack)
		return

	# do charge attack
	if (charge_handler.is_in_charge_range(player_ref.global_position) and charge_handler.can_charge):
		state_machine.change_state(STATE.WindUp)
		return

func _on_leave_normal_state():
	pass

# ATTACK STATE
# TODO implement attack state
func _on_enter_attack_state():
	# component_velocity.max_speed = speed_dict.Attack
	# anim_ss.play_anim("attack1", false)
	for i in 6:
		var result_pos = Utils.get_random_position_around(player_ref, 50, 100)
		var circle_instance = debug_circle.instantiate() as Node2D
		circle_instance.global_position = result_pos
		get_tree().current_scene.add_child(circle_instance)

func _on_attack_state(_delta: float):
	component_look.look(player_ref.global_position)
	pass

func _on_leave_attack_state():
	pass

# WIND UP STATE
func _on_enter_wind_up_state():
	anim_ss.play_anim("special")
	wind_up_timer.start(wind_up_duration)
	component_velocity.max_speed = speed_dict.WindUp
	component_velocity.direction = Vector2.ZERO
	pulse_effect.start_pulse(anim_ss)

func _on_wind_up_state(_delta: float):
	component_look.look(player_ref.global_position)

func _on_leave_wind_up_state():
	pulse_effect.stop_pulse()

# CHARGE STATE
func _on_enter_charge_state():
	anim_ss.play_anim("attack4")
	component_velocity.max_speed = speed_dict.Charge
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	charge_handler.charge(player_ref.global_position)

func _on_charge_state(_delta: float):
	velocity = charge_handler.update(component_velocity.max_speed)

func _on_leave_charge_state():
	pass

# RECOVER STATE
func _on_enter_recover_state():
	anim_ss.play_anim("idle")
	recover_timer.start(recover_duration)
	component_velocity.max_speed = speed_dict.Recover
	component_velocity.direction = Vector2.ZERO

func _on_recover_state(_delta: float):
	component_look.look(player_ref.global_position)

func _on_leave_recover_state():
	pass

# DIE STATE
func _on_enter_die_state():
	_disable_collision()
	anim_ss.play_anim("die", false)
	component_velocity.max_speed = speed_dict.Die
	component_velocity.direction = Vector2.ZERO

func _on_die_state(_delta: float):
	pass

func _on_leave_die_state():
	pass

# Functions
func _on_wind_up_timer_time_out():
	state_machine.change_state(STATE.Charge)

func _on_recover_timer_time_out():
	state_machine.change_state(STATE.Normal)

func _on_animation_finished(_anim_name: StringName):
	pass

func _on_charge_finished():
	state_machine.change_state(STATE.Normal)

func _check_possible_attack(_target_pos: Vector2) -> String:
	var distance = _target_pos.distance_to(global_position)
	for n in range_dict:
		if (distance < range_dict[n]):
			return n
	return ""
