extends CanvasLayer
class_name PauseMenu

@onready var dark_background: ColorRect = $%dark_background
@onready var resume_button: SoundButton = $%resume_button
@onready var options_button: SoundButton = $%options_button
@onready var quit_button: SoundButton = $%quit_button

@export var options_menu_scene: PackedScene
@export var panel: PanelContainer

var show_panel_duration: float = 0.25
var hide_panel_duration: float = 0.125
var is_animation_done: bool = false

var tween_hide_panel: Tween

signal on_panel_shown
signal on_panel_hidden


func _ready() -> void:
	GameEvents.emit_game_paused(true)
	
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	is_animation_done = false
	dark_background.modulate.a = 0
	panel.modulate.a = 0


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("escape")):
		hide_popup()


func show_popup():
	is_animation_done = false
	dark_background.modulate.a = 0
	panel.modulate.a = 0
	_tween_show_panel()
	await on_panel_shown
	is_animation_done = true


func _tween_show_panel() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	#tween.tween_property(panel, "position:y", 0, show_panel_duration).from(-250)
	tween.tween_property(panel, "modulate:a", 1, show_panel_duration).from(0)
	tween.tween_property(dark_background, "modulate:a", 1, show_panel_duration).from(0)
	tween.tween_callback(func():
		on_panel_shown.emit()
	)


func hide_popup():
	if (!is_animation_done): return
	is_animation_done = false
	_tween_hide_panel()
	await on_panel_hidden
	is_animation_done = true
	GameEvents.emit_game_paused(false)
	queue_free()


func _tween_hide_panel():
	if (tween_hide_panel): tween_hide_panel.kill()
	else: tween_hide_panel = create_tween()
	panel.modulate.a = 1
	tween_hide_panel.set_trans(Tween.TRANS_SINE)
	tween_hide_panel.set_ease(Tween.EASE_IN)
	tween_hide_panel.tween_property(panel, "modulate:a", 0, hide_panel_duration)
	tween_hide_panel.tween_property(dark_background, "modulate:a", 0, hide_panel_duration)
	tween_hide_panel.tween_callback(func():
		on_panel_hidden.emit()
	)

func _on_resume_pressed():
	if (!is_animation_done): return
	hide_popup()


func _on_options_pressed():
	if (!is_animation_done): return
	var options_menu = options_menu_scene.instantiate() as OptionsMenu
	add_child(options_menu)
	options_menu.back_pressed.connect(_on_back_pressed.bind(options_menu))
	

func _on_quit_pressed():
	if (!is_animation_done): return
	GameEvents.emit_game_paused(false)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func _on_back_pressed(options_menu: OptionsMenu):
	options_menu.queue_free()
