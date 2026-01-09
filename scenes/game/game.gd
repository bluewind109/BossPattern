extends Node
class_name GameManager

@export var pause_menu_scene: PackedScene
@export var end_screen_scene: PackedScene

@onready var player: Player = $%player
@onready var explosion_container: Node2D = $%explosion_container

var is_paused: bool = false


func _ready() -> void:
	player.comp_health.died.connect(_on_player_died)
	GameEvents.explosion_created.connect(_on_explosion_created)
	GameEvents.game_paused.connect(_on_game_paused)


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("escape")):
		_show_pause_menu()


func _show_pause_menu():
	if (is_paused): return
	var pause_menu = pause_menu_scene.instantiate() as PauseMenu
	get_tree().current_scene.add_child(pause_menu)
	pause_menu.show_popup.call_deferred()


func _on_explosion_created(target: Explosion):
	explosion_container.add_child(target)


func _on_player_died():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	end_screen.set_defeat.call_deferred()
	MetaProgression.save()


func _on_game_paused(val: bool):
	BgmPlayer.set_pause_volume(val)
	is_paused = val
