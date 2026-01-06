extends Sprite2D
class_name ComponentAnimSpriteSheet

# @export var sprite_size: float = 64.0

var anim_player: AnimationPlayer
var anim_dict: Dictionary[int, AnimationInfo] = {}
var current_anim: String = ""


func _ready() -> void:
	anim_player = get_child(0) as AnimationPlayer


func init_anim_data(data: Dictionary[int, AnimationInfo]):
	anim_dict = data


func play_anim(_anim_id: int, is_loop: bool = true):	
	if (not anim_dict.has(_anim_id)): return
	if (current_anim == anim_dict[_anim_id]["name"]): return
	# print("_play_anim: ", anim_dict)
	var next_anim: String = anim_dict[_anim_id]["name"]
	anim_player.stop()
	if (is_loop):	
		anim_player.get_animation(next_anim).loop_mode = Animation.LoopMode.LOOP_LINEAR
	else:
		anim_player.get_animation(next_anim).loop_mode = Animation.LoopMode.LOOP_NONE
	anim_player.play(next_anim)
	current_anim = next_anim


func get_anim_id(_anim_id: int) -> String:
	if (not anim_dict.has(_anim_id)): return ""
	return anim_dict[_anim_id]["name"]
