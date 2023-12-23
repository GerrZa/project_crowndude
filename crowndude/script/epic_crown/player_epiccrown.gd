extends KinematicBody2D

onready var ec_singleton = get_parent()
onready var ground_check = $ground_check
onready var tank_animtor = $tank_spr/tank_animator

var crown_rigid = preload("res://scene/inlevel_scene/epic_crown/crown_rigid.tscn")

var powup_fx = preload("res://sprite/epic_crown/player/sfx/powup_sfx.wav")
var hit_fx = preload("res://sprite/epic_crown/player/sfx/hit_sfx.wav")
var swing_fx = preload("res://sprite/epic_crown/player/sfx/headswing_sfx.wav")
var crown_fx = preload("res://sprite/epic_crown/player/sfx/crown_sfx.wav")

export(int) var p_index
var ingame_index : int

var motion = Vector2.ZERO
var knocking_vec = Vector2(-1,0)
var x_input : float = 0
var gravity = 600
var player_speed : float = 130
var jump_force = 210
var max_jump = 2
var current_jump = 0
var increased_point = 5
var is_ground = false
var direction = 1
var is_knocking = false
var attacking = false
var is_crowned = false
var is_attacker = true
var can_attack = true
var powerup_time = 20
var can_crowned = true

var extrajump_ = false




func _ready():
	#wait for scene to load
	yield(ec_singleton,"is_scene_ready")
	#random ingame index for random start position
	if ec_singleton.player_index.size() >= p_index + 1:
		ingame_index = ec_singleton.player_index[p_index]
	else:
		queue_free()
	
	#make each player different
	if ingame_index == 1:
		$player_spr.texture = Global.ec_player1_spr
	elif ingame_index == 2:
		$player_spr.texture = Global.ec_player2_spr
	elif ingame_index == 3:
		$player_spr.texture = Global.ec_player3_spr
		
	
	#play idle anim
	$player_spr/player_animator.play("idle")
	$crown_spr.visible = false
	
	add_to_group("player")

func _physics_process(delta):
	#basic movement
	x_input = sign(Input.get_action_strength("ui_right" + String(ingame_index)) - Input.get_action_strength("ui_left" + String(ingame_index)))
	
	
	if x_input > 0:
		global_transform.x.x = 1
		knocking_vec = Vector2(-1,0)
	elif x_input < 0:
		global_transform.x.x = -1
		knocking_vec = Vector2(1,0)
	
	
	
	motion.y += gravity * delta
	if is_knocking == false:
		motion.x = x_input * player_speed
	
	motion = move_and_slide(motion)
	
	#movement function
	check_ground()
	jump()
	jump_anim()
	
	#tank animation
	tank_anim()
	#attack function
	if Input.is_action_just_pressed("ui_x" + String(ingame_index)) and attacking == false and can_attack:
		attack()
	

func check_ground():
	if !ground_check.get_overlapping_bodies().empty():
		is_ground = true
	else:
		is_ground = false

func take_damage(object_vector : Vector2,knock_time,knock_power):
	can_attack = false
	can_crowned = false
	
	if is_crowned:
		var crown_inst = crown_rigid.instance()
		crown_inst.position = global_position
		get_tree().current_scene.add_child(crown_inst)
	
	
	is_crowned = false
	$crown_spr.visible = false
	
	flash()
	
	$AudioStreamPlayer.stream = hit_fx
	$AudioStreamPlayer.play()
	
	#take coordinate from attacker and victim
	var normalized_vec : Vector2 = object_vector
	normalized_vec.y += 1
	normalized_vec *= Vector2(-1,-1)
	
	motion = normalized_vec * knock_power
	
	#start knockback
	is_knocking = true
	yield(get_tree().create_timer(knock_time),"timeout")
	is_knocking = false
	can_attack = true
	can_crowned = true
	print(knocking_vec)
	
	


func jump():
	if Input.is_action_just_pressed("ui_a" + String(ingame_index)) and is_knocking == false:
		if current_jump < max_jump -1:
			motion.y = -jump_force
			current_jump += 1
		
	if is_ground:
		current_jump = 0

func attack():
	if is_knocking == false:
		attacking = true
		$player_spr/player_animator.play("attack")
		yield(get_tree().create_timer(0.4),"timeout")
		
		$attack_check.monitoring = true
		$attack_check.monitorable = true
		
		$AudioStreamPlayer.stream = swing_fx
		$AudioStreamPlayer.play()
		
		yield(get_tree().create_timer(0.2),"timeout")
		$attack_check.monitoring = false
		$attack_check.monitorable = false
		
		yield(get_tree().create_timer(0.1),"timeout")
		attacking = false
		$player_spr/player_animator.play("idle")
	

func _on_hitbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.owner.is_attacker and area.owner.name != "Player" + String(p_index):
		print(area.owner.name)
		take_damage(area.owner.knocking_vec,0.3,200)
		owner.call_cam_shake()

func jump_anim():
	if !is_ground:
		$player_spr.offset = Vector2(-3,1)
	else:
		$player_spr.offset = Vector2.ZERO

func tank_anim():
	if is_ground:
		if x_input != 0:
			tank_animtor.play("running")
		else:
			tank_animtor.play("idle")
	else:
		tank_animtor.play("jump")

func get_crown():
	if !is_knocking and can_crowned:
		is_crowned = true
		$crown_spr.visible = true
		can_attack = false
		
		$AudioStreamPlayer.stream = crown_fx
		$AudioStreamPlayer.play()
		
		print("a")
		pass

func flash():
	$tank_spr.material.set_shader_param("flash_modi",1)
	$player_spr.material.set_shader_param("flash_modi",1)
	$flash_timer.start()
	print("start_flash")
func _on_flash_timer_timeout():
	$tank_spr.material.set_shader_param("flash_modi",0)
	$player_spr.material.set_shader_param("flash_modi",0)
	print("stop_flash")


func _on_point_timer_timeout():
	if is_crowned:
		owner.player_ingame_point[ingame_index] += 5

func extrajump():
	max_jump = 3
	extrajump_ = true
	
	$AudioStreamPlayer.stream = powup_fx
	$AudioStreamPlayer.play()
	
	$powerup_timer.start(powerup_time)
	yield($powerup_timer,"timeout")
	print("is_stop")
	extrajump_ = false
	max_jump = 2
