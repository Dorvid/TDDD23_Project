extends Node

#Enter label
onready var enter_text = $Labels/Enter_text
onready var effect_enter = $Labels/Enter_text/Fade_effect
var faded_in_enter_text = false
#Jump label
onready var jump_text = $Labels/Jump_text
onready var effect_jump = $Labels/Jump_text/Fade_effect
var faded_in_jump_text = false
#Attack label
onready var attack_text = $Labels/Attack_text
onready var effect_attack = $Labels/Attack_text/Fade_effect
var faded_in_attack_text = false
#Leave label
onready var leave_text = $Labels/Leave_text
onready var bounce_up = $Labels/Leave_text/Bounce_up
onready var effect_in = $Labels/Leave_text/Effect_in
var faded_in_leave_text = false
var leave_center
var bounced_up = true

#Shows text
func mod_in(tween,label,time):
	tween.interpolate_property(label, 'modulate',Color(1,1,1,0),Color(1,1,1,1),time,Tween.TRANS_CUBIC,Tween.EASE_IN)
	tween.start()

#Hides text
func mod_out(tween,label,time):
	tween.interpolate_property(label, 'modulate',Color(1,1,1,1),Color(1,1,1,0),time,Tween.TRANS_CUBIC,Tween.EASE_IN)
	tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	if CharacterController.connect("boss_hit",self, "_on_Player_enemy_hit") != OK:
		print("Failed to connect to boss_hit signal in arena script")
	mod_in(effect_enter,enter_text,1)
	leave_center = $Labels/Leave_text.get_global_position().x

func _on_Player_enemy_hit():
	$Target_dummy.dummy_hit()
	if faded_in_attack_text == true && faded_in_leave_text == false:
		faded_in_leave_text = true
		mod_out(effect_attack,attack_text,1)


#Enter label
func _enter_fade_completed(_object, _key):
	if faded_in_enter_text == false:
		faded_in_enter_text = true
		$Labels/Start_fight/Start_collision.set_deferred("disabled",false)
		$Ground_and_walls/Entrance_door/Door.set_deferred("disabled",true)
	else:
		mod_in(effect_jump,jump_text,1)

func _on_Start_fight_body_entered(_body):
	$Labels/Start_fight/Start_collision.set_deferred("disabled",true)
	mod_out(effect_enter,enter_text,1)	


#Jump Label
func _jump_fade_completed(_object, _key):
	if faded_in_jump_text == false:
		faded_in_jump_text = true
		$Labels/Jump_Box/Jumpbox.set_deferred("disabled",false)
	else:
		mod_in(effect_attack,attack_text,1)

func _on_Jump_Box_body_entered(_body):
	$Labels/Jump_Box/Jumpbox.set_deferred("disabled",true)
	mod_out(effect_jump,jump_text,1)


#Attack label
func _attack_fade_completed(_object, _key):
	if faded_in_attack_text == false:
		faded_in_attack_text = true
	else:
		mod_in(effect_in,leave_text,1)
		$Labels/Leave_arena/Leavebox.set_deferred("disabled",false)


 #Leave label
func _on_Leave_arena_body_entered(_body):
	MusicController.leave_arena()
	$TransitionScreen.fade_in()

func _on_Effect_in_tween_completed(_object, _key):
	bounce_up.interpolate_property(leave_text,'rect_position',Vector2(leave_center,108),Vector2(leave_center,100),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	bounce_up.start()

func _on_Bounce_up_tween_completed(_object, _key):
	if bounced_up == false:
		bounced_up = true
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(leave_center,108),Vector2(leave_center,100),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	else:
		bounced_up = false
		bounce_up.interpolate_property(leave_text,'rect_position',Vector2(leave_center,100),Vector2(leave_center,108),0.5,Tween.TRANS_QUINT,Tween.EASE_IN)
	bounce_up.start()


func _on_TransitionScreen_transition_done():
	if get_tree().change_scene("res://scenes/UI/Mainmenu.tscn") != OK:
		print("Failed to swap to Mainmenu scene")
