extends EnemyBase
class_name EnemyBat

@onready var anim_ss: ComponentAnimSpriteSheet = $anim_spritesheet
@onready var charge: ComponentCharge = $charge

@onready var wind_up_timer: Timer = $wind_up_timer
var wind_up_duration: float = 1.0

func _ready() -> void:
	super._ready()
	STATE = {
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Charge": "Charge",
	}

	speed_dict = {
		STATE.Normal: 75.0,
		STATE.WindUp: 150.0,
		STATE.Charge: 350.0,
	}

	var lib_name = "enemy_bat_anim_lib"
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

	charge.on_charge_finished.connect(_on_charge_finished)
	if (component_look): component_look.owner_node = anim_ss

	wind_up_timer.one_shot = true
	wind_up_timer.timeout.connect(_on_wind_up_timer_time_out)

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

	state_machine.set_initial_state(STATE.Normal)

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _on_enter_normal_state():
	anim_ss.play_anim("idle")
	component_velocity.max_speed = speed_dict.Normal
	
func _on_normal_state(_delta: float):
	# follow the player
	var target_pos: Vector2 = player_ref.global_position
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

	if (charge.is_in_charge_range(player_ref.global_position) and charge.can_charge):
		state_machine.change_state(STATE.WindUp)

func _on_leave_normal_state():
	pass

func _on_enter_wind_up_state():
	anim_ss.play_anim("idle")
	wind_up_timer.start(wind_up_duration)
	component_velocity.max_speed = speed_dict.WindUp
	component_velocity.direction = Vector2.ZERO

func _on_wind_up_state(_delta: float):
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func _on_leave_wind_up_state():
	pass

func _on_enter_charge_state():
	anim_ss.play_anim("chase")
	component_velocity.max_speed = speed_dict.Charge
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	charge.charge(player_ref.global_position)

func _on_charge_state(_delta: float):
	velocity = charge.update(component_velocity.max_speed)

func _on_leave_charge_state():
	pass

func _on_wind_up_timer_time_out():
	state_machine.change_state(STATE.Charge)

func _on_charge_finished():
	state_machine.change_state(STATE.Normal)
