extends Panel
class_name CardLevelUp

signal selected(upgrade: Res_AbilityUpgrade)

@export var label_name: Label
@export var label_description: Label
@export var button_component: Button
@export var sound_click: AudioStreamPlayer

var popup_ref: LevelUpPopup
var upgrade: Res_AbilityUpgrade

# short duration = game with fast level up for urgency
# long duration = game with slower level up for more impact
var tween_duration: float = 0.25

# enable when tween animation is done
var can_select: bool = false


func _ready() -> void:
	button_component.toggled.connect(_on_button_toggled)
	self.modulate.a = 0
	can_select = false
	pivot_offset = size * Vector2(0.5, 0.5)


func init(_upgrade: Res_AbilityUpgrade):
	upgrade = _upgrade
	label_name.text = _upgrade.name
	label_description.text = _upgrade.desc


func enable_selection(val: bool) -> void:
	can_select = val


func set_card_info(upgrade: Res_AbilityUpgrade) -> void:
	label_name.text = upgrade.name
	label_description.text = upgrade.desc


func show_card() -> void:
	_tween_show_card()


func _tween_show_card() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, tween_duration).from(0)
	tween.tween_property(self, "scale", Vector2(1, 1), tween_duration).from(Vector2(0.5, 1.25))


var button_tween_duration: float = 0.075
func _on_button_toggled(_toggled_on: bool) -> void:
	var button_tween = create_tween()
	if (_toggled_on):
		sound_click.play()
		button_tween.set_trans(Tween.TRANS_SINE)
		button_tween.set_ease(Tween.EASE_IN)
		button_tween.tween_property(self, "scale", Vector2(1.1, 1.1), button_tween_duration)
	else:
		button_tween.set_trans(Tween.TRANS_SINE)
		button_tween.set_ease(Tween.EASE_IN)
		button_tween.tween_property(self, "scale", Vector2(1, 1), button_tween_duration)
	
	# popup_ref.on_card_selected.emit()
	selected.emit(upgrade)
