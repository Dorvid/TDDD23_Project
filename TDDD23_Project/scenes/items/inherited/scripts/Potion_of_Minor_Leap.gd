extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_jump(1.05)
