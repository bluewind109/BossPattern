extends Node

signal explosion_created(target: Explosion)
signal exp_vial_collected(number: float)
signal boss_killed(number: int)
signal enemy_killed(number: int)
signal ability_upgrade_added(upgrade: Res_AbilityUpgrade, current_upgrades: Dictionary)
signal update_player_health_bar(percent: float)
signal player_damaged
signal game_paused


func emit_explosion_created(target: Explosion):
	explosion_created.emit(target)


func emit_exp_vial_collected(number: float):
	exp_vial_collected.emit(number)


func emit_boss_killed(number: int):
	boss_killed.emit(number)


func emit_enemy_killed(number: int):
	enemy_killed.emit(number)


func emit_ability_upgrade_added(upgrade: Res_AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_update_player_health_bar(percent: float):
	update_player_health_bar.emit(percent)


func emit_player_damaged():
	player_damaged.emit()


func emit_game_paused(val: bool):
	get_tree().paused = val
	game_paused.emit(val)
