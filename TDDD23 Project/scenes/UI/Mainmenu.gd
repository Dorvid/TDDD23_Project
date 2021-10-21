extends Control

var bus_index = AudioServer.get_bus_index("Master")
var choice = false


func _ready():
	MusicController.menu_play()
	CharacterController.load_progress()
	#Gets master audio bus value and sets slider to that value
	$Options_container/Volume_slider.set_value(AudioServer.get_bus_volume_db(bus_index))
	#Gets values from CharacterController for selecting renown difficulty
	$Start_container/CheckButton.set_pressed(CharacterController.get_renown_progression())
	$Start_container/GridContainer/SpinBox.set_max(CharacterController.get_renown())
	$Start_container/GridContainer/SpinBox.set_value(CharacterController.get_renown())


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	$Button_container.set_visible(false)
	$Start_container.set_visible(true)


func _on_Tutorial_pressed():
	choice = false
	$TransitionScreen.fade_in()


func _on_Options_pressed():
	$Button_container.set_visible(false)
	$Options_container.set_visible(true)


func _on_Return_pressed():
	$Button_container.set_visible(true)
	$Start_container.set_visible(false)
	$Options_container.set_visible(false)


func _on_Startgame_pressed():
	choice = true
	if $Start_container/CheckButton.is_pressed() == false:
		CharacterController.set_renown_progression(false)
		CharacterController.set_chosen_renown(false)
	$TransitionScreen.fade_in()
	MusicController.fade_menu_music()


func _on_Volume_changed(value):
	AudioServer.set_bus_volume_db(bus_index,value)


func _on_TransitionScreen_transition_done():
	if choice:
		if get_tree().change_scene("res://scenes/areas/Entrance.tscn") != OK:
			print("Couldnt start game in mainmenu")
	else:
		if get_tree().change_scene("res://scenes/areas/Arena_tutorial.tscn") != OK:
			print("Couldnt change scene to tutorial from mainmenu")


func _on_SpinBox_value_changed(value):
	CharacterController.set_chosen_renown(value)
	set_renown_text(value)

func set_renown_text(value: int):
	match value:
		0:
			$Start_container/Renown_text.set_text("")
		1:
			$Start_container/Renown_text.set_text("First boss has more HP")
		2:
			$Start_container/Renown_text.set_text("Second boss has more HP")
		3:
			$Start_container/Renown_text.set_text("Third boss has more HP")
		4:
			$Start_container/Renown_text.set_text("First and second boss is harder")
		5:
			$Start_container/Renown_text.set_text("Bosses drop less gold")
		6:
			$Start_container/Renown_text.set_text("Shop is more expensive")
		7:
			$Start_container/Renown_text.set_text("Start with less damage")
		8:
			$Start_container/Renown_text.set_text("Start hurt")
		9:
			$Start_container/Renown_text.set_text("Bosses are Faster")
		10:
			$Start_container/Renown_text.set_text("Bosses have even more health")

func _on_CheckButton_toggled(button_pressed):
	CharacterController.set_renown_progression(button_pressed)
	$Start_container/GridContainer/SpinBox.set_editable(button_pressed)
	
