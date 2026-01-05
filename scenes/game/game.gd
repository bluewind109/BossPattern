extends Node2D
class_name GameManager

@export var end_screen_scene: PackedScene

@onready var player: Player = $%player
@onready var explosion_container: Node2D = $%explosion_container


func _ready() -> void:
	player.comp_health.died.connect(_on_player_died)
	SignalManager.on_explosion_created.connect(_on_explosion_created)


func _on_explosion_created(target: Explosion):
	explosion_container.add_child(target)


func _on_player_died():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	end_screen.set_defeat.call_deferred()
