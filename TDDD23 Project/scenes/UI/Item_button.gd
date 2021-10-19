extends TextureButton


var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	item = CharacterController.select_shop_loot().instance()
	#add_child(item)
	#item.set_contact_monitor(false)
	#item.set_gravity_scale(0.0)
	#item.set_position(self.rect_pivot_offset)
	#item.set_pickable(true)
	self.set_tooltip(item.get_tooltip())
	self.texture_normal = item.get_texture()
	$Label.text = str(item.get_price())
	pass # Replace with function body.


func _on_TextureButton_pressed():
	if item.buy_item():
		self.set_disabled(true)
		self.set_modulate(Color("3f3232"))
