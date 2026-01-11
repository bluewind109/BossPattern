extends Node

@export var floating_text_scene: PackedScene


func spawn_damage_text_at(
	spawn_pos: Vector2, 
	amount: float, 
	font_color: Color = Color(1, 1, 1, 1),
	outline_color: Color = Color(0, 0, 0, 1)
):
	if (floating_text_scene == null): return

	var spawn_layer = get_tree().get_first_node_in_group("foreground_layer")
	if (spawn_layer == null): spawn_layer = get_tree().current_scene

	var floating_text = floating_text_scene.instantiate() as FloatingText
	spawn_layer.add_child(floating_text)
	floating_text.global_position = spawn_pos

	floating_text.update_style(font_color, outline_color)

	var format_damage_string = "%0.2f"
	if (round(amount) == amount):
		format_damage_string = "%0.0f"
	floating_text.start(format_damage_string % amount)
