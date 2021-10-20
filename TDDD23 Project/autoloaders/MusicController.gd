extends Node

var crowd_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func leave_arena():
	$Crowd.volume_db = -50

#Crowd
func crowd_play():
	if crowd_active == false:
		$Crowd.play()
		crowd_active = true

func crowd_stop():
	$Crowd.stop()
	crowd_active = false


func _on_Crowd_finished():
	$Crowd.volume_db = -25

func fight_play():
	$Fight.play()

func fight_stop():
	$Fight/Tween.interpolate_property($Fight,"volume_db",-25,-80,2,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Fight/Tween.start()

func _on_Tween_tween_completed(_object, _key):
	$Fight.stop()
	$Fight.set_volume_db(-25)
