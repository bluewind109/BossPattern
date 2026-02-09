@tool
extends Resource
class_name UpgradeConfig

@export var upgrades: Dictionary[UpgradeDefine.UPGRADE_ID, Res_LevelUpUpgrade]

@export_tool_button("Generate Upgrade Data")
var generate_upgrade_data_button: Callable = generate_upgrade_data

const path: String = "res://resources/enemy/enemy_data/"


func get_upgrade_res_by_id(_id: UpgradeDefine.UPGRADE_ID) -> Res_LevelUpUpgrade:
	return null


func generate_upgrade_data():
	print("generate_upgrade_data")
	upgrades = {}
	var dir: DirAccess = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.contains(".tres"):
				var full_path: String = path.path_join(file_name)
				var loaded_resource: Res_LevelUpUpgrade = ResourceLoader.load(full_path)
				if (loaded_resource):
					upgrades[loaded_resource.id] = loaded_resource
	else:
		print("Error generate_upgrade_data")
