extends CanvasLayer

signal transition_done
onready var effect_in = $Effect_in
onready var effect_out = $Effect_out


func _ready():
	fade_out()

func fade_out():
	$ColorRect.visible = true
	effect_out.interpolate_property($ColorRect,"color",Color("000000"),Color("00000000"),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	effect_out.start()

func _on_Effect_out_tween_completed(_object, _key):
	$ColorRect.visible = false

func fade_in():
	$ColorRect.visible = true
	effect_in.interpolate_property($ColorRect,"color",Color("00000000"),Color("000000"),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	effect_in.start()

func _on_Effect_in_tween_completed(_object, _key):
	emit_signal("transition_done")
