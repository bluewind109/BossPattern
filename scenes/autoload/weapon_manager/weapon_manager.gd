extends Node

@export var weapon_config: WeaponConfig


func get_weapon_by_id(_id: WeaponDefine.WEAPON_ID):
	return weapon_config.get_weapon_res_by_id(_id)
