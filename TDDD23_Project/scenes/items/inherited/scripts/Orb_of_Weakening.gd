extends "res://scenes/items/Base_item.gd"

func remove_item():
	CharacterController.set_boss_hp_scale(0.9)
