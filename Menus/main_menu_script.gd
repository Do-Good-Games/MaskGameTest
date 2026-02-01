extends Control

@onready var start_button : Button = $"CanvasLayer/Button Container/Start Button"
#@onready var settings_button : Button = $"MAIN MENU BUTTONS/MarginContainer2/Button"
@onready var credits_button : Button = $"CanvasLayer/Button Container/Credits Button"

@export var first_level: Level

func _ready() -> void:
	start_button.pressed.connect(_start)
	credits_button.pressed.connect(_credits)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _start() -> void:
	print("Start Game")
	
	#CHANGE THIS TO THE REAL LEVEL 1 OR WHATEVER
	get_tree().change_scene_to_file("res://Levels/UIHookupsTestLevel.tscn")
	
func _credits() -> void:
	print("Opening Credits Menu")
	
	get_tree().change_scene_to_file("res://Menus/creditsMenu.tscn")
	
