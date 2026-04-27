extends Node
class_name GameManager

@export var pause_menu_scene: PackedScene
@export var end_screen_scene: PackedScene

@export var stage_manager: StageManager

@onready var player: Player = $%player
@onready var explosion_container: Node2D = $%explosion_container

var is_paused: bool = false


func _ready() -> void:
	stage_manager.on_stage_cleared.connect(_on_stage_cleared)

	player.comp_health.died.connect(_on_player_died)
	GameEvents.explosion_created.connect(_on_explosion_created)
	GameEvents.game_paused.connect(_on_game_paused)

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("escape")):
		show_pause_menu()

func show_pause_menu():
	if (is_paused): return
	var pause_menu = pause_menu_scene.instantiate() as PauseMenu
	get_tree().current_scene.add_child(pause_menu)
	pause_menu.show_popup.call_deferred()

func show_end_screen(is_victory: bool):
	var end_screen = end_screen_scene.instantiate() as EndScreen
	end_screen.on_continue_pressed.connect(go_to_meta_menu)
	end_screen.on_quit_pressed.connect(back_to_main_menu)

	add_child(end_screen)
	if not is_victory:
		end_screen.set_defeat.call_deferred()
	MetaProgression.save()

func _on_explosion_created(target: Explosion):
	explosion_container.add_child(target)

func _on_player_died():
	show_end_screen(false)

func _on_stage_cleared():
	show_end_screen(true)

func _on_game_paused(val: bool):
	BgmPlayer.set_pause_volume(val)
	is_paused = val

func go_to_meta_menu():
	ScreenTransition.start_transition(func(): 
		_on_game_paused(false)
		get_tree().change_scene_to_file("res://scenes/ui/meta_menu/meta_menu.tscn")
	)

func back_to_main_menu():
	ScreenTransition.start_transition(func(): 
		_on_game_paused(false)
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
	)
