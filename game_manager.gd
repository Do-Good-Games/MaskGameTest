class_name GameManager extends Node
var playerx
var playery

enum lamp_color_enum{
	NONE = 0, RED =1, GREEN=2, BLUE=3
}
#todo: add 
enum inventory_slot_type{
	NONE = 0, GRENADE=1, LAMP=2
}

signal held_changed

var current_held : lamp_color_enum

#var collected_items: Dictionary[inventory_slot_type,]

var collected_lamps: Dictionary[lamp_color_enum, bool]

func _input(event:InputEvent):
	
	if event.is_action_pressed('inventory_slot_1'):
		held_changed.emit()
		current_held = lamp_color_enum.RED
	if event.is_action_pressed('inventory_slot_2'):
		held_changed.emit()
		current_held = lamp_color_enum.GREEN
	if event.is_action_pressed('inventory_slot_3'):
		held_changed.emit()
		current_held = lamp_color_enum.BLUE
	if event.is_action_pressed('inventory_slot_4'):
		held_changed.emit()
		current_held = lamp_color_enum.NONE
	
	if event.is_action_pressed("inventory_left"):
		held_changed.emit()
		current_held= (current_held - 1 +4 )% 4
		
	if event.is_action_pressed("inventory_right"):
		held_changed.emit()
		current_held =( current_held + 1) % 4

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
