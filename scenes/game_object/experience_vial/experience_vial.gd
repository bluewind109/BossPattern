extends Node2D
class_name ExperienceVial

@onready var collision_shape: CollisionShape2D = $area_2d/collision_shape_2d
@onready var sprite: Sprite2D = $sprite_2d
@onready var collect_vial_sfx: RandomAudioPlayer2D = $collect_vial_sfx

var base_exp_gain: float = 1.0


func _ready() -> void:
	self.name = "ExperienceVial"
	$area_2d.area_entered.connect(_on_area_entered)


func _tween_collect(percent: float, start_pos: Vector2):
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null: return

	global_position = start_pos.lerp(player.global_position, percent)

	# pointed toward player on collected
	var direction_from_start = player.global_position - start_pos 
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(
		rotation, target_rotation, 1 - exp(-2 * get_process_delta_time())
	)


func _disable_collision():
	collision_shape.disabled = true


func _on_area_entered(other_area: Area2D):
	Callable(_disable_collision).call_deferred()

	var duration_1: float = 0.5
	var duration_2: float = 0.05

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(_tween_collect.bind(global_position), 0.0, 1.0, duration_1)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, duration_2).set_delay(duration_1 - duration_2)
	tween.chain()
	tween.tween_callback(func():
		var	exp_gain_upgrade_quantity = MetaProgression.get_upgrade_count(UpgradeDefine.META_UPGRADE_ID.EXPERIENCE_GAIN)
		var exp_gain_value = MetaProgression.get_upgrade_value(UpgradeDefine.META_UPGRADE_ID.EXPERIENCE_GAIN)
		var final_exp_gain = base_exp_gain + base_exp_gain * exp_gain_upgrade_quantity * exp_gain_value
		GameEvents.emit_exp_vial_collected(final_exp_gain)
		if (collect_vial_sfx != null):
			collect_vial_sfx.play_random()
			await collect_vial_sfx.finished # if there is error, move the play_random outside of callback
		queue_free()
	)
	
