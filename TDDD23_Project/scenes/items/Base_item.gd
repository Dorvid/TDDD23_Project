extends RigidBody2D

export (int) var PRICE

func get_price():
	#if renown 6 or higher
	if CharacterController.get_chosen_renown() >= 6:
		PRICE = ceil(PRICE * 1.3)
	return PRICE

func buy_item():
	if CharacterController.can_purchase(PRICE):
		remove_item()
		MusicController.purchase()
		return true
	return false

func remove_item():
	pass

func get_tooltip():
	return $Control.get_tooltip()

func get_texture():
	return $Sprite.get_texture()


func _on_Base_item_body_shape_entered(body_id, _body, _body_shape, _local_shape):
	if get_parent().get_node("Player").get_instance_id() == body_id:
		remove_item()
		CharacterController.add_to_inventory(self.duplicate())
		queue_free()
