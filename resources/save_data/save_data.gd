extends Resource
class_name SaveData

var win_count: int = 0
var loss_count: int = 0
var meta_upgrade_currency: float = 0
var meta_upgrades: Dictionary = {}
var weapon_unlock_progress: Dictionary[WeaponDefine.WEAPON_ID, WeaponUnlockTracking] = {}
var boss_killed: int = 0
var enemy_killed: int = 0
