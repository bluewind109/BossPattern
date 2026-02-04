extends Node

@export var weapon_config: WeaponConfig

var current_weapon_id: WeaponDefine.WEAPON_ID = WeaponDefine.WEAPON_ID.SWORD: 
	set = _on_current_weapon_id_set


func get_weapon_by_id(_id: WeaponDefine.WEAPON_ID) -> Res_WeaponData:
	return weapon_config.get_weapon_res_by_id(_id)


func check_can_unlock_weapon():
	pass


func _on_current_weapon_id_set(new_value):
	current_weapon_id = new_value
