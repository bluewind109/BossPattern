extends Area2D
class_name ComponentHitbox

@export var owner_ref: Node2D

@export var damage_amount: float = 1.0

signal hit(hurtbox: ComponentHurtbox, amount: float)

var max_speed: float = 100.0

var direction: Vector2 = Vector2.ZERO

func _init() -> void:
	# self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_hurtbox_entered)

func _ready() -> void:
	pass

func _on_hurtbox_entered(hurtbox: ComponentHurtbox) -> void:
	if (owner_ref == null): return
	hurtbox.take_damage(damage_amount)
	hit.emit(hurtbox, damage_amount)
