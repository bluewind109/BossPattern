extends CharacterBody2D
class_name Player

enum STATE {Idle, Run, Attack, Die}

@onready var state_machine: CallableStateMachine = $callable_state_machine

@onready var visuals: Node2D = $%visuals
@onready var character_sprite: Sprite2D = $%character_sprite

@onready var comp_health: ComponentHealth = $health
@onready var comp_look: ComponentLook = $look
@onready var player_control: FourWaysControl = $four_ways_control
@onready var hurtbox: ComponentHurtbox = $hurtbox
@onready var dash: Dash = $dash

@onready var abilities: Node = $abilities
@onready var weapons: Node2D = $%weapons

@onready var hit_sfx: RandomAudioPlayer2D = $%hit_sfx

@export var base_max_health: float = 100.0
@export var base_speed: float = 100.0
@export var curve: Curve

@export var anim_player: AnimationPlayer
var anim_dict: Dictionary [String, Variant] = {
	"idle": {
		"anim_id": "idle",
		"speed_scale": 1.0,
	},
	"run": {
		"anim_id": "run",
		"speed_scale": 1.0,
	},
}
var current_anim: String = ""

@export var game_time_manager: GameTimeManager

var current_weapon: Weapon

var is_attacking: bool = false
var is_dashing: bool = false

func _ready() -> void:
	GameEvents.level_up_upgrade_added.connect(_on_upgrade_added)
	if (game_time_manager):
		game_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

	if (comp_health):
		comp_health.health_changed.connect(_on_health_changed)
		comp_health.max_health_changed.connect(_on_max_health_changed)
		comp_health.init(base_max_health)

	if (player_control):
		player_control.set_max_speed(base_speed)

	if (dash):
		dash.player_control = player_control
		dash.start_dash.connect(_on_start_dash)
		dash.stop_dash.connect(_on_stop_dash)

	var weapon_data: Res_WeaponData = WeaponManager.get_weapon_by_id(WeaponManager.current_weapon_id)
	var weapon_level: int = WeaponManager.get_weapon_level(WeaponManager.current_weapon_id)
	var weapon = weapon_data.weapon_scene.instantiate() as Weapon
	weapons.add_child(weapon)
	weapon.on_start_attack.connect(_on_start_attack)
	weapon.on_stop_attack.connect(_on_stop_attack)
	weapon.init(weapon_data, weapon_level)
	current_weapon = weapon

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

	if (Input.is_action_just_pressed("dash") and not is_attacking):
		dash.activate(visuals)

	if (Input.is_action_just_pressed("attack") and not is_dashing):
		current_weapon.start_attack()

	if (Input.is_action_just_pressed("alt_attack") and current_weapon.has_alt_attack and not is_dashing):
		current_weapon.start_alt_attack()

	var target_pos = get_global_mouse_position()
	comp_look.look(target_pos)


func _play_anim(anim_name: String):
	if (not anim_dict.has(anim_name)): return
	if (current_anim == anim_name): return
	# print("_play_anim: ", anim_name)
	anim_player.play(anim_dict[anim_name].anim_id)
	anim_player.speed_scale = anim_dict[anim_name].speed_scale
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


func _on_upgrade_added(
	_upgrade: Res_LevelUpUpgrade, 
	current_upgrades: Dictionary
):
	if (_upgrade is Res_Ability):
		var ability = _upgrade as Res_Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif (_upgrade.id == UpgradeDefine.UPGRADE_ID.PLAYER_SPEED):
		var upgrade_val = current_upgrades[_upgrade.id]["upgrade_value"]
		player_control.max_speed = base_speed + (base_speed * current_upgrades[_upgrade.id]["quantity"] * upgrade_val)


func _on_health_changed(amount: float):
	GameEvents.emit_update_player_health_bar(amount / comp_health.max_health)


func _on_max_health_changed(amount: float):
	GameEvents.emit_update_player_health_bar(comp_health.health / amount)


func _on_damaged(amount: float):
	comp_health.take_damage(amount)
	FloatingTextManager.spawn_damage_text_at(global_position + Vector2.UP * 16, amount)
	if (amount > 0):
		GameEvents.emit_player_damaged()
		if (hit_sfx): hit_sfx.play_random()


func _on_arena_difficulty_increased(difficulty: int):
	var health_regen_quantity =  MetaProgression.get_upgrade_count(UpgradeDefine.META_UPGRADE_ID.HEALTH_REGEN)
	var health_regen_value = MetaProgression.get_upgrade_value(UpgradeDefine.META_UPGRADE_ID.HEALTH_REGEN)
	if (health_regen_quantity <= 0): return
	var is_thirty_seconds_interval = (difficulty % 1) == 0
	if (is_thirty_seconds_interval):
		comp_health.heal(health_regen_quantity * health_regen_value)


func _on_start_attack(speed_scale: float):
	is_attacking = true
	player_control.set_max_speed(base_speed * speed_scale)


func _on_stop_attack():
	is_attacking = false
	player_control.set_max_speed(base_speed)


func _on_start_dash():
	is_dashing = true


func _on_stop_dash():
	is_dashing = false
