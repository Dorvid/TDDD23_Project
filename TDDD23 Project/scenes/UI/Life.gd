extends Control

export (PackedScene) var Heart
var hp
var format_string = "Bar/Heart{int}"
var parsing_str
var resize_width
var total_hp
var health_width = 10

onready var fade = $Fade_effect
# Called when the node enters the scene tree for the first time.

func _ready():
	total_hp = CharacterController.total_hp()
	hp = CharacterController.get_current_hp()
	if total_hp > 5:
		_resize_bar()
		health_width += 300
	else:
		add_heart(5)
	if hp < total_hp:
		for n in range(total_hp,hp,-1):
			parsing_str = format_string.format({"int": n})
			get_node(parsing_str).set_modulate(Color("212020"))
	if CharacterController.connect("damage_taken",self,"_damage_taken") != OK:
		print("Could not connect to signal damage_taken in Life.gd")
	if CharacterController.connect("hp_increase",self,"_resize_bar") != OK:
		print("Could not connect to signal hp_increase in Life.gd")
	


func _damage_taken():
	hp -= 1
	if hp > 0:
		parsing_str = format_string.format({"int": hp + 1})
		fade_heart(get_node(parsing_str))
	elif hp == 0:
		fade_heart(get_node("Bar/Heart"))

func fade_heart(heart):
	fade.interpolate_property(heart,"modulate",Color("ffffff"),Color("212020"),0.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	fade.start()


func _resize_bar():
	var new_total_hp = CharacterController.total_hp()
	resize_width = 310 + (new_total_hp - 5) * 60
	$Bar.rect_size.x = resize_width
	add_heart(new_total_hp - total_hp)
	total_hp = new_total_hp

func add_heart(i):
	for x in i:
		var heart = Heart.instance()
		get_node("Bar").add_child(heart,true)
		heart.rect_position.x = health_width
		health_width += 60
		print_tree()

func free_bar_childs():
	for n in $Bar.get_children():
		$Bar.remove_child(n)
		n.queue_free()


func _on_Timer_timeout():
	#CharacterController.
	pass
