extends EnemyBase
class_name EnemyGolem

@export var sprite: Sprite2D
var idle_texture: Texture2D = preload("./sprites/Golem_1_idle.png")
var walk_texture: Texture2D = preload("./sprites/Golem_1_walk.png")
var attack_texture: Texture2D = preload("./sprites/Golem_1_attack.png")
var die_texture: Texture2D = preload("./sprites/Golem_1_die.png")

@export var anim_player: AnimationPlayer
var anim_dict: Dictionary [String, Variant] = {}
var current_anim: String = ""

@export var wind_up_timer: Timer
var wind_up_duration: float = 1.0

func _ready() -> void:
	super._ready()
	STATE = {
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Attack": "Attack",
	}

	init_anim_data()

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

	state_machine.add_states(STATE.Attack, CallableState.new(
		on_attack_state,
		on_enter_attack_state,
		on_leave_attack_state
	))
	
	state_machine.set_initial_state(STATE.Normal)


func init_anim_data():
	anim_dict = {
		"idle": {
			"anim_id": "golem_idle",
			"texture": idle_texture,
			"hframes": 8
		},
		"walk": {
			"anim_id": "golem_walk",
			"texture": walk_texture,
			"hframes": 10
		},
		"attack": {
			"anim_id": "golem_attack",
			"texture": attack_texture,
			"hframes": 11
		},
		"die": {
			"anim_id": "golem_die",
			"texture": die_texture,
			"hframes": 13
		},
	}

func _physics_process(_delta: float) -> void:
	state_machine.update()

func on_enter_normal_state():
	pass

func on_normal_state():
	pass

func on_leave_normal_state():
	pass

func on_enter_wind_up_state():
	pass

func on_wind_up_state():
	pass

func on_leave_wind_up_state():
	pass

func on_enter_attack_state():
	pass

func on_attack_state():
	pass

func on_leave_attack_state():
	pass

func on_wind_up_timer_time_out():
	pass
