extends CanvasLayer
class_name LevelUpPopup

@export var card_prefab: PackedScene
@export var panel: Panel
@export var card_container: HBoxContainer
@export var button_container: HBoxContainer

@export var button_reroll: Button
@export var button_ok: Button

@export var sound_pop: AudioStreamPlayer
@export var sound_ok: AudioStreamPlayer

var show_duration: float = 0.5
var is_animation_done: bool = false
var is_card_selected: bool = false

signal on_panel_shown
signal on_card_shown
signal on_button_shown
signal on_card_selected


func _ready() -> void:
	on_card_selected.connect(_on_card_selected)

	if (button_reroll): button_reroll.pressed.connect(_on_button_reroll)
	if (button_ok): button_ok.pressed.connect(_on_button_ok)
	
	show_popup()


func _reset_cards() -> void:
	for i in card_container.get_children():
		card_container.remove_child(i)
		i.queue_free()


func set_ability_upgrades(upgrades: Array[Res_AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = card_prefab.instantiate()
		card_container.add_child(card_instance)


func show_popup() -> void:
	print("show_popup")
	is_animation_done = false
	card_container.modulate.a = 0
	button_container.modulate.a = 0
	button_ok.disabled = true
	_tween_show_panel()
	# await get_tree().create_timer(show_panel_duration * 2).timeout
	await on_panel_shown
	_tween_show_card()
	await on_card_shown
	_tween_show_buttons()
	await on_button_shown
	is_animation_done = true


var show_panel_duration: float = 0.25
func _tween_show_panel() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(panel, "position:y", 0, show_panel_duration).from(-250)
	tween.tween_property(panel, "modulate:a", 1, show_panel_duration).from(0)
	tween.tween_callback(func():
		on_panel_shown.emit()
	)


func _tween_show_card(callback: Callable = Callable()) -> void:
	if (not card_prefab): return
	is_animation_done = false
	is_card_selected = false
	button_ok.disabled = true
	_reset_cards()
	card_container.modulate.a = 1
	var card_arr = []
	sound_pop.pitch_scale = 0.25
	for i in 3:
		var card_instance = card_prefab.instantiate() as CardLevelUp
		card_instance.popup_ref = self
		card_container.add_child.call_deferred(card_instance)
		await card_instance.ready
		card_arr.append(card_instance)
		card_instance.enable_selection(false)
	
	for i in card_arr.size():
		card_arr[i].show_card.call_deferred()
		sound_pop.play()
		sound_pop.pitch_scale += 0.25
		await get_tree().create_timer(card_arr[i].tween_duration).timeout

	for i in card_arr.size():
		card_arr[i].enable_selection(true)

	if (callback): callback.call()
	on_card_shown.emit()


var show_button_duration: float = 0.125
func _tween_show_buttons() -> void:
	var tween_show_button = create_tween()
	tween_show_button.set_trans(Tween.TRANS_SINE)
	tween_show_button.set_ease(Tween.EASE_IN)
	tween_show_button.tween_property(button_container, "modulate:a", 1, show_button_duration).from(0)
	tween_show_button.tween_callback(func(): on_button_shown.emit())


var hide_panel_duration: float = 0.125
var tween_hide_panel: Tween
func _tween_hide_panel():
	if (tween_hide_panel): tween_hide_panel.kill()
	else: tween_hide_panel = create_tween()
	panel.modulate.a = 1
	tween_hide_panel.set_trans(Tween.TRANS_SINE)
	tween_hide_panel.set_ease(Tween.EASE_IN)
	tween_hide_panel.tween_property(panel, "modulate:a", 0, hide_panel_duration)


func _on_button_reroll() -> void:
	print("_on_button_reroll")
	if (not is_animation_done): return
	# TODO reroll cards with new stats

	sound_ok.pitch_scale = 0.8
	sound_ok.play()
	_tween_show_card(func(): is_animation_done = true)


func _on_button_ok() -> void:
	print("_on_button_ok")
	if (not is_animation_done): return
	if (not is_card_selected): return
	_tween_hide_panel()
	is_card_selected = false
	is_animation_done = false
	sound_ok.pitch_scale = 1.0
	sound_ok.play()
	tween_hide_panel.tween_callback(func():
		print("hide done")
		# TODO Whatever logic you want to put in
		# TODO Unpause the game after tween animation is done
	)


func _on_card_selected() -> void:
	# print("_on_card_selected")
	is_card_selected = true
	button_ok.disabled = false
