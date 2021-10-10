extends RigidBody2D

var value
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func set_value(gold_cap):
	value = rng.randi_range(gold_cap-20,gold_cap)
	if value < 40:
		$Sprite.play("1")
	elif value < 80:
		$Sprite.play("2")
	else:
		$Sprite.play("3")


func _on_Gold_body_shape_entered(body_id, _body, _body_shape, _local_shape):
	if get_parent().get_node("Player").get_instance_id() == body_id:
		CharacterController.gold_change(value)
		queue_free()
