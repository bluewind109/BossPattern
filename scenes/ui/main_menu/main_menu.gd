extends CanvasLayer
class_name MainMenu

@onready var play_button: SoundButton = $%play_button
@onready var upgrade_button: SoundButton = $%upgrade_button
@onready var options_button: SoundButton = $%options_button
@onready var quit_button: SoundButton = $%quit_button

@export var options_menu_scene: PackedScene

var is_animation_done: bool = true


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed():
	if (!is_animation_done): return
	is_animation_done = false
	ScreenTransition.start_transition(func(): 
		# get_tree().change_scene_to_file("res://scenes/game/game.tscn")
		get_tree().change_scene_to_file("res://scenes/ui/weapon_selection_menu/weapon_selection_menu.tscn")
	)


func _on_upgrade_pressed():
	ScreenTransition.start_transition(func(): 
		get_tree().change_scene_to_file("res://scenes/ui/meta_menu/meta_menu.tscn")

	)
	#await ScreenTransition.transitioned_halfway


func _on_options_pressed():
	ScreenTransition.start_transition(func(): 
		var options_menu = options_menu_scene.instantiate() as OptionsMenu
		add_child(options_menu)
		options_menu.back_pressed.connect(_on_back_pressed.bind(options_menu))
	)
	

func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed(menu):
	ScreenTransition.start_transition(func(): 
		menu.queue_free()
	)
