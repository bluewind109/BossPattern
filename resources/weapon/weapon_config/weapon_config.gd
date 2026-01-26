extends Resource
class_name WeaponConfig

@export var weapons: Dictionary[WeaponDefine.WEAPON_ID, Res_WeaponData]


func get_weapon_res_by_id(_id: WeaponDefine.WEAPON_ID) -> Res_WeaponData:
	if (!weapons.has(_id)): return null
	return weapons[_id]
