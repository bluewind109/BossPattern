@tool
extends Resource
class_name EnemyConfig

@export var enemies: Dictionary[EnemyDefine.ENEMY_ID, Res_EnemyData]

@export_tool_button("Generate Enemy Data")
var generate_enemy_data_button: Callable = generate_enemy_data

const path: String = "res://resources/enemy/enemy_data/"


func get_enemy_res_by_id(_id: EnemyDefine.ENEMY_ID) -> Res_EnemyData:
	if (!enemies.has(_id)): return null
	return enemies[_id]


func generate_enemy_data():
	print("generate_enemy_data")
	enemies = {}
	var dir: DirAccess = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.contains(".tres"):
				var full_path: String = path.path_join(file_name)
				var loaded_resource: Res_EnemyData = ResourceLoader.load(full_path)
				if (loaded_resource):
					enemies[loaded_resource.id] = loaded_resource
			file_name = dir.get_next()
	else:
		print("Error generate_enemy_data")
