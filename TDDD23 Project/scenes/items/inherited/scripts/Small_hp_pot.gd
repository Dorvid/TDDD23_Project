extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.heal_hp(1)
