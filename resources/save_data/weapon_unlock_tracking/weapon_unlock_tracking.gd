extends Resource
class_name WeaponUnlockTracking

var id: WeaponDefine.WEAPON_ID
var is_unlocked: bool = false
var weapon_level: int = 0


func init(_id: WeaponDefine.WEAPON_ID, _is_unlocked: bool, _level: int):
	id = _id
	is_unlocked = _is_unlocked
	weapon_level = _level


func unlock():
	is_unlocked = true
	weapon_level = 1


func upgrade(number: int):
	weapon_level += number
