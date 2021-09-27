extends Node

var ready_to_enter = false

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if ready_to_enter == true:
		if Input.is_action_just_pressed("ui_up"):
			get_tree().change_scene("res://scenes/areas/Arena.tscn")


func _on_Entrance_body_entered(body):
	ready_to_enter = true
	print("Ready to enter")


func _on_Entrance_body_exited(body):
	ready_to_enter = false
	print("No longer ready")
