extends EnemyBase
class_name EnemyBat

@export var sprite: Sprite2D
var idle_texture: Texture2D = preload("res://enemy/sprites/Bat-IdleFly.png")
var chase_texture: Texture2D = preload("res://enemy/sprites/Bat-Run.png")

@export var anim_player: AnimationPlayer
const anim_dict: Dictionary [String, String] = {
	"idle": "fly_idle",
	"chase": "fly_chase",
}

@export var component_velocity: ComponentVelocity
@export var component_steer: ComponentSteer

@export var CHARGE_RANGE: float = 150.0

func _ready() -> void:
	super._ready()
	STATE = {
		"Normal": "Normal",
		"Charge": "Charge",
	}

	state_machine.add_states(STATE.Normal, CallableState.new(
		on_normal_state,
		on_enter_normal_state,
		on_leave_normal_state
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
	sprite.texture = idle_texture
	sprite.hframes = 9
	sprite.region_rect.size = Vector2(64 * sprite.hframes, 64)
	anim_player.play(anim_dict["idle"])
	
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

	move_and_slide()

	# TODO if player in X range, change to chase state

func movement_update(delta):
	pass

func on_leave_normal_state():
	pass

func on_enter_charge_state():
	sprite.texture = chase_texture
	sprite.hframes = 8
	anim_player.play(anim_dict["chase"])

func on_charge_state():
	pass

func on_leave_charge_state():
	pass
