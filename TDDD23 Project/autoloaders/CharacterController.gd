extends Node

var base_hp = 5
var current_hp
var base_dmg = 3
var dmg
var gold = 0
#Ascension mechanic from Slay the Spire
var renown = 0
var has_longsword = false
var returning = false

signal player_dead
signal boss_dead
signal fight_start
signal damage_taken
signal boss_hit

func _ready():
	current_hp = base_hp
	dmg = base_dmg
	#TODO: Load save file
	pass # Replace with function body.

func player_hit():
	current_hp -= 1
	print(current_hp)
	if current_hp <= 0:
		game_over()
	else:
		emit_signal("damage_taken") 

func get_current_gold():
	return gold

func get_player_dmg():
	return dmg

func get_returning():
	return returning

func set_returning(bool_val):
	returning = bool_val

#Emit signals
func game_over():
	emit_signal("player_dead")

func boss_dead():
	emit_signal("boss_dead")

func emit_fight_start():
	emit_signal("fight_start")

func damage_taken():
	emit_signal("damage_taken")

func boss_hit():
	emit_signal("boss_hit")
