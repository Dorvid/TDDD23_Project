extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_base_rdmg(2)
	CharacterController.unlocked_array[4] = true
