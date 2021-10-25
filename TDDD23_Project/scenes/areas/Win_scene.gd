extends Node

var renown_text
var fade_done = false
onready var effect_in = $win_text/Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	var current_renown = CharacterController.get_renown()
	var chosen_renown = CharacterController.get_chosen_renown()
	#If progressing renown increase if not already max otherwise dont show renown text
	$win_text/renown_text.text = ""
	if CharacterController.get_renown_progression():
		if current_renown != 10 && chosen_renown == current_renown:
			var new_renown = CharacterController.increase_renown()
			$win_text/renown_text.text = "Renown " + str(new_renown) + " Unlocked!"
	
	effect_in.interpolate_property($win_text,"modulate", Color(1,1,1,0),Color(1,1,1,1),2,Tween.TRANS_QUINT,Tween.EASE_IN)
	effect_in.start()

#Change scene when any button is pressed and when text is fully visible
func _input(event):
	if fade_done:
		if event is InputEventKey:
			if event.pressed:
				CharacterController.game_done()
				if get_tree().change_scene("res://scenes/UI/Mainmenu.tscn") != OK:
					print("Couldnt change to Mainmenu scene in Win_scene")


func _on_Tween_tween_completed(_object, _key):
	fade_done = true
