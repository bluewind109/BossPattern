extends Node2D
class_name Weapon

@export var weapon_sprite: Sprite2D
@export var weapon_damage: float = 1.0


func init(weapon_data: Res_WeaponData, weapon_level: int):
	if (weapon_data == null): return
	if (weapon_level == 0): weapon_level = 1
	var search_string: String = weapon_data.name.to_lower() + "_0" + str(weapon_level)
	var result_icon: Texture2D = weapon_data.search_icon(search_string)
	if (result_icon != null): weapon_sprite.texture = result_icon
	var final_damage = weapon_data.get_scaled_damage(weapon_level)
	set_weapon_damage(final_damage)


func set_weapon_damage(val: float):
	weapon_damage = val
