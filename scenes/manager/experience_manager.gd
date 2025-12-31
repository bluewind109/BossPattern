extends Node
class_name ExperienceManager

var current_exp = 0


func _ready() -> void:
	GameEvents.exp_vial_collected.connect(_on_exp_vial_collected)


func _increase_exp(number: float):
	current_exp += number
	print("current exp: ", current_exp)


func _on_exp_vial_collected(number: float):
	_increase_exp(number)
