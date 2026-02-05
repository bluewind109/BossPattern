extends Resource
class_name WeaponUpgradeData

@export var damage_scale: Curve


func get_scaled_value(value: float) -> float:
	return damage_scale.sample(value)
