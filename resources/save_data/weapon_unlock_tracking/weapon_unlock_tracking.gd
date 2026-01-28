extends Resource
class_name WeaponUnlockTracking

var id: WeaponDefine.WEAPON_ID
var is_unlocked: bool = false
var weapon_level: int = 0


func _init(_id: WeaponDefine.WEAPON_ID, _is_unlocked: bool, _level: int):
	id = _id
	is_unlocked = _is_unlocked
	weapon_level = _level
