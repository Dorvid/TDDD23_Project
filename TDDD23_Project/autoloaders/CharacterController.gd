extends Node

export (Array, PackedScene) var Boss_loot
export (Array, PackedScene) var Shop_loot
export (Array, PackedScene) var Permanent_loot
var temp_shop_loot
var temp_boss_loot
var temp_perma_loot
var unlocked_array = []
var rng = RandomNumberGenerator.new()
#Inventory for pause screen
var inventory = []


var base_hp = 5
var max_hp
var current_hp
var base_dmg = 3
var base_rdmg = 1
var dmg
var rdmg
var gold = 0
var ammo = 3
#Ascension mechanic from Slay the Spire
var renown = 0
var chosen_renown = 0
var progressing_renown = false
var has_longsword = false
var has_slingshot = false
var returning = false
var current_boss = 0
var boss_hp_multiplier = 1.0
var speed_multiplier = 1.0
var jump_multiplier = 1.0
var gold_multiplier = 1.0
var avoidance = false
var avoid_chance = 0.0
var flame_armor = false
var flame_armor_damage = 0
var range_multiplier = 1.0
#Save data variables
const SAVE_DIR = "user://saves"
var filepath = SAVE_DIR + "/save.dat"

signal player_dead
signal boss_dead
signal fight_start
signal damage_taken
signal boss_hit
signal boss_hit_range
signal hp_change
signal heal
signal gold_changed
signal longsword
signal damage_change
signal rdamage_change
signal speed_increase
signal flame_armor_hit
signal inventory_change
signal abandon_run
signal ammo_update

func _ready():
	for _i in range(0,Permanent_loot.size()):
		unlocked_array.push_back(false)
	max_hp = base_hp
	current_hp = max_hp
	dmg = base_dmg
	rdmg = base_rdmg
	temp_shop_loot = Shop_loot.duplicate()
	temp_boss_loot = Boss_loot.duplicate()
	temp_perma_loot = Permanent_loot.duplicate()

#Player hp functions
func player_hit():
	#Chance to avoid taking damage if player has specific item
	if avoidance:
		rng.randomize()
		if rng.randf_range(0.0,1.0) < avoid_chance:
			return
	current_hp -= 1
	#print(current_hp)
	if current_hp <= 0:
		game_over()
		MusicController.Game_over()
	emit_signal("damage_taken") 

func change_total_hp(i: int):
	if i < 0 && max_hp != current_hp:
		max_hp += i
	else:
		max_hp += i
		current_hp += i
	emit_signal("hp_change")

func total_hp():
	return max_hp

func get_current_hp():
	return current_hp

func heal_hp(i: int):
	if current_hp != base_hp:
		current_hp += i
		emit_signal("heal")

func increase_base_hp(i: int):
	base_hp += i
	change_total_hp(i)

#Other item related functions
func set_avoidance(value: float):
	avoidance = true
	avoid_chance += value

func set_flame_armor(value: int):
	flame_armor = true
	flame_armor_damage += value

func get_flame_armor_damage():
	return flame_armor_damage

func set_boss_hp_scale(input: float):
	boss_hp_multiplier *= input

func get_boss_hp_scale():
	return boss_hp_multiplier
#Melee range
func increase_range(value: float):
	range_multiplier *= value

func get_range():
	return range_multiplier

func add_to_inventory(item):
	inventory.push_back(item)
	emit_signal("inventory_change")
	pass

func get_inventory():
	return inventory.duplicate()
#Player gold functions
func get_current_gold():
	return gold

func gold_change(input: int):
	gold += input
	emit_signal("gold_changed")

func can_purchase(input: int):
	if gold < input:
		return false
	else:
		gold_change(-input)
		return true

func get_gold_multiplier():
	return gold_multiplier

func set_gold_multiplier(input: float):
	gold_multiplier *= input

#Player damage/weapon functions
func get_player_dmg():
	return dmg

func get_player_rdmg(): #ranged damage
	return rdmg

func received_longsword():
	has_longsword = true
	unlocked_array[0] = true
	emit_signal("longsword")

func increase_dmg(input: int):
	dmg += input
	emit_signal("damage_change")

func increase_base_dmg(input: int):
	base_dmg += input
	increase_dmg(input)

func increase_base_rdmg(input: int):
	base_rdmg += input
	increase_rdmg(input)

func increase_rdmg(input: int):
	dmg += input
	emit_signal("rdamage_change")

func received_slingshot():
	has_slingshot = true
	unlocked_array[3] = true
	emit_signal("ammo_update")

func slingshot():
	if !has_slingshot || ammo == 0:
		print(has_slingshot)
		print(ammo)
		return false
	else:
		#shots a shot
		print("Shooting shot")
		increase_ammo(-1)
		return true

func increase_ammo(value: int):
	ammo += value
	emit_signal("ammo_update")

func get_ammo():
	return ammo

#Speed related functions

func increase_speed(input: float):
	speed_multiplier *= input
	emit_signal("speed_increase")

func get_speed_multiplier():
	return speed_multiplier

#Jump related functions

func increase_jump(input: float):
	jump_multiplier *= input

func get_jump_multiplier():
	return jump_multiplier

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
	#reset permanent loot for next round shop
	change_permanent_loot()

func damage_taken():
	emit_signal("damage_taken")
	if flame_armor:
		emit_signal("flame_armor_hit")

func boss_hit():
	emit_signal("boss_hit")

func boss_hit_ranged():
	emit_signal("boss_hit_range")

#Loot functions
func select_loot():
	if temp_boss_loot.size() != 0:
		rng.randomize()
		var i = rng.randi_range(0,temp_boss_loot.size()-1)
		var item = temp_boss_loot[i]
		temp_boss_loot.remove(i)
		return item
	return null

func select_shop_loot():
	if temp_shop_loot.size() != 0:
		rng.randomize()
		var i = rng.randi_range(0,temp_shop_loot.size()-1)
		var item = temp_shop_loot[i]
		temp_shop_loot.remove(i)
		return item
	return null

func select_permanent_loot():
	if temp_perma_loot.size() != 0:
		rng.randomize()
		var i = rng.randi_range(0,temp_perma_loot.size()-1)
		var item = temp_perma_loot[i]
		temp_perma_loot.remove(i)
		return item
	return null

func change_permanent_loot(): #Changes loot that shop can have so that each item only appears once in shop
	var temp_arr = [] #Fills with which indexs of elements in Permanent_loot to remove
	var temp_permanent = Permanent_loot.duplicate() #Neccessary so that this function can be used multiple times
	print(temp_permanent)
	print(unlocked_array)
	for i in range(0,unlocked_array.size()):
		if unlocked_array[i]:
			temp_arr += [i]
	temp_arr.invert() #To loop from behind
	for i in temp_arr:
		temp_permanent.remove(i)
	print(temp_permanent)
	temp_perma_loot = temp_permanent.duplicate()

func is_boss_loot_empty():
	return temp_boss_loot.size() == 0

func is_shop_loot_empty():
	return temp_shop_loot.size() == 0

func is_perma_loot_empty():
	return temp_perma_loot.size() == 0

func add_to_shop_loot(item: PackedScene):
	Shop_loot.push_back(item)

#Renown functions
func get_renown():
	return renown

func increase_renown():
	if renown < 10:
		renown += 1
	return renown

func set_chosen_renown(value: int):
	chosen_renown = value

func get_chosen_renown():
	return chosen_renown

func set_renown_progression(value: bool):
	progressing_renown = value

func get_renown_progression():
	return progressing_renown

#Run is over, resets stats and other bools
func game_done():
	returning = false
	speed_multiplier = 1.0
	jump_multiplier = 1.0
	avoidance = false
	avoid_chance = 0.0
	flame_armor = false
	flame_armor_damage = 0
	gold_multiplier = 1.0
	max_hp = base_hp
	current_hp = max_hp
	dmg = base_dmg
	current_boss = 0
	boss_hp_multiplier = 1.0
	range_multiplier = 1.0
	inventory.clear()
	temp_shop_loot = Shop_loot.duplicate()
	temp_boss_loot = Boss_loot.duplicate()
	temp_perma_loot = Permanent_loot.duplicate()
	save_progress()

func abandon_run():
	game_done()
	emit_signal("abandon_run")
#Save data functions
func save_progress():
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
	var save_data = {
		"base_hp": base_hp,
		"gold": gold,
		"gold_scale": gold_multiplier,
		"renown": renown,
		"damage": base_dmg,
		"rdamage": base_rdmg,
		"longsword": has_longsword,
		"slingshot": has_slingshot,
		"unlocked_items": unlocked_array
	}
	print(save_data)
	return save_data

func load_progress():
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
	print(data)
	if !data.empty():
		base_hp = data["base_hp"]
		gold = data["gold"]
		gold_multiplier = data["gold_scale"]
		renown = data["renown"]
		base_dmg = data["damage"]
		base_rdmg = data["rdamage"]
		has_longsword = data["longsword"]
		has_slingshot = data["slingshot"]
		unlocked_array = data["unlocked_items"]
		print(unlocked_array)
		change_permanent_loot()
