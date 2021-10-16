extends Node

export (Array, PackedScene) var Boss_loot
export (Array, PackedScene) var Shop_loot
var rng = RandomNumberGenerator.new()

var base_hp = 5
var current_hp
var base_dmg = 3
var dmg
var gold = 0
#Ascension mechanic from Slay the Spire
var renown = 0
var has_longsword = false
var returning = false
var current_boss = 0
var speed_multiplier = 1.0
var avoidance = false


signal player_dead
signal boss_dead
signal fight_start
signal damage_taken
signal boss_hit
signal hp_change
signal heal
signal gold_changed
signal longsword
signal damage_change
signal speed_increase

func _ready():
	current_hp = base_hp
	dmg = base_dmg
	#TODO: Load save file
	pass # Replace with function body.

#Player hp functions
func player_hit():
	#Chance to avoid taking damage if player has specific item
	if avoidance:
		rng.randomize()
		if rng.randf_range(0.0,1.0) < 0.1:
			return
	current_hp -= 1
	#print(current_hp)
	if current_hp <= 0:
		game_over()
	emit_signal("damage_taken") 

func change_total_hp(i: int):
	if i < 0 && base_hp != current_hp:
		base_hp += i
	else:
		base_hp += i
		current_hp += i
	emit_signal("hp_change")

func total_hp():
	return base_hp

func get_current_hp():
	return current_hp

func heal_hp(i: int):
	if current_hp != base_hp:
		current_hp += i
		emit_signal("heal")

func set_avoidance():
	avoidance = true
#Player gold functions
func get_current_gold():
	return gold

func gold_change(input: int):
	gold += input
	emit_signal("gold_changed")

#Player damage/weapon functions
func get_player_dmg():
	return dmg

func received_longsword():
	has_longsword = true
	emit_signal("longsword")

func increase_dmg(input: int):
	dmg += input
	emit_signal("damage_change")

#Speed related functions

func increase_speed(input: float):
	speed_multiplier *= input
	emit_signal("speed_increase")

func get_speed_multiplier():
	return speed_multiplier
#Scene related functions
func get_returning():
	return returning

func set_returning(bool_val: bool):
	returning = bool_val

func get_current_boss():
	return current_boss
#Emit signals
func game_over():
	emit_signal("player_dead")

func boss_dead():
	emit_signal("boss_dead")
	current_boss += 1

func emit_fight_start():
	emit_signal("fight_start")

func damage_taken():
	emit_signal("damage_taken")

func boss_hit():
	emit_signal("boss_hit")

#Loot functions
func select_loot():
	rng.randomize()
	var item = Boss_loot[rng.randi_range(0,Boss_loot.size()-1)]
	print("Item selected: " + str(item))
	return item
