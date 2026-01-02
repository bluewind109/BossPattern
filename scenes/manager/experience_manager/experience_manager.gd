extends Node
class_name ExperienceManager

signal exp_updated(current_exp: float, target_exp: float)
signal level_up(new_level: int)

const TARGET_EXP_GROWTH = 1

var current_exp: float = 0
var current_level: int = 1
var target_exp: float = 1


func _ready() -> void:
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)


func _increase_exp(number: float):
	current_exp = min(current_exp + number, target_exp)
	print("current exp: ", current_exp)
	exp_updated.emit(current_exp, target_exp)
	if (current_exp == target_exp):
		current_level += 1
		target_exp += TARGET_EXP_GROWTH
		current_exp = 0
		exp_updated.emit(current_exp, target_exp)
		level_up.emit(current_level)


func _on_exp_vial_collected(number: float):
	_increase_exp(number)
