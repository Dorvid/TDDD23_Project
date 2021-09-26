extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func crowd_play():
	$Crowd.play()
	
func crowd_stop():
	$Crowd.stop()
