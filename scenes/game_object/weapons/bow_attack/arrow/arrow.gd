extends Node2D
class_name Arrow

@export var sprite: Sprite2D

@onready var hitbox: ComponentHitbox = $%hitbox
@onready var pivot: Marker2D = $pivot
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $visible_on_screen_notifier_2d

var speed: float = 150.0
var weapon_damage: float = 1.0
var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	hitbox.set_damage(weapon_damage)
	hitbox.hit.connect(_on_hit)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)


func init(_direction: Vector2, _damage: float, _speed: float):
	direction = _direction
	speed = _speed
	# look_at(direction)
	hitbox.set_damage(_damage)


func _physics_process(delta: float) -> void:
	if (direction):
		global_position += direction * speed * delta


func look(_target_pos: Vector2):
	look_at(_target_pos)


func _on_hit(hurtbox: ComponentHurtbox, _damage: float):
	queue_free()


func _on_screen_exited():
	queue_free()
