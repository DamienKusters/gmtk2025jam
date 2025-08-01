extends Control

@onready var upgrade_map = {
	&"speed": {
		&"node": %SpeedButton,
		&"base_value": 100,
		&"percentage_increase": .5,
		&"max_level": 100,
	},
	&"repair": {
		&"node": %RepairButton,
		&"base_value": 100,
		&"percentage_increase": 2.5,
		&"max_level": 8,
	},
	&"inventory": {
		&"node": %InvButton,
		&"base_value": 100,
		&"percentage_increase": 1.5,
		&"max_level": 100,
	},
}

func _ready():
	Global.cash_updated.connect(_cash_updated)
	Global.player_upgrades_updated.connect(_player_upgrades_updated)
	_render_ui(Global.cash, Global.player_upgrades)

func _cash_updated(cash: int):
	_render_ui(cash, Global.player_upgrades)

func _player_upgrades_updated(player_upgrades):
	_render_ui(Global.cash, player_upgrades)

func _render_ui(cash: int, player_upgrades):
	%CashLabel.text = "Cash: " + str(cash)
	%SpeedLabel.text = "Speed: " + str(player_upgrades.speed)
	%RepairLabel.text = "Repair: " + str(player_upgrades.repair)
	%InvLabel.text = "Inventory: " + str(player_upgrades.inventory)
	
	%SpeedButton.text = "+ Speed\n- %s cash" % _calculate_price_increase(&"speed", player_upgrades.speed)
	%RepairButton.text = "+ Repair\n- %s cash" % _calculate_price_increase(&"repair", player_upgrades.repair)
	%InvButton.text = "+ Inventory\n- %s cash" % _calculate_price_increase(&"inventory", player_upgrades.inventory)

func _calculate_price_increase(id: String, amount_upgraded: int) -> float:
	# TODO: use current value in price increase? or no?
	var added_value = (upgrade_map[id].base_value * amount_upgraded) * upgrade_map[id].percentage_increase
	return float(upgrade_map[id].base_value) + added_value

# this is the worst function in the game
func upgrade_bought(id: String):
	var price = _calculate_price_increase(id, Global.player_upgrades[id])
	if Global.player_upgrades[id] < upgrade_map[id].max_level and Global.cash >= price:
		Global.cash -= price
		Global.player_upgrades[id] += 1
		Global.player_upgrades = Global.player_upgrades # Cringe way to trigger event :)

func _on_start_button_pressed() -> void:
	Global.load_game()
