extends Explosion
class_name Explosion_LightningStrike

var lib_name: String = "explosion_LightningStrike"
func _ready() -> void:
	super._ready()
	anim_name = lib_name + "/" + "explode"

func init(spawn_pos: Vector2, delay: float) -> void:
	super.init(spawn_pos, delay)

func _on_delay_finished():
	super._on_delay_finished()
	if anim_player.has_animation(anim_name): anim_player.play(anim_name)

func _on_animation_finished(_anim_name: StringName):
	super._on_animation_finished(anim_name)
