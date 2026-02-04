extends PanelContainer
class_name WeaponSelectionCard

@onready var click_sfx: RandomAudioPlayer = $click_sfx

@onready var weapon_icon: TextureRect = $%weapon_icon
# @onready var label_progress: Label = $%label_progress
# @onready var label_purchase_count: Label = $%label_purchase_count
@onready var purchase_button: SoundButton = $%purchase_button
@onready var upgrade_button: SoundButton = $%upgrade_button
@onready var select_button: SoundButton = $%select_button
# @onready var progress_bar: ProgressBar = $%upgrade_progress_bar

@export var label_name: Label
@export var label_description: Label

var unlock_tracking: WeaponUnlockTracking
var data: Res_WeaponData

# short duration = game with fast level up for urgency
# long duration = game with slower level up for more impact
var tween_duration: float = 0.25

# enable when tween animation is done
var can_select: bool = false


func _ready() -> void:
	self.name = "weapon_selection_card"

	select_button.pressed.connect(_on_select_pressed)
	# purchase_button.pressed.connect(_on_purchase_pressed)
	pivot_offset = size / 2
	self.modulate.a = 0
	can_select = false
	update_progress.call_deferred()


func init(tracking_data: WeaponUnlockTracking):
	if (tracking_data == null): return
	unlock_tracking = tracking_data
	data = WeaponManager.get_weapon_by_id(unlock_tracking.id)
	if (data == null): return
	label_name.text = data.name
	weapon_icon.texture = data.icons[0]
	# if (unlock_tracking.is_unlocked):
	var result_level = 1 if unlock_tracking.weapon_level == 0 else unlock_tracking.weapon_level
	var search_string: String = data.name.to_lower() + "_0" + str(result_level)
	print("weapon_level search_string: ", search_string)
	var result_icon: Texture2D = data.search_icon(search_string)
	if (result_icon != null): weapon_icon.texture = result_icon
	purchase_button.visible = !unlock_tracking.is_unlocked
	upgrade_button.visible = unlock_tracking.is_unlocked
	select_button.visible = unlock_tracking.is_unlocked

	upgrade_button.disabled = true
	purchase_button.disabled = true
	# label_description.text = _data.description


func enable_selection(val: bool) -> void:
	can_select = val


func set_card_info(_data: WeaponUnlockTracking) -> void:
	data = WeaponManager.get_weapon_by_id(unlock_tracking.id)
	if (data == null): return
	label_name.text = data.name
	# label_description.text = _data.description


func update_progress():
	return
	# if (upgrade == null): return
	# var current_quantity: int = MetaProgression.get_upgrade_count(upgrade.id)
	# var is_upgrade_maxed = current_quantity >= upgrade["max_quantity"]
	# var currency = MetaProgression.get_currency()
	# var percent = currency /  upgrade.experience_cost
	# percent = min(percent, 1)
	# progress_bar.value = percent
	# var is_enough_to_upgrade = percent < 1
	# purchase_button.disabled = is_enough_to_upgrade || is_upgrade_maxed
	# label_progress.text = "%d/%d" % [floori(currency), upgrade.experience_cost]
	# label_purchase_count.text = "x%d" % current_quantity
	# if (is_upgrade_maxed):
	# 	purchase_button.text = "Max"


func show_card() -> void:
	_tween_show_card()


func _tween_show_card() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, tween_duration).from(0)
	tween.tween_property(self, "scale", Vector2(1, 1), tween_duration).from(Vector2(0.5, 1.25))


func _on_purchase_pressed():
	return
	# if (upgrade == null): return
	# var currency = MetaProgression.get_currency()
	# if (currency < upgrade.experience_cost): return
	# MetaProgression.update_currency(upgrade.experience_cost * -1)
	# MetaProgression.add_meta_upgrade(upgrade)
	# get_tree().call_group("meta_upgrade_card", "update_progress")


func _on_upgrade_pressed():
	pass


func _on_select_pressed():
	# save the chosen weapon
	WeaponManager.current_weapon_id = data.id
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
