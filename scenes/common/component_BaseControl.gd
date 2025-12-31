extends BaseComponent
class_name BaseControlComponent

const PLAYER_INPUT: Dictionary[String, String] = {
	"UP": "up",
	"DOWN": "down",
	"LEFT": "left",
	"RIGHT": "right",
}

var component_velocity: ComponentVelocity

func _ready() -> void:
	component_velocity = get_parent() as ComponentVelocity
	assert(component_velocity, "BaseControlComponent must be a child of a ComponentVelocity in %s." % [str(get_path())])