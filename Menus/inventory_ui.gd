extends Control
@onready var left_item_icon: TextureRect = $"CanvasLayer/Inventory/Left Item/MarginContainer/Panel/MarginContainer/Left Item Icon"
@onready var center_item_icon: TextureRect = $"CanvasLayer/Inventory/Center Item/Panel/MarginContainer/Center Item Icon"
@onready var right_item_icon: TextureRect = $"CanvasLayer/Inventory/Right Item/MarginContainer/Panel/MarginContainer/Right Item Icon"

@export var imageMap :Dictionary[GameManager.inventory_slot_type, Texture2D]
@export var colorMap :Dictionary[GameManager.color_enum, Color]

func _ready() -> void:
	game_manager.held_changed.connect(update_icons)
	
func update_icons(new_index:int):
	
	# size one means only our bare hands, don't show anything
	if(game_manager.collected_items.size() == 1):
		left_item_icon.visible = false
		center_item_icon.visible = false
		right_item_icon.visible = false
	#one item, hide second slot
	elif game_manager.collected_items.size() == 2:
		# TODO FIONA: rather than always showing on right, have 
		left_item_icon.visible = false
		_set_icon(new_index, center_item_icon)
		_set_icon((new_index +1 )%2, right_item_icon)
	# 2 or more items, show one above and one below and current item 
	elif game_manager.collected_items.size() >=3:
		var size : int = game_manager.collected_items.size()
		_set_icon(((new_index-1)+size)%size, left_item_icon)
		#TODO FIONA: currently I'm setting the color on the center icon exactly the same as the other two. I'll let you figure out how to highlight
		_set_icon(new_index, center_item_icon)
		_set_icon((new_index+1)%size, right_item_icon)
	elif game_manager.collected_items.size() <=0:
		push_error("ERROR: you somehow have an inventory less than or equal to zero. did you somehow throw away your hand?")
		#this shouldn't happen
		
	
func _set_icon(new_index: int, icon: TextureRect):
	var item : game_manager.InventorySlot = game_manager.collected_items[new_index]
	icon.texture = imageMap.get(item._item )
	icon.modulate = colorMap.get(item._color) #error
	
