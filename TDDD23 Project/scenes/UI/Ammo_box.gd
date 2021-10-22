extends Control

func _ready():
	$NinePatchRect/Label.text = str(CharacterController.get_ammo())
	if CharacterController.connect("ammo_update",self,"update_label") != OK:
		print("Could not connect to signal ammo_update in RDmg_box")
	
func update_label():
	$NinePatchRect/Label.text = str(CharacterController.get_ammo())

