extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.increase_dmg(2)
	CharacterController.change_total_hp(-1)
