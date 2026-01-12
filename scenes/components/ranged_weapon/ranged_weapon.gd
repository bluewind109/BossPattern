extends Node2D
class_name RangedWeapon

@onready var pivot: Marker2D = $pivot
@onready var weapon_sprite: Sprite2D = $pivot/sprite_2d
@onready var bullet_spawn_position: Marker2D = $pivot/sprite_2d/bullet_spawn_position

func _ready() -> void:
	pass

func _physics_process(_delta):
	var mouse_pos: Vector2 = get_global_mouse_position()
	pivot.look_at(mouse_pos)

	if (mouse_pos.x < global_position.x):
		weapon_sprite.flip_v = true
	else:
		weapon_sprite.flip_v = false

	# make the weapon floating vertical slightly
	# pivot.position.y = sin(Time.get_ticks_msec() * delta * 0.2) * 1.5
