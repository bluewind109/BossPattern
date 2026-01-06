extends CanvasLayer
class_name LevelUpPopup

@onready var dark_background: ColorRect = $%dark_background

@export var card_prefab: PackedScene
@export var panel: Panel
@export var card_container: HBoxContainer
@export var button_container: HBoxContainer

@onready var button_reroll: SoundButton = $%button_reroll
@onready var button_ok: SoundButton = $%button_ok

@onready var pop_sfx: AudioStreamPlayer = $pop_sfx
@onready var level_up_sfx: AudioStreamPlayer = $level_up_sfx
#@export var sound_ok: AudioStreamPlayer

var show_duration: float = 0.5
var is_animation_done: bool = false
var is_card_selected: bool = false

var card_pool: Array[CardLevelUp]
var selected_card: Res_AbilityUpgrade

signal on_panel_shown
signal on_card_shown
signal on_button_shown
signal upgrade_selected(upgrade: Res_AbilityUpgrade)
signal reroll_upgrades


func _ready() -> void:
	GameEvents.emit_game_paused(true)
	# on_card_selected.connect(_on_card_selected)

	if (button_reroll): button_reroll.pressed.connect(_on_button_reroll)
	if (button_ok): button_ok.pressed.connect(_on_button_ok)
	if (level_up_sfx): level_up_sfx.play()
	

func _reset_cards() -> void:
	for i in card_container.get_children():
		card_container.remove_child(i)
		i.queue_free()


func set_ability_upgrades(upgrades: Array[Res_AbilityUpgrade]):
	card_pool = []
	for upgrade in upgrades:
		if (upgrade == null): continue
		var card_instance = card_prefab.instantiate() as CardLevelUp
		card_instance.popup_ref = self
		card_instance.init(upgrade)
		card_instance.card_selected.connect(_on_card_selected)
		card_pool.append(card_instance)


func show_popup() -> void:
	print("show_popup")
	is_animation_done = false
	dark_background.modulate.a = 0
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
	tween.tween_property(dark_background, "modulate:a", 1, show_panel_duration).from(0)
	tween.tween_callback(func():
		on_panel_shown.emit()
	)


func _tween_show_card(callback: Callable = Callable()) -> void:
	if (card_prefab == null): return
	is_animation_done = false
	is_card_selected = false
	button_ok.disabled = true
	_reset_cards()
	card_container.modulate.a = 1
	if (pop_sfx): pop_sfx.pitch_scale = 0.25
	for i in card_pool.size():
		card_container.add_child.call_deferred(card_pool[i])
		card_pool[i].enable_selection(false)
	
	for i in card_pool.size():
		card_pool[i].show_card.call_deferred()
		pop_sfx.play()
		pop_sfx.pitch_scale += 0.25
		await get_tree().create_timer(card_pool[i].tween_duration).timeout

	for i in card_pool.size():
		card_pool[i].enable_selection(true)

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
	tween_hide_panel.tween_property(dark_background, "modulate:a", 0, hide_panel_duration)


func _on_button_reroll() -> void:
	print("_on_button_reroll")
	if (not is_animation_done): return
	# reroll cards with new stats
	# sound_ok.pitch_scale = 0.8
	# sound_ok.play()
	reroll_upgrades.emit()
	_tween_show_card(func(): is_animation_done = true)


func _on_button_ok() -> void:
	print("_on_button_ok")
	if (!is_animation_done): return
	if (!is_card_selected): return
	if (selected_card == null): return
	_tween_hide_panel()
	is_card_selected = false
	is_animation_done = false
	# sound_ok.pitch_scale = 1.0
	# sound_ok.play()
	upgrade_selected.emit(selected_card)
	tween_hide_panel.tween_callback(func():
		print("hide done")
		# TODO Whatever logic you want to put in
		# Unpause the game after tween animation is done
		GameEvents.emit_game_paused(false)
		queue_free()
	)


func _on_card_selected(_upgrade: Res_AbilityUpgrade) -> void:
	if (_upgrade == null): return
	print("_on_card_selected ", _upgrade.name)
	selected_card = _upgrade
	is_card_selected = true
	button_ok.disabled = false
