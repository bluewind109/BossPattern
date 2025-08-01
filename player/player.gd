extends CharacterBody2D
class_name Player

@export var state_machine: CallableStateMachine

@export var sprite: Sprite2D
var idle_texture: Texture2D = preload("./sprites/Player_idle.png")
var run_texture: Texture2D = preload("./sprites/Player_run.png")

@export var component_health: ComponentHealth
@export var component_look: ComponentLook

var max_health: float = 100.0

var STATE: Dictionary[String, String] = {
	"Idle": "Idle",
	"Run": "Run",
}

@export var anim_player: AnimationPlayer
var anim_dict: Dictionary [String, Variant] = {
	"idle": {
		"anim_id": "player_idle",
		"texture": idle_texture,
		"hframes": 6
	},
	"run": {
		"anim_id": "player_run",
		"texture": run_texture,
		"hframes": 8
	},
}
var current_anim: String = ""

func _ready() -> void:
	state_machine.add_states(STATE.Idle, CallableState.new(
		on_idle_state,
		on_enter_idle_state,
		on_leave_idle_state
	))

	state_machine.add_states(STATE.Run, CallableState.new(
		on_run_state,
		on_enter_run_state,
		on_leave_run_state
	))

	state_machine.set_initial_state(STATE.Idle)

	var health = max_health
	component_health.init.call_deferred(max_health, health)

func _physics_process(_delta: float) -> void:
	state_machine.update()

	var target_pos = get_global_mouse_position()
	component_look.look(target_pos)

func _play_anim(anim_name: String):
	if (not anim_dict.has(anim_name)): return
	if (current_anim == anim_name): return
	# print("_play_anim: ", anim_name)
	var sprite_size: float = 32
	var anim_data: Variant = anim_dict[anim_name]
	sprite.texture = anim_data.texture
	sprite.hframes = anim_data.hframes
	sprite.region_rect.size = Vector2(sprite_size * sprite.hframes, sprite_size)
	anim_player.play(anim_dict[anim_name].anim_id)
	anim_player.speed_scale = 0.25
	current_anim = anim_name

func on_enter_idle_state():
	_play_anim("idle")

func on_idle_state():
	if (velocity != Vector2.ZERO):
		state_machine.change_state(STATE.Run)

func on_leave_idle_state():
	pass

func on_enter_run_state():
	_play_anim("run")

func on_run_state():
	if (velocity == Vector2.ZERO):
		state_machine.change_state(STATE.Idle)

func on_leave_run_state():
	pass
