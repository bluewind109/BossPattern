extends Node
class_name UpgradeManager

@export var level_up_popup: PackedScene
@export var upgrade_pool: Array[Res_AbilityUpgrade]
@export var experience_manager: ExperienceManager

var current_upgrades = {}
var current_popup: LevelUpPopup

func _ready() -> void:
	experience_manager.level_up.connect(_on_level_up)


func _apply_upgrade(upgrade: Res_AbilityUpgrade):
	var has_upgrade: bool = current_upgrades.has(upgrade.id)
	if (!has_upgrade):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	print("_on_level_up ", current_upgrades)

	if (upgrade.max_quantity > 0):
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if (current_quantity == upgrade.max_quantity):
			upgrade_pool = upgrade_pool.filter(func(_upgrade):
				return _upgrade.id != upgrade.id
			)
			
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func _pick_upgrades() -> Array[Res_AbilityUpgrade]:
	var chosen_upgrades: Array[Res_AbilityUpgrade] = []
	var filtered_upgrades: Array[Res_AbilityUpgrade] = upgrade_pool.duplicate()
	for i in 3:
		if (filtered_upgrades.size() == 0): break
		var chosen_upgrade: Res_AbilityUpgrade = filtered_upgrades.pick_random()
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func(upgrade):
			return upgrade.id != chosen_upgrade.id
		) 
	return chosen_upgrades


func _on_upgrade_selected(upgrade: Res_AbilityUpgrade):
	_apply_upgrade(upgrade)


func _on_reroll_upgrades():
	if (current_popup == null): return
	current_popup.set_ability_upgrades(_pick_upgrades())


func _on_level_up(current_level: int):
	if (level_up_popup == null): return

	var chosen_upgrades = _pick_upgrades()
	if (chosen_upgrades.size() == 0): return

	var popup_instance = level_up_popup.instantiate() as LevelUpPopup
	current_popup = popup_instance
	popup_instance.set_ability_upgrades(chosen_upgrades)
	popup_instance.reroll_upgrades.connect(_on_reroll_upgrades)
	popup_instance.upgrade_selected.connect(_on_upgrade_selected)
	add_child(popup_instance)
	popup_instance.show_popup.call_deferred()
