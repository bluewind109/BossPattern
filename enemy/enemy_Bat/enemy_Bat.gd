extends EnemyBase
class_name EnemyBat

@export var sprite: Sprite2D
var idle_texture: Texture2D = preload("./sprites/Bat-IdleFly.png")
var chase_texture: Texture2D = preload("./sprites/Bat-Run.png")

@export var anim_player: AnimationPlayer
var anim_dict: Dictionary [String, Variant] = {}
var current_anim: String = ""

@export var component_velocity: ComponentVelocity
@export var component_steer: ComponentSteer
@export var component_look: ComponentLook

var charge_position: Vector2
var charge_direction: Vector2
@export var CHARGE_RANGE: float = 150.0
@export var CHARGE_DISTANCE: float = 350.0


func _ready() -> void:
	super._ready()
	STATE = {
		"Normal": "Normal",
		"WindUp": "WindUp",
		"Charge": "Charge",
	}

	init_anim_data()

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

func init_anim_data():
	anim_dict = {
		"idle": {
			"anim_id": "fly_idle",
			"texture": idle_texture,
			"hframes": 9
		},
		"chase": {
			"anim_id": "fly_chase",
			"texture": chase_texture,
			"hframes": 8
		},
	}

func _physics_process(_delta: float) -> void:
	state_machine.update()

func _play_anim(anim_name: String):
	if (not anim_dict.has(anim_name)): return
	if (current_anim == anim_name): return
	# print("_play_anim: ", anim_name)
	var sprite_size: float = 64
	var anim_data: Variant = anim_dict[anim_name]
	sprite.texture = anim_data.texture
	sprite.hframes = anim_data.hframes
	sprite.region_rect.size = Vector2(sprite_size * sprite.hframes, sprite_size)
	anim_player.play(anim_dict[anim_name].anim_id)
	current_anim = anim_name

func on_enter_normal_state():
	_play_anim("idle")
	
func on_normal_state():
	component_velocity.max_speed = 25.0

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
	move_and_slide()

	# if player in X range, change to chase state
	if (is_in_charge_range()):
		state_machine.change_state(STATE.Charge)

func on_leave_normal_state():
	pass

func on_enter_wind_up_state():
	_play_anim("idle")

func on_wind_up_state():
	pass

func on_leave_wind_up_state():
	pass

func on_enter_charge_state():
	_play_anim("chase")
	charge()

func on_charge_state():
	component_velocity.max_speed = 200.0
	velocity = charge_direction * component_velocity.max_speed

	if (is_charge_distance_reached()):
		state_machine.change_state(STATE.Normal)

func on_leave_charge_state():
	pass

func charge():
	charge_position = global_position
	charge_direction = global_position.direction_to(player_ref.global_position)

func is_in_charge_range() -> bool:
	var distance = player_ref.global_position.distance_to(global_position)
	return distance <= CHARGE_RANGE

func is_charge_distance_reached() -> bool:
	var distance = charge_position.distance_to(global_position)
	return distance >= CHARGE_DISTANCE
