extends Resource
class_name Res_WeaponData

@export var weapon_scene: PackedScene
@export var id: WeaponDefine.WEAPON_ID
@export var name: String
@export var base_damage: float = 1.0
@export var max_level: int = 1
@export var icons: Array[Texture2D] = []
@export var achievement_to_unlock: AchievementDefine.ACHIEVEMENT_ID
@export var upgrade_data: WeaponUpgradeData


func do():
	pass


func search_icon(search_string: String) -> Texture2D:
	for icon in icons:
		if (icon.resource_path.contains(search_string)):
			return icon
	return null


func search_icons(search_string: String) -> Array[Texture2D]:
	var filter_icons: Array[Texture2D] = icons.duplicate()
	filter_icons = filter_icons.filter(func(_icons: Texture2D): 
		return _icons.resource_path.contains(search_string)
	)
	return filter_icons

func get_scaled_damage(current_level: int) -> float:
	var level_percent: float = float(current_level) / float(max_level)
	var scaled_damage: float = upgrade_data.get_scaled_value(level_percent)
	print("get_scaled_damage scaled_damage: ", scaled_damage)
	return scaled_damage
