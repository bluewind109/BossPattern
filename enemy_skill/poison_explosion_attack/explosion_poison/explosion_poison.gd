extends Explosion
class_name ExplosionPoison

func _ready() -> void:
	super._ready()

func init(spawn_pos: Vector2, delay: float) -> void:
	pass

func set_anim_ss():
	anim_player.get_animation_library("explosion_poison")
	pass
