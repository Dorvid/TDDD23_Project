extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	#Connects to boss_dead signal and calls _boss_dead when emitted
	CharacterController.connect("boss_dead", self, "_boss_dead")
	pass # Replace with function body.


func _on_Player_enemy_hit():
	$Boss1.boss_hit(CharacterController.get_player_dmg())


func _boss_dead():
	MusicController.crowd_play()
	$Background.play("cheering")
	$Leave_arena/Leavebox.set_deferred('disabled', false)
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', true)


func _on_Start_fight_body_entered(body):
	$Ground_and_walls/Entrance_door/Door.set_deferred('disabled', false)
	$Start_fight/Start_collision.set_deferred('disabled', true)
	CharacterController.emit_fight_start()
