extends Area2D
class_name ComponentHitbox

signal hit(hurtbox: ComponentHurtbox, amount: float)

@export var damage_amount: float = 0.0

var collision_shape: CollisionShape2D = null
var max_speed: float = 100.0
var direction: Vector2 = Vector2.ZERO


func _init() -> void:
	# self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_hurtbox_entered)


func _ready() -> void:
	if (get_child_count() > 0):
		for child in get_children():
			if (child is CollisionShape2D):
				collision_shape = child


func toggle_collision(val: bool):
	if (collision_shape == null): return
	collision_shape.disabled = !val


func set_damage(val: float):
	damage_amount = val


func get_damage():
	return damage_amount


func _on_hurtbox_entered(area: Area2D) -> void:
	if (area is ComponentHurtbox):
		# print(get_parent().name, " _on_hurtbox_entered ", area.get_parent().name)
		var hurtbox: ComponentHurtbox = area
		hurtbox.take_damage(damage_amount)
		hit.emit(hurtbox, damage_amount)
