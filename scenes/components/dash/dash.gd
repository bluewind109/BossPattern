@icon("./icon.png")
extends Node2D
class_name Dash


@onready var duration_timer	: Timer = $%duration_timer
@onready var cooldown_timer: Timer = $%cooldown_timer
@onready var effect_particles: GPUParticles2D = $%effect_particles
@onready var dash_cooldown_bar: TextureProgressBar = $%dash_cooldown_bar
@onready var ghost_effect: GhostEffect = $%ghost_effect

var dash_sprite: Node2D

var can_dash: bool = true
var is_dashing: bool = false

var player_control: FourWaysControl

const DASH_MULTIPLIER: float = 5.0

signal start_dash
signal stop_dash

func _ready() -> void:
	duration_timer.timeout.connect(_on_duration_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	toggle_dash_cooldown_bar(false)

func _process(_delta: float) -> void:
	if (not can_dash):
		dash_cooldown_bar.value = (cooldown_timer.time_left / cooldown_timer.wait_time) * 100

func set_dash_sprite(sprite: Node2D):
	dash_sprite = sprite
	if (ghost_effect):
		ghost_effect.sprite_2d = dash_sprite

func activate(sprite: Node2D):
	if (!can_dash): return
	set_dash_sprite(sprite)
	start_dash.emit()
	can_dash = false
	toggle_dash_cooldown_bar(true)

	duration_timer.start()
	cooldown_timer.start()

	is_dashing = true
	if (ghost_effect):
		ghost_effect.start_effect()
	effect_particles.emitting = true
	if (player_control):
		player_control.set_speed_multiplier(get_dash_multiplier())

func get_dash_multiplier() -> float:
	return DASH_MULTIPLIER

func toggle_dash_cooldown_bar(is_show: bool):
	if (is_show):
		dash_cooldown_bar.show()
	else:
		dash_cooldown_bar.hide()

func _on_duration_timeout() -> void:
	is_dashing = false
	stop_dash.emit()
	if (ghost_effect):
		ghost_effect.stop_effect()
	effect_particles.emitting = false
	if (player_control):
		player_control.reset_speed_multiplier()

func _on_cooldown_timeout() -> void:
	toggle_dash_cooldown_bar(false)
	can_dash = true
