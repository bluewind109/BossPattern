extends Resource
class_name Res_WeaponData

@export var weapon_scene: PackedScene
@export var id: WeaponDefine.WEAPON_ID
@export var name: String
@export var base_damage: float = 1.0
@export var icons: Array[Texture2D] = []


func do():
	pass


func search_icons(search_string: String) -> Array[Texture2D]:
	var filter_icons: Array[Texture2D] = icons.duplicate()
	filter_icons = filter_icons.filter(func(_icons: Texture2D): 
		return _icons.resource_path.contains(search_string)
	)
	return filter_icons
