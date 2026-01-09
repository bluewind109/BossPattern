extends CanvasLayer
class_name MetaMenu

signal back_pressed

@export var meta_upgrade_card_scene: PackedScene
@export var upgrades: Array[Res_MetaUpgrade]= []

@onready var back_button: SoundButton = $%back_button
@onready var card_container: GridContainer = $%card_grid_container


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	
	for child in card_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var meta_upgrade_card = meta_upgrade_card_scene.instantiate() as MetaUpgradeCard
		card_container.add_child(meta_upgrade_card)
		meta_upgrade_card.init(upgrade)
		meta_upgrade_card.show_card()
