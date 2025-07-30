extends Area2D
class_name ComponentHitbox

@export var owner_ref: Node2D

func _init() -> void:
	# self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_hurtbox_entered)

func _ready() -> void:
	pass

func _on_hurtbox_entered() -> void:
	if (owner_ref == null): return

func _on_body_entered(body: Node2D) -> void:
	if (owner_ref == null): return
	# if ("damage" in body):
	# 	# print("_on_body_entered")
	# 	var kb_strength: float = 0.0
	# 	var kb_direction: Vector2 = Vector2.RIGHT
	# 	var is_crit: bool = false
	# 	if ("knockback" in body): kb_strength = body.knockback
	# 	if ("direction" in body): kb_direction = body.direction
	# 	if ("is_crit" in body): is_crit = body.is_crit
	# 	take_damage.emit(body.damage, kb_strength, kb_direction, is_crit)

func _on_area_entered(area: Area2D) -> void:
	if (owner_ref == null): return
	# if ("damage" in area):
	# 	# print("_on_area_entered")
	# 	var kb_strength: float = 0.0
	# 	var kb_direction: Vector2 = Vector2.RIGHT
	# 	var is_crit: bool = false
	# 	if ("knockback" in area): kb_strength = area.knockback
	# 	if ("direction" in area): kb_direction = area.direction
	# 	if ("is_crit" in area): is_crit = area.is_crit
	# 	take_damage.emit(area.damage, kb_strength, kb_direction, is_crit)
