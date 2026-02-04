extends Resource
class_name SaveData

@export var win_count: int = 0
@export var loss_count: int = 0
@export var meta_upgrade_currency: float = 0
@export var meta_upgrades: Dictionary[UpgradeDefine.META_UPGRADE_ID, MetaUpgradeTracking] = {}
@export var weapon_unlock_progress: Dictionary[WeaponDefine.WEAPON_ID, WeaponUnlockTracking] = {}
@export var boss_killed: int = 0
@export var enemy_killed: int = 0


func _init() -> void:
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


func add_meta_upgrade(upgrade: Res_MetaUpgrade):
	if (upgrade == null): return
	if (not meta_upgrades.has(upgrade.id)):
		meta_upgrades[upgrade.id] = MetaUpgradeTracking.new()
		meta_upgrades[upgrade.id].init(
			upgrade.id,
			0,
			upgrade.upgrade_value,
		)
	meta_upgrades[upgrade.id].upgrade_quantity(1)


func get_upgrade_count(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> int: 
	if (!meta_upgrades.has(upgrade_id)): return 0
	return meta_upgrades[upgrade_id]["quantity"]


func get_upgrade_value(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> float:
	if (!meta_upgrades.has(upgrade_id)): return 0.0
	if (!meta_upgrades[upgrade_id].has("upgrade_value")):
		match upgrade_id:
			UpgradeDefine.META_UPGRADE_ID.EXPERIENCE_GAIN:
				return 0.1
			UpgradeDefine.META_UPGRADE_ID.HEALTH_REGEN:
				return 1.0
	return meta_upgrades[upgrade_id]["upgrade_value"]


func update_meta_currency(number: float):
	meta_upgrade_currency += number


func update_boss_killed(number: int):
	boss_killed = maxi(0, boss_killed + number)


func update_enemy_killed(number: int):
	enemy_killed = maxi(0, enemy_killed + number)


func unlock_weapon(_weapon_id: WeaponDefine.WEAPON_ID):
	if (!weapon_unlock_progress.has(_weapon_id)): return
	weapon_unlock_progress[_weapon_id].unlock()
