extends NinePatchRect


onready var gold = CharacterController.get_current_gold()

# Called when the node enters the scene tree for the first time.
func _ready():
	if CharacterController.connect("gold_changed",self,"_change_gold") != OK:
		print("Could not connect to signal gold_changed in Gold.gd")
	pass

func _process(_delta):
	$Label.set_text(str(gold))

func _change_gold():
	gold = CharacterController.get_current_gold()
