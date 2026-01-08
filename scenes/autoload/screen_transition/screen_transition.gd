extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $animation_player

var skip_emit: bool = false


func transition():
	animation_player.play("default")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards("default")


func emit_transitioned_halfway():
	if (skip_emit ==  true): 
		skip_emit = false
		return
	transitioned_halfway.emit()
