extends Node

var base_hp = 5
var base_dmg = 3
var base_gold = 0



func _ready():
	#TODO: Load save file
	pass # Replace with function body.

func crowd_play():
	$Crowd.play()
	
func crowd_stop():
	$Crowd.stop()
