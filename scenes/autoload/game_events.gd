extends Node

signal exp_vial_collected(number: float)
signal ability_upgrade_added(upgrade: Res_AbilityUpgrade, current_upgrades: Dictionary)
signal update_player_health_bar(percent: float)


func emit_exp_vial_collected(number: float):
	exp_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: Res_AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_update_player_health_bar(percent: float):
	update_player_health_bar.emit(percent)