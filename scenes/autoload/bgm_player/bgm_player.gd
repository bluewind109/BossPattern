extends AudioStreamPlayer

@onready var timer: Timer = $timer


func _ready() -> void:
	finished.connect(_on_finished)
	timer.timeout.connect(_on_timeout)


func set_pause_volume(is_paused: bool):
	if (is_paused):
		volume_db = -25.0
	else:
		volume_db = -15.0


func _on_finished():
	timer.start()


func _on_timeout():
	play()
