extends Node

var default_exist = [true,false,false,false]
var can_start = false

func _input(event):
	if Input.is_action_just_pressed("ui_a1"):
		Global.player_exist[1] = true
	elif Input.is_action_just_pressed("ui_a2"):
		Global.player_exist[2] = true
	elif Input.is_action_just_pressed("ui_a3"):
		Global.player_exist[3] = true
	
	if Input.is_action_just_pressed("ui_b1"):
		Global.player_exist[1] = false
	elif Input.is_action_just_pressed("ui_b2"):
		Global.player_exist[2] = false
	elif Input.is_action_just_pressed("ui_b3"):
		Global.player_exist[3] = false
	
	if Input.is_action_just_pressed("ui_x0"):
		Global.player_exist = default_exist
	
	if Input.is_action_just_pressed("host_start"):
		get_tree().change_scene("res://scene/level/epic_crown.tscn")

func _physics_process(delta):
	$CanvasLayer/Control/player_exist_fg/p0.visible = Global.player_exist[0]
	$CanvasLayer/Control/player_exist_fg/p1.visible = Global.player_exist[1]
	$CanvasLayer/Control/player_exist_fg/p2.visible = Global.player_exist[2]
	$CanvasLayer/Control/player_exist_fg/p3.visible = Global.player_exist[3]
	
	if Global.player_exist[1] or Global.player_exist[2] or Global.player_exist[3]:
		 can_start = true
	elif Global.player_exist[1] == false and Global.player_exist[2] == false and Global.player_exist[3] == false:
		can_start = false
