extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_count": 0,
	"loss_count": 0,
	"meta_upgrade_currency": 0,
	"upgrades": {}
}


func _ready() -> void:
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)
	load_save_file()


func load_save_file():
	if (!FileAccess.file_exists(SAVE_FILE_PATH)):
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
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func _on_exp_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
	save()
