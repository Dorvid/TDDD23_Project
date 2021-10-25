extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.set_avoidance(0.05)
