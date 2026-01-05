extends CanvasLayer
class_name EndScreen

@onready var dark_background: ColorRect = $%dark_background
@onready var panel_end: PanelContainer = $%panel_end
@onready var title_label: Label =  $%label_title
@onready var subtitle_label: Label =  $%label_subtitle
@onready var restart_button: Button = $%button_restart
@onready var quit_button: Button = $%button_quit

var show_duration: float = 0.25
var is_animation_done: bool = false

signal on_panel_shown


func _ready() -> void:
	panel_end.pivot_offset = panel_end.size / 2
	get_tree().paused = true
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	dark_background.modulate.a = 0
	panel_end.modulate.a = 0
	show_popup()


func show_popup() -> void:
	is_animation_done = false
	dark_background.modulate.a = 0
	panel_end.modulate.a = 0
	restart_button.disabled = true
	quit_button.disabled = true
	_tween_show_panel()
	await on_panel_shown
	restart_button.disabled = false
	quit_button.disabled = false
	is_animation_done = true


func _tween_show_panel() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(dark_background, "modulate:a", 1, show_duration).from(0)
	tween.tween_property(panel_end, "modulate:a", 1, show_duration).from(0)
	tween.tween_callback(func():
		on_panel_shown.emit()
	)


func set_defeat():
	title_label.text = "Defeat"
	subtitle_label.text = "You lost!"


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	

func _on_quit_button_pressed():
	get_tree().quit()
