extends RigidBody2D

export (int) var PRICE

func _on_Orb_of_speed_body_shape_entered(body_id, _body, _body_shape, _local_shape):
	if get_parent().get_node("Player").get_instance_id() == body_id:
		CharacterController.increase_speed(1.1)
		queue_free()
