extends Node2D
class_name ExplosionShockwave

@export var component_anim_ss: ComponentAnimSpriteSheet

func _ready() -> void:
	component_anim_ss.anim_player.animation_finished.connect(_on_animation_finished)
	component_anim_ss.init_anim_data(
		{		
			"active": {
				"anim_id": "active",
				"texture": component_anim_ss.texture,
				"hframes": 8
			},
		}
	)

func init(_spawn_pos: Vector2):
	global_position = _spawn_pos

func activate():
	component_anim_ss.play_anim("active", false)

func _on_animation_finished(_anim_name: StringName):
	if (_anim_name == component_anim_ss.get_anim_id("active")):
		queue_free()
