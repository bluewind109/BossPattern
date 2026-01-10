extends Node
class_name HitFlash

@export var hit_flash_material: ShaderMaterial
@export var comp_health: ComponentHealth
@export var sprite: Sprite2D

var hit_flash_tween: Tween

func _ready():
	comp_health.health_decreased.connect(_on_health_decreased)
	if (sprite != null): sprite.material = hit_flash_material


func reset_material():
	if (sprite == null): return
	if (sprite.material == hit_flash_material): return
	sprite.material = hit_flash_material


func _on_health_decreased(health: float):
	if (sprite == null): return
	if (hit_flash_tween != null and hit_flash_tween.is_valid()): 
		hit_flash_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.25)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
