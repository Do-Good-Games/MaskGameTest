extends Control

@onready var exit_button : Button = $"CanvasLayer/Button Container/Exit Button"

func _ready() -> void:
	exit_button.pressed.connect(_exit_to_MM)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _exit_to_MM() -> void:
	print("Exiting to MM")
	get_tree().change_scene_to_file("res://Menus/mainMenu.tscn")	
