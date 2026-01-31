class_name GameManager extends Node
var playerx
var playery

enum lamp_color_enum{
	NONE, RED, GREEN, BLUE
}


var collected_lamps: Dictionary[lamp_color_enum, bool]

func get_input():
	#
	#if Input.is_action_pressed('inventory_slot_1'):
		#print("inventory 1")
	#if Input.is_action_pressed('inventory_slot_2'):
		#input.x -= 1
	#if Input.is_action_pressed('inventory_slot_3'):
		#input.y += 1
	#if Input.is_action_pressed('inventory_slot_4'):
		#input.y -= 1
	#if Input.is_action_pressed("right_click"):
		#throwSpeed += 1
	#if Input.is_action_pressed("right_click"):
		#throwSpeed += 1
		#
	pass

func collect_lamp(color: lamp_color_enum):
	if collected_lamps.has(color):
		push_warning("WARNING: trying to ADD a lamp when the player already has that color. should this even be possible in game? or did something break w the code")
	print(" YOU GOT THE  NEW LAMP")
	collected_lamps[color] = true
	#collected_lamps.

func remove_lamp(color: lamp_color_enum):
	if not collected_lamps[color]:
		push_warning("WARNING: trying to REMOVE a lamp which the player doesn't already have that color. should this even be possible?")
	collected_lamps[color] = false

#make   for the lanters the players hold
