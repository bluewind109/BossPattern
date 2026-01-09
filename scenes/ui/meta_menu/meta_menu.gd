extends CanvasLayer
class_name MetaMenu

@export var meta_upgrade_card_scene: PackedScene
@export var upgrades: Array[Res_MetaUpgrade]= []

@onready var card_container: GridContainer = $%card_grid_container


func _ready() -> void:
	for upgrade in upgrades:
		var meta_upgrade_card = meta_upgrade_card_scene.instantiate() as MetaUpgradeCard
		card_container.add_child(meta_upgrade_card)
		meta_upgrade_card.init(upgrade)
		meta_upgrade_card.show_card()
