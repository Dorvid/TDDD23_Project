extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_dmg(1)
	
