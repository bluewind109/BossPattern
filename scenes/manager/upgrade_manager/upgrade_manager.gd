extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[Res_AbilityUpgrade]
@export var experience_manager: ExperienceManager

var current_upgrades = {}


func _ready() -> void:
	experience_manager.level_up.connect(_on_level_up)


func _on_level_up(current_level: int):
	var chosen_upgrade: Res_AbilityUpgrade = upgrade_pool.pick_random()
	if (chosen_upgrade == null): return
	
	var has_upgrade: bool = current_upgrades.has(chosen_upgrade.id)
	if (!has_upgrade):
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
	print("_on_level_up ", current_upgrades)
