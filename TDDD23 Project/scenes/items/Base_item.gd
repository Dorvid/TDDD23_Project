extends RigidBody2D

export (int) var PRICE

func get_price():
	return PRICE

func buy_item():
	if CharacterController.can_purchase(PRICE):
		remove_item()
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
		queue_free()
