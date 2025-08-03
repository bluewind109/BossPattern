extends Projectile
class_name ProjectileShockwave

# Invisible projectile
# release 1 shockwave every X pixels
# stop when reaching target position / certain distance

var checkpoint_pos: Vector2
var current_interval_distance: float = 0
var interval_distance: float = 50.0

var target_distance: float = 250.0
var spawn_pos : Vector2

func _ready() -> void:
	pass

func init(
	_spawn_pos: Vector2,
	_target_pos: Vector2,
	_target_distance: float,
	_speed: float = 75
):
	spawn_pos = _spawn_pos
	checkpoint_pos = spawn_pos
	global_position = spawn_pos
	target_pos = _target_pos
	target_distance = _target_distance
	speed = _speed

func activate():
	direction = spawn_pos.direction_to(target_pos)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if (_can_spawn_shockwave()):	
		_spawn_shockwave()

	if (_is_distance_reached()):
		queue_free()

func _spawn_shockwave():
	print("_spawn_shockwave %s %s" % [global_position.x, global_position.y])
	checkpoint_pos = global_position

func _can_spawn_shockwave() -> bool:
	current_interval_distance = checkpoint_pos.distance_to(global_position)
	return current_interval_distance >= interval_distance

func _is_distance_reached() -> bool:
	var distance = spawn_pos.distance_to(global_position)
	return distance >= target_distance
