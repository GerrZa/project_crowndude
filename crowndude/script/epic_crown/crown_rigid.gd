extends RigidBody2D

export var impulse_onready : bool = true
var can_collect = false
var is_attacker = false

func _ready():
	print("crown is spawned")
	
	if impulse_onready:
		can_collect = false
		print("impulsed")
		apply_central_impulse(Vector2(rand_range(-26,26),rand_range(-150,-180)))
		
		yield(get_tree().create_timer(0.5),"timeout")
		can_collect = true
	else:
		can_collect = true
	

func _physics_process(delta):
	if !$Area2D.get_overlapping_bodies().empty():
		var overlap_body = $Area2D.get_overlapping_bodies()
		var rand_int = randi() %100
		if rand_int > 50:
			overlap_body.shuffle()
		
		if can_collect == true and overlap_body[0].is_in_group("player") and overlap_body[0].can_crowned:
			overlap_body[0].get_crown()
			can_collect = false
			queue_free()
	


