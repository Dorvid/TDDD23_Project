extends KinematicBody2D

var velocity = Vector2()
var knockback_velocity = Vector2()
var knockback = false
export (int) var SPEED
var base_speed
export (int) var GRAVITY
export (int) var JUMPFORCE
export (int) var KNOCKBACK_FORCE
var is_attacking = false
var last_direction = 1
var alive = true
var entrance_area = false

onready var effect_dmg = $Effect_dmg_body
onready var effect_dmg2 = $Effect_dmg_head


# Loads swords so they can be set in ready or in set_longsword()
var short_frames = preload("res://scenes/player/shortsword.tres")
var long_frames = preload("res://scenes/player/longsword.tres")
#projectile
var projectile = preload("res://scenes/player/projectile.tscn")
func _ready():
	base_speed = SPEED * CharacterController.get_speed_multiplier()
	JUMPFORCE *= CharacterController.get_jump_multiplier()
	#If the player has unlocked the long sword set it and increase hitboxes
	if CharacterController.has_longsword == false:
		set_shortsword()
	else:
		set_longsword()
	#set weapon to correct animation just is case
	$Weapon.play("idle")
	#Connect to signals
	if CharacterController.connect("player_dead",self,"_dead") != OK:
		print("Failed to connect to player_dead signal in player script")
	if CharacterController.connect("damage_taken",self,"_damage_taken") != OK:
		print("Failed to connect to damage_taken signal in player script")
	if CharacterController.connect("longsword",self,"set_longsword") != OK:
		print("Failed to connect to longsword signal in player script")
	if CharacterController.connect("speed_increase",self,"_speed_increase") != OK:
		print("Failed to connect to speed_increase signal in player script")

func _physics_process(_delta):
	#Move Character left or right and change animation
	if alive == true:
		if Input.is_action_pressed("ui_right") && (!is_on_floor() || is_attacking == false):
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
		if !entrance_area:
			if Input.is_action_just_pressed("ui_attack") && is_attacking == false:
				if Input.is_action_pressed("ui_down"):
					$Weapon.play("swing down")
					$AttackCollision/down.set_deferred('disabled', false)
				elif Input.is_action_pressed("ui_up"):
					$Weapon.play("swing up")
					$AttackCollision/up.set_deferred('disabled', false)
				else:
					$Weapon.play("swing side")
					$AttackCollision/side.set_deferred('disabled', false)
				#So that we get our attacking animations over our other ones so far
				is_attacking = true
				MusicController.player_swing()
			elif Input.is_action_just_pressed("ui_alt_attack") && is_attacking == false:
				print("Attempting to shoot")
				if CharacterController.slingshot():
					$Weapon.play("slingshot")
					$Slingshot_timer.start()
					is_attacking = true
				else:
					print("failed...")
		
		#If player wants to attack downwards change animation to look down
		if Input.is_action_pressed("ui_down"):
			$Head.play("down")
		else:
			$Head.play("idle")
		
		#If downwards swing hit get a little knockback upwards
		if knockback == true:
			velocity.y = knockback_velocity.y * KNOCKBACK_FORCE
			knockback = false
		else:
			#Gravity
			velocity.y = velocity.y + GRAVITY
		
		#Jump if on a floor
		if Input.is_action_just_pressed("ui_jump") && is_on_floor():
			velocity.y = -JUMPFORCE
		
		#walking noise
		if velocity.x != 0 && is_on_floor():
			MusicController.walk_start()
		else:
			MusicController.walk_stop()
		#Detect Collision and move character, 
		#Vector2.UP tells is_on_floor() which direction the floor is looking
		velocity = move_and_slide(velocity,Vector2.UP)
		
		velocity.x = lerp(velocity.x,0,0.2)
	elif !is_on_floor():
		velocity.y = velocity.y + GRAVITY
		velocity.x = 0
		velocity = move_and_slide(velocity)

#When animation is finished set animation to idle and disable weapon hitboxes
func _on_Weapon_animation_finished():
	is_attacking = false
	turn_off_weap_collision($Weapon.get_animation())
	$Weapon.play("idle")

func turn_off_weap_collision(animation):
	match animation:
		"swing down":
			$AttackCollision/down.set_deferred('disabled', true)
		"swing up":
			$AttackCollision/up.set_deferred('disabled', true)
		"swing side":
			$AttackCollision/side.set_deferred('disabled', true)
	

#When player attacks enemy
func _on_AttackCollision_body_entered(_body):
	CharacterController.boss_hit()
	#Get which way char is attacking
	var temp = $Weapon.get_animation()
	turn_off_weap_collision(temp)
	#Set knockback velocity to add it to char in next physics loop
	if temp == "swing down":
		knockback_velocity = Vector2(0,-1)
		knockback = true
	
	
#Player dies :(
func _dead():
	alive = false
	$Body.play("death")
	$Weapon.hide()
	$Head.hide()

#Flashes player when taking damage
func _damage_taken():
	effect_dmg.interpolate_property($Body.get_material(),'shader_param/flash_modifier',1.0,0.0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	effect_dmg2.interpolate_property($Head.get_material(),'shader_param/flash_modifier',1.0,0.0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	effect_dmg.start()
	effect_dmg2.start()

#Gives player longsword
func set_longsword():
	var val = CharacterController.get_range()
	$Weapon.set_sprite_frames(long_frames)
	$AttackCollision/side.scale = Vector2(1.5 * val ,1)
	$AttackCollision/up.scale = Vector2(1,1.5 * val)
	$AttackCollision/down.scale = Vector2(1,1.5 * val)

func set_shortsword():
	var val = CharacterController.get_range()
	$Weapon.set_sprite_frames(short_frames)
	$AttackCollision/side.scale = Vector2(1.5 * val ,1)
	$AttackCollision/up.scale = Vector2(1,1.5 * val)
	$AttackCollision/down.scale = Vector2(1,1.5 * val)

func _speed_increase():
	SPEED = floor(base_speed * CharacterController.get_speed_multiplier())

#so player cant swing in entrance area
func in_entrance_area():
	entrance_area = true


func _on_Slingshot_timer_timeout():
	#instance a projectile
	var new_projectile = projectile.instance()
	new_projectile.direction(last_direction)
	new_projectile.transform = global_transform
	owner.add_child(new_projectile)
	pass

func get_last_direction():
	return last_direction
