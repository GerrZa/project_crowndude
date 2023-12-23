extends Area2D

var is_collect : bool = false
var is_attacker = false

func _physics_process(delta):
	if !get_overlapping_bodies().empty() and !is_collect:
		var body_overlap = get_overlapping_bodies()
		
		randomize()
		body_overlap.shuffle()
			
		if !body_overlap[0].extrajump_:
			is_collect = true
			body_overlap[0].extrajump()
			queue_free()
	pass
