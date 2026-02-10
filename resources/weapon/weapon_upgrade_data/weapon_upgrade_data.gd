extends Resource
class_name WeaponUpgradeData

@export var damage_scale: Curve
@export var upgrade_cost: Array[int]


func get_scaled_value(value: float) -> float:
	return damage_scale.sample(value)
