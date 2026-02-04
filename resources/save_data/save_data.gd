extends Resource
class_name SaveData

@export var meta_upgrade_currency: float = 0
@export var meta_upgrades: Dictionary[UpgradeDefine.META_UPGRADE_ID, MetaUpgradeTracking] = {}
@export var weapon_unlock_progress: Dictionary[WeaponDefine.WEAPON_ID, WeaponUnlockTracking] = {}
@export var game_tracking: GameTracking


func _init() -> void:
	game_tracking = GameTracking.new()

	for weapon_id: int in WeaponDefine.WEAPON_ID.values():
		var _is_unlocked: bool = false
		var _weapon_level: int = 0
		if (weapon_id == WeaponDefine.WEAPON_ID.SWORD):
			_is_unlocked = true
			_weapon_level = 1
		weapon_unlock_progress[weapon_id] = WeaponUnlockTracking.new()
		weapon_unlock_progress[weapon_id].init(
			weapon_id, 
			_is_unlocked,
			_weapon_level
		)
