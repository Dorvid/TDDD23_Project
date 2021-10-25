extends KinematicBody2D



onready var effect_dmg = $Effect_dmg

func _ready():
	pass

func dummy_hit():
	$AnimatedSprite.play("damage")
	effect_dmg.interpolate_property($AnimatedSprite.get_material(),'shader_param/flash_modifier',1.0,0.0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	effect_dmg.start()


func _on_Effect_dmg_tween_completed(_object, _key):
	$AnimatedSprite.play("default")
