extends KinematicBody2D

var velocity = Vector2()
export (int) var SPEED
export (int) var GRAVITY
export (int) var JUMPFORCE
export (bool)var HAS_LONGSWORD
var is_attacking = false
var last_direction = 0 

# Loads swords so they can be set in ready
var short_frames = preload("res://shortsword.tres")
var long_frames = preload("res://longsword.tres")

func _ready():
	#If the player has unlocked the long sword set it and increase hitboxes
	if HAS_LONGSWORD == false:
		$Weapon.set_sprite_frames(short_frames)
	else:
		$Weapon.set_sprite_frames(long_frames)
		$AttackCollision/side.scale = Vector2(1.5,1)
		$AttackCollision/up.scale = Vector2(1,1.5)
		$AttackCollision/down.scale = Vector2(1,1.5)
	#set weapon to correct animation just is case
	$Weapon.play("idle")

func _physics_process(_delta):
	#Move Character left or right and change animation
	if Input.is_action_pressed("ui_right") && (!is_on_floor() or is_attacking == false):
		#Set Speed
		velocity.x = SPEED
		# For logic concerning which side player is looking at in this case right
		last_direction = 1
		#Set and flip animations and hitboxes for weapons
		$Body.play("walk")
		$Head.set_flip_h(false)
		$Weapon.set_flip_h(false)
		$AttackCollision.scale = Vector2(1,1)
	elif Input.is_action_pressed("ui_left") && (!is_on_floor() or is_attacking == false):
		velocity.x = -SPEED
		# For logic concerning which side player is looking at in this case left
		last_direction = -1
		#Set and flip animations and hitboxes for weapons
		$Body.play("walk")
		$Head.set_flip_h(true)
		$Weapon.set_flip_h(true)
		$AttackCollision.scale = Vector2(-1,1)
	else: #No movement so idle
		velocity.x = 0
		if is_attacking == false:
			$Body.play("idle")
			$Weapon.play("idle")
	
	# Attack logic
	if Input.is_action_just_pressed("ui_attack") && is_attacking == false:
		if Input.is_action_pressed("ui_down"):
			$Weapon.play("swing down")
			$AttackCollision/down.disabled = false
		elif Input.is_action_pressed("ui_up"):
			$Weapon.play("swing up")
			$AttackCollision/up.disabled = false
		else:
			$Weapon.play("swing side")
			$AttackCollision/side.disabled = false
		#So that we get our attacking animations over our other ones so far
		is_attacking = true
	
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
	
#When animation is finished set animation to idle and disable weapon hitboxes
func _on_Weapon_animation_finished():
	is_attacking = false
	$Weapon.play("idle")
	$AttackCollision/down.disabled = true
	$AttackCollision/up.disabled = true
	$AttackCollision/side.disabled = true
