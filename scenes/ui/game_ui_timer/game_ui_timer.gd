extends CanvasLayer
class_name GameUiTimer

@export var end_screen_scene: PackedScene

@onready var game_timer: Timer = $game_timer
@onready var count_down_timer: Timer = $count_down_timer
@onready var label_game_time: Label = $%label_game_time
var current_time: float = 0.0


func _ready() -> void:
	count_down_timer.timeout.connect(_on_count_down_finished)
	current_time = 0.0
	update_game_time()


func _process(delta: float) -> void:
	if (!get_tree().paused):
		current_time += delta
	update_game_time()


func update_game_time():
	var total_seconds = int(current_time) % 60
	var total_minutes = int(current_time) / 60
	label_game_time.text = "%02d:%02d" % [total_minutes, total_seconds]


func _on_count_down_finished():
	#var end_screen = end_screen_scene.instantiate()
	#add_child(end_screen)
	pass
