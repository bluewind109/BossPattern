extends PanelContainer
class_name MetaUpgradeCard

signal card_selected(upgrade: Res_AbilityUpgrade)

@onready var click_sfx: RandomAudioPlayer = $click_sfx

@onready var upgrade_icon: TextureRect = $%upgrade_icon
@onready var label_progress: Label = $%label_progress
@onready var purchase_button: SoundButton = $%purchase_button
@onready var progress_bar: ProgressBar = $%upgrade_progress_bar

@export var label_name: Label
@export var label_description: Label

var upgrade: Res_MetaUpgrade

# short duration = game with fast level up for urgency
# long duration = game with slower level up for more impact
var tween_duration: float = 0.25

# enable when tween animation is done
var can_select: bool = false


func _ready() -> void:
	self.name = "meta_upgrade_card"

	purchase_button.pressed.connect(_on_purchase_pressed)

	pivot_offset = size / 2
	self.modulate.a = 0
	can_select = false
	update_progress.call_deferred()
	#show_card.call_deferred()


func init(_upgrade: Res_MetaUpgrade):
	if (_upgrade == null): return
	upgrade = _upgrade
	label_name.text = _upgrade.title
	label_description.text = _upgrade.description


func enable_selection(val: bool) -> void:
	can_select = val


func set_card_info(_upgrade: Res_MetaUpgrade) -> void:
	label_name.text = _upgrade.title
	label_description.text = _upgrade.description


func update_progress():
	if (upgrade == null): return
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency /  upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1
	label_progress.text = str(floori(currency)) + "/" + str(upgrade.experience_cost)


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
	if (upgrade == null): return
	if (MetaProgression.save_data["meta_upgrade_currency"] < upgrade.experience_cost): return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	get_tree().call_group("meta_upgrade_card", "update_progress")
