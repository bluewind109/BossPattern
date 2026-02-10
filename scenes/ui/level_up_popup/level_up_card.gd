extends PanelContainer
class_name CardLevelUp

signal card_selected(upgrade: Res_LevelUpUpgrade)

@onready var hover_sfx: RandomAudioPlayer = $hover_sfx
@onready var click_sfx: RandomAudioPlayer = $click_sfx

@export var label_name: Label
@export var label_description: Label
@export var button_component: Button

var popup_ref: LevelUpPopup
var upgrade: Res_LevelUpUpgrade

# short duration = game with fast level up for urgency
# long duration = game with slower level up for more impact
var tween_duration: float = 0.25

# enable when tween animation is done
var can_select: bool = false


func _ready() -> void:
	self.name = "level_up_card"
	pivot_offset = size / 2
	button_component.toggled.connect(_on_button_toggled)
	button_component.mouse_entered.connect(_on_mouse_entered)
	self.modulate.a = 0
	can_select = false


func init(_upgrade: Res_LevelUpUpgrade):
	if (_upgrade == null): return
	upgrade = _upgrade
	label_name.text = _upgrade.name
	label_description.text = _upgrade.desc


func enable_selection(val: bool) -> void:
	can_select = val


func set_card_info(_upgrade: Res_LevelUpUpgrade) -> void:
	label_name.text = _upgrade.name
	label_description.text = _upgrade.desc


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
	pivot_offset = size / 2
	var button_tween = create_tween()
	if (_toggled_on):
		if (click_sfx): click_sfx.play_random()
		button_tween.set_trans(Tween.TRANS_SINE)
		button_tween.set_ease(Tween.EASE_IN)
		button_tween.tween_property(self, "scale", Vector2(1.1, 1.1), button_tween_duration)
	else:
		button_tween.set_trans(Tween.TRANS_SINE)
		button_tween.set_ease(Tween.EASE_IN)
		button_tween.tween_property(self, "scale", Vector2(1, 1), button_tween_duration)
	
	# popup_ref.on_card_selected.emit()
	card_selected.emit(upgrade)


func _on_mouse_entered():
	if (hover_sfx): hover_sfx.play_random()
