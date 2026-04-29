extends Node2D
class_name Weapon

signal on_start_attack(speed_scale: float)
signal on_stop_attack()

@export var weapon_sprite: Sprite2D
@export var weapon_damage: float = 1.0
@export var speed_scale: float = 0.5
@export var base_attack_speed: float = 1.0
@export var has_alt_attack: bool = false
var attack_speed_upgrades: Array[float] = []

func init(weapon_data: Res_WeaponData, weapon_level: int):
	if (weapon_data == null): return
	if (weapon_level == 0): weapon_level = 1
	var search_string: String = weapon_data.name.to_lower() + "_0" + str(weapon_level)
	var result_icon: Texture2D = weapon_data.search_icon(search_string)
	if (result_icon != null): weapon_sprite.texture = result_icon
	var final_damage = weapon_data.get_scaled_damage(weapon_level)
	set_weapon_damage(final_damage)


func set_weapon_damage(val: float):
	print("set_weapon_damage val: ", val)
	weapon_damage = val


func add_attack_speed_upgrade(new_value: float):
	attack_speed_upgrades.append(new_value)


func get_attack_speed() -> float:
	var upgrade_value: float = 0.0
	for upgrade in attack_speed_upgrades:
		upgrade_value += upgrade
	upgrade_value = minf(upgrade_value, 1.5)
	return base_attack_speed + upgrade_value


func start_attack():
	on_start_attack.emit(0)


func start_alt_attack():
	on_start_attack.emit(0)


func stop_attack():
	on_stop_attack.emit()
