extends Resource
class_name Res_EnemyData

@export var enemy_scene: PackedScene
@export var id: EnemyDefine.ENEMY_ID
@export var name: String
@export var health: float = 5.0
@export var speed: float = 25.0
@export var base_damage: float = 5.0
@export var stats: Stats
@export var skills: Array[EnemySkillDefine.SKILL_ID]