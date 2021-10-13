extends Node

var ready_to_enter = false
onready var effect_in = $Entrance/Label/Effect_in
onready var effect_out = $Entrance/Label/Effect_out
onready var label = $Entrance/Label

func _ready():
	if CharacterController.get_returning():
		$Player.position = $Return_pos.position
	print_tree()
	pass

func _process(_delta):
	if ready_to_enter == true:
		if Input.is_action_just_pressed("ui_up"):
			CharacterController.set_returning(true)
			$TransitionScreen.fade_in()


func _on_Entrance_body_entered(_body):
	ready_to_enter = true
	effect_in.interpolate_property(label,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_in.start()
	print("Ready to enter")


func _on_Entrance_body_exited(_body):
	ready_to_enter = false
	effect_out.interpolate_property(label,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_out.start()
	print("No longer ready")


func _on_TransitionScreen_transition_done():
	match CharacterController.get_current_boss():
		0:
			if get_tree().change_scene("res://scenes/areas/Arena.tscn") != OK:
				print("Failed to swap to arena scene")
		1:
			if get_tree().change_scene("res://scenes/areas/Arena2.tscn") != OK:
				print("Failed to swap to arena2 scene")
		2: 
			if get_tree().change_scene("res://scenes/areas/Arena3.tscn") != OK:
				print("Failed to swap to arena3 scene")
	$Interface/Life.free_bar_childs()
