extends KinematicBody2D

var velocity = Vector2()
export (int) var SPEED
export (int) var GRAVITY
export (int) var JUMPFORCE


func _physics_process(delta):
	#Move Character left or right and change animation
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$Body.play("walk")
		$Head.set_flip_h(true)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$Body.play("walk")
		$Head.set_flip_h(false)
	else: #No movement so idle
		$Body.play("idle")
	
	#If player wants to attack downwards change animation to look down
	if Input.is_action_pressed("ui_down"):
		$Head.play("down")
	else:
		$Head.play("idle")
	
	#Gravity
	velocity.y = velocity.y + GRAVITY
	
	#Jump if on a floor
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = -JUMPFORCE
	
	#Detect Collision and move character, 
	#Vector2.UP tells is_on_floor() which direction the floor is looking
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
	

