extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func direction(value: int):
	speed *= value



func _on_Projectile_body_entered(body):
	if body.is_in_group("boss"):
		CharacterController.boss_hit_ranged()
		queue_free()
	elif body.is_in_group("walls"):
		queue_free()
