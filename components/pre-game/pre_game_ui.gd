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
		&"percentage_increase": 3.0,
		&"max_level": 9,
	},
	&"inventory": {
		&"node": %InvButton,
		&"base_value": 100,
		&"percentage_increase": 1.5,
		&"max_level": 100,
	},
}

const COST_RESTOCKING = 25

var placed_restocking_pins = 0

func _ready():
	Global.cash_updated.connect(_cash_updated)
	Global.player_upgrades_updated.connect(_player_upgrades_updated)
	_render_ui(Global.cash, Global.player_upgrades)
	update_restock_cost()

func _cash_updated(cash: int):
	_render_ui(cash, Global.player_upgrades)

func _player_upgrades_updated(player_upgrades):
	_render_ui(Global.cash, player_upgrades)

func _render_ui(cash: int, player_upgrades):
	%CashLabel.text = "Cash: " + str(cash)
	%SpeedLabel.text = "Speed: " + str(player_upgrades.speed)
	%RepairLabel.text = "Repair: " + str(player_upgrades.repair) + "/" + str(upgrade_map.repair.max_level)
	%InvLabel.text = "Inventory: " + str(player_upgrades.inventory)
	
	%SpeedButton.text = "+ Speed\n- %s cash" % int(_calculate_price_increase(&"speed", player_upgrades.speed))
	%RepairButton.text = "+ Repair\n- %s cash" % int(_calculate_price_increase(&"repair", player_upgrades.repair))
	%InvButton.text = "+ Inventory\n- %s cash" % int(_calculate_price_increase(&"inventory", player_upgrades.inventory))

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

func update_restock_cost():
	var cost = _calculate_cost_of_restock_count(placed_restocking_pins)
	%RestockPriceLabel.text = "Next toolbox cost: " + str(cost if cost != 0 else "FREE")

func _calculate_cost_of_restock_count(amount_of_points: int) -> int:
	if amount_of_points == 0:
		return 0
	return pow(COST_RESTOCKING, amount_of_points)

func _on_start_button_pressed() -> void:
	var restocking_coords = []
	for child in %RestockingPoints.get_children():
		restocking_coords.append(child.global_position)
	if restocking_coords.is_empty():
		%Popup.show_message("Place at least one (FREE) toolbox before starting the game.\nClick on the map to place one.")
		return
	var restocking_cost = _calculate_cost_of_restock_count(placed_restocking_pins - 1)
	if Global.cash < restocking_cost:
		%Popup.show_message("You can't afford this many toolboxes.\nPress 'Reset toolboxes' to try again.")
		return
	Global.cash -= restocking_cost
	Global.restocking_coords = restocking_coords
	Global.load_game()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_down") && placed_restocking_pins <= 10:
		var i = Global.get_pin_instance()
		var camera = $"../../Camera2D"
		i.position = camera.get_global_mouse_position()
		%RestockingPoints.add_child(i)
		Global.sfx.play_sfx("pop")
		placed_restocking_pins += 1
		update_restock_cost()

func _on_reset_restocking_button_pressed() -> void:
	for child in %RestockingPoints.get_children():
		child.call_deferred("queue_free")
	placed_restocking_pins = 0
	update_restock_cost()

func _on_main_menu_button_pressed() -> void:
	Global.load_game("res://components/main_menu/main_menu.tscn")
