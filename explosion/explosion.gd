extends Node2D
class_name Explosion

@onready var hitbox: ComponentHitbox = $hitbox
@onready var delay_timer: Timer = $delay_timer

@export var explo_size: CollisionShape2D
var delay_duration: float = 0

func _init() -> void:
	if (explo_size):
		explo_size.shape.radius = 20
	pass

func _ready() -> void:
	if (!hitbox.is_node_ready()):
		await hitbox.ready
		_on_hitbox_ready()
	else: 
		_on_hitbox_ready()

func _on_hitbox_ready():
	# disable collision check on spawn
	hitbox.monitoring = false

func activate_explosion():
	# TODO enable collision check
	pass
