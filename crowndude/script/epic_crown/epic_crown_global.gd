extends Node

var player_index = []
onready var cam_ = get_node("Camerawiht_shake")
onready var player0 = get_node("Player0")
onready var player1 = get_node("Player1")
onready var player2 = get_node("Player2")
onready var player3 = get_node("Player3")
var player_ingame_point = [0,0,0,0]

export var powup_time_range1 : int
export var powup_time_range2 : int

var extrajump_powerup = preload("res://scene/inlevel_scene/epic_crown/powerup/extrajump_pow.tscn")

signal is_scene_ready
signal extrajump_spawned

func _ready():
	var count = 0
	var count_r = 0
	var count_p = 0
	
	for i in Global.player_exist:
		if i:
			player_index.append(count)
			
			
		count += 1
	
	for i in $CanvasLayer/ControlMain/Control.get_children():
		i.visible = Global.player_exist[count_r]
		
		count_r += 1
		
		if count_r >= 3:
			break
		
		print(count_r)
	
	for i in $CanvasLayer/ControlMain/Control2.get_children():
		i.visible = Global.player_exist[count_p]
		count_p += 1
	
	randomize()
	player_index.shuffle()
	print(player_index)
	
	var powup_waittime = rand_range(5,10)
	$powerup_timer.wait_time = int(powup_waittime)
	print($powerup_timer.wait_time)
	$powerup_timer.start()
	
	emit_signal("is_scene_ready")

func call_cam_shake():
	cam_._shake(5,0.2,5)

func _physics_process(delta):
	$CanvasLayer/ControlMain/Control/p0.text = "score:" + String(player_ingame_point[0])
	$CanvasLayer/ControlMain/Control/p1.text = "score:" + String(player_ingame_point[1])
	$CanvasLayer/ControlMain/Control/p2.text = "score:" + String(player_ingame_point[2])
	$CanvasLayer/ControlMain/Control/p3.text = "score:" + String(player_ingame_point[3])
	
	$CanvasLayer/ControlMain/Control/Label.text = "%d:%02d" % [floor($game_end_timer.time_left / 60), int($game_end_timer.time_left) % 60]
	


func _on_game_end_timer_timeout():
	Global.add_score(player_ingame_point)
	get_tree().paused = true
	print(Global.player_point)


func _on_powerup_timer_timeout():
	$powerup_timer.wait_time = rand_range(powup_time_range1,powup_time_range2)
	
	var extrajump_instance = extrajump_powerup.instance()
	var powup_pos = $powerup_pos.get_children()
	
	randomize()
	powup_pos.shuffle()
	
	extrajump_instance.position = powup_pos[0].global_position
	
	get_tree().current_scene.add_child(extrajump_instance)
	
