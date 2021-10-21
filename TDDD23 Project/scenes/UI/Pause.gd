extends Control

var inventory = []

var panel = preload("res://scenes/UI/Inventory_panel.tscn")



func _ready():
	if CharacterController.connect("inventory_change",self,"update_inventory") != OK:
		print("Could not connect to inventory change")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var new_paused_state = not get_tree().paused
		get_tree().paused = new_paused_state
		if new_paused_state:
			update_inventory()
		visible = new_paused_state


func _on_Button_pressed():
	get_tree().paused = false
	MusicController.fight_stop()
	MusicController.crowd_stop()
	CharacterController.abandon_run()

func update_inventory():
	print_tree()
	for i in $Inventory.get_children():
		i.queue_free()
	print_tree()
	inventory = CharacterController.get_inventory()
	print(inventory)
	for item in inventory:
		var new_panel = panel.instance()
		new_panel.get_node("Sprite").texture = item.get_texture()
		new_panel.hint_tooltip = item.get_tooltip()
		$Inventory.add_child(new_panel)
