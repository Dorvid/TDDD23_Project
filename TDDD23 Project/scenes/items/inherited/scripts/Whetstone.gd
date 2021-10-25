extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_base_dmg(1)
	CharacterController.unlocked_array[5] = true
