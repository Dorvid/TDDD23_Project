extends Control

var bus_index = AudioServer.get_bus_index("Master")

func _ready():
	#Gets master audio bus value and sets slider to that value
	$Options_container/Volume_slider.set_value(AudioServer.get_bus_volume_db(bus_index))
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	$Button_container.set_visible(false)
	$Start_container.set_visible(true)


func _on_Tutorial_pressed():
	if get_tree().change_scene("res://scenes/areas/Arena_tutorial.tscn") != OK:
		print("Couldnt change scene to tutorial from mainmenu")


func _on_Options_pressed():
	$Button_container.set_visible(false)
	$Options_container.set_visible(true)


func _on_Return_pressed():
	$Button_container.set_visible(true)
	$Start_container.set_visible(false)
	$Options_container.set_visible(false)


func _on_Startgame_pressed():
	if get_tree().change_scene("res://scenes/areas/Entrance.tscn") != OK:
		print("Couldnt start game in mainmenu")


func _on_Volume_changed(value):
	AudioServer.set_bus_volume_db(bus_index,value)
