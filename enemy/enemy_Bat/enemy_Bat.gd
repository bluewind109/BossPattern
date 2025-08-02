extends EnemyBase
class_name EnemyBat

var idle_texture: Texture2D = preload("./sprites/Bat-IdleFly.png")
var chase_texture: Texture2D = preload("./sprites/Bat-Run.png")

@export var component_anim_ss: ComponentAnimSpriteSheet
@export var component_charge: ComponentCharge

@export var wind_up_timer: Timer
var wind_up_duration: float = 1.0

var speed_dict: Dictionary[String, float] = {}

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
	component_anim_ss.init_anim_data(
		{		
			"idle": {
				"anim_id": lib_name + "/" + "fly_idle",
				"texture": idle_texture,
				"hframes": 9
			},
			"chase": {
				"anim_id": lib_name + "/" + "fly_chase",
				"texture": chase_texture,
				"hframes": 8
			},
		}
	)

	component_charge.is_charge_done.connect(on_charge_done)

	wind_up_timer.one_shot = true
	wind_up_timer.timeout.connect(on_wind_up_timer_time_out)

	state_machine.add_states(STATE.Normal, CallableState.new(
		on_normal_state,
		on_enter_normal_state,
		on_leave_normal_state
	))

	state_machine.add_states(STATE.WindUp, CallableState.new(
		on_wind_up_state,
		on_enter_wind_up_state,
		on_leave_wind_up_state
	))

	state_machine.add_states(STATE.Charge, CallableState.new(
		on_charge_state,
		on_enter_charge_state,
		on_leave_charge_state
	))

	state_machine.set_initial_state(STATE.Normal)

func _physics_process(_delta: float) -> void:
	state_machine.update()

func on_enter_normal_state():
	component_anim_ss.play_anim("idle")
	component_velocity.max_speed = speed_dict.Normal
	
func on_normal_state():
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

	if (component_charge.is_in_charge_range(player_ref.global_position) and component_charge.can_charge):
		state_machine.change_state(STATE.WindUp)

func on_leave_normal_state():
	pass

func on_enter_wind_up_state():
	component_anim_ss.play_anim("idle")
	wind_up_timer.start(wind_up_duration)
	component_velocity.max_speed = speed_dict.WindUp
	component_velocity.direction = Vector2.ZERO

func on_wind_up_state():
	var target_pos: Vector2 = player_ref.global_position
	component_look.look(target_pos)

func on_leave_wind_up_state():
	pass

func on_enter_charge_state():
	component_anim_ss.play_anim("chase")
	component_velocity.max_speed = speed_dict.Charge
	component_velocity.direction = global_position.direction_to(player_ref.global_position)
	component_charge.charge(player_ref.global_position)

func on_charge_state():
	velocity = component_charge.update(component_velocity.max_speed)

func on_leave_charge_state():
	pass

func on_wind_up_timer_time_out():
	state_machine.change_state(STATE.Charge)

func on_charge_done():
	state_machine.change_state(STATE.Normal)
