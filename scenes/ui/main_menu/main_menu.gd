extends CanvasLayer
class_name MainMenu

@onready var play_button: SoundButton = $%play_button
@onready var options_button: SoundButton = $%options_button
@onready var quit_button: SoundButton = $%quit_button

@export var options_menu_scene: PackedScene


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_options_pressed():
	# TODO add options menu
	var options_menu = options_menu_scene.instantiate() as OptionsMenu
	add_child(options_menu)
	options_menu.back_pressed.connect(_on_back_pressed.bind(options_menu))
	

func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed(options_menu: OptionsMenu):
	options_menu.queue_free()
