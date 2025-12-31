extends Node2D
class_name ExperienceVial

func _ready() -> void:
	self.name = "ExperienceVial"
	$area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D):
	GameEvents.emit_exp_vial_collected(1)
	queue_free()
