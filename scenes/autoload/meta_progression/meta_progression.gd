extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_count": 0,
	"loss_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {},
}


func _ready() -> void:
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)
	load_save_file()


func init_save_file():
	pass


func load_save_file():
	if (!FileAccess.file_exists(SAVE_FILE_PATH)):
		init_save_file()
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	print("load_save_file: ", save_data)


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: Res_MetaUpgrade):
	if (not save_data["meta_upgrades"].has(upgrade.id)):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0,
			"upgrade_value": upgrade.upgrade_value,
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func get_upgrade_count(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> int: 
	if (!save_data["meta_upgrades"].has(upgrade_id)): return 0
	return save_data["meta_upgrades"][upgrade_id]["quantity"]


func get_upgrade_value(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> float:
	if (!save_data["meta_upgrades"].has(upgrade_id)): return 0.0
	if (!save_data["meta_upgrades"][upgrade_id].has("upgrade_value")):
		match upgrade_id:
			UpgradeDefine.META_UPGRADE_ID.EXPERIENCE_GAIN:
				return 0.1
			UpgradeDefine.META_UPGRADE_ID.HEALTH_REGEN:
				return 1.0
	return save_data["meta_upgrades"][upgrade_id]["upgrade_value"]


func get_currency() -> float:
	if (!save_data.has("meta_upgrade_currency")): return 0.0
	return save_data["meta_upgrade_currency"]


func update_currency(val: float):
	save_data["meta_upgrade_currency"] += val
	save()


func _on_exp_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
	save()


func _on_boss_killed(number: int):
	pass


func _on_enemy_killed(number_int):
	pass