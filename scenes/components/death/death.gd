extends Node2D
class_name ComponentDeath

@onready var hit_audio_player: RandomAudioPlayer2D = $hit_random_audio_player_2d
@onready var timer: Timer = $timer

@export var comp_health: ComponentHealth
@export var sprite: Sprite2D


func _ready() -> void:
	self.name = "death"
	#gpu_particle.texture = sprite.texture
	comp_health.died.connect(_on_died)
	timer.timeout.connect(_on_timeout)


# Remove entity from the game but still play death animation
func _on_died():
	if (owner == null || not owner is Node2D): return
	timer.start()
	
	var spawn_pos: Vector2 = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_pos
	
	hit_audio_player.play_random()
	# TODO play death animation
	
	#animation_player.play("default")
	

func _on_timeout():
	queue_free()
