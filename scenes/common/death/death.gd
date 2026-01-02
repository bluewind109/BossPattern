extends Node2D
class_name ComponentDeath

@export var comp_health: ComponentHealth


func _ready() -> void:
	comp_health.died.connect(_on_died)


# Remove entity from the game but still play death animation
func _on_died():
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	# TODO play death animation
	#animation_player.play("default")
	
