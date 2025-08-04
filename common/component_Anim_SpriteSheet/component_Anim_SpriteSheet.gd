extends Sprite2D
class_name ComponentAnimSpriteSheet

# @export var sprite_size: float = 64.0

var anim_player: AnimationPlayer
var anim_dict: Dictionary[String, Variant] = {}
var current_anim: String = ""

func _ready() -> void:
	anim_player = get_child(0) as AnimationPlayer

func init_anim_data(data: Dictionary[String, Variant]):
	anim_dict = data

func play_anim(_anim_name: String, is_loop: bool = true):	
	if (not anim_dict.has(_anim_name)): return
	if (current_anim == _anim_name): return
	# print("_play_anim: ", anim_name)
	var anim_data: Variant = anim_dict[_anim_name]
	texture = anim_data.texture
	# hframes = anim_data.hframes
	# region_rect.size = Vector2(sprite_size * hframes, sprite_size)
	if (is_loop):	
		anim_player.get_animation(anim_dict[_anim_name].anim_id).loop_mode = Animation.LoopMode.LOOP_LINEAR
	else:
		anim_player.get_animation(anim_dict[_anim_name].anim_id).loop_mode = Animation.LoopMode.LOOP_NONE
	anim_player.play(anim_dict[_anim_name].anim_id)
	current_anim = _anim_name

func get_anim_id(_anim_name: String) -> String:
	if (not anim_dict.has(_anim_name)): return ""
	return anim_dict[_anim_name].anim_id
