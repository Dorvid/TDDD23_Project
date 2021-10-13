extends RigidBody2D

export (int) var PRICE


func _on_Small_HP_pot_body_shape_entered(body_id, _body, _body_shape, _local_shape):
	if get_parent().get_node("Player").get_instance_id() == body_id:
		CharacterController.heal_hp(1)
		queue_free()
