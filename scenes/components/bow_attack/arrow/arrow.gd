extends Node2D
class_name Arrow

@onready var hitbox: ComponentHitbox = $%hitbox
@onready var pivot: Marker2D = $pivot
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $visible_on_screen_notifier_2d

@export var speed: float = 75

var weapon_damage: float = 1.0
var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	hitbox.set_damage(weapon_damage)
	hitbox.hit.connect(_on_hit)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)


func init(_direction: Vector2, _damage: float):
	direction = _direction
	hitbox.set_damage(_damage)


func _physics_process(delta: float) -> void:
	if (direction):
		global_position += direction * speed * delta


func _on_hit(hurtbox: ComponentHurtbox, _damage: float):
	queue_free()


func _on_screen_exited():
	queue_free()
