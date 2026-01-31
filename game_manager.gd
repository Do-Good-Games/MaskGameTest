class_name GameManager extends Node
var playerx
var playery

enum lamp_color_enum{
	RED, GREEN, BLUE
}
var collected_lamps: Dictionary[lamp_color_enum, bool]

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
