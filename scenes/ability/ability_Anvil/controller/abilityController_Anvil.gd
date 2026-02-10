extends Node
class_name AbilityController_Anvil

@export var anvil_ability_scene: PackedScene
@onready var timer: Timer = $timer

const BASE_RANGE: float = 100

var base_anvil_amount: int = 1
var anvil_amount: int


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	GameEvents.level_up_upgrade_added.connect(_on_ability_upgraded)
	anvil_amount = base_anvil_amount


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if (player == null): return Vector2.ZERO
	
	var direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degrees = 360.0 / anvil_amount
	var anvil_distance: float = randf_range(0, BASE_RANGE)
	for i in anvil_amount:
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degrees))
		var spawn_position = player.global_position + (adjusted_direction * anvil_distance)
		
		# create a raycast between player and enemy's spawn position
		var query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			player.global_position, 
			spawn_position,
			1 << 0
		)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if (!result.is_empty()): # no collision between 2 points
			spawn_position = result["position"]
			
		var ability_anvil = anvil_ability_scene.instantiate() as Ability_Anvil
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		if (foreground_layer == null): return
		foreground_layer.add_child(ability_anvil)
		ability_anvil.global_position = spawn_position
		print(spawn_position)


func _on_ability_upgraded(upgrade: Res_LevelUpUpgrade, current_upgrades: Dictionary):
	if (upgrade == null): return
	match upgrade.id:
		UpgradeDefine.UPGRADE_ID.ANVIL_AMOUNT:
			anvil_amount = base_anvil_amount + current_upgrades[upgrade.id]["quantity"]
		_:
			pass
