extends KinematicBody2D

var velocity = Vector2()
export (int) var SPEED
export (int) var HEALTH
export (int) var JUMPFORCE
export (int) var GRAVITY
export (int) var GOLD_CAP
var current_hp
var is_attacking = false
var attack_on_cooldown = false
var turn_on_cooldown = false
var fight_started = false
var player_alive = true
var moving_left = true
var alive = true
var going_to_jump = false
var jumping = false
var air_attack = false
var cant_turn = false
var rng = RandomNumberGenerator.new()

onready var ray_wall = $RayWall
onready var ray_behind = $RayBehind
onready var ray_above = $RayAbove
onready var effect_dmg = $Effect_dmg

func _ready():
	current_hp = ceil(HEALTH * CharacterController.get_boss_hp_scale())
	$AnimatedSprite.play("Idle")
	if CharacterController.connect("fight_start", self, "_fight_start") != OK:
		print("Failed to connect to fight_start signal in Boss1 script")
	if CharacterController.connect("player_dead", self, "_player_dead") != OK:
		print("Failed to connect to player_dead signal in Boss1 script")

func _physics_process(_delta):
	#Check if attacking then check raycasts
	if is_on_floor():
		jumping = false
	if alive == true && fight_started == true && player_alive == true:
		if is_attacking == false && jumping == false:
			if attack_on_cooldown == false:
				choose_attack()
			elif ray_above.is_colliding():
				going_to_jump = true
				print("Ray_above collided with player!")
			elif ray_wall.is_colliding():
				swap_sides()
		if ray_behind.is_colliding() && turn_on_cooldown == false && cant_turn == false:
			swap_sides()
			turn_on_cooldown = true
			$Turn_cooldown.start()
		
		if is_attacking == false:
			if moving_left == true:
				velocity.x = -SPEED
			else:
				velocity.x = SPEED
			
			if going_to_jump == true:
				velocity.y = -JUMPFORCE
				velocity.x /= 2
				$AnimatedSprite.play("Jump")
				jumping = true
				going_to_jump = false
			elif jumping == false:
				$AnimatedSprite.play("Run")
		if air_attack == true:
			velocity = Vector2(0,0)
		else:
			velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
	elif !is_on_floor():
		#Makes sure boss dosent fall through floor when dying
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)


func swap_sides():
	if moving_left == true:
		moving_left = false
		$AnimatedSprite.set_flip_h(false)
		$AttackCollision.scale = Vector2(-1,1)
		ray_wall.scale = Vector2(-1,1)
		ray_behind.scale = Vector2(-1,1)
	else:
		moving_left = true
		$AnimatedSprite.set_flip_h(true)
		$AttackCollision.scale = Vector2(1,1)
		ray_wall.scale = Vector2(1,1)
		ray_behind.scale = Vector2(1,1)

func choose_attack():
	rng.randomize()
	var choice = rng.randi_range(1,3)
	match choice:
		1:
			$AnimatedSprite.play("Attack1")
			$AttackCollision/area/Attack_timer.start()
		2:
			$AnimatedSprite.play("Attack2")
			$AttackCollision/area2/Attack_timer2.start()
		3:
			$AnimatedSprite.play("Attack3")
			$AttackCollision/area3/Attack_timer3.start()
	is_attacking = true
	attack_on_cooldown = true

func _fight_start():
	fight_started = true
	attack_on_cooldown = true
	$Attack_cooldown.start()

func _player_dead():
	player_alive = false
	air_attack = false
	$AnimatedSprite.play("Idle")
	disable_all_hitboxes()

func boss_hit(dmg):
	current_hp -= dmg
	print(current_hp)
	if current_hp <=0:
		$AnimatedSprite.play("Death")
		CharacterController.boss_dead()
		alive = false
		$AttackCollision.queue_free()
	else:
		effect_dmg.interpolate_property($AnimatedSprite.get_material(),'shader_param/flash_modifier',1.0,0.0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		effect_dmg.start()
		if is_attacking == false && jumping == false:
			$AnimatedSprite.play("Hit")

func disable_all_hitboxes():
	$AttackCollision/area/Attack_timer.stop()
	$AttackCollision/body/Cooldown.queue_free()
	$Attack_cooldown.stop()
	$Turn_cooldown.stop()
	$AttackCollision/area.set_deferred('disabled', true)
	$AttackCollision/area2.set_deferred('disabled', true)
	$AttackCollision/area3.set_deferred('disabled', true)
	$AttackCollision/area4.set_deferred('disabled', true)
	$AttackCollision/body.set_deferred('disabled', true)

func _on_Attack_timer_timeout():
	$AttackCollision/area.set_deferred('disabled',false)
	cant_turn = true

func _on_Attack_timer2_timeout():
	$AttackCollision/area2.set_deferred('disabled',false)
	cant_turn = true


func _on_Attack_timer3_timeout():
	$AttackCollision/area3.set_deferred('disabled',false)
	cant_turn = true


func _on_Attack_timer4_timeout():
	$AttackCollision/area4.set_deferred('disabled',false)
	cant_turn = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack1":
		attack_done($AttackCollision/area)
	elif $AnimatedSprite.animation == "Attack2":
		attack_done($AttackCollision/area2)
	elif $AnimatedSprite.animation == "Attack3":
		attack_done($AttackCollision/area3)
	elif $AnimatedSprite.animation == "Attack4":
		attack_done($AttackCollision/area4)
		air_attack = false
		$AnimatedSprite.play("Fall")
	elif $AnimatedSprite.animation == "Jump":
		$AnimatedSprite.play("Attack4")
		$AttackCollision/area4/Attack_timer4.start()
		air_attack = true
	elif $AnimatedSprite.animation == "Fall" && is_on_floor():
		jumping = false
	elif $AnimatedSprite.animation == "Hit":
		$AnimatedSprite.play("Run")

func attack_done(input_area):
	print("disable area " + str(input_area))
	input_area.set_deferred('disabled', true)
	is_attacking = false
	$Attack_cooldown.start()
	$AnimatedSprite.play("Idle")
	cant_turn = false

func _on_AttackCollision_body_entered(_body):
	CharacterController.player_hit()
	$AttackCollision/area.set_deferred('disabled', true)
	$AttackCollision/area2.set_deferred('disabled', true)
	$AttackCollision/area3.set_deferred('disabled', true)
	$AttackCollision/area4.set_deferred('disabled', true)
	$AttackCollision/body.set_deferred('disabled', true)
	$AttackCollision/body/Cooldown.start()

func _on_damage_cooldown_timeout():
	$AttackCollision/body.set_deferred('disabled', false)

func _on_Attack_cooldown_timeout():
	attack_on_cooldown = false

func _on_Turn_cooldown_timeout():
	turn_on_cooldown = false

func get_gold_cap():
	return GOLD_CAP
