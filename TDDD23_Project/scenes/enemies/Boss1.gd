extends KinematicBody2D

var velocity = Vector2()
export (int) var SPEED
export (int) var HEALTH
export (int) var GOLD_CAP
var current_hp
var is_attacking = false
var attack_on_cooldown = false
var fight_started = false
var player_alive = true
var moving_left = true
var alive = true
var renown_hp_scale = 1.0
var can_attack_upwards = false

onready var ray_wall = $RayWall
onready var ray_char = $RayChar
onready var ray_behind = $RayBehind
onready var ray_up = $RayUp
onready var effect_dmg = $Effect_dmg

# Called when the node enters the scene tree for the first time.
func _ready():
	#Increases hp depending on renown
	if CharacterController.get_chosen_renown() == 10:
		renown_hp_scale = 3.0
	elif CharacterController.get_chosen_renown() >= 1:
		renown_hp_scale = 1.5
	current_hp = ceil(HEALTH * CharacterController.get_boss_hp_scale() * renown_hp_scale)
	#If renown 9 or higher boss is faster
	if CharacterController.get_chosen_renown() >= 9:
		SPEED *= 1.5
	#If renown 5 or higher drop less gold
	if CharacterController.get_chosen_renown() >= 5:
		GOLD_CAP *= 0.8
	if CharacterController.get_chosen_renown() >= 4:
		can_attack_upwards = true
	$AnimatedSprite.play("idle")
	if CharacterController.connect("fight_start", self, "_fight_start") != OK:
		print("Failed to connect to fight_start signal in Boss1 script")
	if CharacterController.connect("player_dead", self, "_player_dead") != OK:
		print("Failed to connect to player_dead signal in Boss1 script")

func _physics_process(_delta):
	#Check if attacking then check raycasts
	if alive == true && fight_started == true && player_alive == true:
		if is_attacking == false:
			if ray_char.is_colliding() && attack_on_cooldown == false:
				$AnimatedSprite.play("attack")
				$AttackCollision/start.set_deferred('disabled', false)
				$SwingTimer.start()
				is_attacking = true
				MusicController.play_grunt1()
			elif can_attack_upwards && ray_up.is_colliding():
				$AnimatedSprite.play("upwards")
				$UpwardTimer.start()
				is_attacking = true
				MusicController.play_grunt1()
			elif ray_wall.is_colliding():
				swap_sides()
			elif ray_behind.is_colliding():
				$TurnTimer.start()
		
		#Check if still not attacking then move (or not if attacking)
		if is_attacking == false:
			if moving_left == true:
				velocity.x = -SPEED
				$AnimatedSprite.play("walk")
			else:
				velocity.x = SPEED
				$AnimatedSprite.play("walk")
		else:
			velocity.x = 0
		velocity.y = 100
		velocity = move_and_slide(velocity,Vector2.UP)
		
		velocity.x = lerp(velocity.x,0,0.2)

#Turns the boss around
func swap_sides():
	if moving_left == true:
		moving_left = false
		$AnimatedSprite.set_flip_h(true)
		$AttackCollision.scale = Vector2(-1,1)
		ray_wall.scale = Vector2(-1,1)
		ray_char.scale = Vector2(-1,1)
		ray_behind.scale = Vector2(-1,1)
	else:
		moving_left = true
		$AnimatedSprite.set_flip_h(false)
		$AttackCollision.scale = Vector2(1,1)
		ray_wall.scale = Vector2(1,1)
		ray_char.scale = Vector2(1,1)
		ray_behind.scale = Vector2(1,1)


func _on_SwingTimer_timeout():
	$AttackCollision/start.set_deferred('disabled', true)
	$AttackCollision/end.set_deferred('disabled', false)
	MusicController.boss_fast()

func _on_UpwardTimer_timeout():
	$AttackCollision/up.set_deferred('disabled',false)
	MusicController.boss_fast()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		$AttackCollision/end.set_deferred('disabled', true)
		attack_done()
	elif $AnimatedSprite.animation == "upwards":
		$AttackCollision/up.set_deferred('disabled',true)
		attack_done()

func attack_done():
	attack_on_cooldown = true
	is_attacking = false
	$AttackCooldownTimer.start()
	$AnimatedSprite.play("idle")

func _on_AttackCooldownTimer_timeout():
	attack_on_cooldown = false

func _on_TurnTimer_timeout():
	swap_sides()


func _on_AttackCollision_body_entered(_body):
	CharacterController.player_hit()

func boss_hit(dmg):
	current_hp -= dmg
	print(current_hp)
	if current_hp <=0:
		$AttackCollision.queue_free()
		$SwingTimer.queue_free()
		$UpwardTimer.queue_free()
		$TurnTimer.queue_free()
		$AnimatedSprite.play("death")
		$hitbox.set_deferred('disabled',true)
		CharacterController.boss_dead()
		alive = false
	else:
		effect_dmg.interpolate_property($AnimatedSprite.get_material(),'shader_param/flash_modifier',1.0,0.0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		effect_dmg.start()

func _fight_start():
	fight_started = true

func _player_dead():
	player_alive = false
	$AnimatedSprite.play("idle")

func get_gold_cap():
	return GOLD_CAP
