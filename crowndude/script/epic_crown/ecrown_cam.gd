extends Camera2D

onready var shake_timer = $Timer
onready var shake_tween = $Tween

var shake_power = 0
var default_offset = offset

func _ready():
	set_process(false)
	pass

func _process(delta):
	offset = Vector2(rand_range(-shake_power,shake_power),rand_range(-shake_power,shake_power)) + default_offset
	pass

func _shake(new_shake,shake_time = 0.4,shake_limit=100):
	shake_power += new_shake
	if shake_power > shake_limit:
		shake_power = shake_limit
	
	shake_timer.wait_time = shake_time
	
	shake_tween.stop_all()
	set_process(true)
	shake_timer.start()
	print("shaked")
	
	pass


func _on_Timer_timeout():
	shake_power = 0
	set_process(false)
	
	shake_tween.interpolate_property(self,"offset",offset,default_offset,0.1, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	shake_tween.start()

