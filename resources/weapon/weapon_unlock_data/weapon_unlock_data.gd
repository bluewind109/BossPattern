extends Resource
class_name WeaponUnlockData

@export var id: WeaponDefine.WEAPON_ID
@export var icons: Array[Texture2D] = []


func search_icons(search_string: String) -> Array[Texture2D]:
	var filter_icons: Array[Texture2D] = icons.duplicate()
	filter_icons = filter_icons.filter(func(_icons: Texture2D): 
		return _icons.resource_path.contains(search_string)
	)
	return filter_icons
