extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_base_hp(2)
