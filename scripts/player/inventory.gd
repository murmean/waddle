extends Node

var inventory = []

signal inventory_updated

var player_node: Node = null

func _ready():
	#initialize inventory with x slots
	inventory.resize(30)
	
func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		return false
	
	
func remove_item():
	inventory_updated.emit()
	
func increase_inventory():
	inventory_updated.emit()
	
func set_player_reference(player):
	player_node = player
