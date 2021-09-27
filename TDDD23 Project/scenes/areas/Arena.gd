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
