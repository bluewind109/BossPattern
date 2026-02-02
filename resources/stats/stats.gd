extends Resource
class_name Stats

enum BUFFABLE_STATS
{
	MAX_HEALTH,
	ATTACK,
	DEFENSE,
	SPEED
}

signal health_depleted
signal health_changed(cur_health: float, max_health: float)

@export var base_max_health: float = 100
@export var base_attack: float = 100
@export var base_defense: float = 100
@export var base_speed: float = 75
@export var experience: float = 0

var current_max_health: float = 100
var current_attack: float = 10
var current_defense: float = 10

var health: float = 0: set = _on_health_set

func _setup_local_to_scene() -> void:
	setup_stats()


func setup_stats():
	health = current_max_health
	

func _on_health_set(new_value: float):
	health = clamp(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()
