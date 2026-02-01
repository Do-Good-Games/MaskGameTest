extends Control
@onready var left_item_icon: TextureRect = $"CanvasLayer/Inventory/Left Item/MarginContainer/Panel/MarginContainer/Left Item Icon"
@onready var center_item_icon: TextureRect = $"CanvasLayer/Inventory/Center Item/Panel/MarginContainer/Center Item Icon"
@onready var right_item_icon: TextureRect = $"CanvasLayer/Inventory/Right Item/MarginContainer/Panel/MarginContainer/Right Item Icon"

func _ready() -> void:
	game_manager.held_changed.connect(update_icons)
	
func update_icons():
	# left item:
	#figure out what is to the 'left' of currently held item
	
	var current_item = game_manager.current_held
	center_item_icon
	#if game_manager.current_held 
	
	
func get_image_type(item_type :game_manager.inve)
