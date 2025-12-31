extends Camera2D
class_name GameCamera

var target_position = Vector2.ZERO


func _ready() -> void:
	make_current()

	
func _process(delta: float) -> void:
	_acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func _acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("Player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
