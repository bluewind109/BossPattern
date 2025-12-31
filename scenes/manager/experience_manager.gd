extends Node
class_name ExperienceManager

var current_exp = 0


func increase_exp(number: float):
	current_exp += number
	print("current exp: ", current_exp)
