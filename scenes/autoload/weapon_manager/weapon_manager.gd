extends Node

@export var weapon_config: WeaponConfig


func get_weapon_by_id(_id: WeaponDefine.WEAPON_ID) -> Res_WeaponData:
	return weapon_config.get_weapon_res_by_id(_id)
