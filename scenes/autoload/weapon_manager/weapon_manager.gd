extends Node

@export var weapon_config: WeaponConfig

var current_weapon_id: WeaponDefine.WEAPON_ID = WeaponDefine.WEAPON_ID.SWORD: 
	set = _on_current_weapon_id_set


func get_weapon_by_id(_id: WeaponDefine.WEAPON_ID) -> Res_WeaponData:
	return weapon_config.get_weapon_res_by_id(_id)


func get_weapon_level(_id: WeaponDefine.WEAPON_ID) -> int:
	var weapon_progress = MetaProgression.get_weapon_progression_by_id(_id)
	if (weapon_progress == null): return 1
	print("get_weapon_level _id: ", _id)
	return weapon_progress.weapon_level


func check_can_unlock_weapon(_id: WeaponDefine.WEAPON_ID):
	var weapon = get_weapon_by_id(_id)
	if (weapon == null): return false
	var achievement_id = weapon.achievement_to_unlock
	var is_achievement_done = AchievementManager.is_achievement_done(achievement_id)
	return is_achievement_done


func _on_current_weapon_id_set(new_value):
	current_weapon_id = new_value
