class_name GameManager extends Node
var playerx
var playery


enum color_enum{
	NONE = 0, RED =1, GREEN=2, BLUE=3
}
#todo: add 
enum inventory_slot_type{
	NONE = 0, GRENADE=1, LAMP=2
}
class InventorySlot:
	var _item : inventory_slot_type = inventory_slot_type.NONE
	var _color : color_enum = color_enum.NONE
	var _idx: int = 0
	func _init(item:inventory_slot_type, color:color_enum, idx: int):
		_item = item
		_color = color
		_idx = idx

signal held_changed(new_index : int)

var current_held : InventorySlot = InventorySlot.new(inventory_slot_type.NONE, color_enum.NONE, 0)

var collected_items: Array[InventorySlot]

func _input(event:InputEvent):
	
	#TODO: give the player one keybind that will ALWAYS deactivate their current item (probs `)
	
	var new_idx :int
	if event.is_action_pressed("inventory_left"):
		new_idx = (current_held._idx - 1 +collected_items.size() )% collected_items.size()
		
	if event.is_action_pressed("inventory_right"):
		new_idx=( current_held._idx + collected_items.size()) % collected_items.size()
	set_held(new_idx)

func set_held(idx : int ):
	current_held = collected_items[idx]
	held_changed.emit(current_held._idx)

func collect_item(item_type: inventory_slot_type, color: color_enum):
	
	var new_slot : InventorySlot = InventorySlot.new(item_type, color, collected_items.size() +1)
	#new_slot._init(item_type, color)
	collected_items.push_back(new_slot)
	set_held(new_slot._idx)
	print(" YOU GOT THE  NEW LAMP")
	#collected_lamps.

func remove_current_held():
	_remove_item(current_held._idx)
	set_held(0)

func _remove_item(idx: int):
	collected_items.remove_at(idx)
	

#make   for the lanters the players hold
