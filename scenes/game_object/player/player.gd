extends CharacterBody2D
class_name Player

@onready var state_machine: CallableStateMachine = $callable_state_machine

@onready var character_sprite: Sprite2D = $character_sprite
var idle_texture: Texture2D = preload("./sprites/Player_idle.png")
var run_texture: Texture2D = preload("./sprites/Player_run.png")

@onready var comp_health: ComponentHealth = $health
@onready var comp_look: ComponentLook = $look
@onready var player_control: ComponentFourWaysControl = $component_FourWaysControl
@onready var abilities: Node = $abilities
@onready var hurtbox: ComponentHurtbox = $hurtbox
@onready var hit_sfx: RandomAudioPlayer2D = $%hit_sfx

@export var base_max_health: float = 100.0
@export var base_speed: float = 100.0
@export var curve: Curve

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
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
	if (comp_look): 
		comp_look.owner_node = character_sprite

	if (comp_health):
		comp_health.health_changed.connect(_on_health_changed)
		comp_health.max_health_changed.connect(_on_max_health_changed)
		comp_health.init(base_max_health)

	if (player_control):
		player_control.set_max_speed(base_speed)

	if (hurtbox):
		hurtbox.damaged.connect(_on_damaged)

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


func _physics_process(delta: float) -> void:
	state_machine.update(delta)

	var target_pos = get_global_mouse_position()
	comp_look.look(target_pos)


func _play_anim(anim_name: String):
	if (not anim_dict.has(anim_name)): return
	if (current_anim == anim_name): return
	# print("_play_anim: ", anim_name)
	var sprite_size: float = 32
	var anim_data: Variant = anim_dict[anim_name]
	character_sprite.texture = anim_data.texture
	character_sprite.hframes = anim_data.hframes
	character_sprite.region_rect.size = Vector2(sprite_size * character_sprite.hframes, sprite_size)
	anim_player.play(anim_dict[anim_name].anim_id)
	anim_player.speed_scale = 0.25
	current_anim = anim_name


func on_enter_idle_state():
	_play_anim("idle")


func on_idle_state(_delta: float):
	if (velocity != Vector2.ZERO):
		state_machine.change_state(STATE.Run)


func on_leave_idle_state():
	pass


func on_enter_run_state():
	_play_anim("run")


func on_run_state(_delta: float):
	if (velocity == Vector2.ZERO):
		state_machine.change_state(STATE.Idle)


func on_leave_run_state():
	pass


func _on_ability_upgrade_added(
	ability_upgrade: Res_AbilityUpgrade, 
	current_upgrades: Dictionary
):
	if (ability_upgrade is Res_Ability):
		var ability = ability_upgrade as Res_Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif (ability_upgrade.id == "player_speed"):
		player_control.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)


func _on_health_changed(amount: float):
	GameEvents.emit_update_player_health_bar(amount / comp_health.max_health)


func _on_max_health_changed(amount: float):
	GameEvents.emit_update_player_health_bar(comp_health.health / amount)


func _on_damaged(amount: float):
	if (amount > 0):
		GameEvents.emit_player_damaged()
		if (hit_sfx): hit_sfx.play_random()
