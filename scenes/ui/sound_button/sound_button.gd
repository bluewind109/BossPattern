extends Button
class_name SoundButton

@onready var random_audio_player: RandomAudioPlayer = $random_audio_player


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed():
	if (random_audio_player): random_audio_player.play_random()
