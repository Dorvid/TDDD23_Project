extends "res://scenes/items/Base_item.gd"


func remove_item():
	CharacterController.set_gold_multiplier(1.25)
	CharacterController.unlocked_array[2] = true
