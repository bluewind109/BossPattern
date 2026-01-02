extends CanvasLayer
class_name EndScreen

@onready var restart_button: Button = $%button_restart
@onready var quit_button: Button = $%button_quit


func _ready() -> void:
	get_tree().paused = true
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	

func _on_quit_button_pressed():
	get_tree().quit()
