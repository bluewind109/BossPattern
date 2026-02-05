@tool
extends Resource
class_name WeaponConfig

@export var weapons: Dictionary[WeaponDefine.WEAPON_ID, Res_WeaponData]

@export_tool_button("Generate Weapon Data")
var generate_weapon_data_button: Callable = generate_weapon_data

const path: String = "res://resources/weapon/weapon_data/"


func get_weapon_res_by_id(_id: WeaponDefine.WEAPON_ID) -> Res_WeaponData:
	if (!weapons.has(_id)): return null
	return weapons[_id]


func generate_weapon_data():
	print("generate_weapon_data")
	weapons = {}
	var dir: DirAccess = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.contains(".tres"):
				var full_path: String = path.path_join(file_name)
				var loaded_resource: Res_WeaponData = ResourceLoader.load(full_path)
				if (loaded_resource):
					weapons[loaded_resource.id] = loaded_resource
			file_name = dir.get_next()
	else:
		print("Error generate_weapon_data")