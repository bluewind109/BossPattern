extends Area2D
class_name EnemyProjectile

@onready var projectile_velocity: ComponentProjectileVelocity = $component_ProjectileVelocity
@onready var hitbox: ComponentHitbox = $hitbox
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $visible_on_screen_notifier_2d

@export var speed: float = 75

var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	name = "enemy_projectile_"
	hitbox.hit.connect(_on_hit)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)


func init(_direction: Vector2, _damage: float):
	direction = _direction
	hitbox.set_damage(_damage)


func _physics_process(delta: float) -> void:
	if (direction):
		global_position += direction * speed * delta


func _on_hit():
	queue_free()


func _on_screen_exited():
	queue_free()
