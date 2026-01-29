extends CharacterBody2D
class_name Player

enum STATE {Idle, Run, Attack, Die}

@export var chosen_weapon_id: WeaponDefine.WEAPON_ID

@onready var state_machine: CallableStateMachine = $callable_state_machine

@onready var character_sprite: Sprite2D = $%character_sprite

@onready var comp_health: ComponentHealth = $health
@onready var comp_look: ComponentLook = $look
@onready var player_control: ComponentFourWaysControl = $component_FourWaysControl
@onready var abilities: Node = $abilities
@onready var weapons: Node2D = $%weapons
@onready var hurtbox: ComponentHurtbox = $hurtbox
@onready var hit_sfx: RandomAudioPlayer2D = $%hit_sfx

@export var base_max_health: float = 100.0
@export var base_speed: float = 100.0
@export var curve: Curve

@export var anim_player: AnimationPlayer
var anim_dict: Dictionary [String, Variant] = {
	"idle": {
		"anim_id": "player_idle",
		"speed_scale": 1.0,
	},
	"run": {
		"anim_id": "player_run",
		"speed_scale": 1.5,
	},
}
var current_anim: String = ""

@export var game_time_manager: GameTimeManager


func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
	if (game_time_manager):
		game_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

	if (comp_health):
		comp_health.health_changed.connect(_on_health_changed)
		comp_health.max_health_changed.connect(_on_max_health_changed)
		comp_health.init(base_max_health)

	if (player_control):
		player_control.set_max_speed(base_speed)

	var weapon_data = WeaponManager.get_weapon_by_id(chosen_weapon_id)
	var weapon = weapon_data.weapon_scene.instantiate() as Weapon
	weapons.add_child(weapon)
	weapon.set_weapon_damage(weapon_data.base_damage)

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


func _on_ability_upgrade_added(
	_upgrade: Res_AbilityUpgrade, 
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
