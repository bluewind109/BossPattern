extends Node2D
class_name ExperienceVial

func _ready() -> void:
	$area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D):
	queue_free()
