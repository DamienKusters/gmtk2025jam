extends Control
class_name UI

@export var player: Player

func _ready() -> void:
	player.inventory_repair_packs_updated.connect(update_inventory)
	player.holes_patched_updated.connect(update_score)

func update_inventory(amount: int):
	$Margin/Inventory/Label.text = "Repair Packs: " + str(amount)

func update_score(amount: int):
	$Margin/Inventory/Label2.text = "Score: " + str(amount)
