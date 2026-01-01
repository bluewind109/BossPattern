extends Node

signal exp_vial_collected(number: float)
signal reroll_upgrades()


func emit_exp_vial_collected(number: float):
	exp_vial_collected.emit(number)


func emit_reroll_upgrades():
	reroll_upgrades.emit()
