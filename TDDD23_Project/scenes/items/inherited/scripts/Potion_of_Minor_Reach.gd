extends "res://scenes/items/Base_item.gd"


func remove_item():
	CharacterController.increase_range(1.05)
