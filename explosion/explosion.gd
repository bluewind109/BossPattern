extends Node2D
class_name Explosion


@onready var hitbox: ComponentHitbox = $hitbox
@onready var delay_timer: Timer = $delay_timer

@onready var range_predict: Sprite2D = $range_predict
@onready var range_real: Sprite2D = $range_real

@onready var skill_sprite: Sprite2D = $skill_sprite
@onready var anim_player: AnimationPlayer = $skill_sprite/animation_player

@export var explo_size: CollisionShape2D
var delay_duration: float = 0.0
var explo_duration: float = 1.0
var explo_radius: float = 20.0

const BASE_RADIUS: float = 10.0
const BASE_SCALE: float = 0.2

func _ready() -> void:
	delay_timer.timeout.connect(_on_delay_finished)
	skill_sprite.visible = false
	if (!hitbox.is_node_ready()):
		await hitbox.ready
		_on_hitbox_ready()
	else: 
		_on_hitbox_ready()

func _on_hitbox_ready():
	# disable collision check on spawn
	hitbox.monitoring = false

func init(spawn_pos: Vector2, delay: float) -> void:
	print("init")
	global_position = spawn_pos
	delay_duration = delay
	delay_timer.wait_time = delay_duration
	print(explo_size.shape.radius)
	explo_size.shape.radius = explo_radius

	var scale_multiplier: float = explo_radius / BASE_RADIUS
	range_predict.scale = Vector2.ONE * BASE_SCALE * scale_multiplier
	range_real.scale = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if (delay_duration > 0.0 and !delay_timer.is_stopped()):
		_visualize_explosion(delta)

func _visualize_explosion(_delta: float):
	range_real.scale = range_predict.scale * (1 - (delay_timer.time_left / delay_timer.wait_time))

func activate_explosion():
	if (delay_duration > 0.0): 
		delay_timer.start()
		await delay_timer.timeout
		print("[Explosion] activate_explosion")
	hitbox.monitoring = true

func _on_delay_finished():
	range_real.scale = range_predict.scale
	range_predict.visible = false
	range_real.visible = false
	anim_player.play("lightning_strike")
