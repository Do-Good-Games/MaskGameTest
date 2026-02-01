extends Node2D

@export var color : game_manager.lamp_color_enum = GameManager.lamp_color_enum.RED
@onready var bobby_collectable: BobbyCollectible = $BobbyCollectable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	bobby_collectable.collected.connect(func(): 
		print("lamp received collected signal")
		game_manager.collect_lamp(color)
		)
	match color:
		GameManager.lamp_color_enum.RED:
			sprite_2d.modulate = Color.RED
		GameManager.lamp_color_enum.GREEN:
			sprite_2d.modulate = Color.GREEN
		GameManager.lamp_color_enum.BLUE:
			sprite_2d.modulate = Color.BLUE
	
