extends Node

var crowd_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func leave_arena():
	crowd_stop()

#Crowd
func crowd_play():
	if crowd_active == false:
		$Crowd.play()
		crowd_active = true

func crowd_stop():
	$Crowd.stop()
	crowd_active = false
