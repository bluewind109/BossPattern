extends Projectile
class_name ProjectileShockwave

# Invisible projectile
# release 1 shockwave every X pixels
# stop when reaching target position / certain distance

const PROJECTILE_SHOCKWAVE_SCENE: PackedScene = preload("./projectile_Shockwave.tscn")
@export var explosion_shockwave_prefab: PackedScene

var checkpoint_pos: Vector2
var current_interval_distance: float = 0
var interval_distance: float = 25.0

var target_distance: float = 250.0
var spawn_pos : Vector2

func _ready() -> void:
	pass

static func new_projectile(
	_spawn_pos: Vector2,
	_target_pos: Vector2,
	_target_distance: float,
	_speed: float = 75
) -> ProjectileShockwave:
	var new_projectile_shockwave: ProjectileShockwave = PROJECTILE_SHOCKWAVE_SCENE.instantiate()
	new_projectile_shockwave.spawn_pos = _spawn_pos
	new_projectile_shockwave.checkpoint_pos = _spawn_pos
	new_projectile_shockwave.global_position = _spawn_pos
	new_projectile_shockwave.target_distance = _target_distance
	new_projectile_shockwave.component_projectile_velocity.target_pos = _target_pos
	new_projectile_shockwave.component_projectile_velocity.speed = _speed
	return new_projectile_shockwave

func activate():
	component_projectile_velocity.direction = spawn_pos.direction_to(component_projectile_velocity.target_pos)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if (_can_spawn_shockwave()):	
		_spawn_shockwave()

	if (_is_distance_reached()):
		queue_free()

func _spawn_shockwave():
	# print("_spawn_shockwave %s %s" % [global_position.x, global_position.y])
	checkpoint_pos = global_position
	var explosion_shockwave = explosion_shockwave_prefab.instantiate() as ExplosionShockwave
	explosion_shockwave.init(global_position)
	get_tree().current_scene.add_child(explosion_shockwave)
	explosion_shockwave.activate()

func _can_spawn_shockwave() -> bool:
	current_interval_distance = checkpoint_pos.distance_to(global_position)
	return current_interval_distance >= interval_distance

func _is_distance_reached() -> bool:
	var distance = spawn_pos.distance_to(global_position)
	return distance >= target_distance
