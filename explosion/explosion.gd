extends Node2D
class_name Explosion


@onready var hitbox: ComponentHitbox = $hitbox
@onready var delay_timer: Timer = $delay_timer

@export var explo_size: CollisionShape2D
var delay_duration: float = 0.0
var explo_duration: float = 1.0
var explo_radius: float = 10.0

func _ready() -> void:
	if (!hitbox.is_node_ready()):
		await hitbox.ready
		_on_hitbox_ready()
	else: 
		_on_hitbox_ready()

func _on_hitbox_ready():
	# disable collision check on spawn
	hitbox.monitoring = false

func _visualize_explosion():
	pass

func activate_explosion():
	if (delay_duration > 0.0): await delay_timer.timeout
	if (explo_size): explo_size.shape.radius = 20
	hitbox.monitoring = true
