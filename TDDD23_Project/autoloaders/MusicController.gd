extends Node

var crowd_active = false
const SAVE_DIR = "user://saves"
var filepath = SAVE_DIR + "/settings.dat"
var bus_index = AudioServer.get_bus_index("Master")
var music_index = AudioServer.get_bus_index("Music")
var sfx_index = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_bus_volumes()
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

#Main menu music
func menu_play():
	$Main_menu.play()
	$Main_menu.set_volume_db(-10)

func fade_menu_music():
	$Main_menu/Tween.interpolate_property($Main_menu,"volume_db",-10,-80,1,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Main_menu/Tween.start()

#Entrance
func entrance_play():
	$Entrance.play()
	$Entrance.set_volume_db(-10)

func fade_entrance():
	$Entrance/Tween.interpolate_property($Entrance,"volume_db",-10,-80,1,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Entrance/Tween.start()
#Fight
func fight_play():
	$Fight.play()
	$Fight.set_volume_db(-25)

func fight_stop():
	$Fight/Tween.interpolate_property($Fight,"volume_db",-25,-80,2,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Fight/Tween.start()

func _on_Tween_tween_completed(object, _key):
	object.stop()
#Game_Over
func Game_over():
	$Game_over.play()

#player_swing
func player_swing():
	$player_swing.play()

#Boss
func boss_fast():
	$boss_fast.play()

func boss_slow():
	$boss_slow.play()

func boss_air():
	$boss_air.play()

#Grunts
func play_grunt1():
	$grunt1.play()

func play_grunt2():
	$grunt2.play()

func play_grunt3():
	$grunt3.play()

func player_grunt():
	$player_grunt.play()

#Purchasing items
func purchase():
	$Purchase.play()

#Walking
func walk_start():
	if !$walk.is_playing():
		$walk.play()

func walk_stop():
	$walk.stop()
	$walk/Timer.stop()

func _on_walk_finished():
	$walk/Timer.start()

func _on_Timer_timeout():
	walk_start()

func save_bus_volumes():
	#Check if directory exists, if not create it
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	#Open file
	var file = File.new()
	var error = file.open(filepath,File.WRITE)
	if error != OK:
		print("Failed to open save data, error code:")
		print(error)
	else:
		file.store_var(fill_save_data())
		file.close()

func fill_save_data():
	var dict = {
		"master": AudioServer.get_bus_volume_db(bus_index),
		"music": AudioServer.get_bus_volume_db(music_index),
		"sfx": AudioServer.get_bus_volume_db(sfx_index)
	}
	return dict

func load_bus_volumes():
	var file = File.new()
	if file.file_exists(filepath):
		var error = file.open(filepath,File.READ)
		if error != OK:
			print("Couldnt open save data, error code:")
			print(error)
		else:
			var save_data = file.get_var()
			read_save_data(save_data)
			file.close()

func read_save_data(data):
	AudioServer.set_bus_volume_db(bus_index,data["master"])
	AudioServer.set_bus_volume_db(music_index,data["music"])
	AudioServer.set_bus_volume_db(sfx_index,data["sfx"])
