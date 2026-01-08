extends Node

var save_data: Dictionary = {
	"win_count": 0,
	"loss_count": 0,
	"meta_upgrade_currency": 0,
	"upgrades": {}
}


func _ready() -> void:
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if (not save_data["meta_upgrades"].has(upgrade.id)):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func _on_exp_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
