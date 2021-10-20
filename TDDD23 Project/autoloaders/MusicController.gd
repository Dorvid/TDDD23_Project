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
	crowd_active = false

#Fight
func fight_play():
	$Fight.play()

func fight_stop():
	$Fight/Tween.interpolate_property($Fight,"volume_db",-25,-80,2,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Fight/Tween.start()

func _on_Tween_tween_completed(_object, _key):
	$Fight.stop()
	$Fight.set_volume_db(-25)

#Game_Over
func Game_over():
	$Game_over.play()

#player_swing
func player_swing():
	$player_swing.play()

#Boss3
func boss3_fast():
	$boss3_fast.play()

func boss3_slow():
	$boss3_slow.play()

func boss3_air():
	$boss3_air.play()
