extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
export (int) var SPEED
export (int) var HEALTH
var is_attacking = false
var moving_left = true

onready var ray_wall = $RayWall
onready var ray_char = $RayChar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	#Start Attacking
	if ray_char.is_colliding():
		$AnimatedSprite.play("attack")
		$AttackCollision/SwingTimer.start(0)
		is_attacking = true
	elif ray_wall.is_colliding():
		if moving_left == true:
			moving_left = false
			$AnimatedSprite.set_flip_h(true)
			$AttackCollision.scale = Vector2(-1,1)
			$RayWall.scale = Vector2(-1,1)
			$RayChar.scale = Vector2(-1,1)
		else:
			moving_left = true
			$AnimatedSprite.set_flip_h(false)
			$AttackCollision.scale = Vector2(1,1)
			$RayWall.scale = Vector2(1,1)
			$RayChar.scale = Vector2(1,1)
	
	if is_attacking == false:
		if moving_left == true:
			velocity.x = -SPEED
			$AnimatedSprite.play("walk")
		else:
			velocity.x = SPEED
			$AnimatedSprite.play("walk")
	else:
		velocity.x = 0
	move_and_slide(velocity,Vector2.UP)

func _on_SwingTimer_timeout():
	$AttackCollision/start.disabled = false
	$SwingTimer2.start(0)


func _on_SwingTimer2_timeout():
	$AttackCollision/start.disabled = true
	$AttackCollision/end.disabled = false
	$SwingTimer3.start(0)

func _on_SwingTimer3_timeout():
	$AttackCollision/end.disabled = true
	is_attacking = false
