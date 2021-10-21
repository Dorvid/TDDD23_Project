extends Control

var inventory = []

var panel = preload("res://scenes/UI/Inventory_panel.tscn")



func _ready():
	inventory = CharacterController.get_inventory()
	if CharacterController.connect("inventory_change",self,"update_inventory") != OK:
		print("Could not connect to inventory change")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var new_paused_state = not get_tree().paused
		get_tree().paused = new_paused_state
		visible = new_paused_state


func _on_Button_pressed():
	get_tree().paused = false
	CharacterController.abandon_run()

func update_inventory():
	var temp_inv = CharacterController.get_inventory()
	print(temp_inv)
	temp_inv.slice(0,inventory.size())
	print(temp_inv)
	inventory = temp_inv
	for item in inventory:
		var new_panel = panel.instance()
		new_panel.get_node("Sprite").texture = item.get_texture()
		new_panel.hint_tooltip = item.get_tooltip()
		$Inventory.add_child(new_panel)
		pass
