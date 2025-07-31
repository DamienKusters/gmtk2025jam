extends Control
class_name UI

@export var player: Player

func _ready() -> void:
	player.inventory_repair_packs_updated.connect(update_inventory)

func update_inventory(amount: int):
	$Margin/Inventory/Label.text = "Repair Packs: " + str(amount)
