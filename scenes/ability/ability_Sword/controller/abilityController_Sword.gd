extends Node
class_name AbilityController_Sword

@export var is_disabled: bool = false

@export var sword_ability_scene: PackedScene

@export var damage: float = 5.0
@export var max_range: float = 50.0
@export var offset: float = 16.0

@onready var timer: Timer = $timer

var base_wait_time: float

var base_damage: float = 1.0
var additional_damage_percent: float = 1

var reduction_rate: float



func _ready() -> void:
	base_damage = damage
	base_wait_time = timer.wait_time
	timer.timeout.connect(_on_ability_timer_finished)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgraded)


func _on_ability_timer_finished():
	if (is_disabled): return
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if (player == null): return

	var enemies = get_tree().get_nodes_in_group("Enemy")

	# only enemies inside max range
	enemies = enemies.filter(func(enemy: EnemyBase): 
		var is_in_range = enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2.0)
		var hitable = !enemy.is_spawning and !enemy.is_dead
		return is_in_range and hitable
	)
	if (enemies.size() == 0): return

	# closest enemy inside max range
	enemies.sort_custom(func(a: Node2D, b: Node2D): 
		var distance_a = a.global_position.distance_squared_to(player.global_position)
		var distance_b = b.global_position.distance_squared_to(player.global_position)
		return distance_a < distance_b
	)

	var sword_instance = sword_ability_scene.instantiate() as Ability_Sword
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if (foreground_layer == null): return
	foreground_layer.add_child(sword_instance)

	sword_instance.hitbox.set_damage.call_deferred(base_damage * additional_damage_percent)
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * offset
	var enemy_direction = (enemies[0].global_position - sword_instance.global_position).normalized() 
	# sword_instance.global_position -= enemy_direction * round(150.0/10.0)
	sword_instance.rotation = enemy_direction.angle()


func _on_ability_upgraded(upgrade: Res_LevelUpUpgrade, current_upgrades: Dictionary):
	if (upgrade == null): return
	match upgrade.id:
		UpgradeDefine.UPGRADE_ID.SWORD_RATE:
			reduction_rate = upgrade.upgrade_value
			var percent_reduction = current_upgrades[upgrade.id]["quantity"] * reduction_rate
			timer.wait_time = base_wait_time * (1 - percent_reduction)
			timer.start()
			print(timer.wait_time)
		UpgradeDefine.UPGRADE_ID.SWORD_DAMAGE:
			var upgrade_val = current_upgrades[upgrade.id]["upgrade_value"]
			additional_damage_percent = 1 + (current_upgrades[upgrade.id]["quantity"] * upgrade_val)
		_:
			pass
