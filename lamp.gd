extends Node2D

@export var color : game_manager.color_enum = GameManager.color_enum.RED
@onready var bobby_collectable: BobbyCollectible = $BobbyCollectable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var throwable: CharacterBody2D = $Throwable

func _ready():
	bobby_collectable.collected.connect(receive_collected)
	match color:
		GameManager.color_enum.RED:
			sprite_2d.modulate = Color.RED
		GameManager.color_enum.GREEN:
			sprite_2d.modulate = Color.GREEN
		GameManager.color_enum.BLUE:
			sprite_2d.modulate = Color.BLUE

func receive_collected():
	print("lamp received collected signal")
	game_manager.collect_item(game_manager.inventory_slot_type.LAMP, color)
	deactivate()

func deactivate():
	bobby_collectable.deactivate()
	sprite_2d.visible = false
	#self.disabled = true

func reactivate():
	#self.disabled = false
	throwable.reactivate()
	bobby_collectable.reactivate()
	sprite_2d.visible = true
