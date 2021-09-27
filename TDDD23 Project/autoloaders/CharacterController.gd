extends Node

var base_hp = 5
var current_hp
var base_dmg = 3
var dmg
var gold = 0
var ascension = 0
var has_longsword = false

signal player_dead
signal boss_dead
signal fight_start


func _ready():
	current_hp = base_hp
	dmg = base_dmg
	#TODO: Load save file
	pass # Replace with function body.

func player_hit():
	current_hp -= 1
	print(current_hp)
	if current_hp == 0:
		game_over() 

func get_current_gold():
	return gold

func get_player_dmg():
	return dmg

func emit_fight_start():
	emit_signal("fight_start")

func game_over():
	pass
