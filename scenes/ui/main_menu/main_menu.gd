extends CanvasLayer
class_name MainMenu

@onready var play_button: SoundButton = $%play_button
@onready var options_button: SoundButton = $%options_button
@onready var quit_button: SoundButton = $%quit_button


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_options_pressed():
	# TODO add options menu
	pass
	

func _on_quit_pressed():
	get_tree().quit()
