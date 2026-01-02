extends Node2D
class_name ComponentDeath

@export var comp_health: ComponentHealth
@export var sprite: Sprite2D


func _ready() -> void:
	#gpu_particle.texture = sprite.texture
	comp_health.died.connect(_on_died)


# Remove entity from the game but still play death animation
func _on_died():
	if (owner == null || not owner is Node2D): return
	var spawn_pos: Vector2 = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_pos
	# TODO play death animation
	#animation_player.play("default")
	
