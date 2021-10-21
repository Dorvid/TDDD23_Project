extends Node

var Gold = load("res://scenes/items/Gold_item.tscn")

onready var leave_text = $Labels/Leave_text
onready var game_over = $Labels/Game_over
onready var bounce_up = $Labels/Leave_text/Bounce_up
onready var effect_in = $Labels/Effect_in
onready var effect_drop = $Labels/Game_over/Effect_drop

var bounced_up = true
var text_pos
var current_boss
var run_over = false
var abandon_run = false
# Called when the node enters the scene tree for the first time.
func _ready():
	text_pos = $Labels/Leave_text.get_global_position().x
	#Connects to boss_dead signal and calls _boss_dead when emitted
	if CharacterController.connect("boss_dead", self, "_boss_dead") != OK:
		print("Failed to connect to boss_dead signal in arena script")
	if CharacterController.connect("player_dead", self, "_player_dead") != OK:
		print("Failed to connect to player_dead signal in arena script")
	if CharacterController.connect("boss_hit",self, "_on_Player_enemy_hit") != OK:
		print("Failed to connect to boss_hit signal in arena script")
	if CharacterController.connect("flame_armor_hit",self,"_on_Flame_armor_hit") != OK:
		print("Failed to connect to flame_armor_hit signal in arena script")
	if CharacterController.connect("abandon_run",self,"_abandon_run") != OK:
		print("Failed to connect to abandon_run signal in arena script")
	current_boss = CharacterController.get_current_boss()

func _input(event):
	if run_over:
		if event is InputEventKey:
			if event.pressed:
				if get_tree().change_scene("res://scenes/UI/Mainmenu.tscn") != OK:
					print("Could not change to Mainmenu scene in Arena.gd")

#Signal functions
func _on_Player_enemy_hit():
	match current_boss:
		0:
			$Boss1.boss_hit(CharacterController.get_player_dmg())
		1:
			$Boss2.boss_hit(CharacterController.get_player_dmg())
		2:
			$Boss3.boss_hit(CharacterController.get_player_dmg())

func _on_Flame_armor_hit():
	match current_boss:
		0:
			$Boss1.boss_hit(CharacterController.get_flame_armor_damage())
		1:
			$Boss2.boss_hit(CharacterController.get_flame_armor_damage())
		2:
			$Boss3.boss_hit(CharacterController.get_flame_armor_damage())

func _boss_dead():
	MusicController.fight_stop()
	MusicController.crowd_play()
	#print("Text appering")
	effect_in.interpolate_property(leave_text,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_in.start()
	$Background.play("cheering")
	$Leave_arena/Leavebox.set_deferred('disabled', false)
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', true)
	drop_items()
	change_masks()

#Turns off masks so player and/or boss falls to ground without colliding and staying in air
func change_masks():
	if current_boss == 1:
		$Boss2.set_collision_mask_bit(1,false)
		$Boss2.set_collision_layer_bit(2,false)
	elif current_boss == 2:
		$Boss3.set_collision_mask_bit(1,false)
		$Boss3.set_collision_layer_bit(2,false)
	$Player.set_collision_mask_bit(2,false)

#Drops items to player when boss dies
func drop_items():
	#print("Dropping items...")
	#Select item
	if !CharacterController.is_boss_loot_empty():
		var item = CharacterController.select_loot().instance()
		call_deferred("add_child",item)
		item.position = get_node("Boss" + str(current_boss +1)).position
		item.set_linear_velocity(Vector2(10,50))
	#Drop gold
	var gold = Gold.instance()
	call_deferred("add_child",gold)
	gold.set_value(get_node("Boss" + str(current_boss +1)).get_gold_cap())
	gold.position = get_node("Boss" + str(current_boss +1)).position
	gold.set_linear_velocity(Vector2(10,50))
	#print("Done")

func _player_dead():
	effect_in.interpolate_property(game_over,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_drop.interpolate_property(game_over,'rect_position',Vector2(510,0),Vector2(510,140),2,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	effect_in.start()
	effect_drop.start()
	change_masks()
	CharacterController.game_done()
	MusicController.fight_stop()

#Starts boss fight when player has entered arena
func _on_Start_fight_body_entered(_body):
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', false)
	$Start_fight/Start_collision.set_deferred('disabled', true)
	CharacterController.emit_fight_start()
	MusicController.fight_play()

#Changes scene to entrance, lowes audience volume and removes interface childs
func _on_Leave_arena_body_entered(_body):
	$TransitionScreen.fade_in()
	MusicController.leave_arena()

#Tweens for text
func _on_Effect_in_tween_completed(_object, _key):
	bounce_up.interpolate_property(leave_text,'rect_position',Vector2(text_pos,108),Vector2(text_pos,100),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	bounce_up.start()

func _on_Bounce_up_tween_completed(_object, _key):
	if bounced_up == false:
		bounced_up = true
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(text_pos,108),Vector2(text_pos,100),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	else:
		bounced_up = false
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(text_pos,100),Vector2(text_pos,108),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	bounce_up.start()


func _on_TransitionScreen_transition_done():
	if abandon_run:
		if get_tree().change_scene("res://scenes/UI/Mainmenu.tscn") != OK:
			print("Failed to swap to main menu")
	elif current_boss == 2:
		if get_tree().change_scene("res://scenes/areas/Win_scene.tscn") != OK:
			print("Failed to swap to win_scene")
	else:
		if get_tree().change_scene("res://scenes/areas/Entrance.tscn") != OK:
			print("Failed to swap to entrance scene")


func _on_Effect_drop_tween_completed(_object, _key):
	run_over = true
	print("Ready to exit")

func _abandon_run():
	abandon_run = true
	$TransitionScreen.fade_in()
