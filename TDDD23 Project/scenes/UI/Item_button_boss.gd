extends TextureButton


var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if !CharacterController.is_boss_loot_empty():
		item = CharacterController.select_loot().instance()
		self.set_tooltip(item.get_tooltip())
		self.texture_normal = item.get_texture()
		$Label.text = str(item.get_price())
	else:
		queue_free()

func _on_TextureButton_pressed():
	if item.buy_item():
		self.set_disabled(true)
		self.set_modulate(Color("3f3232"))
