extends Node

#global var
var player_exist = [true,false,false,false]
var player_point = [0,0,0,0]

#epic crown global assets
var ec_player0_spr = preload("res://sprite/epic_crown/player/player1_tank_sheet.png")
var ec_player1_spr = preload("res://sprite/epic_crown/player/player2_tank_sheet.png")
var ec_player2_spr = preload("res://sprite/epic_crown/player/player3_tank_sheet.png")
var ec_player3_spr = preload("res://sprite/epic_crown/player/player4_tank_sheet.png")

func add_score(score : Array):
	for i in player_point.size():
		player_point[i] =+ score[i]
