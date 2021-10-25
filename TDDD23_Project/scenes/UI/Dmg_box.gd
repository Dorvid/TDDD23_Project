extends Control


func _ready():
	$NinePatchRect/Label.text = str(CharacterController.get_player_dmg())
	if CharacterController.connect("damage_change",self,"update_label") != OK:
		print("Could not connect to signal damage_change in Dmg_box")
	
func update_label():
	$NinePatchRect/Label.text = str(CharacterController.get_player_dmg())
	
