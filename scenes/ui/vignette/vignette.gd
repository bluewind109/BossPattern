extends CanvasLayer
class_name Vignette

@onready var animation_player: AnimationPlayer = $animation_player
@onready var color_rect: ColorRect = $color_rect

var normal_color: Color = Color(0.247, 0.149, 0.192, 1.0)
var hurt_color: Color = Color(0.98, 0.008, 0.259, 1.0)


func _ready() -> void:
	GameEvents.player_damaged.connect(_on_player_damaged)
	

func _on_player_damaged():
	animation_player.play("hit")
