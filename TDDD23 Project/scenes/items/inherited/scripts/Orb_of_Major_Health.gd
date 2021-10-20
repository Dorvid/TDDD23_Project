extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.change_total_hp(3)
