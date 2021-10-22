extends Control


func _ready():
	if CharacterController.has_slingshot:
		set_visible(true)
	$NinePatchRect/Label.text = str(CharacterController.get_player_rdmg())
	if CharacterController.connect("rdamage_change",self,"update_label") != OK:
		print("Could not connect to signal rdamage_change in RDmg_box")
	if CharacterController.connect("ammo_update",self,"update_visablity") != OK:
		print("Could not connect to signal ammo_update in RDmg_box")
	
func update_label():
	$NinePatchRect/Label.text = str(CharacterController.get_player_rdmg())

func update_visablity():
	if !visible:
		set_visible(true)
