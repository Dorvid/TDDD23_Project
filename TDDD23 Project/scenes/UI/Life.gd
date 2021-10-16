extends Control

export (PackedScene) var Heart
var hp
var total_hp

# Called when the node enters the scene tree for the first time.

func _ready():
	total_hp = CharacterController.total_hp()
	$Bar/ProgressBar.set_max(total_hp)
	hp = CharacterController.get_current_hp()
	if CharacterController.connect("damage_taken",self,"_damage_taken") != OK:
		print("Could not connect to signal damage_taken in Life.gd")
	if CharacterController.connect("hp_increase",self,"_hp_increase") != OK:
		print("Could not connect to signal hp_increase in Life.gd")
	if CharacterController.connect("heal",self,"_heal") != OK:
		print("Could not connect to signal heal in Life.gd")
	update_text(hp,total_hp)


func _damage_taken():
	hp -= 1
	update_text(hp,total_hp)

func _hp_increase():
	var new_total_hp = CharacterController.total_hp()
	#Heals player for ammount received
	hp += new_total_hp - total_hp
	total_hp = new_total_hp
	$Bar/ProgressBar.set_max(total_hp)
	update_text(hp,total_hp)

func _heal():
	hp = CharacterController.get_current_hp()
	update_text(hp,total_hp)

func update_text(a,b):
	$Bar/Label.text = str(a) + "/" + str(b)
	$Bar/ProgressBar.value = a

func _on_Timer_timeout():
	print($Bar/TextureProgress.value)
	$Bar/TextureProgress.value -= 1
	print($Bar/TextureProgress.value)
	
