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
var done_with_gravity = false
var renown_hp_scale = 1.0

onready var ray_wall = $RayWall
onready var ray_char = $RayChar
onready var ray_behind = $RayBehind
onready var ray_above = $RayAbove
onready var effect_dmg = $Effect_dmg

func _ready():
	#Increases hp depending on renown
	if CharacterController.get_chosen_renown() == 10:
		renown_hp_scale = 3.0
	elif CharacterController.get_chosen_renown() >= 2:
		renown_hp_scale = 1.5
	current_hp = ceil(HEALTH * CharacterController.get_boss_hp_scale() * renown_hp_scale)
	#If renown 9 or higher boss is faster
	if CharacterController.get_chosen_renown() >= 9:
		SPEED *= 1.5
	#If renown 5 or higher drop less gold
	if CharacterController.get_chosen_renown() >= 5:
		GOLD_CAP *= 0.8
	#If renown 4 Jump higher
	if CharacterController.get_chosen_renown() >= 4:
		JUMPFORCE += 256
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
			if ray_char.is_colliding() && attack_on_cooldown == false:
				$AnimatedSprite.play("Attack")
				set_other_hitbox()
				$AttackCollision/area/Attack_timer.start()
				is_attacking = true
				attack_on_cooldown = true
				#print("Ray_char collided with player!")
			elif ray_above.is_colliding():
				going_to_jump = true
				#print("Ray_above collided with player!")
			elif ray_wall.is_colliding():
				swap_sides()
			elif ray_behind.is_colliding() && turn_on_cooldown == false:
				swap_sides()
				attack_on_cooldown = true
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
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
	elif !is_on_floor():
		#Makes sure boss dosent fall through floor when dying
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)


func set_other_hitbox():
	if $hitboxleft.is_disabled():
		$hitboxleft.set_deferred('disabled',false)
		$hitboxright.set_deferred('disabled',true)
	else:
		$hitboxleft.set_deferred('disabled',true)
		$hitboxright.set_deferred('disabled',false)

func swap_sides():
	if moving_left == true:
		moving_left = false
		$AnimatedSprite.set_flip_h(false)
		$AttackCollision.scale = Vector2(-1,1)
		ray_wall.scale = Vector2(-1,1)
		ray_char.scale = Vector2(-1,1)
		ray_behind.scale = Vector2(-1,1)
		set_other_hitbox()
	else:
		moving_left = true
		$AnimatedSprite.set_flip_h(true)
		$AttackCollision.scale = Vector2(1,1)
		ray_wall.scale = Vector2(1,1)
		ray_char.scale = Vector2(1,1)
		ray_behind.scale = Vector2(1,1)
		set_other_hitbox()

func _fight_start():
	fight_started = true

func _player_dead():
	player_alive = false
	$AnimatedSprite.play("Idle")
	disable_all_hitboxes()

func boss_hit(dmg):
	current_hp -= dmg
	print(current_hp)
	if current_hp <=0:
		$AnimatedSprite.play("Death")
		#$hitboxleft.set_deferred('disabled',true)
		#$hitboxright.set_deferred('disabled',true)
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
	$AttackCollision/body.set_deferred('disabled', true)

func _on_Attack_timer_timeout():
	$AttackCollision/area.set_deferred('disabled',false)
	MusicController.boss_slow()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		set_other_hitbox()
		$AttackCollision/area.set_deferred('disabled', true)
		is_attacking = false
		$Attack_cooldown.start()
		$AnimatedSprite.play("Idle")
	elif $AnimatedSprite.animation == "Jump":
		$AnimatedSprite.play("Fall")
	elif $AnimatedSprite.animation == "Fall" && is_on_floor():
		jumping = false
	elif $AnimatedSprite.animation == "Hit":
		$AnimatedSprite.play("Run")

func _on_AttackCollision_body_entered(_body):
	CharacterController.player_hit()
	$AttackCollision/area.set_deferred('disabled', true)
	$AttackCollision/body.set_deferred('disabled', true)
	$AttackCollision/body/Cooldown.start()

func _on_damage_cooldown_timeout():
	$AttackCollision/body.set_deferred('disabled', false)


func _on_Attack_cooldown_timeout():
	attack_on_cooldown = false


func _on_Turn_cooldown_timeout():
	turn_on_cooldown = false
	$Attack_cooldown.start()

func get_gold_cap():
	return GOLD_CAP
