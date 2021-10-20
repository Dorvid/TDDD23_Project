extends Node

var ready_to_enter = false
onready var effect_in = $Entrance/Label/Effect_in
onready var effect_out = $Entrance/Label/Effect_out
onready var label = $Entrance/Label

var ready_to_shop = false
onready var shop_in = $Shopkeeper/Shop_in
onready var shop_out = $Shopkeeper/Shop_out
onready var shop_label = $Shopkeeper/Label

func _ready():
	if CharacterController.get_returning():
		$Player.position = $Return_pos.position
	else:
		if CharacterController.get_chosen_renown() >= 7:
			CharacterController.increase_dmg(-1)
		if CharacterController.get_chosen_renown() >= 8:
			CharacterController.damage_taken()

func _process(_delta):
	if ready_to_enter:
		if Input.is_action_just_pressed("ui_up"):
			CharacterController.set_returning(true)
			$TransitionScreen.fade_in()
	if ready_to_shop:
		if Input.is_action_just_pressed("ui_enter_shop"):
			$Shop_Screen.set_visible(true)
	#prevent player from moving and attacking when shop is open
	if $Shop_Screen.is_visible() == true:
		$Player.is_attacking = true
	else:
		$Player.is_attacking = false


func _on_Entrance_body_entered(_body):
	ready_to_enter = true
	effect_in.interpolate_property(label,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_in.start()
	#print("Ready to enter")


func _on_Entrance_body_exited(_body):
	ready_to_enter = false
	effect_out.interpolate_property(label,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,Tween.TRANS_CUBIC,Tween.EASE_IN)
	effect_out.start()
	#print("No longer ready")


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


func _on_Interaction_body_entered(_body):
	ready_to_shop = true
	shop_in.interpolate_property(shop_label,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	shop_in.start()
	#print("Ready to shop")


func _on_Interaction_body_exited(_body):
	ready_to_shop = false
	$Shop_Screen.set_visible(false)
	shop_out.interpolate_property(shop_label,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,Tween.TRANS_CUBIC,Tween.EASE_IN)
	shop_out.start()
	#print("No longer ready to shop")
