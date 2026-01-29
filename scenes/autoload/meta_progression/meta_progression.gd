extends Node

const SAVE_FILE_PATH = "user://save/"
const SAVE_FILE_NAME = "game_save.tres"

var save_data: SaveData


func _ready() -> void:
	verify_save_directory(SAVE_FILE_PATH)
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)
	load_save_file()


func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)


func init_save_file():
	print("init_save_file")
	save_data = SaveData.new()


func load_save_file():
	if (!ResourceLoader.exists(SAVE_FILE_PATH + SAVE_FILE_NAME)):
	# if (!FileAccess.file_exists(SAVE_FILE_PATH + SAVE_FILE_NAME)):
		init_save_file()
		save()
		return
	# var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	# save_data = file.get_var(true)
	# print("load_save_file: ", save_data)
	save_data = ResourceLoader.load(SAVE_FILE_PATH + SAVE_FILE_NAME)
	print("load_save_file: ", save_data.meta_upgrade_currency)


func save():
	# var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	# file.store_var(save_data)
	ResourceSaver.save(save_data, SAVE_FILE_PATH + SAVE_FILE_NAME)
	print("save")


func get_weapon_progression() -> Dictionary[WeaponDefine.WEAPON_ID, WeaponUnlockTracking]:
	return save_data.weapon_unlock_progress


func add_meta_upgrade(upgrade: Res_MetaUpgrade):
	save_data.add_meta_upgrade(upgrade)
	save()


func get_upgrade_count(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> int:
	return save_data.get_upgrade_count(upgrade_id)


func get_upgrade_value(upgrade_id: UpgradeDefine.META_UPGRADE_ID) -> float:
	return save_data.get_upgrade_value(upgrade_id)


func get_currency() -> float:
	return save_data.meta_upgrade_currency


func update_currency(number: float):
	print("update_currency: ", number)
	save_data.update_meta_currency(number)
	save()


func _on_exp_vial_collected(number: float):
	update_currency(number)


func _on_boss_killed(number: int):
	save_data.update_boss_killed(number)
	save()


func _on_enemy_killed(number: int):
	save_data.update_enemy_killed(number)
	save()


func _on_unlock_weapon(_weapon_id: WeaponDefine.WEAPON_ID):
	save_data.unlock_weapon(_weapon_id)
	save()
