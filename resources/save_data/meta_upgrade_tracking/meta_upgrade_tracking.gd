extends Resource
class_name MetaUpgradeTracking

var id: UpgradeDefine.META_UPGRADE_ID
var quantity: int = 0
var upgrade_value: float = 0


func init(_id: UpgradeDefine.META_UPGRADE_ID, _quantity: int, _upgrade_value: float):
	id = _id
	quantity = _quantity
	upgrade_value = _upgrade_value


func upgrade_quantity(number: int):
	quantity += number
