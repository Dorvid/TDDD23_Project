extends Node

onready var leave_text = $Leave_text
onready var game_over = $Game_over
onready var bounce_up = $Leave_text/Bounce_up
onready var effect_in = $Effect_in
onready var effect_drop = $Game_over/Effect_drop

var bounced_up = true
# Called when the node enters the scene tree for the first time.
func _ready():
	#Connects to boss_dead signal and calls _boss_dead when emitted
	if CharacterController.connect("boss_dead", self, "_boss_dead") != OK:
		print("Failed to connect to boss_dead signal in arena script")
	if CharacterController.connect("player_dead", self, "_player_dead") != OK:
		print("Failed to connect to player_dead signal in arena script")
	if CharacterController.connect("boss_hit",self, "_on_Player_enemy_hit") != OK:
		print("Failed to connect to boss_hit signal in arena script")


func _on_Player_enemy_hit():
	$Boss1.boss_hit(CharacterController.get_player_dmg())


func _boss_dead():
	MusicController.crowd_play()
	print("Text appering")
	effect_in.interpolate_property(leave_text,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_in.start()
	$Background.play("cheering")
	$Leave_arena/Leavebox.set_deferred('disabled', false)
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', true)

func _player_dead():
	
	effect_in.interpolate_property(game_over,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_drop.interpolate_property(game_over,'rect_position',Vector2(510,0),Vector2(510,140),2,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	effect_in.start()
	effect_drop.start()

func _on_Start_fight_body_entered(_body):
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', false)
	$Start_fight/Start_collision.set_deferred('disabled', true)
	CharacterController.emit_fight_start()


func _on_Leave_arena_body_entered(_body):
	MusicController.leave_arena()
	$Interface/Life.free_bar_childs()
	if get_tree().change_scene("res://scenes/areas/Entrance.tscn") != OK:
		print("Failed to swap to entrance scene")


func _on_Effect_in_tween_completed(_object, _key):
	bounce_up.interpolate_property(leave_text,'rect_position',Vector2(437,108),Vector2(437,100),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	bounce_up.start()


func _on_Bounce_up_tween_completed(_object, _key):
	if bounced_up == false:
		bounced_up = true
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(437,108),Vector2(437,100),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	else:
		bounced_up = false
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(437,100),Vector2(437,108),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	bounce_up.start()
