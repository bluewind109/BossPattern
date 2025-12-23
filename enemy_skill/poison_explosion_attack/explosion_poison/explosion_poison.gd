extends Explosion
class_name ExplosionPoison

func _ready() -> void:
	super._ready()
	anim_lib_path = "res://explosion/animation/explosion_poison.res"
	var anim_lib: AnimationLibrary = load(anim_lib_path)
	if (anim_lib):
		anim_player.add_animation_library("explosion_poison", anim_lib)

func init(spawn_pos: Vector2, delay: float) -> void:
	pass

func set_anim_ss():
	anim_player.get_animation_library("explosion_poison")
	pass
