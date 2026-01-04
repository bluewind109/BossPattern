extends Node2D
class_name ExplosionShockwave

enum ANIM_STATE{RESET = 0, active}

var anim_dict: Dictionary[int, AnimationInfo] = {}

@onready var anim_ss: ComponentAnimSpriteSheet = $component_Anim_SpriteSheet

func _ready() -> void:
	self.name = "ExplosionShockwave"
	anim_ss.anim_player.animation_finished.connect(_on_animation_finished)

	anim_dict = {
		ANIM_STATE.RESET: AnimationInfo.new("RESET", true),
		ANIM_STATE.active: AnimationInfo.new("active", false),
	}
	anim_ss.init_anim_data(anim_dict)



func init(_spawn_pos: Vector2):
	global_position = _spawn_pos

func activate():
	anim_ss.play_anim(ANIM_STATE.active, false)

func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == anim_dict[ANIM_STATE.active]["name"]):
		queue_free()
