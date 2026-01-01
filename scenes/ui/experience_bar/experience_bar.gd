extends CanvasLayer
class_name ExperienceBar

@export var experience_manager: ExperienceManager
@onready var progress_bar: ProgressBar = $%exp_progress_bar


func _ready() -> void:
	progress_bar.value = 0
	experience_manager.exp_updated.connect(_on_exp_updated)


func _on_exp_updated(current_exp: float, target_exp: float):
	if (target_exp == 0): return
	var percent = current_exp / target_exp
	progress_bar.value = percent
