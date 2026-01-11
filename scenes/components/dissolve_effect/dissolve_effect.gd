extends Node
class_name DissolveEffect

@export var dissolve_material: ShaderMaterial
@export var sprite: Sprite2D

var dissolved_tween: Tween


func start_dissolve(cb: Callable = Callable()):
	if (sprite == null): return
	sprite.material = dissolve_material
	sprite.material.resource_local_to_scene = true
	sprite.material.set_shader_parameter("is_horizontal", true)
	sprite.material.set_shader_parameter("progress", 0.0)

	if (dissolved_tween != null and dissolved_tween.is_valid()): 
		dissolved_tween.kill()

	dissolved_tween = create_tween()
	dissolved_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	dissolved_tween.tween_property(sprite.material, "shader_parameter/progress", 1.0, 1.0)
	if (cb != Callable()): 
		dissolved_tween.tween_callback(func():
			cb.call()
		)		


func reverse_dissolve(cb: Callable = Callable()):
	if (sprite == null): return
	sprite.material = dissolve_material
	sprite.material.resource_local_to_scene = true
	sprite.material.set_shader_parameter("is_horizontal", false)
	sprite.material.set_shader_parameter("progress", 1.0)

	if (dissolved_tween != null and dissolved_tween.is_valid()): 
		dissolved_tween.kill()
	dissolved_tween = create_tween()
	dissolved_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dissolved_tween.tween_property(sprite.material, "shader_parameter/progress", 0.0, 1.5)
	if (cb != Callable()): 
		dissolved_tween.tween_callback(func():
			cb.call()
		)	
