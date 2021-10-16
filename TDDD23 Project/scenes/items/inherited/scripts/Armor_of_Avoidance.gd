extends RigidBody2D

export (int) var PRICE




func _on_Armor_of_Avoidance_body_shape_entered(body_id, _body, _body_shape, _local_shape):
	if get_parent().get_node("Player").get_instance_id() == body_id:
		CharacterController.set_avoidance()
		queue_free()
