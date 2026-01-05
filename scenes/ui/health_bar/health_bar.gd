extends CanvasLayer
class_name HealthBar

@onready var progress_bar: ProgressBar = $%progress_bar


func _ready() -> void:
	GameEvents.update_player_health_bar.connect(_on_update_player_health_bar)


func _on_update_player_health_bar(percent: float):
	progress_bar.value = percent * progress_bar.max_value
